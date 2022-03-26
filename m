Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3754C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 26 Mar 2022 02:36:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5248E4B116;
	Fri, 25 Mar 2022 22:36:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F9tmvA6RWPI9; Fri, 25 Mar 2022 22:35:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 352D84B131;
	Fri, 25 Mar 2022 22:35:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A6C84B09C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 22:35:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p6rD6CiJKvdn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 22:35:56 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D9F34B131
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 22:35:56 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 mj15-20020a17090b368f00b001c637aa358eso13889340pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 19:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=NUY1wg4evhKaQGByM6d8SxocfJxkAaaILI7ZScN9kP0=;
 b=N0E4+4JwvqtgxjjrlkKtHyw3eECXc+FlnXH6m3vvN1NcH4mS0PMlcLliwCgwJ/+ri3
 NiQzHCz5FG+BcAJnbfr9gfMwhBtYjkgd1yfDc47FQLjFRflaWOe1Qic6kgnypxgeCKPV
 9RGzVt6b3FhWnR0qiMtC4+3GvPmcqB/hrjinWcGuvFivwCMfGSvh4yDEqzFyYLxfSZrH
 9vpxnenX8oIJgiuL/x7n5aNRHSyKPYhFSmvkq1yhpfnhOqcpyi7qs8PGxjgrl8ewDC+F
 MJ+D1icEK53F7j+aLnUcp6KEDBiniYAiPog22s5NERRX4uYVPcl8yOsF7USgLoMfU/Hc
 FO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NUY1wg4evhKaQGByM6d8SxocfJxkAaaILI7ZScN9kP0=;
 b=fG9aVBkG3dfUCv+cYshH1+m1jrdVl+L51CnmAiOZB+hLakmZLBYfh8btUcgFHArMLQ
 8Jn05Vn7SIQ9lCW13IBXnHL3bJtPWOoq61KC6VIsiGKeHjjib+4eqlCTDVQJhPjc+NJo
 R1E/s3LmOnFFVb5xjRDU/h/+UEgK6/YMbCivGEgAkYWyHH1R+NL/NZ7pxX2Ruu5b+yMh
 +HDBVIgOVcIGuI97CCEg03I+ecB2ACAMr472PmjLxP26YZlNRDrRcBLfTiagLAmhkB0O
 Pc2OVSry4gh21UgbcZIda5tY23uhJkTqH/MvFT04wOaxoH50EiWsP8psoKIOuUgqKK5/
 LV2A==
X-Gm-Message-State: AOAM531Uys9WVBwAEoc+kTd9CCCki1ag5ghvQldrvrmrnafRXEdFkHad
 QE+qg9fTZjCgXZ4Au+NFzbymsbcNdx+Jsd6kr0wCLQ==
X-Google-Smtp-Source: ABdhPJyLILWFARa9ecDWFgbUjLgj8SnpKU6JSTSw6I7oIEXSWaHNQR4oQ0R5ChNlG/u8ieDTUMKNG57lNdTMwXVAAXA=
X-Received: by 2002:a17:902:b403:b0:153:62bb:c4b7 with SMTP id
 x3-20020a170902b40300b0015362bbc4b7mr14660873plr.138.1648262155360; Fri, 25
 Mar 2022 19:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com>
 <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
 <YjywaFuHp8DL7Q9T@google.com>
In-Reply-To: <YjywaFuHp8DL7Q9T@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 25 Mar 2022 19:35:39 -0700
Message-ID: <CAAeT=FwkSUb59Uc35CJgerJdBM5ZCUExNnz2Zs2oHFLn0Jjbsg@mail.gmail.com>
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

> > > > + */
> > > > +#define KVM_ARM_ID_REG_MAX_NUM   64
> > > > +#define IDREG_IDX(id)            ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > > +
> > > >   struct kvm_arch {
> > > >           struct kvm_s2_mmu mmu;
> > > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > > >           /* Memory Tagging Extension enabled for the guest */
> > > >           bool mte_enabled;
> > > >           bool ran_once;
> > > > +
> > > > + /* ID registers for the guest. */
> > > > + u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > >
> > > This is a decently large array. Should we embed it in kvm_arch or
> > > allocate at init?
> >
> >
> > What is the reason why you think you might want to allocate it at init ?
>
> Well, its a 512 byte array of mostly cold data. We're probably
> convinced that the guest is going to access these registers at most once
> per vCPU at boot.
>
> For the vCPU context at least, we only allocate space for registers we
> actually care about (enum vcpu_sysreg). My impression of the feature
> register ranges is that there are a lot of registers which are RAZ, so I
> don't believe we need to make room for uninteresting values.
>
> Additionally, struct kvm is visible to EL2 if running nVHE. I
> don't believe hyp will ever need to look at these register values.

As saving/restoring breakpoint/watchpoint registers for guests
might need a special handling when AA64DFR0_EL1.BRPs get changed,
next version of the series will use the data in the array at
EL2 nVHE.  They are cold data, and almost half of the entries
will be RAZ at the moment though:)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
