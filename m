Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB550317714;
	Fri, 15 Aug 2025 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755279202; cv=none; b=WwiNCmOJAO8mxijV9yGbBm413QyQ2k41PJGo3cUNGIvm9aCqdgIXeg0stOfLu+jvaSVEO49WVWefZyv7f0i7lEZJdgZHAuQVuG1PFOHbtRIuwz/tmBVgPLSo26NXLCqKiFxOB5XOtLOrvu3O+p0fGicHxbX74sWPafVO0oxhSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755279202; c=relaxed/simple;
	bh=uNXcExhIGYZE1vtxyHmmV/bddkPc9+O8TyoblnfQCXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3zC3bAezmto6CtCfSw9QLeAY1SGAB7NloprUpeIic2SGKb6PDtiUlE2b/C8TZjvHukfc3iva2kl+LEKBIkQLzCzCweIryKUqGYymprWO+HHOfoaNJbN7H0VS54leyPNW08WovR9PZe1FBvJvxIfLirSBteT7L5o/3cP7RhLAIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9769EC4CEEB;
	Fri, 15 Aug 2025 17:33:17 +0000 (UTC)
Date: Fri, 15 Aug 2025 18:33:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aJ9vW8SgklYByjpB@arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-2-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811163635.1562145-2-yeoreum.yun@arm.com>

On Mon, Aug 11, 2025 at 05:36:31PM +0100, Yeoreum Yun wrote:
> @@ -3131,6 +3132,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, GCIE, IMP)
>  	},
> +	{
> +		.desc = "Unprivileged Load Store Instructions (LSUI)",
> +		.capability = ARM64_HAS_LSUI,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		ARM64_CPUID_FIELDS(ID_AA64ISAR3_EL1, LSUI, IMP)
> +	},
>  	{},
>  };

Since this is only used in the kernel, I wonder whether we should hide
it behind #ifdef CONFIG_AS_HAS_LSUI. Otherwise we report it as present
and one may infer that the kernel is going to use it. Not a strong view
and I don't think we have a precedent for this.

-- 
Catalin
