Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA5EC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 06:12:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5AF4B173;
	Wed, 24 Nov 2021 01:12:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dZwFKRGfkEDo; Wed, 24 Nov 2021 01:12:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3C14B164;
	Wed, 24 Nov 2021 01:12:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFAD4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 01:12:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yPsNQE75G6Gy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 01:12:06 -0500 (EST)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AAB94B10E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 01:12:06 -0500 (EST)
Received: by mail-pf1-f170.google.com with SMTP id 8so1661697pfo.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 22:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=bSm7tAjnjETjcXp7DjTp7DvZMdzTKvggHz7077B/Mtc=;
 b=ZEJ07Ne0rV/g1K3moNbswR98QFjCI70BcjD7zPzJzXi3am1/8h7wL7YY+Qln32XMJU
 omyFdpNec1iloQRWHhERHiryffU0iGzNydGfsnYOb7zb8dGiDedBlKMVocodQKU6PEkC
 UITgcre9SHnJNwBo3idZXEG64yZGzrZaKRc295Dgcf5KXpsYypiBy/kq3ArZ//8Ql1rN
 YOxhSsQTI/RF9txlmwuNAgMQ+6b6zaNNByzIg2kutC/9CjbkHAg9Ashlrff8I8CrFQMP
 SOunFnAFbgP/ZH+lty8JkXlfZlXCnQCMG/rp2jvQ4bRqiW94LPLCg0BdygKEk+Gr7xss
 ON2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=bSm7tAjnjETjcXp7DjTp7DvZMdzTKvggHz7077B/Mtc=;
 b=ct8lWQ80isS6mGBtPcae5xxrMGt0ChEUHh7043ufvmuSZqqEZxawV/PVs65fPVqFth
 8UwpQ985y7UuM7fzS+yjLmNTWHJMbvs/PRKL54vKjQPY1DyQkwoS4W3BuVtPWmM0B6l5
 23OmPk/IC+Jeu0CpZ0lyBsUVXZDYv4DDraXR9PJrA41yjvz3lUaKym+b6UxFS5MxXM9n
 xT4OQGVbptBLJnSPQvWBfp79exV1dnFrOMRhIIqwIIfbAN8OgJTOaKtUhafIFglr0SBP
 KdQjZ6D61JErcQ7u1kU43GO5iY6Bo0nfL97O+J4/VRNU0iTTcglPf5ech8dgZ4ZgQCyW
 KSbQ==
X-Gm-Message-State: AOAM530Fjt3cTUKJ0mvBrNmh2/L96EtMIXz0E1pPi9RopmsMgxmWsW+L
 +OPJqEbJ3FmB1E8tabJtHgt+PZIBaaL68P5JBOLYOQ==
X-Google-Smtp-Source: ABdhPJyiyxPCkG38X5eKSzVgjrjbwU8syqnUiFLwj/t/o+9pmchksr2bNK+WVAjCchFGoGuVXHs9Y6xd0HUQ875mCOA=
X-Received: by 2002:aa7:9438:0:b0:4a2:c941:9ac4 with SMTP id
 y24-20020aa79438000000b004a2c9419ac4mr3633208pfo.12.1637734325078; Tue, 23
 Nov 2021 22:12:05 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-5-reijiw@google.com>
 <87h7c5sn05.wl-maz@kernel.org>
