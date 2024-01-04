Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DA928DD4
	for <kvmarm@lists.linux.dev>; Thu,  4 Jan 2024 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EgDKCdZE"
Date: Thu, 4 Jan 2024 18:22:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704392543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6mU88UU7RwuIYuMbDb5yDn0rYv6PefHxXdYDrc9VLI=;
	b=EgDKCdZE20v9OExzVNdXTQ+9FPo7gxMtUmhFXzPE09LkTPYSwarsZGWvGfDJmHvCqE1gt2
	w6D7B8Mdkl0/RnB/gsmZxzxCVkPwwKpXTIpZVRRe0NDLTg5nBI0DndLsm+EQMChmijdnJE
	fXbEFcwX4/qNEemgMFBwlT0kWk1nggs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, keirf@google.com,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Add missing memory barriers when switching
 to pKVM's hyp pgd
Message-ID: <ZZb3W1N80q6pAib7@linux.dev>
References: <20240104164220.7968-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104164220.7968-1-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 04, 2024 at 04:42:20PM +0000, Will Deacon wrote:
> In commit f320bc742bc23 ("KVM: arm64: Prepare the creation of s1
> mappings at EL2"), pKVM switches from a temporary host-provided
> page-table to its own page-table at EL2. Since there is only a single
> TTBR for the nVHE hypervisor, this involves disabling and re-enabling
> the MMU in __pkvm_init_switch_pgd().
> 
> Unfortunately, the memory barriers here are not quite correct.
> Specifically:
> 
>   - A DSB is required to complete the TLB invalidation executed while
>     the MMU is disabled.
> 
>   - An ISB is required to make the new TTBR value visible to the
>     page-table walker before the MMU is enabled in the SCTLR.
> 
> An earlier version of the patch actually got this correct:
> 
>   https://lore.kernel.org/lkml/20210304184717.GB21795@willie-the-truck/
> 
> but thanks to some badly worded review comments from yours truly, these
> were dropped for the version that was eventually merged.
> 
> Bring back the barriers and fix the potential issue (but note that this
> was found by code inspection).
> 
> Cc: Quentin Perret <qperret@google.com>
> Fixes: f320bc742bc23 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
> Signed-off-by: Will Deacon <will@kernel.org>

+1 to Marc's suggestion about folding the appropriate barriers into the
macro, but fine with this as is:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
