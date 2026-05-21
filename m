Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795413E2755
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369671; cv=none; b=nXI25iIWnwRzPN5vTHcLnNJBwAMh3DCp+8H0qvPTym3Hsloju8xAx5OPibfQN9CwPN7nQng28eM5m4jcVkhDu4Dby3jN6uToD6rvUYIdG9we66vNUj1bXzc6eRBS30DNYaMyiw3j4Yg++J01WszTtJFOKC/SGtu297UYyTuX4lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369671; c=relaxed/simple;
	bh=n1K9FL3sSKh4ZL14DkfXMekeA+vBvgRQxpeU6VG9xSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kroNfdIcCNw/XZ8QVvRN9srYX15/FVDnnjvX85g4g6pVVIqm6O+9HlxTQO5QzgL4kpAa105QNPgDXWNCq6f0wmH0B4tWAgSZJ3zrFIo6nMGp35vKGp03+PfBx2EygNbUsCYUdsCc+IU1SGHLmxXcYoqVtrgQ/JDDufadsz6Td6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dfJa52lf; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dfJa52lf"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso55629555e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779369668; x=1779974468; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oaCe+0vBux/acxxxbAjd0sdUOKLj5KDIayotecJQPco=;
        b=dfJa52lf+GJTAn+W1axV/kdhE1BdDvWxDZ2u7nluqVQyAZVOWav+XmgX5azBWc8/5b
         HY3UCbrGzfVhDbumIam21o8+UGh6nUQ0T/02/UHmB5jwuhYqM5gBGn00ZEyjJFgIUIC3
         q4WSVmZCW3Jg1qA9pNPU32OIujN/4+Zqk6N4Gg6NtP2Qqv1cnQYcjkWTLa+1sW7w5xXM
         +WbOxLXwZq73CH5L6A2dnQD320O8PZw1OdBzJCK/EZ9XTEN+f1+k8Iz1Hq4ydhr5KJ+J
         14YiLxdzUiu6cWbZ23HI0gw2FixhrGhtFMTodKgW43R+WcOeW91fr2tIuoKADBPCooMl
         r5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369668; x=1779974468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oaCe+0vBux/acxxxbAjd0sdUOKLj5KDIayotecJQPco=;
        b=sdeZVTxe/fK0zmITZrqfLVL/aIIj/tFfhPA7cxLYoGj8/cALKO8BLeQOpgaF98V9Mi
         50WbicGmEYlTHlZY8DlmgxJG5rlwq4H4EbPMpTgi7eJoneEMHifdU2x7mdpmJkGwJzPM
         Eu1WnYvLAf40b1cuuTJRCzJSpdi+O4JoSkzdB8yKNQECOFkh1B0MffFtgocLMn/ueTk2
         ACBZz73c+hKD/Zqy1v9O0guXaa/4fZM+/6C3gfogdRS15K1bCWl+4Zly0eGT9ZDIpb4R
         MZo+/r26i2vlVZcQfQAynv63aMFjp0gf9d1U7nWJY0dzq1nLel8Te5INGdtMI46Z0k+S
         5zGw==
X-Forwarded-Encrypted: i=1; AFNElJ9z4Ru/hNqkaKHD/SWSG9lFwWtYEF7Ii4RaLKINTyUTdMy3Vh1DWOSOFU4Ryy3H0VEwGZgGcOY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuqsyxpNXQUIaVcfhg6oDAdfoAlnlxxrMiCxby3Nx51p1y4CWq
	n0dTzxe/HNfqKTYY1wEjAkNLvmuVixHV2Pttm0Z+BSiGcHJE8MdY0Nz42q4FaYTXLA==
X-Gm-Gg: Acq92OFvEPqWz40ZqQfexl39FMV76FZxPaFwbahiJGwevZjWMDDTFI6wTiMjd/eQo8L
	BnNN6Y8AOuhbmlKYRI2XwwKHdLYEHTczE8Kf2d8iAjvLeXraTI+8zF2QPq+9xgw37F4MZSJ+cJn
	v9UjjeUNRz2lEda5unIlb/PEikAOqtVCkWgohFORigVz9bHByqFh+tRi5O6znS2qAGiyCiKSDGL
	+4Fv7CAYx3OOjRnKoZ5WLU5Lkk03exHq3TpiKEwu5mMjRhqTAZSd4nBRnT6FaZ5pJZIzlJWvY3p
	r1alnm8x7dVCb+iDLwVHKSP5nVg5p2cPM5baEO7UCFbDkIe5A8OEtL+c7iaFqQCl+epI4zFQV7A
	VcP6HGHGtlprvFv/jha5/yZeM7QzKcHTv2iLj8qJLXwFT7R/KvZUdT5IoyjJTusnQPHgqGVfYKm
	261ypruA39H+J6zx9wkCCGhXmlLO5oJ4lGpVd7J1OHfdMg1+lVCcMTlRlQLVuCJt8KBsp/UGWb1
	don1A==
