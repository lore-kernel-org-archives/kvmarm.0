Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7387253B7B;
	Thu, 15 May 2025 16:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747327574; cv=none; b=gYVvml9Ehd4+PW1quv/lK6mTircOlT8EZ0xfl9y5XZSGn7hYto+2vyyzOsVC2pBkL20/pN+Hei6sC5Ujcfgmajw1VGz9OHxwJnvb4ZFxhem1sOLSsSSNx9FFcTiuCA/jJ1vEg6tsXae4JHIQ1TIoakgVm8a2wHBlIgYu20vfONw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747327574; c=relaxed/simple;
	bh=Ub09ioyJtfYtGJFI4/iSfjy1TdXXfZMx2MejwqwXv3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGr0xuJdUuvy7KlN9GWHphJWLnYMtwbN9OouMx1Gn8H0rtbI8MKrZrbSgR6JJE6tW+NBdLw3B4+17YKXel/y1KnILew/ai0A70lIJd5076tCCrc1p8kbYxHipIHGhQweeI1lT0kBvNcSh5NLd9j/Bu3CpY16cc/4TMRgfyO/ETM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7BMDE+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7BMDE+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E30C4CEE7;
	Thu, 15 May 2025 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747327574;
	bh=Ub09ioyJtfYtGJFI4/iSfjy1TdXXfZMx2MejwqwXv3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7BMDE+Ha0N0njQiGB9sncd1ok8bX9gjrBUHDRz6umQInfj0eYwLZ9MczEqQzG6l/
	 8AV5p6ro7qJVP6s4yp6ukh2MWumgay40c2pKQEsYK0YRuFawUx6gzf0EVKZWL1Wwfn
	 uAHU26cF+19xUBGSnZuBS5dFOzCzdXCUQjSEPTogTlwPXkO3CTp00W3XZ3I9dfelkl
	 GR8wY1lggo/Awp/+3Rr1HaHG4uHSw3mePGlGVLaieCk9Cq7KnowewCEb4jwL/Jqp6p
	 V0TxSI5F3IYx9ALDrJV9EgS7oRDhiINgsQogOAhbqyeRLL2gtNjoEriasuHNWoFg/X
	 wNLiuF45Zp6Mw==
Date: Thu, 15 May 2025 17:46:06 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, sebastianene@google.com,
	lpieralisi@kernel.org, arve@android.com, qwandor@google.com,
	kernel-team@android.com, armellel@google.com, perl@immunant.com,
	jean-philippe@linaro.org, ahomescu@google.com, tabba@google.com,
	qperret@google.com, james.morse@arm.com
Subject: Re: [PATCH v3 3/3] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Message-ID: <20250515164606.GB12396@willie-the-truck>
References: <20250513-virtio-msg-ffa-v3-0-d66c76ff1b2c@google.com>
 <20250513-virtio-msg-ffa-v3-3-d66c76ff1b2c@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513-virtio-msg-ffa-v3-3-d66c76ff1b2c@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, May 13, 2025 at 06:28:32AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
