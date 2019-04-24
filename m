From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Date: Wed, 24 Apr 2019 15:29:26 +0100
Message-ID: <4e475e1f-80f2-372a-2c16-a03ac947525a@arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
 <20190424133903.GU3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424133903.GU3567@e103592.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/04/2019 14:39, Dave Martin wrote:
> On Tue, Apr 23, 2019 at 10:12:35AM +0530, Amit Daniel Kachhap wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> When pointer authentication is supported, a guest may wish to use it.
>> This patch adds the necessary KVM infrastructure for this to work, with
>> a semi-lazy context switch of the pointer auth state.
>>
>> Pointer authentication feature is only enabled when VHE is built
>> in the kernel and present in the CPU implementation so only VHE code
>> paths are modified.
>>
>> When we schedule a vcpu, we disable guest usage of pointer
>> authentication instructions and accesses to the keys. While these are
>> disabled, we avoid context-switching the keys. When we trap the guest
>> trying to use pointer authentication functionality, we change to eagerly
>> context-switching the keys, and enable the feature. The next time the
>> vcpu is scheduled out/in, we start again. However the host key save is
>> optimized and implemented inside ptrauth instruction/register access
>> trap.
>>
>> Pointer authentication consists of address authentication and generic
>> authentication, and CPUs in a system might have varied support for
>> either. Where support for either feature is not uniform, it is hidden
>> from guests via ID register emulation, as a result of the cpufeature
>> framework in the host.
>>
>> Unfortunately, address authentication and generic authentication cannot
>> be trapped separately, as the architecture provides a single EL2 trap
>> covering both. If we wish to expose one without the other, we cannot
>> prevent a (badly-written) guest from intermittently using a feature
>> which is not uniformly supported (when scheduled on a physical CPU which
>> supports the relevant feature). Hence, this patch expects both type of
>> authentication to be present in a cpu.
>>
>> This switch of key is done from guest enter/exit assembly as preparation
>> for the upcoming in-kernel pointer authentication support. Hence, these
>> key switching routines are not implemented in C code as they may cause
>> pointer authentication key signing error in some situations.
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> [Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
>> , save host key in ptrauth exception trap]
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>> Changes since v9:
>>
>> * Removed hardcoding of enum values[Mark Zyngier].
>> * Changed kvm_ptrauth_asm.h to kvm_ptrauth.h[Mark Zyngier].
>> * Removed macro __ptrauth_save_state and applied inline [Marc Zyngier].
>> * Moved kvm_arm_vcpu_ptrauth_setup_lazy, kvm_arm_vcpu_ptrauth_enable and
>>   kvm_arm_vcpu_ptrauth_disable from *.c to kvm_emulate.h file [Marc Zyngier].
>> * Added/Modified comments at few places [Marc Zyngier].
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> 
> [...]
> 
>> @@ -1058,9 +1087,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>>  					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
>>  					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
>>  					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
>> -		if (val & ptrauth_mask)
>> -			kvm_debug("ptrauth unsupported for guests, suppressing\n");
>> -		val &= ~ptrauth_mask;
>> +		if (!vcpu_has_ptrauth(vcpu)) {
>> +			if (val & ptrauth_mask)
>> +				kvm_debug("ptrauth unsupported for guests, suppressing\n");
>> +			val &= ~ptrauth_mask;
>> +		}
> 
> Hmmm, didn't spot this before, but this error message no longer makes
> sense now that KVM _does_ support pointer auth.
> 
> Without vcpu_has_ptrauth(vcpu), we should just silently mask out the
> relevant ID fields now (same as for SVE).
> 
> The patch below should achieve that.
> 
> --8<--
> 
> From c6065122c5cccef57108dff990ce8fb43426f88e Mon Sep 17 00:00:00 2001
> From: Dave Martin <Dave.Martin@arm.com>
> Date: Wed, 24 Apr 2019 14:32:29 +0100
> Subject: [PATCH] KVM: arm64: sys_regs: Remove warning about missing pointer
>  auth support
> 
> KVM does support pointer auth for guests now, so it is
> inappropriate (and confusing) to print a warning to dmesg when
> userspace explicitly does not ask for pointer auth to be turned on
> for a vcpu.
> 
> So, just squash the virtual ptrauth ID_AA64ISAR1_EL1 fields when
> appropriate and remove the warning.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7f06c2e..f599f5e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1082,16 +1082,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  
>  	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> -	} else if (id == SYS_ID_AA64ISAR1_EL1) {
> -		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> -					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> -					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> -		if (!vcpu_has_ptrauth(vcpu)) {
> -			if (val & ptrauth_mask)
> -				kvm_debug("ptrauth unsupported for guests, suppressing\n");
> -			val &= ~ptrauth_mask;
> -		}
> +	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> +		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> +			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> +			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> +			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
>  	}
>  
>  	return val;
> 

Since the series isn't in -next yet, I've squashed the above with the
other nits I had in -queue.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
