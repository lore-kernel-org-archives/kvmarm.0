From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH 2/2] arm64: KVM: Do not update PC if the trap handler has
 updated it
Date: Tue, 22 Dec 2015 18:15:54 +0800
Message-ID: <567922DA.3090107@linaro.org>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
 <1450778118-12715-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 143C14130B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 05:13:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wFOn0kYOVE2c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 05:13:22 -0500 (EST)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
 [209.85.220.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A6A8410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 05:13:21 -0500 (EST)
Received: by mail-pa0-f41.google.com with SMTP id q3so94632329pav.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 02:16:04 -0800 (PST)
In-Reply-To: <1450778118-12715-3-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/22 17:55, Marc Zyngier wrote:
> Assuming we trap a system register, and decide that the access is
> illegal, we will inject an exception in the guest. In this
> case, we shouldn't increment the PC, or the vcpu will miss the
> first instruction of the handler, leading to a mildly confused
> guest.
> 
> Solve this by snapshoting PC before the access is performed,
> and checking if it has moved or not before incrementing it.
> 
Thanks a lot. This solves the problem of guest PMU failing to inject EL1
fault to guest.

Tested-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Shannon Zhao <shannon.zhao@linaro.org>

> Reported-by: Shannon Zhao <shannon.zhao@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 73 +++++++++++++++++++++++------------------------
>  1 file changed, 36 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d2650e8..9c87e0c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -966,6 +966,39 @@ static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
>  	return NULL;
>  }
>  
> +/* Perform the sysreg access, returns 0 on success */
> +static int access_sys_reg(struct kvm_vcpu *vcpu,
> +			  struct sys_reg_params *params,
> +			  const struct sys_reg_desc *r)
> +{
> +	u64 pc = *vcpu_pc(vcpu);
> +
> +	if (unlikely(!r))
> +		return -1;
> +
> +	/*
> +	 * Not having an accessor means that we have configured a trap
> +	 * that we don't know how to handle. This certainly qualifies
> +	 * as a gross bug that should be fixed right away.
> +	 */
> +	BUG_ON(!r->access);
> +
> +	if (likely(r->access(vcpu, params, r))) {
> +		/*
> +		 * Skip the instruction if it was emulated without PC
> +		 * having changed. This allows us to detect a fault
> +		 * being injected (incrementing the PC here would
> +		 * cause the vcpu to skip the first instruction of its
> +		 * fault handler).
> +		 */
> +		if (pc == *vcpu_pc(vcpu))
> +			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +		return 0;
> +	}
> +
> +	return -1;
> +}
> +
>  int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	kvm_inject_undefined(vcpu);
> @@ -994,26 +1027,7 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
>  
>  	r = find_reg(params, table, num);
>  
> -	if (r) {
> -		/*
> -		 * Not having an accessor means that we have
> -		 * configured a trap that we don't know how to
> -		 * handle. This certainly qualifies as a gross bug
> -		 * that should be fixed right away.
> -		 */
> -		BUG_ON(!r->access);
> -
> -		if (likely(r->access(vcpu, params, r))) {
> -			/* Skip instruction, since it was emulated */
> -			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -		}
> -
> -		/* Handled */
> -		return 0;
> -	}
> -
> -	/* Not handled */
> -	return -1;
> +	return access_sys_reg(vcpu, params, r);
>  }
>  
>  static void unhandled_cp_access(struct kvm_vcpu *vcpu,
> @@ -1178,27 +1192,12 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>  	if (!r)
>  		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
>  
> -	if (likely(r)) {
> -		/*
> -		 * Not having an accessor means that we have
> -		 * configured a trap that we don't know how to
> -		 * handle. This certainly qualifies as a gross bug
> -		 * that should be fixed right away.
> -		 */
> -		BUG_ON(!r->access);
> -
> -		if (likely(r->access(vcpu, params, r))) {
> -			/* Skip instruction, since it was emulated */
> -			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> -			return 1;
> -		}
> -		/* If access function fails, it should complain. */
> -	} else {
> +	if (access_sys_reg(vcpu, params, r)) {
>  		kvm_err("Unsupported guest sys_reg access at: %lx\n",
>  			*vcpu_pc(vcpu));
>  		print_sys_reg_instr(params);
> +		kvm_inject_undefined(vcpu);
>  	}
> -	kvm_inject_undefined(vcpu);
>  	return 1;
>  }
>  
> 

-- 
Shannon
