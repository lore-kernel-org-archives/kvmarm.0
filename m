Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CCB33D6
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 21:12:26 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id 202-20020a6218d3000000b005a89856900eso1378119pfy.14
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 13:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jZqpqHNnDrkVf5YnH4C4p2Du+MWFI+rsSboHjRikfo0=;
        b=cstTUl3cDjETi7Uy5k8lUK4jDXVH5n84ULJ8Qdzf8KUig6GFtpHB7w0eoI8Plhg2NM
         6FWa3l7sXNc+M6YDtvaFjXzlpRtWBMe5SojZXE91tPmgJMlFF/CW1ZZv81jiCr0fXexK
         lScdHryZlveE1J+z0J2TIi81MbXXQWHYdNInuM44+8VugSDN/fGG/tYGrW4Jcvq/Dl9n
         Ek7HnOVQiTB+e4FM6RTzQyIV1EEstxc2pOWecp5NaX9GOemJJxxrazzswOceIxFVcfln
         /s7eha+SalTSQycIbbCTH+sAFv5dgkYSrn8AD1goiYFHWVwKHCsyUeb7nev3pGjb/y5j
         CUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jZqpqHNnDrkVf5YnH4C4p2Du+MWFI+rsSboHjRikfo0=;
        b=NdBwLZPkyY7k+mifZV7tjw8Jh8fEMG8TDkFTj6YPRLpzEdRr0kWhjbEhltHubBdKLM
         6+jN9Nvfxb0jtjM45AW9nfYejPcRim4soCm9GJD908QUkPtQXs7JahP5sziOjR6Uh4s1
         yYzsivcKTc6+ebl4X27XdUiUj+Jam+uwUV1KputC6sWHIlRsCmCPfXYA/drVTAy7Y7y8
         oWqe8XN389pN8mIqQwbtHSpfySsC1UzZOLJ3Ow5YPiKkW351F0u6ZJq9mZV7j1rxj8Re
         lJyz8KTSbeIdsYrpEzW4r2fNPuc9YUWNwg4G6we0sZ1SCoBLiPIIG3lMbKRNgatLy4EV
         Ibgw==
X-Gm-Message-State: AO0yUKVUFKBAcTeiaXFd7tb77ZpYxF3hkTYPZmxZGJPxIScaoAZHAAnh
	+Qd3OrRh3w+v0jxi8+RhBN6y8R99JlQ=
X-Google-Smtp-Source: AK7set8UOj7NygywK+cGr/Rmvj7I4XEunDNhPQJfW5dsIVprbIkkXYFIqYFcViXFQ9A3GP588Pa1F52horE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fa4b:b0:237:2106:a861 with SMTP id
 dt11-20020a17090afa4b00b002372106a861mr826705pjb.0.1677186745595; Thu, 23 Feb
 2023 13:12:25 -0800 (PST)
Date: Thu, 23 Feb 2023 13:12:24 -0800
In-Reply-To: <CAOUHufZ0Ep4_Edo4OoeUVpVK4uFJF6_yVL=xSrQM8an_Vw4VKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-2-yuzhao@google.com>
 <Y/ee1s3XPGa62SFV@google.com> <CAOUHufZ0Ep4_Edo4OoeUVpVK4uFJF6_yVL=xSrQM8an_Vw4VKw@mail.gmail.com>
Message-ID: <Y/fWuGL5RN8fUIr5@google.com>
Subject: Re: [PATCH mm-unstable v1 1/5] mm/kvm: add mmu_notifier_test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 10:14=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 16, 2023, Yu Zhao wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 9c60384b5ae0..1b465df4a93d 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -875,6 +875,63 @@ static int kvm_mmu_notifier_clear_young(struct m=
mu_notifier *mn,
> > >       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gf=
n);
> > >  }
> > >
> > > +static bool kvm_test_clear_young(struct kvm *kvm, unsigned long star=
t,
> > > +                              unsigned long end, unsigned long *bitm=
ap)
> > > +{
> > > +     int i;
> > > +     int key;
> > > +     bool success =3D true;
> > > +
> > > +     trace_kvm_age_hva(start, end);
> > > +
> > > +     key =3D srcu_read_lock(&kvm->srcu);
> > > +
> > > +     for (i =3D 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > > +             struct interval_tree_node *node;
> > > +             struct kvm_memslots *slots =3D __kvm_memslots(kvm, i);
> > > +
> > > +             kvm_for_each_memslot_in_hva_range(node, slots, start, e=
nd - 1) {
> > > +                     gfn_t lsb_gfn;
> > > +                     unsigned long hva_start, hva_end;
> > > +                     struct kvm_gfn_range range =3D {
> > > +                             .slot =3D container_of(node, struct kvm=
_memory_slot,
> > > +                                                  hva_node[slots->no=
de_idx]),
> > > +                     };
> > > +
> > > +                     hva_start =3D max(start, range.slot->userspace_=
addr);
> > > +                     hva_end =3D min(end - 1, range.slot->userspace_=
addr +
> > > +                                            range.slot->npages * PAG=
E_SIZE - 1);
> > > +
> > > +                     range.start =3D hva_to_gfn_memslot(hva_start, r=
ange.slot);
> > > +                     range.end =3D hva_to_gfn_memslot(hva_end, range=
.slot) + 1;
> > > +
> > > +                     if (WARN_ON_ONCE(range.end <=3D range.start))
> > > +                             continue;
> >
> > Extend __kvm_handle_hva_range() instead of copy-pasting.  At a very qui=
ck glance,
> > I believe all that is needed is (minus sanity checks):
>=20
> Yes, will do.
>=20
> I do need to add one more parameter to kvm_gfn_range, because that's
> what the current kvm_arch_test_clear_young() needs, assuming that
> function is acceptable.
>=20
> Also, just a side note, from MM's POV, the following in
> __kvm_handle_hva_range() seems to forget to handle end =3D=3D 0, if that'=
s
> possible?

It's handled by the WARN_ON_ONCE() at the very top:

static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
						  const struct kvm_hva_range *range)
{
	if (WARN_ON_ONCE(range->end <=3D range->start))
		return 0;


>=20
>   hva_end =3D min(range->end, slot->userspace_addr + (slot->npages <<
> PAGE_SHIFT));
