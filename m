Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892C12E8DEF
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 15:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783526064; cv=none; b=mpBIAGGF2gTJu3sqS9OOGtqTKnw6D9SCXgyoLFxn9s4vWWBqI5snF9SC6Yx7mEsCOuUz+KzEtTv0kv9mytqCpB62CwWMUGME7Yohu0d1qqPq2uXzRZX9NQduxrTjRcke3SnRpCeSUplhTuI6Ry8TjS0UKimAhDZ1Rxy3WJ5JuuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783526064; c=relaxed/simple;
	bh=4TMlaYqB/am0G/LbJU1NWYiqmS+cXj8h4NpwA+Oe3rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2QPX7oMkWTkH4YBOeBb1ht1UvSSTqtDzR+xTLgkoPyxi+Hfi47Pt7FOV0Qq5+72n3Nu6AtGMpGM+gey+ssZDi6QiGpK6RxQIZ5Z9bdRGwJxda+fgHrz+x5z8ShObYYrBraOCfQayFCyx427MAHIqjxo9l0nhKnhf7BNqv9LXuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fqcSl+Vh; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fqcSl+Vh"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-472326ca506so613387f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 08:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783526061; x=1784130861; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TEH0TLSCJV0L+s7o2DSFoI6lwgg3rA8RuA/n0rPDeqM=;
        b=fqcSl+VhWXT8aX9753fFxDT8QDaKiDKkMaVVQQ31E6eyFNPadRY6yo7uVHb/VTSUlS
         cb+huKlKeIw7FW8z+GJBRuHzOWNKPi9UbEkHBk2NQ1VRSXrGmoAnWBYbpJCNWM86MsVG
         2RZD3/hlrBp1zmJDNXiIklqCy53GuwRIfZYrzjNDV+yZ1+VdKzcSn9GMHpYoT39gKjtb
         4pTsFNiV4mVYJsD/SjI+DdDbv0D4cJq8CW0cPvhtRWpqTKhmxUFtNVCH5ReoOZ1SeaM+
         1Q8ZqlqU9LpJqisJgxLe2AYtQPudh1eBCxSJ0n2ozaPsOQBFAje5cVi6+jeYEHD+p9dU
         d9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783526061; x=1784130861;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TEH0TLSCJV0L+s7o2DSFoI6lwgg3rA8RuA/n0rPDeqM=;
        b=N9845ksF54CCz12nYFtLnMXuUoTkykIc1r+DKdnxGbuIjWAgnUjUWqpAQjY8jjrNBV
         O7nrB+1741w6AeL2ge67qLVAjJ8QJqbUR1icMWrCrZCYGHvPtwPGhG/yZ+xkSyYzpZZy
         MqVHupZJReBKLIbt6S+A5u64rDwFngWzqNbIUJFVcAAapdwHB8t6vTNl7m1dIbIjtBVC
         S51rzaLtUu11yrbkFWnjBu/MlHqcw8AFi2sTeRkRfJiqY+59ggH9ZO4AMTqCWoL1tsba
         r037gTRkfLKPXNThIhjDLoWymPzJPpTlStnWO5MeaPf45rZDquRWw1xlSTznpapgeX16
         Cbpw==
X-Gm-Message-State: AOJu0YzTrivcugYSlA2QKrbGjFaRVTDOy/K0uFSjj8NCSownZbeau0Hz
	7xlsp/d+gE4jL3asbB+Hube9rvS5OrVcWz3TsI0bJB2ryxl2vS+L0BgbP7xg9mR75EtRCFp+4mu
	4VmnnEg==
X-Gm-Gg: AfdE7cnW4iu4+V84c2of6PM9gtcepO2gS0MhjwJLurodKKk/rImnbOtCIbW/rYtp8ap
	EdAwaRrvZMazvnAPUDgCT/dEZ5LXtEnP/yXtnbE3edAUYea0ol197LFjtBRRNjniWwyGYhWoxMs
	A7TWfotnAoknvnyDZanFZW+i3zoUOe+Nd75WGhelsVGvpVTwSUAcrpwa4czfVkcg6E3PDkIA1gj
	cgq360c2gyeHIOTMpAM96hS9RRv8tWx49A2JVemGdWSal/c9MH0V6OTHR9+PkjtZRzQOyWg/KpT
	XqkTk3CaUl8c526Hejo93l4HbLjO4G82AIp8D435J6FFbyHltmbOJOSa2jaUzZL8zuGRsFvPmUN
	vhJ8vQTJcqmxJ5Wwx69OWJJcYlz20FDbgvkoSGm/j3qt7Ot8TnOoxrUZpo7RWm+9Uow8X0d/Rd7
	gIxZa3XfsG6E1TwY3bTrJATLu2eFJYSNHKn6wA+D12OWVSM2vBjfhjov6s9Zt3+w==
X-Received: by 2002:a05:600d:8653:20b0:493:e85f:c583 with SMTP id 5b1f17b1804b1-493e85fc596mr15623125e9.26.1783526060692;
        Wed, 08 Jul 2026 08:54:20 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f4fc0bsm136256855e9.10.2026.07.08.08.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 08:54:19 -0700 (PDT)
Date: Wed, 8 Jul 2026 16:54:16 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 04/18] KVM: arm64: Add a heap allocator for the pKVM
 hyp
Message-ID: <ak5yqI8QSgYrY3qQ@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-5-vdonnefort@google.com>
 <20260706181242.276E21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260706181242.276E21F000E9@smtp.kernel.org>

