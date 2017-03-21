From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] kvm: pass the virtual SEI syndrome to guest OS
Date: Tue, 21 Mar 2017 14:07:40 +0800
Message-ID: <693256ed-c5e6-f62e-5475-4cab5514159e@huawei.com>
References: <1489996534-8270-1-git-send-email-gengdongjiu@huawei.com>
 <7055772d-2a20-6e0c-2bf8-204bc9ef52a5@arm.com>
 <b912c293-4314-7c90-30a4-2f986feb1670@huawei.com>
 <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <22fb583f-a33e-15f8-a059-fb112b27dd4f@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, will.deacon@arm.com, christoffer.dall@linaro.org, rkrcmar@redhat.com, suzuki.poulose@arm.com, andre.przywara@arm.com, mark.rutland@arm.com, vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xiexiuqi@huawei.com, wangxiongfeng2@huawei.com, wuquanming@huawei.com, James.Morse@arm.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
  Thank you very much for your review.


On 2017/3/20 21:58, Marc Zyngier wrote:
> On 20/03/17 12:28, gengdongjiu wrote:
>>
>>
>> On 2017/3/20 19:24, Marc Zyngier wrote:
>>> Please include James Morse on anything RAS related, as he's already
>>> looking at related patches.
>>>
>>> On 20/03/17 07:55, Dongjiu Geng wrote:
>>>> In the RAS implementation, hardware pass the virtual SEI
>>>> syndrome information through the VSESR_EL2, so set the virtual
>>>> SEI syndrome using physical SEI syndrome el2_elr to pass to
>>>> the guest OS
>>>>
>>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>>> Signed-off-by: Quanming wu <wuquanming@huawei.com>
>>>> ---
>>>>  arch/arm64/Kconfig                   |  8 ++++++++
>>>>  arch/arm64/include/asm/esr.h         |  1 +
>>>>  arch/arm64/include/asm/kvm_emulate.h | 12 ++++++++++++
>>>>  arch/arm64/include/asm/kvm_host.h    |  4 ++++
>>>>  arch/arm64/kvm/hyp/switch.c          | 15 ++++++++++++++-
>>>>  arch/arm64/kvm/inject_fault.c        | 10 ++++++++++
>>>>  6 files changed, 49 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>>> index 8c7c244247b6..ea62170a3b75 100644
>>>> --- a/arch/arm64/Kconfig
>>>> +++ b/arch/arm64/Kconfig
>>>> @@ -908,6 +908,14 @@ endmenu
>>>>  
>>>>  menu "ARMv8.2 architectural features"
>>>>  
>>>> +config HAS_RAS_EXTENSION
>>>> +	bool "Support arm64 RAS extension"
>>>> +	default n
>>>> +	help
>>>> +	  Reliability, Availability, Serviceability(RAS; part of the ARMv8.2 Extensions).
>>>> +
>>>> +	  Selecting this option OS will try to recover the error that RAS hardware node detected.
>>>> +
>>>
>>> As this is an architectural extension, this should be controlled by the
>>> CPU feature mechanism, and not be chosen at compile time. What you have
>>> here will break horribly when booted on a CPU that doesn't implement RAS.
>>
>> thanks very much for your review, yes, it is, you are right.
>>
>>>
>>>>  config ARM64_UAO
>>>>  	bool "Enable support for User Access Override (UAO)"
>>>>  	default y
>>>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>>>> index d14c478976d0..e38d32b2bdad 100644
>>>> --- a/arch/arm64/include/asm/esr.h
>>>> +++ b/arch/arm64/include/asm/esr.h
>>>> @@ -111,6 +111,7 @@
>>>>  #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
>>>>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
>>>>  #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
>>>> +#define VSESR_ELx_IDS_ISS_MASK    ((1UL << 25) - 1)
>>>>  
>>>>  /* ESR value templates for specific events */
>>>>  
>>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>>>> index f5ea0ba70f07..20d4da7f5dce 100644
>>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>>> @@ -148,6 +148,18 @@ static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
>>>>  	return vcpu->arch.fault.esr_el2;
>>>>  }
>>>>  
>>>> +#ifdef CONFIG_HAS_RAS_EXTENSION
>>>> +static inline u32 kvm_vcpu_get_vsesr(const struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	return vcpu->arch.fault.vsesr_el2;
>>>> +}
>>>> +
>>>> +static inline void kvm_vcpu_set_vsesr(struct kvm_vcpu *vcpu, unsigned long val)
>>>> +{
>>>> +	vcpu->arch.fault.vsesr_el2 = val;
>>>> +}
>>>> +#endif
>>>> +
>>>>  static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>>>>  {
>>>>  	u32 esr = kvm_vcpu_get_hsr(vcpu);
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index e7705e7bb07b..f9e3bb57c461 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -83,6 +83,10 @@ struct kvm_mmu_memory_cache {
>>>>  };
>>>>  
>>>>  struct kvm_vcpu_fault_info {
>>>> +#ifdef CONFIG_HAS_RAS_EXTENSION
>>>> +	/* Virtual SError Exception Syndrome Register */
>>>> +	u32 vsesr_el2;
>>>> +#endif
>>>>  	u32 esr_el2;		/* Hyp Syndrom Register */
>>>>  	u64 far_el2;		/* Hyp Fault Address Register */
>>>>  	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
>>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>>> index aede1658aeda..770a153fb6ba 100644
>>>> --- a/arch/arm64/kvm/hyp/switch.c
>>>> +++ b/arch/arm64/kvm/hyp/switch.c
>>>> @@ -86,6 +86,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>>>>  		isb();
>>>>  	}
>>>>  	write_sysreg(val, hcr_el2);
>>>> +#ifdef CONFIG_HAS_RAS_EXTENSION
>>>> +	/* If virtual System Error or Asynchronous Abort is pending. set
>>>> +	 * the virtual exception syndrome information
>>>> +	 */
>>>> +	if (vcpu->arch.hcr_el2 & HCR_VSE)
>>>> +		write_sysreg(vcpu->arch.fault.vsesr_el2, vsesr_el2);
>>>> +#endif
>>>>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>>>>  	write_sysreg(1 << 15, hstr_el2);
>>>>  	/*
>>>> @@ -139,8 +146,14 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>>>>  	 * the crucial bit is "On taking a vSError interrupt,
>>>>  	 * HCR_EL2.VSE is cleared to 0."
>>>>  	 */
>>>> -	if (vcpu->arch.hcr_el2 & HCR_VSE)
>>>> +	if (vcpu->arch.hcr_el2 & HCR_VSE) {
>>>>  		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
>>>> +#ifdef CONFIG_HAS_RAS_EXTENSION
>>>> +		/* set vsesr_el2[24:0] with esr_el2[24:0] */
>>>> +		kvm_vcpu_set_vsesr(vcpu, read_sysreg_el2(esr)
>>>> +					& VSESR_ELx_IDS_ISS_MASK);
>>>
>>> What guarantees that ESR_EL2 still contains the latest exception? What
>>> does it mean to store something that is the current EL2 exception
>>> syndrome together with an SError that has already been injected?
>>
>> yes, thanks for the review, I will add a judgement condition for the "exit_code"
>> if the "exit_code == ARM_EXCEPTION_EL1_SERROR" then set the vsesr_el2.
>>
>> for the aarch32, it only need set the "ExT, bit [12]" and AET, "bits [15:14]", other bit is RES0
>>
>>>
>>> Also, is it correct to directly copy the ESR_EL2 bits into VSESR_EL2? My
>> please see below spec description, it virtual SERROR syndrome from VSESR_EL2.
>> -----
>>  Control returns to the OS, and the ESB instruction is re-executed.
>> — The physical asynchronous SError interrupt has been cleared, so it is not taken again.
>> — The PE sets VDISR_EL2.A to 1 and records the syndrome from VSESR_EL2 in VDISR_EL2.
>> -----
> 
> Which doesn't say anything about directly using ESR_EL2 and propagating
> it directly to the guest, specially when there is *already* an SError

thank you for the comments.
In my current solution which I refer to ARM RAS spec(RAS_Extension_PRD03-PRDC-010953-32-0.pdf).
when the Guest OS triggers an SEI, it will firstly trap to EL3 firmware, El3 firmware records the error
info to the APEI table, then copy the ESR_EL3 ELR_EL3 to ESR_EL2 ELR_EL2 and transfers control to the
hypervisor, hypervisor delegates the error exception to EL1 guest OS by setting HCR_EL2.VSE to 1 and pass the
virtual SEI syndrome through vsesr_el2. The EL1 guest OS check the DISR_EL1 syndrome information to decide to
terminate the application, or do some other recovery action. because the HCR_EL2.AMO is set, so in fact, read
DISR_EL1, it returns the VDISR_EL2. and VDISR_EL2 is loaded from VSESR_EL2, so here I pass the virtual SEI
syndrome vsesr_el2.

please see the ARM spec example about SEI with ESB
----------------------------------------------------------------------------------------------------
 The firmware logs, triages, and delegates the error exception to the hypervisor. As the error came
from EL1, it does by faking an SError interrupt exception entry to EL2.
 Control transfers to the hypervisor’s delegated error recovery agent. It repeats the process of triaging
the error.
 The hypervisor delegates the error exception to EL1 by setting HCR_EL2.VSE to 1, and returns
control to the OS using ERET.
 Control returns to the OS, and the ESB instruction is re-executed.
— The physical asynchronous SError interrupt has been cleared, so it is not taken again.
— The PE sets VDISR_EL2.A to 1 and records the syndrome from VSESR_EL2 in VDISR_EL2.
 The SVC exception entry code completes, and then the OS checks DISR_EL1 for a deferred SError
interrupt.
— See the example code sequence in Error Synchronization Barrier.
— This in fact returns VDISR_EL2 because the HCR_EL2.AMO bit is set.
 Because this returns DISR_EL1.A set, the OS instead processes the error.
— Although the error exception was taken from EL1, the OS error recovery agent can use the
information that it was taken from the ESB instruction at the exception entry point to isolate
the error to the EL0 application and not affect the OS.
 The error has been logged, triaged, and contained to the EL0 application.
-------------------------------------------------------------------------------------------------------------


> pending (just in case you haven't noticed, this is the *exit* path, and
> I can't see why you would overload VSESR_EL2 at at point).
>
thanks for the question.
This is exit path, for the case that already an SError is pending.it should be overload VSESR_EL2 using
the esr_el2 in below situation, right?

int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
                       int exception_index)
{
        exit_handle_fn exit_handler;

        if (ARM_SERROR_PENDING(exception_index)) {
                u8 hsr_ec = ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));

                /*
                 * HVC/SMC already have an adjusted PC, which we need
                 * to correct in order to return to after having
                 * injected the SError.
                 */
                if (hsr_ec == ESR_ELx_EC_HVC32 || hsr_ec == ESR_ELx_EC_HVC64 ||
                    hsr_ec == ESR_ELx_EC_SMC32 || hsr_ec == ESR_ELx_EC_SMC64) {
                        u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
                        *vcpu_pc(vcpu) -= adj;
                }

                kvm_inject_vabt(vcpu);
                return 1;
        }


>>
>>> own reading of the specification seem to imply that there is at least
>>> differences when the guest is AArch32. Surely there would be some
>>> processing here.
>>
>>
>>
>>>
>>>> +#endif
>>>> +	}
>>>>  
>>>>  	__deactivate_traps_arch()();
>>>>  	write_sysreg(0, hstr_el2);
>>>> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
>>>> index da6a8cfa54a0..08a13dfe28a8 100644
>>>> --- a/arch/arm64/kvm/inject_fault.c
>>>> +++ b/arch/arm64/kvm/inject_fault.c
>>>> @@ -242,4 +242,14 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
>>>>  void kvm_inject_vabt(struct kvm_vcpu *vcpu)
>>>>  {
>>>>  	vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) | HCR_VSE);
>>>> +#ifdef CONFIG_HAS_RAS_EXTENSION
>>>> +	/* If virtual System Error or Asynchronous Abort is set. set
>>>> +	 * the virtual exception syndrome information
>>>> +	 */
>>>> +	kvm_vcpu_set_vsesr(vcpu, ((kvm_vcpu_get_vsesr(vcpu)
>>>> +				& (~VSESR_ELx_IDS_ISS_MASK))
>>>> +				| (kvm_vcpu_get_hsr(vcpu)
>>>> +				& VSESR_ELx_IDS_ISS_MASK)));
>>>
>>> What is the rational for setting VSESR_EL2 with the EL1 syndrome
>>> information? That doesn't make any sense to me.
>> thanks, I set the VSESR_EL2 using the  EL2 syndrome information, "kvm_vcpu_get_hsr"
>> return the value of esr_el2, not EL1 syndrome information
> 
> Ah, good point. But that doesn't make it more valid. I still don't see
> anything in the spec that supports this behaviour, and I still propose
> that when RAS is enabled, the VSError injection is mediated by userspace.
> 
For the reason that set vsesr_el2 using esr_el2, I have explained it in above.
do you mean below steps?

EL0/EL1 SEI ---> EL3 firmware ------> EL2 hypervisor notify the Qemu to inject VSError ------>Qemu call KVM API to inject VSError ---->KVM



> Thanks,
> 
> 	M.
> 
