Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE2C1DED58
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425065; cv=none; b=NoYvU6bXORnBi/oIB0x0gi+6hagmmJ+qe/f63qSSCmcMBagjE/WDhQylxeBcjkJfBiU22D9Yfdm2+j37DMGhVYHSCgu/BHIWWh0Pq6LJsPIyiuCLQ4OjLJTwwwUMzDqzKtsb6vBIXjZ6n8IRxLtn/hPTE6L8svNqI7/QFyQBShc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425065; c=relaxed/simple;
	bh=oE9r30qVJ25lEtpADYxY0kb0u8ajuTEGjpH+9tV4SVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LPScBYFHywieuIiLzeRC1dUR1prs7RZASTYXZAUtg4pmv8ABvqMbCQDjmBFecFqID0GjtspOrJKy9MJwF8VSYbUhra3D9w4nvh+82GwOCi1lwH+rAW4FSMGQdUiDXXsDEujpbJgukh9n9tPJb9daxStz8hTdI6ea7b1SulY3MIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YLYOLhkS; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YLYOLhkS"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso38325e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425062; x=1735029862; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0XC2ZwAn0E++YNctCTdRNukhVgGGxBVyakf6CmRi2f4=;
        b=YLYOLhkSyB2+LrMijBkSBSjt/ZgJLCCA6QNCUVOy3UCeQRsdPQOwSxlu3iAItyjcx3
         F2cLT8NFXM212pWRphjDUnpWLLlasF8vKHSa3EA7U10Q7kkArx2GsZ7vekIvLCswc+s6
         +ze4ddu+j5HYo0/J6QFnXIjvP2Fxd2huZnNwBNUjfB3UIYj/etvzE1wVSiRi2yKlr1lC
         1eJbC6Fedgx9oHhY/mCYaXIeBGm7ZTB1bpu/jTHpFTo8YLKhFy5b8b43gKWbrbyXypsA
         zOnGnrnyY9bXj0x23CzoTA7qGiqRSC7U0g5uqd4t4YfEbgNQ8hJLv96ZP0B31ST4NH7d
         FsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425062; x=1735029862;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0XC2ZwAn0E++YNctCTdRNukhVgGGxBVyakf6CmRi2f4=;
        b=w3592hBfLn4zs6Okazsz22Yz9phjavSz+v48ECuUsAbDdaKJlf1pkDAQo084MR8/hp
         v2TWpFH415FOKPmQo+WqJpRLvNU2SQiefO5jDnAvpfEUziDbqUaa8m/QGioE1iqu4+Qn
         XI5tHeSabsDNLXRc7igTtiQ59MRhvimWloNqgtwGfRZS7Db1LAD6ze0iY5yExLbVGyS8
         piAso8NaciQPSRkDknuPpMP+4ft9YQqf2Yyg4ymAFPsUhp6VpZxeg0//r52md+CKwr0p
         CEo7gw3PeLT8Qp4h8oBcAcqRx0Hz44oxS2AfuFTLJK5rfTTz5nzaZUnafl1PLgUW0pTR
         Xwew==
X-Forwarded-Encrypted: i=1; AJvYcCWHsxkxz2coCACvhE1ty9eSUZaVLWPtbEvFsKDjdH0rP2tb6Y0g0Ue0HcuvNph59+dd2c78VTs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0jMus1df97Pk1qKLsiB7eXNvLWxZWGCmjI19FVwwn8Bw1atQe
	K2aZ/Rww3ALuOMKpR2lQZ8MEW6mk3/O9zeeielN7bYM5z0FzvUHW8KAdNpPyVphfVcp6TWq5U2X
	czVg6k1sZD64Ftrt1VOL91PbbI0OkMQL0aS9x
X-Gm-Gg: ASbGncsnSATF8xt/rMRTS435tU8JWWTQcG+pOpSKWi3xaPVY9y0iXqWTW7EKvfN4lvH
	dFG0aOjAm4e9mpVltqIZDH7+Kg/j5j6tU/U5ZYnyq/Wae+R7lw2jcv1eBPhVl85rwccs=
