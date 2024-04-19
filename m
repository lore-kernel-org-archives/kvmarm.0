Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA6D10A3B
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713559938; cv=none; b=Nxqv1ZV6OsKARRmha+wYfi8FnW5o72kTpKTPQ+dCZXXHTaAugZcclYu8CFfy23xmH+lVkiddJI5Ji7VnLN+JgpATFFxyRdhuWq6GxWO2pDqXTloWmmjbtsY5b9Pas3WkkUrCwtMT57AfbdsRKFXddWbBGUGuM6Ncv/SttzmnYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713559938; c=relaxed/simple;
	bh=AM0w2SHCm+eFiZ8ISSWuH7LbGi6LLl6bfnEt5gSCBTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfkqIB/Ip2tBH2mgCE3GscybgNUk5ZqWZzDaF8rlwq2d2A3DrW1+AF1wjUJUMrqXtu9ygWNFu3Vw7/AGG0zhboRHX+baKTt83ucJZfXwauwMY7iFVqmB1Dqr9V8QVouwllUa42S41ztFxGHRW5msM2e3O0FzQiAkyw9PNpLuRyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YP1Fd0dB; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YP1Fd0dB"
Date: Fri, 19 Apr 2024 20:52:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713559935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iYUc4daCaWrXz6mfR1o38vQFryrRgs3Q8Dgp3wOCJuU=;
	b=YP1Fd0dBeRBpLyj4j5eF356T1jR3Lel4x0SLOSOJuu2KdgNEQf6mL/zywwI0512G7gKRfj
	lVXwkhvWfCQ9KIrICwgQS5Yf71yX8zD9wLN3Z2K6mXte17Wv4knJoFWF6deeGppZCNsiaz
	JbC7Cg90leYECRV8REfypCW3UP37qSg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v3 27/31] KVM: arm64: Use atomic refcount helpers for
 'struct hyp_page::refcount'
Message-ID: <ZiLZehsi1_arusae@linux.dev>
References: <20240419075941.4085061-1-tabba@google.com>
 <20240419075941.4085061-28-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419075941.4085061-28-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 08:59:37AM +0100, Fuad Tabba wrote:
> From: Will Deacon <will@kernel.org>
> 
> Convert the 'struct hyp_page' refcount manipulation functions over to
> the new atomic refcount helpers. For now, this will make absolutely no
> difference because the 'struct hyp_pool' locking is still serialising
> everything. One step at a time...
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 +++++++-----------
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c    |  2 +-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c     |  5 ++++-
>  3 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index ab205c4d6774..74474c82667b 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -6,6 +6,7 @@
>  #include <asm/page.h>
>  
>  #include <linux/types.h>
> +#include <nvhe/refcount.h>
>  
>  struct hyp_page {
>  	unsigned short refcount;
> @@ -39,37 +40,32 @@ static inline phys_addr_t hyp_virt_to_phys(void *addr)
>  #define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
>  
>  /*
> - * Refcounting for 'struct hyp_page'.
> - * hyp_pool::lock must be held if atomic access to the refcount is required.
> + * Refcounting wrappers for 'struct hyp_page'.
>   */
>  static inline int hyp_page_count(void *addr)
>  {
>  	struct hyp_page *p = hyp_virt_to_page(addr);
>  
> -	return p->refcount;
> +	return hyp_refcount_get(p->refcount);
>  }
>  
>  static inline void hyp_page_ref_inc(struct hyp_page *p)
>  {
> -	BUG_ON(p->refcount == USHRT_MAX);
> -	p->refcount++;
> +	hyp_refcount_inc(p->refcount);

Adding a BUG_ON() for taking a reference on a non-refcounted page (i.e.
p->refcount was 0) would be nice, especially since we're past the point of
serializing everything and you can theoretically have a zero count page
outside of the free list.

Seems like otherwise we'd get actually hit the BUG_ON() in an unrelated
allocation path.

-- 
Thanks,
Oliver