> the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
> uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
> argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
> in the host ffa handler.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> Signed-off-by: Per Larsen <perl@immunant.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 111 +++++++++++++++++++++++++++++++++++++++++-
>  include/linux/arm_ffa.h       |   2 +
>  2 files changed, 111 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 403fde6ca4d6ec49566ef60709cedbaef9f04592..437289aa5d902b0d2a4a8760403f0190f2320813 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -79,6 +79,14 @@ static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>  	};
>  }
>  
> +static void ffa_to_smccc_1_2_error(struct arm_smccc_1_2_regs *regs, u64 ffa_errno)
> +{
> +	*regs = (struct arm_smccc_1_2_regs) {
> +		.a0	= FFA_ERROR,
> +		.a2	= ffa_errno,
> +	};
> +}
> +
>  static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
>  {
>  	if (ret == FFA_RET_SUCCESS) {
> @@ -89,11 +97,25 @@ static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
>  	}
>  }
>  
> +static void ffa_to_smccc_1_2_regs_prop(struct arm_smccc_1_2_regs *regs, int ret, u64 prop)
> +{
> +	if (ret == FFA_RET_SUCCESS)
> +		*regs = (struct arm_smccc_1_2_regs) { .a0 = FFA_SUCCESS,
> +						      .a2 = prop };
> +	else
> +		ffa_to_smccc_1_2_error(regs, ret);
> +}
> +
>  static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
>  {
>  	ffa_to_smccc_res_prop(res, ret, 0);
>  }
>  
> +static void ffa_to_smccc_1_2_regs(struct arm_smccc_1_2_regs *regs, int ret)
> +{
> +	ffa_to_smccc_1_2_regs_prop(regs, ret, 0);
> +}
> +
>  static void ffa_set_retval(struct kvm_cpu_context *ctxt,
>  			   struct arm_smccc_res *res)
>  {
> @@ -131,6 +153,29 @@ static void ffa_set_retval(struct kvm_cpu_context *ctxt,
>  	}
>  }
>  
> +static void ffa_set_retval_smccc_1_2(struct kvm_cpu_context *ctxt,
> +			   struct arm_smccc_1_2_regs *regs)
> +{
> +	cpu_reg(ctxt, 0) = regs->a0;
> +	cpu_reg(ctxt, 1) = regs->a1;
> +	cpu_reg(ctxt, 2) = regs->a2;
> +	cpu_reg(ctxt, 3) = regs->a3;
> +	cpu_reg(ctxt, 4) = regs->a4;
> +	cpu_reg(ctxt, 5) = regs->a5;
> +	cpu_reg(ctxt, 6) = regs->a6;
> +	cpu_reg(ctxt, 7) = regs->a7;
> +	cpu_reg(ctxt, 8) = regs->a8;
> +	cpu_reg(ctxt, 9) = regs->a9;
> +	cpu_reg(ctxt, 10) = regs->a10;
> +	cpu_reg(ctxt, 11) = regs->a11;
> +	cpu_reg(ctxt, 12) = regs->a12;
> +	cpu_reg(ctxt, 13) = regs->a13;
> +	cpu_reg(ctxt, 14) = regs->a14;
> +	cpu_reg(ctxt, 15) = regs->a15;
> +	cpu_reg(ctxt, 16) = regs->a16;
> +	cpu_reg(ctxt, 17) = regs->a17;
> +}
> +
>  /* Call SMC64 using SMCCC 1.2 if hyp negotiated FF-A 1.2 falling back to 1.1 */
>  static void arm_smccc_1_x_smc(u64 func_id, u64 a1, u64 a2, u64 a3,
>  			      u64 a4, u64 a5, u64 a6, u64 a7,
> @@ -686,7 +731,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_NOTIFICATION_GET:
>  	case FFA_NOTIFICATION_INFO_GET:
>  	/* Unimplemented interfaces added in FF-A 1.2 */
> -	case FFA_MSG_SEND_DIRECT_REQ2:
>  	case FFA_MSG_SEND_DIRECT_RESP2:
>  	case FFA_CONSOLE_LOG:
>  	case FFA_PARTITION_INFO_GET_REGS:
> @@ -697,6 +741,21 @@ static bool ffa_call_supported(u64 func_id)
>  	return true;
>  }
>  
> +/*
> + * Must a given FFA function use the SMC calling convention v1.2?
> + */
> +static bool ffa_call_needs_smccc_1_2(u64 func_id)
> +{
> +	switch (func_id) {
> +	case FFA_MSG_SEND_DIRECT_REQ2:
> +	case FFA_MSG_SEND_DIRECT_RESP2:
> +	case FFA_PARTITION_INFO_GET_REGS:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  static bool do_ffa_features(struct arm_smccc_res *res,
>  			    struct kvm_cpu_context *ctxt)
>  {
> @@ -855,9 +914,47 @@ static void do_ffa_part_get(struct arm_smccc_res *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
> +			       struct kvm_cpu_context *ctxt,
> +			       u64 vm_handle)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	DECLARE_REG(u32, endp, ctxt, 1);
> +	DECLARE_REG(u64, uuid_lo, ctxt, 2);
> +	DECLARE_REG(u64, uuid_hi, ctxt, 3);
> +	DECLARE_REG(u64, x4, ctxt, 4);
> +	DECLARE_REG(u64, x5, ctxt, 5);
> +	DECLARE_REG(u64, x6, ctxt, 6);
> +	DECLARE_REG(u64, x7, ctxt, 7);
> +	DECLARE_REG(u64, x8, ctxt, 8);
> +	DECLARE_REG(u64, x9, ctxt, 9);
> +	DECLARE_REG(u64, x10, ctxt, 10);
> +	DECLARE_REG(u64, x11, ctxt, 11);
> +	DECLARE_REG(u64, x12, ctxt, 12);
> +	DECLARE_REG(u64, x13, ctxt, 13);
> +	DECLARE_REG(u64, x14, ctxt, 14);
> +	DECLARE_REG(u64, x15, ctxt, 15);
> +	DECLARE_REG(u64, x16, ctxt, 16);
> +	DECLARE_REG(u64, x17, ctxt, 17);
> +
> +	if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != vm_handle) {
> +		ffa_to_smccc_1_2_regs(regs, FFA_RET_INVALID_PARAMETERS);

Just call ffa_to_smccc_1_2_error() here?

> +		return;
> +	}
> +
> +	struct arm_smccc_1_2_regs args = {
> +		func_id, endp, uuid_lo, uuid_hi,
> +		 x4,  x5,  x6,  x7,  x8,  x9, x10,
> +		x11, x12, x13, x14, x15, x16, x17
> +	};
> +
> +	arm_smccc_1_2_smc(&args, regs);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_res res;
> +	struct arm_smccc_1_2_regs regs;
>  
>  	/*
>  	 * There's no way we can tell what a non-standard SMC call might
> @@ -913,14 +1010,24 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_MSG_SEND_DIRECT_REQ2:
> +		if (ffa_get_hypervisor_version() >= FFA_VERSION_1_2) {
> +			do_ffa_direct_msg2(&regs, host_ctxt, HOST_FFA_ID);
> +			goto out_handled;
> +		}
> +		goto out_not_supported;
>  	}
>  
>  	if (ffa_call_supported(func_id))
>  		return false; /* Pass through */
>  
> +out_not_supported:
>  	ffa_to_smccc_error(&res, FFA_RET_NOT_SUPPORTED);
>  out_handled:
> -	ffa_set_retval(host_ctxt, &res);
> +	if (ffa_call_needs_smccc_1_2(func_id))

Could we push this check lower down? The host_ctxt contains the func_id,
so we could (a) stop taking it as an extra parameter to
kvm_host_psci_handler() and kvm_host_ffa_handler(), (b) add a helper to
extract it and (c) ffa_set_retval() could handle the registers
appropriately to the call.

Will
