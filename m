Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A625EC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 24 May 2022 16:58:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC0F4B211;
	Tue, 24 May 2022 12:58:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hh+nVc3Ll6vi; Tue, 24 May 2022 12:58:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE324B229;
	Tue, 24 May 2022 12:58:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E00504B19F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 19:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m4GQ+IzrUEcz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 May 2022 19:53:42 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 624B94B187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 19:53:42 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id v8so26228471lfd.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 16:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=B6K+n5trTrHvxAFuNCecjs0YmyJ1Bn3a5xkmVuIStmM=;
 b=BPnHN7iMI/JEFGAgFED1NnOV+p4X8cTy2jl7w3i7pSKE6MPXIeU4iH8g3qr6t+F7YK
 DAQEFeqzXtwo9GOo1WLRgaRfsbYX9afv48KXrqcVCqsJ6KQZetFNnUC234u72PiZM/Sq
 D0BMYIhezronCLCcKMGEYT4lZXGxLMpLwDvJ7gbjMW6IZv5vYrmyqPzfkgnx8HAxvnAh
 ne9OYywwq+DJjLctEvlzoFyX5TgISZzA+7M6DzftnaU3a25R/PD4p9/JxG3FDWOBaO1G
 uytiajMVRtN4+DwRpOsaKGimX/CBnLr3z4DJONW6GfkrXVafvBBZWLuYT+/d5qcLyco/
 2CfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=B6K+n5trTrHvxAFuNCecjs0YmyJ1Bn3a5xkmVuIStmM=;
 b=wT1syYWhzDrDGPyIyFKZP3xL/7WctGWOw0+tLIU8SpsnGtRbpMOAPigBVToJrzlz3h
 vhXkfdr1AK40n3+IplTBlN0cf7GcksCrtja2hNWxk72Ujv003cLqb8NGr+eQ9vC4Biim
 SaorTD4b3NZzgnCDZmsWRPpW+I9YjWzqwGriRJ/YQ5o3k/AkU5SsBKCwO1UC6r42+BgO
 NXlaaCRERcYnJfWGuf+y7LtZtxzXBO0n5gJ3pdavCpC0i5g0S4Q0jpzThv2FKRDuRauX
 MLvwCH/w7lo3X6Seub0O3yISzEgLSdV0Q7MqEA1sYc2nYoxP01bhFJf2WCCrAxignC55
 lhjQ==
X-Gm-Message-State: AOAM531uTS+EwL9WSAlv8euHWyl/Rv/nTbnaDXPahEW3LF0nQ/RWhjAW
 unIvqTDX0iHo+LiA2Jpl/bkPcv5P+fA4EdKvtFT2ug==
X-Google-Smtp-Source: ABdhPJziXHj05xT/zUF+nkUcHohkaf74BzKmGNn2lMFBYinF4EG9SrYpHZStR9D2/7fYm2TKO7+NKxKY3t8tZLFiduc=
X-Received: by 2002:a05:6512:3989:b0:477:caeb:1a13 with SMTP id
 j9-20020a056512398900b00477caeb1a13mr16496442lfu.64.1653350020658; Mon, 23
 May 2022 16:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
 <YovGUDrYZMZ7PXeY@google.com>
 <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
 <CAL715WL8g4y=agnMCM7uX6dhBp1JdFKHOCcYsh-=HT0wF=sQUA@mail.gmail.com>
 <CALzav=dcFmkZsEBUWGECUQVzrE4TiF=eOxhRXW-XQ-_q4cXchA@mail.gmail.com>
In-Reply-To: <CALzav=dcFmkZsEBUWGECUQVzrE4TiF=eOxhRXW-XQ-_q4cXchA@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 May 2022 16:53:14 -0700
Message-ID: <CALzav=fVvYtOz5Bfrn=hkaegkKEpwuP1+GB+RvNxc7OJ7i2sGw@mail.gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To: Mingwei Zhang <mizhang@google.com>
X-Mailman-Approved-At: Tue, 24 May 2022 12:58:17 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)" <kvm@vger.kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
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

On Mon, May 23, 2022 at 11:22 AM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, May 23, 2022 at 11:13 AM Mingwei Zhang <mizhang@google.com> wrote:
> >
> > On Mon, May 23, 2022 at 10:44 AM David Matlack <dmatlack@google.com> wrote:
> > >
> > > On Mon, May 23, 2022 at 10:37 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Fri, May 20, 2022, Mingwei Zhang wrote:
> > > > > On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > > index e089db822c12..5e2e75014256 100644
> > > > > > --- a/virt/kvm/kvm_main.c
> > > > > > +++ b/virt/kvm/kvm_main.c
> > > > > > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > > > > >                 return (void *)__get_free_page(gfp_flags);
> > > > > >  }
> > > > > >
> > > > > > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > > > > > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> > > > > >  {
> > > > > > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> > > > > >         void *obj;
> > > > > >
> > > > > >         if (mc->nobjs >= min)
> > > > > >                 return 0;
> > > > > > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > > > > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > > > > > +
> > > > > > +       if (unlikely(!mc->objects)) {
> > > > > > +               if (WARN_ON_ONCE(!capacity))
> > > > > > +                       return -EIO;
> > > > > > +
> > > > > > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > > > > > +               if (!mc->objects)
> > > > > > +                       return -ENOMEM;
> > > > > > +
> > > > > > +               mc->capacity = capacity;
> > > > >
> > > > > Do we want to ensure the minimum value of the capacity? I think
> > > > > otherwise, we may more likely start using memory from GFP_ATOMIC if
> > > > > the capacity is less than, say 5? But the minimum value seems related
> > > > > to each cache type.
> > > >
> > > > Eh, if we specify a minimum, just make the arch default the minimum.  That way we
> > > > avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
> > > > default is '4'.
> > >
> > > I'm not exactly sure what you had in mind Mingwei. But there is a bug
> > > in this code if min > capacity. This function will happily return 0
> > > after filling up the cache, even though it did not allocate min
> > > objects. The same bug existed before this patch if min >
> > > ARRAY_SIZE(mc->objects). I can include a separate patch to fix this
> > > bug (e.g. WARN and return -ENOMEM if min > capacity).
> >
> > oh, what I am saying is this one:
> > https://elixir.bootlin.com/linux/latest/source/virt/kvm/kvm_main.c#L417
> >
> > If we are running out of kmem cache, then we start to use
> > __GFP_ATOMIC, which should be avoided as much as we can? Since this
> > patch parameterized the 'capacity', then to avoid the future usage
> > where caller provides a too small value, maybe we could add a warning
> > if the 'capacity' is too small, say, smaller than 40 (the default
> > value)?
>
> I'm not too worried about that. Callers of
> kvm_mmu_topup_memory_cache() are responsible for passing in a min
> value. It doesn't matter if capacity is a number lower than 40, as
> long as kvm_mmu_topup_memory_cache() is able to allocate min objects,
> the call is a success (and the GFP_ATOMIC fallback should never
> trigger, and if it does, we'll get a WARN splat).

Ah and I forgot to add: In this situation, the bug is that *min* is
too small, not capacity. So adding a restriction on capacity would not
help.

>
> The only actual loophole I can spot is if capacity is less than min.
> In that case topup will return 0 despite allocating less than min
> objects. Again we'll still hit the GFP_ATOMIC and get a WARN splat,
> but we can detect the problem in kvm_mmu_topup_memory_cache() which
> will include the buggy callsite in the backtrace.
>
> >
> > The case of  'capacity' < min would be a more serious issue, that
> > situation probably should never be allowed.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
