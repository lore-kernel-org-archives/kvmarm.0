Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6D81F03C9
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 21:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741036731; cv=none; b=rGfYoE8yg88/Kd4a1obnfrnrcRIGGNMkYKuIn7ZRTOyNq7zwTvloROrgPWiXF5YbzMI4c7gHGJbD+2uaQb33dBOM/nB6x7hgtN72aVs9LncdkWGzihDDOsXAtPUqd0mrUiiAM7LYO4Cxdi+CppCZnbpDsJmbtdqg/9s5vqsR9hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741036731; c=relaxed/simple;
	bh=m+22Wzco0memBcsmVoxCvRmoDxpC6qNqVC3zcVKI/x4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khnFyNNXl5e5D/xGtkvHY2/VoDJqv6Yrw4paw1X+jit/GkYeFtB1+QYL7S924BZ3fjnHlwSZTMCnRlGQNbuKOeQnm+aggmXLuBmqirhL4or+6UOyf5NvzFbLeiWbnBk3YmxQE4ne+gtwPgGqr8C1UxC3eVU4LhN0HZw0fQsZtTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xB0QWNwI; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xB0QWNwI"
Date: Mon, 3 Mar 2025 13:18:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741036725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VL2PoiSGgr0ZBIyYB1keoFRM15/brjcTmISS7bEwIkY=;
	b=xB0QWNwIYrNkYhnY9l2eJb2tbiISVRGAHbCv8MZtR1mqso28BlvjRvjLdf0VZ3Wd3or/S0
	bnzxMb0fE9H7rtuhqY2yMBAAuczCsqYRBfd3fHXztq9COm+M0AS9fTJyrMg8N3r5/7QpDP
	vlmCQHNQF2zlEojXjEWVqP0o473JIbo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Count pKVM stage-2 usage in secondary
 pagetable stats
Message-ID: <Z8Ycq3d7O8_3fozk@linux.dev>
References: <20250228121355.1377891-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228121355.1377891-1-vdonnefort@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 12:13:55PM +0000, Vincent Donnefort wrote:
> Count the pages used by pKVM for the guest stage-2 in memory stats under
> secondary pagetable stats, similarly to what the VHE mode does.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1f55b0c7b11d..c2e022c41313 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1088,12 +1088,18 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  
>  static void hyp_mc_free_fn(void *addr, void *unused)
>  {
> +	kvm_account_pgtable_pages(addr, -1);
>  	free_page((unsigned long)addr);
>  }

Don't we drain more than just stage-2 page tables into the teardown_mc
(e.g. vcpu structs)?

Thanks,
Oliver
