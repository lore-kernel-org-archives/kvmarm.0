Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BE0C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 01:06:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCAA84B92D;
	Mon, 12 Dec 2022 20:06:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gFatvrSJBW4f; Mon, 12 Dec 2022 20:06:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83A004B922;
	Mon, 12 Dec 2022 20:06:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 789D34B922
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:06:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3aylRBFZTeGk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 20:06:30 -0500 (EST)
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57B524B8C8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:06:30 -0500 (EST)
Received: by mail-yw1-f182.google.com with SMTP id
 00721157ae682-3c090251d59so172091647b3.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=pv4WCEHXWY+FV1YUq8UNcPDkKm6bq2JSRGE//Kj9vf8=;
 b=nHZzxj7Q780CVpKNF5gPN9HC44/Nc5HxGgyb1Juqwj1LdHZaoEfIug7PLPSpIoG2yv
 bmGt6M4gEviMg/4oleu94/zXTiZWfGijEovvaEHGgA7Eev1ScUr3lmzTjd64Mi03kCxs
 PbGxjVHqOnyt6ZPcxJwRG/wcbDAMZUx3Xl4SiOpcV0axmJA2GnEXju4M06z4rBwHhhEb
 yE957qAZ7PBaas2oZC443pTFXpt0xmYGnt5zUCk7Qk2H1quPnvfsIn/n2xF6RlLVxEn/
 7qsqOx/N1UaziUkHy3R+gnhN/7hTYyhLpEA7pfvyzNtgwB54yoGqLe9EO7E5FBPlJUQ0
 OJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=pv4WCEHXWY+FV1YUq8UNcPDkKm6bq2JSRGE//Kj9vf8=;
 b=WJvwmQ9yq9JiadHC0ov4BQs/jPJEWTgEmfSZqrOl1JqIre0N/0+xyVum1RGoSeuIk6
 ldZJ5zjD2C/1R0E7F/JU8fv9Vp2RSFxidltlXPf46LfPtYXhaA7C39rhRSMxpCbhYzPL
 pDV9sh00BaCto77JXb/+jmtFNT+oBqY4QB83sIuNjpHKisyYsXAB5bCqXbCynnSL4itT
 HS9PZaWVdJc66mhIEkoBKtQFcBjyTwlKmj27IW4va8j/2pxBV53ScLTFjdO/AisCnGJl
 /jYCeqzrWePUc9oyI0pbhpZQgVpt9p/UM/w1yMj3qD2DPu9+yAbd9FDEWdEei4Lt90FK
 Y7uw==
X-Gm-Message-State: ANoB5pmaLgoq7Vz41Ke7KfxhTBuS8PnUFyF545eo4pUNMyI0E38IUP2L
 txgFn9s16MKw+2iuykMMqeWWoMFbOO6KTS/297zUCA==
X-Google-Smtp-Source: AA0mqf6UC/AYrRSJ+MEPYQjgdOAUYa1qq71cF4IZc0dJwhxjGVc2rf3hOO63DAbZlhHX9B51ehBcsSfwU5FzFAQu4JA=
X-Received: by 2002:a81:4d6:0:b0:402:7be6:f265 with SMTP id
 205-20020a8104d6000000b004027be6f265mr4263609ywe.188.1670893589689; Mon, 12
 Dec 2022 17:06:29 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-3-dmatlack@google.com>
 <48f4df00-8ef6-042f-c9ae-4023c4f70058@redhat.com>
In-Reply-To: <48f4df00-8ef6-042f-c9ae-4023c4f70058@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Dec 2022 17:06:03 -0800
Message-ID: <CALzav=crvFwCo50N5QOFD5FstrR9wJ=FmQAkYDHaKzQuatCNfw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/37] KVM: MMU: Move struct kvm_mmu_page_role into
 common code
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 Ben Gardon <bgardon@google.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Yu Zhao <yuzhao@google.com>,
 xu xin <cgel.zte@gmail.com>, Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

On Mon, Dec 12, 2022 at 3:11 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/8/22 20:38, David Matlack wrote:
> > +/*
> > + * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
> > + * also includes TDP pages) to determine whether or not a page can be used in
> > + * the given MMU context.
> > + */
> > +union kvm_mmu_page_role {
> > +     u32 word;
> > +     struct {
> > +             struct {
> > +                     /* The address space ID mapped by the page. */
> > +                     u16 as_id:8;
> > +
> > +                     /* The level of the page in the page table hierarchy. */
> > +                     u16 level:4;
> > +
> > +                     /* Whether the page is invalid, i.e. pending destruction. */
> > +                     u16 invalid:1;
> > +             };
> > +
> > +             /* Architecture-specific properties. */
> > +             struct kvm_mmu_page_role_arch arch;
> > +     };
> > +};
> > +
>
> Have you considered adding a tdp_mmu:1 field to the arch-independent
> part?  I think that as long as _that_ field is the same, there's no need
> to have any overlap between TDP MMU and shadow MMU roles.
>
> I'm not even sure if the x86 TDP MMU needs _any_ other role bit.  It
> needs of course the above three, and it also needs "direct" but it is
> used exactly to mean "is this a TDP MMU page".  So we could have
>
> union {
>         struct {
>                 u32 tdp_mmu:1;
>                 u32 invalid:1;
>                 u32 :6;
>                 u32 level:8;
>                 u32 arch:8;
>                 u32 :8;
>         } tdp;
>         /* the first field must be "u32 tdp_mmu:1;" */
>         struct kvm_mmu_page_role_arch shadow;

We could but then that prevents having common fields between the
Shadow MMU and TDP MMU. For example, make_spte() and
make_huge_page_split_spte() use sp->role.level regardless of TDP or
Shadow MMU, and is_obsolete_sp() uses sp->role.invalid. Plus then you
need the `arch:8` byte for SMM.

It's possible to make it work, but I don't see what the benefit would be.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
