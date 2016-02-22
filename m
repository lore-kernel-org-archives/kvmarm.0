From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: next-20160222 build: 5 failures 9 warnings (next-20160222)
Date: Mon, 22 Feb 2016 10:41:42 +0000
Message-ID: <56CAE5E6.7030707@arm.com>
References: <E1aXlz4-000486-Pb@optimist>
 <20160222100832.GX18327@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160222100832.GX18327@sirena.org.uk>
Sender: linux-next-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/02/16 10:08, Mark Brown wrote:
> On Mon, Feb 22, 2016 at 08:36:46AM +0000, Build bot for Mark Brown wrote:
> 
> Today's -next fails to build on arm64 due to:
> 
>> 	arm64-allnoconfig
>> ../arch/arm64/include/asm/kvm_host.h:338:2: error: implicit declaration of function 'kvm_call_hyp' [-Werror=implicit-function-declaration]
>>
>> 	arm64-allmodconfig
>> ../arch/arm64/include/asm/kvm_host.h:338:2: error: implicit declaration of function 'kvm_call_hyp' [-Werror=implicit-function-declaration]
> 
>> 	arm64-defconfig
>> ../arch/arm64/include/asm/kvm_host.h:338:2: error: implicit declaration of function 'kvm_call_hyp' [-Werror=implicit-function-declaration]
> 
> triggered by the merge of the kvm-arm tree with -next today, it looks
> like changes in that tree and arm64 aren't playing nicely with each
> other (bisect came down to the merge and visual inspection of the
> changes didn't immediately show anything else though the issue is
> obvious in the code).

I'm about to push the following patch on top of the KVM tree:

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 43688d9..31fe7d6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -333,11 +333,6 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 		     hyp_stack_ptr, vector_ptr);
 }
 
-static inline void __cpu_init_stage2(void)
-{
-	kvm_call_hyp(__init_stage2_translation);
-}
-
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
@@ -349,4 +344,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 
+/* #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__) */
+
+static inline void __cpu_init_stage2(void)
+{
+	kvm_call_hyp(__init_stage2_translation);
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */

This will create a new conflict, but will make the resolution 100% clear.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
