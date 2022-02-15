Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6635CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 05:34:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D10B940C94;
	Tue, 15 Feb 2022 00:34:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uM4+W3W5x5ex; Tue, 15 Feb 2022 00:34:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD2C40D26;
	Tue, 15 Feb 2022 00:34:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3199B40D0B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 00:34:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jKyKz0CTspkt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Feb 2022 00:34:48 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41DA740C02
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 00:34:48 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id c3so12277757pls.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 21:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pEGYpK2WTUlNo49K4aOabZchrFLXXj+UJFJyyQaWWLY=;
 b=c1IRU79OBWKmKVvHoZ657hn+BIOvnKaFDOysbBwvV1swwtxP2CzvWpMYFodZL7pyXe
 DZdKduKDBeOlfW9Lb5I3y5oMliiCCQHJtBBYyAzvBsovMwky8eFOtXXrRSb2f/UiLJFH
 OlNH9sv0czL3LubU8biAy8Q9UWVE5CdP+DXfR4VteUQ24CXsfid1iYzKljLWfZRN+KrE
 E24ugnb+6K145mMZy34gogpxb7w5CV8p4xy+jAnSkHmLEIB5c3YBzxumctv4t6J43Sox
 dssSloNguYubuE7EjQLBJPECjxUQMB6ao7LjLbELAuC2BvMwX3VPQl1jOUxp9imd8rEc
 q25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pEGYpK2WTUlNo49K4aOabZchrFLXXj+UJFJyyQaWWLY=;
 b=UXzocpiKudc6gS7F+d6q6gFccIAuW5vf1lXxWpawRmNbKOm668eSb3v2GMC1LoGYzN
 8//AQOQGQEo3VcryWdaztq1A+9uM9spr9aN5n0+Dq55GuhbF1gNEP/wxhKAkv6v6Bw/G
 qxCFBETdT4EUUHfJndJUH1vnHOLX8/E2HbsNExGQm1KI9LZUemE2gA+KYFpDHavzzUR/
 GyUlW6+NoPywAKr/UtxrSBwBt9gw0gyoREC9Xoa5Z4EuDliQGrDqyzeGUvSxxAh/Eb58
 MBzNMXk/0U9yL/NqqdCYQY4Ee4I8FuHIwLbRK9FhMOIUz1+m5plTXyZn/RQDGHe8xuhx
 GHyw==
X-Gm-Message-State: AOAM531fR8kWAUTpsq4XA8v33pkP0s1xQh43W7qmDzeCWibxd5QTq9nz
 byQCluL4JXIAQiPBdIdzSzhkAB0NHfM1vdVwCfns8Q==
X-Google-Smtp-Source: ABdhPJwTIc9T/alHiSxZa2YiPqqJGthvxTNntB2RDakGFxaxfT81PxoYoEvPkoTvCJhvou+qhX+H9SUOI+CN9YfRjww=
X-Received: by 2002:a17:90b:4f43:: with SMTP id
 pj3mr2553859pjb.9.1644903286999; 
 Mon, 14 Feb 2022 21:34:46 -0800 (PST)
MIME-Version: 1.0
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-2-alexandru.elisei@arm.com>
In-Reply-To: <20211117153842.302159-2-alexandru.elisei@arm.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 14 Feb 2022 21:34:30 -0800
Message-ID: <CAAeT=Fyy-DNg_uYPJFQopgc+h2VgOzeoZZLt5MByj7hgq1BGww@mail.gmail.com>
Subject: Re: [RFC PATCH v5 01/38] KVM: arm64: Make lock_all_vcpus() available
 to the rest of KVM
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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

Hi Alex,

