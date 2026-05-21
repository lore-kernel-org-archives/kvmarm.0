Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF853CBE69
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368897; cv=pass; b=pHv/B56mgw6im2iY8+6Ct28UT8x8I0hrb3ez3rtsGcxekOww7Qes4JMKuYr/uZhFWANtM9/UwiDNhcEEQjMYIwG+Y42QLKDVKl0zk4iC+G2etDIpl/pA9yfyexjmaBO7FMTC56eaGfuPxwjb/X855a6MTCi0SuEYNMGRG2jHOMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368897; c=relaxed/simple;
	bh=1HBW9Xd7VKCBlabYPTkXBflzDF7j6VONq+YdaP2AeII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g6RhIgT99hF6KMWyvdCNqkXUgjfphb6h9fwWj7RCxqfw3AV8v2YGEbbwgWIW3gSej38++/dHyU18Mx9PGL1D74iwqq3Ok2QSHWvIaumZQbIccsVwqr0EuNSva8Cb+slijkbf3WQg4idF+DuxrjG6loudZpaTp6fsa0n7amvUiUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZmFNYm+x; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZmFNYm+x"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d864c23bdso21981cf.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:08:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779368895; cv=none;
        d=google.com; s=arc-20240605;
        b=SyLgyBcNMCFnF3KUOrFcyn7BDCMgbMhF1nmUdtJf8WqV48DRn0F3YhNbMMzyRs4pwM
         o3uY2m+NkVOCBD/iAzXe2G/91KqRSZQkVNWzL7Nog3khate+MhC4jkWB88jayOxD8OBL
         DwsZgLJFrNvaykJyhsN6zj3TzDjp7HXSQBULtU0b1qDtmgxe79+qxlmwb194FJqG5a3N
         klywAfZmcEnX7++WeP/zo8LagtbW0bbrwJu0XievuS4mi6UPkLH6p7/aaJpTOwTv182h
         SjFHGWSdk7ZrlqR0/x8dDdgLOSEGvwhoKx6TzjoqmGbc/6w6gQt7mdedvgk+u1+tdX0u
         jj4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ioEzmXHuVthmvT1VW0zwCCGdbJiMgEB9gdSvDBe2i+A=;
        fh=d3qYz4YG+rfDJUDspmmHaWud45NCEgtzxx7VbWk1SLw=;
        b=k1IhcCj3nNAm79EUsO3rOqMNy174i/ZkHQgZwywz5O+f6G/T6z3ecYGRUqcLIfPaSl
         5Q+ffp6+MJxFBCSVprx2seLZn96v942C+KSjSXDTo4Sf70N6zuKscQ8gRildPFjjn3r9
         Iq/hDxa8NOLXFQm4m1+MOmhX8Yc7BA6rdH3UnUucBGn9PHuHwGTj6/or2mnlp//iujJL
         K51RaRRg/u+m9Ccl1lO0Qw92uYZbIZynJL4srvoJD6RnMJOhmHxlTOmBbRUZn3IeyzxQ
         rtZiI5/ZlPhO8BsG5W9y/eYuD0iPQbOHoledR1Z+RrUz0c2xqWKGCLO79QjmsNHAGeFd
         SKhw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779368895; x=1779973695; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ioEzmXHuVthmvT1VW0zwCCGdbJiMgEB9gdSvDBe2i+A=;
        b=ZmFNYm+xSFtCoSq+5zwjnSGegsq+WBNZvgQXyFLDk+8uQNC4nzPiQ7BdNPOOALklC+
         dlYixd2wNBFvEqmcdbVT/YALJjRJgum6uwA8agicjSao57WDFuMfh6ZO6SNUAtZiecvl
         aCmLqlBf70iJICcPIDeTJtIl7G3d64judYjo4zAkHd5rNocbKruzJSeydAb+rqNnIAvd
         BaqND84vijIUyZo28mi9Pb5hr79Gjtb7MsmewIsR90tFQeCAULeiucQ8MUf4izyi6byS
         2NgQJZZc4FAlA2i2LVr0D2CfyBgbnjgZTbH+P+qNeR2n1dZtfQgkRnEfUPtc2wjdRIXL
         I0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368895; x=1779973695;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioEzmXHuVthmvT1VW0zwCCGdbJiMgEB9gdSvDBe2i+A=;
        b=Fk1HcaP/LivCt8tyAYVpOSJJjTi/++Vkin0XycEFS/yviAifGk1f0rC0MIZ+oOWBTo
         ep7A96f/b9pEzVajqPNy+hQ2fu2uOj3MfhYPtZOoviaJV70Zpuq1TzqchE5NiXR6chRJ
         /Mnx3zOLgHeFRgdCddOOqr87Xu6BFQEmD86XGmSfjkDyTat1WM+IRk/MMEkrYH7VYedC
         Vzs25SXWSWOoDAk9GyEqTk+XKfiEhAhr3YyoQt+ky6THUyAwmbL1evSNR4mEMJlgH5Xv
         R7+17A6mdSMBHo4kbE5OksZgv7/Es99vK8+J8rrro2b/bQvzF7J8W8LC+jopKiuCRtHI
         cgFg==
