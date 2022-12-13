Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37F615B0
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 01:06:30 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-3bfd998fa53so171945657b3.5
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 17:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=um9fA14qfKqLTd4PnYbnNbTpwvE6qfR8mH24h4ms5trfo8kdzz7zq+86UFSuQgPQGY
         Q9OQsRjOooSrMiFQcAe9rzc8iJs8W/wX7xtd4lEXCULa/yJLpxuPvdr+bjYCd/E9VrUH
         guPoVTunaSPbH8klD0MQpFy89hYy7i3WLycMtzandm83WDTxa3hgCNET0x5RHRPzEogj
         ff+rXuTz5MlJLHhvATs9b0XI9Pi3I6sX/apdG2fz2jO0HpUpQL6EZugX58svEegqjkiw
         1K4+3xd+mW1BjZjnxquMet2lmVKQ+KxGKEBLZ2zLl3T8yFxrEnzTfOv90DIeHBUrY+gk
         meYw==
X-Gm-Message-State: ANoB5pkw8+SBUpJw5WQd8KsgIxCgYz7+4ILeBqEAe5ndJVoru6FFAvNX
	Ag2n0oe84AU3qw2B4pTWfnzGyoAzyE01+VmVw3ms4g==
X-Google-Smtp-Source: AA0mqf6UC/AYrRSJ+MEPYQjgdOAUYa1qq71cF4IZc0dJwhxjGVc2rf3hOO63DAbZlhHX9B51ehBcsSfwU5FzFAQu4JA=
X-Received: by 2002:a81:4d6:0:b0:402:7be6:f265 with SMTP id
 205-20020a8104d6000000b004027be6f265mr4263609ywe.188.1670893589689; Mon, 12
 Dec 2022 17:06:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-3-dmatlack@google.com>
 <48f4df00-8ef6-042f-c9ae-4023c4f70058@redhat.com>
In-Reply-To: <48f4df00-8ef6-042f-c9ae-4023c4f70058@redhat.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 12 Dec 2022 17:06:03 -0800
Message-ID: <CALzav=crvFwCo50N5QOFD5FstrR9wJ=FmQAkYDHaKzQuatCNfw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/37] KVM: MMU: Move struct kvm_mmu_page_role into
 common code
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221213010603.VJkcpfl1Fkt1m9DwROMUegvpMJkOlEYPlbhbMMmp0DI@z>

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
