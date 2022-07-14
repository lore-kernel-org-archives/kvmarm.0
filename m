Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED74EC43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 06:37:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 786B84C52D;
	Thu, 14 Jul 2022 02:37:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t0+HNY6hvlhv; Thu, 14 Jul 2022 02:37:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56B1C4C58D;
	Thu, 14 Jul 2022 02:37:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA90A4C549
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 02:37:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nnGtoiU-vYb8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 02:37:41 -0400 (EDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com
 [209.85.222.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FC614C52D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 02:37:41 -0400 (EDT)
Received: by mail-ua1-f53.google.com with SMTP id y11so303486uae.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2022 23:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=DoVVtteCv4PUdu2G1ggr00c8VWMSSFxt1TEptKxuTW0=;
 b=Yg7QG1MA5dRaGXwsjWXPgTpypAjgPETFU7n6Jm4ywkPPo+Wa4E2b9TFyWSvmxA22Ae
 l1HqtI2r1ZNVtT3iNHNDC3NB1koFzAsjug1KCmJeh6SJLwqRsaRP44IaCJqs+yyal8G8
 0TgwJCktxgm1BscDmwHnWfLFwzOj8DC/Wiqj86/dcy6DRQOfr6C1llH8MHZuKdlokBwe
 ssIzCowpwUoZntN+LJlVhe1cYIPyUcIuMDNPhXQ+9M+GZ3RJNWEyArUG5N2c4mM3ZzC4
 eP+PxiQjaVdxl0FisOInGcR9VreKxlvU1aKZMsXGP8lxWx/sUvUjfwKtW539PlRiKiAQ
 RRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=DoVVtteCv4PUdu2G1ggr00c8VWMSSFxt1TEptKxuTW0=;
 b=RwjVmlzBq/qoT59nJcUJEjsBzwHX7XwkYHWpBI1q3A0MrliYe0UWTbnLaVcEKGiu8b
 lJ8lDOGSEmKqSdo15dshzjmahQ/rBh7B2ySTf7izfSQapvxVbtBGAoJdhhkXnAQ+i+8z
 Mx5XDNeiMCsOTB5nO6R1TVVVcw7UxSc0J+uS9tle2ytC75CUjY3K9I93Bq9ZuLtLuGJU
 JKoV2tKbRHVvnMv79pzo+ef0bJg+nyAMhR/10qDsIMmqXIO2in9NZqSJn1watznzP36E
 WHkiUfFJ4PmI0E+xczPjFcWowXPLwiq2x8ADZQIatZxqnGYUj2NYSwiUYwrwf2YZ4Kg5
 4rAw==
X-Gm-Message-State: AJIora8NrIRxuLsmP2Y88cyK62hETiDsSOXtg2ZiKvVz+HNAx2NsKaFq
 6I7sdSOFqY+OIF4QCk61egPdMNwTVKEV+9rUELeYew==
X-Google-Smtp-Source: AGRyM1s39uG0oWTCljT/mPbeadx0K3bCVGNfETvY7O8txNbSc94KoOZxiE3kiHQYjB/J8zgxbRy/Ec0mR83I7hT0oq0=
X-Received: by 2002:ab0:63cf:0:b0:382:90bb:5c29 with SMTP id
 i15-20020ab063cf000000b0038290bb5c29mr2879964uap.51.1657780660825; Wed, 13
 Jul 2022 23:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-16-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-16-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 13 Jul 2022 23:37:25 -0700
Message-ID: <CAAeT=FzgBpwcf7oEGeCLCHO+XadP+i7vyPFWx6VJxmiWC94-7g@mail.gmail.com>
Subject: Re: [PATCH 15/19] KVM: arm64: vgic-v2: Add helper for legacy
 dist/cpuif base address setting
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
> We carry a legacy interface to set the base addresses for GICv2.
> As this is currently plumbed into the same handling code as
> the modern interface, it limits the evolution we can make there.
>
> Add a helper dedicated to this handling, with a view of maybe
> removing this in the future.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c                  | 11 ++-------
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 32 +++++++++++++++++++++++++++
>  include/kvm/arm_vgic.h                |  1 +
>  3 files changed, 35 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 83a7f61354d3..bf39570c0aef 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1414,18 +1414,11 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>                                         struct kvm_arm_device_addr *dev_addr)
>  {
> -       unsigned long dev_id, type;
> -
> -       dev_id = (dev_addr->id & KVM_ARM_DEVICE_ID_MASK) >>
> -               KVM_ARM_DEVICE_ID_SHIFT;
> -       type = (dev_addr->id & KVM_ARM_DEVICE_TYPE_MASK) >>
> -               KVM_ARM_DEVICE_TYPE_SHIFT;
> -
> -       switch (dev_id) {
> +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {
>         case KVM_ARM_DEVICE_VGIC_V2:
>                 if (!vgic_present)
>                         return -ENXIO;
> -               return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
> +               return kvm_set_legacy_vgic_v2_addr(kvm, dev_addr);
>         default:
>                 return -ENODEV;
>         }
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index fbbd0338c782..0dfd277b9058 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -41,6 +41,38 @@ static int vgic_check_type(struct kvm *kvm, int type_needed)
>                 return 0;
>  }
>
> +int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr)
> +{
> +       struct vgic_dist *vgic = &kvm->arch.vgic;
> +       int r;
> +
> +       mutex_lock(&kvm->lock);
> +       switch (FIELD_GET(KVM_ARM_DEVICE_ID_MASK, dev_addr->id)) {

Shouldn't this be KVM_ARM_DEVICE_TYPE_MASK (not KVM_ARM_DEVICE_ID_MASK) ?

Thank you,
Reiji


> +       case KVM_VGIC_V2_ADDR_TYPE_DIST:
> +               r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
> +               if (!r)
> +                       r = vgic_check_iorange(kvm, vgic->vgic_dist_base, dev_addr->addr,
> +                                              SZ_4K, KVM_VGIC_V2_DIST_SIZE);
> +               if (!r)
> +                       vgic->vgic_dist_base = dev_addr->addr;
> +               break;
> +       case KVM_VGIC_V2_ADDR_TYPE_CPU:
> +               r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
> +               if (!r)
> +                       r = vgic_check_iorange(kvm, vgic->vgic_cpu_base, dev_addr->addr,
> +                                              SZ_4K, KVM_VGIC_V2_CPU_SIZE);
> +               if (!r)
> +                       vgic->vgic_cpu_base = dev_addr->addr;
> +               break;
> +       default:
> +               r = -ENODEV;
> +       }
> +
> +       mutex_unlock(&kvm->lock);
> +
> +       return r;
> +}
> +
>  /**
>   * kvm_vgic_addr - set or get vgic VM base addresses
>   * @kvm:   pointer to the vm struct
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 2d8f2e90edc2..f79cce67563e 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -365,6 +365,7 @@ extern struct static_key_false vgic_v2_cpuif_trap;
>  extern struct static_key_false vgic_v3_cpuif_trap;
>
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> +int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
>  void kvm_vgic_early_init(struct kvm *kvm);
>  int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
>  int kvm_vgic_create(struct kvm *kvm, u32 type);
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
