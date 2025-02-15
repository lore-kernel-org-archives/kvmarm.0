Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54B4D529
	for <kvmarm@lists.linux.dev>; Sat, 15 Feb 2025 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739636220; cv=none; b=O8HrkNgglu2rub4M6CI52rCYkTY6n7x0JaBMS/8Eev3rVMcVzQQs1GAm8CCD5jDqSaYEnU5/+lVi5vHnE5xNV11qOgKRAyoFjjjqxyIw0E32tX+2CHOWwh/KAt0zcqRF1aVhcE8jIExE8u8Ee2VJQfFpjNMIFZuOY64i/Xo5fl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739636220; c=relaxed/simple;
	bh=pgsl/If+wA3j4FE+G3XExPBAamk7MSPy8GjTdtMB844=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YyTAFRsV9BeZKJFrsFztsUryx+OjpSOL0l7xjUsAnEGBEzPl5v90zsQcyiNqdVW/0qG2tRwMGTmORzqNP1YHGMkn9PpBcMcTjBRi3kXzmUr3rlv5KZgf8/lodLBfJmsg9iMVHv3tqgSVC9pqRITYcfLXqx9chbA8gD5vRbpNh9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c9FKINuT; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9FKINuT"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab7cc0c1a37so546458866b.0
        for <kvmarm@lists.linux.dev>; Sat, 15 Feb 2025 08:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739636217; x=1740241017; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=okAkfz3seOBQI9McoD6NBWS5lv1omzWEsYR9zMa/7M8=;
        b=c9FKINuTtfLTrIlXvTxFDe7AKoxVeuCD3eXEtOpsQKieWrbSqqSYRxdMTIS3ReTjE9
         sKS/hrC9A0cLr0dfeBWluvq9WwH5cbRWmdF3s4O8Baq8ucgD+kdtVYvbw/0w0D93jKPT
         +DHgEp517VTiWcuYloWrMXu9PDwSzH+95DcLH6mNGJn8gTB38FifDbS5SvhRCFyoUoJe
         v/7sofWWiEw80Wn0m6VQu2KW0hJ+m5c8xyID8/4AXANcaXdsuYZY54CLm/RSvEWCSBXk
         vR8YQWKKLSdKYHWbOATMFncwnj+qaWYDW4nw8Dx33h8+elKGadH2cwsF4TX0OfaOF1qV
         CayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739636217; x=1740241017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=okAkfz3seOBQI9McoD6NBWS5lv1omzWEsYR9zMa/7M8=;
        b=FKk1inzdz1eBJAruG5HqV/efliIgcNELP52RUNysVgdyvTKLSZnBKS3vlUAE4AyMUK
         104141/80cxJNvhm/IhU3fAeXbqpTL9qAvTlc1C40mE+5e0jKKLimsBCqnlibVLzsiIC
         Lm6hhLR7j36hZNPJ4lfx/NVtbuP6SgEn0ZgFdiI7h8JLD179KpoSIyeh2nODFkwr25nd
         ASm5Du5HiPQOkTPi96EMA183iDmz7mmkHz0mw8VCmQ8zn/xxotVLDGSyZOvOs2aHNXSH
         hC/1QX2UyxuFUyW+rkqOG73wv3EJBsXtMiiXs17uwpquX0bvQPuHNlnLKHJXqHFdIipq
         xsUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcWO2/3H3vQRy7Nr46PiMnlcnX5PasjsUucFxKcg11Fr5dy80EFwdmh3nZHBCqZ2z8mh0dEoQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzu4Uiv3hxz0h5zHYrMu+rHKY/myrmM1dHbnKLmFAATh0EI3XWM
	OLs1sYIaz8F/X1d1O+Z5YxD37krlKlhAap/OF1F9xnBBRlfNnB9su9FBHWOnz285jzQEMniKF12
	QR8OjGEW9y/Cii2ab7oenuq1JvrI=
X-Gm-Gg: ASbGncvnToSqfNhdMcuuNoQRpVFFtnFvrEx9rvm5x+x17QwffgmMFHdpg/5Q1XSQm1X
	QztCHBPpycEcbfGhXl5aIrLcHitBYg2jWEM+uriM0QP1WhmeF/YpZwQdgVtFYbzTDhGFWN88C
