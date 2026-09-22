Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F61439F77
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 14:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087754; cv=pass; b=gTyqgcsajGyzN4jVx9uPbA7ac/aY/5Fs70f9yoTFSk97Eu/ZI2KXfM3jfOWIivlIlQJKtmeMchLqbRt+bZ2HUEcDHOOAa2Xg1OsBqE6OmCnGmsJlMhfUXkjkcihd7AjpNqOov9eXejfX8Q16pRceBO06b9Vg0AGU2huP2c8yXWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087754; c=relaxed/simple;
	bh=F6DxW3SXJZHdbOOUfkwznpoF++sRCvwou8e7w4hV31c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ScL5VhDEMKsCrMfGijXeEMJ5lJ9pIlTIMNDwuTubfQcwmWh51R4BLTV/EPysRABl6zyWzXk8YxTUWCSymUAaNsxqKEYFXf5e8w3F00HZgKBKcaJDUTIgpAWWDGeIqv0Ez0XOeSL5dzMabhM3ki3CgAEOUwmXwza6u1mnLytcQwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hd43E4rk; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hd43E4rk"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6aa13d8d9d0so12135a12.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 07:35:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790087751; cv=none;
        d=google.com; s=arc-20260327;
        b=HJYWMnUHNE6p94QsjV3EA4x3IJ8itOS3rBW96KcDZcqSwA3DiYVlhZSnuMzFu9OCSF
         7aqWvoPrgJSvN8xRU9XhdDlKv0JAHOWcXxr7l6V2EIVfApPvOZ4XiaYslp8Y+ripwRGI
         hCsTQRqrjc3DPr4ijx2bITRgWCJd3E5cx+uRWS3vWDNYSk2FjyO1YRJnebT5d3/nQViu
         XYn7lVY6MDtwcP7Sl0mwFLoc3EjrBCZc9Z8tkYbp9NmesGR1gRh8ysGsTGnI1+8nbANG
         Qr0gled4syXqLW/hzE3AUS4kmowuokMeI6xo5lHB3twhDx50WdlvtP47H3xWLSkGw7EY
         JC5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KdISmA3ixIlNjIAB3K7umMj0lq95tzNubXcY7qdlJJ4=;
        fh=LojhdoFLhYGkxDegyCY3vvyTkINavhNJCncKWlEzotI=;
        b=fxTGKigKtQJfd33C80ySyftL/fgd80UyL7z/mzctQzfn13fQYl3rNEU6OgUyZHem1B
         UFVs2hNTr1tDETbVr/yiEH5BwirG9Wi4xNUWOhLfB5flcjVZ58gzi6tRPmg4XAM1/Dux
         zCdIAykYxdWUn8HWNWU37A283oeuKwzVsaqx7rjpoIHaEoee20KbQFt1CJ8EML++nMEs
         GxYDGNAF1+XvVyv+bgFSc1iSybEbruaChIYshWh2BM6S1raQqYoLPKRoyI9+j9oL7uoj
         YQcKwtv3VBKqbX9pgQAHQor+dcWDf2po3/KttHJ//eYj4A3lmP+f7mnnz1ZVMBujl2Jr
         MKnQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790087751; x=1790692551; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KdISmA3ixIlNjIAB3K7umMj0lq95tzNubXcY7qdlJJ4=;
        b=Hd43E4rkR8EFR8V/2U/3IcEacH1E2V2Zs1RRhDvNZYW74T4Y2qG19VYDkFRhLZUhsE
         fo8JzUpXjK4zvKARvk1gq0qtWMXeSDr/RyzZnqc8mX3vV9l2rgLUHaHo+ktLss9C0vp/
         E8tAruk6v1I6+YbqaVtpc0lYXSzf16C6R/hgMfJpMfBMszjo3QT4FJIw2Mw7FdKQzUk5
         e6yfDfHnQHw+Op8Yb7EuF5kzShiAnyJW/Q5EbPztTWpvOiSMmABt1S8bGViQV0HvZy9e
         ZscOk3W8FJLG72dpaUr4e7couMlZFiB3owjbRoOpFGI5gKDsFtMHssuh4+z4ueRoA7AX
         /XLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790087751; x=1790692551;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KdISmA3ixIlNjIAB3K7umMj0lq95tzNubXcY7qdlJJ4=;
        b=1viF/S9NnKRnGatxYwHpGJoMXClboQw5GfGl4x2CaMHvdhmhxf2MkR5n1xDPYeGYMj
         Ev7fC93RHxE4+3WBnoIQrji0RZVA4vW96OSFDgsRhESWoENiv/YgmIhF5EnUVsbyfa3T
         6R1GwGw7MFrgl9oSxDI+d4kQQ4f99SiaZaohoYfYQJnAXddn13eebZ85PHmC9DDKtjPO
         VTcX5It6wUCiO0h1lhOvu07HkzRw2lD9iMJaqiAn4vjU+rPRPkxal3mmikBKbjWAto/Z
         rLSMoDndH/z2wCve784PnP8oCxioMMZQS0HDYVkscrKIw68fvzYNpVr8y02zIWTGlkZe
         Pleg==
X-Forwarded-Encrypted: i=1; AKwUvBzpQar61lHr8gWLg/i16L2S5xDGVaxw56mZEhrBmN6yy5Y81WnJQBa/sHeDGfGNbog4p2A6KSY=@lists.linux.dev
X-Gm-Message-State: AFuF++mhX1KYi4qqe/NGQcpV/uUO4IpTIHUSDPRYLIfMlHE4890mMRgP
	HhWg1t7Z8vwJtTwucQakh8rjTHYkXkEyR4VXWrf6/6Fu72ZShpXXVXVfF1nogCRY0rr8fwbvUVI
	7Sc/6x4mohRVhXUO8SgcwXjT9QEecu4oZnGjXwLgK
