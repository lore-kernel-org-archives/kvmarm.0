Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1CFC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jan 2022 16:22:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED79F40B3B;
	Mon, 24 Jan 2022 11:22:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mkf6Hf3ZAFA5; Mon, 24 Jan 2022 11:22:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9562E40AFA;
	Mon, 24 Jan 2022 11:22:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CBC40AFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 11:22:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 48g621rEXmtU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 11:22:09 -0500 (EST)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com
 [209.85.167.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 797D740A84
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 11:22:09 -0500 (EST)
Received: by mail-oi1-f181.google.com with SMTP id e81so26244552oia.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 08:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Tas5AbzcTcQxkjTh80aoeGdBDNzOmo4QIeXV2TcoEGc=;
 b=A6ZxEY7kZWYRmUXB9AnJu03se+0+yrE1ha8XTsaYULIzIofkM9b87UR7jWDGmnNiOE
 1e/ksqWlYh3zsWE7iDerPvDny8Sx/nNam16/BtEJXxpeHPBs5oo5maEPUagHmciGRuXG
 5IIZpZtDJUDJVNb52cN8srtTvbSBBgURl+h/WaShLfOGieT0DLZ97TpomHlluPZVkVd2
 ErzMfoqI8VHJTWx/5BnqKcSmaQ7smIOjfgYI5eJaRPoQKa6lKwjTn95cxE+S96Kla63y
 xyWOhDlbJl/amWXoGAEEd1dGnuuTg2K/GKVLGpzRMMhLxmnJecZ6C+0ydUm+DWH1g2Bj
 Y5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Tas5AbzcTcQxkjTh80aoeGdBDNzOmo4QIeXV2TcoEGc=;
 b=UT4MPro37QMuhk3c92flMGXxgs4/66/s2lJ17b8BZOxpCcxGbY0QWvUcpWox0hUdFA
 HJIfd9Y5thIRtSxCha6sP1HADr5eWTbt3csqpSnPkgypKiQiCBFBg1j1MZz8JRLH45dI
 VYL+K9iCmXS7mER+iYWjC+0ANzFiAg/v8ZygGMTF0ZGfaCenHm2UDRRDmO7zcicV+WcV
 nupWh55x0gRg9LNuDk97aAnGTslm/cq3OM7PTl6/Zcz6FUKi0tulykLU4y55E8MpqjJ9
 Bzn1kj+u4EIPFJOeEv77spl3ZE9nanoy+f0anoGAIbCIaFcdTHhoXwWAmRVfoXJk4AB6
 WxlA==
X-Gm-Message-State: AOAM532Iy0kR0wM2TgoZWWA8tMQoUjUk68M2xiYgipAn5BIReN9zTKue
 victdQdaHtfiwy3Lwc6De6YIz4P5KxspRaAL2tygbQ==
X-Google-Smtp-Source: ABdhPJy0xze+kYEb3O+BA8yiLfrII+cCnt3mZXTrFCxYbbrwrAhMFPf+eucXwvPEkUPMtreTBEf/hCDY0+5i5b0TEU4=
X-Received: by 2002:aca:1204:: with SMTP id 4mr2016816ois.85.1643041328609;
 Mon, 24 Jan 2022 08:22:08 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
In-Reply-To: <20220106042708.2869332-3-reijiw@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 24 Jan 2022 16:21:32 +0000
Message-ID: <CA+EHjTxVe3baCwpde+QFYKvyUaUGu9F37t-=r8k32JcHBOY61Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
To: Reiji Watanabe <reijiw@google.com>
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

Hi Reiji,

On Thu, Jan 6, 2022 at 4:28 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> Use the saved ones when ID registers are read by the guest or
> userspace (via KVM_GET_ONE_REG).
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 16 ++++++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/sys_regs.c         | 62 ++++++++++++++++++++++---------
>  3 files changed, 62 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2a5f7f38006f..c789a0137f58 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -102,6 +102,17 @@ struct kvm_s2_mmu {
>  struct kvm_arch_memory_slot {
>  };
>
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.
> + */
> +#define KVM_ARM_ID_REG_MAX_NUM 64
> +#define IDREG_IDX(id)          ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +#define is_id_reg(id)  \
> +       (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&        \
> +        sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 0 &&        \
> +        sys_reg_CRm(id) < 8)
> +

This is consistent with the Arm ARM "Table D12-2 System instruction
encodings for non-Debug System register accesses".

Minor nit, would it be better to have IDREG_IDX and is_id_reg in
arch/arm64/kvm/sys_regs.h, since other similar and related ones are
there?

>  struct kvm_arch {
>         struct kvm_s2_mmu mmu;
>
> @@ -137,6 +148,9 @@ struct kvm_arch {
>
>         /* Memory Tagging Extension enabled for the guest */
>         bool mte_enabled;
> +
> +       /* ID registers for the guest. */
> +       u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
>  };
>
>  struct kvm_vcpu_fault_info {
> @@ -734,6 +748,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>                                 struct kvm_arm_copy_mte_tags *copy_tags);
>
> +void set_default_id_regs(struct kvm *kvm);
> +
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e4727dc771bf..5f497a0af254 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>
>         set_default_spectre(kvm);
> +       set_default_id_regs(kvm);
>
>         return ret;
>  out_free_stage2_pgd:
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3ec1a44f94d..80dc62f98ef0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -33,6 +33,8 @@
>
>  #include "trace.h"
>
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> +
>  /*
>   * All of this file is extremely similar to the ARM coproc.c, but the
>   * types are different. My gut feeling is that it should be pretty
> @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>                           struct sys_reg_params *p,
>                           const struct sys_reg_desc *r)
>  {
> -       u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +       u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>         u32 sr = reg_to_encoding(r);
>
>         if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> -               struct sys_reg_desc const *r, bool raz)
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -       u32 id = reg_to_encoding(r);
> -       u64 val;
> -
> -       if (raz)
> -               return 0;
> -
> -       val = read_sanitised_ftr_reg(id);
> +       u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
>
>         switch (id) {
>         case SYS_ID_AA64PFR0_EL1:
> @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>         return val;
>  }
>
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +                      struct sys_reg_desc const *r, bool raz)
> +{
> +       u32 id = reg_to_encoding(r);
> +
> +       return raz ? 0 : __read_id_reg(vcpu, id);
> +}
> +
>  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
>                                   const struct sys_reg_desc *r)
>  {
> @@ -1223,9 +1225,8 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  /*
>   * cpufeature ID register user accessors
>   *
> - * For now, these registers are immutable for userspace, so no values
> - * are stored, and for set_id_reg() we don't allow the effective value
> - * to be changed.
> + * For now, these registers are immutable for userspace, so for set_id_reg()
> + * we don't allow the effective value to be changed.
>   */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>                         const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1237,7 +1238,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
>         return reg_to_user(uaddr, &val, id);
>  }
>
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +static int __set_id_reg(struct kvm_vcpu *vcpu,
>                         const struct sys_reg_desc *rd, void __user *uaddr,
>                         bool raz)

Minor nit: why remove the const in this patch? This is required for a
future patch but not for this one.

Thanks,
/fuad


>  {
> @@ -1837,8 +1838,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>         if (p->is_write) {
>                 return ignore_write(vcpu, p);
>         } else {
> -               u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> -               u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +               u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> +               u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
>                 u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>
>                 p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> @@ -2850,3 +2851,30 @@ void kvm_sys_reg_table_init(void)
>         /* Clear all higher bits. */
>         cache_levels &= (1 << (i*3))-1;
>  }
> +
> +/*
> + * Set the guest's ID registers that are defined in sys_reg_descs[]
> + * with ID_SANITISED() to the host's sanitized value.
> + */
> +void set_default_id_regs(struct kvm *kvm)
> +{
> +       int i;
> +       u32 id;
> +       const struct sys_reg_desc *rd;
> +       u64 val;
> +
> +       for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> +               rd = &sys_reg_descs[i];
> +               if (rd->access != access_id_reg)
> +                       /* Not ID register, or hidden/reserved ID register */
> +                       continue;
> +
> +               id = reg_to_encoding(rd);
> +               if (WARN_ON_ONCE(!is_id_reg(id)))
> +                       /* Shouldn't happen */
> +                       continue;
> +
> +               val = read_sanitised_ftr_reg(id);
> +               kvm->arch.id_regs[IDREG_IDX(id)] = val;
> +       }
> +}
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
