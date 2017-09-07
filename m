From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH] arm64: KVM: VHE: reset PSTATE.UAO when switch to host
Date: Thu, 7 Sep 2017 18:05:11 +0800
Message-ID: <f710f68a-1e89-85a6-41a6-afc7588114db@huawei.com>
References: <1504763684-30128-1-git-send-email-gengdongjiu@huawei.com>
 <59B10F52.9010400@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59B10F52.9010400@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, vladimir.murzin@arm.com, rkrcmar@redhat.com, catalin.marinas@arm.com, shankerd@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhanghaibin7@huawei.com, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/9/7 17:20, James Morse wrote:
> Hi Dongjiu Geng,
> 
> On 07/09/17 06:54, Dongjiu Geng wrote:
>> In VHE mode, host kernel runs in the EL2 and can enable
>> 'User Access Override' when fs==KERNEL_DS so that it can
>> access kernel memory. However, PSTATE.UAO is set to 0 on
>> an exception taken from EL1 to EL2. Thus when VHE is used
>> and exception taken from a guest UAO will be disabled and
>> host will use the incorrect PSTATE.UAO. So check and reset
>> the PSTATE.UAO when switching to host.
> 
> This would only be a problem if KVM were calling into world-switch with
> fs==KERNEL_DS. I can't see where this happens.
 Not only KVM, may also kernel sets the fs == KERNEL_DS before calling into world-switch

> 
> kvm_arch_vcpu_ioctl_run() is the only place KVM calls world-switch, there are no
> set_fs() calls in it, or on the path to it. The addr_limit should be USER_DS,
> PSTATE.UAO will be clear, as it is when we come back from a guest.
how about if kernel set the KERNEL_DS? but not the kvm_arch_vcpu_ioctl_run().

> 
> This isn't broken today. I agree it will break if KVM decides to
> set_fs(KERNEL_DS) around world switch, but until then we don't need this patch.
KVM and host kernel set_fs(KERNEL_DS) all can break this.
In the normal way, after world-switch, I think it should check whether it needs to restore to its previous state.
we should not always consider the set_fs(KERNEL_DS) is disabled for the host.

> 
> 
>> Move the reset PSTATE.PAN on entry to EL2 together with
>> PSTATE.UAO reset.
> 
> Moving this breaks PAN-at-HYP for systems with PAN but without VHE.
No, without VHE, the host kernel is running in the EL1.
Before host kernel enter guest, host OS will call 'HVC' instruction to do the world-switch, and the pstate.PAN will be saved into the SPSR_EL2.
When world-switch back to host kernel from EL2, it will call 'eret' instruction to EL1 host, this 'eret' instruction will restore the SPSR_EL2 to the PSTATE.
so the PSTATE.PAN will be restored.
So without VHE, we should not reset the PAN. I paste the spec statement

------------------------------
PSTATE.PAN is copied to SPSR_ELx.PAN on an exception taken from AArch64 to AArch64
SPSR_ELx.PAN is copied to PSTATE.PAN on an exception return to AArch64 from AArch64


> 
> 
>> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
>> index 12ee62d..7662ef5 100644
>> --- a/arch/arm64/kvm/hyp/entry.S
>> +++ b/arch/arm64/kvm/hyp/entry.S
>> @@ -96,8 +96,6 @@ ENTRY(__guest_exit)
>>  
>>  	add	x1, x1, #VCPU_CONTEXT
>>  
>> -	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
>> -
>>  	// Store the guest regs x2 and x3
>>  	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
>>  
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index a733461..715b3941 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -22,6 +22,7 @@
>>  #include <asm/kvm_emulate.h>
>>  #include <asm/kvm_hyp.h>
>>  #include <asm/fpsimd.h>
>> +#include <asm/exec.h>
>>  
>>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
>>  {
>> @@ -399,6 +400,17 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>>  
>>  	__sysreg_restore_host_state(host_ctxt);
>>  
>> +	if (has_vhe()) {
>> +		/*
>> +		 * PSTATE was not saved over guest enter/exit, re-enable
>> +		 * any detecte features that might not have been set
>> +		 * correctly.
>> +		 */
>> +		uao_thread_switch(current);
> 
> I don't see how addr_limit will ever be KERNEL_DS, so this is always clearing
> PSTATE.UAO, which was already clear from the guest-exit exception.
I think we should not always consider the host kernel does not set the KERNEL_DS before entering guest.

> 
> (Also, the uao_thread_switch() code isn't accessible from EL2, neither is current)
No,
for the VHE, both the uao_thread_switch() and current can be accessible from the EL2.
all the host kernel runs in the EL2.
The API can be accessible from EL2 to the VHE.
The current is Qemu or other kvm tools
I have tested this patch, it is workable.

> 
> 
>> +		asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1),
>> +			ARM64_HAS_PAN, CONFIG_ARM64_PAN));
> 
> ... and this is setting PSTATE.PAN on VHE, which was already set, and breaking
> PAN-at-HYP on non-VHE systems.
> 
> Vladimir's commit message for that patch that added this enabling explained it
> is needed for !VHE as SCTLR_EL2 when HCR_EL2.E2H is clear doesn't have a SPAN bit.
> 
> When we have VHE clearing SCTLR_EL2.SPAN (clearing because it was RES1 on v8.0)
> will cause the CPU to set PSTATE.PAN when we take an exception.
> 
> 
>> +	}
>> +
>>  	if (fp_enabled) {
>>  		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
>>  		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
>>
> 
> 
> James
> 
> 
> .
> 
