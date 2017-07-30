From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 21/38] KVM: arm64: Set a handler for the system
 instruction traps
Date: Sun, 30 Jul 2017 22:00:15 +0200
Message-ID: <20170730200015.GK5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-22-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FD6C40FB0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:59:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V+-5pyxf2cza for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jul 2017 15:59:05 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 04C7940D16
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:59:04 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id m85so59628145wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 13:00:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1500397144-16232-22-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, marc.zyngier@arm.com, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:47AM -0500, Jintack Lim wrote:
> When HCR.NV bit is set, execution of the EL2 translation regime address
> aranslation instructions and TLB maintenance instructions are trapped to

translation

> EL2. In addition, execution of the EL1 translation regime address
> aranslation instructions and TLB maintenance instructions that are only

translation

> accessible from EL2 and above are trapped to EL2. In these cases,
> ESR_EL2.EC will be set to 0x18.
> 
> Change the existing handler to handle those system instructions as well
> as MRS/MSR instructions.  Emulation of each system instructions will be
> done in separate patches.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_coproc.h |  2 +-
>  arch/arm64/kvm/handle_exit.c        |  2 +-
>  arch/arm64/kvm/sys_regs.c           | 53 ++++++++++++++++++++++++++++++++-----
>  arch/arm64/kvm/trace.h              |  2 +-
>  4 files changed, 50 insertions(+), 9 deletions(-)
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
> index 9259881..d19e253 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -174,7 +174,7 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
> -	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
> +	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
>  	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7062645..dbf5022 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1808,6 +1808,40 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
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
> +	int ret = 0;
> +
> +	/* TLB maintenance instructions*/
> +	if (params->CRn == 0b1000)
> +		ret = emulate_tlbi(vcpu, params);
> +	/* Address Translation instructions */
> +	else if (params->CRn == 0b0111 && params->CRm == 0b1000)
> +		ret = emulate_at(vcpu, params);

there are some style issues here.  I think it would be nicer to do:

	if (x) {
		/* Foo */
		do_something();
	} else if (y) {
		/* Bar */
		do_something_else();
	}

can you remind me why we'd not see any other than these particular two
classes of instructions here?

> +
> +	if (ret)
> +		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +
> +	return ret;
> +}
> +
>  static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
>  			      const struct sys_reg_desc *table, size_t num)
>  {
> @@ -1819,18 +1853,19 @@ static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
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
>  	int Rt = kvm_vcpu_sys_get_rt(vcpu);
>  	int ret;
>  
> -	trace_kvm_handle_sys_reg(esr);
> +	trace_kvm_handle_sys(esr);
>  
>  	params.is_aarch32 = false;
>  	params.is_32bit = false;
> @@ -1842,10 +1877,16 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
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

Thanks,
-Christoffer
