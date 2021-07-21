Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2DFC07E9B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 08:21:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A60F6120D
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 08:21:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A60F6120D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DDAB4B13B;
	Wed, 21 Jul 2021 04:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rOUEIoHz4T5e; Wed, 21 Jul 2021 04:21:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F174F4B12C;
	Wed, 21 Jul 2021 04:21:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 114004B12A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:21:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8gFFZlrd7Uny for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 04:21:17 -0400 (EDT)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com
 [209.85.210.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E3E24B126
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:21:16 -0400 (EDT)
Received: by mail-ot1-f48.google.com with SMTP id
 59-20020a9d0ac10000b0290462f0ab0800so1325021otq.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 01:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4ljbr/BjAQXHoSjfnU/poMdQSYUhBIQOTVvbtplVbjY=;
 b=maSbKwVEYZFFrT24oXzJTzTOFffLltJ2yi6OgUCQHiqvRT85jX60r2L6xt7dT0MY5R
 /fGwK9XK8BJcx5IsZrxvnVhoXBjAAz5SG2EfRDTEMXvDD28Z6wGxqmQS4hDMZnRGrmkN
 bl/nkg4ZmCQEAg87r9gh994HwjiJdxV17bIpUWA9vyfq119CW6Sa0ePvxWqdHa8SGAJX
 P25ELNgH8iHrF1XL/XmGI5I/04pPt1Ro4pb/xyUVMtmmrPFmuLWE6p2CasMElZueQDRD
 iQ10xmDmbi+QaWVpgQ2bzpEKjMk93cEH11VC1GjuehVWtk3pbPKhydBEhZw2TYUIgh4L
 tJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4ljbr/BjAQXHoSjfnU/poMdQSYUhBIQOTVvbtplVbjY=;
 b=kNC2/dVj3+QMzStP4hxyJBy5LgbEnQWuWTdpFdWYJqQPPTaXA2/5Si0QfyAczajRGB
 7AIXiqq+pgBLYwSYYq3xG4MRS0ZQs3GFkfx+6BrNdwVL183Jmk7iCUi9JeW4Fi0QjmuV
 KJsV1/NyQRitIU2tRxlKQOqTOxUYfbBgROr568qa43r2IC/VuCLycTi0NHpd0wy9bslf
 9jHgnGBQ+CFN/avcXNpGMPyOlMvgyECBdtu0xrF/rLZwKUQzYTcBTytyhV0RVo/bRcOa
 je6fgLHhZ9WCoLWRErIL5w9jwaI0Qb7jC9nIOOSTY+tri9I2d3kTHqABKiPxslDKNIyo
 SNGQ==
X-Gm-Message-State: AOAM53056HXnTgkX+JbIr6pTWV4mg6whwzm5as5AKt3UijiyxgYqAdPd
 7LyQlj2djzmgL9U0Gq1x+rwf6FbKrdLYMNkum6PQcg==
X-Google-Smtp-Source: ABdhPJyyehspCNVbLKAckLKJrrmnVHUkrdP6T8Euhhbd/dhCTqA37omyVRmpregC0z9MvGHlZQwyoWvs7UCHgaemIh8=
X-Received: by 2002:a9d:4b02:: with SMTP id q2mr14525860otf.52.1626855676138; 
 Wed, 21 Jul 2021 01:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-12-qperret@google.com>
In-Reply-To: <20210719104735.3681732-12-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 Jul 2021 09:20:39 +0100
Message-ID: <CA+EHjTwGCZY8CzM_zBQ6yWCTVu_B-GZFvvHPBUqRW-jr4LDE2A@mail.gmail.com>
Subject: Re: [PATCH 11/14] KVM: arm64: Expose kvm_pte_valid() helper
To: Quentin Perret <qperret@google.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Quentin,


On Mon, Jul 19, 2021 at 11:48 AM Quentin Perret <qperret@google.com> wrote:
>
> The KVM pgtable API exposes the kvm_pgtable_walk() function to allow
> the definition of walkers outside of pgtable.c. However, it is not easy
> to implement any of those walkers without some of the low-level helpers,
> such as kvm_pte_valid(). Make it static inline, and move it to the
> header file to allow its re-use in other places.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 7 +++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 6 ------
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 1aa49d6aabb7..8240c881ae1e 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -25,6 +25,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>
>  typedef u64 kvm_pte_t;
>
> +#define KVM_PTE_VALID                  BIT(0)
> +

I don't know if there's a better solution for this, but having the
KVM_PTE_VALID by itself here, with the rest remaining in pgtable.c
might be confusing. I see that you probably don't want to move them
all here because they are internal to pgtable.c.

Thanks,
/fuad

> +static inline bool kvm_pte_valid(kvm_pte_t pte)
> +{
> +       return pte & KVM_PTE_VALID;
> +}
> +
>  /**
>   * struct kvm_pgtable_mm_ops - Memory management callbacks.
>   * @zalloc_page:               Allocate a single zeroed memory page.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c7120797404a..e0ae57dca827 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -11,7 +11,6 @@
>  #include <asm/kvm_pgtable.h>
>  #include <asm/stage2_pgtable.h>
>
> -#define KVM_PTE_VALID                  BIT(0)
>
>  #define KVM_PTE_TYPE                   BIT(1)
>  #define KVM_PTE_TYPE_BLOCK             0
> @@ -135,11 +134,6 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>         return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>  }
>
> -static bool kvm_pte_valid(kvm_pte_t pte)
> -{
> -       return pte & KVM_PTE_VALID;
> -}
> -
>  static bool kvm_pte_table(kvm_pte_t pte, u32 level)
>  {
>         if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> --
> 2.32.0.402.g57bb445576-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
