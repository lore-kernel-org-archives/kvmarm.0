Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAF5C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:59:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58A3A61186
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:59:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58A3A61186
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0674B159;
	Thu,  9 Sep 2021 12:59:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lq3WTfxDvinV; Thu,  9 Sep 2021 12:59:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A8B4B15A;
	Thu,  9 Sep 2021 12:59:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B901B4B13A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a1im1A1n1zzL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 12:59:45 -0400 (EDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
 [209.85.219.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9545E4B119
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:59:45 -0400 (EDT)
Received: by mail-yb1-f181.google.com with SMTP id y16so5253839ybm.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 09:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=h4cQqQOplk8x725n2ey4+/+BvWdK0UMLhYf+SNIozPk=;
 b=O4T0puoUdDmajej0EsClr36rF3VQEmHKZCjpSAvbYXv/PDlaYW5ih7hdSkYYVp7OFr
 fSx1buxVk+fhg4K25HNQdnT/A9V+/xIYvYmFJarVLEcx5aWSBN4DZ6vh8mVVandRdCrU
 n78NET/pRJfSbRKI/IBgztDqYkf6fmuwbmFxHkeKtxXTLc0OzyytfdT+28GXRIn6xG3d
 xawbnTEJRRRmUO6dG1qqIDPyKZ7yIYhluR4mcoXhFrgxE6eUCAiTkSm2v9NcJ+YDXCpF
 cW0PSEDndkk6pjoC0rCTTo6Ye+KEjIw5Ub2Au+s/+N0g+xnYoXjWOmpb83VnwNdi0Fej
 /wCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=h4cQqQOplk8x725n2ey4+/+BvWdK0UMLhYf+SNIozPk=;
 b=PxTrU7qQ9TD5XslJzLRQBgRblh6eAn1WR8XXeSXSzMxyW2hc/zrq6VutzOJJxHIVSp
 lgYGGtXU11xy4+TdVLlpImSqEYcAOrWXKR6uQJYRgMHIN//07G5krK4D7ACcWg5qpk4o
 kK1Kg+JrdKSX2XtSmFhu1RbmIGnP2yFrCKQm13nZsv48vTtS6+jk2hJKKmBhfhJ1MEYR
 LEVBuULBMMuUUxZUyBa6xbtinjpnij7j2vPY4fJVP1tGjCXzUg0w9o+E5woVZ9Uia0vG
 MqSRf6Sf9FL+mz927scu3o9PdjDy+/kdJe8CdW7y9LW15DSq3wLtlaJygUOtL7jYLgR6
 rW+Q==
X-Gm-Message-State: AOAM530oC4kF1GmFfUDCwjdxX9lYrs40YP5FXF6CbqpeZmYYEV5CI0AY
 qjM21vFvN5jqiZ9l7bFanUFdTPRiQV3puwgIU/upeQ==
X-Google-Smtp-Source: ABdhPJwD2J11x1YItUB+digmkHQyFDgrrRlsAAGKHfI7ALtSn12JHhwFekPsDwP18MY3PE58Vz8ZDU+XjV0cy/d+HSs=
X-Received: by 2002:a25:cd82:: with SMTP id d124mr5190323ybf.491.1631206784899; 
 Thu, 09 Sep 2021 09:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
 <YTmW7/pY0E9cHQ+c@google.com>
In-Reply-To: <YTmW7/pY0E9cHQ+c@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 09:59:33 -0700
Message-ID: <CAJHc60zk6vJg4dj4hm7sCHK08TEr=GtXemDJHb22mgvg2eUfXA@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 8, 2021 at 10:09 PM Oliver Upton <oupton@google.com> wrote:
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
>
> I believe both of these functions could use some documentation. The
> former has implicit ordering requirements (can only be called after all
> vCPUs are created) and the latter can only be used within a guest.
>
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
> > +
> > +static struct vm_vcpuid_map vcpuid_map[KVM_MAX_VCPUS];
> > +
>
> Hmm.
>
> I'm not too big of a fan that the KVM_MAX_VCPUS macro is defined in the
> KVM selftests. Really, userspace should discover the limit from the
> kernel. Especially when we want to write tests that test behavior at
> KVM's limit.
>
> That being said, there are more instances of these static allocations in
> the selftests code, so you aren't to be blamed.
>
> Related: commit 074c82c8f7cf ("kvm: x86: Increase MAX_VCPUS to 1024")
> has raised this limit.
>
I'm not a fan of static allocations either, but the fact that
sync_global_to_guest() doesn't have a size argument (yet), makes me
want to take a shorter route. Anyway, if you want I can allocate it
dynamically and copy it to the guest's memory by hand, or come up with
a utility wrapper while I'm at it.
(Just wanted to make sure we are not over-engineering our needs here).

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
> > +
> > +     if (i < KVM_MAX_VCPUS)
> > +             vcpuid_map[i].vcpuid = VM_VCPUID_MAP_INVAL;
> > +
> > +     sync_global_to_guest(vm, vcpuid_map);
> > +}
> > +
> > +int get_vcpuid(void)
>
> nit: guest_get_vcpuid()
>
Sounds nice. Since we have a lot of guest utility functions now, I'm
fancying a world where we prefix guest_ with all of them to avoid
confusion.

Regards,
Raghavendra
> > +{
> > +     int i, vcpuid;
> > +     uint64_t mpidr = read_sysreg(mpidr_el1) & MPIDR_HWID_BITMASK;
> > +
> > +     for (i = 0; i < KVM_MAX_VCPUS; i++) {
> > +             vcpuid = vcpuid_map[i].vcpuid;
> > +             GUEST_ASSERT_1(vcpuid != VM_VCPUID_MAP_INVAL, mpidr);
> > +
> > +             if (mpidr == vcpuid_map[i].mpidr)
> > +                     return vcpuid;
> > +     }
> > +
> > +     /* We should not be reaching here */
> > +     GUEST_ASSERT_1(0, mpidr);
> > +     return -1;
> > +}
> > --
> > 2.33.0.153.gba50c8fa24-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
