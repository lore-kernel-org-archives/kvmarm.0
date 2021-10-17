Return-Path: <SRS0=PgOR=PF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D5AC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 00:43:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77F0660F8F
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 00:43:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 77F0660F8F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE89B4B168;
	Sat, 16 Oct 2021 20:43:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xq1hWexKzbJU; Sat, 16 Oct 2021 20:43:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2F734B133;
	Sat, 16 Oct 2021 20:43:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22F814B0C2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 20:43:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ro4OT9N5vFI0 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Oct 2021 20:43:16 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CED3E4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 20:43:16 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 ez7-20020a17090ae14700b001a132a1679bso2140170pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 17:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=IiOWGy8tMQRLpDn+eCyybilmmSR1ckxWs2pDq5ZT9Ik=;
 b=J5xRJ0dTlgDAo6yty9GlaenUpAjwcXiT5oAi/nRczSdBoQ1YfioXV8pJzIE1inx+R1
 bnAdW7YP3yQYbSpaM7oITWrY8xWWOZXlo2JDfOIxmNm82FYWUga28yAjcyqsPbD9nuGA
 zoguHRuJCrjfiz2INl3V0sOonzQoOg5LBF3nGQNraadXGRufsogZvhLfKKHsh1860x4M
 ukAvDjoqL/ygxmozeQkX67z8BAlu3aiKQrgUF+YvX/wQ/nQDV59tKkBKtolmcO2d4Ex5
 4ZtILO5dr+NF/7f3wt/ML06pi4Qhg/NyNN6kgixBQPpG1AUHu0GJcCvSVQCA6LdsgxiC
 +/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=IiOWGy8tMQRLpDn+eCyybilmmSR1ckxWs2pDq5ZT9Ik=;
 b=pYMGjXzZFuIUGtWFEuJMvNZatQARMcxlhS71geTfPZjxNqxGdzCJ0TXY1EzyHWgdTi
 DqohocYECvDMEwfcNk1n5CGaTM8kIu4RUnng60W//MXmkzOktAcgq3QQMFACAB29TsbQ
 o6+y3y671NakHowQOTs03a1n1JguRNw5uJuBX+Gfh780tVKb33+CzZBusHSswMnrD2si
 HlDCIaEmfY/OR4Ai+6ZTsF4wqwoJWR+7NJvkdm6B4irF2zPZBYh92pZ3q5PN3WrmpYGv
 eiSX3gS/OJnHIFcS66QNlDgx3KDQFzH1FrYZYpxiII+MsTVFjqmACgniAhY/tSeHmAep
 ukJg==
X-Gm-Message-State: AOAM5300QdJUdd+geyPkt1qj/aa2PvNGihSpvLDsijWoq0n0E1x1Qerp
 DPn3f+z6vgNm1mD+x497D4I3/NcAhckZvNy4yokQ6w==
X-Google-Smtp-Source: ABdhPJy3v+acwe/IavlDvDOFJQAd8YtLrwYt9/b1dEsWw7zjJKe6J06bBCxOm0YQ7+Br5VTgSCTFV1eWn36o+7szWcc=
X-Received: by 2002:a17:902:c402:b0:13f:1c07:5a25 with SMTP id
 k2-20020a170902c40200b0013f1c075a25mr18688367plk.38.1634431395551; Sat, 16
 Oct 2021 17:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-3-reijiw@google.com>
 <20211015130918.ezlygga73doepbw6@gator>
In-Reply-To: <20211015130918.ezlygga73doepbw6@gator>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 16 Oct 2021 17:42:59 -0700
Message-ID: <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value
 per vCPU
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Oct 15, 2021 at 6:09 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Oct 11, 2021 at 09:35:12PM -0700, Reiji Watanabe wrote:
> > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > registers' sanitized value in the array for the vCPU at the first
> > vCPU reset. Use the saved ones when ID registers are read by
> > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> >  arch/arm64/kvm/sys_regs.c         | 26 ++++++++++++++++++--------
> >  2 files changed, 28 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 9b5e7a3b6011..0cd351099adf 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
> >       u64 disr_el1;           /* Deferred [SError] Status Register */
> >  };
> >
> > +/*
> > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > + * where 0<=crm<8, 0<=op2<8.
>
> crm is 4 bits, so this should be 0 <= crm < 16 and...
>
> > + */
> > +#define KVM_ARM_ID_REG_MAX_NUM 64
>
> ...this should be 128. Or am I missing something?

