Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2CFC43214
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 14:53:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8CA8F6112E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 14:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8CA8F6112E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C514A023;
	Mon,  2 Aug 2021 10:53:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 67lqoEGt-lyi; Mon,  2 Aug 2021 10:53:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD1A94A19B;
	Mon,  2 Aug 2021 10:53:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A554A023
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 10:53:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 64vYL50i5xlE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 10:53:26 -0400 (EDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
 [209.85.218.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EFCD405D8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 10:53:26 -0400 (EDT)
Received: by mail-ej1-f51.google.com with SMTP id go31so31263557ejc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 07:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=E6FWmVZfDjLa3Evt0Fn+50V6XguYMilIcMj6+S8hDhM=;
 b=oqcZv0fOKw49s1dfDkn3QFtKKh7kUyBUbZ8eUoFgJ8Wew0rRh0D53TByBe7u1Ny/Tj
 rb3WFV1VdhGjk1pcruAVZ06h17QB8sUxhevCi8xak9Z0Ap0gUaM19wLcNfV3aj1tT4ls
 dmbSsjIPjjl1kvegq73ZdqYxSiXVKOjJaFAc+SPfwWX5Oqh81C38ksHRFoV44ner6ZNI
 eQLlk7/f0CdxexEgNQJEsQIgc/GEoN4UrvzsjQi4CqiQo/X0mQDk1xSmt/6bPj/UXoJ8
 dZhPBljGPMHWCY+wJVDL7dAnrjNFKP6Sm682gzLvtxgaXxjHJ1sETrB/tRrSQlnnrfqV
 KO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=E6FWmVZfDjLa3Evt0Fn+50V6XguYMilIcMj6+S8hDhM=;
 b=qmdyGmcwaKWkRXf5xuvM2mp/nylTHW/v3BnliqVmQ0Oq6bAkgmQ0mWww133mqrkFaF
 CLWZLxT3oQkOn5kmwclZiU9iGM4QP0pEnrX8sMI5Yzqes1RHR8h7SSsLVa6LRkq1LAHV
 RR9kjXxTTl/xTWm+UEMaIYaXmM1zpbDC+y1e159Z3KBEXlawKVL6HNnt/5QmAomyGbGy
 WjPgUPuhzyeTFQX3UK1sY7CaUvrFYKf1DqWdhcX+KQ9YropKpVud6GZo7haEiXu3VhJO
 SVtlsi0wZkSJthKrNSn3pEUHSyB6J8SoJ1iQ70hipQ7aFVy9tY6kxvRFVwDTU+rTAy14
 5Biw==
X-Gm-Message-State: AOAM530JDkWmx4N2QcGK6BXBvDHeElSk6YvC92KqYMJO+FXGctOcqFot
 vAvmz2btog8oI4q8KRHmHhWS0wkgzPz12JWwMYUi/Q==
X-Google-Smtp-Source: ABdhPJwPorqtqpze/8XQ3IeLdPsZ4jw4SoXKq7dwTegBWGeXoiFEXZRNPE+1Z17aC6tvi1oLm0ZA4BY5mG/BOH9M7fQ=
X-Received: by 2002:a17:906:cd1a:: with SMTP id
 oz26mr15845091ejb.101.1627916005678; 
 Mon, 02 Aug 2021 07:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-17-qperret@google.com>
In-Reply-To: <20210729132818.4091769-17-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 16:52:49 +0200
Message-ID: <CA+EHjTwL+grX__03SfeDdxeppjSovEZhKRvqjmA_4kSBwsjswg@mail.gmail.com>
Subject: Re: [PATCH v3 16/21] KVM: arm64: Enable retrieving protections
 attributes of PTEs
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

On Thu, Jul 29, 2021 at 3:29 PM Quentin Perret <qperret@google.com> wrote:
>
> Introduce helper functions in the KVM stage-2 and stage-1 page-table
> manipulation library allowing to retrieve the enum kvm_pgtable_prot of a
> PTE. This will be useful to implement custom walkers outside of
> pgtable.c.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 20 +++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 37 ++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index d5ca9b6ce241..7ff9f52239ba 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -505,4 +505,24 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   */
>  int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>                          kvm_pte_t *ptep, u32 *level);
> +
> +/**
> + * kvm_pgtable_stage2_pte_prot() - Retrieve the protection attributes of a
> + *                                stage-2 Page-Table Entry.
> + * @pte:       Page-table entry
> + *
> + * Return: protection attributes of the page-table entry in the enum
> + *        kvm_pgtable_prot format.
> + */
> +enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
> +
> +/**
> + * kvm_pgtable_hyp_pte_prot() - Retrieve the protection attributes of a stage-1
> + *                             Page-Table Entry.
> + * @pte:       Page-table entry
> + *
> + * Return: protection attributes of the page-table entry in the enum
> + *        kvm_pgtable_prot format.
> + */
> +enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
>  #endif /* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 1915489bb127..a6eda8f23cb6 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -363,6 +363,26 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>         return 0;
>  }
>
> +enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
> +{
> +       enum kvm_pgtable_prot prot = pte & KVM_PTE_LEAF_ATTR_HI_SW;
> +       u32 ap;
> +
> +       if (!kvm_pte_valid(pte))
> +               return prot;
> +
> +       if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
> +               prot |= KVM_PGTABLE_PROT_X;
> +
> +       ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S1_AP, pte);
> +       if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RO)
> +               prot |= KVM_PGTABLE_PROT_R;
> +       else if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RW)
> +               prot |= KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;

nit: why not use the freshly minted KVM_PGTABLE_PROT_RW?

Thanks,
/fuad


> +
> +       return prot;
> +}
> +
>  static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
>  {
>         /*
> @@ -565,6 +585,23 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>         return 0;
>  }
>
> +enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
> +{
> +       enum kvm_pgtable_prot prot = pte & KVM_PTE_LEAF_ATTR_HI_SW;
> +
> +       if (!kvm_pte_valid(pte))
> +               return prot;
> +
> +       if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
> +               prot |= KVM_PGTABLE_PROT_R;
> +       if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
> +               prot |= KVM_PGTABLE_PROT_W;
> +       if (!(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN))
> +               prot |= KVM_PGTABLE_PROT_X;
> +
> +       return prot;
> +}
> +
>  static bool stage2_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
>  {
>         if (!kvm_pte_valid(old) || !kvm_pte_valid(new))
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
