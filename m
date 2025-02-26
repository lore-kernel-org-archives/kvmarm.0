Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8224C1DC997
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 10:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740564489; cv=none; b=NgR8t7BXtT5lgrKkORpD+qDa/qR5UzZxKrfPBGVy1ojc4tGduMxaLvphLFAzmtoP1iZFt/Vm7UU9a5gaLb13Qzh+FBZ9EtlfK0pvnZpH5WZH/3S8yNDGUkdDzPeDWmYZXdbzFNdhGKG4NJdWJUofRQZL53MfY+HsxmyP8A3Ka7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740564489; c=relaxed/simple;
	bh=0tJumjnptvV8j42pULj/TSUErToqBkozF6Z5A15hMnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBfcOtCzcYwWPG/99xwZQLQ0qOgwrQIoM93D2/T7evSVf6G0jRvSIq2kNCo5ZX0QTV6AT1gIwaG6WK+B5kGbmjTWDPLLndRtZOdkOn8rWdYnRasYCBO9QhhlVe1RVJLXXZMWMwUk1ylcgpk2ojF+Trw3/bA/TQnpqa26KPXMvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v3oArvu0; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v3oArvu0"
Date: Wed, 26 Feb 2025 02:07:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740564485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5i64C+XznY5VpwulJeuZ+fGDTRMIkf91taLlh/OqCYg=;
	b=v3oArvu02FM6YGN1u5zf71hgLXwsJiDLOoixvpr0JJxGDToNzSws1vy6oss7NnNd8QLMuf
	jXOClnDeec7Zloq5DQ06f6pJ3TgqLvLP5eJvRdYELi7pYpaQVAMLQhW4x/74A5DLZUYbf6
	buE2h0UDSplp4UTtyq26wCWwcbHcCmM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, mark.rutland@arm.com, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v1 1/3] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
Message-ID: <Z77n_Gv0X0bolONW@linux.dev>
References: <20250214150258.464798-1-tabba@google.com>
 <20250214150258.464798-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214150258.464798-2-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Fuad,

Series LGTM overall, one comment:

On Fri, Feb 14, 2025 at 03:02:56PM +0000, Fuad Tabba wrote:
> Initialize and set the traps controlled by the HCRX_EL2 in pKVM
> when the register is supported by the system.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c | 46 ++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 3927fe52a3dd..668ebec27f1b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -58,6 +58,30 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcr_el2 |= HCR_ATA;
>  }
>  
> +static void pkvm_vcpu_reset_hcrx(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> +	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_HCX))
> +		return;
> +
> +	/*
> +	 * In general, all HCRX_EL2 bits are gated by a feature.
> +	 * The only reason we can set SMPME without checking any
> +	 * feature is that its effects are not directly observable
> +	 * from the guest.
> +	 */
> +	vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
> +

The comment isn't wrong, but we don't support SME at all in KVM at this
point.

Any objection to dropping this bit? I can fix it when applying the
series, no need to respin.

Thanks,
Oliver