X-Gm-Gg: AYBFou2ML8DaAFAzLzjXeUgRNVV8iAhW+5FHJxwsjH7XnSbIdEFaDB7HlrZR0+xydHg
	mKpqhvxXhZuA45ZtOKCTjLOAPsxpUnSPAvWTjgB8zPPMKsg4Cp17xwaaNCurHETRnuUO6KnFJRv
	iUv9gp8uJeJZ3z8F7PD002o5A84ZQnJlg1tGsDGUI9T3LTIWt0BKeLzWhqSv7mP0B76TJ5eVAuY
	fLfwONzmAgcj9aC3jnhRaXVy5S1Jfw1QXxLL/lS/8cFGprcKxSL2teUhwCvGVvxbwYjSajCtZSL
	UH898h1ni7X8MMKPCAUzXctzhS0qYtTsEmuVDGKUirwWFFsSXKufGYarEuMnML8sDepkLjrx5+f
	PAxXuaUb6eesVLQ==
X-Received: by 2002:a05:6402:23c8:b0:6a6:f2a5:1b4f with SMTP id
 4fb4d7f45d1cf-6aaac5924eemr8663a12.4.1790087750560; Tue, 22 Sep 2026 07:35:50
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260715150125.2798116-1-smostafa@google.com>
In-Reply-To: <20260715150125.2798116-1-smostafa@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Tue, 22 Sep 2026 15:35:38 +0100
X-Gm-Features: AclHuK-rurQJCakbPVql7LeaZWXspdhQDHQ-9g658VqXPpUrYK4ePYQ8b4RsihE
Message-ID: <CAFgf54rT1wvmGqm+8JqrKShhh+5pEWDS0f4FReT9CJBbcjnk1A@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Use consistent type for pool size
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 4:01=E2=80=AFPM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> All the pool sizes in the hypervisor are "unsigned long" but when
> they get passed to hyp_early_alloc_contig() or hyp_pool_init() they get
> truncated to 32-bits.
>
> That is not a big problem at the moment as to overflow this we need
> 4G bytes of carveout (2 TB of host or guest system memory).
>
> However when new users are added (as IOMMU) it is hard to reason
> about the carveout size anymore.
>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>

Ping, as Sashiko reminded me about this:
https://lore.kernel.org/all/20260922132359.BB0381F000FF@smtp.kernel.org/

This has already been reviewed.

Thanks,
Mostafa

> ---
> For example in the SMMUv3 to avoid this overflow, I add a cap
> for the pools size to UINT_MAX to work around this:
> https://lore.kernel.org/linux-iommu/20260715115906.2664882-9-smostafa@goo=
gle.com/
> ---
>  arch/arm64/kvm/hyp/include/nvhe/early_alloc.h | 2 +-
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h         | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/early_alloc.c         | 2 +-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 6 +++---
>  4 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h b/arch/arm64/k=
vm/hyp/include/nvhe/early_alloc.h
> index dc61aaa56f31..462883c4e325 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
> @@ -7,7 +7,7 @@
>  void hyp_early_alloc_init(void *virt, unsigned long size);
>  unsigned long hyp_early_alloc_nr_used_pages(void);
>  void *hyp_early_alloc_page(void *arg);
> -void *hyp_early_alloc_contig(unsigned int nr_pages);
> +void *hyp_early_alloc_contig(unsigned long nr_pages);
>
>  extern struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/i=
nclude/nvhe/gfp.h
> index 3766333bace9..3a428dc40b14 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> @@ -29,6 +29,6 @@ void hyp_get_page(struct hyp_pool *pool, void *addr);
>  void hyp_put_page(struct hyp_pool *pool, void *addr);
>
>  /* Used pages cannot be freed */
> -int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
> -                 unsigned int reserved_pages);
> +int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages=
,
> +                 unsigned long reserved_pages);
>  #endif /* __KVM_HYP_GFP_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/n=
vhe/early_alloc.c
> index 00de04153cc6..9fef0c7d2185 100644
> --- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> @@ -21,7 +21,7 @@ unsigned long hyp_early_alloc_nr_used_pages(void)
>         return (cur - base) >> PAGE_SHIFT;
>  }
>
> -void *hyp_early_alloc_contig(unsigned int nr_pages)
> +void *hyp_early_alloc_contig(unsigned long nr_pages)
>  {
>         unsigned long size =3D (nr_pages << PAGE_SHIFT);
>         void *ret =3D (void *)cur;
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nv=
he/page_alloc.c
> index 57f86aa0f82f..51460d420c94 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -229,12 +229,12 @@ void *hyp_alloc_pages(struct hyp_pool *pool, u8 ord=
er)
>         return hyp_page_to_virt(p);
>  }
>
> -int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
> -                 unsigned int reserved_pages)
> +int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages=
,
> +                 unsigned long reserved_pages)
>  {
>         phys_addr_t phys =3D hyp_pfn_to_phys(pfn);
>         struct hyp_page *p;
> -       int i;
> +       unsigned long i;
>
>         hyp_spin_lock_init(&pool->lock);
>         pool->max_order =3D min(MAX_PAGE_ORDER,
> --
> 2.55.0.141.g00534a21ce-goog
>
