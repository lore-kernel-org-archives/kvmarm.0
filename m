Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4133D35B657
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529486; cv=pass; b=mfDFyDgZ4wPc7f2+9qS0ZWD/VM9I6KsdhKJx/vBtOie82ds0WF9iZFlnqj/MidKJ+5dha8HsCgBiubPxO+eQzT57b6FrdBCAAE0opWuskG1G4NFBn0aIXv73ysYAIQnJ1Nf6EUtHH/D0wfj/+d8MAunS31jIt4tosu/IcqX6aZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529486; c=relaxed/simple;
	bh=1oa3YMbrVxkiZ/30mG+3GDu/6TBi8y+ceAv7iSoePXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZU8vBq+MwZs9SYnlHNskYZFNu8+m+fnfnDca1tRMe3dI6n/0u2uV11XbFGI94GD5JRxgSzZIdJ7i+GUwlTt7OkJTVqPxRIYDKVORuoGlgCaK9TUHjNGXmfvxNf6A57eUQe7DifvaIzu08m1PmGKdwmQgbIL8Du44baUlhEJLBaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UZx98Sba; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UZx98Sba"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51765331535so943051cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:18:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781529483; cv=none;
        d=google.com; s=arc-20240605;
        b=QEhS0SKmePDu4M0OPw9rEX7+DJpAI0Nrqis3WMYTsvSoDZ/ha8HKY4ryOnPlbf+mLD
         qSJtRDMc3U6AHs0N1JIq9UuGK9jf4IHj+AwUEanM6KLRjorHhLEQs7+Bg7EVxKbuwjx4
         S8ax7bruLFrHCdQo0YZJcSbkOuIOiYBBbSPO0Fqu+Q53l8MJCARCx8moqtWtQHNvty1o
         JFccwd2DiabU1iMq5F+ckqxGVxvZpXll8OME4H3xJUCAAW6BlAF7tTE/2+6JKWyKfYop
         M3zgV2z2NBZOMcx8989tFCNZgSX7CeMc1vqJH2zd/K4ZhwfBHh/ll44rJHT8d9nOMrYT
         INNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uXiQUtZeQmAEP0ZEmjMWqTXf4XIHOoKpgb4lVMRg2uA=;
        fh=bFrLFxVzR/s2hFKSBbfe1PNkrBlmymvPmy0b6Pu1nMQ=;
        b=AsgQRXcSST/Bq/95ObanLRnZiXAMLTIsJl3wCuj5WKs5JsOvvowkkD35PmSa0t3Bzj
         Ey7TfPzWolfPbRaptE5piIfOl84izB9hgv2zC2tl7hfHbdsN2d75E9E3ra785BjgMDhY
         d1NZl6qf8wlZ+omzCDPtjahFoAQ+DtGzwzd1YIG/eid13Lte/A2C9fD5sQgaAqniWCjg
         uHtuMYTv0UigYHNChrJ94Kaptt0B2xVPIVpas8lsYgDk4+7AjUgXIYGNZhPJckTeOzSP
         1ZCR1l7G4FRUYgwOLcMFfoPaHNK7tL0ul9V/XwbE/qLb3HCz5YzFEeLqTQf1eJB9vmlb
         ceaQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781529483; x=1782134283; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uXiQUtZeQmAEP0ZEmjMWqTXf4XIHOoKpgb4lVMRg2uA=;
        b=UZx98SbaI6M3fvcKQzc5QgtKJgF6icEoKElY6FdGLJcdoDs7tsw3meYuAfeEHZCzmf
         kisnH4EZRkUtPTdNcEE5gP9iHipvWIp/mzN/b8eeWMfKBgQNIJhZ5kSkEmjMFicZP+Jb
         nzYN/mldNw3kBlSWJ9qHnVUD2VutFIFJjK1Q1is6lyp7eSyS150BDVP+tidLhtj765kg
         QKlIkdpPquScfSSU9ruPc4NgifVP+ws96FrD+77a9RUWiF/rLNv5gWN01APJ4eYSkOWI
         SuhvTdcWRmeh05BwSTaxsc/LjqfS+GFVRego8NcwOGRduqpjS4tZ1pkHp5OKASxcjpQI
         WVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529483; x=1782134283;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXiQUtZeQmAEP0ZEmjMWqTXf4XIHOoKpgb4lVMRg2uA=;
        b=dI+phxGTZuqo/ZaHheqLBNpi01BfVu7Hv8cRCVyG+qnFwXYMsXG2jx1hOiSH1d/X8D
         bAwH63L3+P61Q2L1WuunVvUmbcQxxgNVnwfKnsYs9qRqANgpg9cQMkq4Gf/+YHq8wMRq
         w/05mjH3dHD1E7tlcv4Avr1LcrTwvjhP9t/GsejdRioDQb6RNXwFZ4qxNYLwLxXeVWhA
         WHIVbCwdWVb4/fZg6tgaHmRtmN1Y14EkG+UoPBPq31CiJYyN0xYUjiMkpsE1tzyfgzDK
         BvgnNM8Ocid1nB7qPKCNfqYtltET1qIl4rVYKVeaF8U4vOQd5Dua1R0ZrnpTAOjJZUq2
         kUEw==
