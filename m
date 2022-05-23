Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F685C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 24 May 2022 16:58:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E55B74B116;
	Tue, 24 May 2022 12:58:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cvrmjTkijI3G; Tue, 24 May 2022 12:58:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 658114B215;
	Tue, 24 May 2022 12:58:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F6D4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 14:13:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HHXJ0z+Z5yoJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 May 2022 14:13:31 -0400 (EDT)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95BF54B1C9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 14:13:31 -0400 (EDT)
Received: by mail-qt1-f175.google.com with SMTP id v6so10119439qtx.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 11:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9HFX9sjl+4VLRtd7vfZP8e0JAPWXxyf7EQ+egr1dfcA=;
 b=XmbHC6s54toCVJhe+r/t0oUqEEo6vDWi/pHAZbCRT05gdM7142NZCPkCgjNSbDneXa
 2HpkmYLGn+24ofjOzud50aHEqkNXt1LTQG3yZMKQqsw9VEqcO2V2Vb+0T2iuw03j+K2G
 hDs9ogxGqyL5a3X/u0ZmYwqJQpSm+Ny7bDTEHcUlg+U7Og5466M8sXwCbBXM3q7JApWz
 MLbxGNntDJc1tilQd9QdKWMHLowyt/5xXuLr+TQqWHJC18gPAgPGdZvjMo+clA05NFbd
 MkU7+k6RROPiJEctaZ/MKvf48EyVF2qYy2b7jEvZPZ9kgO7wZk8UXSZDRefysbVdSvwF
 QrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9HFX9sjl+4VLRtd7vfZP8e0JAPWXxyf7EQ+egr1dfcA=;
 b=nRDQNxIpM00ycNVgGAzsxphFPzyDDe68Jr801zq0aNgEimmr9TsUn36JMqq95fTzNH
 dm1uB8r0yUhIO/76gaRmNV0mCkbl1GZII3NhYwMYZ/7ykLa5IyAEx/53BV25GmNSYknN
 60Rbw4Og74H+5XY+dmF3FkdpElv76mdtw1vsydu2eNUB6QI72z2RXahkv3rVfzNGQsn3
 QtrooFkDsSS14ZUE1wfe4Ktxv/hENdiuwIxZzvdV+zLcJtGZsKiSKj6iFEuvOg82J0GY
 /blxNtaC3zAXq9bnCcNy+prihE/anH1Q2w4rP2+NF4c1ldeGfEq06mjbDA1Uhzsz82YY
 1Rhg==
X-Gm-Message-State: AOAM530bNwQFDTLbqiy2QNAAgXkVkODHgwsWrXpy+N6mZZIUmlvBeuU5
 xM/uOPHpC0Gbg8hzUAXJDedsXr5ur/eZsVb9Otn2TA==
X-Google-Smtp-Source: ABdhPJyTpagwHeBg7qLoy4BlcwV85GdG9mZ1tyZUA0awaQdoCbca3Xf2RKHRW63ETWlsi2oNPpabaRdlW0+nTdF5Iqs=
X-Received: by 2002:a05:622a:1903:b0:2f3:ddac:436d with SMTP id
 w3-20020a05622a190300b002f3ddac436dmr16866137qtc.25.1653329610964; Mon, 23
 May 2022 11:13:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
 <YovGUDrYZMZ7PXeY@google.com>
 <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
In-Reply-To: <CALzav=fUTYGjDuWQxJusH4CzkEwGja-4xAmpqEOZdUfBftYwYw@mail.gmail.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Mon, 23 May 2022 11:13:20 -0700
Message-ID: <CAL715WL8g4y=agnMCM7uX6dhBp1JdFKHOCcYsh-=HT0wF=sQUA@mail.gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To: David Matlack <dmatlack@google.com>
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

On Mon, May 23, 2022 at 10:44 AM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, May 23, 2022 at 10:37 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, May 20, 2022, Mingwei Zhang wrote:
> > > On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index e089db822c12..5e2e75014256 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> > > >                 return (void *)__get_free_page(gfp_flags);
> > > >  }
> > > >
> > > > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > > > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> > > >  {
> > > > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> > > >         void *obj;
> > > >
> > > >         if (mc->nobjs >= min)
> > > >                 return 0;
> > > > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > > > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > > > +
> > > > +       if (unlikely(!mc->objects)) {
> > > > +               if (WARN_ON_ONCE(!capacity))
> > > > +                       return -EIO;
> > > > +
> > > > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > > > +               if (!mc->objects)
> > > > +                       return -ENOMEM;
> > > > +
> > > > +               mc->capacity = capacity;
> > >
> > > Do we want to ensure the minimum value of the capacity? I think
> > > otherwise, we may more likely start using memory from GFP_ATOMIC if
> > > the capacity is less than, say 5? But the minimum value seems related
> > > to each cache type.
> >
> > Eh, if we specify a minimum, just make the arch default the minimum.  That way we
> > avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
> > default is '4'.
>
> I'm not exactly sure what you had in mind Mingwei. But there is a bug
> in this code if min > capacity. This function will happily return 0
> after filling up the cache, even though it did not allocate min
> objects. The same bug existed before this patch if min >
> ARRAY_SIZE(mc->objects). I can include a separate patch to fix this
> bug (e.g. WARN and return -ENOMEM if min > capacity).

oh, what I am saying is this one:
https://elixir.bootlin.com/linux/latest/source/virt/kvm/kvm_main.c#L417

If we are running out of kmem cache, then we start to use
__GFP_ATOMIC, which should be avoided as much as we can? Since this
patch parameterized the 'capacity', then to avoid the future usage
where caller provides a too small value, maybe we could add a warning
if the 'capacity' is too small, say, smaller than 40 (the default
value)?

The case of  'capacity' < min would be a more serious issue, that
situation probably should never be allowed.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
