Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72081AA1F4
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779370292; cv=pass; b=tEPx8V6gGf1BiSvE1cadKPFP/pNzPODTvTE8wz2WzeO2oKxsqnpvVA+ah7U5Sjcr3vrUtCCc0cMJmDUejvYVFbDr54d8poUg43utK3twT5UREIXvSC0LIlC1Un6rjsF5wnzKKgEbBdMOUB3ZX0MRSsMbc+yeoQfVa47m5HsaWMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779370292; c=relaxed/simple;
	bh=6HtAVKEZIc7ZZ1rjtHleA2qqy1GcI6PyUi1Nu6+PJdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HHTvLQU/ZhcMZmvPd/zzDQBV6LlACsVDCBRme9w7RQt5wwG+iM0QCfoNWt57x5vwB7dLaKtrOAN/k7RzhgFDjY0LSLJ8H9GgEL+AAdIlV3lWJ8H0bD7DS74Jnm5Zuc34COZILeMwRA1EoZKYmN299sCohJ9ZFRNASarTDeLqgk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qRSMOwI0; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qRSMOwI0"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-515548f390fso1561cf.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:31:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779370290; cv=none;
        d=google.com; s=arc-20240605;
        b=lw7QbEPdVlqMajrZQgD28HCA4LdoC5KZ5gNqHT4avLOEivhih3n8tlyAEVSnK4Li/5
         lxAyeCnzUcxVL0j016W7qjYMVJ/OcIxH8OZeKU77H6Dy2LRJX4qu4fJKWxiNakup12qd
         9ZijEsWtXGJwsADc9FARK+mkhxCcCeF5oCDqeyraaVapl5sUjKxd510oLq4RvF78DL5d
         Y0ZCqyW9s0LyIkQzaBUmNRYzjz098GQwuUrzOi6+OCFeQWROvkoqddrItVodn7iQbPJm
         IL7baRgMhWyhWKb25j0Rn72+onkWsZt9PyC/IeB6s41EaJaTKl9vt4PJ6XBUTv2zmY0s
         bWqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5+Tg5A2q1rSTmypZ4m7QNpGOwZSgbWFsRlyJMtjn0p0=;
        fh=XL2WdG2EjmV4IPc7NPb8aTKEUcJlTj6UaGLZ4G0XrEc=;
        b=aIisErwhAEk0+S5eBLHJ6bCnGwDSbU+/uXPIdIEekR8kwMaxPLAN1wTCNaJYUqyELn
         D9ViCa349JaqDcRh6AKtbTwKc5Mda23Yw60p4egatx9xvIZjKAVbKdKd/PGW1v0HkAnf
         ZaleSYxITLJe7hhXLE6cUa237aaUupNneUY4oDPcw5+CtSetbW0IZYGzBDh0gmSTZCH5
         fbRjvwb2D2hrntOfIaWVsWP+XsCSlVGwgzy6KXhlFc4Mh3F5qt0tnkWZWVfLrPYAiPnJ
         IOlB5F6achEhcoi2d8K/ZMGXkFV+RjpY0biiy9awU09+ZMPMSpi5s+filduWPg9Is9Gt
         4aVA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779370290; x=1779975090; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5+Tg5A2q1rSTmypZ4m7QNpGOwZSgbWFsRlyJMtjn0p0=;
        b=qRSMOwI0XBET/8euztW+AH0VZZwaiT7/LbypD9XjFAOklHoMTxCUO1KLWX6LLFaV60
         fxlExqTinsYnwtHM1RLzdUOcx0KyVdG7neZsQF5BRurImQJ2jJtt6UshoXkhD1NswW4E
         F0hfR5JhEbNthRbNi4a5T2bHuVRDlD2PsW7QG5AASVoPozDXiFgmQ7S4Uxf2l6PUu4rf
         hNeYWB8uvK8gKRvLwqy91LzqH/6dbGAKsn3h34CV5BewQtLGIaByNrJv3V+gXUMof2DA
         BsYJRB96MQYECSi2enWRkfRI3grve+lkIhHmR998PYFwy6GCg5I8+t/bpnPZ2nROye8i
         JVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779370290; x=1779975090;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+Tg5A2q1rSTmypZ4m7QNpGOwZSgbWFsRlyJMtjn0p0=;
        b=fO7x0C3OwZl/T2rQME2C68c7CIWozoVhofIbQce1XRAzciw996WurXQ6dUoHfjlY5F
         QV5buPCUilxNK3iOwkUz4IiLmeAgK6OOApZqRNMkJEgpP8SwDVKmNxDgYJWA4eeoPc6s
         DJLtI3JNgeHdQZGD2Dn6pzZPd0ZrxgNahIJQCU8RkZX1M3y4pamgRneuOIGfIfjfDPP/
         HMO9Ya0s109F0XBxTzbHLUNM2RHfn2mGFcO685R/XBBLICwXkzuFYPXf7DTS0ZV3iZMv
         am3ote/ftvjxwLfd9kI0iS3t1OaL7pU+nDtYs9QBVZqDVIpReMK7tSJJ4QlU7hg7+3tf
         QETQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ZhcSQok8rwF5kgFtLiBJC8icTMJa1RxnBlBYjiBi1OPZc+0n1RJvl86aEPqDu/6VOh1uMetM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNAUOYW2hK1hxtAgwNriuIuClHnmxK58I/lrAgljBGRGihnHS0
	0cCtMuOpC+BA1mnyg8/nO+pizfriPdIH4GmEXIV+Oi9Ons/xg8zHq+fL5gQ9IfQt64GBs+1yPR/
	yTOL+plLxbvmMfqM9A3n24Qm2ON9Ein+neuE/MhPR
