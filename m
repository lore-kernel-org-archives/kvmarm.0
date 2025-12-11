Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF44229B38
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 20:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765485368; cv=none; b=fmUtr1bYwTNg7ufHVUfW5Th3eUx+hWNAynbV3gmBR39gMSJne6hGanujnMSM5k6glUGz37cBAHR2z+pwEnpoCUbZjwoziXAd4PldaVsChZHEalUUunffcIqu6ICQ8CrTC2Hf2oCHvtnezq3OFMUn2AF8zCAaGNqeK0L2OV8BNf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765485368; c=relaxed/simple;
	bh=TO+xTEZtUGaXTld4LG2GnHGUoSmoCf2h0b5koSopinM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTJppfLmty/kW9Ym2yJJa9PkTnKW9qgw/885qdNllQYRxUllTnO65N+mFlxhYGBUOatppSf74p94nvKClVgBK77wTo2Yoh+C4onsRKBxQ2XkVLalgB8aeT9J5vSklj3Vud6Gcz6SbTM/GA93ap9x7dM/K88TuOs7IaGa661PsXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBGZst/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBGZst/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDFBC4CEF7;
	Thu, 11 Dec 2025 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765485367;
	bh=TO+xTEZtUGaXTld4LG2GnHGUoSmoCf2h0b5koSopinM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oBGZst/ilIfa32pv/f1maIimQrN4KhqcdqAsyg5OHp7Gotp+q4b33pXmqjBpWblaK
	 J7qDcPr46lXT9xjl9FJMZUNDUHPVOT3ynebl/qwt0X13wO0b2ZSJBJccJpF5JU6r71
	 pgLN2dgmHQXFnJ11Ir6YNSoFNVkJ9xng5VLSE4wUOPyvaLTK+0gchN9bjd5eNpkdCw
	 ab3r5oZvbmaAfQbwOejWse6375/iRhLjazFkf3yoOujZ3AUOmGUMWvFmMYfA0XAcBM
	 1WkbvVBZktv+wEer+ESo3GHvS2nJsV8sWaRx5K+p8EU2MKMYTAExvYlKwYhdTtTOno
	 4VDvrxAb5DyFg==
Date: Fri, 12 Dec 2025 05:36:01 +0900
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	tabba@google.com
Subject: Re: [PATCH 1/2] KVM: arm64: Copy FGT traps to unprotected pKVM VCPU
 on VCPU load
Message-ID: <aTsrMUGan1AH5suO@google.com>
References: <20251210132102.137631-1-alexandru.elisei@arm.com>
 <20251210132102.137631-2-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210132102.137631-2-alexandru.elisei@arm.com>

Hey Alexandru,

[+Fuad as we ran into this last week]

On Wed, Dec 10, 2025 at 01:21:01PM +0000, Alexandru Elisei wrote:
> Commit fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
> introduced per-VCPU FGT traps. For an unprotected pKVM VCPU, the untrusted
> host FGT configuration is copied in pkvm_vcpu_init_traps(), which is called
> from __pkvm_init_vcpu(). __pkvm_init_vcpu() is called once per VCPU (when
> the VCPU is first run) which means that the uninitialized, zero, values for
> the FGT registers end up being used for the entire lifetime of the VCPU.
> This causes both unwanted traps (for the inverse polarity trap bits) and
> the guest being allowed to access registers it shouldn't.
> 
> Fix it by copying the FGT traps for unprotected pKVM VCPUs when the
> untrusted host loads the VCPU.
> 
> Fixes: fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  1 -
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 29430c031095..ee0f1343100c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -167,6 +167,7 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
>  	DECLARE_REG(unsigned int, vcpu_idx, host_ctxt, 2);
>  	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
>  	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *hyp_kvm_vcpu;
>  
>  	if (!is_protected_kvm_enabled())
>  		return;
> @@ -175,10 +176,17 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
>  	if (!hyp_vcpu)
>  		return;
>  
> +	hyp_kvm_vcpu = &hyp_vcpu->vcpu;
> +
>  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		/* Propagate WFx trapping flags */
> -		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
> -		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
> +		hyp_kvm_vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
> +		hyp_kvm_vcpu->arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);

I don't think the 'hyp_kvm_vcpu' really makes this much clearer and it's
the line only ends up being a single character shorter. Just continue to
use 'hyp_vcpu->vcpu.'?

> +	} else {
> +		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> +
> +		memcpy(&hyp_kvm_vcpu->arch.fgt, host_vcpu->arch.fgt,
> +		       sizeof(hyp_kvm_vcpu->arch.fgt));
>  	}
>  }
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 43bde061b65d..05774aed09cb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -172,7 +172,6 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
>  
>  		/* Trust the host for non-protected vcpu features. */
>  		vcpu->arch.hcrx_el2 = host_vcpu->arch.hcrx_el2;
> -		memcpy(vcpu->arch.fgt, host_vcpu->arch.fgt, sizeof(vcpu->arch.fgt));
>  		return 0;
>  	}

Otherwise, looks good to me:

Acked-by: Will Deacon <will@kernel.org>

Will
