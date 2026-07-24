Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA223A5E7A
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 08:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784880618; cv=none; b=SqmEc75tVDM059pakzmdfUi4QgYO4XXa1/QOUqMitbtJ8MBSVOkr4yR2Qn9ZAX/J6tt33t1P5f4/bgtx5nAnkM3fFsmiS/kAlj6xDybmUEdSwCjmj/RUmBuZ3+mOvKJCcO7lU5fDhzxmi3tOfm2/zGN04jWgNN39OkKRzA7rkIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784880618; c=relaxed/simple;
	bh=W61NpeYtZobY8CWcAeg2oKDy3dzF6J40+e5P3y7D1CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nE6UF34IYJ7g0zxfjy8X5IzrsEzLEn7oVG3flbUMRkpymXw7SpQLLNST51heka/ET2wD7P/NZN8lNrWxaxT9QC+8B62uPenpzLZfpgVN6QfvboTglFyFj2xlS8f/khVqyb0Lv0prhgoH2PfKOsfQ61atNYBx4ilWobkv67DM3Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vQR+Sv0P; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vQR+Sv0P"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784880612; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=tc2VYYqrq42W/5SGTHQcpL32EmlWmR6pet5QVyrl61U=;
	b=vQR+Sv0Ps7CCX8dstyyNC+jwg4yqwiSmbt6PWsV1U5w6ne1cl4Zgk2wQdZkjip/VG6YWpnRJ77+Qu8dbNPcN4KEIANFGwNUazX2EHOZdgB0qtaExVTUVHYHET8IVCYr+csNVBB9WrkUiMD33CUNb8pfcwSSp+iZXJ4sQ8BlL6PE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7iVo7m_1784880611;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7iVo7m_1784880611 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 16:10:11 +0800
Date: Fri, 24 Jul 2026 16:10:10 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 23/28] KVM: arm64: Add NVHCR_EL2 context switching
Message-ID: <yxrqmwrf5uwsf7a7g2rtdpamrl7m2tjfpuo4kqizqocmi4c3rf@cfcvhsur23jj>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-24-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-24-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:29AM +0800, Marc Zyngier wrote:
> Since NVHCR_EL2 represents the HCR_EL2 state of the EL1 guest, it
> must be dealt with in some particular way:
>
> - for a guest in hyp context (an L1 by definition), NVHCR_EL2 directly
>   reflects HCR_EL2 as read and written by the guest itself. It must
>   therefore be eagerly synced back with the emulation code which only
>   knows about HCR_EL2. This is unconditional if NV3 is available on
>   the host.
>
> - For an L2 guest, NVHCR_EL2 is controlled by the L1 guest, and we
>   just context switch it like any other EL1 register. Yes, EL1, as
>   that's where this thing runs from the PoV of L1. This is conditioned
>   on the guest using NV3.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 11 +++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c            | 10 ++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de9..c382848d31947 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -172,6 +172,10 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>
>  	if (ctxt_has_sctlr2(ctxt))
>  		ctxt_sys_reg(ctxt, SCTLR2_EL1) = read_sysreg_el1(SYS_SCTLR2);
> +
> +	/* Retrieve L2's HCR_EL2, and save it for future use */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		ctxt_sys_reg(ctxt, NVHCR_EL2) = read_sysreg_s(SYS_NVHCR_EL2);
>  }
>
>  static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
> @@ -285,6 +289,13 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
>
>  	if (ctxt_has_sctlr2(ctxt))
>  		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR2_EL1), SYS_SCTLR2);
> +
> +	/*
> +	 * Publish the L2 view of HCR_EL2 to the HW if L1 is using NV3.
> +	 * Otherwise, the data is already in place in the L1's own VNCR.
> +	 */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);
>  }
>
>  /* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index e5a51dc3cbe5e..cbda9e087db39 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -71,7 +71,10 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  			hcr |= HCR_NV1;
>
>  		/* Publish the guest's view of HCR_EL2 to the HW */
> -		__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
> +		if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
> +			write_sysreg_s(__vcpu_sys_reg(vcpu, HCR_EL2), SYS_NVHCR_EL2);
> +		else
> +			__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
>
>  		/*
>  		 * Nothing in HCR_EL2 should impact running in hypervisor
> @@ -567,7 +570,10 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
>  		*vcpu_cpsr(vcpu) |= mode;
>
>  		/* Publish the latest HCR_EL2 to the emulation */
> -		hcr = __vcpu_sys_reg(vcpu, NVHCR_EL2);
> +		hcr = (cpus_have_final_cap(ARM64_HAS_NV3) &&
> +		       vcpu_el2_e2h_is_set(vcpu)) ?
> +			read_sysreg_s(SYS_NVHCR_EL2) :
> +			__vcpu_sys_reg(vcpu, NVHCR_EL2);

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
>  		__vcpu_assign_sys_reg(vcpu, HCR_EL2, hcr);
>  	}
> --
> 2.47.3
