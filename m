Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCFCC43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 04:43:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E839D4C485;
	Thu, 14 Jul 2022 00:43:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A+yBR6fyqY7r; Thu, 14 Jul 2022 00:43:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A197B4C38C;
	Thu, 14 Jul 2022 00:43:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E963A4C37B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 00:43:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E6wTLIv4id5U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 00:43:45 -0400 (EDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com
 [209.85.217.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2CFE4C325
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 00:43:45 -0400 (EDT)
Received: by mail-vs1-f49.google.com with SMTP id a184so487347vsa.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 21:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CC8ma0I/yKcFtcwzZTYPpavoOcCdTiLVctElv53aEp4=;
 b=HFVmVR3R2e4P+LA6LAajl9bQqT+fbST+HoGMue0JFUYDYN4dTQkExtSYqTSvMK+S87
 81AdH0dy7+CRfqVlIEoldw9T1Sr5K+FPn2k7LTu9Gtln/42zNGUDgbKSLv27m2uw+qNM
 ZuguIbz1UwZO/24nrswHAI1CGaFeNGSGxPAieSWSxOlHZrKC+8hHv0JPdEPCxmKSeqyJ
 /Xm2XAaaLdaFWJPR9K1mb12Z6x1yRYoINxIDDQQTvm3pKShj8o+S0WYymvZPyJa6iKDF
 FUjFaFFfMk6FHyFIDZHRloOGqUiLTDZHCuixLYcEcYV3QFI3Ts479sPi/c0ecnd/Netq
 +hLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CC8ma0I/yKcFtcwzZTYPpavoOcCdTiLVctElv53aEp4=;
 b=JPS6vNR3pLu7XKftkq5RDm8Fe4WFddwT0MkiOJZyd3HHSd0ed1n9lUAiraeSE4w1K8
 v1dl2H7XYvKAsSnHWPWpe22r4aEG6yy7yxAuN7pRzibDsrYlVXTjebMsjcYJ9cc9NZxA
 vJZn/hn5OHY8Dnu/ZHzn5HFGlkZqsrGQtajr0eo9J6uS5KyJfhIgirHcqy4psnJnuj+V
 8hWVTgClk+OfgayF5Iw+HG3UPX1W+ajvJniTYETvQsmHPFzmqzFuGdXeUQf3HLT8cfRv
 zC5TuWQdv0Xw2MKl9rqeganMxB5ByIQ/w/iZ1AMkavxVUUTQLT84M3atCpW5VoRRUVDM
 D5yQ==
X-Gm-Message-State: AJIora+J4dttaJ/oMlMJy3VMOz3QvFgNsUmw+3IvEPE5U3MWIuP7l8wC
 FxSUnBSl+c5mWfIwNbzH42K2LHKn+ZhRIhrFmebUqQ==
X-Google-Smtp-Source: AGRyM1smHGyMSsB3BIrtUB2s8kgDZPXptz9yEcssqJGDWdArFXCBnoEDdctdhEDhI/rFnpAU6PZnpL7t6CUQZSQ9muM=
X-Received: by 2002:a67:f5c9:0:b0:357:515d:a6ea with SMTP id
 t9-20020a67f5c9000000b00357515da6eamr2769699vso.51.1657773823034; Wed, 13 Jul
 2022 21:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-14-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-14-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 13 Jul 2022 21:43:27 -0700
Message-ID: <CAAeT=Fx9CbiJStMJcQ=-iwoLhAQGcwPbW==b0yHxkd3hmcXjiQ@mail.gmail.com>
Subject: Re: [PATCH 13/19] KVM: arm64: vgic-v2: Consolidate userspace access
 for MMIO registers
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Align the GICv2 MMIO accesses from userspace with the way the GICv3
> code is now structured.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 40 ++++++++++++---------------
>  1 file changed, 18 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 925875722027..ddead333c232 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -348,17 +348,18 @@ bool lock_all_vcpus(struct kvm *kvm)
>   *
>   * @dev:      kvm device handle
>   * @attr:     kvm device attribute
> - * @reg:      address the value is read or written
>   * @is_write: true if userspace is writing a register
>   */
>  static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>                                     struct kvm_device_attr *attr,
> -                                   u32 *reg, bool is_write)
> +                                   bool is_write)
>  {
> +       u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
>         struct vgic_reg_attr reg_attr;
>         gpa_t addr;
>         struct kvm_vcpu *vcpu;
>         int ret;
> +       u32 val;
>
>         ret = vgic_v2_parse_attr(dev, attr, &reg_attr);
>         if (ret)
> @@ -367,6 +368,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>         vcpu = reg_attr.vcpu;
>         addr = reg_attr.addr;
>
> +       if (is_write)
> +               if (get_user(val, uaddr))
> +                       return -EFAULT;
> +
>         mutex_lock(&dev->kvm->lock);
>
>         ret = vgic_init(dev->kvm);
> @@ -380,10 +385,10 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>
>         switch (attr->group) {
>         case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> -               ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
> +               ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, &val);
>                 break;
>         case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -               ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
> +               ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &val);
>                 break;
>         default:
>                 ret = -EINVAL;
> @@ -393,6 +398,11 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>         unlock_all_vcpus(dev->kvm);
>  out:
>         mutex_unlock(&dev->kvm->lock);
> +
> +       if (!ret && !is_write)
> +               if (put_user(val, uaddr))
> +                       ret = -EFAULT;
> +
>         return ret;
>  }
>
> @@ -407,15 +417,8 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
>
>         switch (attr->group) {
>         case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
> -               u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> -               u32 reg;
> -
> -               if (get_user(reg, uaddr))
> -                       return -EFAULT;
> -
> -               return vgic_v2_attr_regs_access(dev, attr, &reg, true);
> -       }
> +       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> +               return vgic_v2_attr_regs_access(dev, attr, true);
>         }
>
>         return -ENXIO;
> @@ -432,15 +435,8 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
>
>         switch (attr->group) {
>         case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
> -               u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> -               u32 reg = 0;
> -
> -               ret = vgic_v2_attr_regs_access(dev, attr, &reg, false);
> -               if (ret)
> -                       return ret;
> -               return put_user(reg, uaddr);
> -       }
> +       case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> +               return vgic_v2_attr_regs_access(dev, attr, false);
>         }
>
>         return -ENXIO;

For vgic_v2_{set,get}_attr(), perhaps it might be even simpler
to call vgic_{set,get}_common_attr() from the "default" case
of "switch (attr->group)".
This is not directly related to this patch though:)

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
