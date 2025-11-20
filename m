Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2451275112
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763649269; cv=none; b=h0VhBzcEthobFA5KhpaujetS7MnYs7sJzBWQsP4vccYNH9M6EnaZyuDTQfiZuE6E152OzixLyY7LrGZsPKvXn3Zl7aMT/ZNFvoK/iB3yoYjmrhwKmjRXuEo/S5USAGNBMIMpUvRd1uG+sTyMDn6f8NgjRVlrigaHoWjvbwjrmIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763649269; c=relaxed/simple;
	bh=pQoPTUlu2GUkilY397z/5eMpaFU7yQbOEPxHhgU9k2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNAzzgrZFNpxVlghFlBpUyxX+WOx6MHpTsp8KV/44fQl5DlYsRFXYY+S63XnGtCfIBd6sosVR+rWvvMD6WHeA1SC4CX/TvpLDmlQIbRVR6XMfFevAr6KkHUJLEpz4+5AUhRc1+kF5Eg481XrMokvZIVFoiXyMreIHc7nI1z8eFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C62BB339;
	Thu, 20 Nov 2025 06:34:18 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F8D63F740;
	Thu, 20 Nov 2025 06:34:24 -0800 (PST)
Date: Thu, 20 Nov 2025 14:34:19 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/5] KVM: arm64: Force trap of GMID_EL1 when the guest
 doesn't have MTE
Message-ID: <20251120143419.GA2325986@e124191.cambridge.arm.com>
References: <20251120133202.2037803-1-maz@kernel.org>
 <20251120133202.2037803-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120133202.2037803-3-maz@kernel.org>

On Thu, Nov 20, 2025 at 01:31:59PM +0000, Marc Zyngier wrote:
> If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
> to force GMID_EL1 being trapped.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 84e6f04220589..40f32b017f107 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5558,6 +5558,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_has_mte(vcpu->kvm))
>  		vcpu->arch.hcr_el2 |= HCR_ATA;
> +	else if (id_aa64pfr1_mte(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1)))
> +		vcpu->arch.hcr_el2 |= HCR_TID5;

This is because we want to enable the trapping regardless of CONFIG_ARM64_MTE
(so we can't use system_supports_mte()).

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

>  
>  	/*
>  	 * In the absence of FGT, we cannot independently trap TLBI
> -- 
> 2.47.3
> 
