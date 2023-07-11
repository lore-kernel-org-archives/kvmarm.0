Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8CC7F
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 02:59:21 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2b6f0508f54so79822881fa.3
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689044360; x=1691636360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DBmSxEV9koNvPnH4f6fQb1MyHlXgygw1qw/AWmL9NU=;
        b=jbRRZbz4ynuhPqqeV5apPzs0jqkJtDi55aZFCp3oS1Ky8RkTvPlwMnB4q/fiemRBoQ
         /nqmDMG2P1A6auw8vdVkBVLFNlCCKg5J2gfTl+c6qkohrCouZIFJFDxXVd83G/CNdJVI
         qpp4LD8m9YAEdXqPmRzBi1781HakxZf9US60Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689044360; x=1691636360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DBmSxEV9koNvPnH4f6fQb1MyHlXgygw1qw/AWmL9NU=;
        b=LkUFiYgeUINKnGzdF54XQi9zVfjgOZ3ZtSVn2mhucC4JMizD9FbqxCeShW6uKVgtnL
         /7ds1xdDR9xqvkD2EmkK7bmRqGG4rVHStkVAFZdtT7bXGbypN3SAR/bMbqt4Y8rGrkwa
         y6D6o/NhqnwckIdB3ZHfoCg2cENEfwhX4rDKncBFEyVdhGQ8xoh8zv+L+CJp6DifF9n1
         ExaYeb43EFZoqdgkAe+u3UL7X2xEDNr1aANqvcSxKGTBzNhBo4qw+sOuGSb3otncXVyP
         PL3W6eHtng9tD39GXnixK0Tw7Pm4koBJ+ifVIlqmf66vmhWdbgpOc9SjXZL8HY0w2mbx
         3Iaw==
X-Gm-Message-State: ABy/qLZ+lLljyPxBHNKkLjWrhjtatFgNGO0ybf6gaOEeCVEZ48A6LWC0
	LUPjCn6OBsFYi4rb2lEm2PMi8TTEZLMnaPxdJKccyQ==
X-Google-Smtp-Source: APBJJlFhZxK1fGMNnOjl8Qk8f7Az5wy8Xg34SBiq6VLsMfXYX+pfTJMvsTItHqfjvno05fAVxl0LMgHzDd+1uLzcle4=
X-Received: by 2002:a2e:7e12:0:b0:2b7:1b63:4657 with SMTP id
 z18-20020a2e7e12000000b002b71b634657mr5157080ljc.37.1689044359940; Mon, 10
 Jul 2023 19:59:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com> <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
 <20230706155805.GD3894444@ls.amr.corp.intel.com> <CAD=HUj6GiK3TSSe7UY8C2Jd+3tjZNBa-TLgk-UodyL=E+qKavg@mail.gmail.com>
 <20230710163448.GE3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230710163448.GE3894444@ls.amr.corp.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 11 Jul 2023 11:59:08 +0900
Message-ID: <CAD=HUj6ZEzVEFgn_J_9EPNMj5i-N=MSc0xZF8FweqrgTxUks0g@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 11, 2023 at 1:34=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Fri, Jul 07, 2023 at 10:35:02AM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > > index e44ab512c3a1..b1607e314497 100644
> > > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > >
> > > > > ...
> > > > >
> > > > > > @@ -2937,6 +2943,7 @@ static int mmu_set_spte(struct kvm_vcpu *=
vcpu, struct kvm_memory_slot *slot,
> > > > > >       bool host_writable =3D !fault || fault->map_writable;
> > > > > >       bool prefetch =3D !fault || fault->prefetch;
> > > > > >       bool write_fault =3D fault && fault->write;
> > > > > > +     bool is_refcounted =3D !fault || fault->is_refcounted_pag=
e;
> > > > >
> > > > > Just wonder, what if a non-refcounted page is prefetched?  Or is =
it possible in
> > > > > practice?
> > > >
> > > > Prefetching is still done via gfn_to_page_many_atomic, which sets
> > > > FOLL_GET. That's fixable, but it's not something this series curren=
tly
> > > > does.
> > >
> > > So if we prefetch a page, REFCOUNTED bit is cleared unconditionally w=
ith this
> > > hunk.  kvm_set_page_{dirty, accessed} won't be called as expected for=
 prefetched
> > > spte.  If I read the patch correctly, REFCOUNTED bit in SPTE should r=
epresent
> > > whether the corresponding page is ref-countable or not, right?
> > >
> > > Because direct_pte_prefetch_many() is for legacy KVM MMU and FNAME(pr=
efetch_pte)
> > > is shadow paging, we need to test it with legacy KVM MMU or shadow pa=
ging to hit
> > > the issue, though.
> > >
> >
> > direct_pte_prefetch_many and prefetch_gpte both pass NULL for the
> > fault parameter, so is_refcounted will evaluate to true. So the spte's
> > refcounted bit will get set in that case.
>
> Oops, my bad.  My point is "unconditionally".  Is the bit always set for
> non-refcountable pages?  Or non-refcountable pages are not prefeched?

The bit is never set for non-refcounted pages, and is always set for
refcounted pages. The current series never prefetches non-refcounted
pages, since it continues to use the gfn_to_page_many_atomic API.

-David
