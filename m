Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2BE1EDA1B
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738952484; cv=none; b=p5RROoLUfOaZfgQosySNXMxBRKjPMp906kCKHEqv38WQZIXHvgAOfSMuEypAQd+P87+uqu6FE+bV1dQx7JDqjbJe3bXz++yUHH3tFLcvME1kejzyF8Ww1r6Kfmp9zjqidmUCvumBwEFKsS1NgRghcLYUAZAez9/6veXgQCD0qF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738952484; c=relaxed/simple;
	bh=o25nVfFHkCqh9v+E0amQTGd33Nc49EG9wKqEbv5rPQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZknzeOYatGTj/cRgG2M08xhTP+bPyu/5tpsilNvLLxpP6JFxCtzjXia7OJMtkyFtxL2WWFa24H53dSPg4g6DluAbGDHqMDg8ARURRUFo3US9IxS91gwC4W4DnaEawcH0wYJ9/AtZFXJ+0PO1ikvlffvAcbx+Bn2/qJUnR7S0Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EOhoGwfg; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EOhoGwfg"
Date: Fri, 7 Feb 2025 10:21:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738952468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DPpGE6KfgFPKO8JJBADUbGZ8Ya+RMAHRsJf1swlqxCs=;
	b=EOhoGwfg5dGbnzpteRz5Z7syVX4X8qA26qOJ6hJisGwZtjhHUmar9tOM/mhEMSC1sMoMdS
	mqqkw/8RAxgz6I29IwPLACUqROlhn9rbFa8WDg4iyjrvi/TfwBnkEBrcwI0YZj2aad2BQQ
	7YQ7PLA5+sTPY5mb6GdSIrOPb13Xt40=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v6 3/4] KVM: arm64: Report all the KVM/arm64-specific
 hypercalls
Message-ID: <Z6ZPDml0JKuSjLIO@linux.dev>
References: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
 <20250205132222.55816-4-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205132222.55816-4-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 05, 2025 at 01:22:21PM +0000, Shameer Kolothum wrote:
> Currently ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID returns the
> bitmap corresponding to KVM_REG_ARM_VENDOR_HYP_BMAP and it only
> returns _KVM_FEATURES_FUNC_ID and _KVM_PTP_FUNC_ID. Change that
> to return all the KVM/arm64-specific hypercalls exposed by
> KVM/arm64 to guest operating systems.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/kvm/hypercalls.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 27ce4cb44904..5cef2590ffdf 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -359,7 +359,11 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
>  		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> -		val[0] = smccc_feat->vendor_hyp_bmap;
> +		val[0] = GENMASK(ARM_SMCCC_KVM_FUNC_PTP,
> +				 ARM_SMCCC_KVM_FUNC_FEATURES);
> +		/* Function numbers 2-63 are reserved for pKVM for now */
> +		val[2] = GENMASK((ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS - 64),
> +				 (ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER - 64));
>  		break;

This isn't right, vendor_hyp_bmap is very much load bearing. We have a
documented UAPI that allows userspace to control the hypercalls exposed
to the guest.

The idea being a user wants kernel rollback safety and doesn't expose
hypercalls that could potentially be revoked.

https://docs.kernel.org/virt/kvm/arm/fw-pseudo-registers.html#bitmap-feature-firmware-registers

-- 
Thanks,
Oliver
