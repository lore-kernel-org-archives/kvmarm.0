From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 14/55] KVM: arm64: Take account of system instruction traps
Date: Wed, 22 Feb 2017 12:34:04 +0100
Message-ID: <20170222113404.GI26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-15-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483943091-1364-15-git-send-email-jintack@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:24:10AM -0500, Jintack Lim wrote:
> When HCR.NV bit is set, execution of the EL2 translation regime Address
> Translation instructions and TLB maintenance instructions are trapped to
> EL2. In addition, execution of the EL1 translation regime Address
> Translation instructions and TLB maintenance instructions that are only
> accessible from EL2 and above are trapped to EL2. In these cases,
> ESR_EL2.EC will be set to 0x18.
> 
> Take account of this and handle system instructions as well as MRS/MSR
> instructions in the handler. Change the handler name to reflect this.
> 
> Emulation of those system instructions is to be done.

Is it goint to be done in later patches in this series or left as an
excercise for the reader?

> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/include/asm/kvm_coproc.h |  2 +-
>  arch/arm64/kvm/handle_exit.c        |  2 +-
>  arch/arm64/kvm/sys_regs.c           | 49 ++++++++++++++++++++++++++++++++-----
>  arch/arm64/kvm/trace.h              |  2 +-
>  4 files changed, 46 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
> index 0b52377..1b3d21b 100644
> --- a/arch/arm64/include/asm/kvm_coproc.h
> +++ b/arch/arm64/include/asm/kvm_coproc.h
> @@ -43,7 +43,7 @@ void kvm_register_target_sys_reg_table(unsigned int target,
>  int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
> -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
>  #define kvm_coproc_table_init kvm_sys_reg_table_init
>  void kvm_sys_reg_table_init(void);
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 4e4a915..a891684 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -147,7 +147,7 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
> -	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
> +	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
>  	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4158f2f..202f64d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1903,6 +1903,36 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>  	return 1;
>  }
>  
> +static int emulate_tlbi(struct kvm_vcpu *vcpu,
> +			     struct sys_reg_params *params)
> +{
> +	/* TODO: support tlbi instruction emulation*/
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
> +static int emulate_at(struct kvm_vcpu *vcpu,
> +			     struct sys_reg_params *params)
> +{
> +	/* TODO: support address translation instruction emulation */
> +	kvm_inject_undefined(vcpu);
> +	return 1;
> +}
> +
> +static int emulate_sys_instr(struct kvm_vcpu *vcpu,
> +			     struct sys_reg_params *params)
> +{
> +	int ret;
> +
> +	/* TLB maintenance instructions*/
> +	if (params->CRn == 0b1000)
> +		ret = emulate_tlbi(vcpu, params);
> +	/* Address Translation instructions */
> +	else if (params->CRn == 0b0111 && params->CRm == 0b1000)
> +		ret = emulate_at(vcpu, params);
> +	return ret;
> +}
> +
>  static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
>  			      const struct sys_reg_desc *table, size_t num)
>  {
> @@ -1914,18 +1944,19 @@ static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
>  }
>  
>  /**
> - * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
> + * kvm_handle_sys-- handles a system instruction or mrs/msr instruction trap
> +		    on a guest execution
>   * @vcpu: The VCPU pointer
>   * @run:  The kvm_run struct
>   */
> -int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_handle_sys(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	struct sys_reg_params params;
>  	unsigned long esr = kvm_vcpu_get_hsr(vcpu);
>  	int Rt = (esr >> 5) & 0x1f;
>  	int ret;
>  
> -	trace_kvm_handle_sys_reg(esr);
> +	trace_kvm_handle_sys(esr);
>  
>  	params.is_aarch32 = false;
>  	params.is_32bit = false;
> @@ -1937,10 +1968,16 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	params.regval = vcpu_get_reg(vcpu, Rt);
>  	params.is_write = !(esr & 1);
>  
> -	ret = emulate_sys_reg(vcpu, &params);
> +	if (params.Op0 == 1) {
> +		/* System instructions */
> +		ret = emulate_sys_instr(vcpu, &params);
> +	} else {
> +		/* MRS/MSR instructions */
> +		ret = emulate_sys_reg(vcpu, &params);
> +		if (!params.is_write)
> +			vcpu_set_reg(vcpu, Rt, params.regval);
> +	}
>  
> -	if (!params.is_write)
> -		vcpu_set_reg(vcpu, Rt, params.regval);
>  	return ret;
>  }
>  
> diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
> index 5f40987..192708e 100644
> --- a/arch/arm64/kvm/trace.h
> +++ b/arch/arm64/kvm/trace.h
> @@ -134,7 +134,7 @@
>  	TP_printk("%s %s reg %d (0x%08llx)", __entry->fn,  __entry->is_write?"write to":"read from", __entry->reg, __entry->write_value)
>  );
>  
> -TRACE_EVENT(kvm_handle_sys_reg,
> +TRACE_EVENT(kvm_handle_sys,
>  	TP_PROTO(unsigned long hsr),
>  	TP_ARGS(hsr),
>  
> -- 
> 1.9.1
> 
> 
