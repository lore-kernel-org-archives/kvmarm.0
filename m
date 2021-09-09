Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71E6C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:11:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4049461100
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 17:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4049461100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C10304B17B;
	Thu,  9 Sep 2021 13:11:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r+VyhKSmowR2; Thu,  9 Sep 2021 13:11:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E23C4B15B;
	Thu,  9 Sep 2021 13:11:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7261D4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:11:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mVnUlIo1bqh5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 13:11:09 -0400 (EDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com
 [209.85.219.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52E3B4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 13:11:09 -0400 (EDT)
Received: by mail-yb1-f169.google.com with SMTP id y16so5328652ybm.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 10:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Gt9YsGEHPd9blquFdpY+rNn/Ktkd0FJBPDXVSwWfzVA=;
 b=mBPX6UaRDah3B9oEWW40eU8dcRn8RO27Gpz202oHuPyfN6E2FVjsIyHQoLooajZXzz
 WKvlB4pyuqZBiH941evKKdmhjzotDrTrIRW9b+f/vYXimmZkfY6Pw5n/D8soGbl93xhg
 6nVfZ8UUE5zyPdNVLOU4y4m7Lgi9SEHC2RqUhV/PzfFnjly+5Q33ymAQTsfyG1DjjyJs
 qfW+e20g4OTXBCKsm7HSZ0jOHZHeavkx+lNQd6d463MFJZOUwDO9DaXCzYCYcrQoiupo
 vm8+36L8qF8U0YQ4dc4r38X0yCdYMJT5QcfnRv563cdHCRSyVu1FKpPWoKabCSgssWOu
 i0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Gt9YsGEHPd9blquFdpY+rNn/Ktkd0FJBPDXVSwWfzVA=;
 b=oSMR3HNPquODwixYDV4hbXF1Xc6VlnG4L3siaq1bCRzWHbaHMLghRKMI9vt/GJlN+f
 4K9VxDLURbMA50I2m63OdwnsDPytZDPJShj6XFqsFhKrBvDlWgonZfmy8I3+3p1zpOgp
 crPQKiGUFvLwy+1Br842n9H+/kW9xB8T5hCdplrkJjZ71/TVqMO75zDN6pR87nTOWcAg
 24ZnhhjTFImOZtlz0LXf2UQhceJRYs1IKWlalnTw7p2yODMIi0WqVPQI/S8g6VrFORrM
 CXE+9LT9KdNGQrpbd92NYNhUm91/rwFADjV11uiYHvcqJwr+adYaIV2jlDcLoObgnbKy
 kLug==
X-Gm-Message-State: AOAM531L7AKEiMKcAHfnBymejfjIZAqbFOFpFeI2hYFHLc1Wjt40AObX
 Nyo8ste30vwEuQRTK0wzypEWu+iI40sX5wIZ3QF+Rw==
X-Google-Smtp-Source: ABdhPJyjeZVZ5OBHHfB/gVgbY4kEHNdlHJNCyRZ8a5HkSMk3+pNJRkf1F8zHY9JBbnAAyeMDADYnnps15uTm9MTGWF8=
X-Received: by 2002:a25:1c09:: with SMTP id c9mr5447528ybc.350.1631207468411; 
 Thu, 09 Sep 2021 10:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <20210909075643.fhngqu6tqrpe33gl@gator>
In-Reply-To: <20210909075643.fhngqu6tqrpe33gl@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 10:10:56 -0700
Message-ID: <CAJHc60wRkUyKEdY0ok0uC7r=P0FME+Lb7oapz+AKbjaNDhFHyA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 9, 2021 at 12:56 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:09AM +0000, Raghavendra Rao Ananta wrote:
> > At times, such as when in the interrupt handler, the guest wants
> > to get the vcpuid that it's running on. As a result, introduce
> > get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> > backend, the VMM prepares a map of vcpuid and mpidr during VM
> > initialization and exports the map to the guest for it to read.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/processor.h |  3 ++
> >  .../selftests/kvm/lib/aarch64/processor.c     | 46 +++++++++++++++++++
> >  2 files changed, 49 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index b6088c3c67a3..150f63101f4c 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -133,6 +133,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
> >               int vector, handler_fn handler);
> >  void vm_install_sync_handler(struct kvm_vm *vm,
> >               int vector, int ec, handler_fn handler);
> > +void vm_vcpuid_map_init(struct kvm_vm *vm);
> >
> >  static inline void cpu_relax(void)
> >  {
> > @@ -194,4 +195,6 @@ static inline void local_irq_disable(void)
> >       asm volatile("msr daifset, #3" : : : "memory");
> >  }
> >
> > +int get_vcpuid(void);
> > +
> >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > index 632b74d6b3ca..9844b62227b1 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> > @@ -13,9 +13,17 @@
> >  #include "processor.h"
> >
> >  #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN  0xac0000
> > +#define VM_VCPUID_MAP_INVAL                  -1
> >
> >  static vm_vaddr_t exception_handlers;
> >
> > +struct vm_vcpuid_map {
> > +     uint64_t mpidr;
> > +     int vcpuid;
> > +};
>
> I'd prefer we create an arch neutral map structure that has arch specific
> vm_vcpuid_map_add() functions to populate them. So, instead of calling the
> 'mpidr' member mpidr, we should call it 'cpuid'. On x86, for example,
> cpuid would be the APIC ID.
>
Great idea. Let me think about it..

> > +
> > +static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
> > +
> >  static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
> >  {
> >       return (v + vm->page_size) & ~(vm->page_size - 1);
> > @@ -426,3 +434,41 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> >       assert(vector < VECTOR_NUM);
> >       handlers->exception_handlers[vector][0] = handler;
> >  }
> > +
> > +void vm_vcpuid_map_init(struct kvm_vm *vm)
> > +{
> > +     int i = 0;
> > +     struct vcpu *vcpu;
> > +     struct vm_vcpuid_map *map;
> > +
> > +     list_for_each_entry(vcpu, &vm->vcpus, list) {
> > +             map = &vcpuid_map[i++];
> > +             map->vcpuid = vcpu->id;
> > +             get_reg(vm, vcpu->id,
> > +                     ARM64_SYS_KVM_REG(SYS_MPIDR_EL1), &map->mpidr);
> > +             map->mpidr &= MPIDR_HWID_BITMASK;
> > +     }
>
> Here we should assert that i is no longer zero. If it is, then we should
> complain that vcpus need to be added before this call is made.
>
Makes sense, I'll add an ASSERT to be safe.
> But, rather than providing an init function that inits the whole map
> after all vcpus are created, I think we should add each vcpu's map entry
> as we add vcpus to the vm. So we need to call the arch-specific
> vm_vcpuid_map_add() from vm_vcpu_add(). We can just create stubs
> for x86 and s390 for now. Also, in vm_vcpu_rm() we should find the
> corresponding entry in the vcpuid map and set it to VM_VCPUID_MAP_INVAL
> in order to remove it.
>
> > +
> > +     if (i < KVM_MAX_VCPUS)
> > +             vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
> > +
> > +     sync_global_to_guest(vm, vcpuid_map);
>
> We can't do this synch part for the test code at vcpu add time since we
> don't know if the guest page tables are ready. I think it's OK to require
> the test code to do this when the guest code needs it though. We should
> document that requirement above the vm_vcpuid_map struct declaration,
> which will be in kvm_util.h.
>
Sure, I'll add a comment.
> > +}
> > +
> > +int get_vcpuid(void)
> > +{
> > +     int i, vcpuid;
> > +     uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
> > +
> > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > +             vcpuid = vcpuid_map[i].vcpuid;
> > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
>
> We don't want this assert if it's possible to have sparse maps, which
> it probably isn't ever going to be, but...
>
If you look at the way the array is arranged, the element with
VM_VCPUID_MAP_INVAL acts as a sentinel for us and all the proper
elements would lie before this. So, I don't think we'd have a sparse
array here.

Regards,
Raghavendra
> > +
> > +             if (mpidr == vcpuid_map[i].mpidr)
> > +                     return vcpuid;
> > +     }
> > +
> > +     /* We should not be reaching here */
> > +     GUEST_ASSERT_1(0, mpidr);
>
> ...this assert should be good enough to sanity check the map by itself
> anyway.
>
> Also, the only arch-specific aspect of get_vcpuid() is the looking up
> the cpuid. So we should make get_vcpuid arch-neutral and call an arch-
> specific get_cpuid() from it.
>
> > +     return -1;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
