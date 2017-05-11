From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v1 1/2] KVM: arm: plug guest debug exploit
Date: Thu, 11 May 2017 11:07:36 +0100
Message-ID: <87r2zv4sgn.fsf@linaro.org>
References: <20170510170200.13285-1-alex.bennee@linaro.org> <20170510170200.13285-2-alex.bennee@linaro.org> <e391df93-8afd-08fa-2e0a-48515d154a99@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <e391df93-8afd-08fa-2e0a-48515d154a99@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: christoffer.dall@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Zhichao Huang <zhichao.huang@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Russell King <linux@armlinux.org.uk>, Vladimir Murzin <vladimir.murzin@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Marc Zyngier <marc.zyngier@arm.com> writes:

> Hi Alex,
>
> On 10/05/17 18:01, Alex Bennée wrote:
>> From: Zhichao Huang <zhichao.huang@linaro.org>
>>
>> Hardware debugging in guests is not intercepted currently, it means
>> that a malicious guest can bring down the entire machine by writing
>> to the debug registers.
>>
>> This patch enable trapping of all debug registers, preventing the
>> guests to access the debug registers. This includes access to the
>> debug mode(DBGDSCR) in the guest world all the time which could
>> otherwise mess with the host state. Reads return 0 and writes are
>> ignored.
>>
>> The result is the guest cannot detect any working hardware based debug
>> support. As debug exceptions are still routed to the guest normal
>> debug using software based breakpoints still works.
>>
>> To support debugging using hardware registers we need to implement a
>> debug register aware world switch as well as special trapping for
>> registers that may affect the host state.
>>
>> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>
>> ---
>> ajb:
>>   - convert to C world switch
>>   - reword commit message
>> ---
>>  arch/arm/include/asm/kvm_coproc.h |  3 +-
>>  arch/arm/kvm/coproc.c             | 82 +++++++++++++++++++++++++++++----------
>>  arch/arm/kvm/handle_exit.c        |  4 +-
>>  arch/arm/kvm/hyp/switch.c         |  4 +-
>>  4 files changed, 69 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_coproc.h b/arch/arm/include/asm/kvm_coproc.h
>> index 4917c2f7e459..e74ab0fbab79 100644
>> --- a/arch/arm/include/asm/kvm_coproc.h
>> +++ b/arch/arm/include/asm/kvm_coproc.h
>> @@ -31,7 +31,8 @@ void kvm_register_target_coproc_table(struct kvm_coproc_target_table *table);
>>  int kvm_handle_cp10_id(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  int kvm_handle_cp_0_13_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> -int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> +int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>
>> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
>> index 3e5e4194ef86..b2053393bb1f 100644
>> --- a/arch/arm/kvm/coproc.c
>> +++ b/arch/arm/kvm/coproc.c
>> @@ -93,12 +93,6 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  	return 1;
>>  }
>>
>> -int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> -{
>> -	kvm_inject_undefined(vcpu);
>> -	return 1;
>> -}
>> -
>>  static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
>>  {
>>  	/*
>> @@ -514,12 +508,8 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
>>  	return 1;
>>  }
>>
>> -/**
>> - * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
>> - * @vcpu: The VCPU pointer
>> - * @run:  The kvm_run struct
>> - */
>> -int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +static int kvm_handle_cp_64(struct kvm_vcpu *vcpu, struct kvm_run *run,
>> +			    bool cp15)
>>  {
>>  	struct coproc_params params;
>>
>> @@ -533,7 +523,35 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
>>  	params.CRm = 0;
>>
>> -	return emulate_cp15(vcpu, &params);
>> +	if (cp15)
>> +		return emulate_cp15(vcpu, &params);
>> +
>> +	/* raz_wi cp14 */
>> +	(void)pm_fake(vcpu, &params, NULL);
>
> Why this (void) cast?

I guess a super picky compiler could complain about throwing away a
return value? Mine didn't do I've removed it.

>
>> +
>> +	/* handled */
>> +	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
>> +	return 1;
>> +}
>> +
>> +/**
>> + * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
>> + * @vcpu: The VCPU pointer
>> + * @run:  The kvm_run struct
>> + */
>> +int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +{
>> +	return kvm_handle_cp_64(vcpu, run, 1);
>
> true instead of 1?

fixed

>
>> +}
>> +
>> +/**
>> + * kvm_handle_cp14_64 -- handles a mrrc/mcrr trap on a guest CP14 access
>> + * @vcpu: The VCPU pointer
>> + * @run:  The kvm_run struct
>> + */
>> +int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +{
>> +	return kvm_handle_cp_64(vcpu, run, 0);
>
> false?

fixed

>
>>  }
>>
>>  static void reset_coproc_regs(struct kvm_vcpu *vcpu,
>> @@ -546,12 +564,8 @@ static void reset_coproc_regs(struct kvm_vcpu *vcpu,
>>  			table[i].reset(vcpu, &table[i]);
>>  }
>>
>> -/**
>> - * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
>> - * @vcpu: The VCPU pointer
>> - * @run:  The kvm_run struct
>> - */
>> -int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +static int kvm_handle_cp_32(struct kvm_vcpu *vcpu, struct kvm_run *run,
>> +			      bool cp15)
>>  {
>>  	struct coproc_params params;
>>
>> @@ -565,7 +579,35 @@ int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
>>  	params.Rt2 = 0;
>>
>> -	return emulate_cp15(vcpu, &params);
>> +	if (cp15)
>> +		return emulate_cp15(vcpu, &params);
>> +
>> +	/* raz_wi cp14 */
>> +	(void)pm_fake(vcpu, &params, NULL);
>> +
>> +	/* handled */
>> +	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
>> +	return 1;
>> +}
>> +
>> +/**
>> + * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
>> + * @vcpu: The VCPU pointer
>> + * @run:  The kvm_run struct
>> + */
>> +int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +{
>> +	return kvm_handle_cp_32(vcpu, run, 1);
>> +}
>> +
>> +/**
>> + * kvm_handle_cp14_32 -- handles a mrc/mcr trap on a guest CP14 access
>> + * @vcpu: The VCPU pointer
>> + * @run:  The kvm_run struct
>> + */
>> +int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +{
>> +	return kvm_handle_cp_32(vcpu, run, 0);
>>  }
>>
>>  /******************************************************************************
>> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
>> index 96af65a30d78..42f5daf715d0 100644
>> --- a/arch/arm/kvm/handle_exit.c
>> +++ b/arch/arm/kvm/handle_exit.c
>> @@ -95,9 +95,9 @@ static exit_handle_fn arm_exit_handlers[] = {
>>  	[HSR_EC_WFI]		= kvm_handle_wfx,
>>  	[HSR_EC_CP15_32]	= kvm_handle_cp15_32,
>>  	[HSR_EC_CP15_64]	= kvm_handle_cp15_64,
>> -	[HSR_EC_CP14_MR]	= kvm_handle_cp14_access,
>> +	[HSR_EC_CP14_MR]	= kvm_handle_cp14_32,
>>  	[HSR_EC_CP14_LS]	= kvm_handle_cp14_load_store,
>> -	[HSR_EC_CP14_64]	= kvm_handle_cp14_access,
>> +	[HSR_EC_CP14_64]	= kvm_handle_cp14_64,
>
> It feels a bit odd to have separate methods at this level, converging
> onto a single one that has to apply separate treatments in
> kvm_handle_cp_{32,64} depending on the CP number. I wonder if it
> wouldn't be nicer to either keep the paths separate entirely, or have a
> single access method that does it all.

I've separated the cp14 and cp15 paths with a light bit of re-factoring
to extract params.

>
>>  	[HSR_EC_CP_0_13]	= kvm_handle_cp_0_13_access,
>>  	[HSR_EC_CP10_ID]	= kvm_handle_cp10_id,
>>  	[HSR_EC_HVC]		= handle_hvc,
>> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
>> index 92678b7bd046..624a510d31df 100644
>> --- a/arch/arm/kvm/hyp/switch.c
>> +++ b/arch/arm/kvm/hyp/switch.c
>> @@ -48,7 +48,9 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu, u32 *fpexc_host)
>>  	write_sysreg(HSTR_T(15), HSTR);
>>  	write_sysreg(HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11), HCPTR);
>>  	val = read_sysreg(HDCR);
>> -	write_sysreg(val | HDCR_TPM | HDCR_TPMCR, HDCR);
>> +	val |= HDCR_TPM | HDCR_TPMCR; /* trap performance monitors */
>> +	val |= HDCR_TDRA | HDCR_TDOSA | HDCR_TDA; /* trap debug regs */
>> +	write_sysreg(val, HDCR);
>>  }
>>
>>  static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>>
>
> Thanks,


Cheers, I'll send v2 soon.

--
Alex Bennée
