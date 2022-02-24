Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011F2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 12:27:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB534BEF4;
	Thu, 24 Feb 2022 07:27:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YwzywaKOIw82; Thu, 24 Feb 2022 07:27:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 445C84C0CD;
	Thu, 24 Feb 2022 07:27:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2964B4BEF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 07:27:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S26Bg-CWhnK6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 07:27:10 -0500 (EST)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9116D4C0C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 07:27:10 -0500 (EST)
Received: by mail-oi1-f176.google.com with SMTP id y7so2270098oih.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 04:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=nwPQWibcxWFMgXyN9ojVzSP3LzP6lHj2lJ3iUxgMjZo=;
 b=UBXR2MWYL/s+kIoqgRGAYAptEH4Pc/nZimkfWIwawk2UW5OrLBRBIriDI+z5GgP8K2
 oN5Rh18Lml+7Bn+qfKh11yqwH8Xr6ium0CITxUAYF/VtkBUn9F9Naa3DN24atWoDEirn
 Iw6npN0oSb16EtzPL1tg8TP9yNcT4GoI3MkBnWQIXGsXW/fTT92AKS/5+ewrtpAjJyKv
 YtouZoIqplRqkGT7FlRhU5i+rEslOCdT5HNqp3Np7DGOoy+X0sKaBN7fUyyYNOSwLw12
 Jfcr/RVp8xnyU7eAq6n92RFOWtamJgnHZTa9bsP/dNcGunwXcAF2ZN/cUb44hwFZREoz
 hbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=nwPQWibcxWFMgXyN9ojVzSP3LzP6lHj2lJ3iUxgMjZo=;
 b=5ps5p/hyLVTRYlqnwcZJVZJf1JaocKahQcOYbOAXsjR+aQ2U3Zv6BSWmn8HInot0Ko
 JPw/8VeOdkWeHRfFL8juAap4SbEzN8dBsYeMCsdWojTslit+9YNzcper35aaeq4SL4RB
 5kr6j7mHBNvWTWI4Kt5t/squdjVbwPXK/sEiczVMDrScpOs92nVNnvfEIz1iHlpjtXsp
 7I+gE6Ulh1tagJa3WKKmIRbMUILv6WxxSLT3DsOI5rG0RaVqx/haUvLtpCygT0KFHR1u
 Esu/MjjPjMzLNvzi60Rao7vphY6wy82SquXsIcnimv81DpD5IU/4lzA/QZn3t+g8V8+a
 QAsg==
X-Gm-Message-State: AOAM531UD41eCsF3slaosOHzZyrH8rFjau3Pzajc92ZaaKV1jeW/5dM2
 utBRC2PAsqYvrB347JETD1sXU/od4FMuQwCIrb2SEw==
X-Google-Smtp-Source: ABdhPJyrrakVNa5pcRaScIuNmvHmY+CpOg3ZbilxQyabTPfLuKc9DpV3Splz80s2X3grapbHSv8hLTMNiuCNYtZoQl4=
X-Received: by 2002:a05:6808:ec1:b0:2d6:52f:6405 with SMTP id
 q1-20020a0568080ec100b002d6052f6405mr5741674oiv.124.1645705629835; Thu, 24
 Feb 2022 04:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
 <20220224051439.640768-7-kaleshsingh@google.com>
In-Reply-To: <20220224051439.640768-7-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 24 Feb 2022 12:26:33 +0000
Message-ID: <CA+EHjTwhpjDDnKRU3QrJysgMhYH7eTi2_LrWpxCArLoP-1-BrQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] KVM: arm64: Add hypervisor overflow stack
To: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>
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

On Thu, Feb 24, 2022 at 5:21 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Allocate and switch to 16-byte aligned secondary stack on overflow. This
> provides us stack space to better handle overflows; and is used in
> a subsequent patch to dump the hypervisor stacktrace. The overflow stack
> is only allocated if CONFIG_NVHE_EL2_DEBUG is enabled, as hypervisor
> stacktraces is a debug feature dependent on CONFIG_NVHE_EL2_DEBUG.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S   | 5 +++++
>  arch/arm64/kvm/hyp/nvhe/switch.c | 5 +++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 749961bfa5ba..367a01e8abed 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -179,6 +179,10 @@ SYM_FUNC_END(__host_hvc)
>         b       hyp_panic
>
>  .L__hyp_sp_overflow\@:
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +       /* Switch to the overflow stack */
> +       adr_this_cpu sp, hyp_overflow_stack + PAGE_SIZE, x0
> +#else
>         /*
>          * Reset SP to the top of the stack, to allow handling the hyp_panic.
>          * This corrupts the stack but is ok, since we won't be attempting
> @@ -186,6 +190,7 @@ SYM_FUNC_END(__host_hvc)
>          */

Nit: Maybe you should update this comment as well, since whether it
corrupts the stack or not depends on what happens above with
CONFIG_NVHE_EL2_DEBUG.

Thanks,
/fuad

>         ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
>         mov     sp, x0
> +#endif
>
>         bl      hyp_panic_bad_stack
>         ASM_BUG()
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 703a5d3f611b..efc20273a352 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -34,6 +34,11 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
>  DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
> +       __aligned(16);
> +#endif
> +
>  static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
>         u64 val;
> --
> 2.35.1.473.g83b2b277ed-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
