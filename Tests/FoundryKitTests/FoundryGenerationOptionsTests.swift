import Testing
@testable import FoundryKit

@Suite("FoundryGenerationOptions Tests")
struct FoundryGenerationOptionsTests {
    
    @Test("Initialization with all parameters")
    func testCompleteInitialization() {
        let options = FoundryGenerationOptions(
            sampling: .random(top: 50, seed: 12345),
            temperature: 0.8,
            frequencyPenalty: 0.3,
            presencePenalty: 0.2,
            maxTokens: 200,
            topP: 0.95,
            useGuidedGeneration: true
        )
        
        #expect(options.temperature == 0.8)
        #expect(options.topP == 0.95)
        #expect(options.maxTokens == 200)
        #expect(options.presencePenalty == 0.2)
        #expect(options.frequencyPenalty == 0.3)
        #expect(options.useGuidedGeneration == true)
        
        // Check sampling mode
        if let sampling = options.sampling {
            // Note: We can't directly access the internal mode enum
            // In real tests, we'd verify behavior through the public API
            #expect(sampling == .random(top: 50, seed: 12345))
        }
    }
    
    @Test("Initialization with minimal parameters")
    func testMinimalInitialization() {
        let options = FoundryGenerationOptions(temperature: 0.5)
        
        #expect(options.temperature == 0.5)
        #expect(options.sampling == nil)
        #expect(options.topP == nil)
        #expect(options.maxTokens == nil)
        #expect(options.presencePenalty == nil)
        #expect(options.frequencyPenalty == nil)
        #expect(options.useGuidedGeneration == false)
    }
    
    @Test("Default initialization")
    func testDefaultInitialization() {
        let options = FoundryGenerationOptions()
        
        #expect(options.sampling == nil)
        #expect(options.temperature == nil)
        #expect(options.topP == nil)
        #expect(options.maxTokens == nil)
        #expect(options.presencePenalty == nil)
        #expect(options.frequencyPenalty == nil)
        #expect(options.useGuidedGeneration == false)
    }
    
    @Test("Temperature validation")
    func testTemperatureValidation() {
        // Valid temperatures
        let validTemp1 = FoundryGenerationOptions(temperature: 0.0)
        let validTemp2 = FoundryGenerationOptions(temperature: 2.0)
        let validTemp3 = FoundryGenerationOptions(temperature: 0.5)
        
        #expect(validTemp1.temperature == 0.0)
        #expect(validTemp2.temperature == 2.0)
        #expect(validTemp3.temperature == 0.5)
        
        // Note: Temperature should be between 0 and 2 inclusive
    }
    
    @Test("Sampling modes")
    func testSamplingModes() {
        // Test greedy sampling
        let greedyOptions = FoundryGenerationOptions(sampling: .greedy)
        #expect(greedyOptions.sampling == .greedy)
        
        // Test random top-k sampling
        let topKOptions = FoundryGenerationOptions(sampling: .random(top: 40, seed: 12345))
        #expect(topKOptions.sampling == .random(top: 40, seed: 12345))
        
        // Test random threshold sampling
        let thresholdOptions = FoundryGenerationOptions(sampling: .random(probabilityThreshold: 0.9, seed: 54321))
        #expect(thresholdOptions.sampling == .random(probabilityThreshold: 0.9, seed: 54321))
        
        // Test without seed
        let topKNoSeed = FoundryGenerationOptions(sampling: .random(top: 20))
        #expect(topKNoSeed.sampling == .random(top: 20, seed: nil))
    }
    
    @Test("Penalty parameters")
    func testPenaltyParameters() {
        let options = FoundryGenerationOptions(
            frequencyPenalty: 2.0,
            presencePenalty: -2.0
        )
        
        #expect(options.presencePenalty == -2.0)
        #expect(options.frequencyPenalty == 2.0)
    }
    
    @Test("Token limits and aliases")
    func testTokenLimits() {
        let options = FoundryGenerationOptions(
            maxTokens: 1000
        )
        
        #expect(options.maxTokens == 1000)
        #expect(options.maxOutputTokens == 1000) // Test alias
    }
    
    @Test("Guided generation flag")
    func testGuidedGeneration() {
        let optionsWithGuided = FoundryGenerationOptions(
            useGuidedGeneration: true
        )
        #expect(optionsWithGuided.useGuidedGeneration == true)
        
        let optionsWithoutGuided = FoundryGenerationOptions(
            useGuidedGeneration: false
        )
        #expect(optionsWithoutGuided.useGuidedGeneration == false)
        
        // Default should be false
        let defaultOptions = FoundryGenerationOptions()
        #expect(defaultOptions.useGuidedGeneration == false)
    }
    
    @Test("Equatable conformance")
    func testEquatable() {
        let options1 = FoundryGenerationOptions(
            sampling: .greedy,
            temperature: 0.7,
            frequencyPenalty: 0.1,
            presencePenalty: 0.2,
            maxTokens: 100,
            topP: 0.9,
            useGuidedGeneration: false
        )
        
        let options2 = FoundryGenerationOptions(
            sampling: .greedy,
            temperature: 0.7,
            frequencyPenalty: 0.1,
            presencePenalty: 0.2,
            maxTokens: 100,
            topP: 0.9,
            useGuidedGeneration: false
        )
        
        let options3 = FoundryGenerationOptions(
            sampling: .greedy,
            temperature: 0.8,  // Different temperature
            frequencyPenalty: 0.1,
            presencePenalty: 0.2,
            maxTokens: 100,
            topP: 0.9,
            useGuidedGeneration: false
        )
        
        let options4 = FoundryGenerationOptions(
            sampling: .random(top: 10),  // Different sampling
            temperature: 0.7,
            frequencyPenalty: 0.1,
            presencePenalty: 0.2,
            maxTokens: 100,
            topP: 0.9,
            useGuidedGeneration: false
        )
        
        #expect(options1 == options2)
        #expect(options1 != options3)
        #expect(options1 != options4)
    }
    
    @Test("Sendable conformance")
    func testSendable() async {
        let options = FoundryGenerationOptions(
            sampling: .random(top: 40, seed: 12345),
            temperature: 0.7,
            maxTokens: 100
        )
        
        // Test that options can be safely passed between concurrent contexts
        await withTaskGroup(of: (Double?, Int?).self) { group in
            group.addTask {
                return (options.temperature, options.maxTokens)
            }
            
            group.addTask {
                return (options.temperature, options.maxTokens)
            }
            
            for await (temp, tokens) in group {
                #expect(temp == 0.7)
                #expect(tokens == 100)
            }
        }
    }
    
    @Test("Foundation Models conversion")
    func testFoundationModelsConversion() {
        let options = FoundryGenerationOptions(
            sampling: .greedy,
            temperature: 0.7,
            frequencyPenalty: 0.1,  // Note: Not supported by Foundation Models yet
            presencePenalty: 0.2,   // Note: Not supported by Foundation Models yet
            maxTokens: 100,         // Note: Not supported by Foundation Models yet
            topP: 0.9               // Note: Not supported by Foundation Models yet
        )
        
        let fmOptions = options.toFoundationModels()
        
        // Foundation Models currently only supports temperature and sampling
        #expect(fmOptions.temperature == 0.7)
        #expect(fmOptions.sampling == .greedy)
    }
}