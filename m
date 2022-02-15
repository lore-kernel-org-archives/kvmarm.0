Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45650C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Feb 2022 10:34:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADBFD40FD8;
	Tue, 15 Feb 2022 05:34:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z6lVEEv4ob+l; Tue, 15 Feb 2022 05:34:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5E8E40CF5;
	Tue, 15 Feb 2022 05:34:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112B940B59
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 05:34:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k+JP6nwXWU5q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Feb 2022 05:34:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4C7240B41
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 05:34:18 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C3D21063;
 Tue, 15 Feb 2022 02:34:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 716B33F66F;
 Tue, 15 Feb 2022 02:34:15 -0800 (PST)
Date: Tue, 15 Feb 2022 10:34:30 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v5 01/38] KVM: arm64: Make lock_all_vcpus() available
 to the rest of KVM
Message-ID: <YguBtoUfy6Hkygt4@monolith.localdoman>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-2-alexandru.elisei@arm.com>
 <CAAeT=Fyy-DNg_uYPJFQopgc+h2VgOzeoZZLt5MByj7hgq1BGww@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fyy-DNg_uYPJFQopgc+h2VgOzeoZZLt5MByj7hgq1BGww@mail.gmail.com>
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

Hi Reiji,

On Mon, Feb 14, 2022 at 09:34:30PM -0800, Reiji Watanabe wrote:
> Hi Alex,
> 
> On Wed, Nov 17, 2021 at 7:37 AM Alexandru Elisei
> <alexandru.elisei@arm.com> wrote:
> >
> > The VGIC code uses the lock_all_vcpus() function to make sure no VCPUs are
> > run while it fiddles with the global VGIC state. Move the declaration of
> > lock_all_vcpus() and the corresponding unlock function into asm/kvm_host.h
> > where it can be reused by other parts of KVM/arm64 and rename the functions
> > to kvm_{lock,unlock}_all_vcpus() to make them more generic.
> >
> > Because the scope of the code potentially using the functions has
> > increased, add a lockdep check that the kvm->lock is held by the caller.
> > Holding the lock is necessary because otherwise userspace would be able to
> > create new VCPUs and run them while the existing VCPUs are locked.
> >
> > No functional change intended.
> >
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h     |  3 ++
> >  arch/arm64/kvm/arm.c                  | 41 ++++++++++++++++++++++
> >  arch/arm64/kvm/vgic/vgic-init.c       |  4 +--
> >  arch/arm64/kvm/vgic/vgic-its.c        |  8 ++---
> >  arch/arm64/kvm/vgic/vgic-kvm-device.c | 50 ++++-----------------------
> >  arch/arm64/kvm/vgic/vgic.h            |  3 --
> >  6 files changed, 56 insertions(+), 53 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 2a5f7f38006f..733621e41900 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -606,6 +606,9 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> >  void kvm_arm_halt_guest(struct kvm *kvm);
> >  void kvm_arm_resume_guest(struct kvm *kvm);
> >
> > +bool kvm_lock_all_vcpus(struct kvm *kvm);
> > +void kvm_unlock_all_vcpus(struct kvm *kvm);
> > +
> >  #ifndef __KVM_NVHE_HYPERVISOR__
> >  #define kvm_call_hyp_nvhe(f, ...)                                              \
> >         ({                                                              \
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 2f03cbfefe67..e9b4ad7b5c82 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -651,6 +651,47 @@ void kvm_arm_resume_guest(struct kvm *kvm)
> >         }
> >  }
> >
> > +/* unlocks vcpus from @vcpu_lock_idx and smaller */
> > +static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> > +{
> > +       struct kvm_vcpu *tmp_vcpu;
> > +
> > +       for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> > +               tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> > +               mutex_unlock(&tmp_vcpu->mutex);
> > +       }
> > +}
> > +
> > +void kvm_unlock_all_vcpus(struct kvm *kvm)
> > +{
> > +       lockdep_assert_held(&kvm->lock);
> > +       unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> > +}
> > +
> > +/* Returns true if all vcpus were locked, false otherwise */
> > +bool kvm_lock_all_vcpus(struct kvm *kvm)
> > +{
> > +       struct kvm_vcpu *tmp_vcpu;
> > +       int c;
> > +
> > +       lockdep_assert_held(&kvm->lock);
> > +
> > +       /*
> > +        * Any time a vcpu is run, vcpu_load is called which tries to grab the
> > +        * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure that
> 
> Nit: vcpu_load() doesn't try to grab the vcpu->mutex, but kvm_vcpu_ioctl()
> does (The original comment in lock_all_vcpus() was outdated).

Will change.

> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks!

Alex

> 
> Thanks,
> Reiji
> 
> 
> > +        * no other VCPUs are run and it is safe to fiddle with KVM global
> > +        * state.
> > +        */
> > +       kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> > +               if (!mutex_trylock(&tmp_vcpu->mutex)) {
> > +                       unlock_vcpus(kvm, c - 1);
> > +                       return false;
> > +               }
> > +       }
> > +
> > +       return true;
> > +}
> > +
> >  static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> >  {
> >         struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
> > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > index 0a06d0648970..cd045c7abde8 100644
> > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > @@ -87,7 +87,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
> >                 return -ENODEV;
> >
> >         ret = -EBUSY;
> > -       if (!lock_all_vcpus(kvm))
> > +       if (!kvm_lock_all_vcpus(kvm))
> >                 return ret;
> >
> >         kvm_for_each_vcpu(i, vcpu, kvm) {
> > @@ -117,7 +117,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
> >                 INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
> >
> >  out_unlock:
> > -       unlock_all_vcpus(kvm);
> > +       kvm_unlock_all_vcpus(kvm);
> >         return ret;
> >  }
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index 089fc2ffcb43..bc4197e87d95 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2005,7 +2005,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
> >                 goto out;
> >         }
> >
> > -       if (!lock_all_vcpus(dev->kvm)) {
> > +       if (!kvm_lock_all_vcpus(dev->kvm)) {
> >                 ret = -EBUSY;
> >                 goto out;
> >         }
> > @@ -2023,7 +2023,7 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
> >         } else {
> >                 *reg = region->its_read(dev->kvm, its, addr, len);
> >         }
> > -       unlock_all_vcpus(dev->kvm);
> > +       kvm_unlock_all_vcpus(dev->kvm);
> >  out:
> >         mutex_unlock(&dev->kvm->lock);
> >         return ret;
> > @@ -2668,7 +2668,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
> >         mutex_lock(&kvm->lock);
> >         mutex_lock(&its->its_lock);
> >
> > -       if (!lock_all_vcpus(kvm)) {
> > +       if (!kvm_lock_all_vcpus(kvm)) {
> >                 mutex_unlock(&its->its_lock);
> >                 mutex_unlock(&kvm->lock);
> >                 return -EBUSY;
> > @@ -2686,7 +2686,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
> >                 break;
> >         }
> >
> > -       unlock_all_vcpus(kvm);
> > +       kvm_unlock_all_vcpus(kvm);
> >         mutex_unlock(&its->its_lock);
> >         mutex_unlock(&kvm->lock);
> >         return ret;
> > diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > index 0d000d2fe8d2..c5de904643cc 100644
> > --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > @@ -305,44 +305,6 @@ int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
> >         return 0;
> >  }
> >
> > -/* unlocks vcpus from @vcpu_lock_idx and smaller */
> > -static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> > -{
> > -       struct kvm_vcpu *tmp_vcpu;
> > -
> > -       for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> > -               tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> > -               mutex_unlock(&tmp_vcpu->mutex);
> > -       }
> > -}
> > -
> > -void unlock_all_vcpus(struct kvm *kvm)
> > -{
> > -       unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> > -}
> > -
> > -/* Returns true if all vcpus were locked, false otherwise */
> > -bool lock_all_vcpus(struct kvm *kvm)
> > -{
> > -       struct kvm_vcpu *tmp_vcpu;
> > -       int c;
> > -
> > -       /*
> > -        * Any time a vcpu is run, vcpu_load is called which tries to grab the
> > -        * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
> > -        * that no other VCPUs are run and fiddle with the vgic state while we
> > -        * access it.
> > -        */
> > -       kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> > -               if (!mutex_trylock(&tmp_vcpu->mutex)) {
> > -                       unlock_vcpus(kvm, c - 1);
> > -                       return false;
> > -               }
> > -       }
> > -
> > -       return true;
> > -}
> > -
> >  /**
> >   * vgic_v2_attr_regs_access - allows user space to access VGIC v2 state
> >   *
> > @@ -373,7 +335,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
> >         if (ret)
> >                 goto out;
> >
> > -       if (!lock_all_vcpus(dev->kvm)) {
> > +       if (!kvm_lock_all_vcpus(dev->kvm)) {
> >                 ret = -EBUSY;
> >                 goto out;
> >         }
> > @@ -390,7 +352,7 @@ static int vgic_v2_attr_regs_access(struct kvm_device *dev,
> >                 break;
> >         }
> >
> > -       unlock_all_vcpus(dev->kvm);
> > +       kvm_unlock_all_vcpus(dev->kvm);
> >  out:
> >         mutex_unlock(&dev->kvm->lock);
> >         return ret;
> > @@ -539,7 +501,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> >                 goto out;
> >         }
> >
> > -       if (!lock_all_vcpus(dev->kvm)) {
> > +       if (!kvm_lock_all_vcpus(dev->kvm)) {
> >                 ret = -EBUSY;
> >                 goto out;
> >         }
> > @@ -589,7 +551,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> >                 break;
> >         }
> >
> > -       unlock_all_vcpus(dev->kvm);
> > +       kvm_unlock_all_vcpus(dev->kvm);
> >  out:
> >         mutex_unlock(&dev->kvm->lock);
> >         return ret;
> > @@ -644,12 +606,12 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
> >                 case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
> >                         mutex_lock(&dev->kvm->lock);
> >
> > -                       if (!lock_all_vcpus(dev->kvm)) {
> > +                       if (!kvm_lock_all_vcpus(dev->kvm)) {
> >                                 mutex_unlock(&dev->kvm->lock);
> >                                 return -EBUSY;
> >                         }
> >                         ret = vgic_v3_save_pending_tables(dev->kvm);
> > -                       unlock_all_vcpus(dev->kvm);
> > +                       kvm_unlock_all_vcpus(dev->kvm);
> >                         mutex_unlock(&dev->kvm->lock);
> >                         return ret;
> >                 }
> > diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> > index 3fd6c86a7ef3..e69c839a6941 100644
> > --- a/arch/arm64/kvm/vgic/vgic.h
> > +++ b/arch/arm64/kvm/vgic/vgic.h
> > @@ -255,9 +255,6 @@ int vgic_init(struct kvm *kvm);
> >  void vgic_debug_init(struct kvm *kvm);
> >  void vgic_debug_destroy(struct kvm *kvm);
> >
> > -bool lock_all_vcpus(struct kvm *kvm);
> > -void unlock_all_vcpus(struct kvm *kvm);
> > -
> >  static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
> >  {
> >         struct vgic_cpu *cpu_if = &vcpu->arch.vgic_cpu;
> > --
> > 2.33.1
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
