Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22298C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 17:36:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 980C54D730;
	Mon, 18 Jul 2022 13:36:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vyJXBZrEnpna; Mon, 18 Jul 2022 13:36:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49F8C4D736;
	Mon, 18 Jul 2022 13:36:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A7964D71E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6hLqCEFLcBmI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 13:36:39 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDE634D6E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:36:38 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id v16so2289243wrr.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 10:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XjNKaW7NRoU376H3IAtZu9323wKhhqWkRMdq9V9ugLM=;
 b=XkYmp5LFgBH04IKeO22dXnfycbzv0+nqjpSozbbbu9hCDxe3zFHk4P7tTGXjrmSW0l
 30/pALVUq8pkMcvAN8zvAHlDW8U4aM9su/s9QWwpZO3m+kNN3qm0vJZG4Vf2zqVctLCq
 JGbW4Oi0qtAcgEszybxPuzvjRqzymsgYTh9HyXKL3Sn4Z/6XlTbYgd9SPelBSrh18GQq
 4/QEtNGAMu+3siI7I7+WHeff2gF+r667NDk7O5IE8KNpelJHJIDn3WdSm/nhUV5UW27g
 IrSt4lBaUi2nFoSHoIDI6nHsoiHfUmAa0AH4ZtuGFvPS+UaUJe3WiZnnAN9jHOkNN1XQ
 J2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XjNKaW7NRoU376H3IAtZu9323wKhhqWkRMdq9V9ugLM=;
 b=E16DIdBXAN0srgUb0DiXxB3TEEb+gZN/NcSkAQb9iWCKS/dDgSalHmsRfVGylesfSb
 MhB3yXyDDQQ5Otp7nq1PVJgVvlzKaO5zdwOOG1ML2CArmjN/Mt9SUyK6fDzyziYFGhC5
 EgkbV4b0ufB3dIogmShH/M406/l83Ct13LBiTWrdEmcDEJbeBPBlZn85ZgsG2Sj/CnGm
 KiBfBpLu83y/wt2NYzOeupxe7rAU0Fp0tdbNZoX7YpxRMCRwy40DRWJJFGyz06/jElGZ
 7llqvMg/OQur5KmJGuPAsZgheVIikqmG5RTEgZdpsCZCPn6Px0Lf5onuyrgUugADQ1WB
 PmPA==
X-Gm-Message-State: AJIora8VK+UnS48yCVfXj0zkYmpbGngFUahaN2Z1+aYH9FdPVKbynJ1y
 kLklfzPED/sRuBKNZzobkDDYCPGX72m1pZ1NVSxRow==
X-Google-Smtp-Source: AGRyM1uiXo0g/V54MJg5NwiG4eamdCrDj+v/MxteMevT3CYQUP1C+atyDrRN4RaRUqYnmDPPfcX1KL5Y9jmfMDBAQvg=
X-Received: by 2002:a05:6000:1e04:b0:21d:7ec3:fe5a with SMTP id
 bj4-20020a0560001e0400b0021d7ec3fe5amr24016772wrb.116.1658165797763; Mon, 18
 Jul 2022 10:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-13-kaleshsingh@google.com>
 <CA+EHjTw8VwFHYHzpyt+sqwo7CDhGm+F+h2+AX=5FtYcXPECGUA@mail.gmail.com>
In-Reply-To: <CA+EHjTw8VwFHYHzpyt+sqwo7CDhGm+F+h2+AX=5FtYcXPECGUA@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Jul 2022 10:36:22 -0700
Message-ID: <CAC_TJvfjVK1PNY-UAq8ex1HsqWEN2muM7D_hRXr6LN=hT5=aLQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] KVM: arm64: Save protected-nVHE (pKVM) hyp
 stacktrace
To: Fuad Tabba <tabba@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 andreyknvl@gmail.com, "Cc: Android Kernel" <kernel-team@android.com>,
 Marco Elver <elver@google.com>, Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, russell.king@oracle.com,
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

