Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF418CC00
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 22:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725921381; cv=none; b=phrFmWeGNeYhfehkKUQE16yoBgPBCysSS4QAN+N0JVXmx8vxJHqX391RitNpcwhCJT/ODoKIslOwPUXYDnTWRZ+Nri/dDGkTAEHhUDW1tt5vB6IuXGcgnWQOWbHQv4OfJZJMlobtcdVnC9lWMPecc7P6donP6pMmehFhqcbdTiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725921381; c=relaxed/simple;
	bh=v/39exFJwhMuoVl7WLHYpG8vgwVP9StqtsFj1qr1wgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7AsTehhFtloexcp6US8OkYgB3ZrwmxRP5s/wwKSjmEBbFhkSjMkEgkHEoBot2phyg6vxk2owNoA03PRB0j8EJPR50hFowaCKhgMhtRWSwb5TOu8RY4KQ2jmeoIBaYC+5meS5U5vrkad++ntm0b9DDOwoCStqrrV/dTOv9jlr3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VfNbR2Yx; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VfNbR2Yx"
Date: Mon, 9 Sep 2024 22:36:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725921377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PAOwxfQaHCQqtI5pUon/+UOel8KmgsVnMsfbJQaWVLE=;
	b=VfNbR2YxKTO00M+E11bjDCcDKgJZ2grBhvATdSx/2QjmfxN4lxvtuk5Z3kqt5qkxivgrpC
	T+u3r1Lhjv2mx1FWGqIBqaBcynm2XlN/prAeu0U5cdnh0yh78e1qIwyd+9GxWZxXLxvjJ9
	Uc+l3d4Vpb6IWmDO16ynNlFVed5g6fA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Snehal Koukuntla <snehalreddy@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Add memory length checks and remove
 inline in do_ffa_mem_xfer
Message-ID: <Zt94W-rswpPRrzSP@linux.dev>
References: <20240909180154.3267939-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909180154.3267939-1-snehalreddy@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Snehal,

On Mon, Sep 09, 2024 at 06:01:54PM +0000, Snehal Koukuntla wrote:
> When we share memory through FF-A and the description of the buffers
> exceeds the size of the mapped buffer, the fragmentation API is used.
> The fragmentation API allows specifying chunks of descriptors in subsequent
> FF-A fragment calls and no upper limit has been established for this.
> The entire memory region transferred is identified by a handle which can be
> used to reclaim the transferred memory.
> To be able to reclaim the memory, the description of the buffers has to fit
> in the ffa_desc_buf.
> Add a bounds check on the FF-A sharing path to prevent the memory reclaim
> from failing.
> 
> Also do_ffa_mem_xfer() does not need __always_inline
> 
> Fixes: 634d90cf0ac65 ("KVM: arm64: Handle FFA_MEM_LEND calls from the host")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sebastian Ene <sebastianene@google.com>
> Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
> ---

Next time around, please include some notes on what's changed between
versions and ideally a link to the last patch. It helps latecomers (i.e.
me) get an idea of what's happening w/ a patch.

>  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index e715c157c2c4..637425f63fd1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -426,7 +426,7 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_res *res,
>  	return;
>  }
>  
> -static __always_inline void do_ffa_mem_xfer(const u64 func_id,
> +static void do_ffa_mem_xfer(const u64 func_id,
>  					    struct arm_smccc_res *res,
>  					    struct kvm_cpu_context *ctxt)
>  {
> @@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
>  		goto out_unlock;
>  	}
>  
> +	if (len > ffa_desc_buf.len) {
> +		ret = FFA_RET_NO_MEMORY;
> +		goto out_unlock;
> +	}
> +

This check doesn't need to happen behind the host_buffers spinlock. Of
course, keeping it behind the lock is benign, but this sort of thing
prompts a reviewer to ask "why?"

Besides that,

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
