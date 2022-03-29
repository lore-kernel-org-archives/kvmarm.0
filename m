Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E66C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 08:51:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82284A100;
	Tue, 29 Mar 2022 04:51:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id temfmVylTef7; Tue, 29 Mar 2022 04:51:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 611C049EF2;
	Tue, 29 Mar 2022 04:51:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49EEF49EEB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1aq6G5xj6Ip9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 04:51:42 -0400 (EDT)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com
 [209.85.160.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 324B249EF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:42 -0400 (EDT)
Received: by mail-oa1-f41.google.com with SMTP id
 586e51a60fabf-de48295467so18023964fac.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 01:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VJe5O/dIYvnfHgc69g0ehLPKljcP5RKzYK2S6ZDVOnE=;
 b=Uba6bE+82Py38fI3DPMkzE6lkUD0b/uApAHybu4BE6FTGoLWsQpNaC2VhN6RdAAIbL
 F8/DEKspBDMmWd8Jw+7HQgx+ynr9i6mN1aiqNpxajiOoBV2yDzvroGFL3siW+MkNqrnX
 jcxJTBRWxa7Wf9mhwUfWT/6utLuJFzzHV3iIwtdA4NK5NRAaWPwyqGMe82wv8awpU44N
 q+3oKwp/reccSUIQBFI9jC6ZG+CRkojREJH+JZXJe9VgEkrc4rUugOPsB9VVEDoJ3mXk
 T+aNBI33U7vN9UoMvZxpDF6ROVXQsH+yI522YkW0qsNdVZsvcmC+NeWkBK1EBMlY1B6n
 vRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VJe5O/dIYvnfHgc69g0ehLPKljcP5RKzYK2S6ZDVOnE=;
 b=AtpqOJmsUp3CpikrhCWBasYP8eCkzroF2sgUj8xyLsM6Cz506G9cybI0TSJHMYnGAG
 1lJmsRLeFgkZfgyigc4ZDeVkzQ1gOcrD34/78mEX/K9CvfeGxEmKXeyUrV5XckMWdbl4
 D/M7oycejmdRAAIoHP2i7OC9/bNYSKrtrLxF+3sXkvjXBccndkcsNVsqMzWjBBgAEQS+
 py8CrQzQoy5/tQLfsLiI2td16ZMN9RgQgsudFReXnd/zS2102poqvwLuXuwScuB788Ra
 PwW1PaGuqHYFGAGoO1Hl972V9xjWdUI07waY/hZ98t7VemwNPXfFNjswQlkW7TWGF/hR
 PZYQ==
X-Gm-Message-State: AOAM532kZSarC+cBFQGJA8fsYx7pOGp0zP4s6PQH4wrFaMRw6QK0caap
 Kfc4zfGs/ORcVVEusfnClivr+UKphFwK43iaUyMuDg==
X-Google-Smtp-Source: ABdhPJzQnNB1enU6Vkw99LKFBHjurfLKTPpi/C2YL5+IsoNf/fgBuvf7UOzi/nLVp7bF67JAE1XzNk8Susa0c79YPd0=
X-Received: by 2002:a05:6870:700f:b0:dd:9f77:9a97 with SMTP id
 u15-20020a056870700f00b000dd9f779a97mr1639234oae.146.1648543901566; Tue, 29
 Mar 2022 01:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-6-kaleshsingh@google.com>
In-Reply-To: <20220314200148.2695206-6-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 29 Mar 2022 09:51:05 +0100
Message-ID: <CA+EHjTxkug-92zR5sr7icry8KWuksAt6PBt95QTjtkYonF7-Ng@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] KVM: arm64: Detect and handle hypervisor stack
 overflows
To: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Andrew Walbran <qwandor@google.com>,
 will@kernel.org, Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, surenb@google.com,
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

Hi Kalesh,


On Mon, Mar 14, 2022 at 8:05 PM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> The hypervisor stacks (for both nVHE Hyp mode and nVHE protected mode)
> are aligned such  that any valid stack address has PAGE_SHIFT bit as 1.
> This allows us to conveniently check for overflow in the exception entry
> without corrupting any GPRs. We won't recover from a stack overflow so
> panic the hypervisor.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad


> ---
>
> Changes in v5:
>   - Valid stack addresses now have PAGE_SHIFT bit as 1 instead of 0
>
> Changes in v3:
>   - Remove test_sp_overflow macro, per Mark
>   - Add asmlinkage attribute for hyp_panic, hyp_panic_bad_stack, per Ard
>
>
>  arch/arm64/kvm/hyp/nvhe/host.S   | 24 ++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c |  7 ++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index 3d613e721a75..be6d844279b1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -153,6 +153,18 @@ SYM_FUNC_END(__host_hvc)
>
>  .macro invalid_host_el2_vect
>         .align 7
> +
> +       /*
> +        * Test whether the SP has overflowed, without corrupting a GPR.
> +        * nVHE hypervisor stacks are aligned so that the PAGE_SHIFT bit
> +        * of SP should always be 1.
> +        */
> +       add     sp, sp, x0                      // sp' = sp + x0
> +       sub     x0, sp, x0                      // x0' = sp' - x0 = (sp + x0) - x0 = sp
> +       tbz     x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
> +       sub     x0, sp, x0                      // x0'' = sp' - x0' = (sp + x0) - sp = x0
> +       sub     sp, sp, x0                      // sp'' = sp' - x0 = (sp + x0) - x0 = sp
> +
>         /* If a guest is loaded, panic out of it. */
>         stp     x0, x1, [sp, #-16]!
>         get_loaded_vcpu x0, x1
> @@ -165,6 +177,18 @@ SYM_FUNC_END(__host_hvc)
>          * been partially clobbered by __host_enter.
>          */
>         b       hyp_panic
> +
> +.L__hyp_sp_overflow\@:
> +       /*
> +        * Reset SP to the top of the stack, to allow handling the hyp_panic.
> +        * This corrupts the stack but is ok, since we won't be attempting
> +        * any unwinding here.
> +        */
> +       ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
> +       mov     sp, x0
> +
> +       bl      hyp_panic_bad_stack
> +       ASM_BUG()
>  .endm
>
>  .macro invalid_host_el1_vect
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 6410d21d8695..703a5d3f611b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -347,7 +347,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>         return exit_code;
>  }
>
> -void __noreturn hyp_panic(void)
> +asmlinkage void __noreturn hyp_panic(void)
>  {
>         u64 spsr = read_sysreg_el2(SYS_SPSR);
>         u64 elr = read_sysreg_el2(SYS_ELR);
> @@ -369,6 +369,11 @@ void __noreturn hyp_panic(void)
>         unreachable();
>  }
>
> +asmlinkage void __noreturn hyp_panic_bad_stack(void)
> +{
> +       hyp_panic();
> +}
> +
>  asmlinkage void kvm_unexpected_el2_exception(void)
>  {
>         return __kvm_unexpected_el2_exception();
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
