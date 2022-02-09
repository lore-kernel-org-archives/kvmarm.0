Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0AAC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Feb 2022 02:26:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F9EF49EE2;
	Tue,  8 Feb 2022 21:26:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8pLLFBAhIo+0; Tue,  8 Feb 2022 21:26:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B1749ED7;
	Tue,  8 Feb 2022 21:26:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2395D40BD6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 21:26:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iSyX9VRWTsPh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 21:26:39 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6931849EE8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 21:26:39 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id qe15so864419pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 18:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RETGvp9Tb/Fz8lE6Cy2ZeI6FXeLdHxtZ2zuXuM2JVTA=;
 b=h0ORmwwfgrYhpl2k4woJ0UJwDxVUPCJCvj99KzAWB6eamY886SElIBC7JelHmAV5Op
 EOn4cXtkpcYUT520QFUeViVAxjNmrhMWli50DvHmSVizwdMWYv+yuAntaB1IcRdwedqo
 uLp+4jmOL5dS+MiuINOOSrI0OokQiPY37RgtfL2t8WxUJcVHxVj+49SlRHp/1bsIraMs
 iPq0aGm2E2oZ85R9+VbWJfBeI8+qP6r7OZyZLseAfPF+5hKdrl0SulT1kicYESHM4W29
 ARKqwNFPMeGyJNgkfUTxJg/KUCFFuIz/wz05/DxKYTBrhTJo0nIC5DPSMOuEfIvdGaIo
 /mKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RETGvp9Tb/Fz8lE6Cy2ZeI6FXeLdHxtZ2zuXuM2JVTA=;
 b=DW9dRhoXpbtIJx43RRVt6cWlG635R+GpSY6m+FMkoiayH92O8W4ANkSDIT+saMpx3O
 6pvfuOdDS5mjvPciARXnRKWgfW1w5FcSHVXCAR0VkbW9cKJ+Eh9UInpBGXJxYso/329U
 0SNdrmJGPjTtYSqXALyY17AMofkHBYCaQ/t0liTAy+fD7Z1v9TwmBfGFtJ7gE7RLAEPS
 ie+tlVyzdHVhY07V+IFbukSfahdNSeupA8D5Nb9fJAflOGAHAMN4KBYCoAxiICZYLz+d
 HVQcviNlacSGzyY/KcL7SMS83u4qadlMABUCOGX0KZ4yzWLxSqX3zV8Yk0oI5Js4r6k1
 Gtow==
X-Gm-Message-State: AOAM533e+5h4RuSPcfnteA9sFVUEp3UyUz6OSRT1V94u5yfFgNUTWuKz
 xPWul7zO+k/n4pv1pMW3SuMuR7TDkq2G+tl3hMYe1w==
X-Google-Smtp-Source: ABdhPJzSlAUxv013+i3iF7UhDBr6xMrmqztdd1yDabdyguJJHcuzAwZQNttg/w0jY29TPb8/0IsD2MTC7JdUisUWmcg=
X-Received: by 2002:a17:90b:3c6:: with SMTP id
 go6mr1007670pjb.230.1644373598101; 
 Tue, 08 Feb 2022 18:26:38 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <CA+EHjTxVe3baCwpde+QFYKvyUaUGu9F37t-=r8k32JcHBOY61Q@mail.gmail.com>
In-Reply-To: <CA+EHjTxVe3baCwpde+QFYKvyUaUGu9F37t-=r8k32JcHBOY61Q@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 8 Feb 2022 18:26:21 -0800
Message-ID: <CAAeT=FxTUSsDA9WUBWGDwF563JSJpguM-fumab6aQdToy2sUfA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
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

Sorry for the late reply.
I've noticed that I didn't reply to the comments in this mail.

