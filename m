Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A86C1FBEB0
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754404736; cv=none; b=Nou1uH6dIQtBaYNYp6PhWIZOavSEgKiHqtpkIKzG5Tu5RXeSJtkf+3D9ys8OeiaBoNMBppkxnD1brN2Kan19k/5Uu+c84xivdTZgNmjMdgAyszCOG2wPeMlguJJdN8MXMw1f2gxIDbZkvJ3Kwy5fwymzgtTn0+heChegziYS65Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754404736; c=relaxed/simple;
	bh=fFzCKWdJOEzQHpeFCArObuHdaP3421oaeu4PjzR5Wno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSRgc5oIk/FN0HGQTIA0UgL0quHqVpQWgX5/pbpHjSFoZA+JRsAVcs8seZc7oQNZ4RsNVVyOkuR1wHXmRVJcX0o+2+vvZwVby+yIegoRCUN2DyNnq3Gyt/Qzp1RXJsCY2eK9bnvvZ8AFm5u4wCT1FfISSPlElsgb5dTbfiHQlYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tP9KNPog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tP9KNPog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B059CC4CEF0;
	Tue,  5 Aug 2025 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754404736;
	bh=fFzCKWdJOEzQHpeFCArObuHdaP3421oaeu4PjzR5Wno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tP9KNPog9PH5Q4it44Jn+MXQ8q4z3WLPOJT5fbzXpZ7pHDOrvADIEyYK/chEYUyGt
	 bLz1g+wk4Ue/eLQfso4Cd2nOU4T+q49fnJmtuuw/FKbaSAfhTjnwuqiO/Jxr3v8sls
	 ij/jqq1rdysvwgLzRFO7h23ovvw56IUHIUZRF0KorBdpbbat0ww7WKrBSk5qMmriAk
	 qJodWjbNyL3euUhlOZP0miQmT5gmaAkdl0J7ArypdcgdpLKnlPcG9QCvw6dAEpva2t
	 hWJoIxkBHasqEqWW5zf4fJyB1B5vqCAvxOKAk4jC3WL62qmSusOPBZhuyxpVkZ5V2m
	 Vu39gEGAD69UA==
Date: Tue, 5 Aug 2025 15:38:50 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com,
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v1 2/4] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Message-ID: <aJIXerl04PDah1db@willie-the-truck>
References: <20250805135617.831971-1-tabba@google.com>
 <20250805135617.831971-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805135617.831971-3-tabba@google.com>

On Tue, Aug 05, 2025 at 02:56:15PM +0100, Fuad Tabba wrote:
> Allow vcpu_{read,write}_sys_reg() to be called from EL2. This makes it
> possible for hyp to use existing helper functions to access the vCPU
> context.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 184 +++++++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h    |   3 -
>  arch/arm64/kvm/sys_regs.c            | 184 ---------------------------
>  3 files changed, 184 insertions(+), 187 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 0720898f563e..1f449ef4564c 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -224,6 +224,190 @@ static inline bool vcpu_is_host_el0(const struct kvm_vcpu *vcpu)
>  	return is_hyp_ctxt(vcpu) && !vcpu_is_el2(vcpu);
>  }
>  
> +#define PURE_EL2_SYSREG(el2)						\
> +	case el2: {							\
> +		*el1r = el2;						\
> +		return true;						\
> +	}
> +
> +#define MAPPED_EL2_SYSREG(el2, el1, fn)					\
> +	case el2: {							\
> +		*xlate = fn;						\
> +		*el1r = el1;						\
> +		return true;						\
> +	}
> +
> +static bool get_el2_to_el1_mapping(unsigned int reg,
> +				   unsigned int *el1r, u64 (**xlate)(u64))
> +{

I guess this needs to be 'inline' too, but...

> +static inline u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	u64 val = 0x8badf00d8badf00d;
> +	u64 (*xlate)(u64) = NULL;
> +	unsigned int el1r;
> +
> +	if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
> +		goto memory_read;
> +
> +	if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
> +		if (!is_hyp_ctxt(vcpu))
> +			goto memory_read;
> +
> +		/*
> +		 * CNTHCTL_EL2 requires some special treatment to
> +		 * account for the bits that can be set via CNTKCTL_EL1.
> +		 */
> +		switch (reg) {
> +		case CNTHCTL_EL2:
> +			if (vcpu_el2_e2h_is_set(vcpu)) {
> +				val = read_sysreg_el1(SYS_CNTKCTL);
> +				val &= CNTKCTL_VALID_BITS;
> +				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
> +				return val;
> +			}
> +			break;
> +		}
> +
> +		/*
> +		 * If this register does not have an EL1 counterpart,
> +		 * then read the stored EL2 version.
> +		 */
> +		if (reg == el1r)
> +			goto memory_read;
> +
> +		/*
> +		 * If we have a non-VHE guest and that the sysreg
> +		 * requires translation to be used at EL1, use the
> +		 * in-memory copy instead.
> +		 */
> +		if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
> +			goto memory_read;
> +
> +		/* Get the current version of the EL1 counterpart. */
> +		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
> +		if (reg >= __SANITISED_REG_START__)
> +			val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
> +
> +		return val;
> +	}
> +
> +	/* EL1 register can't be on the CPU if the guest is in vEL2. */
> +	if (unlikely(is_hyp_ctxt(vcpu)))
> +		goto memory_read;
> +
> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
> +		return val;
> +
> +memory_read:
> +	return __vcpu_sys_reg(vcpu, reg);
> +}

... isn't this now pretty huge to be inlining? Similarly for the write
accessor. What does the bloat-o-meter script say?

Will
