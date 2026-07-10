Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED8C24677B
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783693481; cv=none; b=DRLb3lQtQ+1w/p2+Iy2NY0nhs4f8mr6M/tH7MpgxCLXxqELlJMHUmu2ci1qZSUFXT3kBF25T/VUPm6TXPa+8kJg8W9zoILs1GqnW2pmRnURkk7dxWPpKecDXymIpcd6NPyCGqE54JDdAULyxVgOAXHag16McFAEVXJxj1Frcu2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783693481; c=relaxed/simple;
	bh=57yy5wTX9Ho7bi/LUfyKbKgFguqEUaBdyCNXSxpomDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxaGJROJAoMYVXcWrqfWRwEgIGE/smy6Wec9Kgjml8GPpDB+zbQ5+y5jOmt0rLAc32Ouk+pjy5qPYAdUhn8QyLRGi2vAG2/3IqVG5I10F3RGsY092sem+0OgeazS4n6MXyfp1+RJ7F7lxaKddhR7YcEX5JStV69ShlKCLm+B2jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KDnsVFPm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KDnsVFPm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B967176A;
	Fri, 10 Jul 2026 07:24:34 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72CA23F7B4;
	Fri, 10 Jul 2026 07:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783693478; bh=57yy5wTX9Ho7bi/LUfyKbKgFguqEUaBdyCNXSxpomDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KDnsVFPm01cedCI0/W1Ov+nbDD+1CVJd5UTLnCY0bXSpzfghDgwZjWbC4VNF/nwbR
	 Sw6NUD/64kRr4B57VVC9r61PBA4BnXdMfvEAXl7Vv2thWhBX1vyo6aIqWlg2EtNB6T
	 yjCYS77HwzB9up7X1ro8yvb8QBGSGCEPVfpgKS8k=
Date: Fri, 10 Jul 2026 15:24:34 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Message-ID: <20260710142434.GC12293@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-28-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-28-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:47PM +0100, Marc Zyngier wrote:
> Further enable FEAT_NV3 by making it visible to NV guests.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/nested.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c9bf04944f9cb..64c8fb82fadf6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1728,7 +1728,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  		 * You get EITHER
>  		 *
>  		 * - FEAT_VHE without FEAT_E2H0
> -		 * - FEAT_NV limited to FEAT_NV2(p1)
> +		 * - FEAT_NV limited to FEAT_NV2(p1)/NV3
>  		 * - HCR_EL2.NV1 being RES0
>  		 *
>  		 * OR
> @@ -1740,7 +1740,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
>  			val = 0;
>  		} else {
> -			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			if (cpus_have_final_cap(ARM64_HAS_NV3))
> +				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);
> +			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))
>  				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
>  			else
>  				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
> -- 
> 2.47.3
> 
