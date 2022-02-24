Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C90C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 14:59:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A8F4BA25;
	Fri, 25 Feb 2022 09:59:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yg2nYP5jyf5s; Fri, 25 Feb 2022 09:59:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E1A74BA4D;
	Fri, 25 Feb 2022 09:59:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7464BC07
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:56:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e-zOCNMsMcEG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:56:42 -0500 (EST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7946C4BBE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:56:42 -0500 (EST)
Received: by mail-wm1-f52.google.com with SMTP id p4so321472wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0eQeP3GzjSxs3bFEsWrl0jof0V3c/zOR378LhVu6aVM=;
 b=eb+djR6grT5DoJHqSaYa43YmTmUXIY1zzrWUkx3lm8dwxaudIuXSEpFreKjqauj0nZ
 rq8S6FDFEMmkBWqAtIWnb5OvW2qU+eA1vhVR0Cao8KakyZvplVi5P8SPgsN5MSG5xZEy
 bD2DoMr4NXO1WqW6vWNEq0O2y6BdMU0FcLHQwg4+5xzxjxIkoHrN0Q7rAP4ehLcbfLh9
 WuJwhQrf4mF9OiTa4Oic677/toW3IEbTDPTlZKrtV9ydwGfz3bGBW7qA3CYoKLnYxxmY
 1UtIQYyoHhb9hXqGveElUe0IhklJ7bSMf1m1kTXBrBfZj+VF5/yEetss9ZTjOdhJ8TPE
 dSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0eQeP3GzjSxs3bFEsWrl0jof0V3c/zOR378LhVu6aVM=;
 b=cuhRf5lhEBeXoLypQPOa/acIT2sJauOmMHIL+bq6tb/7PenKmRcHyUubxp17qUgp/A
 5OMdf/be77tRa7cnxPWckgif5p0YJda4a/C/a8Pghn0PLSKUPd3wl/3H/tQxc3y2ZoNT
 hJ6NLYhvvK1m5rn0ieuZ1zSvM+B+kJlwqxVFv9QYrtSAgBYa/VO14mMkShDIYO10u4+t
 Yjd22kBYUbiJEqzf6I/TWYueqHZRUJVOm+49NdBPFwS2q/nSlM2rqUJlJg+xc2mB42wD
 Vio46GUcRhErZ/ajhyQPE5f4oV4XthmZ/hsQGeO9WMGz4jOtLWp4P0lOLT3NHE2FDPuf
 zgCA==
X-Gm-Message-State: AOAM533eGZilluVplpUiF0nbWfUibYypd67Lfrh+gLcaxkQyk8goBfNg
 /eTO1XplhPrT6iGCIQ1hSEihxr6k/6X8VxNu0NnD4A==
X-Google-Smtp-Source: ABdhPJzYW+HNNpZCuNrYQ+PqbU6fJhTMCkFS76nSOqdlNgbBezGKlNVWKEYvrhVOCHiGYxSgEJIQGaqr9FHR5gjgLks=
X-Received: by 2002:a05:600c:218d:b0:37f:a920:9705 with SMTP id
 e13-20020a05600c218d00b0037fa9209705mr3264121wme.86.1645725401178; Thu, 24
 Feb 2022 09:56:41 -0800 (PST)
MIME-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
 <20220224051439.640768-7-kaleshsingh@google.com>
 <CA+EHjTwhpjDDnKRU3QrJysgMhYH7eTi2_LrWpxCArLoP-1-BrQ@mail.gmail.com>
In-Reply-To: <CA+EHjTwhpjDDnKRU3QrJysgMhYH7eTi2_LrWpxCArLoP-1-BrQ@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 24 Feb 2022 09:56:30 -0800
Message-ID: <CAC_TJve3wW91UMtCNHeDSZ8hspySmuYO2WgEYEH3Dk=Uj+GkJw@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] KVM: arm64: Add hypervisor overflow stack
To: Fuad Tabba <tabba@google.com>
X-Mailman-Approved-At: Fri, 25 Feb 2022 09:59:45 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 Marc Zyngier <maz@kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Suren Baghdasaryan <surenb@google.com>, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
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

On Thu, Feb 24, 2022 at 4:27 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Kalesh,
>
> On Thu, Feb 24, 2022 at 5:21 AM Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Allocate and switch to 16-byte aligned secondary stack on overflow. This
> > provides us stack space to better handle overflows; and is used in
> > a subsequent patch to dump the hypervisor stacktrace. The overflow stack
> > is only allocated if CONFIG_NVHE_EL2_DEBUG is enabled, as hypervisor
> > stacktraces is a debug feature dependent on CONFIG_NVHE_EL2_DEBUG.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/host.S   | 5 +++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 5 +++++
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index 749961bfa5ba..367a01e8abed 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -179,6 +179,10 @@ SYM_FUNC_END(__host_hvc)
> >         b       hyp_panic
> >
> >  .L__hyp_sp_overflow\@:
> > +#ifdef CONFIG_NVHE_EL2_DEBUG
> > +       /* Switch to the overflow stack */
> > +       adr_this_cpu sp, hyp_overflow_stack + PAGE_SIZE, x0
> > +#else
> >         /*
> >          * Reset SP to the top of the stack, to allow handling the hyp_panic.
> >          * This corrupts the stack but is ok, since we won't be attempting
> > @@ -186,6 +190,7 @@ SYM_FUNC_END(__host_hvc)
> >          */
>
> Nit: Maybe you should update this comment as well, since whether it
> corrupts the stack or not depends on what happens above with
> CONFIG_NVHE_EL2_DEBUG.

Ack, will update it in the next version.

Thanks,
Kalesh
>
> Thanks,
> /fuad
>
> >         ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
> >         mov     sp, x0
> > +#endif
> >
> >         bl      hyp_panic_bad_stack
> >         ASM_BUG()
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 703a5d3f611b..efc20273a352 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -34,6 +34,11 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
> >  DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
> >  DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
> >
> > +#ifdef CONFIG_NVHE_EL2_DEBUG
> > +DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
> > +       __aligned(16);
> > +#endif
> > +
> >  static void __activate_traps(struct kvm_vcpu *vcpu)
> >  {
> >         u64 val;
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
