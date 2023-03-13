Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC77322B
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 17:27:00 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id o32so11665642vsv.12
        for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 10:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678728420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKAQ9vOuh2KbA3c9Dmk/0KLdau6scnjMAijm65LwHDQ=;
        b=bFrBbd9MqoqKlf1DgxJOA+BZad7IJjXfnDtmNdGIvMWWZzPBWRyKirnvrmAP/kn1SO
         dPoF3gsxlTZI1AOU/bIL2ObFYQ3CJn0OSrfvzYNnhQvptRzTvvkKqRctcmljpPmFcxXZ
         /qS46H511O4zxtXRLEXiUOEJraFXS9j5skvYBGRKrlgjNAoqI74347EFc2V6Rx6EMx3O
         jZtNaAcdWrQYPZBnGTFMvh3682X6/x12D35XAuJnww2ew/HArrdrucosNn2yLE7st4mp
         vzO/9I8tW/dIOyiMcJMmo1BYKQY6EFWL/9ye+/PUA7HEipzX6FaHfCYwU2kqU0WZKSQg
         lTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678728420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LKAQ9vOuh2KbA3c9Dmk/0KLdau6scnjMAijm65LwHDQ=;
        b=qHdyT5MFV/Q49bYakuitgD++diMEm1M+OzGEdIR3S9oMwEkXbWfqNXyKKfUJFB10L4
         EL34xHfu4tviU69VvE7sa7s7QYxOW6Krlg3JY4uNkYNdFd/btKVQ74pzWJcbPCRLAlXm
         r0I8H3DEmNghBG7adUTv778eaWh+RUCjV1uSt+B4V1GPC6+GuBnRCtmAKUfLCITBwh5v
         4v5GRkwHhYudDrVwThwVy7NxHApFSMwr42zYmd9NP8LJrRPeAz0ChisFNECl+Oh269RA
         eDibMdVwDKxg1zucs/iwgc68C7utJwgmZWNP9sbjzTc3TD+1eNnH4gepbFkv9S9OL8WI
         4uZw==
X-Gm-Message-State: AO0yUKVPxCbiFQQPJXZvWWM6KsNwAPNHE0LQ/+1hsjY0HDi70JR8uJOc
	26rJVfNpc3Y4LEWsqd3WOFrGPO0snUepqecw7kzFk3/q6dWJr+d5G1k=
X-Google-Smtp-Source: AK7set+zFXTcBkpbscHx01ebZLKXIBXMOwslWE6/EuYSMnF7TkuGSMjDEta44Nky4LY+x1Soyzr9BWRcwRkI0Eq1Mo4=
X-Received: by 2002:a67:f350:0:b0:423:e6b4:9582 with SMTP id
 p16-20020a67f350000000b00423e6b49582mr4032552vsm.4.1678728419924; Mon, 13 Mar
 2023 10:26:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230313091425.1962708-1-maz@kernel.org> <20230313091425.1962708-2-maz@kernel.org>
 <ZA9HAQtkCDwFXcsm@google.com> <CALzav=c3aKNT-7CzkrFC8YCCwj-E16JYWwsmOV-HaLbODG67hQ@mail.gmail.com>
 <ZA9bhVQBtgES7Qqi@google.com>
In-Reply-To: <ZA9bhVQBtgES7Qqi@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 13 Mar 2023 10:26:33 -0700
Message-ID: <CALzav=dx=nAL=kW0fvtuHdj0T68VXSs7dnsVMB7qQcHo6v5mVA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 13, 2023 at 10:21=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Mon, Mar 13, 2023, David Matlack wrote:
> > On Mon, Mar 13, 2023 at 8:53=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > +David
> > >
> > > On Mon, Mar 13, 2023, Marc Zyngier wrote:
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 7113587222ff..d7b8b25942df 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -666,14 +666,23 @@ static int get_user_mapping_size(struct kvm *=
kvm, u64 addr)
> > > >                                  CONFIG_PGTABLE_LEVELS),
> > > >               .mm_ops         =3D &kvm_user_mm_ops,
> > > >       };
> > > > +     unsigned long flags;
> > > >       kvm_pte_t pte =3D 0;      /* Keep GCC quiet... */
> > > >       u32 level =3D ~0;
> > > >       int ret;
> > > >
> > > > +     /*
> > > > +      * Disable IRQs so that we hazard against a concurrent
> > > > +      * teardown of the userspace page tables (which relies on
> > > > +      * IPI-ing threads).
> > > > +      */
> > > > +     local_irq_save(flags);
> > > >       ret =3D kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
> > > > -     VM_BUG_ON(ret);
> > > > -     VM_BUG_ON(level >=3D KVM_PGTABLE_MAX_LEVELS);
> > > > -     VM_BUG_ON(!(pte & PTE_VALID));
> > > > +     local_irq_restore(flags);
> > > > +
> > > > +     /* Oops, the userspace PTs are gone... */
> > > > +     if (ret || level >=3D KVM_PGTABLE_MAX_LEVELS || !(pte & PTE_V=
ALID))
> > > > +             return -EFAULT;
> > >
> > > I don't think this should return -EFAULT all the way out to userspace=
.  Unless
> > > arm64 differs from x86 in terms of how the userspace page tables are =
managed, not
> > > having a valid translation _right now_ doesn't mean that one can't be=
 created in
> > > the future, e.g. by way of a subsequent hva_to_pfn().
> > >
> > > FWIW, the approach x86 takes is to install a 4KiB (smallest granuale)=
 translation,
> >
> > If I'm reading the ARM code correctly, returning -EFAULT here will
> > have that effect. get_user_mapping_size() is only called by
> > transparent_hugepage_adjust() which returns PAGE_SIZE if
> > get_user_mapping_size() returns anything less than PMD_SIZE.
>
> No, this patch adds
>
> +               int sz =3D get_user_mapping_size(kvm, hva);
> +
> +               if (sz < 0)
> +                       return sz;
> +
> +               if (sz < PMD_SIZE)
> +                       return PAGE_SIZE;
> +

Gah, I just looked at the trimmed patch in the reply. Thanks for
pointing that out.