X-Google-Smtp-Source: AGHT+IEwF6vLnEXWXotW293B/3xDlg0MfzJfP38jNk+QmBSe2iHne9w0GrH53Co4xrP5jB2HAYsv4KQ4ugP+Dsy31Qc=
X-Received: by 2002:a17:906:c399:b0:ab7:bcc0:9050 with SMTP id
 a640c23a62f3a-abb70b2f1a6mr268258766b.27.1739636216871; Sat, 15 Feb 2025
 08:16:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250211143910.16775-1-sebott@redhat.com> <20250211143910.16775-2-sebott@redhat.com>
 <Z7BoydkyT_h0gwOV@linux.dev>
In-Reply-To: <Z7BoydkyT_h0gwOV@linux.dev>
Reply-To: luoyonggang@gmail.com
From: =?UTF-8?B?572X5YuH5YiaKFlvbmdnYW5nIEx1byk=?= <luoyonggang@gmail.com>
Date: Sun, 16 Feb 2025 00:16:44 +0800
X-Gm-Features: AWEUYZmnYv-KvGHpFE_jzJc8vV2oHyHLnjmQy49AKn3ynSRfnXjgHvmlK88ELt8
Message-ID: <CAE2XoE_8ihJZQF856w-_F+cgJW7fLWGz7M7Ztoxzw2vE51_m1A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Cornelia Huck <cohuck@redhat.com>, 
	Eric Auger <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2025 at 6:15=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Sebastian,
>
> On Tue, Feb 11, 2025 at 03:39:07PM +0100, Sebastian Ott wrote:
> > +static int set_id_reg_non_ftr(struct kvm_vcpu *vcpu, const struct sys_=
reg_desc *rd,
> > +                           u64 val)
> > +{
> > +     u32 id =3D reg_to_encoding(rd);
> > +     int ret;
> > +
> > +     mutex_lock(&vcpu->kvm->arch.config_lock);
>
> There's quite a few early outs, guard() might be a better fit than
> explicitly dropping the lock.
>
> > +     /*
> > +      * Since guest access to MIDR_EL1 is not trapped
> > +      * set up VPIDR_EL2 to hold the MIDR_EL1 value.
> > +      */
> > +     if (id =3D=3D SYS_MIDR_EL1)
> > +             write_sysreg(val, vpidr_el2);
>
> This is problematic for a couple reasons:
>
>  - If the kernel isn't running at EL2, VPIDR_EL2 is undefined
>
>  - VPIDR_EL2 needs to be handled as part of the vCPU context, not
>    written to without a running vCPU. What would happen if two vCPUs
>    have different MIDR values?
>
> Here's a new diff with some hacks thrown in to handle VPIDR_EL2
> correctly. Very lightly tested :)

Thans, I am also faced this issue, but other than this, I am also
facing a issue, after updating
MIDR_EL1, The CP15 register MIDR for aarch32 not updated.
The instruction is `MRC p15,0,<Rt>,c0,c0,0    ; Read CP15 Main ID Register`=
 from
https://developer.arm.com/documentation/ddi0406/b/System-Level-Architecture=
/Protected-Memory-System-Architecture--PMSA-/CP15-registers-for-a-PMSA-impl=
ementation/c0--Main-ID-Register--MIDR-

The value of this instruction is not updated



>
> Thanks,
> Oliver
> ---
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 7cfa024de4e3..3db8c773339e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -373,6 +373,7 @@ struct kvm_arch {
>  #define KVM_ARM_ID_REG_NUM     (IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
>         u64 id_regs[KVM_ARM_ID_REG_NUM];
>
> +       u64 midr_el1;
>         u64 ctr_el0;
>
>         /* Masks for VNCR-backed and general EL2 sysregs */
> @@ -1469,6 +1470,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka,=
 u32 reg)