X-Gm-Gg: Acq92OF1G99TDfzkpRNSnb0GA03qgv3DtpGvVrkpvD5WNBiy+ug2XtZBslqLzebUjqI
	IoDniZ2RtZ7I79cIywM7kKdhctCiI6NrDm4PVpP6ZzYzCbd/oXoAyEjgMEINP/ZKsNMQ8Jg8nFo
	abyKnvBb/SVxdb/rUG0VV0daX6jFnbwzXWM+QCbUdS22735SgbbWpXqPovRUqrRxZxLHvvbUvQ3
	2CohieBejoUzGQlGokC92ZY9vtUUXodZMFm6reTYO56oOh0+sJQGYVFIBcVIa3z2r0PGw+BVExA
	c+oktB0vwDWCxUhRyjw=
X-Received: by 2002:ac8:5945:0:b0:514:b17e:86f3 with SMTP id
 d75a77b69052e-516c545d419mr9811621cf.12.1779370288694; Thu, 21 May 2026
 06:31:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com>
 <20260521102149.804874-2-vdonnefort@google.com> <CA+EHjTxPoxjvMTZX5w+UyVgC=W3VUSDoOQ-tCDLfnae16SqoMQ@mail.gmail.com>
 <ag8GvtAonB6LNB5m@google.com>
In-Reply-To: <ag8GvtAonB6LNB5m@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 14:30:51 +0100
X-Gm-Features: AVHnY4KrdKGWYydx9yhZf1wn2cakxt9es8y5lQpSEP6pVl9oimBEtzwNxOuc5kg
Message-ID: <CA+EHjTyrfKLZ1o1szYz3UUA2oq+GZOAeA7ta3ohxKeBDMS9y_w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Reset page order in pKVM hyp_pool_init
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 May 2026 at 14:21, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Thu, May 21, 2026 at 02:07:36PM +0100, Fuad Tabba wrote:
> > On Thu, 21 May 2026 at 11:22, Vincent Donnefort <vdonnefort@google.com> wrote:
> > >
> > > When a VM fails to initialise after its stage-2 hyp_pool has been
> > > initialised, that stage-2 must be torn down entirely. This requires
> > > resetting both the refcount and the order of its pages back to 0.
> > >
> > > Currently, reclaim_pgtable_pages() implicitly resets the page order by
> > > allocating the entire pool with order-0 granularity. However, in the VM
> > > initialisation error path, the addresses of the donated memory (the PGD)
> > > are already known, making it unnecessary to iterate over all pages in
> > > the pool.
> > >
> > > Since the vmemmap page order is a hyp_pool-specific field, leaving a
> > > non-zero order on hyp_pool destruction is harmless until another pool
> > > attempts to admit the page. Instead of resetting this field during
> > > destruction, reset it during pool initialization in hyp_pool_init().
> > > Note that pages added to the pool outside of the initial pool range
> > > (e.g., via guest_s2_zalloc_page()) must still have their order managed
> > > manually.
> > >
> > > While at it, add a WARN_ON() in the hyp_pool attach path to catch
> > > unexpected page orders that exceed the pool's max_order.
> > >
> > > Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
> > > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > index 25f04629014e..89eb20d4fee4 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > > @@ -322,7 +322,6 @@ void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
> > >         while (addr) {
> > >                 page = hyp_virt_to_page(addr);
> > >                 page->refcount = 0;
> > > -               page->order = 0;
> > >                 push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> > >                 WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
> > >                 addr = hyp_alloc_pages(&vm->pool, 0);
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> > > index a1eb27a1a747..c3b3dc5a8ea7 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> > > @@ -97,6 +97,8 @@ static void __hyp_attach_page(struct hyp_pool *pool,
> > >         u8 order = p->order;
> > >         struct hyp_page *buddy;
> > >
> > > +       WARN_ON(p->order > pool->max_order);
> > > +
> >
> > Could you add a brief comment? It took me a minute to figure out what this
> > catches. IIUC it's not attach's own input, it's a stale p->order from way back
> > when an external page was popped from a memcache (today only via
> > guest_s2_zalloc_page()). Right?
>
> I think it'd be self explanatory if that was next the page_add_to_list, but that
> wouldn't protect the memset (that's really best-effort though).
>
> How about?
>
> /*
>  * A page with an order bigger than the pool's max is an 'external' page
>  * whose order hasn't been reset before being added to the pool.
>  */
>
> But now I am thinking I can do way better: we can easily identify external
> pages, so I could just force the order to 0 in that case.
>
> WDYS?

Yeah, Sounds better. The WARN's scope was actually narrower than the
real risk. Forcing order = 0 on entry covers all of that and removes
the implicit caller obligation the WARN was best-effort enforcing.

The memset is trivially safe then too (PAGE_SIZE << 0, regardless of
what was in the vmemmap).

Cheers,
/fuad

>
> >
> > With that.
> >
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > Tested-by: Fuad Tabba <tabba@google.com>
> >
> > Cheers,
> > /fuad
> >
> >
> >
> >
> > >         memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
> > >
> > >         /* Skip coalescing for 'external' pages being freed into the pool. */
> > > @@ -237,8 +239,10 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
> > >
> > >         /* Init the vmemmap portion */
> > >         p = hyp_phys_to_page(phys);
> > > -       for (i = 0; i < nr_pages; i++)
> > > +       for (i = 0; i < nr_pages; i++) {
> > >                 hyp_set_page_refcounted(&p[i]);
> > > +               p[i].order = 0;
> > > +       }
> > >
> > >         /* Attach the unused pages to the buddy tree */
> > >         for (i = reserved_pages; i < nr_pages; i++)
> > > --
> > > 2.54.0.746.g67dd491aae-goog
> > >
