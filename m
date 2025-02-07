Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5EB21D00B
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738937330; cv=none; b=SHZdT7yinYu4O9gJOe/lfMBWMiZwey58eBsyAXgsL0iIM2MtUJu/xiDX/5AT9GXgx2ze1/c8zxzpCbuV5M9OP2ZQAZ6k7Ga5rMYX6XGIqk5Xwl89ZSkypEbl+vY08VfJhWHvc8qfQEW05q4uxNviV1HGgdvOHdoxaMaFibL0cgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738937330; c=relaxed/simple;
	bh=LWe72L47xpbJcvLJWBHPqv46sQLt3DuB5r4Qkrploxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmUs3hlWB6PLma7qUFYW6XC3mvDNeR1fU7Y5ObptZennBUa2OKpuSmb8Zny3os/FtFc4BhQTRNObsJgAASSlaJLRe332EwS2XBEk5jt1aQ4u4+vnlUCFElINqDhnYQz7R9dXekbtpZS4DTD0cfLLO0Osro24ie8undofvj6FR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED39C4CED1;
	Fri,  7 Feb 2025 14:08:46 +0000 (UTC)
Date: Fri, 7 Feb 2025 14:08:44 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v6 4/4] arm64: paravirt: Enable errata based on
 implementation CPUs
Message-ID: <Z6YT7GxVKGKcnYmL@arm.com>
References: <20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com>
 <20250205132222.55816-5-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205132222.55816-5-shameerali.kolothum.thodi@huawei.com>

On Wed, Feb 05, 2025 at 01:22:22PM +0000, Shameer Kolothum wrote:
>  static inline bool is_midr_in_range(struct midr_range const *range)
>  {
> -	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
> -				       range->rv_min, range->rv_max);
> +	int i;
> +
> +	if (!target_impl_cpu_num)
> +		return midr_is_cpu_model_range(read_cpuid_id(), range->model,
> +					       range->rv_min, range->rv_max);
> +
> +	for (i = 0; i < target_impl_cpu_num; i++) {
> +		if (midr_is_cpu_model_range(target_impl_cpus[i].midr,
> +					    range->model,
> +					    range->rv_min, range->rv_max))
> +			return true;
> +	}
> +	return false;
>  }

It's a interesting approach but how does this work in practice if an
erratum requires a firmware counterpart? Do we expect firmwares on all
machines involved to have workarounds for the other machines? Or is KVM
going to intercept those SMCs and pretend the EL3 counterpart is there?

-- 
Catalin