X-Forwarded-Encrypted: i=1; AFNElJ/0CtbCVfWPTBkE58V5AHxKeUOkja2gETY5/heBvF6f5t+OrZxRsVt4YMJ5oNCxxcAdyfr5ugM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/XAokkoJw5uqSBxu71e7uQ+71PkWPuw5C57VpXDTFLMjJhChV
	dxV9BH/rM6p8vLBNhykxbBz4AbiBflmPDFOVVjpcn+wTr6kCT36lGjV0NZXDaG+kXZ/YrtaQlA4
	toVz+J5bWlQx1A1lDEzIKhG1gjq+FJGAFwOlXoOKzu7F7jAQJKHYAExED9pU=
X-Gm-Gg: Acq92OGhruTu1LBOnFvfTdK0jcmpuDyCuClcGG0h4F9DAc1GH5+gVpc055Wa5/2mRa8
	YaTCNWYv0t4Zs7CCCYqZZ85TIA3J7iTL2FtxLSV/9RJbXxaE5dn6Sbxnhp69Yo+YNXpCkdGEbct
	ZuOKMsHshfIeS+PkpIZteVEhnggXvu+eFO0vkNR7Z/MM/KK5NnqRTgUbKlLPSt2i7XZ8Dz8D2nx
	aMoaC2xFXGY5Amnz35hhG31zm45cC+CoAFG0WpliN1+n1tsCVORmxnuQl5ecc/Ip3xCZ77Jx3J0
	DMN1ljV9
X-Received: by 2002:a05:622a:248e:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-519872e7656mr1540691cf.2.1781529482065; Mon, 15 Jun 2026
 06:18:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-4-tabba@google.com>
 <ai_3Hlf8CakQ7ESQ@google.com>
In-Reply-To: <ai_3Hlf8CakQ7ESQ@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 14:17:25 +0100
X-Gm-Features: AVVi8CeyrAKW-cv791O6i-EeRBkuB2A92LrYUKT1_oKuiNIQXb3fwr9dG8LEDbA
Message-ID: <CA+EHjTxxGChwio0tQym5VEHCUbC8yjzVZbNuzz5qN9V=WWApKw@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] KVM: arm64: Use guard()/scoped_guard() in arm64
 KVM EL1 code
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Per Larsen <perlarsen@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 13:59, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, Jun 12, 2026 at 07:59:17AM +0100, tabba@google.com wrote:
> > Convert the manual mutex_lock()/spin_lock() pairs in
> > arch/arm64/kvm/{pkvm,arm,mmu,reset,psci}.c to guard(mutex),
> > guard(spinlock) and scoped_guard(), dropping unlock-only goto labels in
> > favour of direct returns. Centralised cleanup gotos that still serve
> > other resources are preserved.
> >
> > reset.c uses scoped_guard() rather than guard() so the lock covers only
> > the small read/update window inside kvm_reset_vcpu(), leaving the rest
> > of the function outside the critical section.
>
> I believe in that case unless it really helps with cleaning resources, there's
> not much point using scoped_guard().
>
> I would keep it as is.