On Mon, Jul 06, 2026 at 06:12:41PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] hyp_allocator_map remaps already-mapped pages and corrupts unmapped tracker state due to unaligned next chunks.
> - [High] Fatal EL2 WARN_ON creates a dead-branch trap and panics the hypervisor on global lock contention in hyp_allocator_alloc.
> --
> 
> commit d07913766ae6b18b86e593f40b4fc4a8165e2722
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add a heap allocator for the pKVM hyp
> 
> This commit creates a heap allocator to manage VA-contiguous memory for the
> hypervisor, replacing donations embedded within HVCs. It supports allocating,
> freeing, topping up from a host memcache, and reclaiming memory.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
> > index 0000000000000..07ef0a13855f7
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
> 
> [ ... ]
> 
> > +static int hyp_allocator_map(struct hyp_allocator *allocator, struct chunk_hdr *chunk,
> > +			     struct chunk_hdr *next,
> > +			     void *addr, void *end)
> > +{
> > +	void *unmapped = chunk ? chunk_unmapped(chunk) : allocator->first_unmapped;
> > +
> > +	/*
> > +	 * hyp_allocator_can_create_chunk() already validates addr/end
> > +	 * belong to the chunk.
> > +	 */
> > +	WARN_ON(end <= addr);
> > +
> > +	/* The chunk does not span an unmapped region */
> > +	if (!unmapped)
> > +		return 0;
> > +
> > +	while (unmapped < end) {
> > +		void *page = pop_hyp_memcache(&allocator->mc, hyp_phys_to_virt);
> > +		int ret;
> > +
> > +		if (!page) {
> > +			end = PTR_ALIGN(end, PAGE_SIZE);
> > +			*this_cpu_ptr(allocator->topup_needed) =
> > +				(unsigned long)(end - unmapped) >> PAGE_SHIFT;
> > +			return -ENOMEM;
> > +		}
> > +
> > +		ret = __hyp_allocator_map(unmapped, hyp_virt_to_phys(page));
> 
> [Severity: Critical]
> Does this loop correctly handle unaligned next chunks when re-mapping
> reclaimed memory?
> 
> If the allocator reclaims a chunk where the next chunk is unaligned (e.g., at
> PAGE_SIZE + 32), the unmapped hole is safely truncated to PAGE_SIZE by
> PTR_ALIGN_DOWN(next, PAGE_SIZE). However, if the chunk is later reused with
> an end address extending into the partially shared page (e.g., PAGE_SIZE + 16):
> 
> The loop in hyp_allocator_map() iterates while (unmapped < end). When unmapped
> reaches the end of the true hole (PAGE_SIZE), the loop continues because
> PAGE_SIZE < PAGE_SIZE + 16. It then pops a new physical page and maps it at
> PAGE_SIZE, overwriting the existing active PTE containing the next chunk.
> 
> Additionally, the unmapped == next reset check fails because of the unaligned
> next pointer, propagating the corrupted tracker state.

I don't believe this can happen. Chunks __always__ describe a mapped section,
followed (or not) by an unmapped one. So if we are adding mappings to a chunk,
next has to be PAGE_ALIGNED.

However, I could add a WARN_ON() here.


> 
> [ ... ]
> 
> > +static void *hyp_allocator_alloc(struct hyp_allocator *allocator, size_t size)
> > +{
> > +	struct chunk_hdr *chunk;
> > +
> > +	size = max(size, MIN_ALLOC_SIZE);
> > +
> > +	/* Ensure we do not overflow ALIGN(MIN_ALLOC_SIZE) */
> > +	if (size > U32_MAX) {
> > +		hyp_allocator_set_errno(allocator, -E2BIG);
> > +		return NULL;
> > +	}
> > +
> > +	size = ALIGN(size, MIN_ALLOC_SIZE);
> > +	if (size > (allocator->end - allocator->start - chunk_hdr_size())) {
> > +		hyp_allocator_set_errno(allocator, -E2BIG);
> > +		return NULL;
> > +	}
> > +
> > +#ifdef CONFIG_NVHE_EL2_DEBUG
> > +	/* The allocator can modify the hyp stage-1 */
> > +	if (WARN_ON(hyp_spin_is_locked(&pkvm_pgd_lock))) {
> > +		hyp_allocator_set_errno(allocator, -EINVAL);
> > +		return NULL;
> > +	}
> > +#endif
> 
> [Severity: High]
> Can this lock check trigger a hypervisor panic under normal SMP contention?
> 
> At EL2, WARN_ON() expands to a fatal BRK instruction, meaning the error
> handling path here acts as a dead-branch trap and will never execute.
> 
> Furthermore, hyp_spin_is_locked() returns true if the lock is held by any CPU,
> not just the local one. If host userspace triggers concurrent VM creations or
> VCPU initializations, driving concurrent EL2 hypercalls to hyp_alloc(), CPU A
> might hold pkvm_pgd_lock while CPU B concurrently evaluates this WARN_ON().
> 
> This converts standard SMP lock contention into a fatal host denial of service.

Duh, this hyp_spin_is_locked() is of course utterly broken! I'll add a
comment for hyp_alloc() instead.

> 
> > +	scoped_guard(hyp_spinlock, &allocator->lock) {
> > +		chunk = hyp_allocator_alloc_chunk(allocator, size);
> > +		if (IS_ERR_OR_NULL(chunk)) {
> > +			hyp_allocator_set_errno(allocator,
> > +						IS_ERR(chunk) ? PTR_ERR(chunk) : -EINVAL);
> > +			return NULL;
> > +		}
> > +	}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260706175415.2604046-1-vdonnefort@google.com?part=4
