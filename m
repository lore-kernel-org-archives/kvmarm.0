Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AA4C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 13:58:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 860CE61165
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 13:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 860CE61165
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04C9E4A023;
	Tue, 20 Jul 2021 09:58:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SLLzMf1QOuLV; Tue, 20 Jul 2021 09:58:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15DBD4A19F;
	Tue, 20 Jul 2021 09:58:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 700634A126
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 09:58:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n97cyG9t65l5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 09:57:56 -0400 (EDT)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com
 [209.85.167.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F2584A023
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 09:57:56 -0400 (EDT)
Received: by mail-oi1-f180.google.com with SMTP id s23so8868146oiw.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=z54CTZ7m1ybOAaQslMS3Yzi7pwB2B73X0p7oLSu85mA=;
 b=RoH7jW88EdEt7Zcg9ZAb1d4Bp5ahB/RWZA0yBQYnLk8mVoTqhNfvVkxPYb5ejv86Gy
 4T4vuSwRZi9fabkvECsfWgswUgwFGZBdRmDUmF3jjLIMbrFlpX60Ra3slAseSlqOc8gT
 wQTG+OAT0P0Ue9KVpTNUoikCqkex3E0sr3nWPog/XK/t+6g/E3GIPtZQUiDecQ9u2Rms
 9+jRIZ4eiWxhM/1hhVvcz63NYSQovi+AQeGs9ilkvM7hYiWJ2o/Jr2Ft7S3tmviu/Tnn
 kluG2NVyuOHWY3GXx6uErJwdt1d0NLeSviJ/nrHi50LyNstUOzp3NaBq4ydzGjt0GHSe
 Fxyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=z54CTZ7m1ybOAaQslMS3Yzi7pwB2B73X0p7oLSu85mA=;
 b=MHJ00fdOmFT1nJgPFCl8hWecRwMERy2ZpwrRSIlw4R41/FkiR+75sXhgzE5em3Z0TI
 OOhL+DUGQ1sIBSJzqss0M+WAkEhmeR44dqj2k+VZjzcvOAQTJe2j7GkmVWkkkIyOxn9B
 wIYNUlRDlUBi5LjHaqMpiuHJyp7sMHXG/9FXPEFStcJBkMyUYd0SxISpWLI08yx03dbA
 NNhEOC759Is7vuXNx5L9fAAeYX3qqJUXPBrY7HKrzpMa6icJWdFzqr8/RyQ1lPjpAVUK
 IZePplCpiLSXD/H/SDsmLQhytZWsMBRWy1tDEG3t8zpsBtmY4dzdVPCEvEUmNAObzaU/
 d+cw==
X-Gm-Message-State: AOAM531yIBQi7UNcs3Caw2QIZQzCoSes+m+gDboln/bPEBD8gWISaaWJ
 3iAGm3jWsNgyCPXTJkQD2IFv7Sk51WIqEUlNVC1r5g==
X-Google-Smtp-Source: ABdhPJxkbl1jK/kwdgT8I4sKUxzm7eCYwuuEYGAnfVuHj/oT/zlMVBdDpQ6GDUnClK1MlQCp3VfruvMZU3I7IwoRwHY=
X-Received: by 2002:aca:cf8e:: with SMTP id f136mr25218634oig.67.1626789475645; 
 Tue, 20 Jul 2021 06:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-2-qperret@google.com>
In-Reply-To: <20210719104735.3681732-2-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 20 Jul 2021 14:57:19 +0100
Message-ID: <CA+EHjTwL7M=Proo62mE5UFsGiYSGcNF2Pa7s9YOe5fiVVdRx-A@mail.gmail.com>
Subject: Re: [PATCH 01/14] KVM: arm64: Provide the host_stage2_try() helper
 macro
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

On Mon, Jul 19, 2021 at 11:47 AM Quentin Perret <qperret@google.com> wrote:
>
> We currently unmap all MMIO mappings from the host stage-2 to recycle
> the pages whenever we run out. In order to make this pattern easy to
> re-use from other places, factor the logic out into a dedicated macro.
> While at it, apply the macro for the kvm_pgtable_stage2_set_owner()
> calls. They're currently only called early on and are guaranteed to
> succeed, but making them robust to the -ENOMEM case doesn't hurt and
> will avoid painful debugging sessions later on.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 38 ++++++++++++++-------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d938ce95d3bd..56f2117c877b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -208,6 +208,23 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
>                                       prot, &host_s2_pool);
>  }
>
> +/*
> + * The pool has been provided with enough pages to cover all of memory with
> + * page granularity, but it is difficult to know how much of the MMIO range
> + * we will need to cover upfront, so we may need to 'recycle' the pages if we
> + * run out.
> + */
> +#define host_stage2_try(fn, ...)                                       \
> +       ({                                                              \
> +               int __ret = fn(__VA_ARGS__);                            \
> +               if (__ret == -ENOMEM) {                                 \
> +                       __ret = host_stage2_unmap_dev_all();            \
> +                       if (!__ret)                                     \
> +                               __ret = fn(__VA_ARGS__);                \
> +               }                                                       \
> +               __ret;                                                  \
> +        })

I think it might be good to document that this macro expects the
host_kvm.lock to be held.

Thanks,
/fuad

>  static int host_stage2_idmap(u64 addr)
>  {
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> @@ -223,22 +240,7 @@ static int host_stage2_idmap(u64 addr)
>         if (ret)
>                 goto unlock;
>
> -       ret = __host_stage2_idmap(range.start, range.end, prot);
> -       if (ret != -ENOMEM)
> -               goto unlock;
> -
> -       /*
> -        * The pool has been provided with enough pages to cover all of memory
> -        * with page granularity, but it is difficult to know how much of the
> -        * MMIO range we will need to cover upfront, so we may need to 'recycle'
> -        * the pages if we run out.
> -        */
> -       ret = host_stage2_unmap_dev_all();
> -       if (ret)
> -               goto unlock;
> -
> -       ret = __host_stage2_idmap(range.start, range.end, prot);
> -
> +       ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
>  unlock:
>         hyp_spin_unlock(&host_kvm.lock);
>
> @@ -257,8 +259,8 @@ int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
>                 return -EINVAL;
>
>         hyp_spin_lock(&host_kvm.lock);
> -       ret = kvm_pgtable_stage2_set_owner(&host_kvm.pgt, start, end - start,
> -                                          &host_s2_pool, pkvm_hyp_id);
> +       ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
> +                             start, end - start, &host_s2_pool, pkvm_hyp_id);
>         hyp_spin_unlock(&host_kvm.lock);
>
>         return ret != -EAGAIN ? ret : 0;
> --
> 2.32.0.402.g57bb445576-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