>         switch (reg) {
>         case sys_reg(3, 0, 0, 1, 0) ... sys_reg(3, 0, 0, 7, 7):
>                 return &ka->id_regs[IDREG_IDX(reg)];
> +       case SYS_MIDR_EL1:
> +               return &ka->midr_el1;
>         case SYS_CTR_EL0:
>                 return &ka->ctr_el0;
>         default:
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index 76ff095c6b6e..866411621a39 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -168,9 +168,11 @@ static inline void __sysreg_restore_user_state(struc=
t kvm_cpu_context *ctxt)
>  }
>
>  static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ct=
xt,
> -                                             u64 mpidr)
> +                                             u64 midr, u64 mpidr)
>  {
> -       write_sysreg(mpidr,                             vmpidr_el2);
> +       write_sysreg(midr, vpidr_el2);
> +       write_sysreg(mpidr, vmpidr_el2);
> +
>
>         if (has_vhe() ||
>             !cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvh=
e/sysreg-sr.c
> index dba101565de3..a01be1add5ad 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> @@ -28,7 +28,15 @@ void __sysreg_save_state_nvhe(struct kvm_cpu_context *=
ctxt)
>
>  void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
>  {
> -       __sysreg_restore_el1_state(ctxt, ctxt_sys_reg(ctxt, MPIDR_EL1));
> +       u64 midr;
> +
> +       if (ctxt_is_guest(ctxt))
> +               midr =3D kvm_read_vm_id_reg(kern_hyp_va(ctxt_to_vcpu(ctxt=
)->kvm),
> +                                         SYS_MIDR_EL1);
> +       else
> +               midr =3D read_cpuid_id();
> +
> +       __sysreg_restore_el1_state(ctxt, midr, ctxt_sys_reg(ctxt, MPIDR_E=
L1));
>         __sysreg_restore_common_state(ctxt);
>         __sysreg_restore_user_state(ctxt);
>         __sysreg_restore_el2_return_state(ctxt);
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index 90b018e06f2c..1d4b9597eb29 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -87,11 +87,12 @@ static void __sysreg_restore_vel2_state(struct kvm_vc=
pu *vcpu)
>         write_sysreg(__vcpu_sys_reg(vcpu, PAR_EL1),     par_el1);
>         write_sysreg(__vcpu_sys_reg(vcpu, TPIDR_EL1),   tpidr_el1);
>
> -       write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),           vmpidr_el=
2);
> -       write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),        SYS_MAIR)=
;
> -       write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),        SYS_VBAR)=
;
> -       write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),  SYS_CONTE=
XTIDR);
> -       write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),       SYS_AMAIR=
);
> +       write_sysreg(kvm_read_vm_id_reg(vcpu->kvm, SYS_MIDR_EL1),       v=
pidr_el2);
> +       write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),                   v=
mpidr_el2);
> +       write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),                S=
YS_MAIR);
> +       write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),                S=
YS_VBAR);
> +       write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),          S=
YS_CONTEXTIDR);
> +       write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),               S=
YS_AMAIR);
>
>         if (vcpu_el2_e2h_is_set(vcpu)) {
>                 /*
> @@ -191,7 +192,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu=
)
>  {
>         struct kvm_cpu_context *guest_ctxt =3D &vcpu->arch.ctxt;
>         struct kvm_cpu_context *host_ctxt;
> -       u64 mpidr;
> +       u64 midr, mpidr;
>
>         host_ctxt =3D host_data_ptr(host_ctxt);
>         __sysreg_save_user_state(host_ctxt);
> @@ -222,10 +223,9 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcp=
u)
>                 if (vcpu_has_nv(vcpu)) {
>                         /*
>                          * Use the guest hypervisor's VPIDR_EL2 when in a
> -                        * nested state. The hardware value of MIDR_EL1 g=
ets
> -                        * restored on put.
> +                        * nested state.
>                          */
> -                       write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2),=
 vpidr_el2);
