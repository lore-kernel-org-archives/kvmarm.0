Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E8DC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 11:53:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E353760F57
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 11:53:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E353760F57
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 626E64A3BF;
	Mon, 11 Oct 2021 07:53:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZCEwnWeN1SiN; Mon, 11 Oct 2021 07:53:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17BDB4B0B8;
	Mon, 11 Oct 2021 07:53:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFC3B4B0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 07:53:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M8opHOVVU1dp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 07:53:17 -0400 (EDT)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com
 [209.85.167.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D3514B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 07:53:17 -0400 (EDT)
Received: by mail-oi1-f180.google.com with SMTP id g125so17561293oif.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 04:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=eJ45GCrJMsooDuVSvfBbN5Gg/bGSxPWcigvSPp1UGKw=;
 b=NJklQjhlrY6tzVyO2KtGCqcIgqcsLFjuH3Y2wZ7aP19Eoex1iM/JMNTOgjLWsMbR1C
 Br/E5Lycs8Et377BwJgEQHG1veQbTcS7Zqst/2QuEl6ARsfG8jTq8GWPnBtUMc2/s8FO
 MGEd8cGshpP5Ge2uj4frPnsrjNVf0yR1fKhwv8fQ0mj2S/a1c+0WmUfdunQNVGmp91NS
 hcBCO55pWY++REpMcHf53n6D7wLXz/y54mkMz0BOrTu2cQ+70tEWqcIMDKikuUUiIJjr
 xPNo2Ntf0bdL4c1z/v8biZmgRw3F90fRFBdhMXBugulPschQDarRPLZxYW7fYG2DzU7D
 N5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=eJ45GCrJMsooDuVSvfBbN5Gg/bGSxPWcigvSPp1UGKw=;
 b=JKRf0DR+P9jr8waINjwuGXdUdHgJte0Ri5qgoNmqLINO4bx1n5ODGM3YWrueFWHLwP
 tbYBdzuT1M2nkTN2GBL7weYviAuPWMBZdOWvvETQhZJc9C/u8wLJmSVAUUS6TL7/6xK4
 O1xQvf0IqC9t9jW2CQDP1QeL3M/omrXDO+6tw8o5DgNvKKi/KvMn0rDpy7RWMmwMUkgF
 XrRnWWf++4I6TP8uzpy8KjJj49O/X5gUwZkAm7QcgfZwcCxQ2ePC5mvnYi04qjljpnwc
 ZBdKI/K67J13qIrX5cuPJEkVRY37IA/QQLkALuBbw015wA9AxfZxlox8mhlNKr5B8Kg+
 8fow==
X-Gm-Message-State: AOAM530SeBqPK0nTXtUisMu6vre2NyOh6GfZ9bvfPeWTS4fUdtYGPkfm
 jDpaZUbBy+8nY7jft6VvOTCmLwgYsITjQ5kdZwcDJQ==
X-Google-Smtp-Source: ABdhPJwgMq+PfOx4hyNsENit46m6eGxuw9QamY4RA5zHw+bykzWvYmusQtSreaRNEDRNACQqz8mMP6Q/9SL0rznUctE=
X-Received: by 2002:a05:6808:243:: with SMTP id
 m3mr9826330oie.14.1633953196720; 
 Mon, 11 Oct 2021 04:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
 <20211010145636.1950948-8-tabba@google.com>
 <87pmsbpz7j.wl-maz@kernel.org>
In-Reply-To: <87pmsbpz7j.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 11 Oct 2021 12:52:40 +0100
Message-ID: <CA+EHjTwQo8FOiKt5Y1K-7yNEAFDEOwaWGTti=5hXA0X+u=FASg@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] KVM: arm64: Add handlers for protected VM System
 Registers
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


