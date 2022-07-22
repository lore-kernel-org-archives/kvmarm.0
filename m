Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA86C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 17:28:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94F214CCFD;
	Fri, 22 Jul 2022 13:28:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 37gk1ViTXWia; Fri, 22 Jul 2022 13:28:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A36F4CB98;
	Fri, 22 Jul 2022 13:28:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E071C4D229
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 13:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q2V7FqApyeSW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2022 13:28:31 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93FC14D213
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 13:28:31 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id a5so7395069wrx.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 10:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iwlo3BqFTDCGoeQJZWI9pHBVdatv5K3XsvNJ8Oj1ml0=;
 b=EvrScfvXzo/TRQoNEGgStFwBfwgOXLAWI14neyWBoektfW3yQaQaUzJpfRCq2CSE8W
 eC7GoUHSUfnidEnJkSl+J3F7RZOYOHW9MPCzeQrlMWCCjPuIftWDJhS6Gvr8jFiP6A28
 A1eJ0Ccw5PjBaXUFVN7egE0wEozabHciz42onTJgCN4386Td3elkdLV1HpAqyCAx2lFH
 pKEvmNRV6gplzqZXvBW+DxTxSHVoaul2LwwHR0ZjmJb7+A8EuTLZ7snpMVJa35SE+alg
 QEtEfxm4xbQXV08ULk1GvbAjnrVS2cttW+/TOmIYJXmhQ5GIHmfYnLns3gfCcIHOUynn
 nIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=iwlo3BqFTDCGoeQJZWI9pHBVdatv5K3XsvNJ8Oj1ml0=;
 b=gwdjZdEzARKoJzQXgiGtEIXqfRVFhd/JTLDX4rUn4c7PF6hY4dP0G0K/xRoIa+tAVX
 jUCvzVj3+861xqYnGNqEN0eF1lNLEoRQUxs29BlbZ7RMfjD5U7pEyKnecR3XXR4J/sIB
 tzXRUMnKfXrGFtq98E5o2wWt9l10NE0dkmkSy40vxH8QqT9DVrpPDtfWT6l0QoAnxzus
 Niqrb3kAkgjm2IFBvvkeZo9vUJfSjpqyrXc6vQctzIUi+dMHgz7gCYtppj4ZWaHuiWAw
 aphqYE3DwEJEOvfyZnVU7TDcCQtODBu+Jt+dnE7kXM49YceFnPZOzIG+9CGj4Yq3UP7F
 gCGg==
X-Gm-Message-State: AJIora9IOR6U8Yae+t4rLqifm12WnZJ14fELn79U1ZQpfmT8KW2Rk4Fd
 rvEeSdQe6FD8zTS+z6R8YcRxpSdxp1pFVzY78UINuA==
X-Google-Smtp-Source: AGRyM1u4ikPl/LtayDssTs6DxZSbbt9+bh3MqXwxRj6V6FITNQSGqxV7Y7eunshdDHKNYuaCM56/nHqbH6WDzqJYZxs=
X-Received: by 2002:a05:6000:1e04:b0:21d:7ec3:fe5a with SMTP id
 bj4-20020a0560001e0400b0021d7ec3fe5amr693779wrb.116.1658510910254; Fri, 22
 Jul 2022 10:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-13-kaleshsingh@google.com>
 <YtrDU9TRjNWCTPVg@google.com>
In-Reply-To: <YtrDU9TRjNWCTPVg@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 22 Jul 2022 10:28:19 -0700
Message-ID: <CAC_TJvcdc=gRG5fYr16gQikHLedtH=RyasXvgNsMufUNtBEXRg@mail.gmail.com>
Subject: Re: [PATCH v5 12/17] KVM: arm64: Save protected-nVHE (pKVM) hyp
 stacktrace
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marco Elver <elver@google.com>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, Marc Zyngier <maz@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Andrew Jones <drjones@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, andreyknvl@gmail.com,
 LKML <linux-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>
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

On Fri, Jul 22, 2022 at 8:33 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Kalesh,
>
> On Wed, Jul 20, 2022 at 10:57:23PM -0700, Kalesh Singh wrote:
> > In protected nVHE mode, the host cannot access private owned hypervisor
> > memory. Also the hypervisor aims to remains simple to reduce the attack
> > surface and does not provide any printk support.
> >
> > For the above reasons, the approach taken to provide hypervisor stacktraces
> > in protected mode is:
> >    1) Unwind and save the hyp stack addresses in EL2 to a shared buffer
> >       with the host (done in this patch).
> >    2) Delegate the dumping and symbolization of the addresses to the
> >       host in EL1 (later patch in the series).
> >
> > On hyp_panic(), the hypervisor prepares the stacktrace before returning to
> > the host.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
>
> Tried reworking this a bit and here is what I arrived at, WDYT?
> Untested, of course :)

