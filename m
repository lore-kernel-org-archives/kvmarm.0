Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9726AC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2707B60EBD
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 04:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2707B60EBD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB4F04075E;
	Tue, 10 Aug 2021 00:39:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xSYoznFKPDf2; Tue, 10 Aug 2021 00:39:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C613A407EC;
	Tue, 10 Aug 2021 00:39:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E53104075E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:39:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c+VfgxAPRWDQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 00:39:08 -0400 (EDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA5FC406DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 00:39:08 -0400 (EDT)
Received: by mail-ot1-f47.google.com with SMTP id
 v10-20020a9d604a0000b02904fa9613b53dso9679036otj.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 21:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=UMFQDtJfJF2Z8IAcGX8deSauImQlRu6R2zUBaKg66SA=;
 b=uJUvnv9Oa0JSABisOkmc0JRxljR5Q0vxiz6uz6OXOs86o2qR7n0ZqyJWwjWimiKr+A
 tZHzy8oOwrvz906N5j9vfQr/ZoEX7M/NfFMB1gAPlGGAUrLI3oflIVG2KqbaqaxirAdI
 UAqcpepluxv/L2G6zLmPCSdoj0tqhFbLJra790uZ50D4Lxv11y7Wmw5usBPtOBPeASmB
 Gm4jh1Dc5D6A4oN+mR4BCXxzfwfV/8XZOe9/z8jNAWQDO2+9E/OcGZ4iws4hlECSA4HZ
 a0fVANXJHO/mnDkt0OpRRr9sXIczLflr1G/uJPiVPPDNUOnIcn6JQht945WV5Y+PiQxi
 NQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=UMFQDtJfJF2Z8IAcGX8deSauImQlRu6R2zUBaKg66SA=;
 b=X1SpTFF7+IMeYNZCigIJFxZaPSyZLKgL1PpIdHlOD/YXk9NIWZUOO6VcyYlraPYFqR
 U4S+JTAhqkVQZs8F808/omWt9dSgxrQ5dWgCe+OznJC9rIClv7cRsR96SdghR8+JbHVg
 OWC0az+5XFZr9+VjwozwSlFJVTWgCZ998o6lkCs2Mnh2FOP3wp/aSsAREChRAOlqhwl+
 t4Um9gpgSjdTst59ZFRE5+hIx1ksUxh/Nq40PquN/53dX9S9xCP3++PUl/eT0rb8k89F
 5zy+JWwQFLxpiWsKC9oM3t51LibWAg7ph8u40beBlYD0Af0y53cu0d/C93HUNfs6jB1C
 bu7Q==
X-Gm-Message-State: AOAM5339bBadGXYUQDQWiRxjXQyTkQgkvs4F7ThNuxmbl04mcwcXvIOa
 szi4B5ltjQZuOLEH1AgLpxBXvIAS+kBbdUSgB8ER6w==
X-Google-Smtp-Source: ABdhPJyvS+1AkGsFP795ybM9ve5pjpgbh+8MfOJDVjge/he7hS4eAwhQnNLI3hx8Ydr4zJzaZPT0XAoiSitu2dAt6Ao=
X-Received: by 2002:a9d:2609:: with SMTP id a9mr3296708otb.365.1628570348246; 
 Mon, 09 Aug 2021 21:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-17-qperret@google.com>
In-Reply-To: <20210809152448.1810400-17-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Aug 2021 06:38:32 +0200
Message-ID: <CA+EHjTyRKnAhE3joW_VNOL51qJToaR=20KhkKXm98bpvymBX6g@mail.gmail.com>
Subject: Re: [PATCH v4 16/21] KVM: arm64: Enable retrieving protections
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


On Mon, Aug 9, 2021 at 5:25 PM Quentin Perret <qperret@google.com> wrote:
>
> Introduce helper functions in the KVM stage-2 and stage-1 page-table
> manipulation library allowing to retrieve the enum kvm_pgtable_prot of a
> PTE. This will be useful to implement custom walkers outside of
> pgtable.c.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

>  arch/arm64/include/asm/kvm_pgtable.h | 20 +++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 37 ++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index ff9d52f8073a..f1651e0153ad 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -506,4 +506,24 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
> index cff744136044..f8ceebe4982e 100644
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
> +               prot |= KVM_PGTABLE_PROT_RW;
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
> 2.32.0.605.g8dce9f2422-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