On Mon, Jan 24, 2022 at 8:22 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:28 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > Use the saved ones when ID registers are read by the guest or
> > userspace (via KVM_GET_ONE_REG).
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 16 ++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/sys_regs.c         | 62 ++++++++++++++++++++++---------
> >  3 files changed, 62 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 2a5f7f38006f..c789a0137f58 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -102,6 +102,17 @@ struct kvm_s2_mmu {
> >  struct kvm_arch_memory_slot {
> >  };
> >
> > +/*
> > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > + * where 0<=crm<8, 0<=op2<8.
> > + */
> > +#define KVM_ARM_ID_REG_MAX_NUM 64
> > +#define IDREG_IDX(id)          ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > +#define is_id_reg(id)  \
> > +       (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&        \
> > +        sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&        \
> > +        sys_reg_CRm(id) < 8)
> > +
>
> This is consistent with the Arm ARM "Table D12-2 System instruction
> encodings for non-Debug System register accesses".
>
> Minor nit, would it be better to have IDREG_IDX and is_id_reg in
> arch/arm64/kvm/sys_regs.h, since other similar and related ones are
> there?

I will move is_id_reg in sys_regs.c as it is used only in the file.
I will keep IDREG_IDX in arch/arm64/kvm/sys_regs.h as IDREG_IDX is
used to get an index of kvm_arch.id_regs[], which is defined in
kvm_host.h.

>
> >  struct kvm_arch {
> >         struct kvm_s2_mmu mmu;
> >
> > @@ -137,6 +148,9 @@ struct kvm_arch {
> >
> >         /* Memory Tagging Extension enabled for the guest */
> >         bool mte_enabled;
> > +
> > +       /* ID registers for the guest. */
> > +       u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > @@ -734,6 +748,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                                 struct kvm_arm_copy_mte_tags *copy_tags);
> >
> > +void set_default_id_regs(struct kvm *kvm);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e4727dc771bf..5f497a0af254 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >         kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
> >
> >         set_default_spectre(kvm);
> > +       set_default_id_regs(kvm);
> >
> >         return ret;
> >  out_free_stage2_pgd:
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index e3ec1a44f94d..80dc62f98ef0 100644
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
> >                           struct sys_reg_params *p,
> >                           const struct sys_reg_desc *r)
> >  {
> > -       u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +       u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >         u32 sr = reg_to_encoding(r);
> >
> >         if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >         return true;
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > -               struct sys_reg_desc const *r, bool raz)
> > +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> > -       u32 id = reg_to_encoding(r);
> > -       u64 val;
> > -
> > -       if (raz)
> > -               return 0;
> > -
> > -       val = read_sanitised_ftr_reg(id);
> > +       u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
> >
> >         switch (id) {
> >         case SYS_ID_AA64PFR0_EL1:
> > @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >         return val;
> >  }
> >
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > +                      struct sys_reg_desc const *r, bool raz)
> > +{
> > +       u32 id = reg_to_encoding(r);
> > +
> > +       return raz ? 0 : __read_id_reg(vcpu, id);
> > +}
> > +
> >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >                                   const struct sys_reg_desc *r)
> >  {
> > @@ -1223,9 +1225,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > - * For now, these registers are immutable for userspace, so no values
> > - * are stored, and for set_id_reg() we don't allow the effective value
> > - * to be changed.
> > + * For now, these registers are immutable for userspace, so for set_id_reg()
> > + * we don't allow the effective value to be changed.
> >   */
> >  static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >                         const struct sys_reg_desc *rd, void __user *uaddr,
> > @@ -1237,7 +1238,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
> >         return reg_to_user(uaddr, &val, id);
> >  }
> >
> > -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > +static int __set_id_reg(struct kvm_vcpu *vcpu,
> >                         const struct sys_reg_desc *rd, void __user *uaddr,
> >                         bool raz)
>
> Minor nit: why remove the const in this patch? This is required for a
> future patch but not for this one.

Thank you for catching this. I will fix this.

Regards,
Reiji

>
>
> >  {
> > @@ -1837,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >         if (p->is_write) {
> >                 return ignore_write(vcpu, p);
> >         } else {
> > -               u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -               u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +               u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> > +               u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
> >                 u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
> >
> >                 p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> > @@ -2850,3 +2851,30 @@ void kvm_sys_reg_table_init(void)
> >         /* Clear all higher bits. */
> >         cache_levels &= (1 << (i*3))-1;
> >  }
> > +
> > +/*
> > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > + * with ID_SANITISED() to the host's sanitized value.
> > + */
> > +void set_default_id_regs(struct kvm *kvm)
> > +{
> > +       int i;
> > +       u32 id;
> > +       const struct sys_reg_desc *rd;
> > +       u64 val;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > +               rd = &sys_reg_descs[i];
> > +               if (rd->access != access_id_reg)
> > +                       /* Not ID register, or hidden/reserved ID register */
> > +                       continue;
> > +
> > +               id = reg_to_encoding(rd);
> > +               if (WARN_ON_ONCE(!is_id_reg(id)))
> > +                       /* Shouldn't happen */
> > +                       continue;
> > +
> > +               val = read_sanitised_ftr_reg(id);
> > +               kvm->arch.id_regs[IDREG_IDX(id)] = val;
> > +       }
> > +}
> > --
> > 2.34.1.448.ga2b2bfdf31-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
