Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A3EC432BE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:37:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B2E9610CE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 09:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5B2E9610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4BFD4A483;
	Mon,  2 Aug 2021 05:37:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z5VhOJ+-g4fs; Mon,  2 Aug 2021 05:37:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 692244A523;
	Mon,  2 Aug 2021 05:37:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E37C14A19E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:37:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4sBAdYjhMjbU for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 05:37:19 -0400 (EDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCE6B40856
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 05:37:19 -0400 (EDT)
Received: by mail-oi1-f173.google.com with SMTP id x15so23394110oic.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 02:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FYSKq5I9PT1AOR7++VBDqRUavrD1FqW1zkcq2amkopA=;
 b=BOHy8c6RcwBv7BrZpawuZkaSiILuONkxy7E9exBa18jEkvhpM2mDhoaSYmfLpYlO0y
 3Juy2FnrfJYtsuyXakMsrb5sWy0al+mhdrKckXjGcfenEr/gchY+LziFl5RIqHIzxsn5
 cGEvLMc98cLzLD0XDWyKgBP1BaJX3EnS/FO2xiGeRcuF3Vx1isdKKvzJm5lKbgEHyH0n
 Gng7h7uqoTeoKL1JmenGMRV97O28QlScIg3CUHw4PqXGnqPCp5uJoST3dVmhPN8DLwz0
 skLl/gWCpFZ9aqLuPvoHQftThg7Qag861NVqscxhtJYdZu+C41nY56By2vOYAWeO/D7B
 3ayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FYSKq5I9PT1AOR7++VBDqRUavrD1FqW1zkcq2amkopA=;
 b=REZHYlcPknCaHjZbETNijotigS9r7+mgSZ3Kggx5pfWIzEXDWZQ1dvYTqY38wcT5eh
 bGVRN62CGYFWross5ycLV3Gshmrx4/cs4X1bp+tyOKEdCp47tgUF60iwakaUkQbMgyre
 /69wQUVDlGVjkH9Lmi6U3+S8k6p3iKBl9+yojdtW9WnkwaZCOwdUEQoj1Pm1ljerCHQD
 z5V8xfjy7joIMaYf/nEUZnnAIVMyLFoXXZPcfw8zUcaL+S7Dpi0RurXkFA0k46UqOON6
 syCS75++KLUvmk/8peCaVk1keCV+lyqN7dSXtamSQy2P8qU73tjbCIIQJPuBCVOMl5Cj
 kiQg==
X-Gm-Message-State: AOAM533A4/2ITMuLWkgyWTVytGACfkeM23+FQxPSvillUsYjW3OkZIoG
 eYh8d6rEiTYPls9Nbz/gIpQ4qYvYEJRnEB+11DIWmg==
X-Google-Smtp-Source: ABdhPJx7duRBSKr9RK9jF8w3zgG9BJbts+dNEDkZYXg0XR4D+ZuJAK0QB2VUoRu6L16cgXQVWEdqlDJrLx8Fq0oVgEM=
X-Received: by 2002:a05:6808:5a:: with SMTP id
 v26mr9759822oic.90.1627897039116; 
 Mon, 02 Aug 2021 02:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-4-qperret@google.com>
In-Reply-To: <20210729132818.4091769-4-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Aug 2021 11:36:42 +0200
Message-ID: <CA+EHjTzrqbyHQyo7X-=MeJXQ5bVcfUz0uiUKVAv_U+aqVNuhYw@mail.gmail.com>
Subject: Re: [PATCH v3 03/21] KVM: arm64: Provide the host_stage2_try() helper
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

Hi Quentin.

On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
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
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 40 +++++++++++++++------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d938ce95d3bd..74280a753efb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -208,6 +208,25 @@ static inline int __host_stage2_idmap(u64 start, u64 end,
>                                       prot, &host_s2_pool);
>  }
>
> +/*
> + * The pool has been provided with enough pages to cover all of memory with
> + * page granularity, but it is difficult to know how much of the MMIO range
> + * we will need to cover upfront, so we may need to 'recycle' the pages if we
> + * run out.
> + */

The comment you added in V2 about host_kvm.lock got dropped in favor
asserting that the lock is held.

Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad




> +#define host_stage2_try(fn, ...)                                       \
> +       ({                                                              \
> +               int __ret;                                              \
> +               hyp_assert_lock_held(&host_kvm.lock);                   \
> +               __ret = fn(__VA_ARGS__);                                \
> +               if (__ret == -ENOMEM) {                                 \
> +                       __ret = host_stage2_unmap_dev_all();            \
> +                       if (!__ret)                                     \
> +                               __ret = fn(__VA_ARGS__);                \
> +               }                                                       \
> +               __ret;                                                  \
> +        })
> +
>  static int host_stage2_idmap(u64 addr)
>  {
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> @@ -223,22 +242,7 @@ static int host_stage2_idmap(u64 addr)
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
> @@ -257,8 +261,8 @@ int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
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
> 2.32.0.432.gabb21c7263-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
