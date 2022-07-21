Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62240C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:59:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 092FF4C938;
	Thu, 21 Jul 2022 05:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ebX+-q0Y8tGp; Thu, 21 Jul 2022 05:59:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C54754C947;
	Thu, 21 Jul 2022 05:59:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECA784C942
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2NNQtXzR-dix for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:59:28 -0400 (EDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
 [209.85.218.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B004D4C92B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:28 -0400 (EDT)
Received: by mail-ej1-f46.google.com with SMTP id l23so2276216ejr.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1zPB+ZV4Xrrq+Kcn0bkCJJPjeU/vNo5EqrxJwRUCS1A=;
 b=rlYVsHDLITER6xoaQ69OnVwTUoomKByTN+gPGK9K2t0crSEBimtTWlWYFftRFscoHr
 emiG/AZK7JszLPfoeYpWgLLMG8Ty1+pX1XnbHdVznHb5XX87JKiX0a5+B24fyD/hUktK
 GVkvK2tkeMFap6N+Slrs2dOf2ouBqwEQ8m8mTO7IX63NNV9F7ZgOX19D7yrG49GroD91
 D8+oWOBLOrzJq0W/3/W2amNHKLT14yHoI56PQI9FOeo1rfg2OhNt368MKiCyjPYtCb0l
 9IRvbmyM9rSQNpI8UDNh/n07qsIT9EmRss+sKwvzNjf2znoig533h6wSpTHvJK1d1XiL
 A0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1zPB+ZV4Xrrq+Kcn0bkCJJPjeU/vNo5EqrxJwRUCS1A=;
 b=seLx4CZ/gmWSDrSDXsPWlBXFt5SfoDPMwhTzYekYvictswcZTYVTx40Kwtz3CfqNvR
 nHYtHIYMpsSe8Sp3NlTTZQKUlpglVZU6POcfw0iS1M8kOJPXglUPOYA0DVijdqjB9Ciy
 9AzCpFBHQqIdEPmnjIqNKphDmDMRmGaRBEr04iqnpvH4RjzY4FUFaukm0mNk4ffiPlvk
 CB/NItiNKUmWxDVq1Oj3xc+EJiCwmNI2jFNDptA+AVi2oJvoE8AkuWF0AXNqW9DWUDYs
 wBjihQLg8df4r0uNXsX9YxhextwVZUeXpAfLtib2wesE/p2dwt4FddGeyK3GfLTetXxu
 NPKQ==
X-Gm-Message-State: AJIora+NnGCDDtOxJvSRj2S7CuggQKuqjRU7Vep89A4gXHyWqi4W+vaB
 Z0xVQa4VUcEZVbXKCwIiRJY4JCtD9N+XElem2NSMBA==
X-Google-Smtp-Source: AGRyM1tC1QMisFjGwD5R0J3SfMsabxPDnO9sTLmyjaTXAlyMYIr2z+UyVExzMJqvTZbfS7ikgd404pZy5ZSTPNhV/rU=
X-Received: by 2002:a17:907:9706:b0:72b:4b0d:86a2 with SMTP id
 jg6-20020a170907970600b0072b4b0d86a2mr38027129ejc.242.1658397567669; Thu, 21
 Jul 2022 02:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-16-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-16-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:58:50 +0100
Message-ID: <CA+EHjTy4ozkDCs0FECRnJFfN-_G0ye4uJ3OVhMRvzUQux-QL=A@mail.gmail.com>
Subject: Re: [PATCH v5 15/17] KVM: arm64: Implement non-protected nVHE hyp
 stack unwinder
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
> Implements the common framework necessary for unwind() to work
> for non-protected nVHE mode:
>     - on_accessible_stack()
>     - on_overflow_stack()
>     - unwind_next()
>
> Non-protected nVHE unwind() is used to unwind and dump the hypervisor
> stacktrace by the host in EL1
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> Changes in v5:
>   - Use regular comments instead of doc comments, per Fuad
>
>  arch/arm64/include/asm/stacktrace/nvhe.h | 67 +++++++++++++++++++++++-
>  arch/arm64/kvm/arm.c                     |  2 +-
>  2 files changed, 66 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> index c3688e717136..7a6e761aa443 100644
> --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -120,15 +120,78 @@ NOKPROBE_SYMBOL(unwind_next);
>   * (by the host in EL1).
>   */
>
> +DECLARE_KVM_NVHE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], overflow_stack);
> +DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
> +DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> +
> +/*
> + * kvm_nvhe_stack_kern_va - Convert KVM nVHE HYP stack addresses to a kernel VAs
> + *
> + * The nVHE hypervisor stack is mapped in the flexible 'private' VA range, to
> + * allow for guard pages below the stack. Consequently, the fixed offset address
> + * translation macros won't work here.
> + *
> + * The kernel VA is calculated as an offset from the kernel VA of the hypervisor
> + * stack base.
> + *
> + * Returns true on success and updates @addr to its corresponding kernel VA;
> + * otherwise returns false.
> + */
> +static inline bool kvm_nvhe_stack_kern_va(unsigned long *addr,
> +                                         enum stack_type type)
> +{
> +       struct kvm_nvhe_stacktrace_info *stacktrace_info;
> +       unsigned long hyp_base, kern_base, hyp_offset;
> +
> +       stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
> +
> +       switch (type) {
> +       case STACK_TYPE_HYP:
> +               kern_base = (unsigned long)*this_cpu_ptr(&kvm_arm_hyp_stack_page);
> +               hyp_base = (unsigned long)stacktrace_info->stack_base;
> +               break;
> +       case STACK_TYPE_OVERFLOW:
> +               kern_base = (unsigned long)this_cpu_ptr_nvhe_sym(overflow_stack);
> +               hyp_base = (unsigned long)stacktrace_info->overflow_stack_base;
> +               break;
> +       default:
> +               return false;
> +       }
> +
> +       hyp_offset = *addr - hyp_base;
> +
> +       *addr = kern_base + hyp_offset;
> +
> +       return true;
> +}
> +
>  static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
>                                      struct stack_info *info)
>  {
> -       return false;
> +       struct kvm_nvhe_stacktrace_info *stacktrace_info
> +                               = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
> +       unsigned long low = (unsigned long)stacktrace_info->overflow_stack_base;
> +       unsigned long high = low + OVERFLOW_STACK_SIZE;
> +
> +       return on_stack(sp, size, low, high, STACK_TYPE_OVERFLOW, info);
> +}
> +
> +static inline bool on_hyp_stack(unsigned long sp, unsigned long size,
> +                               struct stack_info *info)
> +{
> +       struct kvm_nvhe_stacktrace_info *stacktrace_info
> +                               = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
> +       unsigned long low = (unsigned long)stacktrace_info->stack_base;
> +       unsigned long high = low + PAGE_SIZE;
> +
> +       return on_stack(sp, size, low, high, STACK_TYPE_HYP, info);
>  }
>
>  static inline int notrace unwind_next(struct unwind_state *state)
>  {
> -       return 0;
> +       struct stack_info info;
> +
> +       return unwind_next_common(state, &info, kvm_nvhe_stack_kern_va);
>  }
>  NOKPROBE_SYMBOL(unwind_next);
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a0188144a122..6a64293108c5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -49,7 +49,7 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
>
>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>
> -static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> +DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
>  unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
>  DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
