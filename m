Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7AAC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 22:00:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E18CA61AA2
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 22:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E18CA61AA2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53FCC4B25E;
	Thu, 18 Nov 2021 17:00:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qr4A6BZ83wpd; Thu, 18 Nov 2021 17:00:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC54E4B248;
	Thu, 18 Nov 2021 17:00:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 850344B1F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 17:00:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5qBRr2ebBoa7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 17:00:20 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B25B24B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 17:00:20 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id g28so6704699pgg.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 14:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EpdJi3HYgLc5zwKM/z1Fkk+LrQE+K6mTNDKahwPRN+Q=;
 b=akQ9hotq/NIJFU7aF5TgnIKJNyCnEcDMpW5ZtN6EzU8z9873Ze+lsfJAepUwTdRkPm
 QVtg3sfjkzqWMCtitRktzbgzCpnEzTHNWAluqme/o+QYJpgcK+5UCQVcOHX77mEX8ZFA
 hrzCME8n3ul8ykXPDoTLJjnbWfsjxVjwQizOYDNhN4p9acchsHk4xxntouONdNg1NBhR
 ExQT2cAlzF6RaGaGyKrG1XYK1RjDU+PKeF4DYCc4nHiaqT4ngsdBHTPrLfAyJZjA8Bbb
 pT5UpJ7bUSEShC6Yn0o/YosxpFZ1kGhV2jKyzlp7er1mWeXXFFmiZxBkPQeQyEim3K17
 /uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EpdJi3HYgLc5zwKM/z1Fkk+LrQE+K6mTNDKahwPRN+Q=;
 b=HBfUluT05o4dR6UjQacKjxghOOPjW7tuk5F4fP5gOCTAEryHMK5J40q0Bdw42ZzzrX
 gRuwPJE+d+hMYS76l4sQZEry+fZxDMEX/RPD70OZTsRY9G2Mai5XlIGnEm2/SZzftfE5
 qd4CT5W/HWiNwrMNFcX9Xy1LZNtM5V7zmOReAQdHwRQttv0y+GehZdrYu4MJRRHc87au
 8bl3Dvy/WOpJaMfwfozvdrp7nqQWgIpwkVad3ihNm4kq2G1QLhwVro/LoPlLiGvkt2zZ
 LyhlTZL+U5MRv0YxSXxhFl6xAY6Gv8cj4MEPkYL1eFDSXVZZ01vuw4QJNFh3YDdDO4im
 lEyw==
X-Gm-Message-State: AOAM530mBhqZg7Aoy0MDU+lflmERcnc7EaMy2NlMIItn3oOQUP9OrUao
 VhxN1kZWVd7LQdKhV3OiKw6M8XgQu583iqWP3i/R5w==
X-Google-Smtp-Source: ABdhPJzL2sawh7KxRB9k5qoNwKnO6wsjrcsjdgXf7XIV8VeKfPMFfbCAThDnxgeJ16+XkOhTt+8FzOqG77GQGJZPL3c=
X-Received: by 2002:a63:c158:: with SMTP id p24mr13526679pgi.53.1637272819548; 
 Thu, 18 Nov 2021 14:00:19 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-3-reijiw@google.com>
 <dad16d0f-a0fa-cd8e-fdd0-0bbdf38af791@redhat.com>
In-Reply-To: <dad16d0f-a0fa-cd8e-fdd0-0bbdf38af791@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 18 Nov 2021 14:00:03 -0800
Message-ID: <CAAeT=FyUjwJDLw=6u_ocgQ_974+vD4w0n2=WCYXLsH4cf+dxOw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Eric Auger <eauger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Eric,

On Thu, Nov 18, 2021 at 12:37 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > registers' sanitized value in the array for the vCPU at the first
> > vCPU reset. Use the saved ones when ID registers are read by
> > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 10 +++++++
> >  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
> >  2 files changed, 37 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index edbe2cb21947..72db73c79403 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
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
> > @@ -210,6 +218,8 @@ enum vcpu_sysreg {
> >       CNTP_CVAL_EL0,
> >       CNTP_CTL_EL0,
> >
> > +     ID_REG_BASE,
> > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> >       /* Memory Tagging Extension registers */
> >       RGSR_EL1,       /* Random Allocation Tag Seed Register */
> >       GCR_EL1,        /* Tag Control Register */
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index e3ec1a44f94d..5608d3410660 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -33,6 +33,8 @@
> >
> >  #include "trace.h"
> >
> > +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> > +
> >  /*
> >   * All of this file is extremely similar to the ARM coproc.c, but the
> >   * types are different. My gut feeling is that it should be pretty
> > @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                         struct sys_reg_params *p,
> >                         const struct sys_reg_desc *r)
> >  {
> > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +     u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >       u32 sr = reg_to_encoding(r);
> >
> >       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > -             struct sys_reg_desc const *r, bool raz)
> > +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> > -     u32 id = reg_to_encoding(r);
> > -     u64 val;
> > -
> > -     if (raz)
> > -             return 0;
> > -
> > -     val = read_sanitised_ftr_reg(id);
> > +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> >
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >       return val;
> >  }
> >
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > +                    struct sys_reg_desc const *r, bool raz)
> > +{
> > +     u32 id = reg_to_encoding(r);
> > +
> > +     return raz ? 0 : __read_id_reg(vcpu, id);
> > +}
> > +
> >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >                                 const struct sys_reg_desc *r)
> >  {
> > @@ -1178,6 +1180,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
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
> > @@ -1223,9 +1235,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > - * For now, these registers are immutable for userspace, so no values
> > - * are stored, and for set_id_reg() we don't allow the effective value
> > - * to be changed.
> > + * We don't allow the effective value to be changed.
> This change may be moved to a subsequent patch as this patch does not
> change the behavior yet.

Thank you for the review.

There are three main parts in the original comments.

 (A) these registers are immutable for userspace
 (B) no values are stored
 (C) we don't allow the effective value to be changed

This patch stores ID register values in sys_regs[].
So, I don't think (B) should be there, and I removed (B).
Since (A) is essentially the same as (C), I removed (A)
(and left (C)).

Do you think it is better to leave (A) in this patch, too ?

Thanks,
Reiji


> >   */
> >  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >                       const struct sys_reg_desc *rd, void __user *uaddr,
> > @@ -1382,6 +1392,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
> >  #define ID_SANITISED(name) {                 \
> >       SYS_DESC(SYS_##name),                   \
> >       .access = access_id_reg,                \
> > +     .reset  = reset_id_reg,                 \
> >       .get_user = get_id_reg,                 \
> >       .set_user = set_id_reg,                 \
> >       .visibility = id_visibility,            \
> > @@ -1837,8 +1848,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >       if (p->is_write) {
> >               return ignore_write(vcpu, p);
> >       } else {
> > -             u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -             u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +             u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> > +             u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
> >               u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
> >
> >               p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> >
> Thanks
>
> Eric
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
