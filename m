Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119A7C43334
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 06:12:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A31E4BDAE;
	Tue, 12 Jul 2022 02:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OQFbh+9ncWtf; Tue, 12 Jul 2022 02:12:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9964BDAB;
	Tue, 12 Jul 2022 02:12:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 894524BDA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 02:12:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BAcfml7lfda2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2022 02:11:56 -0400 (EDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com
 [209.85.217.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78E224BD9B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2022 02:11:56 -0400 (EDT)
Received: by mail-vs1-f45.google.com with SMTP id s1so3421323vsr.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 23:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=oNG734zoDtC7NjitR5PLwxoioCjGns2LqBTR0a3CYV8=;
 b=ORjbC77+qKSDkdBvLMkjAEgg2Wz8k1ktfLsxZ/KOS4nV6H5DWIBueB7OzSPgn0QdlR
 owRlKyREZG59FjJOCP+KB/Z/XAymTz6GYCNW3T00Odb2/cfLtFTdwtr24RuoyIWYXnE4
 C9j2n5uFPQ16SsQGovleMzyvrixugJI365eKYjziv6L40lAUnyd/6Wrrl3ZU0DYRHiOY
 +GugYoKPuLG5Eyv1Ca54lb8tdfq0XoUaafC6WERUO0jEti2D9lkF8r32mpOZg1HhR/vA
 lCEOTrxM0Zl9MDsrtfUPLPCH0PUntvxeoe8nfgmFakbEY5Gp1v7opzj5a/smdH7RhwJb
 Az3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=oNG734zoDtC7NjitR5PLwxoioCjGns2LqBTR0a3CYV8=;
 b=4tMyyr8RySDEbVXtizGlRtJDG5F7QKHQs+sOjJKeMjynCHFH3fUNw20DrNuv1ObtVp
 FEpbrbdchupaGJ87uJMu01q+fJRXxV+1ejan9CJUCvp18BxQw4T+Zi/bstAPXxtd3NU8
 Ta7di0pE7C8JW7ZE6LRvcxan0LKDjzqd5WsLPyv7B0ZJ7S9LkWGRP9t/AkvW1Wp67LHx
 mMWy/YihtGfFhJfbs2FinKZOBR8BivcFA+DzTUk18R/7nEjgbU6l61UUTX3mi1EJDU8O
 bB6ljJ4qh3GypE5inlN6gzE6C7RU86iAiJs+M1omRgJjH7RMP+9VewmHkeecBvuqmAJL
 /UNw==
X-Gm-Message-State: AJIora+ypXoUIyAFai86WRZAL/IgWnrivP08lw8767kiyrZG6m7OoNPC
 kKtBIxVNrvvx49JW8ss9brjxxddZqrds6DeF9f2j+g==
X-Google-Smtp-Source: AGRyM1uZuk9p6VgkE/lOIAz85oIVBg15JoI9cn0o1yYc8xVs13NTcbMepH/XALs37ObggkcLEnqHq0j/SSsPQJYrJCQ=
X-Received: by 2002:a67:5c41:0:b0:356:20ab:2f29 with SMTP id
 q62-20020a675c41000000b0035620ab2f29mr8229234vsb.63.1657606315823; Mon, 11
 Jul 2022 23:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-9-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-9-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 11 Jul 2022 23:11:39 -0700
Message-ID: <CAAeT=FwLxFnVq3T313CM__5j9e1d-5rRDeTwdZVqsbX0LM3ywA@mail.gmail.com>
Subject: Re: [PATCH 08/19] KVM: arm64: vgic-v3: Push user access into
 vgic_v3_cpu_sysregs_uaccess()
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Marc,

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to start making the vgic sysreg access from userspace
> similar to all the other sysregs, push the userspace memory
> access one level down into vgic_v3_cpu_sysregs_uaccess().
>
> The next step will be to rely on the sysreg infrastructure
> to perform this task.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic-sys-reg-v3.c      | 22 +++++++++++++------
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 31 ++++++---------------------
>  arch/arm64/kvm/vgic/vgic.h            |  4 ++--
>  3 files changed, 23 insertions(+), 34 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 85a5e1d15e9f..8c56e285fde9 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -278,15 +278,21 @@ int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *
>         return -ENXIO;
>  }
>
> -int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> -                               u64 *reg)
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
> +                               struct kvm_device_attr *attr,
> +                               bool is_write)
>  {
> +       u64 __user *uaddr = (u64 __user *)(long)attr->addr;
>         struct sys_reg_params params;
>         const struct sys_reg_desc *r;
> -       u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> +       u64 sysreg;
>
> -       if (is_write)
> -               params.regval = *reg;
> +       sysreg = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;

Why don't you use attr_to_id() here ?


> +
> +       if (is_write) {
> +               if (get_user(params.regval, uaddr))
> +                       return -EFAULT;
> +       }
>         params.is_write = is_write;
>
>         r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> @@ -297,8 +303,10 @@ int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
>         if (!r->access(vcpu, &params, r))
>                 return -EINVAL;
>
> -       if (!is_write)
> -               *reg = params.regval;
> +       if (!is_write) {
> +               if (put_user(params.regval, uaddr))
> +                       return -EFAULT;
> +       }
>
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index c6d52a1fd9c8..d8269300632d 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -561,14 +561,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>                 if (!is_write)
>                         *reg = tmp32;
>                 break;
> -       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
> -               u64 regid;
> -
> -               regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> -               ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
> -                                                 regid, reg);
> +       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> +               ret = vgic_v3_cpu_sysregs_uaccess(vcpu, attr, is_write);

Nit: Since @reg that is passed to vgic_v3_attr_regs_access() will be NULL
for KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS, I think it would be more clear
if you could update the comment for vgic_v3_attr_regs_access accordingly.

----
/*
 * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
 *
 * @dev:      kvm device handle
 * @attr:     kvm device attribute
 * @reg:      address the value is read or written
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * @is_write: true if userspace is writing a register
 */
static int vgic_v3_attr_regs_access(struct kvm_device *dev,
                                    struct kvm_device_attr *attr,
                                    u64 *reg, bool is_write)
----

Thank you,
Reiji


>                 break;
> -       }
>         case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
>                 unsigned int info, intid;
>
> @@ -617,15 +612,8 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>                 reg = tmp32;
>                 return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>         }
> -       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
> -               u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> -               u64 reg;
> -
> -               if (get_user(reg, uaddr))
> -                       return -EFAULT;
> -
> -               return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> -       }
> +       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> +               return vgic_v3_attr_regs_access(dev, attr, NULL, true);
>         case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
>                 u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>                 u64 reg;
> @@ -681,15 +669,8 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>                 tmp32 = reg;
>                 return put_user(tmp32, uaddr);
>         }
> -       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
> -               u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> -               u64 reg;
> -
> -               ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
> -               if (ret)
> -                       return ret;
> -               return put_user(reg, uaddr);
> -       }
> +       case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> +               return vgic_v3_attr_regs_access(dev, attr, NULL, false);
>         case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
>                 u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>                 u64 reg;
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index ffc2d3c81b28..c23118467a35 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -245,8 +245,8 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>                          int offset, u32 *val);
>  int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>                          int offset, u32 *val);
> -int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> -                        u64 id, u64 *val);
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
> +                               struct kvm_device_attr *attr, bool is_write);
>  int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>                                     u32 intid, u64 *val);
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
