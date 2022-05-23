Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFD8C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 24 May 2022 16:58:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F024B1B7;
	Tue, 24 May 2022 12:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WTDBlF14Zhip; Tue, 24 May 2022 12:58:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4555E4B20A;
	Tue, 24 May 2022 12:58:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 790B84B11F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 13:44:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DLzVW2KV5WaI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 May 2022 13:44:34 -0400 (EDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3960849ED5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 13:44:34 -0400 (EDT)
Received: by mail-lj1-f169.google.com with SMTP id r3so11212508ljd.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 10:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Lt+QmLRlAmSG7nATNb3de1rpq1KDptBx8X9RCMbUflw=;
 b=Rr3FTbZSH6OEOK11OGjw8VhElwCyNuOyvzb6UGiQa0VN2z4nznXexLQevuNvWvmzge
 CTYxbMdQDt/ABY+5MJUs3UQ9cjgZB5HpfDYKoRS1NjSjEXU07Em23YCDUfUVa0uX8nb/
 9z73CqVXPwVsA8Daek73ky1cd2penETPszXb/oyC1JTxYrs3iF1+pny/UHRiTwvpdI8k
 g8tK6SALO5ySpktT2RjFFNN6TQsPT7nll0EKnmQlStwKvKJ60ZHIYNM+jC9XU/fKERYw
 C53AE92+J6jh3ctfSI6kiJseh3KT/sVgJBhffuZkOWwWVE+RPT6LvCRHczR7+R0zJEmT
 JfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Lt+QmLRlAmSG7nATNb3de1rpq1KDptBx8X9RCMbUflw=;
 b=6zKXaVtN6WYIbS6zJPs7xHld5jJNxQV+AtwmV01EQooW6Ohlg2A9gYk25HMWQ4AkL6
 zy8ixJTNa0/LV+wUvoH5UdjkQj9V3Ml/wc1Hq2S6BSk3NiP4HHPh69Th3cEbjcGWF2ux
 LygPC3XKAd48tYgTLLfsxAyqOppXzXz8RZ2JtMdk2JE2Valwgg5r6bb6ri+mw1tHg5uf
 q/IaChwM04ySIAslTzgIDdv6j05Ko57LneeM4sUJZ6guFOrEoryZ92PA2TyMbsiQ9YZF
 aRQznBhti8YgwuHR1vI8pTUjb5zkgU6TmvOM+v1q4BzZojpLZ8Akn+DQhc3XFshcrxOQ
 DJ2A==
X-Gm-Message-State: AOAM5330oIvGYpsf6rx3Hhg3Fcum7/5HOBVarFlrPt/b2hnp0Wmu6AOd
 pkrGLR6gLn/2QQBsViGqV8LFMcABmtzm0cElLfsI2Q==
X-Google-Smtp-Source: ABdhPJzDb1QQeQPt37UpqWbTLpFmjnccbcNhzyRtox2/Lhza8BwHrGwgro263+zixdfWhTwF6P7oNs645WQMXX3iLvE=
X-Received: by 2002:a05:651c:b20:b0:253:f4ec:b7d0 with SMTP id
 b32-20020a05651c0b2000b00253f4ecb7d0mr159601ljr.198.1653327872507; Mon, 23
 May 2022 10:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
 <YovGUDrYZMZ7PXeY@google.com>
In-Reply-To: <YovGUDrYZMZ7PXeY@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 May 2022 10:44:05 -0700
Message-ID: <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 24 May 2022 12:58:17 -0400
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)" <kvm@vger.kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Mingwei Zhang <mizhang@google.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Peter Feiner <pfeiner@google.com>
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

On Mon, May 23, 2022 at 10:37 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, May 20, 2022, Mingwei Zhang wrote:
> > On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index e089db822c12..5e2e75014256 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > >                 return (void *)__get_free_page(gfp_flags);
> > >  }
> > >
> > > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> > >  {
> > > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> > >         void *obj;
> > >
> > >         if (mc->nobjs >= min)
> > >                 return 0;
> > > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > > +
> > > +       if (unlikely(!mc->objects)) {
> > > +               if (WARN_ON_ONCE(!capacity))
> > > +                       return -EIO;
> > > +
> > > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > > +               if (!mc->objects)
> > > +                       return -ENOMEM;
> > > +
> > > +               mc->capacity = capacity;
> >
> > Do we want to ensure the minimum value of the capacity? I think
> > otherwise, we may more likely start using memory from GFP_ATOMIC if
> > the capacity is less than, say 5? But the minimum value seems related
> > to each cache type.
>
> Eh, if we specify a minimum, just make the arch default the minimum.  That way we
> avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
> default is '4'.

I'm not exactly sure what you had in mind Mingwei. But there is a bug
in this code if min > capacity. This function will happily return 0
after filling up the cache, even though it did not allocate min
objects. The same bug existed before this patch if min >
ARRAY_SIZE(mc->objects). I can include a separate patch to fix this
bug (e.g. WARN and return -ENOMEM if min > capacity).
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