Ack.

>
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/arm.c   | 14 +++-----
> >  arch/arm64/kvm/mmu.c   | 80 +++++++++++++++---------------------------
> >  arch/arm64/kvm/pkvm.c  | 26 ++++++--------
> >  arch/arm64/kvm/psci.c  | 17 ++++-----
> >  arch/arm64/kvm/reset.c |  8 ++---
> >  5 files changed, 53 insertions(+), 92 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 9453321ef8c6..c9f36932c980 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -793,9 +793,7 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> >  int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >                                   struct kvm_mp_state *mp_state)
> >  {
> > -     int ret = 0;
> > -
> > -     spin_lock(&vcpu->arch.mp_state_lock);
> > +     guard(spinlock)(&vcpu->arch.mp_state_lock);
> >
> >       switch (mp_state->mp_state) {
> >       case KVM_MP_STATE_RUNNABLE:
> > @@ -808,12 +806,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> >               kvm_arm_vcpu_suspend(vcpu);
> >               break;
> >       default:
> > -             ret = -EINVAL;
> > +             return -EINVAL;
> >       }
> >
> > -     spin_unlock(&vcpu->arch.mp_state_lock);
> > -
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  /**
> > @@ -1726,15 +1722,13 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
> >       /*
> >        * Handle the "start in power-off" case.
> >        */
> > -     spin_lock(&vcpu->arch.mp_state_lock);
> > +     guard(spinlock)(&vcpu->arch.mp_state_lock);
> >
> >       if (power_off)
> >               __kvm_arm_vcpu_power_off(vcpu);
> >       else
> >               WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
> >
> > -     spin_unlock(&vcpu->arch.mp_state_lock);
> > -
> >       return 0;
> >  }
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 4da9281312eb..d18f4ce7ceae 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -391,13 +391,13 @@ static void stage2_flush_vm(struct kvm *kvm)
> >   */
> >  void __init free_hyp_pgds(void)
> >  {
> > -     mutex_lock(&kvm_hyp_pgd_mutex);
> > -     if (hyp_pgtable) {
> > -             kvm_pgtable_hyp_destroy(hyp_pgtable);
> > -             kfree(hyp_pgtable);
> > -             hyp_pgtable = NULL;
> > -     }
> > -     mutex_unlock(&kvm_hyp_pgd_mutex);
> > +     guard(mutex)(&kvm_hyp_pgd_mutex);
> > +     if (!hyp_pgtable)
> > +             return;
> > +
> > +     kvm_pgtable_hyp_destroy(hyp_pgtable);
> > +     kfree(hyp_pgtable);
> > +     hyp_pgtable = NULL;
> >  }
> >
> >  static bool kvm_host_owns_hyp_mappings(void)
> > @@ -424,16 +424,11 @@ static bool kvm_host_owns_hyp_mappings(void)
> >  int __create_hyp_mappings(unsigned long start, unsigned long size,
> >                         unsigned long phys, enum kvm_pgtable_prot prot)
> >  {
> > -     int err;
> > -
> >       if (WARN_ON(!kvm_host_owns_hyp_mappings()))
> >               return -EINVAL;
> >
> > -     mutex_lock(&kvm_hyp_pgd_mutex);
> > -     err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
> > -     mutex_unlock(&kvm_hyp_pgd_mutex);
> > -
> > -     return err;
> > +     guard(mutex)(&kvm_hyp_pgd_mutex);
> > +     return kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
> >  }
> >
> >  static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
> > @@ -481,56 +476,42 @@ static int share_pfn_hyp(u64 pfn)
> >  {
> >       struct rb_node **node, *parent;
> >       struct hyp_shared_pfn *this;
> > -     int ret = 0;
> >
> > -     mutex_lock(&hyp_shared_pfns_lock);
> > +     guard(mutex)(&hyp_shared_pfns_lock);
> >       this = find_shared_pfn(pfn, &node, &parent);
> >       if (this) {
> >               this->count++;
> > -             goto unlock;
> > +             return 0;
> >       }
> >
> >       this = kzalloc_obj(*this);
> > -     if (!this) {
> > -             ret = -ENOMEM;
> > -             goto unlock;
> > -     }
> > +     if (!this)
> > +             return -ENOMEM;
> >
> >       this->pfn = pfn;
> >       this->count = 1;
> >       rb_link_node(&this->node, parent, node);
> >       rb_insert_color(&this->node, &hyp_shared_pfns);
> > -     ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
> > -unlock:
> > -     mutex_unlock(&hyp_shared_pfns_lock);
> > -
> > -     return ret;
> > +     return kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
> >  }
> >
> >  static int unshare_pfn_hyp(u64 pfn)
> >  {
> >       struct rb_node **node, *parent;
> >       struct hyp_shared_pfn *this;
> > -     int ret = 0;
> >
> > -     mutex_lock(&hyp_shared_pfns_lock);
> > +     guard(mutex)(&hyp_shared_pfns_lock);
> >       this = find_shared_pfn(pfn, &node, &parent);
> > -     if (WARN_ON(!this)) {
> > -             ret = -ENOENT;
> > -             goto unlock;
> > -     }
> > +     if (WARN_ON(!this))
> > +             return -ENOENT;
> >
> >       this->count--;
> >       if (this->count)
> > -             goto unlock;
> > +             return 0;
> >
> >       rb_erase(&this->node, &hyp_shared_pfns);
> >       kfree(this);
> > -     ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
> > -unlock:
> > -     mutex_unlock(&hyp_shared_pfns_lock);
> > -
> > -     return ret;
> > +     return kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
> >  }
> >
> >  int kvm_share_hyp(void *from, void *to)
> > @@ -655,7 +636,7 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
> >       unsigned long base;
> >       int ret = 0;
> >
> > -     mutex_lock(&kvm_hyp_pgd_mutex);
> > +     guard(mutex)(&kvm_hyp_pgd_mutex);
> >
> >       /*
> >        * This assumes that we have enough space below the idmap
> > @@ -670,8 +651,6 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
> >       base = io_map_base - size;
> >       ret = __hyp_alloc_private_va_range(base);
> >
> > -     mutex_unlock(&kvm_hyp_pgd_mutex);
> > -
> >       if (!ret)
> >               *haddr = base;
> >
> > @@ -714,17 +693,16 @@ int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr)
> >       size_t size;
> >       int ret;
> >
> > -     mutex_lock(&kvm_hyp_pgd_mutex);
> > -     /*
> > -      * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
> > -      * an alignment of our allocation on the order of the size.
> > -      */
> > -     size = NVHE_STACK_SIZE * 2;
> > -     base = ALIGN_DOWN(io_map_base - size, size);
> > +     scoped_guard(mutex, &kvm_hyp_pgd_mutex) {
> > +             /*
> > +              * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
> > +              * an alignment of our allocation on the order of the size.
> > +              */
> > +             size = NVHE_STACK_SIZE * 2;
> > +             base = ALIGN_DOWN(io_map_base - size, size);
> >
> > -     ret = __hyp_alloc_private_va_range(base);
> > -
> > -     mutex_unlock(&kvm_hyp_pgd_mutex);
> > +             ret = __hyp_alloc_private_va_range(base);
> > +     }
>
> Not sure about that one, it's not shorter, doesn't remove any label but add
> a tab.

