Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62973D64
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737997561; cv=none; b=WuNfy7iCFl/IjGxvtdvjOXCPdJ5vrfmev3sc8QZ1Y0YWuU3DAbnbWJVkcic0PskJ9HGU8seWVl7DgyVwE3yCxy6XZXMAdEk/acAClxnEkJg0wzuOlcCPrmgY1vRlcETjoR5epjt6y3z/kPFwa+BaBAjtzYYtHZZJMpHFNAeuv2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737997561; c=relaxed/simple;
	bh=mSI7l3axH1VqwMY+HCSbeKdzA2H6YooEvqW0ff2jGUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lg4TqiLLK2mONhwP80zqNaIQFgqU0JLRwe4QWKXjtc+8UJPmlrVq3gbK1coiW6t+Ye8wKuGaEwN/b6RE81jeYeA7zkNyr+kXBXKAtQTgNOsdVPfSdPTn3Mi6OecenFAEHGR3CEJ7QXpjxvdDPT8/z8vcj22JVNqLZJZULNQpUNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u/aPbhrO; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u/aPbhrO"
Date: Mon, 27 Jan 2025 09:05:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737997556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h9dwybOO0+mZiFuuq/Vf+IGs6l28IyHfVWotIsmLO+c=;
	b=u/aPbhrOYBk3Frt9AqX45lJMVsHZmxgN4f4FNLsj7PbQngoz58Z4r82mCC3EuPxpbogNhE
	JBw9xeT+UXhheABj4aVKKV5hZwsWDNxDH5DYyxpCX5HsneZxS3pO28N91a8a4lLU24OP/S
	8aWGyUmKxuY2HmIizZG5v5I6ESr6m8s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v5 3/4] KVM: arm64: Report all the KVM/arm64-specific
 hypercalls
Message-ID: <Z5e86rCgvbtK84CT@linux.dev>
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
 <20250124151732.6072-4-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250124151732.6072-4-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hi Shameer,

On Fri, Jan 24, 2025 at 03:17:31PM +0000, Shameer Kolothum wrote:
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
> index 27ce4cb44904..6132cb542200 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -359,7 +359,11 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
>  		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> -		val[0] = smccc_feat->vendor_hyp_bmap;
> +		val[0] = GENMASK(ARM_SMCCC_KVM_FUNC_MMIO_GUARD,
> +				 ARM_SMCCC_KVM_FUNC_FEATURES);
> +		/* Function numbers 8-63 are reserved for pKVM for now */
> +		val[2] = GENMASK((ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS - 64),
> +				 (ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER - 64));
>  		break;

This isn't right. The pKVM carveout exists for some KVM-internal
bookkeeping to (hopefully) avoid breaking guest ABI between what's in
the downstream android kernel and what eventually gets accepted
upstream.

The purpose of this hypercall is for the guest to discover what
interfaces are actually implemented by the hypervisor, and we definitely
do not implement these upstream at the moment.

-- 
Thanks,
Oliver
