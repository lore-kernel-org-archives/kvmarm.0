Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6EBC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 28 Mar 2022 00:05:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8C814B1AD;
	Sun, 27 Mar 2022 20:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hiGnTOfM4YyT; Sun, 27 Mar 2022 20:05:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A63894B1C6;
	Sun, 27 Mar 2022 20:05:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A051B4B1C4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Mar 2022 20:05:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GAolZfT2juJk for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Mar 2022 20:05:15 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39B474B1C3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Mar 2022 20:05:15 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id s8so11059730pfk.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Mar 2022 17:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GYMVP9OcKppCPlsPpjFdXuvj9GQOHfrmZVMxuBWQMzk=;
 b=UOxWHJfBVxArY0VLUCwJyQc28fwR60rMZ4S+d0rgbgXS8D5RnDbQxQifCxLtrWaUZL
 LPsY+nIUBjj1pwA4aT1IfEo0kpUTAV71v6UD7tyqMfI2mdSP430LpN0Mdg8q1MmjLXZm
 PT9iJZ97vc3dSx+sPU4oiMZM9puvMkPNisQlEXPIdWT/Md56HM/GMkWSgrodvzVABY4P
 //zREGepFUdm6gc8H7E/4hy3AALqUb0ODCSwTDuSI4nxpOhtbh1ZvqoFmXc57z1/yHSr
 Izsg88jeaspt87mMJHfYs6PgQHuC2XcH4Iq/6/CN47YfXCteVZW5jFi3zzeS1TfjiUwh
 58Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GYMVP9OcKppCPlsPpjFdXuvj9GQOHfrmZVMxuBWQMzk=;
 b=y6XdZxfVNsKF+MAYXom5f+iSWYMiu3Metod9SIYtG6YqGQ4+JiNWNWTlK2/9gU1UMG
 X553+HBn50E1HJ6KiBRXqCvZkRF/VsBIK8son+UNInctSs8tHQzHpmorXKoAc6Qy4rAC
 jouLYt1yW8UOSBB0m67AFwCqc9j0LQyhiKShiqTyuhrQKOhFqqACqY3a5LPeDW76aj40
 EFl7CLa8cltnQNwwTS+CKuUKUKTHXuBXQt0eoV6iEBGzYxLDtI1K062zQtnsGn8Ita0y
 HVyHnsVDrp+tL88G20tHr48Z/Oll8Ceo01ak++0liIPCXhm+7JoENt0aidg+W5RLAPt0
 o5zA==
X-Gm-Message-State: AOAM533O/XltIFr1pqARzHIyG4Gcd91NtnMBj5Mk5od75xMTtD8vRTg5
 BPKgCFRa5tkkiEpPim+lMZ/yMLLAOF2fKxliFrNq6qoD1QlJpw0O
X-Google-Smtp-Source: ABdhPJyBQuYuCqeNZAOxA+BktTbh+7vcK4unm4ItMQkMKvp6ipwld2A4FhAXXvvhUrz3D9PIsaWPX7c9ospx8G7/m9M=
X-Received: by 2002:a05:6a00:26cf:b0:4f6:fc52:7b6a with SMTP id
 p15-20020a056a0026cf00b004f6fc527b6amr20736309pfw.39.1648425914133; Sun, 27
 Mar 2022 17:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com>
 <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
 <YjywaFuHp8DL7Q9T@google.com>
 <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
 <YkDrv2JdZhVFnGMk@google.com>
In-Reply-To: <YkDrv2JdZhVFnGMk@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 27 Mar 2022 17:04:58 -0700
Message-ID: <CAAeT=Fx8d9aWr1DFJ2N0n9KUs3z3PaGmFVbkcYRSkt7=H19hog@mail.gmail.com>
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver,

On Sun, Mar 27, 2022 at 3:57 PM Oliver Upton <oupton@google.com> wrote:
>
> On Fri, Mar 25, 2022 at 07:35:39PM -0700, Reiji Watanabe wrote:
> > Hi Oliver,
> >
> > > > > > + */
> > > > > > +#define KVM_ARM_ID_REG_MAX_NUM   64
> > > > > > +#define IDREG_IDX(id)            ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > > > +
> > > > > >   struct kvm_arch {
> > > > > >           struct kvm_s2_mmu mmu;
> > > > > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > > > > >           /* Memory Tagging Extension enabled for the guest */
> > > > > >           bool mte_enabled;
> > > > > >           bool ran_once;
> > > > > > +
> > > > > > + /* ID registers for the guest. */
> > > > > > + u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > > > >
> > > > > This is a decently large array. Should we embed it in kvm_arch or
> > > > > allocate at init?
> > > >
> > > >
> > > > What is the reason why you think you might want to allocate it at init ?
> > >
> > > Well, its a 512 byte array of mostly cold data. We're probably
> > > convinced that the guest is going to access these registers at most once
> > > per vCPU at boot.
> > >
> > > For the vCPU context at least, we only allocate space for registers we
> > > actually care about (enum vcpu_sysreg). My impression of the feature
> > > register ranges is that there are a lot of registers which are RAZ, so I
> > > don't believe we need to make room for uninteresting values.
> > >
> > > Additionally, struct kvm is visible to EL2 if running nVHE. I
> > > don't believe hyp will ever need to look at these register values.
> >
> > As saving/restoring breakpoint/watchpoint registers for guests
> > might need a special handling when AA64DFR0_EL1.BRPs get changed,
> > next version of the series will use the data in the array at
> > EL2 nVHE.  They are cold data, and almost half of the entries
> > will be RAZ at the moment though:)
>
> Shouldn't we always be doing a full context switch based on what
> registers are present in hardware? We probably don't want to leave host
> watchpoints/breakpoints visible to the guest.

Correct, any host breakpoints/watchpoints won't be exposed to the guest.
(When restoring breakpoints/watchpoints for the guest, physical
 breakpoints that are not mapped to any virtual ones will be cleared)


> Additionally, if we are narrowing the guest's view of the debug
> hardware, are we going to need to start trapping debug register
> accesses? Unexposed breakpoint registers are supposed to UNDEF if we
> obey the Arm ARM to the letter. Even if we decide to not care about
> unexposed regs, I believe certain combinations of ID_AA64DF0_EL1.{BRPs,
> CTX_CMPs} might require that we emulate.

Exactly, we will need to start trapping debug registers when the special
handling is needed, and yes, we will need a special handling when the
guest accesses to invalid virtual breakpoints/watchpoints or use the
invalid virtual breakpoints as linked breakpoints.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