X-Forwarded-Encrypted: i=1; AFNElJ+bPKntimZ6j4GozFnYhnLIm07nBwqH4kr1szKidChevEULoa19JbVVOZfHZ4uxQvCV7G36CbQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmykutELR+DjldWDbbxh0gZ+rZzukjLpTsEWnLAhXk518aqsTW
	C5WhWGVKjup0qD/II1MQcYCbHb3tzJ7F7S81JAZwGGk3kIzzn3EKzYgK8cX033I5RhcrvaM53ev
	OPChiBIgvgOtpqK6bLIZyGDhrV7yc6KcaG3fNeoFZ
X-Gm-Gg: Acq92OEXHXQTaqJ3J9vxPY+b6UNGm4nHPuKYE58SY+zlcwYsb3xVT79NaFDD0urOb52
	+aRtnpgAlRiXHorZR2g8rFL3zoAeSB7+xqPGKo10wJBtU4WbITR6fl9RkGstUj9elT+yVC2nuTm
	58b7UIrdClhqjk+nNjHevwTrHMvSHQ6NVKIj/2BKmGSl05Hr89pStDYwkB57lmd5uyDeAUqSrE7
	l7c1sOc2ZoCWHljXdJURgCPabS/iA+KQV0IOF3BJh+XB1Vy2oFsmP+V2BplEgSCdmJQ4/p28E2H
	ZcoeGsCgbfmgGU/KIBI=
X-Received: by 2002:a05:622a:4a8f:b0:516:9871:9a37 with SMTP id
 d75a77b69052e-516c530d214mr378741cf.3.1779368894161; Thu, 21 May 2026
 06:08:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com> <20260521102149.804874-2-vdonnefort@google.com>
In-Reply-To: <20260521102149.804874-2-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 14:07:36 +0100
X-Gm-Features: AVHnY4KpHOKPjBT7EqKWxkA57-QgUd5s-jhv2KTVVou9FaixwRXZGIGkqf1v4Bw
Message-ID: <CA+EHjTxPoxjvMTZX5w+UyVgC=W3VUSDoOQ-tCDLfnae16SqoMQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Reset page order in pKVM hyp_pool_init
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 May 2026 at 11:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> When a VM fails to initialise after its stage-2 hyp_pool has been
> initialised, that stage-2 must be torn down entirely. This requires
> resetting both the refcount and the order of its pages back to 0.
>
> Currently, reclaim_pgtable_pages() implicitly resets the page order by
> allocating the entire pool with order-0 granularity. However, in the VM
> initialisation error path, the addresses of the donated memory (the PGD)
> are already known, making it unnecessary to iterate over all pages in
> the pool.
>
> Since the vmemmap page order is a hyp_pool-specific field, leaving a
> non-zero order on hyp_pool destruction is harmless until another pool
> attempts to admit the page. Instead of resetting this field during
> destruction, reset it during pool initialization in hyp_pool_init().
> Note that pages added to the pool outside of the initial pool range
> (e.g., via guest_s2_zalloc_page()) must still have their order managed
> manually.
>
> While at it, add a WARN_ON() in the hyp_pool attach path to catch
> unexpected page orders that exceed the pool's max_order.
>
> Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 25f04629014e..89eb20d4fee4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -322,7 +322,6 @@ void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
>         while (addr) {
>                 page = hyp_virt_to_page(addr);
>                 page->refcount = 0;
> -               page->order = 0;
>                 push_hyp_memcache(mc, addr, hyp_virt_to_phys);
>                 WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
>                 addr = hyp_alloc_pages(&vm->pool, 0);
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> index a1eb27a1a747..c3b3dc5a8ea7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -97,6 +97,8 @@ static void __hyp_attach_page(struct hyp_pool *pool,
>         u8 order = p->order;
>         struct hyp_page *buddy;
>
> +       WARN_ON(p->order > pool->max_order);
> +

Could you add a brief comment? It took me a minute to figure out what this
catches. IIUC it's not attach's own input, it's a stale p->order from way back
when an external page was popped from a memcache (today only via
guest_s2_zalloc_page()). Right?

With that.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




>         memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
>
>         /* Skip coalescing for 'external' pages being freed into the pool. */
> @@ -237,8 +239,10 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
>
>         /* Init the vmemmap portion */
>         p = hyp_phys_to_page(phys);
> -       for (i = 0; i < nr_pages; i++)
> +       for (i = 0; i < nr_pages; i++) {
>                 hyp_set_page_refcounted(&p[i]);
> +               p[i].order = 0;
> +       }
>
>         /* Attach the unused pages to the buddy tree */
>         for (i = reserved_pages; i < nr_pages; i++)
> --
> 2.54.0.746.g67dd491aae-goog
>