X-Received: by 2002:a05:600c:1f87:b0:490:3cf0:8d81 with SMTP id 5b1f17b1804b1-4903cf08f14mr15940795e9.13.1779369667306;
        Thu, 21 May 2026 06:21:07 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035c64beasm24039235e9.1.2026.05.21.06.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:21:06 -0700 (PDT)
Date: Thu, 21 May 2026 14:21:02 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-team@android.com, qperret@google.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Reset page order in pKVM hyp_pool_init
Message-ID: <ag8GvtAonB6LNB5m@google.com>
References: <20260521102149.804874-1-vdonnefort@google.com>
 <20260521102149.804874-2-vdonnefort@google.com>
 <CA+EHjTxPoxjvMTZX5w+UyVgC=W3VUSDoOQ-tCDLfnae16SqoMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxPoxjvMTZX5w+UyVgC=W3VUSDoOQ-tCDLfnae16SqoMQ@mail.gmail.com>

On Thu, May 21, 2026 at 02:07:36PM +0100, Fuad Tabba wrote:
> On Thu, 21 May 2026 at 11:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > When a VM fails to initialise after its stage-2 hyp_pool has been
> > initialised, that stage-2 must be torn down entirely. This requires
> > resetting both the refcount and the order of its pages back to 0.
> >
> > Currently, reclaim_pgtable_pages() implicitly resets the page order by
> > allocating the entire pool with order-0 granularity. However, in the VM
> > initialisation error path, the addresses of the donated memory (the PGD)
> > are already known, making it unnecessary to iterate over all pages in
> > the pool.
> >
> > Since the vmemmap page order is a hyp_pool-specific field, leaving a
> > non-zero order on hyp_pool destruction is harmless until another pool
> > attempts to admit the page. Instead of resetting this field during
> > destruction, reset it during pool initialization in hyp_pool_init().
> > Note that pages added to the pool outside of the initial pool range
> > (e.g., via guest_s2_zalloc_page()) must still have their order managed
> > manually.
> >
> > While at it, add a WARN_ON() in the hyp_pool attach path to catch
> > unexpected page orders that exceed the pool's max_order.
> >
> > Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 25f04629014e..89eb20d4fee4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -322,7 +322,6 @@ void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
> >         while (addr) {
> >                 page = hyp_virt_to_page(addr);
> >                 page->refcount = 0;
> > -               page->order = 0;
> >                 push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> >                 WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
> >                 addr = hyp_alloc_pages(&vm->pool, 0);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> > index a1eb27a1a747..c3b3dc5a8ea7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> > @@ -97,6 +97,8 @@ static void __hyp_attach_page(struct hyp_pool *pool,
> >         u8 order = p->order;
> >         struct hyp_page *buddy;
> >
> > +       WARN_ON(p->order > pool->max_order);
> > +
> 
> Could you add a brief comment? It took me a minute to figure out what this
> catches. IIUC it's not attach's own input, it's a stale p->order from way back
> when an external page was popped from a memcache (today only via
> guest_s2_zalloc_page()). Right?

I think it'd be self explanatory if that was next the page_add_to_list, but that
wouldn't protect the memset (that's really best-effort though).

How about?

/* 
 * A page with an order bigger than the pool's max is an 'external' page
 * whose order hasn't been reset before being added to the pool.
 */

But now I am thinking I can do way better: we can easily identify external
pages, so I could just force the order to 0 in that case.

WDYS?

> 
> With that.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> 
> Cheers,
> /fuad
> 
> 
> 
> 
> >         memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
> >
> >         /* Skip coalescing for 'external' pages being freed into the pool. */
> > @@ -237,8 +239,10 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
> >
> >         /* Init the vmemmap portion */
> >         p = hyp_phys_to_page(phys);
> > -       for (i = 0; i < nr_pages; i++)
> > +       for (i = 0; i < nr_pages; i++) {
> >                 hyp_set_page_refcounted(&p[i]);
> > +               p[i].order = 0;
> > +       }
> >
> >         /* Attach the unused pages to the buddy tree */
> >         for (i = reserved_pages; i < nr_pages; i++)
> > --
> > 2.54.0.746.g67dd491aae-goog
> >
