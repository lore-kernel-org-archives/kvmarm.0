Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F37C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 07:21:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 702BA61507
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 07:21:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 702BA61507
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8DC4B2DA;
	Tue,  5 Oct 2021 03:21:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2g5N-EI-qpb2; Tue,  5 Oct 2021 03:21:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78F134B2A1;
	Tue,  5 Oct 2021 03:21:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13E954B287
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 03:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dXtcxnsunHwR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 03:21:18 -0400 (EDT)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com
 [209.85.167.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7FBB4B284
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 03:21:18 -0400 (EDT)
Received: by mail-oi1-f172.google.com with SMTP id t189so25030330oie.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 00:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=t50iClouvR5wNCpxVuPLY/4woxgBaeq2YJxilfcBxqQ=;
 b=J+94v5pHqshDYiJxv8ZiKIUzq3WoDzxQ6USi+tcv2o8XFm3vczBmpRbsSeFYCnJifN
 odYbvqEwPcw/FPG1AFa9lzP83y7WHTj44NOsOKcvDNOrt2eCJoT2mBTa5fSD6OywWwkC
 BLd7H+8rRl2+Lwb/+0bqWau6yYX/qXemovS3VeePF1IlgOw3eT/n5V6CRfkBKxWwDH33
 xjAQEJ8nofWJ/EhrEhdWzEWOmkshYoBVfFgwubbO+qfY472Fn1Tyjq55esDuKfg2RSYF
 eNPLDGRBuL7G2AIaQ5t8esAthukpMn5VdNjxBaRw4SCuYZB0dtrvgP3p/lfO7xDze8VS
 4Z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=t50iClouvR5wNCpxVuPLY/4woxgBaeq2YJxilfcBxqQ=;
 b=BBfVYv2ZAZ6cLfoeKRmlfycS1MypVQY989TYloisz3hgGGGL2231p0/pCB4RdmFAWW
 QJvhSPzthrEOHczm6ms/UAdfUS3cY8e6uUMqCxWP8YGmAyAIlMdiskV93PvuDlYidGiK
 YYf/ac3JAtSrD68FiNjYOhV7RE+0B3ROwC6H7fTj6V8TqDwAlaUmegEvG9TtUEJIPET4
 N9SQI5PAlQWa3FKez6hgUE2cnhv6TGE0vLg3BBpbBfwI6Z8K8+1FHuxbXHTnigC1u13T
 0/RzgAbtubOvZR1yvfInh83fHVBo+HOahNHGtIqXMyUvUOLyn/vyXUWPUJntWo3Kedeq
 q3nw==
X-Gm-Message-State: AOAM533GdcVrGuO0UOQLgsIZyc67uFMrmGpY0VxkHbkHr6dm4j5SKbx0
 BYN/UbG9Am8dAWMSNSs5BdsfvvDIFWVpHjGB0Es2pw==
X-Google-Smtp-Source: ABdhPJxEaJp7LF/gYfQZpn3JIvXZDIElO6AVcWj+FJM4+9kwneOgxH1YTpeV0ZXlGKdCSSn4gfibW+UcW15ckdXKP6o=
X-Received: by 2002:a05:6808:1641:: with SMTP id
 az1mr1237774oib.67.1633418477949; 
 Tue, 05 Oct 2021 00:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-12-tabba@google.com>
 <87tuhwr98w.wl-maz@kernel.org>
In-Reply-To: <87tuhwr98w.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Oct 2021 08:20:41 +0100
Message-ID: <CA+EHjTxH4MhqrO1G_YmYSEwLceG6xxMe4SSRbSHVtmXSSSpy4A@mail.gmail.com>
Subject: Re: [PATCH v6 11/12] KVM: arm64: Trap access to pVM restricted
 features
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Mon, Oct 4, 2021 at 6:27 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Wed, 22 Sep 2021 13:47:03 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Trap accesses to restricted features for VMs running in protected
> > mode.
> >
> > Access to feature registers are emulated, and only supported
> > features are exposed to protected VMs.
> >
> > Accesses to restricted registers as well as restricted
> > instructions are trapped, and an undefined exception is injected
> > into the protected guests, i.e., with EC = 0x0 (unknown reason).
> > This EC is the one used, according to the Arm Architecture
> > Reference Manual, for unallocated or undefined system registers
> > or instructions.
> >
> > Only affects the functionality of protected VMs. Otherwise,
> > should not affect non-protected VMs when KVM is running in
> > protected mode.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 60 ++++++++++++++++++++++++++++++++
> >  1 file changed, 60 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 49080c607838..2bf5952f651b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -20,6 +20,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> > @@ -28,6 +29,7 @@
> >  #include <asm/thread_info.h>
> >
> >  #include <nvhe/mem_protect.h>
> > +#include <nvhe/sys_regs.h>
> >
> >  /* Non-VHE specific context */
> >  DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
> > @@ -158,6 +160,49 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> >               write_sysreg(pmu->events_host, pmcntenset_el0);
> >  }
> >
> > +/**
> > + * Handler for protected VM restricted exceptions.
> > + *
> > + * Inject an undefined exception into the guest and return true to indicate that
> > + * the hypervisor has handled the exit, and control should go back to the guest.
> > + */
> > +static bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     __inject_undef64(vcpu);
> > +     return true;
> > +}
> > +
> > +/**
> > + * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
> > + *
> > + * Returns true if the hypervisor has handled the exit, and control should go
> > + * back to the guest, or false if it hasn't.
> > + */
> > +static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     if (kvm_handle_pvm_sysreg(vcpu, exit_code))
> > +             return true;
> > +     else
> > +             return kvm_hyp_handle_sysreg(vcpu, exit_code);
>
> nit: drop the else.

