Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496B9C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 22:47:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E424B1A9;
	Mon,  9 May 2022 18:47:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bgkfkRSclWEv; Mon,  9 May 2022 18:47:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C65C4B10A;
	Mon,  9 May 2022 18:47:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E27B4B0DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:47:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eBCFWV54IorY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 18:47:19 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4054049E2B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:47:19 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id q4so12313532plr.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 15:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=HqfHpv0KlKI7R/yNkzZ4Z0O6e/LDYyZQrPZnAWmT71E=;
 b=gBcOu1AAKpSXofktmoX+I7Bsue1fm8qXDW5SAW2z78o+w1vB0SSgx4IklNVsM6AAzZ
 rRanfgSmN+B+INR8d1D8AkH0tSIFfSoPJ6A1yAUns87zIIglHwwo2m30NPBXwdX6TkWW
 SEK+nrP1tpdnPeU3iaz+GJi7tRkKbBkzOi5H4MwWVtOkVkQ/68e+8sIXf2yl0Iu4H6Hw
 OTlElUOOi39t2GII8YY4Ffe6Y2H/8k+QiYj5KX2vieq1bsIMVrRUSDXE38zuU0bl3Ntb
 BAua97uPHpzdm6iAaITSrNyyPFguQ121LRQWWdm6DNlKn8HkFJ2uJNJ4JUyeP1z+xoqX
 Ts5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HqfHpv0KlKI7R/yNkzZ4Z0O6e/LDYyZQrPZnAWmT71E=;
 b=MZs/LBd0C8gjcoiTKhSQwd3YG9/Jnhygm2YGkwNSwh6pJ6GtYKnQttYMmG6x2AFrco
 Q/uv71GzM1WeDAf6nb6UgEpdO5BDkjXybDBfPZw2d5856N1nESxs5wL8nTburu8aMqII
 pUMgeqCFCPU9VL9EeLWZuj722HUswitqJEY4FfhBzwAGWzKGOB4upF8NkB42GLEMADAx
 /ntvp8QK8/O0LtFgwlJdThv4mxn7Iobuk7bT3RypOSirgnLqoB/MC7PZccAL27Xusi6Z
 zVhHLG2be5IubuUhi8FlHsrGjuMdctOtDvAhG5ImP9+l3BofS/4RXxikHbGzM+xT992+
 OrBA==
X-Gm-Message-State: AOAM531gkfY0uPcCDY94kcWtA5XZxgI7sm23DXBlSYxDC8Y5SXUMt1VR
 OHwXquLaCiIxDCYDhVA0mWWm/w==
X-Google-Smtp-Source: ABdhPJzlAs+WsB2F0OyBXHzmXsCE5yKPzcqLqI7jJtlr5bkfm/U8b2uxGA/nhaBtBW85p0tqZlWDJg==
X-Received: by 2002:a17:902:c2c7:b0:159:9f9:85f3 with SMTP id
 c7-20020a170902c2c700b0015909f985f3mr18070842pla.18.1652136437989; 
 Mon, 09 May 2022 15:47:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 3-20020a17090a018300b001cb978f906esm259814pjc.0.2022.05.09.15.47.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 15:47:17 -0700 (PDT)
Date: Mon, 9 May 2022 22:47:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YnmZ8jUaWHCuQ++r@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
 <YnlFzMpJZNfFuFic@google.com>
 <CALzav=fTTf8=u1i0pePxAHtuHr4Q_+N1-d8x09MtRk+6y250rw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=fTTf8=u1i0pePxAHtuHr4Q_+N1-d8x09MtRk+6y250rw@mail.gmail.com>
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

On Mon, May 09, 2022, David Matlack wrote:
> On Mon, May 9, 2022 at 9:48 AM Sean Christopherson <seanjc@google.com> wrote:
> > > +static void kvm_nested_mmu_try_split_huge_pages(struct kvm *kvm,
> > > +                                             const struct kvm_memory_slot *slot,
> > > +                                             gfn_t start, gfn_t end,
> > > +                                             int target_level)
> > > +{
> > > +     int level;
> > > +
> > > +     /*
> > > +      * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> > > +      * down to the target level. This ensures pages are recursively split
> > > +      * all the way to the target level. There's no need to split pages
> > > +      * already at the target level.
> > > +      */
> > > +     for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
> >
> > Unnecessary braces.
> 
> The brace is unnecessary, but when the inner statement is split across
> multiple lines I tend to prefer using braces. (That's why I did the
> same in the other patch and you had the same feedback.) I couldn't
> find any guidance about this in CodingStyle so I'm fine with getting
> rid of the braces if that's what you prefer.

The style varies by subsystem, e.g. I believe perf requires braces in this case.
Absent a "hard" rule, I value consistency above all else, e.g. because KVM doesn't
(usually) include the braces, I started looking for the second statement, i.e. the
lack of an opening brace is an indicator (to me at elast) that a loop/if contains
a single statement.

I actually like Golang's forced braces, but mostly because they are 100% mandatory
and so all code is consistent.
 
> > > +             slot_handle_level_range(kvm, slot,
> > > +                                     nested_mmu_try_split_huge_pages,
> > > +                                     level, level, start, end - 1,
> > > +                                     true, false);
> >
> > IMO it's worth running over by 4 chars to drop 2 lines:
> 
> Will do.
> 
> >
> >         for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
> >                 slot_handle_level_range(kvm, slot, nested_mmu_try_split_huge_pages,
> >                                         level, level, start, end - 1, true, false);
> > > +     }
> > > +}
> > > +
> > >  /* Must be called with the mmu_lock held in write-mode. */
> >
> > Add a lockdep assertion, not a comment.
> 
> Agreed but this is an existing comment, so better left to a separate patch.

Doh, I mistook the /* for a +.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
