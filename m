Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AD0C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:59:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC9A4C938;
	Thu, 21 Jul 2022 05:59:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 47v6nH-de7HA; Thu, 21 Jul 2022 05:59:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C1D4C948;
	Thu, 21 Jul 2022 05:59:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFCA44C938
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEtT2Cf1WWkL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:59:17 -0400 (EDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A11934C92B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:17 -0400 (EDT)
Received: by mail-ej1-f43.google.com with SMTP id j22so2285984ejs.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Lj/0wM6NAt2u4+QegECU3k06tWmQYzBPAjiO9RdsPZg=;
 b=TWW8k4hNmMq9Daa63lNZ1ib4dK8on5MllaStr0wGK4hJZvkqqOaXSM2ogqz6vmexvT
 s1EFTwlXjIYmge/HQBuFO/YI4JOHjW3jTR7Gi7XBL+sGUCe4hkywaCi6yHxj6NwE3trP
 q7F9lxawv6hAriazOGeT3RgXZhSRqpd+JxiCUn3uA0FzHF00YC19vLx9T5YJCDuQcx0y
 vnkexEUgnkxjmB2lgv+fgrbbd+zU99FxRC40IOhRageMos4P34CJvhkDwiAqY4W5Qkh4
 BwimYmXY7nJDTNPzJjvkW2atxkxPiwcaXPug33Eyu2aU6u/x+//9WQ2aRh9H+/l4DRjs
 vWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Lj/0wM6NAt2u4+QegECU3k06tWmQYzBPAjiO9RdsPZg=;
 b=j2F3UkaRGQExuEYUxC5H0LQ8TSQyq8/XbA/IH7phOMOyydUsMxRU2HqAhILES7E6r5
 pzpYz4Si+JU8E3qJwDTWGaKDAKuoPJQxLW+gDU5UVgrOdRw8lEnuMNqcg/CGQaj6rTqg
 WKc4biSCZMtibk0Mw5MNKdocXNPRaSWLRed7HefIdgP+yxfqxLhR+WC3lLLnUfl6VAut
 mFO4jFjnt7eOokzLaA4SsLe0klLn9w1gPbJheUt+cuV91v23i2+i+lmsuZr05slS/2X0
 VIQTgL11lSitIZ//2pn8eRzMOUtnCaIobVLp7jW8NwMVmyvgO2yfHI2DZmSVIj9xpcZW
 bdMw==
X-Gm-Message-State: AJIora8o83H9u2HBkGKIhjb2qAfUKXvkFyGb7Ko6gxvz2ivE7cgvt+uh
 wA+lJW3hmAApEtvd3gVop1KRp9WBhmiaiOGx15gRbA==
X-Google-Smtp-Source: AGRyM1vFVHjD2TFnvN66RJojUMjD/iIsLidEphqOnhp9/G1jJM7kym/Lso/S89nbkov9+VZ0as59TPn0TDwUL1SEHts=
X-Received: by 2002:a17:907:6297:b0:72f:9aad:fcb with SMTP id
 nd23-20020a170907629700b0072f9aad0fcbmr1588686ejc.161.1658397556502; Thu, 21
 Jul 2022 02:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-15-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-15-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:58:40 +0100
Message-ID: <CA+EHjTzyK+bhtbC3xU5zCnsTDHpAKFqP3sp3LYFXjkHfPn8o-Q@mail.gmail.com>
Subject: Re: [PATCH v5 14/17] KVM: arm64: Implement protected nVHE hyp stack
 unwinder
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
> Implements the common framework necessary for unwind() to work in
> the protected nVHE context:
>    - on_accessible_stack()
>    - on_overflow_stack()
>    - unwind_next()
>
> Protected nVHE unwind() is used to unwind and save the hyp stack
> addresses to the shared stacktrace buffer. The host reads the
> entries in this buffer, symbolizes and dumps the stacktrace (later
> patch in the series).
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  arch/arm64/include/asm/stacktrace/common.h |  2 ++
>  arch/arm64/include/asm/stacktrace/nvhe.h   | 34 ++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
> index be7920ba70b0..73fd9e143c4a 100644
> --- a/arch/arm64/include/asm/stacktrace/common.h
> +++ b/arch/arm64/include/asm/stacktrace/common.h
> @@ -34,6 +34,7 @@ enum stack_type {
>         STACK_TYPE_OVERFLOW,
>         STACK_TYPE_SDEI_NORMAL,
>         STACK_TYPE_SDEI_CRITICAL,
> +       STACK_TYPE_HYP,
>         __NR_STACK_TYPES
>  };
>
> @@ -186,6 +187,7 @@ static inline int unwind_next_common(struct unwind_state *state,
>          *
>          * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
>          * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
> +        * HYP -> OVERFLOW
>          *
>          * ... but the nesting itself is strict. Once we transition from one
>          * stack to another, it's never valid to unwind back to that first
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> index 8f02803a005f..c3688e717136 100644
> --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -39,10 +39,19 @@ static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
>         state->pc = pc;
>  }
>
> +static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
> +                               struct stack_info *info);
> +
>  static inline bool on_accessible_stack(const struct task_struct *tsk,
>                                        unsigned long sp, unsigned long size,
>                                        struct stack_info *info)
>  {
> +       if (on_accessible_stack_common(tsk, sp, size, info))
> +               return true;
> +
> +       if (on_hyp_stack(sp, size, info))
> +               return true;
> +
>         return false;
>  }
>
> @@ -60,12 +69,27 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>  static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
>                                      struct stack_info *info)
>  {
> -       return false;
> +       unsigned long low = (unsigned long)this_cpu_ptr(overflow_stack);
> +       unsigned long high = low + OVERFLOW_STACK_SIZE;
> +
> +       return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
> +}
> +
> +static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
> +                               struct stack_info *info)
> +{
> +       struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
> +       unsigned long high = params->stack_hyp_va;
> +       unsigned long low = high - PAGE_SIZE;
> +
> +       return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
>  }
>
>  static inline int notrace unwind_next(struct unwind_state *state)
>  {
> -       return 0;
> +       struct stack_info info;
> +
> +       return unwind_next_common(state, &info, NULL);
>  }
>  NOKPROBE_SYMBOL(unwind_next);
>  #else  /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> @@ -75,6 +99,12 @@ static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
>         return false;
>  }
>
> +static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
> +                               struct stack_info *info)
> +{
> +       return false;
> +}
> +
>  static inline int notrace unwind_next(struct unwind_state *state)
>  {
>         return 0;
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