> +                       midr =3D ctxt_sys_reg(guest_ctxt, VPIDR_EL2);
>
>                         /*
>                          * As we're restoring a nested guest, set the val=
ue
> @@ -233,10 +233,11 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vc=
pu)
>                          */
>                         mpidr =3D ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
>                 } else {
> +                       midr =3D kvm_read_vm_id_reg(vcpu->kvm, SYS_MIDR_E=
L1);
>                         mpidr =3D ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
>                 }
>
> -               __sysreg_restore_el1_state(guest_ctxt, mpidr);
> +               __sysreg_restore_el1_state(guest_ctxt, midr, mpidr);
>         }
>
>         vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
> @@ -271,9 +272,5 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
>         /* Restore host user state */
>         __sysreg_restore_user_state(host_ctxt);
>
> -       /* If leaving a nesting guest, restore MIDR_EL1 default view */
> -       if (vcpu_has_nv(vcpu))
> -               write_sysreg(read_cpuid_id(),   vpidr_el2);
> -
>         vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
>  }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f6cd1ea7fb55..aa1a0443dc6a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1656,7 +1656,7 @@ static bool is_feature_id_reg(u32 encoding)
>   */
>  static inline bool is_vm_ftr_id_reg(u32 id)
>  {
> -       if (id =3D=3D SYS_CTR_EL0)
> +       if (id =3D=3D SYS_CTR_EL0 || id =3D=3D SYS_MIDR_EL1)
>                 return true;
>
>         return (sys_reg_Op0(id) =3D=3D 3 && sys_reg_Op1(id) =3D=3D 0 &&
> @@ -1989,6 +1989,34 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *rd,
>         return 0;
>  }
>
> +static int set_id_reg_non_ftr(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *rd,
> +                             u64 val)
> +{
> +       u32 id =3D reg_to_encoding(rd);
> +
> +       guard(mutex)(&vcpu->kvm->arch.config_lock);
> +
> +       /*
> +        * Once the VM has started the ID registers are immutable. Reject=
 any
> +        * write that does not match the final register value.
> +        */
> +       if (kvm_vm_has_ran_once(vcpu->kvm)) {
> +               if (val !=3D read_id_reg(vcpu, rd))
> +                       return -EBUSY;
> +
> +               return 0;
> +       }
> +
> +       /*
> +        * For non ftr regs do a limited test against the writable mask o=
nly.
> +        */
> +       if ((rd->val & val) !=3D val)
> +               return -EINVAL;
> +
> +       kvm_set_vm_id_reg(vcpu->kvm, id, val);
> +       return 0;
> +}
> +
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
rd,
>                       u64 val)
>  {
> @@ -2483,6 +2511,15 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> +#define FUNCTION_RESET(reg)                                            \
> +       static u64 reset_##reg(struct kvm_vcpu *v,                      \
> +                              const struct sys_reg_desc *r)            \
> +       {                                                               \
> +               return read_sysreg(reg);                                \
> +       }
> +
> +FUNCTION_RESET(midr_el1)
> +
>
>  /*
>   * Architected system registers.
> @@ -2532,6 +2569,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>
>         { SYS_DESC(SYS_DBGVCR32_EL2), undef_access, reset_val, DBGVCR32_E=
L2, 0 },
>
> +       { ID_DESC(MIDR_EL1), .set_user =3D set_id_reg_non_ftr, .visibilit=
y =3D id_visibility,
> +         .reset =3D reset_midr_el1, .val =3D GENMASK_ULL(31, 0) },
>         { SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
>
>         /*
> @@ -4584,13 +4623,11 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
>                 return ((struct sys_reg_desc *)r)->val;                 \
>         }
>
> -FUNCTION_INVARIANT(midr_el1)
>  FUNCTION_INVARIANT(revidr_el1)
>  FUNCTION_INVARIANT(aidr_el1)
>
>  /* ->val is filled in by kvm_sys_reg_table_init() */
>  static struct sys_reg_desc invariant_sys_regs[] __ro_after_init =3D {
> -       { SYS_DESC(SYS_MIDR_EL1), NULL, reset_midr_el1 },
>         { SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
>         { SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
>  };
>


--=20
         =E6=AD=A4=E8=87=B4
=E7=A4=BC
=E7=BD=97=E5=8B=87=E5=88=9A
Yours
    sincerely,
Yonggang Luo
