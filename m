Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FDDC43334
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 00:01:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5734C682;
	Thu, 21 Jul 2022 20:01:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NxFL+IhF91+z; Thu, 21 Jul 2022 20:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E79234C83A;
	Thu, 21 Jul 2022 20:01:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B454C712
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 20:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SL-CZ8SPR1tB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 20:01:20 -0400 (EDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A7754C682
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 20:01:19 -0400 (EDT)
Received: by mail-lj1-f171.google.com with SMTP id r14so3677442ljp.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 17:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=TfUx8CmhONPumASQ3Ohn0ZPBwIqk0yRSMBdm0KN2cgU=;
 b=rOHN3ZGGd0VZ8vpBhxUS3HRRKOp92PUaDlqmaWVQgqErtb6Xo8/DY7Q5ALgGDkl1G8
 qQ7FlqyStGgGVHuhOQy8qypFsKQl0an3DzVR1DnoI8XA+tnSI9bgkFO0XC0hMI2lE/QL
 wrMQyRmh4idG2r0aPrIKyi9Ui4tb8TLAnFuCOHGHkKg7V5iR9yCd4zWR1hs2+4bvChdy
 x40yWVd9k2XjY9Czw6f7QBnQThHo7oCtU7sh2xOK23lJiJx7iwopE2D/670kdQaj0UZG
 RDlQoapXQoEoN9uzBnp0raGVgaQwy6wESzIK0Be3BQGnm+GFq/VbVNMUye51vkNgxkgT
 Df8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=TfUx8CmhONPumASQ3Ohn0ZPBwIqk0yRSMBdm0KN2cgU=;
 b=aAhoHgXSAh4xcCtrJgEu1BbMzYHFuOJJweY2z7pmi7u6mg5iTlQfYl0KsBxnOr8qI6
 SPZpFcqXFrPCVcBUB3Gj9JfCLk2o089LynYptekjEyTmxzuhOzRLCivlibvAiRNPJPvk
 ViWB+EA2LJe2Uh0NG0hc7MvwyKviX3Gw0qBWYHTqF4Ry6JiL/NG4/9lKcVTZxWOPzKid
 e6ErfMEMOHRfuKk3uiJtDNI7V75epsGsjX8FSsM8qriIz7QHWoJhO3bqwc9flaM22zE3
 IA9PDDRf1zGz4WcywqCthOu2u0ipbVS0hkbOJ6rMGRQdCI41myT3FvRgxLH2YRydCK+S
 TbkA==
X-Gm-Message-State: AJIora89Kw3GriBXpxpuJ4571wTrAxxeLciPQw7IqvecypeRPkAOrzOX
 YrnjxXsj5Vn7yW60Lz3shaF88JcfBnUM2w2kktm2HA==
X-Google-Smtp-Source: AGRyM1s+4jZ2x/29KrEyF0s+DwzE6XpjQADLpLzRnJDAnzkLjFNuegifnNgpwxjZcEU4vwvE6S7KFwmjrYf0PPjgeak=
X-Received: by 2002:a2e:9d02:0:b0:25d:d6b9:b753 with SMTP id
 t2-20020a2e9d02000000b0025dd6b9b753mr262234lji.344.1658448078269; Thu, 21 Jul
 2022 17:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-18-kaleshsingh@google.com>
 <Ytm4ji93wyjRI7Jw@google.com>
In-Reply-To: <Ytm4ji93wyjRI7Jw@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 21 Jul 2022 17:01:07 -0700
Message-ID: <CAC_TJveRKqRkfiJr=0JHxRYSqTh3CMANqNkkRNRvj=xwWd6jDg@mail.gmail.com>
Subject: Re: [PATCH v5 17/17] KVM: arm64: Introduce hyp_dump_backtrace()
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

On Thu, Jul 21, 2022 at 1:35 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Kalesh,
>
> Nifty series! Had the chance to take it for a spin :) Few comments
> below:

Hi Oliver. Thanks for giving it a try :)