In-Reply-To: <87h7c5sn05.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 23 Nov 2021 22:11:49 -0800
Message-ID: <CAAeT=Fz9CWhp8ym4hWHW7r-6eGJiNZ6_M8151aq9WT5g66vdEg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Nov 2021 06:43:34 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
> > userspace.
> >
> > The CSV2/CSV3 fields of the register were already writable and values
> > that were written for them affected all vCPUs before. Now they only
> > affect the vCPU.
> > Return an error if userspace tries to set SVE/GIC field of the register
> > to a value that conflicts with SVE/GIC configuration for the guest.
> > SIMD/FP/SVE fields of the requested value are validated according to
> > Arm ARM.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
> >  1 file changed, 103 insertions(+), 56 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1552cd5581b7..35400869067a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
> >               id_reg->init(id_reg);
> >  }
> >
> > +#define      kvm_has_gic3(kvm)               \
> > +     (irqchip_in_kernel(kvm) &&      \
> > +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> > +
> > +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                                 const struct id_reg_info *id_reg, u64 val)
> > +{
> > +     int fp, simd;
> > +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
> > +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
> > +     int gic;
> > +
> > +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
> > +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
> > +     if (simd != fp)
> > +             return -EINVAL;
> > +
> > +     /* fp must be supported when sve is supported */
> > +     if (pfr0_has_sve && (fp < 0))
> > +             return -EINVAL;
> > +
> > +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> > +     if (vcpu_has_sve ^ pfr0_has_sve)
> > +             return -EPERM;
> > +
> > +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
> > +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
> > +             return -EPERM;
> > +
> > +     return 0;
> > +}
> > +
> > +static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
> > +{
> > +     u64 limit = id_reg->vcpu_limit_val;
> > +     unsigned int gic;
> > +
> > +     limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
> > +     if (!system_supports_sve())
> > +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> > +
> > +     /*
> > +      * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
> > +      * isn't affected.  Userspace can override this as long as it
> > +      * doesn't promise the impossible.
> > +      */
> > +     limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
> > +                ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
> > +
> > +     if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> > +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
> > +     if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
> > +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
> > +
> > +     gic = cpuid_feature_extract_unsigned_field(limit, ID_AA64PFR0_GIC_SHIFT);
> > +     if (gic > 1) {
> > +             /* Limit to GICv3.0/4.0 */
> > +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
> > +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
> > +     }
> > +     id_reg->vcpu_limit_val = limit;
> > +}
> > +
> > +static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                                  const struct id_reg_info *idr)
> > +{
> > +     u64 val = idr->vcpu_limit_val;
> > +
> > +     if (!vcpu_has_sve(vcpu))
> > +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> > +
> > +     if (!kvm_has_gic3(vcpu->kvm))
> > +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
>
> No. As I said in a previous email, this breaks migration, and
> advertising a GICv3 CPU interface doesn't mean it is usable (the guest
> OS must check that it can actually enable ICC_SRE_EL1.SRE -- see what
> the Linux GICv3 driver does for an example).

Yes, I understand. I will remove that code.

> > +     return val;
> > +}
> > +
> > +static struct id_reg_info id_aa64pfr0_el1_info = {
> > +     .sys_reg = SYS_ID_AA64PFR0_EL1,
> > +     .ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
> > +                        S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
> > +     .init = init_id_aa64pfr0_el1_info,
> > +     .validate = validate_id_aa64pfr0_el1,
> > +     .get_reset_val = get_reset_id_aa64pfr0_el1,
> > +};
> > +
> >  /*
> >   * An ID register that needs special handling to control the value for the
> >   * guest must have its own id_reg_info in id_reg_info_table.
> > @@ -409,7 +495,9 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
> >   * validation, etc.)
> >   */
> >  #define      GET_ID_REG_INFO(id)     (id_reg_info_table[IDREG_IDX(id)])
> > -static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
> > +static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
> > +     [IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
> > +};
> >
> >  static int validate_id_reg(struct kvm_vcpu *vcpu,
> >                          const struct sys_reg_desc *rd, u64 val)
> > @@ -1239,20 +1327,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >  static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> >       u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> > +     u64 lim, gic, gic_lim;
> > +     const struct id_reg_info *id_reg;
> >
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > -             if (!vcpu_has_sve(vcpu))
> > -                     val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> > -             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
> > -             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
> > -             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
> > -             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
> > -             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
> > -             if (irqchip_in_kernel(vcpu->kvm) &&
> > -                 vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> > -                     val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
> > -                     val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
> > +             gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
> > +             if (kvm_has_gic3(vcpu->kvm) && (gic == 0)) {
> > +                     /*
> > +                      * This is a case where userspace configured gic3 after
> > +                      * the vcpu was created, and then it didn't set
> > +                      * ID_AA64PFR0_EL1.
> > +                      */
>
> Shouldn't that be done at the point where a GICv3 is created, rather
> than after the fact?

I will look into having it done at the point where a GICv3 is created.
(I originally chose this way because I wanted to avoid access to
other vCPUs' ID registers if possible)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