On Wed, Nov 17, 2021 at 7:37 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> The VGIC code uses the lock_all_vcpus() function to make sure no VCPUs are
> run while it fiddles with the global VGIC state. Move the declaration of
> lock_all_vcpus() and the corresponding unlock function into asm/kvm_host.h
> where it can be reused by other parts of KVM/arm64 and rename the functions
> to kvm_{lock,unlock}_all_vcpus() to make them more generic.
>
> Because the scope of the code potentially using the functions has
> increased, add a lockdep check that the kvm->lock is held by the caller.
> Holding the lock is necessary because otherwise userspace would be able to
> create new VCPUs and run them while the existing VCPUs are locked.
>
> No functional change intended.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h     |  3 ++
>  arch/arm64/kvm/arm.c                  | 41 ++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic-init.c       |  4 +--
>  arch/arm64/kvm/vgic/vgic-its.c        |  8 ++---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 50 ++++-----------------------
>  arch/arm64/kvm/vgic/vgic.h            |  3 --
>  6 files changed, 56 insertions(+), 53 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2a5f7f38006f..733621e41900 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -606,6 +606,9 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>
> +bool kvm_lock_all_vcpus(struct kvm *kvm);
> +void kvm_unlock_all_vcpus(struct kvm *kvm);
> +
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  #define kvm_call_hyp_nvhe(f, ...)                                              \
>         ({                                                              \
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 2f03cbfefe67..e9b4ad7b5c82 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -651,6 +651,47 @@ void kvm_arm_resume_guest(struct kvm *kvm)
>         }
>  }
>
> +/* unlocks vcpus from @vcpu_lock_idx and smaller */
> +static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> +{
> +       struct kvm_vcpu *tmp_vcpu;
> +
> +       for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> +               tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> +               mutex_unlock(&tmp_vcpu->mutex);
> +       }
> +}
> +
> +void kvm_unlock_all_vcpus(struct kvm *kvm)
> +{
> +       lockdep_assert_held(&kvm->lock);
> +       unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> +}
> +
> +/* Returns true if all vcpus were locked, false otherwise */
> +bool kvm_lock_all_vcpus(struct kvm *kvm)
> +{
> +       struct kvm_vcpu *tmp_vcpu;
> +       int c;
> +
> +       lockdep_assert_held(&kvm->lock);
> +
> +       /*
> +        * Any time a vcpu is run, vcpu_load is called which tries to grab the
> +        * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure that

Nit: vcpu_load() doesn't try to grab the vcpu->mutex, but kvm_vcpu_ioctl()
does (The original comment in lock_all_vcpus() was outdated).

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji


> +        * no other VCPUs are run and it is safe to fiddle with KVM global
> +        * state.
> +        */
> +       kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> +               if (!mutex_trylock(&tmp_vcpu->mutex)) {
> +                       unlock_vcpus(kvm, c - 1);
> +                       return false;
> +               }
> +       }
> +
> +       return true;
> +}
> +
>  static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>  {
>         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 0a06d0648970..cd045c7abde8 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -87,7 +87,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>                 return -ENODEV;
>
>         ret = -EBUSY;
> -       if (!lock_all_vcpus(kvm))
> +       if (!kvm_lock_all_vcpus(kvm))
>                 return ret;
>
>         kvm_for_each_vcpu(i, vcpu, kvm) {
> @@ -117,7 +117,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>                 INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
>
>  out_unlock:
> -       unlock_all_vcpus(kvm);
> +       kvm_unlock_all_vcpus(kvm);
>         return ret;
>  }
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 089fc2ffcb43..bc4197e87d95 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2005,7 +2005,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
>                 goto out;
>         }
>
> -       if (!lock_all_vcpus(dev->kvm)) {
> +       if (!kvm_lock_all_vcpus(dev->kvm)) {
>                 ret = -EBUSY;
>                 goto out;
>         }
> @@ -2023,7 +2023,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
>         } else {
>                 *reg = region->its_read(dev->kvm, its, addr, len);
>         }
> -       unlock_all_vcpus(dev->kvm);
> +       kvm_unlock_all_vcpus(dev->kvm);
>  out:
>         mutex_unlock(&dev->kvm->lock);
>         return ret;
> @@ -2668,7 +2668,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
>         mutex_lock(&kvm->lock);
>         mutex_lock(&its->its_lock);
>
> -       if (!lock_all_vcpus(kvm)) {
> +       if (!kvm_lock_all_vcpus(kvm)) {
>                 mutex_unlock(&its->its_lock);
>                 mutex_unlock(&kvm->lock);
>                 return -EBUSY;
> @@ -2686,7 +2686,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
>                 break;
>         }
>
> -       unlock_all_vcpus(kvm);
> +       kvm_unlock_all_vcpus(kvm);
>         mutex_unlock(&its->its_lock);
>         mutex_unlock(&kvm->lock);
>         return ret;
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 0d000d2fe8d2..c5de904643cc 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -305,44 +305,6 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
>         return 0;
>  }
>
> -/* unlocks vcpus from @vcpu_lock_idx and smaller */
> -static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> -{
> -       struct kvm_vcpu *tmp_vcpu;
> -
> -       for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> -               tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> -               mutex_unlock(&tmp_vcpu->mutex);
> -       }
> -}
> -
> -void unlock_all_vcpus(struct kvm *kvm)
> -{
> -       unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> -}
> -
> -/* Returns true if all vcpus were locked, false otherwise */
> -bool lock_all_vcpus(struct kvm *kvm)
> -{
> -       struct kvm_vcpu *tmp_vcpu;
> -       int c;
> -
> -       /*
> -        * Any time a vcpu is run, vcpu_load is called which tries to grab the
> -        * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
> -        * that no other VCPUs are run and fiddle with the vgic state while we
> -        * access it.
> -        */
> -       kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> -               if (!mutex_trylock(&tmp_vcpu->mutex)) {
> -                       unlock_vcpus(kvm, c - 1);
> -                       return false;
> -               }
> -       }
> -
> -       return true;
> -}
> -
>  /**
>   * vgic_v2_attr_regs_access - allows user space to access VGIC v2 state
>   *
> @@ -373,7 +335,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>         if (ret)
>                 goto out;
>
> -       if (!lock_all_vcpus(dev->kvm)) {
> +       if (!kvm_lock_all_vcpus(dev->kvm)) {
>                 ret = -EBUSY;
>                 goto out;
>         }
> @@ -390,7 +352,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
>                 break;
>         }
>
> -       unlock_all_vcpus(dev->kvm);
> +       kvm_unlock_all_vcpus(dev->kvm);
>  out:
>         mutex_unlock(&dev->kvm->lock);
>         return ret;
> @@ -539,7 +501,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>                 goto out;
>         }
>
> -       if (!lock_all_vcpus(dev->kvm)) {
> +       if (!kvm_lock_all_vcpus(dev->kvm)) {
>                 ret = -EBUSY;
>                 goto out;
>         }
> @@ -589,7 +551,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>                 break;
>         }
>
> -       unlock_all_vcpus(dev->kvm);
> +       kvm_unlock_all_vcpus(dev->kvm);
>  out:
>         mutex_unlock(&dev->kvm->lock);
>         return ret;
> @@ -644,12 +606,12 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>                 case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
>                         mutex_lock(&dev->kvm->lock);
>
> -                       if (!lock_all_vcpus(dev->kvm)) {
> +                       if (!kvm_lock_all_vcpus(dev->kvm)) {
>                                 mutex_unlock(&dev->kvm->lock);
>                                 return -EBUSY;
>                         }
>                         ret = vgic_v3_save_pending_tables(dev->kvm);
> -                       unlock_all_vcpus(dev->kvm);
> +                       kvm_unlock_all_vcpus(dev->kvm);
>                         mutex_unlock(&dev->kvm->lock);
>                         return ret;
>                 }
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 3fd6c86a7ef3..e69c839a6941 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -255,9 +255,6 @@ int vgic_init(struct kvm *kvm);
>  void vgic_debug_init(struct kvm *kvm);
>  void vgic_debug_destroy(struct kvm *kvm);
>
> -bool lock_all_vcpus(struct kvm *kvm);
> -void unlock_all_vcpus(struct kvm *kvm);
> -
>  static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
>  {
>         struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
> --
> 2.33.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