On Mon, Oct 11, 2021 at 12:39 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 10 Oct 2021 15:56:32 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Add system register handlers for protected VMs. These cover Sys64
> > registers (including feature id registers), and debug.
> >
> > No functional change intended as these are not hooked in yet to
> > the guest exit handlers introduced earlier. So when trapping is
> > triggered, the exit handlers let the host handle it, as before.
> >
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> [...]
>
> > +/*
> > + * Architected system registers.
> > + * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> > + *
> > + * NOTE: Anything not explicitly listed here is *restricted by default*, i.e.,
> > + * it will lead to injecting an exception into the guest.
> > + */
> > +static const struct sys_reg_desc pvm_sys_reg_descs[] = {
> > +     /* Cache maintenance by set/way operations are restricted. */
> > +
> > +     /* Debug and Trace Registers are restricted. */
> > +
> > +     /* AArch64 mappings of the AArch32 ID registers */
> > +     /* CRm=1 */
> > +     AARCH32(SYS_ID_PFR0_EL1),
> > +     AARCH32(SYS_ID_PFR1_EL1),
> > +     AARCH32(SYS_ID_DFR0_EL1),
> > +     AARCH32(SYS_ID_AFR0_EL1),
> > +     AARCH32(SYS_ID_MMFR0_EL1),
> > +     AARCH32(SYS_ID_MMFR1_EL1),
> > +     AARCH32(SYS_ID_MMFR2_EL1),
> > +     AARCH32(SYS_ID_MMFR3_EL1),
> > +
> > +     /* CRm=2 */
> > +     AARCH32(SYS_ID_ISAR0_EL1),
> > +     AARCH32(SYS_ID_ISAR1_EL1),
> > +     AARCH32(SYS_ID_ISAR2_EL1),
> > +     AARCH32(SYS_ID_ISAR3_EL1),
> > +     AARCH32(SYS_ID_ISAR4_EL1),
> > +     AARCH32(SYS_ID_ISAR5_EL1),
> > +     AARCH32(SYS_ID_MMFR4_EL1),
> > +     AARCH32(SYS_ID_ISAR6_EL1),
> > +
> > +     /* CRm=3 */
> > +     AARCH32(SYS_MVFR0_EL1),
> > +     AARCH32(SYS_MVFR1_EL1),
> > +     AARCH32(SYS_MVFR2_EL1),
> > +     AARCH32(SYS_ID_PFR2_EL1),
> > +     AARCH32(SYS_ID_DFR1_EL1),
> > +     AARCH32(SYS_ID_MMFR5_EL1),
> > +
> > +     /* AArch64 ID registers */
> > +     /* CRm=4 */
> > +     AARCH64(SYS_ID_AA64PFR0_EL1),
> > +     AARCH64(SYS_ID_AA64PFR1_EL1),
> > +     AARCH64(SYS_ID_AA64ZFR0_EL1),
> > +     AARCH64(SYS_ID_AA64DFR0_EL1),
> > +     AARCH64(SYS_ID_AA64DFR1_EL1),
> > +     AARCH64(SYS_ID_AA64AFR0_EL1),
> > +     AARCH64(SYS_ID_AA64AFR1_EL1),
> > +     AARCH64(SYS_ID_AA64ISAR0_EL1),
> > +     AARCH64(SYS_ID_AA64ISAR1_EL1),
> > +     AARCH64(SYS_ID_AA64MMFR0_EL1),
> > +     AARCH64(SYS_ID_AA64MMFR1_EL1),
> > +     AARCH64(SYS_ID_AA64MMFR2_EL1),
> > +
> > +     HOST_HANDLED(SYS_SCTLR_EL1),
> > +     HOST_HANDLED(SYS_ACTLR_EL1),
> > +     HOST_HANDLED(SYS_CPACR_EL1),
> > +
> > +     HOST_HANDLED(SYS_RGSR_EL1),
> > +     HOST_HANDLED(SYS_GCR_EL1),
>
> What is the expected semantics of this handling? These registers are
> free to use by the guest unless MTE is disabled. Either the guest
> accesses them directly (no trap), accesses them while MTE is disabled
> (trap), or access them when MTE doesn't exist.
>
> The first and last cases are invisible to EL2. For the second case,
> why should we go back to EL1 rather than injecting an UNDEF directly?

In hindsight, my approach to constructing this table was not the right
one. I took the one for EL1, and filtered it based on the trapping
bits. So yes, you are right that I need to re-examine this table with
that in mind.

Thanks,
/fuad

> > +
> > +     /* Scalable Vector Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_TTBR0_EL1),
> > +     HOST_HANDLED(SYS_TTBR1_EL1),
> > +     HOST_HANDLED(SYS_TCR_EL1),
>
> None of these should normally trap unless we are handling an erratum
> (such as Cavium 219) or that we have HCR_EL2.TVM set. The former is
> handled at EL2, and I don't expect any Set/Way emulation to require
> the latter.
>
> > +
> > +     HOST_HANDLED(SYS_APIAKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APIAKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APIBKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APIBKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APDAKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APDAKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APDBKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APDBKEYHI_EL1),
> > +     HOST_HANDLED(SYS_APGAKEYLO_EL1),
> > +     HOST_HANDLED(SYS_APGAKEYHI_EL1),
>
> This is debatable too. If the guest has started using PtrAuth and that
> we haven't handled things in fixup_guest_exit(), why returning to the
> host? This should directly UNDEF.
>
> > +
> > +     HOST_HANDLED(SYS_AFSR0_EL1),
> > +     HOST_HANDLED(SYS_AFSR1_EL1),
> > +     HOST_HANDLED(SYS_ESR_EL1),
>
> Same as TTBR*/TCR.
>
> > +
> > +     HOST_HANDLED(SYS_ERRIDR_EL1),
> > +     HOST_HANDLED(SYS_ERRSELR_EL1),
> > +     HOST_HANDLED(SYS_ERXFR_EL1),
> > +     HOST_HANDLED(SYS_ERXCTLR_EL1),
> > +     HOST_HANDLED(SYS_ERXSTATUS_EL1),
> > +     HOST_HANDLED(SYS_ERXADDR_EL1),
> > +     HOST_HANDLED(SYS_ERXMISC0_EL1),
> > +     HOST_HANDLED(SYS_ERXMISC1_EL1),
>
> This really should be handled as RAZ/WI at EL2.
>
> > +
> > +     HOST_HANDLED(SYS_TFSR_EL1),
> > +     HOST_HANDLED(SYS_TFSRE0_EL1),
>
> Same as RCSR/GSR.
>
> > +
> > +     HOST_HANDLED(SYS_FAR_EL1),
>
> Same as TTBR
>
> > +     HOST_HANDLED(SYS_PAR_EL1),
>
> Does not trap in the absence of FGT (which we don't use yet).
>
> > +
> > +     /* Performance Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_MAIR_EL1),
> > +     HOST_HANDLED(SYS_AMAIR_EL1),
>
> Same as TTBR.
>
> > +
> > +     /* Limited Ordering Regions Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_VBAR_EL1),
>
> Doesn't trap in the absence of FGT.
>
> > +     HOST_HANDLED(SYS_DISR_EL1),
>
> If RAS exists, a DISR_EL1 access is routed to VDISR_EL2. If RAS isn't
> present, this UNDEFs. In any case, there is no trap.
>
> > +
> > +     /* GIC CPU Interface registers are restricted. */
>
> Err... Does this include ICC_SGI*R_EL1/ICC_SRE_EL1? Not going to work
> if you don't let EL1 dealing with this.
>
> > +
> > +     HOST_HANDLED(SYS_CONTEXTIDR_EL1),
>
> Same as TTBR.
>
> > +     HOST_HANDLED(SYS_TPIDR_EL1),
>
> Doesn't trap in the absence of FGT.
>
> > +
> > +     HOST_HANDLED(SYS_SCXTNUM_EL1),
>
> Should UNDEF at EL2 until we actually enable FEAT_CSV2_2.
>
> > +
> > +     HOST_HANDLED(SYS_CNTKCTL_EL1),
>
> Never traps.
>
> > +
> > +     HOST_HANDLED(SYS_CCSIDR_EL1),
> > +     HOST_HANDLED(SYS_CLIDR_EL1),
> > +     HOST_HANDLED(SYS_CSSELR_EL1),
> > +     HOST_HANDLED(SYS_CTR_EL0),
>
> Eventually, we should expose a synthetic version of these at EL2.
>
> > +
> > +     /* Performance Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_TPIDR_EL0),
> > +     HOST_HANDLED(SYS_TPIDRRO_EL0),
>
> Do not trap in the absence of FGT.
>
> > +
> > +     HOST_HANDLED(SYS_SCXTNUM_EL0),
>
> Should UNDEF at EL2 until we actually enable FEAT_CSV2_2.
>
> > +
> > +     /* Activity Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_CNTP_TVAL_EL0),
> > +     HOST_HANDLED(SYS_CNTP_CTL_EL0),
> > +     HOST_HANDLED(SYS_CNTP_CVAL_EL0),
> > +
> > +     /* Performance Monitoring Registers are restricted. */
> > +
> > +     HOST_HANDLED(SYS_DACR32_EL2),
> > +     HOST_HANDLED(SYS_IFSR32_EL2),
> > +     HOST_HANDLED(SYS_FPEXC32_EL2),
>
> I don't understand the presence of these registers here. As the name
> indicates, they are 32bit only.
>
> We need a complete overhaul of this table. I'm going to go through the
> rest of the patches, and we can then fix this.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
