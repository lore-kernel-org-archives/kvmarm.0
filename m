Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05349439328
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783523626; cv=none; b=bh7NytpjsthM1mrJVFiFyALH2xZ2WhV97UQMKi355L0SAMEuZPE+uku/YJxrqS4fQWEy8um57j/9uUV7mULe9L4bC+OvKDVeHwiit58+NkAvWkFhXZ0SFGN0YCpILvxCww/gP5+S8ROq17qd9zx5aD9JeimIP9TnR9AzcNh2LGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783523626; c=relaxed/simple;
	bh=KsPnCN5iKtR3Tyf39tnbed0nBIUgL2+cHyPoFgvOS+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jbs3x39hcxk+LmgHhxvBXxjgbel+2tifp8jVaP+jbdiRf6+65J4ZHt/ymmoAyw3mh8cBhBSU0B5BrPtX3A3WLghMIHKQBsBMkb+LPzhClMtjVhF9HA6n/GAYEjtreR9ptUefJAnT2i9/u4Cls4QAqoErpYdPurW2H4VRavHQi1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bc3j9izU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bc3j9izU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CE9E152B;
	Wed,  8 Jul 2026 08:13:39 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E09DD3F66F;
	Wed,  8 Jul 2026 08:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783523623; bh=KsPnCN5iKtR3Tyf39tnbed0nBIUgL2+cHyPoFgvOS+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bc3j9izUpviX6IatkwKRU96CeLl6uZh+YJkdbarL3THb7zXIVe/Emj1TyPom5OXfB
	 x5DD6cjTp2lNyx5Gt+tswereaoWfbfc/MILAc1PTljO0ECmMsXO4G7/OISlMis8Jtb
	 ykZpwidCAERTAn1hhSvDXDK+PS/zTlKeAIafe/b4=
Date: Wed, 8 Jul 2026 16:13:39 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 24/28] KVM: arm64: Engage NV3 ERET trap elision
Message-ID: <20260708151339.GB12293@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-25-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-25-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:44PM +0100, Marc Zyngier wrote:
> When running on NV3 HW, always engage ERET trap elision when running
> the L1 context, as there is no benefit in not doing so.
> 
> An L1 can itself engage trap elision by setting its own view of
> HCRX_EL2.NVTGE==1, which will subsequently be honored.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c      |  4 ++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index c562d8171d5e1..b32870a5e1236 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -706,6 +706,16 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
> +
> +		/*
> +		 * NV3 is a host-specific extension, and we always use it
> +		 * when present and that the guest uses NV. It may be be
> +		 * hidden from the guest though.
> +		 */
> +		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
> +		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_NVTGE;
> +		}
>  	}
>  }
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index c5c06ae41b229..f129f22f15618 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -345,6 +345,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	u64 esr = kvm_vcpu_get_esr(vcpu);
>  	u64 spsr, elr, mode;
>  
> +	/* With NV3, the fast path is handled in HW */
> +	if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
> +		return false;
> +
>  	/*
>  	 * Going through the whole put/load motions is a waste of time
>  	 * if this is a VHE guest hypervisor returning to its own
> -- 
> 2.47.3
> 
