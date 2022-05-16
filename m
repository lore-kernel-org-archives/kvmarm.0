Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA39C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 19:11:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E73904B266;
	Mon, 16 May 2022 15:11:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4bOW+m9Xt0uf; Mon, 16 May 2022 15:11:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A2E49F3D;
	Mon, 16 May 2022 15:11:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD60C4B29E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 12:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jbTtoTeMKpDU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 12:39:34 -0400 (EDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
 [209.85.167.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA6D04B29D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 12:39:34 -0400 (EDT)
Received: by mail-lf1-f54.google.com with SMTP id b18so26801529lfv.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 09:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hYHwEAjXNX75VWbUllN/Gour8BQtThd5ZVwkANp9gRY=;
 b=bK0X0UtuI4068ycqprV0lsvDAI+AHR1gGA9C4RAXNgLVkgt0X/SKAKqpBUz8VqsXpj
 VrQIu3E5HBAJkaSLXxA5SSd32mibLdUgvSTv7KRsOl12irVDXAei24CduxHIFEmELpOP
 Akpk1TKatgOUWNo6GH97f41Rgt6dC5o53iE1TXInCkHY+5KU2UCKYICVz0nTiaETdOa2
 CUC3ubVPJqahOO59ugDHhBeZXWtViC++Mw6XCSkemHHGmBDpjehgL/B1CmV7dpUkYOpZ
 84aGJCq612yfSOXz1WDxqr+HCHIKSkf5IFdZCgpMrXHap1xZ012QF/CF92C9hAXvs7rX
 +KlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hYHwEAjXNX75VWbUllN/Gour8BQtThd5ZVwkANp9gRY=;
 b=WKAjRywuJPvc6n72uAw5CqcPSPpyoh24E438oHwG93KHQTuk2/NV1D45xt7Pz0HcAw
 ia42dBy0SL/3gYRoLxgyLx7jiiQL0r0anTocV/YjcCpUMe3d7f3UfspmOM4nSuXLFwLa
 m/WTcO8xdxx5bCEEVxRvrwdQrmV/D3cJ8fJS/zMEjZt9QLUIxp4xwtyxT0VJbL76zFLf
 5aoHWzt5QN7M/2QXkbpNVKPk55+MEFtfsC6Ry0KwPBu+rEL8teJp5f9KvS8KMtBswv2d
 WCkNQ4B94mO6NRWmUW9RzY64t5ZUFpalvKlWsaDN9dqFZWiNppIVwxa6QuBcqL8ZMbLM
 Y8yQ==
X-Gm-Message-State: AOAM533GJ5nqwZlKA1bEY7zXYLMwF28clkOrfHrx3pzIrHW4ohJdxExw
 AhZmREFcMJgLBuoEpD24vaFGvpEcsL8ps5fC5WwDRw==
X-Google-Smtp-Source: ABdhPJxDcLtX1NQ8HJRWY2uXCXca5YQCMMosdKfmnprtNa9msTSkc4SzO4QNTM90AWokT5c92TgN1ZwszC5RaDsSBUI=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr13821457lfj.518.1652719173041; Mon, 16
 May 2022 09:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-21-dmatlack@google.com>
 <YoJkb7oMEz0v1dnp@google.com>
In-Reply-To: <YoJkb7oMEz0v1dnp@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 16 May 2022 09:39:07 -0700
Message-ID: <CALzav=d-O5KWDC356cdpoJAUvKSSNOMtn_n7G6Yc342-VQFJNQ@mail.gmail.com>
Subject: Re: [PATCH v5 20/21] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Mon, 16 May 2022 15:11:00 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Mon, May 16, 2022 at 7:49 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 13, 2022, David Matlack wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 53ae2c0640bc..2f2ef6b60ff4 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -764,7 +764,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >  {
> >       phys_addr_t addr;
> >       int ret = 0;
> > -     struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> > +     struct kvm_mmu_memory_cache cache = {
> > +             .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> > +             .gfp_zero = __GFP_ZERO,
>
> I dislike requiring all users to specificy the capacity.  It largely defeats the
> purpose of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, and bleeds details into code that
> really doesn't care all that much about the details.
>
> Rather than force the capacity to be set before topup, what about adding a custom
> capacity topup helper?  That allows keeping a default capacity, better documents
> the caches that are special, and provides an opportunity to sanity check that the
> capacity isn't incorrectly changed by the user.

Even simpler: If mc->capacity is 0 in topup, set it to
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.

This is what I had before when I was laying out the storage for
objects in a separate array. It was risky then because it was too easy
for someone to accidentally corrupt memory (call topup with
capacity==0 but without allocating the objects array). Now that topup
takes care of allocation automatically, that risk is gone.

>
> And then I believe this code becomes:
>
>         struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
>
> E.g. (completely untested)
>
> static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc,
>                                         int capacity, int min)
> {
>         gfp_t gfp = GFP_KERNEL_ACCOUNT;
>         void *obj;
>
>         if (mc->nobjs >= min)
>                 return 0;
>
>         if (likely(mc->capacity)) {
>                 if (WARN_ON_ONCE(mc->capacity != capacity || !mc->objects))
>                         return -EIO;
>         } else {
>                 mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
>                 if (!mc->objects)
>                         return -ENOMEM;
>
>                 mc->capacity = capacity;
>         }
>
>         while (mc->nobjs < mc->capacity) {
>                 obj = mmu_memory_cache_alloc_obj(mc, gfp);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
>         }
>         return 0;
> }
>
> int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> {
>         const int capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>
>         return __kvm_mmu_topup_memory_cache(mc, capacity, min);
> }
>
> int kvm_mmu_topup_custom_memory_cache(struct kvm_mmu_memory_cache *mc,
>                                       int capacity)
> {
>         return __kvm_mmu_topup_memory_cache(mc, capacity, capacity);
> }
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