Registers with (3, 0, 0, 0<=crm<8, op2) are defined/allocated including
reserved (RAZ) ones (please see Table D12-2 in ARM DDI 0487G.b),
and the code supports those only for now.

I understand that registers with crm >= 8 could be defined in the future
(I'm not so sure if they will be really ID registers though),
but then we can include them later as needed.

> > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > +
> >  enum vcpu_sysreg {
> >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > @@ -209,6 +217,8 @@ enum vcpu_sysreg {
> >       CNTP_CVAL_EL0,
> >       CNTP_CTL_EL0,
> >
> > +     ID_REG_BASE,
> > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> >       /* Memory Tagging Extension registers */
> >       RGSR_EL1,       /* Random Allocation Tag Seed Register */
> >       GCR_EL1,        /* Tag Control Register */
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1d46e185f31e..72ca518e7944 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                         struct sys_reg_params *p,
> >                         const struct sys_reg_desc *r)
> >  {
> > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
> >       u32 sr = reg_to_encoding(r);
> >
> >       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > @@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >               struct sys_reg_desc const *r, bool raz)
> >  {
> >       u32 id = reg_to_encoding(r);
> > -     u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> > +     u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> >
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> >       return REG_HIDDEN;
> >  }
> >
> > +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
>
> Since not all ID registers will use this, then maybe name it
> reset_sanitised_id_reg?

Thank you for the suggestion.

I named it 'reset_id_reg' according to the naming conventions of
set_id_reg, get_id_reg, and access_id_reg which are used for the same
set of ID registers (ID_SANITISED ones) as reset_id_reg.
I would think it's better to use consistent names for all of them.
So, I am a bit reluctant to change only the name of reset_id_reg.

What do you think about the names of those other three functions ?


> > +{
> > +     u32 id = reg_to_encoding(rd);
> > +
> > +     if (vcpu_has_reset_once(vcpu))
> > +             return;
>
> Ah, I see my kvm_vcpu_initialized() won't work since vcpu->arch.target is
> set before the first reset. While vcpu->arch.target is only being used
> like a "is_initialized" boolean at this time, I guess we better keep it
> in case we ever want to implement CPU models (which this series gets us a
> step closer to).

Thank you for sharing your thoughts and I agree with you.


> > +
> > +     __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> > +}
> > +
> >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >                              const struct sys_reg_desc *rd,
> >                              const struct kvm_one_reg *reg, void __user *uaddr)
> > @@ -1219,9 +1228,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > - * For now, these registers are immutable for userspace, so no values
> > - * are stored, and for set_id_reg() we don't allow the effective value
> > - * to be changed.
> > + * We don't allow the effective value to be changed.
> >   */
> >  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >                       const struct sys_reg_desc *rd, void __user *uaddr,
> > @@ -1375,6 +1382,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
> >  #define ID_SANITISED(name) {                 \
> >       SYS_DESC(SYS_##name),                   \
> >       .access = access_id_reg,                \
> > +     .reset  = reset_id_reg,                 \
> >       .get_user = get_id_reg,                 \
> >       .set_user = set_id_reg,                 \
> >       .visibility = id_visibility,            \
> > @@ -1830,8 +1838,10 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >       if (p->is_write) {
> >               return ignore_write(vcpu, p);
> >       } else {
> > -             u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -             u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +             u64 dfr = __vcpu_sys_reg(vcpu,
> > +                                      IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
> > +             u64 pfr = __vcpu_sys_reg(vcpu,
> > +                                      IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));
>
> Please avoid these ugly line breaks when we're well under Linux's max
> length, which is 100.

Yes, I will fix them (as well as all other similar line breaks
for other patches in my series).

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