Ack.


>
> >
> >       if (ret) {
> >               kvm_err("Cannot allocate hyp stack guard page\n");
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 053e4f733e4b..a39111b70f9f 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -190,39 +190,33 @@ bool pkvm_hyp_vm_is_created(struct kvm *kvm)
> >
> >  int pkvm_create_hyp_vm(struct kvm *kvm)
> >  {
> > -     int ret = 0;
> > -
> >       /*
> >        * Synchronise with kvm_arch_prepare_memory_region(), as we
> >        * prevent memslot modifications on a pVM that has been run.
> >        */
> > -     mutex_lock(&kvm->slots_lock);
> > -     mutex_lock(&kvm->arch.config_lock);
> > -     if (!pkvm_hyp_vm_is_created(kvm))
> > -             ret = __pkvm_create_hyp_vm(kvm);
> > -     mutex_unlock(&kvm->arch.config_lock);
> > -     mutex_unlock(&kvm->slots_lock);
> > +     guard(mutex)(&kvm->slots_lock);
> > +     guard(mutex)(&kvm->arch.config_lock);
> >
> > -     return ret;
> > +     if (!pkvm_hyp_vm_is_created(kvm))
> > +             return __pkvm_create_hyp_vm(kvm);
> > +
> > +     return 0;
> >  }
> >
> >  int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
> >  {
> > -     int ret = 0;
> > +     guard(mutex)(&vcpu->kvm->arch.config_lock);
> >
> > -     mutex_lock(&vcpu->kvm->arch.config_lock);
> >       if (!vcpu_get_flag(vcpu, VCPU_PKVM_FINALIZED))
> > -             ret = __pkvm_create_hyp_vcpu(vcpu);
> > -     mutex_unlock(&vcpu->kvm->arch.config_lock);
> > +             return __pkvm_create_hyp_vcpu(vcpu);
> >
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  void pkvm_destroy_hyp_vm(struct kvm *kvm)
> >  {
> > -     mutex_lock(&kvm->arch.config_lock);
> > +     guard(mutex)(&kvm->arch.config_lock);
> >       __pkvm_destroy_hyp_vm(kvm);
> > -     mutex_unlock(&kvm->arch.config_lock);
> >  }
> >
> >  int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index 3b5dbe9a0a0e..e1389c525e9d 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -62,7 +62,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >       struct vcpu_reset_state *reset_state;
> >       struct kvm *kvm = source_vcpu->kvm;
> >       struct kvm_vcpu *vcpu = NULL;
> > -     int ret = PSCI_RET_SUCCESS;
> >       unsigned long cpu_id;
> >
> >       cpu_id = smccc_get_arg1(source_vcpu);
> > @@ -78,14 +77,13 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >       if (!vcpu)
> >               return PSCI_RET_INVALID_PARAMS;
> >
> > -     spin_lock(&vcpu->arch.mp_state_lock);
> > +     guard(spinlock)(&vcpu->arch.mp_state_lock);
> > +
> >       if (!kvm_arm_vcpu_stopped(vcpu)) {
> >               if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
> > -                     ret = PSCI_RET_ALREADY_ON;
> > +                     return PSCI_RET_ALREADY_ON;
> >               else
> > -                     ret = PSCI_RET_INVALID_PARAMS;
> > -
> > -             goto out_unlock;
> > +                     return PSCI_RET_INVALID_PARAMS;
> >       }
> >
> >       reset_state = &vcpu->arch.reset_state;
> > @@ -113,9 +111,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >       WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
> >       kvm_vcpu_wake_up(vcpu);
> >
> > -out_unlock:
> > -     spin_unlock(&vcpu->arch.mp_state_lock);
> > -     return ret;
> > +     return PSCI_RET_SUCCESS;
> >  }
> >
> >  static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
> > @@ -176,9 +172,8 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
> >        * re-initialized.
> >        */
> >       kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> > -             spin_lock(&tmp->arch.mp_state_lock);
> > +             guard(spinlock)(&tmp->arch.mp_state_lock);
> >               WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
> > -             spin_unlock(&tmp->arch.mp_state_lock);
> >       }
> >       kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
> >
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index b963fd975aac..60969d90bdd3 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -193,10 +193,10 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >       bool loaded;
> >       u32 pstate;
> >
> > -     spin_lock(&vcpu->arch.mp_state_lock);
> > -     reset_state = vcpu->arch.reset_state;
> > -     vcpu->arch.reset_state.reset = false;
> > -     spin_unlock(&vcpu->arch.mp_state_lock);
> > +     scoped_guard(spinlock, &vcpu->arch.mp_state_lock) {
> > +             reset_state = vcpu->arch.reset_state;
> > +             vcpu->arch.reset_state.reset = false;
> > +     }
>
> Same, I don't find this one really interesting.

Ack.

Thanks!
/fuad

>
> >
> >       preempt_disable();
> >       loaded = (vcpu->cpu != -1);
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