On Mon, Jul 18, 2022 at 3:07 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Kalesh,
>
> On Fri, Jul 15, 2022 at 7:11 AM Kalesh Singh <kaleshsingh@google.com> wrote:
> >
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
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/stacktrace/nvhe.h | 18 ++++++
> >  arch/arm64/kvm/hyp/nvhe/stacktrace.c     | 70 ++++++++++++++++++++++++
> >  2 files changed, 88 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> > index 36cf7858ddd8..456a6ae08433 100644
> > --- a/arch/arm64/include/asm/stacktrace/nvhe.h
> > +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> > @@ -21,6 +21,22 @@
> >
> >  #include <asm/stacktrace/common.h>
> >
> > +/**
> > + * kvm_nvhe_unwind_init - Start an unwind from the given nVHE HYP fp and pc
> > + *
> > + * @fp : frame pointer at which to start the unwinding.
> > + * @pc : program counter at which to start the unwinding.
> > + */
> > +static __always_inline void kvm_nvhe_unwind_init(struct unwind_state *state,
> > +                                                unsigned long fp,
> > +                                                unsigned long pc)
> > +{
> > +       unwind_init_common(state, NULL);
> > +
> > +       state->fp = fp;
> > +       state->pc = pc;
> > +}
> > +
> >  static inline bool on_accessible_stack(const struct task_struct *tsk,
> >                                        unsigned long sp, unsigned long size,
> >                                        struct stack_info *info)
> > @@ -33,6 +49,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
> >   */
> >  #ifdef __KVM_NVHE_HYPERVISOR__
> >
> > +extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
> > +
> >  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> >  static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
> >                                      struct stack_info *info)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> > index 96c8b93320eb..832a536e440f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> > @@ -11,4 +11,74 @@ DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
> >
> >  #ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> >  DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
> > +
> > +/**
> > + * pkvm_save_backtrace_entry - Saves a protected nVHE HYP stacktrace entry
> > + *
> > + * @arg    : the position of the entry in the stacktrace buffer
> > + * @where  : the program counter corresponding to the stack frame
> > + *
> > + * Save the return address of a stack frame to the shared stacktrace buffer.
> > + * The host can access this shared buffer from EL1 to dump the backtrace.
> > + */
> > +static bool pkvm_save_backtrace_entry(void *arg, unsigned long where)
> > +{
> > +       unsigned long **stacktrace_pos = (unsigned long **)arg;
> > +       unsigned long stacktrace_start, stacktrace_end;
> > +
> > +       stacktrace_start = (unsigned long)this_cpu_ptr(pkvm_stacktrace);
> > +       stacktrace_end = stacktrace_start + NVHE_STACKTRACE_SIZE - (2 * sizeof(long));
>
> I guess this is related to my comment in patch 9, but why does the end
> happen at 2 * instead of just 1 * before the actual end? I guess
> because it's inclusive. That said, a comment would be helpful.
>

The intention is to check that we can fit 2 entries (the stacktrace
entry and null entry). I think the "end" naming is a bit misleading.
Let me try to clarify it better in the next version.

Thanks,
Kalesh

> Thanks,
> /fuad
>
> > +
> > +       if ((unsigned long) *stacktrace_pos > stacktrace_end)
> > +               return false;
> > +
> > +       /* Save the entry to the current pos in stacktrace buffer */
> > +       **stacktrace_pos = where;
> > +
> > +       /* A zero entry delimits the end of the stacktrace. */
> > +       *(*stacktrace_pos + 1) = 0UL;
> > +
> > +       /* Increment the current pos */
> > +       ++*stacktrace_pos;
> > +
> > +       return true;
> > +}
> > +
> > +/**
> > + * pkvm_save_backtrace - Saves the protected nVHE HYP stacktrace
> > + *
> > + * @fp : frame pointer at which to start the unwinding.
> > + * @pc : program counter at which to start the unwinding.
> > + *
> > + * Save the unwinded stack addresses to the shared stacktrace buffer.
> > + * The host can access this shared buffer from EL1 to dump the backtrace.
> > + */
> > +static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
> > +{
> > +       void *stacktrace_start = (void *)this_cpu_ptr(pkvm_stacktrace);
> > +       struct unwind_state state;
> > +
> > +       kvm_nvhe_unwind_init(&state, fp, pc);
> > +
> > +       unwind(&state, pkvm_save_backtrace_entry, &stacktrace_start);
> > +}
> > +#else /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> > +static void pkvm_save_backtrace(unsigned long fp, unsigned long pc)
> > +{
> > +}
> >  #endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> > +
> > +/**
> > + * kvm_nvhe_prepare_backtrace - prepare to dump the nVHE backtrace
> > + *
> > + * @fp : frame pointer at which to start the unwinding.
> > + * @pc : program counter at which to start the unwinding.
> > + *
> > + * Saves the information needed by the host to dump the nVHE hypervisor
> > + * backtrace.
> > + */
> > +void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)
> > +{
> > +       if (is_protected_kvm_enabled())
> > +               pkvm_save_backtrace(fp, pc);
> > +}
> > --
> > 2.37.0.170.g444d1eabd0-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
