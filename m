Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E45548CD71
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791894; cv=none; b=NAY2HZ6qPGjY7dmgRUTWMBk6P9mM2uiRooaEJc6c4KSLTOVsrDh/fqFnYzAcehbJ4zPxx7afzCoHHcVyOMzggAI7jvbQjhuj/utQA3rqyAUIzIsSHXEV6X/pD0k+OePZvt/dgHN17YgFN+svoZph+yOWCye01MaZuoegdBsXs3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791894; c=relaxed/simple;
	bh=WUNSoWZpeqdDZs8W4YWQUVGB39NYxjnCgCjxLQYs5jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4PuH0CPYUQRYJ9kD054QrTWV+F9XuJzwYgvIxlbw5AZA/bPHZPs8E0h0V7vvl8JXdhZW0Pzu31R1somZEEFYms6bEnAUpNATMQ3tpZpXOtAPa8EypLYesuOoeMrgWQeuMTvBza9xPE1Yk4TvWsJyR6K2j5rqJ2vpCoRtYd2uwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IDdmMswX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IDdmMswX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DF811476;
	Mon,  7 Sep 2026 07:38:01 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 036B73F528;
	Mon,  7 Sep 2026 07:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788791885; bh=WUNSoWZpeqdDZs8W4YWQUVGB39NYxjnCgCjxLQYs5jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IDdmMswXM7Hyaxng4ZWtOFUzjYY9W9L3t2I6wgjA2csgfHO7soIZNCWzGxwQqTROn
	 hpcnBPqMDP9HZ0hSK7TeQxX6tNaGzjaBJxu6YvgNmXFh/RE2pcDUeW6+vqOqDgEOIT
	 /V36J4k5vsFR4Gtb88FtWgeQKGDXugPr/ss2KbfA=
Date: Mon, 7 Sep 2026 15:37:56 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 04/20] KVM: arm64: Use block-level annotations when
 setting up the host stage-2
Message-ID: <n2cker7zphcsacuck5ovwtj6k622ykpadg6njs2qirhqxj5keh@ub2dnnarnmmm>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-5-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-5-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:08:48AM +0100, Vincent Donnefort wrote:

[...]

> +static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +				     enum kvm_pgtable_walk_flags visit)
> +{
> +	struct fix_host_ownership_data *data = ctx->arg;
> +	enum kvm_pgtable_prot prot = 0;
> +	phys_addr_t phys = 0;
> +	int ret;
> +
> +	if (kvm_pte_valid(ctx->old))
> +		prot = kvm_pgtable_hyp_pte_prot(ctx->old);
> +
> +	if (!prot) {
> +		/* Unchanged region */
> +		if (!data->prot)
> +			return 0;
> +
> +		goto apply_ownership;
> +	}
> +
> +	phys = kvm_pte_to_phys(ctx->old);
> +	if (!addr_is_memory(phys))
> +		return -EINVAL;
> +
> +	/* We already know phys is contiguous as we walk the linear map */
> +
> +	if (prot != data->prot)
> +		goto apply_ownership;
> +
> +	/* Accumulate in the current region */
> +	data->size += kvm_granule_size(ctx->level);
> +
> +	return 0;
> +
> +apply_ownership:
> +	ret = __fix_host_ownership(data);
> +	if (ret)
> +		return ret;
> +
> +	data->phys = phys;
> +	data->size = kvm_granule_size(ctx->level);
> +	data->prot = prot;
> +
> +	return 0;
> +}

I think this function can be simplified, if we check phys first:

static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
				     enum kvm_pgtable_walk_flags visit)
{
	struct fix_host_ownership_data *data = ctx->arg;
	enum kvm_pgtable_prot prot = 0;
	phys_addr_t phys = 0;
	int ret;

	if (kvm_pte_valid(ctx->old))
		prot = kvm_pgtable_hyp_pte_prot(ctx->old);

	if (prot) {
		phys = kvm_pte_to_phys(ctx->old);
		if (!addr_is_memory(phys))
			return -EINVAL;
	}

	if (prot != data->prot) {
		ret = __fix_host_ownership(data);
		if (ret)
			return ret;

		data->phys = phys;
		data->size = kvm_granule_size(ctx->level);
		data->prot = prot;
	} else {
		data->size += kvm_granule_size(ctx->level);
	}
	return 0;
}

Did I miss anything?

Thanks,
Wei-Lin Chang
