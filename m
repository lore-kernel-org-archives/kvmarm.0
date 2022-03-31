Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515B8C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 16:24:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0FF749E2C;
	Fri,  1 Apr 2022 12:24:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6HdUxxXgbhK1; Fri,  1 Apr 2022 12:24:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9303049E36;
	Fri,  1 Apr 2022 12:24:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98E5C4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 15:57:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 17PaXb9kKAfc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 15:57:50 -0400 (EDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
 [209.85.208.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CBBE4B1AB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 15:57:50 -0400 (EDT)
Received: by mail-lj1-f175.google.com with SMTP id s13so1201231ljd.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 12:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pTe27Qc9aU9mrh9Xska5d8/rYGqxPk37jFPTpeO0UrM=;
 b=cM+XYBWkQOvd6IpcK95d5PqkmE8Zj/rsE4HM7KyzFR+6DlwGlrOGTFvjtZpdC9Aguj
 ESLCoJHA6QKBbqz7zUq2+E4v6HH/ZVXTMUYngj6O/43jTiLxBhJi3bfgeUXDEUrKXO08
 jlLXoMJrlDu0ntHa4lYeB+e2z1Fh9359EEd57bYrB062nhgLtDMXJSITG9Z6Kf3Ed3Fi
 mthSWhv5B5HSBNA0vYd6c5UqJ/fLBKbFciLMVvj0n4okgDzj36jXxbYKZr9X1J8Auxr+
 KBfDAEbrqLEltDXdCTGVk7I9BVY+6Ofz+qmkKRTQ2zs3SMS+MOlVbg/b0NYQ27XQppJ0
 WsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pTe27Qc9aU9mrh9Xska5d8/rYGqxPk37jFPTpeO0UrM=;
 b=IU8L2XR0bvzXHZvuFPiEYzTQ5afMe2QXIFMDcMN4nEFNxY8wCKSNgCrY9+TmLJL9kw
 NntOUH1M9wFinSlJXNVRmJhzx9sDqNY4cB37MZcxzxN8HoVIilY82LntQAWu4ysO7xZq
 BVBSnT+F0YAiVLXhc9es5+5/+m0VEJTUTic+T2N5tJacbq3zRv7RFBe9ZnTGDOBouu5V
 DF7qyuxxlI7cBsi4qiGPi+gDY5NwX9pkYATXUSyps5KJFTzWUzayM/P1tMr+XinEO47Z
 HOHKWikF598DHRiz3BuQqAYovxbaAtng76Fr6pY7J+USadq2Hvn9dXIaWEmP+4pZ/plI
 qpxw==
X-Gm-Message-State: AOAM530n+0lq8/KBwqPlVT0RPbZ37SXuW3qixQzg7zuWYX6p0plhUacd
 YAKk3VB/IxEXRjBrbI5Uy+qD3mEZEiZTTQfp+KhkkA==
X-Google-Smtp-Source: ABdhPJw9+gcr6sgJpKfiIcWS6ZH8RxhxtcabitgSKfJZiaZHQP81kNDhjMCQEcxa3zOxAKVi/mFm6Pv92XT19v/VvHs=
X-Received: by 2002:a2e:390c:0:b0:248:1b88:d6c4 with SMTP id
 g12-20020a2e390c000000b002481b88d6c4mr11250384lja.49.1648756669056; Thu, 31
 Mar 2022 12:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-21-dmatlack@google.com>
 <YjG7Zh4zwTDsO3L1@xz-m1.local>
 <CALzav=fRFzbGEVhdMSwhX1Gs1++DGW6MOWvKzeQ-RTtLsus=SQ@mail.gmail.com>
 <YkSirYT6s8YtUr4w@xz-m1.local>
In-Reply-To: <YkSirYT6s8YtUr4w@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Thu, 31 Mar 2022 12:57:22 -0700
Message-ID: <CALzav=ceTVGviFzCP0BfUP74DmkBkBnRo5wczGq+2j05MdetMw@mail.gmail.com>
Subject: Re: [PATCH v2 20/26] KVM: x86/mmu: Extend Eager Page Splitting to the
 shadow MMU
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Fri, 01 Apr 2022 12:24:11 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
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

On Wed, Mar 30, 2022 at 11:34 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Mar 22, 2022 at 04:58:08PM -0700, David Matlack wrote:
> > > > +static int prepare_to_split_huge_page(struct kvm *kvm,
> > > > +                                   const struct kvm_memory_slot *slot,
> > > > +                                   u64 *huge_sptep,
> > > > +                                   struct kvm_mmu_page **spp,
> > > > +                                   bool *flush,
> > > > +                                   bool *dropped_lock)
> > > > +{
> > > > +     int r = 0;
> > > > +
> > > > +     *dropped_lock = false;
> > > > +
> > > > +     if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES)
> > > > +             return -ENOSPC;
> > > > +
> > > > +     if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > > > +             goto drop_lock;
> > > > +
> > >
> > > Not immediately clear on whether there'll be case that *spp is set within
> > > the current function.  Some sanity check might be nice?
> >
> > Sorry I'm not sure what you mean here. What kind of sanity check did
> > you have in mind?
>
> Something like "WARN_ON_ONCE(*spp);"?

Ah I see. I was confused because the previous version of this code
checked if *spp is already set and, if so, skipped the allocation. But
I accidentally introduced a memory leak here when I implemented Ben'
suggestion to defer alloc_memory_for_split() to a subsequent commit.
I'll fix this in v3.

>
> >
> > >
> > > > +     *spp = kvm_mmu_alloc_direct_sp_for_split(true);
> > > > +     if (r)
> > > > +             goto drop_lock;
> > > > +
> > > > +     return 0;
>
> Thanks,
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
