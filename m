From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v5 07/12] KVM: arm64: guest debug, add support for single-step
Date: Thu, 04 Jun 2015 14:46:39 +0100
Message-ID: <87a8wfbn7k.fsf@linaro.org>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org> <1432891828-4816-8-git-send-email-alex.bennee@linaro.org> <20150604110752.GI7657@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150604110752.GI7657@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Fri, May 29, 2015 at 10:30:23AM +0100, Alex Benn=C3=A9e wrote:
>> This adds support for single-stepping the guest. To do this we need =
to
>> manipulate the guests PSTATE.SS and MDSCR_EL1.SS bits which we do in=
 the
>> kvm_arm_setup/clear_debug() so we don't affect the apparent state of=
 the
>> guest. Additionally while the host is debugging the guest we suppres=
s
>> the ability of the guest to single-step itself.
>
> I feel like there should be a slightly more elaborate explanation of
> exactly what works and what doesn't work when the guest is single
> stepping something and which choices we've made for supporting or not
> supporting this.

OK, I shall put bit more explanation. I was trying to avoid too much
exposition in the commit comments vs the code.

>
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>=20
>> ---
>> v2
>>   - Move pstate/mdscr manipulation into C
>>   - don't export guest_debug to assembly
>>   - add accessor for saved_debug regs
>>   - tweak save/restore of mdscr_el1
>> v3
>>   - don't save PC in debug information struct
>>   - rename debug_saved_regs->guest_debug_state
>>   - save whole value, only use bits in restore
>>   - add save/restore_guest-debug_regs helper functions
>>   - simplify commit message for clarity
>>   - rm vcpu_debug_saved_reg access fn
>> v4
>>   - added more comments based on suggestions
>>   - guest_debug_state->guest_debug_preserved
>>   - no point masking restore, we will trap out
>> v5
>>   - more comments
>>   - don't bother preserving pstate.ss
>
> it would have been good if there was some comment explaining the reas=
on
> for this change.
>
>> ---
>>  arch/arm/kvm/arm.c                |  4 ++-
>>  arch/arm64/include/asm/kvm_host.h | 11 ++++++++
>>  arch/arm64/kvm/debug.c            | 58 ++++++++++++++++++++++++++++=
++++++++---
>>  arch/arm64/kvm/handle_exit.c      |  2 ++
>>  4 files changed, 70 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 064c105..9b3ed6d 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -302,7 +302,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  	kvm_arm_set_running_vcpu(NULL);
>>  }
>> =20
>> -#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG=
_USE_SW_BP)
>> +#define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE |    \
>> +			    KVM_GUESTDBG_USE_SW_BP | \
>> +			    KVM_GUESTDBG_SINGLESTEP)
>> =20
>>  /**
>>   * kvm_arch_vcpu_ioctl_set_guest_debug - set up guest debugging
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/=
asm/kvm_host.h
>> index 7cb99b5..e2db6a6 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -123,6 +123,17 @@ struct kvm_vcpu_arch {
>>  	 * here.
>>  	 */
>> =20
>> +	/*
>> +	 * Guest registers we preserve during guest debugging.
>> +	 *
>> +	 * These shadow registers are updated by the kvm_handle_sys_reg
>> +	 * trap handler if the guest accesses or updates them while we
>> +	 * are using guest debug.
>> +	 */
>> +	struct {
>> +		u32	mdscr_el1;
>> +	} guest_debug_preserved;
>> +
>>  	/* Don't run the guest */
>>  	bool pause;
>> =20
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index 8d1bfa4..10a6baa 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -19,11 +19,41 @@
>> =20
>>  #include <linux/kvm_host.h>
>> =20
>> +#include <asm/debug-monitors.h>
>> +#include <asm/kvm_asm.h>
>>  #include <asm/kvm_arm.h>
>> +#include <asm/kvm_emulate.h>
>> +
>> +/* These are the bits of MDSCR_EL1 we may manipulate */
>> +#define MDSCR_EL1_DEBUG_MASK	(DBG_MDSCR_SS | \
>> +				DBG_MDSCR_KDE | \
>> +				DBG_MDSCR_MDE)
>> =20
>>  static DEFINE_PER_CPU(u32, mdcr_el2);
>> =20
>>  /**
>> + * save/restore_guest_debug_regs
>> + *
>> + * For some debug operations we need to tweak some guest registers.=
 As
>> + * a result we need to save the state of those registers before we
>> + * make those modifications. This does get confused if the guest
>> + * attempts to control single step while being debugged. It will st=
art
>> + * working again once it is no longer being debugged by the host.
>
> What gets confused and what starts working?

Maybe I should cut from "This does get..." and put more explanation in
the single step comment later.

>
>> + *
>> + * Guest access to MDSCR_EL1 is trapped by the hypervisor and handl=
ed
>> + * after we have restored the preserved value to the main context.
>> + */
>> +static void save_guest_debug_regs(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->arch.guest_debug_preserved.mdscr_el1 =3D vcpu_sys_reg(vcpu, =
MDSCR_EL1);
>> +}
>> +
>> +static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu_sys_reg(vcpu, MDSCR_EL1) =3D vcpu->arch.guest_debug_preserved=
=2Emdscr_el1;
>> +}
>> +
>> +/**
>>   * kvm_arm_init_debug - grab what we need for debug
>>   *
>>   * Currently the sole task of this function is to retrieve the init=
ial
>> @@ -38,7 +68,6 @@ void kvm_arm_init_debug(void)
>>  	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
>>  }
>> =20
>> -
>>  /**
>>   * kvm_arm_setup_debug - set up debug related stuff
>>   *
>> @@ -73,12 +102,33 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>>  	if (trap_debug)
>>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
>> =20
>> -	/* Trap breakpoints? */
>> -	if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
>> +	/* Is Guest debugging in effect? */
>> +	if (vcpu->guest_debug) {
>>  		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDE;
>> +
>> +		/* Save guest debug state */
>> +		save_guest_debug_regs(vcpu);
>> +
>> +		/*
>> +		 * Single Step (ARM ARM D2.12.3 The software step state
>> +		 * machine)
>> +		 *
>> +		 * If we are doing Single Step we need to manipulate
>> +		 * MDSCR_EL1.SS and PSTATE.SS. If not we need to
>> +		 * suppress the guests ability to trigger single step
>> +		 * exceptions as otherwise the host will deal with them.
>
> is this because if you are doing any kind of guest debugging, we trap
> all debug exceptions to EL2 and therefore single-stepping in the gues=
t
> won't work anyway and the host doesn't know what to do with such
> exceptions?

Correct. As MDCR_EL2.TDE is in effect everything gets routed to EL2. Fo=
r
breakpoints this is not a major problem as we have all the details
for user space to re-inject the exception if required. However for
single-step it means we get an exception as soon as the guest enables
MDSCR_EL1.SS even if it doesn't have MDSCR_EL1.KDE enabled. The guest
would only be expecting the single step to kick in when it eret's to EL=
0
setting PSTATE.SS.

In future we could consider getting userspace to singlestep the guest
out of the kernel until it goes over the eret but this is starting to
get hairy.

>
> I would feel slightly better if the comment assured me this doesn't
> outright break something, but ok...

Well nothing breaks per-se but if you have a GDB session in the guest
you'll wonder why "start" and the various breaks don't trigger. They
actually will but the host GDB then tries to SS over them and we
continue on until the host has stopped doing any sort of debug.

>
>> +		 */
>> +		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
>> +			*vcpu_cpsr(vcpu) |=3D  DBG_SPSR_SS;
>> +			vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D DBG_MDSCR_SS;
>> +		} else {
>> +			vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~DBG_MDSCR_SS;
>> +		}
>> +	}
>>  }
>> =20
>>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>>  {
>> -	/* Nothing to do yet */
>> +	if (vcpu->guest_debug)
>> +		restore_guest_debug_regs(vcpu);
>>  }
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_ex=
it.c
>> index 27f38a9..e9de13e 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -103,6 +103,7 @@ static int kvm_handle_guest_debug(struct kvm_vcp=
u *vcpu, struct kvm_run *run)
>>  	run->debug.arch.hsr =3D hsr;
>> =20
>>  	switch (hsr >> ESR_ELx_EC_SHIFT) {
>> +	case ESR_ELx_EC_SOFTSTP_LOW:
>>  	case ESR_ELx_EC_BKPT32:
>>  	case ESR_ELx_EC_BRK64:
>>  		break;
>> @@ -130,6 +131,7 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>>  	[ESR_ELx_EC_SYS64]	=3D kvm_handle_sys_reg,
>>  	[ESR_ELx_EC_IABT_LOW]	=3D kvm_handle_guest_abort,
>>  	[ESR_ELx_EC_DABT_LOW]	=3D kvm_handle_guest_abort,
>> +	[ESR_ELx_EC_SOFTSTP_LOW]=3D kvm_handle_guest_debug,
>>  	[ESR_ELx_EC_BKPT32]	=3D kvm_handle_guest_debug,
>>  	[ESR_ELx_EC_BRK64]	=3D kvm_handle_guest_debug,
>>  };
>> --=20
>> 2.4.1
>>=20
>
> As for the code of this patch:
>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

--=20
Alex Benn=C3=A9e
