Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECA7C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:58:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 289CD4C93D;
	Thu, 21 Jul 2022 05:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rw+ovCUpe6EJ; Thu, 21 Jul 2022 05:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2215B4C93E;
	Thu, 21 Jul 2022 05:58:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4ED4C930
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NmEE3qVQw2Bt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:58:51 -0400 (EDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com
 [209.85.208.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A8C94C93E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:51 -0400 (EDT)
Received: by mail-ed1-f52.google.com with SMTP id e15so1512222edj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RmAIjKGWk0hNqXTnjY9ohH0Hfcr8vg917Lo9awM+QzI=;
 b=rHaT/SOwOYka0T4gC642ubUIOA0nOV6Jrx+k8lfSVuNlZCg6k9HusWWKOzy0JL+JKA
 jG9X9xcgQRmAxFdk+rHJ0EpPcUdzKyeBNPP0S+LaVIIqDuyZgPVe0CAMZDk/znoO8kWZ
 oChbddtj0Yu/vqRZ9BQlFUNEjQ/2x6N4VHSc/W1gxQZsZcTbZga34SHoqbzEFEuqMXte
 4d+4Ped7pzDLPByLcPp4OQtrtwenH22oVXC+0Z9bxo4xjnalQHOXkXxTA8Fo0UR0mhxk
 Mi/vPWa75OjwrFQMtPjzMxSkzM2QJn5VgQlf9wykEtwE7Ga8b48SPxhJ/tHGH0k2FaBS
 NlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RmAIjKGWk0hNqXTnjY9ohH0Hfcr8vg917Lo9awM+QzI=;
 b=AmAch9Cy2+SGOFIOrIm0iVqGj6kk0hRdjOHiABWnLlvKEi9GULswCyMWdfpXu2NE9v
 +d7gWqw0YHqs4K8UESUmlciTA2F8dA6+EwG4UuQy2aosazuMP5kP1WXDGKid1Le1rxXx
 yMjmYAuWuDPBazRT5dzRpKs96Hx1l25CiEmx3NXzmF+fi69Y0mABHFeEYXCHI3qRPyDf
 E0acB0RZaJ3pZ2uEQwhjcLcEU4oVD44TLaB6X0RudI/ZrlNFLJkC/AlsjdXv7HaDqK/B
 PrYQqR5iRjGwf3DeqV09+Jw2aqnmDNFoozdPqWvXxTuPqHYedmZWbiumhpSqN4E3zw2a
 A9Tw==
X-Gm-Message-State: AJIora9z9YLgl8YPtJcrYzPArxjkxiV8hb197TfhRbnTp62p6Zbynl78
 S56fBU3lslIydQJcv9W+eOJflj7Xe3DkkgSSTO5TQA==
X-Google-Smtp-Source: AGRyM1uNyQGAgyUyWlicYyKFzueKx1CnxNhfO10Jlea4E3AIWxJJXx09bUiJbLYyg+XFDZNmbcrgYnmqe6s5k3VegI8=
X-Received: by 2002:a05:6402:753:b0:43b:a416:3963 with SMTP id
 p19-20020a056402075300b0043ba4163963mr13570370edy.267.1658397530188; Thu, 21
 Jul 2022 02:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-12-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-12-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:58:13 +0100
Message-ID: <CA+EHjTzb9cEAP=p39tbNynymnTXSNVuta74sQp05V1VsFVDaJg@mail.gmail.com>
Subject: Re: [PATCH v5 11/17] KVM: arm64: Stub implementation of non-protected
 nVHE HYP stack unwinder
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, madvenka@linux.microsoft.com, kernel-team@android.com,
 elver@google.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 andreyknvl@gmail.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Hi Kalesh,

On Thu, Jul 21, 2022 at 6:58 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Add stub implementations of non-protected nVHE stack unwinder, for
> building. These are implemented later in this series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Changes in v5:
>   - Mark unwind_next() as inline, per Marc
>   - Comment !__KVM_NVHE_HYPERVISOR__ unwinder path, per Marc
>
>  arch/arm64/include/asm/stacktrace/nvhe.h | 26 ++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> index 80d71932afff..3078501f8e22 100644
> --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -8,6 +8,12 @@
>   *      the HYP memory. The stack is unwinded in EL2 and dumped to a shared
>   *      buffer where the host can read and print the stacktrace.
>   *
> + *   2) Non-protected nVHE mode - the host can directly access the
> + *      HYP stack pages and unwind the HYP stack in EL1. This saves having
> + *      to allocate shared buffers for the host to read the unwinded
> + *      stacktrace.
> + *
> + *
>   * Copyright (C) 2022 Google LLC
>   */
>  #ifndef __ASM_STACKTRACE_NVHE_H
> @@ -55,5 +61,25 @@ static inline int notrace unwind_next(struct unwind_state *state)
>  NOKPROBE_SYMBOL(unwind_next);
>  #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
>
> +#else  /* !__KVM_NVHE_HYPERVISOR__ */
> +/*
> + * Conventional (non-protected) nVHE HYP stack unwinder
> + *
> + * In non-protected mode, the unwinding is done from kernel proper context
> + * (by the host in EL1).
> + */
> +
> +static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
> +                                    struct stack_info *info)
> +{
> +       return false;
> +}
> +
> +static inline int notrace unwind_next(struct unwind_state *state)
> +{
> +       return 0;
> +}
> +NOKPROBE_SYMBOL(unwind_next);
> +
>  #endif /* __KVM_NVHE_HYPERVISOR__ */
>  #endif /* __ASM_STACKTRACE_NVHE_H */
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
