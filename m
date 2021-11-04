Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE61BC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 21:39:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B57461215
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 21:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B57461215
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A963F4B0ED;
	Thu,  4 Nov 2021 17:39:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i71wOOHC0oSM; Thu,  4 Nov 2021 17:39:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D13FF4B10A;
	Thu,  4 Nov 2021 17:39:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8472F4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 17:39:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 43skvz7AMfZJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 17:39:26 -0400 (EDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C3684B0E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 17:39:26 -0400 (EDT)
Received: by mail-pf1-f173.google.com with SMTP id h74so7117384pfe.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 14:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dtf9b8fplgaOJMDpqNO6Cstehs/ZY/hIOYdlwAKvCrM=;
 b=ZWTXThxYXJwS5ahQFyDJ6XewypWlRj+SKTfV5jmHGMk46XvkayjLj+5TCI0zlO8Rx0
 Fd1mm3cuoNFZh+dLhdJPzwI/KVzRs5ICFWvDN+O/r9JbZ2+FaktZ1muw6HN4INkdvtt7
 QSndc/9bpN0/ZK81C4RX7yV3Lvpl5YpwMr6f1ZJ1bPZfWUyrTIo4YT4iaiSY3N700eGc
 bVSrsihwraskjIXpbBplk531gJ8NDvUXgJlF0CIlUBpDv2EJLxye6DzGWyaVqJbp55FQ
 Y2yoM7N5S1HFecwXWDWulTkX88UYWRsDSkD5MshAETWHEN0291O89I1xoISIl9tyA+Y0
 6XVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dtf9b8fplgaOJMDpqNO6Cstehs/ZY/hIOYdlwAKvCrM=;
 b=m6fpXMQkd9QKiPcnyUHqg3TT6LoXRN0mbErf8etzSkmuEVrXps6p3Q4zAeyCTdd+5c
 3oQJE/eKUTeHcow2kHyDE7VrZpBTj7EXXZWEiu7brli3ZhOt/em0Y5IzzOpMeZaQg77n
 7o7aUvE4GTUGn5vA0Z/VmWf+EKGn2EargGCSwVlUty/TreGnCgEiksM6NDg+JxAtOZ+u
 shKrdthX2ku1Nz3EhLrQDGCZYWbXWU0lVX53rGsSYSYS+7HrsS2cv2d2QIunTOVccTzm
 JinOsZI4Qwaf3JNSFyLwdJNGk1xnhV22B7kg6h16V1wMFncek1gW3EchH5UxNHVZwDVD
 a0Cw==
X-Gm-Message-State: AOAM530Bsbtv598cK8jQ9KXFDvSEZF93kYVKb2S/b/FbDCgVLQChhGYX
 TnS14PYseFDgt81cqxNpad6nhNGlblFuQU5Dd2DN3xPrKsGhMKdJ+tA=
X-Google-Smtp-Source: ABdhPJzGJ+GVm4WlWh8DMevth5qADyct+jy57f2q5Za7kf1fkEUSrsdsFZL6JiLt8CIyCOZqKz2ysHHmEx2lwhMv9Ks=
X-Received: by 2002:a63:c158:: with SMTP id p24mr9764132pgi.53.1636061965137; 
 Thu, 04 Nov 2021 14:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-3-reijiw@google.com>
 <YYQG6fxRVEsJ9w2d@google.com>
In-Reply-To: <YYQG6fxRVEsJ9w2d@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 4 Nov 2021 14:39:09 -0700
Message-ID: <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/28] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Oliver Upton <oupton@google.com>
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

Hi Oliver,

On Thu, Nov 4, 2021 at 9:14 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Tue, Nov 02, 2021 at 11:24:54PM -0700, Reiji Watanabe wrote:
> > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > registers' sanitized value in the array for the vCPU at the first
> > vCPU reset. Use the saved ones when ID registers are read by
> > userspace (via KVM_GET_ONE_REG) or the guest.
>
> Based on my understanding of the series, it appears that we require the
> CPU identity to be the same amongst all vCPUs in a VM. Is there any
> value in keeping a single copy in kvm_arch?

Yes, that's a good point.
It reminded me that the idea bothered me after we discussed a similar
case about your counter offset patches, but I didn't seriously
consider that.

Thank you for bringing this up.
I will look into keeping it per VM in kvm_arch.

Regards,
Reiji




>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> >  arch/arm64/kvm/sys_regs.c         | 24 ++++++++++++++++--------
> >  2 files changed, 26 insertions(+), 8 deletions(-)
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
> > + */
> > +#define KVM_ARM_ID_REG_MAX_NUM 64
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
> > index 1d46e185f31e..2443440720b4 100644
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
> > +{
> > +     u32 id = reg_to_encoding(rd);
> > +
> > +     if (vcpu_has_reset_once(vcpu))
> > +             return;
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
> > @@ -1830,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >       if (p->is_write) {
> >               return ignore_write(vcpu, p);
> >       } else {
> > -             u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -             u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +             u64 dfr = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
> > +             u64 pfr = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));
> >               u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
> >
> >               p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> > --
> > 2.33.1.1089.g2158813163f-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
