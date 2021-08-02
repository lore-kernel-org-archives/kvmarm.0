Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E341BC4338F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:50:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67F7560238
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 67F7560238
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 041C54AEE2;
	Mon,  2 Aug 2021 05:50:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YM1BCJ7cGUPq; Mon,  2 Aug 2021 05:50:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCFC740C88;
	Mon,  2 Aug 2021 05:50:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5843440C88
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:50:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pvi2Fy8yQaKQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 05:50:50 -0400 (EDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com
 [209.85.167.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FC5C40874
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:50:50 -0400 (EDT)
Received: by mail-oi1-f171.google.com with SMTP id y18so23486049oiv.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 02:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=b8yWPewOpxEQv7YrShVluvsDfJILeyLSFc02MK8M4Jg=;
 b=mMdp1X5UVpP6BtslW98Pmn4WGS1V9KMePYP8jFuWMlGsfFdVwyUBDVmyVKhoK/mgiz
 DYwQ1Zg2pcEy3GWarwo8/Wed2E+Ds2XfD0k14pt9t/GSwknmApk7fsT4ggMBI0LtK40b
 Jim8WOzKtRLSorL6DSdLgzRXLObY2uvcZY2A4HHPYVmPQdSDgVGU33VbgB12AmY7lKxK
 uGy4Axny7H1i0ytJLGPNUs1yHBUJeNlpy+9D26T3VDLPFM9/uyNQgkRjZ56JOdWuJsCB
 0NYIK0SLGxShbXLtxVLRbCeCUI7mEUBhQHjpTRIB2JVaG2fZSVG2fviPN34iILOIFOPi
 JDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=b8yWPewOpxEQv7YrShVluvsDfJILeyLSFc02MK8M4Jg=;
 b=nz+DpIfoeYxpKjdgl/Fo2/WvkeFI1YqR5bo00tFLJ6chtCfe/qpUakc/nDRnztuuaC
 VzdSUQq9UISjS4knn52n5R97vx7Edq1dZbGHPN6IVq8Y+GZ1wG1iEnarB7K/r4WYhQqw
 q0kjY4/4dVTm502p4IY/9xnFy97vpEYQkfEYZJl3o57bv5qxfFBFN9J6OQo6SWNvko7v
 4UZRoQl2sHJTv8xG4lf8jh0OcPTznzo0vdTz0NE6umUSkcx6SO8CXkmoQUeKzscALMLH
 bzSou7vy2kaFkH4I8GTCV0S5tziVj0ReOgf0PML53NpGlvU2mrNGXJdbDAefnKIoxL2T
 6P+A==
X-Gm-Message-State: AOAM5329TRd2YFxF5ismX0e4V2aN21Qwi48zb42gtlfTmThExjIY3S36
 6UVT0yQ9XP440szDJzmm6PG6AYBNY+ybpybHuRCYZQ==
X-Google-Smtp-Source: ABdhPJzkv07umAxyH1yzoI9pdizT6IMTPQXJOtx/ojWMS2eL8ogaXJ4KJCr2SDpEzW1Kb2Mrr8zYqtsaHVWwT/ZBeiE=
X-Received: by 2002:aca:2102:: with SMTP id 2mr9817151oiz.67.1627897849884;
 Mon, 02 Aug 2021 02:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-10-qperret@google.com>
In-Reply-To: <20210729132818.4091769-10-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 11:50:13 +0200
Message-ID: <CA+EHjTzYP3W4w3-EufkxWrFtGuCs6=SuO9XegAGAAp46EDF1VQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/21] KVM: arm64: Tolerate re-creating hyp mappings to
 set software bits
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

On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
>
> The current hypervisor stage-1 mapping code doesn't allow changing an
> existing valid mapping. Relax this condition by allowing changes that
> only target software bits, as that will soon be needed to annotate shared
> pages.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 1ee1168ac32d..2689fcb7901d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -362,6 +362,21 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>         return 0;
>  }
>
> +static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
> +{
> +       /*
> +        * Tolerate KVM recreating the exact same mapping, or changing software
> +        * bits if the existing mapping was valid.
> +        */
> +       if (old == new)
> +               return false;

The added comment clarifies the rationale here. Thanks.

Reviewed-by: Fuad Tabba <tabba@google.com>

/fuad



/fuad

> +       if (!kvm_pte_valid(old))
> +               return true;
> +
> +       return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW);
> +}
> +
>  static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                                     kvm_pte_t *ptep, struct hyp_map_data *data)
>  {
> @@ -371,9 +386,8 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         if (!kvm_block_mapping_supported(addr, end, phys, level))
>                 return false;
>
> -       /* Tolerate KVM recreating the exact same mapping */
>         new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> -       if (old != new && !WARN_ON(kvm_pte_valid(old)))
> +       if (hyp_pte_needs_update(old, new))
>                 smp_store_release(ptep, new);
>
>         data->phys += granule;
> --
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
