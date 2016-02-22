From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: next-20160222 build: 5 failures 9 warnings (next-20160222)
Date: Mon, 22 Feb 2016 12:44:15 +0000
Message-ID: <56CB029F.2060409@arm.com>
References: <E1aXlz4-000486-Pb@optimist>
 <20160222100832.GX18327@sirena.org.uk> <56CAE5E6.7030707@arm.com>
 <20160222115243.GA5779@e106950-lin.cambridge.arm.com>
 <56CAF868.5020406@arm.com>
 <20160222120730.GB5779@e106950-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160222120730.GB5779@e106950-lin.cambridge.arm.com>
Sender: linux-next-owner@vger.kernel.org
To: Brian Starkey <brian.starkey@arm.com>
Cc: Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linaro-kernel@lists.linaro.org, kvmarm@lists.cs.columbia.edu, linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-build-reports@lists.linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 22/02/16 12:07, Brian Starkey wrote:
> On Mon, Feb 22, 2016 at 12:00:40PM +0000, Marc Zyngier wrote:
>> On 22/02/16 11:52, Brian Starkey wrote:
>>>> This will create a new conflict, but will make the resolution 100% 
>>>> clear.
>>>
>>> I applied this, but arm64 defconfig wouldn't build until I uncommented
>>> the '#define kvm_call_hyp(...' line.
>>>
>>> Is that right?
>>
>> This patch is intended as a merge indication so that when you do the
>> merge with the arm64 tree, it conflicts and you can resolve it by going
>> the right thing (merging the non-comment version of this line).
> 
> Right, now I understand "make the resolution 100% clear" - I guess 100%
> clear isn't clear enough for me :-(

It is not meant to be clear to you, but to whoever is actually performing the merge:

$ git checkout arm64/for-next/core
Note: checking out 'arm64/for-next/core'.
$ git merge kvmarm-master/next
Auto-merging virt/kvm/arm/hyp/vgic-v2-sr.c
Auto-merging virt/kvm/arm/hyp/timer-sr.c
Auto-merging arch/arm64/mm/fault.c
Removing arch/arm64/kvm/hyp/hyp.h
Auto-merging arch/arm64/kvm/hyp/debug-sr.c
Auto-merging arch/arm64/kvm/hyp.S
CONFLICT (content): Merge conflict in arch/arm64/kvm/hyp.S
Auto-merging arch/arm64/kernel/image.h
Auto-merging arch/arm64/kernel/head.S
Auto-merging arch/arm64/kernel/debug-monitors.c
Auto-merging arch/arm64/kernel/cpufeature.c
CONFLICT (content): Merge conflict in arch/arm64/kernel/cpufeature.c
Auto-merging arch/arm64/include/asm/kvm_host.h
CONFLICT (content): Merge conflict in arch/arm64/include/asm/kvm_host.h
Auto-merging arch/arm64/include/asm/kvm_asm.h
Auto-merging arch/arm64/include/asm/cpufeature.h
CONFLICT (content): Merge conflict in arch/arm64/include/asm/cpufeature.h
Auto-merging arch/arm64/Kconfig
Removing arch/arm/kvm/interrupts_head.S
Auto-merging arch/arm/kvm/arm.c
CONFLICT (content): Merge conflict in arch/arm/kvm/arm.c
Auto-merging arch/arm/include/asm/kvm_asm.h
Automatic merge failed; fix conflicts and then commit the result.
maz@approximate:~/Work/arm-platforms$ git diff arch/arm64/include/asm/kvm_host.h
diff --cc arch/arm64/include/asm/kvm_host.h
index e3d67ff,31fe7d6..0000000
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@@ -343,6 -344,11 +344,15 @@@ void kvm_arm_setup_debug(struct kvm_vcp
  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
  
++<<<<<<< HEAD
 +#define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
++=======
+ /* #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__) */
+ 
+ static inline void __cpu_init_stage2(void)
+ {
+       kvm_call_hyp(__init_stage2_translation);
+ }
++>>>>>>> kvmarm-master/next
  
  #endif /* __ARM64_KVM_HOST_H__ */

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
