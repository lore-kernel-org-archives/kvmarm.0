Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14A5C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 24 May 2022 16:58:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D9DE4B242;
	Tue, 24 May 2022 12:58:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EsiPgjzj0NKD; Tue, 24 May 2022 12:58:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F7854B226;
	Tue, 24 May 2022 12:58:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F4624B1F4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 14:23:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y0S9j5NGR8IP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 May 2022 14:23:26 -0400 (EDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
 [209.85.208.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BFE64B12E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 14:23:26 -0400 (EDT)
Received: by mail-lj1-f170.google.com with SMTP id 27so13267222ljw.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 11:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JBE+c6B6mu+AU/hAc8TEq+k0wWV4teBbrl8ksLPajFc=;
 b=cWHVnC7SjbQmMEiVyXfCzVIwsV3Lh2RylQXtUjn75DQ9ceQTENt+WSdC1+qQPWw8yy
 SpilqZe8fjKZ2i4ZcQNVW/Xq0QMQ/FwJiZMkeGDFUTu5YZHSdHeRx8ieJzECO8muh3Bt
 krUpWLStrKeGzqo0aLvY1wu7oGH4X5EtBrO1MG9y4N5YbR+JT8IUm7O8vcYLqskmy1SI
 SCIaY6VoNwevl9WnTh6ITh4or1ZmLLZEXDOsmRxsiZdaqklvLnhpa5Uni3T3Rc7oytnp
 7WnKbUaItrZqB9NYSo6Dt90ETwk9rrSVO6HZU2Zkx4UZkTjinD/QFxrX+oYCwgEAlqZF
 moLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JBE+c6B6mu+AU/hAc8TEq+k0wWV4teBbrl8ksLPajFc=;
 b=NRmcHO6i1V6awcW9BKt2qpakisMefP3mZaAaYfqTSQg8cPN0LR5gw5u/zjFmwA+kY+
 ugrFSnG7BGEXR2a47fLEegRhP0VcIYVfPy9opWs4GZ8z9tho18t0cs5JOQARQMo2O+nh
 ZIGuTXTxW7hTpLeb3fgJiEpltUwVF8FyGkty6ngMcK+5X/mYPXPo5SCb9BW+JBvXsVGW
 w5Tt2i60loSpuekCuy6ozaQjQvhIsOcOXk28FkN9EPlQoAvL95wcBN493ohJEDu5oqoy
 dBD+JsCLbYWM4ksrSqiGI0yvh+OR/kid4kC7E3pHKImhSV+DeTyIfngWrv2hw39aR9Tr
 6SNQ==
X-Gm-Message-State: AOAM533pN8cuYN0Ds8IGTz3wkKupEShRqu/iVDOOZDX85eSFGVUoV5T6
 lkCfHoqz6rX6mI/VFWcGvfBrAxsgXirf2AxgAffArg==
X-Google-Smtp-Source: ABdhPJyNsj6lIr9f0L/th/WhKwBNwG+T8hd6N7+QYW7amPHZGMNM9aG5b3qM5eH0DKS98CKLvqIisTXtpNcpRY+gaWM=
X-Received: by 2002:a2e:9d93:0:b0:253:c9bd:288 with SMTP id
 c19-20020a2e9d93000000b00253c9bd0288mr13678056ljj.223.1653330204606; Mon, 23
 May 2022 11:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
 <YovGUDrYZMZ7PXeY@google.com>
 <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
 <CAL715WL8g4y=agnMCM7uX6dhBp1JdFKHOCcYsh-=HT0wF=sQUA@mail.gmail.com>
In-Reply-To: <CAL715WL8g4y=agnMCM7uX6dhBp1JdFKHOCcYsh-=HT0wF=sQUA@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 May 2022 11:22:57 -0700
Message-ID: <CALzav=dcFmkZsEBUWGECUQVzrE4TiF=eOxhRXW-XQ-_q4cXchA@mail.gmail.com>
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

On Mon, May 23, 2022 at 11:13 AM Mingwei Zhang <mizhang@google.com> wrote:
>
> On Mon, May 23, 2022 at 10:44 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Mon, May 23, 2022 at 10:37 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, May 20, 2022, Mingwei Zhang wrote:
> > > > On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > index e089db822c12..5e2e75014256 100644
> > > > > --- a/virt/kvm/kvm_main.c
> > > > > +++ b/virt/kvm/kvm_main.c
> > > > > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > > > >                 return (void *)__get_free_page(gfp_flags);
> > > > >  }
> > > > >
> > > > > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > > > > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> > > > >  {
> > > > > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> > > > >         void *obj;
> > > > >
> > > > >         if (mc->nobjs >= min)
> > > > >                 return 0;
> > > > > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > > > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > > > > +
> > > > > +       if (unlikely(!mc->objects)) {
> > > > > +               if (WARN_ON_ONCE(!capacity))
> > > > > +                       return -EIO;
> > > > > +
> > > > > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > > > > +               if (!mc->objects)
> > > > > +                       return -ENOMEM;
> > > > > +
> > > > > +               mc->capacity = capacity;
> > > >
> > > > Do we want to ensure the minimum value of the capacity? I think
> > > > otherwise, we may more likely start using memory from GFP_ATOMIC if
> > > > the capacity is less than, say 5? But the minimum value seems related
> > > > to each cache type.
> > >
> > > Eh, if we specify a minimum, just make the arch default the minimum.  That way we
> > > avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
> > > default is '4'.
> >
> > I'm not exactly sure what you had in mind Mingwei. But there is a bug
> > in this code if min > capacity. This function will happily return 0
> > after filling up the cache, even though it did not allocate min
> > objects. The same bug existed before this patch if min >
> > ARRAY_SIZE(mc->objects). I can include a separate patch to fix this
> > bug (e.g. WARN and return -ENOMEM if min > capacity).
>
> oh, what I am saying is this one:
> https://elixir.bootlin.com/linux/latest/source/virt/kvm/kvm_main.c#L417
>
> If we are running out of kmem cache, then we start to use
> __GFP_ATOMIC, which should be avoided as much as we can? Since this
> patch parameterized the 'capacity', then to avoid the future usage
> where caller provides a too small value, maybe we could add a warning
> if the 'capacity' is too small, say, smaller than 40 (the default
> value)?

I'm not too worried about that. Callers of
kvm_mmu_topup_memory_cache() are responsible for passing in a min
value. It doesn't matter if capacity is a number lower than 40, as
long as kvm_mmu_topup_memory_cache() is able to allocate min objects,
the call is a success (and the GFP_ATOMIC fallback should never
trigger, and if it does, we'll get a WARN splat).

The only actual loophole I can spot is if capacity is less than min.
In that case topup will return 0 despite allocating less than min
objects. Again we'll still hit the GFP_ATOMIC and get a WARN splat,
but we can detect the problem in kvm_mmu_topup_memory_cache() which
will include the buggy callsite in the backtrace.

>
> The case of  'capacity' < min would be a more serious issue, that
> situation probably should never be allowed.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
