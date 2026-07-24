Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D98137FF41
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873224; cv=none; b=OmG7QY4/l4i42dtqfO3eZUBXBcPifKaCHw2GcrUjNdHRs7UOgSjIqWj9TYbqzD+Y3wktHelwKU+YcGSE76i/tBEsKAK8RXtIDakVYOQnVxA9OMSVtxy1ZkDXx4QE76ohSE2tn4NSBmJfmH+0Mkls+KqqBfp2GigXGv02AEIR3QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873224; c=relaxed/simple;
	bh=zB4Ja/fTNI+vcdJUlEPJI6rcF4URLJQvE9A8oqDdva8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ayr4Cojz4sBIhdHNBBq2uGjotDOdbVGyN6h+4ZTiiE9l/ffNWPxQvQ0KNDjs7DtEMuIl32urnG32/IiiKBtPYvqiNyLgyhQ6CJb+jZYhBG05YLfM5fV2a1dpWdBtbeG66r6BqIWvELVgNE98IS+pm5yjP7q7f4LvtWVSONX5Y3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lgewS5ny; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lgewS5ny"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784873209; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=nBJPCq06j/mROJ1z/tUYXDZdGERXJLKDUkBXfllJZzs=;
	b=lgewS5nyOHVfZruHtWK4HbLzba4MlPl6RIs8hRCHxykUUKh+fgQaVOPpx9gs2weR6mKBVwFio1EUPhfwYcBDe5dXD5zEH3bPMEzW5ZL7WcFQXI1JPtMg/UZa4ds2TGdulMNjw7ao30FLrsi6YoJFj+uf4HlfIIo9YjwKKX4eLDM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7i9haS_1784873208;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7i9haS_1784873208 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 14:06:48 +0800
Date: Fri, 24 Jul 2026 14:06:48 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 09/28] KVM: arm64: Relax CPTR_EL2 handling when
 FEAT_NV2p1 is present
Message-ID: <itfuntllavrtihse3vgrrmiamhiduyegqxh6i5mhwg65m5rcmn@a4465gauamq2>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-10-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:15AM +0800, Marc Zyngier wrote:
> With FEAT_NV2P1, it is no longer necessary to trap CPTR_EL2 accesses
> via CPACR_EL1, as CPACR_EL1.TCPAC is guaranteed to be stateful.
>
> Prevent such trapping and context switch CPACTR_EL1 in NV contexts
> when NV2P1 is present.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 5 +++--
>  arch/arm64/kvm/hyp/vhe/switch.c         | 3 +++
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c      | 8 +++++---
>  arch/arm64/kvm/sys_regs.c               | 5 ++++-
>  4 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8e5f492f39086..7b27296c94607 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -108,9 +108,10 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
>  	 * The architecture is a bit crap (what a surprise): an EL2 guest
>  	 * writing to CPTR_EL2 via CPACR_EL1 can't set any of TCPAC or TTA,
>  	 * as they are RES0 in the guest's view. To work around it, trap the
> -	 * sucker using the very same bit it can't set...
> +	 * sucker using the very same bit it can't set. FEAT_NV2p1 fixes it.
>  	 */
> -	if (vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
> +	if (!cpus_have_final_cap(ARM64_HAS_NV2P1) &&
> +	    vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
>  		val |= CPTR_EL2_TCPAC;
>
>  	/*
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 684cebf23aa0e..a8da40568a048 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -443,6 +443,9 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	u64 esr = kvm_vcpu_get_esr(vcpu);
>  	int rt;
>
> +	if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +		return false;
> +
>  	if (!is_hyp_ctxt(vcpu) || esr_sys64_to_sysreg(esr) != SYS_CPACR_EL1)
>  		return false;
>
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index be685b63e8cf2..6f0f046e4ca4e 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -42,10 +42,12 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
>  		u64 val;
>
>  		/*
> -		 * We don't save CPTR_EL2, as accesses to CPACR_EL1
> -		 * are always trapped, ensuring that the in-memory
> -		 * copy is always up-to-date. A small blessing...
> +		 * Without FEAT_NV2p1, we don't save CPTR_EL2, as accesses
> +		 * to CPACR_EL1 are always trapped, ensuring that the
> +		 * in-memory copy is always up-to-date. A small blessing...
>  		 */
> +		if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			__vcpu_assign_sys_reg(vcpu, CPTR_EL2, read_sysreg_el1(SYS_CPACR));
>  		__vcpu_assign_sys_reg(vcpu, SCTLR_EL2,	 read_sysreg_el1(SYS_SCTLR));
>  		__vcpu_assign_sys_reg(vcpu, TTBR0_EL2,	 read_sysreg_el1(SYS_TTBR0));
>  		__vcpu_assign_sys_reg(vcpu, TTBR1_EL2,	 read_sysreg_el1(SYS_TTBR1));
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6b47d936efb32..1dfc1f88bec82 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -326,7 +326,10 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
>  			val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
>  			return val;
>  		case CPTR_EL2:
> -			return __vcpu_sys_reg(vcpu, reg);
> +			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +				return read_sysreg_el1(SYS_CPACR);
> +			else
> +				return __vcpu_sys_reg(vcpu, reg);

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  		default:
>  			WARN_ON_ONCE(1);
>  		}
> --
> 2.47.3
