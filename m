Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC333054F2
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 23:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762557139; cv=none; b=aKshXgVn8sBbUypGHrCC49Yxp5rRdDxBdF7I0Tt8kNZ1CQTU+yRePppu1nDfFiKl0wolkdFo2GWXWilCf4aRAZylStKJ0U2oXAs5yh+QDfm49Sxk0AjQMODfNHFS5orcsGpyynOS9KX2zg/ImCREqfWVaY5xRo26aEhof10bZfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762557139; c=relaxed/simple;
	bh=B0AHPl2PuZVRK5tNUjTCgltSSw3SvWwui8ypfs0L1Bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJCoiqIZBRLNAxVs6Vs1wOGxIlliRsXI+wtEGpLk10OHD9NPVal4hQokyUC05U2aYHBw1UhoZs2btdXkPYjiot7Z4GSzEsDlUz9Y9lGeI7yxhU5/OfGYr2ZuVIakdhk9oqWWBuzmvXYjYZ/HnDXLjTtULGJSGRnmo/7OZa5PQuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pR1paCW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pR1paCW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D1CC19422;
	Fri,  7 Nov 2025 23:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762557139;
	bh=B0AHPl2PuZVRK5tNUjTCgltSSw3SvWwui8ypfs0L1Bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pR1paCW0yy1ljJ/PJey7H4gvzNzun7TU/nG39UXNM9qpH/AbmbkLBGrkhNaFJU2+m
	 65lf8lfc5Fb9C9ih1kF5S/R3KK0jO2WMSYsd3nTq5m3jODKkIIKG7d0FlMQ5A1PQ4I
	 tjyINcHKBmnviErAiQdE6Tb7vQs+1R0/JnrViPlLDsnVYZ+vP6imooi9jpGbsZoQBm
	 rr0bXyYbdokB51EoaE5Kil5+0bsWAMS4PnE/w6oNljI7vGdbDkVu2NVAgAE0ASOUJW
	 dF8bkNVSEEfXGyhi1HZUpaYkosV1ix/N3qEGDlq/MoiQYn5/YQob4mKT1QJk7aBV6K
	 xkI/xnTTE0WIw==
Date: Fri, 7 Nov 2025 15:12:17 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vladimir.murzin@arm.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: Define FAR_MASK for fault IPA offset
Message-ID: <aQ580W6SU1lGbd_D@kernel.org>
References: <20251106144418.2847443-1-tabba@google.com>
 <20251106144418.2847443-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106144418.2847443-6-tabba@google.com>

On Thu, Nov 06, 2025 at 02:44:17PM +0000, Fuad Tabba wrote:
> This 12-bit FAR mask is hard-coded as 'GENMASK(11, 0)' in several places
> to reconstruct the full fault IPA.
> 
> Define FAR_MASK for this value in the shared header and replace all
> open-coded instances to improve readability.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h         | 2 ++
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 2 +-
>  arch/arm64/kvm/inject_fault.c            | 2 +-
>  arch/arm64/kvm/mmu.c                     | 4 ++--
>  4 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 1da290aeedce..e995e9b3a0c4 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -343,6 +343,8 @@
>  #define PAR_TO_HPFAR(par)		\
>  	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
>  
> +#define FAR_MASK GENMASK_ULL(11, 0)
> +

This seems really confusing to me, since FAR_MASK sounds like it
represents the meaningful bits of FAR_ELx. Perhaps something like the
following would better represent intent:

#define FAR_TO_FIPA_OFFSET(far)	((far) & GENMASK_ULL(11, 0))

Thanks,
Oliver

>  #define ECN(x) { ESR_ELx_EC_##x, #x }
>  
>  #define kvm_arm_exception_class \
> diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> index 78579b31a420..22898ed4dd6f 100644
> --- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> +++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
> @@ -44,7 +44,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  
>  	/* Build the full address */
>  	fault_ipa  = kvm_vcpu_get_fault_ipa(vcpu);
> -	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
>  
>  	/* If not for GICV, move on */
>  	if (fault_ipa <  vgic->vgic_cpu_base ||
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index dfcd66c65517..8ef3453696a2 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -258,7 +258,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
>  	unsigned long addr, esr;
>  
>  	addr  = kvm_vcpu_get_fault_ipa(vcpu);
> -	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +	addr |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
>  
>  	__kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu), addr);
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7cc964af8d30..21a9442f9b1e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1959,7 +1959,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  
>  		/* Falls between the IPA range and the PARange? */
>  		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
> -			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
>  
>  			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
>  		}
> @@ -2059,7 +2059,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		 * faulting VA. This is always 12 bits, irrespective
>  		 * of the page size.
>  		 */
> -		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +		ipa |= kvm_vcpu_get_hfar(vcpu) & FAR_MASK;
>  		ret = io_mem_abort(vcpu, ipa);
>  		goto out_unlock;
>  	}
> -- 
> 2.51.2.1041.gc1ab5b90ca-goog
> 
