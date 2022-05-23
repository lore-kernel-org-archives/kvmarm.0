Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4644EC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 23 May 2022 17:37:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD17A4B1B0;
	Mon, 23 May 2022 13:37:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FDMHLc5nIaJZ; Mon, 23 May 2022 13:37:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9919B4B20B;
	Mon, 23 May 2022 13:37:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4214B1FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 13:37:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w9nOfsODrAku for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 May 2022 13:37:25 -0400 (EDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 739134B1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 13:37:25 -0400 (EDT)
Received: by mail-pj1-f53.google.com with SMTP id z11so4856352pjc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 May 2022 10:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uPvB4xKkZsbv/NQuw+LVF1ZeOmndZIablC0q46ZFciY=;
 b=XvH+fP7b6A7IaMFFBQF7IkZCZBYDCe5tYb80MfrbM2f0FYzFokK+x6mgbkPTeOgoUg
 LclNFKJEWXiNeIZWkIZLNbNNePqmTZSw88j10EPFP/TCd88RX+QFgo+8KXnJ7ZFWEqw8
 e258spbjBdsYFehtuKv0B7wbQEdEuoZG2QfXIkOIkFlhdL9EvniL6ve+PR8g87Ue1Ipd
 qlKgwGG9OiDFl7+72jz8mhlBqYjKbIOUmNWAcLmyrAe5QY5hfjJUdhA+UHLy5+ZIOXNQ
 y5rtJrUIwrCDHAi+YfCoOzCaRCeBurqBgL7bm+aoHAkTBJ7vzfBVMAs7LZYNqcNRbsWw
 xF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uPvB4xKkZsbv/NQuw+LVF1ZeOmndZIablC0q46ZFciY=;
 b=urwlK3PZNW4SuVtWubiHTwx0xQue0sO/793uFnd/JuiZN7g6SOjNY7z5t3G0KQkp1l
 qquqLJ4D0DY9IrBR0A2ztnAG8nghwxgI3uir73p9jQBC7iZmHUI1pTRCu7w7IBhzyBy7
 1qpijfjgDd599iQYV3PR+ll+vA1STRs9KAfwIzZn67hqkR8ChIzlfa4SnZBF6ygrq1ec
 g4QTTs/FePlq0fzo49jhuDrs7Kih4bd7rG3aX4yujFIYA7JThla3IEWnFBecYb1ipyIe
 5wa7DMWdRXJ33rrJwx7inpeBTabO4slY8kHU/pNnT8cz2Oy4fXfQc0p/h2cHsJ4X6Xbk
 ruig==
X-Gm-Message-State: AOAM5300fo8mfAjWh9bjPZhKPPmEc0KAZEMmx8YH3eFMJkL1oe/cPNv3
 +DbK0xzGkeBQXsoJWwDqOhrG6A==
X-Google-Smtp-Source: ABdhPJw4AGNGxsFqbqwZIS+BFk/8egtH9UXiumvmBRxLQ0/47sCH59HMfF1NiH7idboGwFW37lheDQ==
X-Received: by 2002:a17:90b:4b90:b0:1e0:1b0:1a1 with SMTP id
 lr16-20020a17090b4b9000b001e001b001a1mr146255pjb.70.1653327444125; 
 Mon, 23 May 2022 10:37:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 j13-20020a170902da8d00b0015e8d4eb260sm5388000plx.170.2022.05.23.10.37.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 May 2022 10:37:23 -0700 (PDT)
Date: Mon, 23 May 2022 17:37:20 +0000
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YovGUDrYZMZ7PXeY@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
 <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL715WJ5DVM-A8EFND0iQ-MH9nAhE3rvWdYWaEgRTCJEVeegRg@mail.gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)" <kvm@vger.kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, maciej.szmigiero@oracle.com,
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

On Fri, May 20, 2022, Mingwei Zhang wrote:
> On Mon, May 16, 2022 at 4:24 PM David Matlack <dmatlack@google.com> wrote:
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index e089db822c12..5e2e75014256 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
> >                 return (void *)__get_free_page(gfp_flags);
> >  }
> >
> > -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> > +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> >  {
> > +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
> >         void *obj;
> >
> >         if (mc->nobjs >= min)
> >                 return 0;
> > -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> > -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> > +
> > +       if (unlikely(!mc->objects)) {
> > +               if (WARN_ON_ONCE(!capacity))
> > +                       return -EIO;
> > +
> > +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > +               if (!mc->objects)
> > +                       return -ENOMEM;
> > +
> > +               mc->capacity = capacity;
> 
> Do we want to ensure the minimum value of the capacity? I think
> otherwise, we may more likely start using memory from GFP_ATOMIC if
> the capacity is less than, say 5? But the minimum value seems related
> to each cache type.

Eh, if we specify a minimum, just make the arch default the minimum.  That way we
avoid adding even more magic/arbitrary numbers.  E.g. for whatever reason, MIPS's
default is '4'.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
