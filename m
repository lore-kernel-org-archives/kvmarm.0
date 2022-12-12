Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AD7C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:30:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F6F64B861;
	Mon, 12 Dec 2022 17:30:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cZT4zTv5dScc; Mon, 12 Dec 2022 17:30:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F4B4B90B;
	Mon, 12 Dec 2022 17:30:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C44FA4B88B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:30:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gUsEL3qej7Rj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:30:35 -0500 (EST)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 938F14B861
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:30:35 -0500 (EST)
Received: by mail-pg1-f175.google.com with SMTP id v3so9211262pgh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=wDIyaaZP6Sx38V8+GZMMaiCN2LYY75lyx3Qk2zggJjY=;
 b=AsH0HY9ES//YrqC7aVzHEC/CizcXUu59joNA74umGoNmkMvxLqS0wCffNxDluDxyKo
 EAqtkusIPRaWsTDrdjn9/llFRUygCmGbtm2vECAI+G08t237WcwWOvji02G3iAivLRkK
 XtmAOzz+XqYsq2GDP6d9iwh7sTltvZI9fxPTUGYZWGyPiUekYEmb0NyP6jBH0aSpM1QX
 0tz4LyerHFPtS+ochp41KGvy5c0kQvu3ZBbrMJ4Y8A8WkC/7Ukk+1JDMNDpCdZbv+wUw
 sB78NjP1UXJBhqkf6gNp2CwQYVDksQEYfo+cDNGLFgrv7+7q0LQlQIxLu11hgJt4KH7o
 881Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=wDIyaaZP6Sx38V8+GZMMaiCN2LYY75lyx3Qk2zggJjY=;
 b=x9MwG5CgX2hRMQn9cmaYFKv8XKYwgr4L710XhktILpr/0Fq+0VDoG9PCPfcZStFG7O
 PsGRO/ZqwJy4zWZS8rmM6GdwoOBTmEgtRS9rNbwFdp4GRz2ZlKgJn7I9Jbe2hMX0GQCT
 MPY6WM0IqsXwcfFtdH1cq8k6KHb/8uRQGX82JE2Ii1NqIJLumQkGlWlsPQtDS00tduLT
 AaCYzXMlP0Sdw4ufrNxn2xXHNqCtzp2CVlYSj/ICLmNyk5TqMT64986hWwfjzb4mXGh0
 Q+Kj6Piurf7lUEbvY4LCz6zUxpXKP1pDPDRD8ILdc/YRFxsq8ziVEFEW06pVeMICDZ+F
 V0sw==
X-Gm-Message-State: ANoB5plwFZbv70+k5BfAjxytEKkCZtqgriN1BXNHt/tZTm4oIo3Uchr2
 DeYS7xU5aMfHPgTnSrWgj3ppyQ==
X-Google-Smtp-Source: AA0mqf74FM6U4ztV3LqdnGXHnnnSC43RbbAIDoSZcE8bsILwNcSluJ+18YStm6rGNZYFVpgbA3RNLg==
X-Received: by 2002:aa7:9a1c:0:b0:574:3e1d:72dd with SMTP id
 w28-20020aa79a1c000000b005743e1d72ddmr18119342pfj.19.1670884234340; 
 Mon, 12 Dec 2022 14:30:34 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 q13-20020aa7842d000000b0056d98e31439sm6499921pfn.140.2022.12.12.14.30.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 14:30:33 -0800 (PST)
Date: Mon, 12 Dec 2022 14:30:28 -0800
From: David Matlack <dmatlack@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common
 code
Message-ID: <Y5erhA1QOBhqnO5C@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-11-dmatlack@google.com>
 <CANgfPd-DaxszBe6vLQGe=LKNKx8bDX-AC_30qLVAyYkQXwN7WA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd-DaxszBe6vLQGe=LKNKx8bDX-AC_30qLVAyYkQXwN7WA@mail.gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Mon, Dec 12, 2022 at 10:24:31AM -0800, Ben Gardon wrote:
> On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
> >
> > Move struct kvm_page_fault to common code. This will be used in a future
> > commit to move the TDP MMU to common code.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
[...]
> > diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
> > index a9da33d4baa8..9f0ca920bf68 100644
> > --- a/include/kvm/mmu_types.h
> > +++ b/include/kvm/mmu_types.h
> > @@ -66,4 +66,48 @@ struct kvm_mmu_page {
> >         struct kvm_mmu_page_arch arch;
> >  };
> >
> > +struct kvm_page_fault {
> > +       /* The raw faulting address. */
> > +       const gpa_t addr;
> > +
> > +       /* Whether the fault was synthesized to prefetch a mapping. */
> > +       const bool prefetch;
> > +
> > +       /* Information about the cause of the fault. */
> > +       const bool write;
> > +       const bool exec;
> > +
> > +       /* Shifted addr, or result of guest page table walk if shadow paging. */
> > +       gfn_t gfn;
> 
> Is this redundant to have in common code? If we're not doing common
> shadow paging, then this is just addr shifted. Would this be better
> placed in the arch specific struct?

Yes it's redundant but it is actually used by the TDP MMU, unlike @addr.
So if anything I would rather move @addr to kvm_page_fault_arch.

> 
> > +
> > +       /* The memslot that contains @gfn. May be NULL. */
> > +       struct kvm_memory_slot *slot;
> > +
> > +       /* Maximum page size that can be created for this fault. */
> > +       u8 max_level;
> > +
> > +       /*
> > +        * Page size that can be created based on the max_level and the page
> > +        * size used by the host mapping.
> > +        */
> > +       u8 req_level;
> > +
> > +       /* Final page size that will be created. */
> > +       u8 goal_level;
> > +
> > +       /*
> > +        * The value of kvm->mmu_invalidate_seq before fetching the host
> > +        * mapping. Used to verify that the host mapping has not changed
> > +        * after grabbing the MMU lock.
> > +        */
> > +       unsigned long mmu_seq;
> 
> Should this be ifdef'ed with  KVM_ARCH_WANT_MMU_NOTIFIER?

I'll have to take a closer look, but probably yes.

> 
> > +
> > +       /* Information about the host mapping. */
> > +       kvm_pfn_t pfn;
> > +       hva_t hva;
> > +       bool map_writable;
> > +
> > +       struct kvm_page_fault_arch arch;
> > +};
> > +
> >  #endif /* !__KVM_MMU_TYPES_H */
> > --
> > 2.39.0.rc1.256.g54fd8350bd-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