>
> On Wed, Jul 20, 2022 at 10:57:28PM -0700, Kalesh Singh wrote:
> > In non-protected nVHE mode, unwinds and dumps the hypervisor backtrace
> > from EL1. This is possible beacuase the host can directly access the
> > hypervisor stack pages in non-proteced mode.
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >
> > Changes in v5:
> >   - Move code out from nvhe.h header to handle_exit.c, per Marc
> >   - Fix stacktrace symoblization when CONFIG_RAMDOMIZE_BASE is enabled,
> >     per Fuad
> >   - Use regular comments instead of doc comments, per Fuad
> >
> >  arch/arm64/kvm/handle_exit.c | 65 +++++++++++++++++++++++++++++++-----
> >  1 file changed, 56 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index ad568da5c7d7..432b6b26f4ad 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
>
> [...]
>
> > @@ -318,6 +319,56 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >               kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
> >  }
> >
> > +/*
> > + * kvm_nvhe_print_backtrace_entry - Symbolizes and prints the HYP stack address
> > + */
> > +static void kvm_nvhe_print_backtrace_entry(unsigned long addr,
> > +                                               unsigned long hyp_offset)
> > +{
> > +     unsigned long va_mask = GENMASK_ULL(vabits_actual - 1, 0);
> > +
> > +     /* Mask tags and convert to kern addr */
> > +     addr = (addr & va_mask) + hyp_offset;
> > +     kvm_err(" [<%016lx>] %pB\n", addr, (void *)(addr + kaslr_offset()));
> > +}
>
> It is a bit odd to see this get churned from the last patch. Is it
> possible to introduce the helper earlier on? In fact, the non-protected
> patch should come first to layer the series better.

Agreed. pKVM is the one with the extra layer. I'll reorder this in the
next version.

>
> Also, it seems to me that there isn't much need for the indirection if
> the pKVM unwinder is made to work around the below function signature:

Ok, I'll fold it into the below function.

>
> <snip>
>
> > +/*
> > + * hyp_dump_backtrace_entry - Dump an entry of the non-protected nVHE HYP stacktrace
> > + *
> > + * @arg    : the hypervisor offset, used for address translation
> > + * @where  : the program counter corresponding to the stack frame
> > + */
> > +static bool hyp_dump_backtrace_entry(void *arg, unsigned long where)
> > +{
> > +     kvm_nvhe_print_backtrace_entry(where, (unsigned long)arg);
> > +
> > +     return true;
> > +}
>
> </snip>
>
> > +/*
> > + * hyp_dump_backtrace - Dump the non-proteced nVHE HYP backtrace.
> > + *
> > + * @hyp_offset: hypervisor offset, used for address translation.
> > + *
> > + * The host can directly access HYP stack pages in non-protected
> > + * mode, so the unwinding is done directly from EL1. This removes
> > + * the need for shared buffers between host and hypervisor for
> > + * the stacktrace.
> > + */
> > +static void hyp_dump_backtrace(unsigned long hyp_offset)
> > +{
> > +     struct kvm_nvhe_stacktrace_info *stacktrace_info;
> > +     struct unwind_state state;
> > +
> > +     stacktrace_info = this_cpu_ptr_nvhe_sym(kvm_stacktrace_info);
> > +
> > +     kvm_nvhe_unwind_init(&state, stacktrace_info->fp, stacktrace_info->pc);
> > +
> > +     kvm_err("Non-protected nVHE HYP call trace:\n");
>
> I don't see the value in discerning non-protected vs. protected in the
> preamble, as panic() will dump the kernel commandline which presumably
> would have a `kvm-arm.mode=protected` in the case of pKVM.

Ok, I'll remove the distinction.

>
> <nit>
>
> Not entirely your problem, but we should really use a consistent name
> for that thing we have living at EL2. Hyp or nVHE (but not both) would
> be appropriate.
>

Right, I think just "nVHE" is probably sufficient. (Open to other suggestions)

> </nit>
>
> > +     unwind(&state, hyp_dump_backtrace_entry, (void *)hyp_offset);
> > +     kvm_err("---- End of Non-protected nVHE HYP call trace ----\n");
>
> Maybe:
>
> kvm_err("---[ end ${NAME_FOR_EL2} trace ]---");
>
> (more closely matches the pattern of the arm64 stacktrace)

Agreed.

Thanks,
Kalesh

>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
