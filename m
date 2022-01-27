Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD3BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 07:19:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB68B4A100;
	Thu, 27 Jan 2022 02:19:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YRMuPBgv+tNY; Thu, 27 Jan 2022 02:19:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8F949F2F;
	Thu, 27 Jan 2022 02:19:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B1949F27
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:19:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 835I4pka0L4k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 02:19:34 -0500 (EST)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1606F49ED5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:19:34 -0500 (EST)
Received: by mail-pl1-f172.google.com with SMTP id b15so1760104plg.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 23:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=i2RBhTxWRPU1sfMn3Q98WcKVoFM08enITE4vRBeZ0ts=;
 b=LveWagL8Y8wBrtFmstEFsxtVqR1cOWjSmVVo65yBqhyJF2T9o8vkHeytGjWxDMvW37
 KkJOHyfSKBRPCACtT5nb96Qsz1vHII0V9f0DWvWt2JzYKfRvbEUnHh2I7QDwUwm9jHiZ
 KXJQVXMh0+LfChNfwdq3PBx/Rom3FSQdlR506AUB3hnBBsJMF5+NX0UlH5YXfzAM2ucy
 pL0MHTrMME6dXUD4DM3djF7MFuhZ8iji6n9/OCThl5QPK3nbgzvB6Yl1nszY25PERhoP
 IVWe4CjOca/AqrKAXU40l/FHxoJGkjovc6+OHakCV5075aM+G4ADSX9M/42lCQVyLomO
 VBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=i2RBhTxWRPU1sfMn3Q98WcKVoFM08enITE4vRBeZ0ts=;
 b=f1nuJHkxldTu/+673u41xNLU13l76suNCf2cqUvFnOUOAEEIXwG0gN4g0KolUVF9oF
 1guSD/BXAZ+dEglZLP75IAw2lpEVEQrYtvzElePwZ3utepvG3AKcN0RmeLE4qKsesnAi
 xJBmaO5H7o3PLtzjVQp2bgKc7iTfClxhrTOAb38f6LZ4AlUtjnDqCTodaR1kkdVrjvmo
 07OYbY3MmwPMeDME25L4LuG2cS5G0AiSfnE5xAYrNzVDTuFTxuJkG7EOQPDgXAYQiDQb
 v4LPebQuuSgpnMs2yv0i92zRbz9cluAnk3I/hefLBZuhyqhlOVEt4mPschGpWilU/2sH
 DGWw==
X-Gm-Message-State: AOAM533mGA1VVykN1GZq752ISYKRJcoT9adHr2/pfViWpTYa8v7AAwhW
 7hjPoacKPTP1Va0aXWSyBOGhws2G1oFg/kuVok26Aw==
X-Google-Smtp-Source: ABdhPJx0IH1AvG7ogKWuMzMV7o4j8Ergb4xi8pLDsEOdIkOfB6Z5ux4Yre4+FVoHvdLBt2Vo8S4SBzDXKvetgqgjFhA=
X-Received: by 2002:a17:902:bc83:: with SMTP id
 bb3mr2671934plb.172.1643267973009; 
 Wed, 26 Jan 2022 23:19:33 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-21-reijiw@google.com>
 <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
In-Reply-To: <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 26 Jan 2022 23:19:17 -0800
Message-ID: <CAAeT=Fx1pM66cQaefkBTAJ7-Y0nzjmABJrp5DiNm4_47hdEyrg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of
 ID_AA64PFR0_EL1
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Fuad,

On Mon, Jan 24, 2022 at 9:17 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add feature_config_ctrl for RAS and AMU, which are indicated in
> > ID_AA64PFR0_EL1, to program configuration registers to trap
> > guest's using those features when they are not exposed to the guest.
> >
> > Introduce trap_ras_regs() to change a behavior of guest's access to
> > the registers, which is currently raz/wi, depending on the feature's
> > availability for the guest (and inject undefined instruction
> > exception when guest's RAS register access are trapped and RAS is
> > not exposed to the guest).  In order to keep the current visibility
> > of the RAS registers from userspace (always visible), a visibility
> > function for RAS registers is not added.
> >
> > No code is added for AMU's access/visibility handler because the
> > current code already injects the exception for Guest's AMU register
> > access unconditionally because AMU is never exposed to the guest.
>
> I think it might be code to trap it anyway, in case AMU guest support
> is added in the future.

Yes, I will fix it.
(I forgot to update the comment above...)


> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 90 +++++++++++++++++++++++++++++++++++----
> >  1 file changed, 82 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 33893a501475..015d67092d5e 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -304,6 +304,63 @@ struct feature_config_ctrl {
> >         void    (*trap_activate)(struct kvm_vcpu *vcpu);
> >  };
> >
> > +enum vcpu_config_reg {
> > +       VCPU_HCR_EL2 = 1,
> > +       VCPU_MDCR_EL2,
> > +       VCPU_CPTR_EL2,
> > +};
> > +
> > +static void feature_trap_activate(struct kvm_vcpu *vcpu,
> > +                                 enum vcpu_config_reg cfg_reg,
> > +                                 u64 cfg_set, u64 cfg_clear)
> > +{
> > +       u64 *reg_ptr, reg_val;
> > +
> > +       switch (cfg_reg) {
> > +       case VCPU_HCR_EL2:
> > +               reg_ptr = &vcpu->arch.hcr_el2;
> > +               break;
> > +       case VCPU_MDCR_EL2:
> > +               reg_ptr = &vcpu->arch.mdcr_el2;
> > +               break;
> > +       case VCPU_CPTR_EL2:
> > +               reg_ptr = &vcpu->arch.cptr_el2;
> > +               break;
> > +       }
> > +
> > +       /* Clear/Set fields that are indicated by cfg_clear/cfg_set. */
> > +       reg_val = (*reg_ptr & ~cfg_clear);
> > +       reg_val |= cfg_set;
> > +       *reg_ptr = reg_val;
> > +}
> > +
> > +static void feature_ras_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TERR | HCR_TEA, HCR_FIEN);
>
> Covers all the flags for ras.
>
> > +}
> > +
> > +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);
>
> Covers the CPTR flags for AMU, but as you mentioned, does not
> explicitly clear HCR_AMVOFFEN.

In my understanding, clearing HCR_EL2.AMVOFFEN is not necessary as
CPTR_EL2.TAM == 1 traps the guest's accessing AMEVCNTR0<n>_EL0 and
AMEVCNTR1<n>_EL0 anyway (HCR_EL2.AMVOFFEN doesn't matter).
(Or is my understanding wrong ??)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