Hi Oliver,

I think what you have is a lot cleaner. :) I'll incorporate it for the
next spin.

Thanks,
Kalesh

>
> --
> Thanks,
> Oliver
>
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> index 3078501f8e22..05d7e03e0a8c 100644
> --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -21,6 +21,23 @@
>
>  #include <asm/stacktrace/common.h>
>
> +/*
> + * kvm_nvhe_unwind_init - Start an unwind from the given nVHE HYP fp and pc
> + *
> + * @state : unwind_state to initialize
> + * @fp    : frame pointer at which to start the unwinding.
> + * @pc    : program counter at which to start the unwinding.
> + */
> +static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
> +                                       unsigned long fp,
> +                                       unsigned long pc)
> +{
> +       unwind_init_common(state, NULL);
> +
> +       state->fp = fp;
> +       state->pc = pc;
> +}
> +
>  static inline bool on_accessible_stack(const struct task_struct *tsk,
>                                        unsigned long sp, unsigned long size,
>                                        struct stack_info *info)
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> index 96c8b93320eb..644276fb02af 100644
> --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -11,4 +11,69 @@ DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
>
>  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
>  DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
> +
> +/*
> + * pkvm_save_backtrace_entry - Saves a protected nVHE HYP stacktrace entry
> + *
> + * @arg    : the index of the entry in the stacktrace buffer
> + * @where  : the program counter corresponding to the stack frame
> + *
> + * Save the return address of a stack frame to the shared stacktrace buffer.
> + * The host can access this shared buffer from EL1 to dump the backtrace.
> + */
> +static bool pkvm_save_backtrace_entry(void *arg, unsigned long where)
> +{
> +       unsigned long *stacktrace = this_cpu_ptr(pkvm_stacktrace);
> +       int *idx = (int *)arg;
> +
> +       /*
> +        * Need 2 free slots: 1 for current entry and 1 for the
> +        * delimiter.
> +        */
> +       if (*idx > ARRAY_SIZE(pkvm_stacktrace) - 2)
> +               return false;
> +
> +       stacktrace[*idx] = where;
> +       stacktrace[++*idx] = 0UL;
> +
> +       return true;
> +}
> +
> +/*
> + * pkvm_save_backtrace - Saves the protected nVHE HYP stacktrace
> + *
> + * @fp : frame pointer at which to start the unwinding.
> + * @pc : program counter at which to start the unwinding.
> + *
> + * Save the unwinded stack addresses to the shared stacktrace buffer.
> + * The host can access this shared buffer from EL1 to dump the backtrace.
> + */
> +static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
> +{
> +       struct unwind_state state;
> +       int idx = 0;
> +
> +       kvm_nvhe_unwind_init(&state, fp, pc);
> +
> +       unwind(&state, pkvm_save_backtrace_entry, &idx);
> +}
> +#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> +static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
> +{
> +}
>  #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> +
> +/*
> + * kvm_nvhe_prepare_backtrace - prepare to dump the nVHE backtrace
> + *
> + * @fp : frame pointer at which to start the unwinding.
> + * @pc : program counter at which to start the unwinding.
> + *
> + * Saves the information needed by the host to dump the nVHE hypervisor
> + * backtrace.
> + */
> +void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
> +{
> +       if (is_protected_kvm_enabled())
> +               pkvm_save_backtrace(fp, pc);
> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 6db801db8f27..64e13445d0d9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -34,6 +34,8 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
>  DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>
> +extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
> +
>  static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
>         u64 val;
> @@ -375,6 +377,10 @@ asmlinkage void __noreturn hyp_panic(void)
>                 __sysreg_restore_state_nvhe(host_ctxt);
>         }
>
> +       /* Prepare to dump kvm nvhe hyp stacktrace */
> +       kvm_nvhe_prepare_backtrace((unsigned long)__builtin_frame_address(0),
> +                                  _THIS_IP_);
> +
>         __hyp_do_panic(host_ctxt, spsr, elr, par);
>         unreachable();
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