Will do.

> I wonder though: what if there is an overlap between between the pVM
> handling and the normal KVM stuff? Are we guaranteed that there is
> none?
>
> For example, ESR_ELx_EC_SYS64 is used when working around some bugs
> (see the TX2 TVM handling). What happens if you return early and don't
> let it happen? This has a huge potential for some bad breakage.

This is a tough one. Especially because it's dealing with bugs, there
is no guarantee really. I think that for the TVM handling there is no
overlap and the TVM handling code in kvm_hyp_handle_sysreg() will be
invoked. However, workarounds could always be added, and if that
happens, we need to make sure that they're on all paths. One solution
is to make sure that such code is in a common function called by both
paths. Not sure how we could enforce that other than by documenting
it.

What do you think?

> > +}
> > +
> > +/**
> > + * Handler for protected floating-point and Advanced SIMD accesses.
> > + *
> > + * Returns true if the hypervisor has handled the exit, and control should go
> > + * back to the guest, or false if it hasn't.
> > + */
> > +static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     /* Linux guests assume support for floating-point and Advanced SIMD. */
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +     BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
> > +                             PVM_ID_AA64PFR0_ALLOW));
> > +
> > +     return kvm_hyp_handle_fpsimd(vcpu, exit_code);
> > +}
> > +
> >  static const exit_handler_fn hyp_exit_handlers[] = {
> >       [0 ... ESR_ELx_EC_MAX]          = NULL,
> >       [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15,
> > @@ -170,8 +215,23 @@ static const exit_handler_fn hyp_exit_handlers[] = {
> >       [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
> >  };
> >
> > +static const exit_handler_fn pvm_exit_handlers[] = {
> > +     [0 ... ESR_ELx_EC_MAX]          = NULL,
> > +     [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15,
> > +     [ESR_ELx_EC_CP15_64]            = kvm_hyp_handle_cp15,
>
> Heads up, this one was bogus, and I removed it in my patches[1].
>
> But it really begs the question: given that you really don't want to
> handle any AArch32 for protected VMs, why handling anything at all the
> first place? You really should let the exit happen and let the outer
> run loop deal with it.

Good point. Will fix this.

Cheers,
/fuad

> > +     [ESR_ELx_EC_SYS64]              = kvm_handle_pvm_sys64,
> > +     [ESR_ELx_EC_SVE]                = kvm_handle_pvm_restricted,
> > +     [ESR_ELx_EC_FP_ASIMD]           = kvm_handle_pvm_fpsimd,
> > +     [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
> > +     [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
> > +     [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
> > +};
> > +
> >  static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
> >  {
> > +     if (unlikely(kvm_vm_is_protected(kvm)))
> > +             return pvm_exit_handlers;
> > +
> >       return hyp_exit_handlers;
> >  }
> >
> > --
> > 2.33.0.464.g1972c5931b-goog
> >
> >
>
> Thanks,
>
>         M.
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/early-ec-handlers&id=f84ff369795ed47f2cd5e556170166ee8b3a988f
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