X-Google-Smtp-Source: AGHT+IGM0bpr7//XD6OxuzJzrQz8DmDuxUXL0rgx8RL7HNA2kZE/P+I6liY2VW7R5nSj/mMRt13Okt8o4WT6PlKUZeY=
X-Received: by 2002:a05:600c:2317:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-4364901b009mr920745e9.2.1734425061742; Tue, 17 Dec 2024
 00:44:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-4-qperret@google.com>
In-Reply-To: <20241216175803.2716565-4-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:43:45 +0000
Message-ID: <CA+EHjTznFMF77kfUTkMeRpHnz9HAD1gSw6Do6tQvYSJ_jXG3gg@mail.gmail.com>
Subject: Re: [PATCH v3 03/18] KVM: arm64: Make hyp_page::order a u8
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> We don't need 16 bits to store the hyp page order, and we'll need some
> bits to store page ownership data soon, so let's reduce the order
> member.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h |  5 +++--
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
>  3 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> index 97c527ef53c2..f1725bad6331 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> @@ -7,7 +7,7 @@
>  #include <nvhe/memory.h>
>  #include <nvhe/spinlock.h>
>
> -#define HYP_NO_ORDER   USHRT_MAX
> +#define HYP_NO_ORDER   0xff
>
>  struct hyp_pool {
>         /*
> @@ -19,11 +19,11 @@ struct hyp_pool {
>         struct list_head free_area[NR_PAGE_ORDERS];
>         phys_addr_t range_start;
>         phys_addr_t range_end;
> -       unsigned short max_order;
> +       u8 max_order;
>  };
>
>  /* Allocation */
> -void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order);
> +void *hyp_alloc_pages(struct hyp_pool *pool, u8 order);
>  void hyp_split_page(struct hyp_page *page);
>  void hyp_get_page(struct hyp_pool *pool, void *addr);
>  void hyp_put_page(struct hyp_pool *pool, void *addr);
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index c84b24234ac7..45b8d1840aa4 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -41,8 +41,9 @@ static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
>  }
>
>  struct hyp_page {
> -       unsigned short refcount;
> -       unsigned short order;
> +       u16 refcount;
> +       u8 order;
> +       u8 reserved;
>  };
>
>  extern u64 __hyp_vmemmap;
> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> index e691290d3765..a1eb27a1a747 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -32,7 +32,7 @@ u64 __hyp_vmemmap;
>   */
>  static struct hyp_page *__find_buddy_nocheck(struct hyp_pool *pool,
>                                              struct hyp_page *p,
> -                                            unsigned short order)
> +                                            u8 order)
>  {
>         phys_addr_t addr = hyp_page_to_phys(p);
>
> @@ -51,7 +51,7 @@ static struct hyp_page *__find_buddy_nocheck(struct hyp_pool *pool,
>  /* Find a buddy page currently available for allocation */
>  static struct hyp_page *__find_buddy_avail(struct hyp_pool *pool,
>                                            struct hyp_page *p,
> -                                          unsigned short order)
> +                                          u8 order)
>  {
>         struct hyp_page *buddy = __find_buddy_nocheck(pool, p, order);
>
> @@ -94,7 +94,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
>                               struct hyp_page *p)
>  {
>         phys_addr_t phys = hyp_page_to_phys(p);
> -       unsigned short order = p->order;
> +       u8 order = p->order;
>         struct hyp_page *buddy;
>
>         memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
> @@ -129,7 +129,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
>
>  static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
>                                            struct hyp_page *p,
> -                                          unsigned short order)
> +                                          u8 order)
>  {
>         struct hyp_page *buddy;
>
> @@ -183,7 +183,7 @@ void hyp_get_page(struct hyp_pool *pool, void *addr)
>
>  void hyp_split_page(struct hyp_page *p)
>  {
> -       unsigned short order = p->order;
> +       u8 order = p->order;
>         unsigned int i;
>
>         p->order = 0;
> @@ -195,10 +195,10 @@ void hyp_split_page(struct hyp_page *p)
>         }
>  }
>
> -void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order)
> +void *hyp_alloc_pages(struct hyp_pool *pool, u8 order)
>  {
> -       unsigned short i = order;
>         struct hyp_page *p;
> +       u8 i = order;
>
>         hyp_spin_lock(&pool->lock);
>
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
