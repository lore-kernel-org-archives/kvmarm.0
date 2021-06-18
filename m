Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A7FC48BE8
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 09:29:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9BAE1613E1
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 09:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BAE1613E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 188744A3A3;
	Fri, 18 Jun 2021 05:29:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AbM0zCu0CEnV; Fri, 18 Jun 2021 05:29:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 188184A418;
	Fri, 18 Jun 2021 05:29:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00C734A3A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:29:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TQZkwToTia5u for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 05:29:39 -0400 (EDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com
 [209.85.210.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDEF84048B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:29:38 -0400 (EDT)
Received: by mail-ot1-f45.google.com with SMTP id
 6-20020a9d07860000b02903e83bf8f8fcso9053634oto.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 02:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=N/qwmYB+XdX9IWGAxOnGY9FuYF4paO9b0DILqAiiyD4=;
 b=ukSsBJQ1E59E3x8w6/nvtF76OYRFR47kxQSpjcZN3MI9ZL8YorOWl/yPIzCH6S8az+
 K7IbWVot1ZFKlr9W/cVkRjOZeil1SkqOXI+pEuv+dyVO0uxeCHG2516DfBxsEriGBkQu
 1Ou3qFOYOAfSiMN0XwCHtF+0PMfy8QU7vzVOa7S4Nz6bI+/9AWbF9bybNcaFBoXr9v+q
 ZIHb+/6t8OUGw3FhNkONlLbPTaL707jQ/Vr7vGucFY5MAv4CGhJReCIVuUByFZND4sRC
 IyPEoErHPcyrhQ+QPfyN+xIr++MgjHwITJ86CajL0L/rFhipAzAVMGDdWnCgmcVoNOas
 y5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=N/qwmYB+XdX9IWGAxOnGY9FuYF4paO9b0DILqAiiyD4=;
 b=hLk1OIyC08tHGstwvIDZ4wP9IQlZAynh73Zib9H6oDbsk0xpPvZ0SeE01+o5u1nn6i
 FmK8lM/piZzSPZSuuTfclpDsAVfp+lL4vyLkTOxaQE9obbsavWECyyQpuncXXn+uBxnE
 AW4lL6SCzwOvPxS4P6ElU/qPG6xrQTj0OIM8y6VGJx/UcY0hr6BXMwB3igAD3pSQ+o5b
 4oUDhtWDRAjcpHPh/L1Ywe5e5PLfP6pF1g3VprqnWqwAgEsl8HU04ff8IdxDHl7KFeQS
 Iw3tSkvi0rAMewoheaUikIj5F9XItn8oXFCQv+5eJ5VHREodR48Wqw8BvlWNcVETYqn2
 c+cA==
X-Gm-Message-State: AOAM533MZ9zpaeTFPHftSAvetO3HHQJAM6YUKvY2Pi+cP77x7lm/KVti
 0XHc0xMsm7v8kZGhHyhLtsIVtNLAFL1keh6AYV74qg==
X-Google-Smtp-Source: ABdhPJy34bTXMGIWJlSVjHMhTC48jR0vAtQDfnNfPeWsE4KxnDAcP0mvJ7OTC20GbVGyNRrT4alrOBZJO+ruEnem2vo=
X-Received: by 2002:a05:6830:1002:: with SMTP id
 a2mr8201355otp.144.1624008578100; 
 Fri, 18 Jun 2021 02:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-3-wangyanan55@huawei.com>
In-Reply-To: <20210617105824.31752-3-wangyanan55@huawei.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 18 Jun 2021 10:29:02 +0100
Message-ID: <CA+EHjTwyQ6t3jy9SQ0bfC6W9Ngju7ysGHpsXu9L2j5qwoRJUfQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] KVM: arm64: Introduce mm_ops member for structure
 stage2_attr_data
To: Yanan Wang <wangyanan55@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Yanan,

On Thu, Jun 17, 2021 at 11:58 AM Yanan Wang <wangyanan55@huawei.com> wrote:
>
> Also add a mm_ops member for structure stage2_attr_data, since we
> will move I-cache maintenance for guest stage-2 to the permission
> path and as a result will need mm_ops for some callbacks.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c37c1dc4feaf..d99789432b05 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -861,10 +861,11 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  }
>
>  struct stage2_attr_data {
> -       kvm_pte_t       attr_set;
> -       kvm_pte_t       attr_clr;
> -       kvm_pte_t       pte;
> -       u32             level;
> +       kvm_pte_t                       attr_set;
> +       kvm_pte_t                       attr_clr;
> +       kvm_pte_t                       pte;
> +       u32                             level;
> +       struct kvm_pgtable_mm_ops       *mm_ops;
>  };
>
>  static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> @@ -903,6 +904,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>         struct stage2_attr_data data = {
>                 .attr_set       = attr_set & attr_mask,
>                 .attr_clr       = attr_clr & attr_mask,
> +               .mm_ops         = pgt->mm_ops,
>         };
>         struct kvm_pgtable_walker walker = {
>                 .cb             = stage2_attr_walker,
> --
> 2.23.0

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
