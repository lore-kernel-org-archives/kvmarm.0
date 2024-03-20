Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EDC69DE9
	for <kvmarm@lists.linux.dev>; Wed, 20 Mar 2024 20:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710968090; cv=none; b=cOQjN9Fvvz1xy0qGcRAjatssvcz4yrWc+Iux/WlChUTra16NF9aJdJO1Xb0YXxTx2z6HjhmmGSlfiCuN43NxguDDdeixhlHZrCHznbZQUwOWA/2pFMXH+YO6bx2HmtivThYNMd5SgEB1Wr1v1tMrgsEgmgdLargxw+xdzWOGoJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710968090; c=relaxed/simple;
	bh=XhFojGRriaPCLI2McEy+lswO1UFG6gWja66SzVIzjrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NqOsJBAZ3Xw/mI9cO6w1Q61ftx9yNtS+M9Nrm3EpFUXM6kSOvJ8kZ0gdftjCVOlcVEzqiJvcdp83xlIB0SM7PEMTYLh+SrRc4p9XQnCEIv6qtmNyIsRaglhWA2F9XUQqj47SFXDJhEIaF28Sb1TSzsYHoyuCyIdhfrY5v9YP9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHuOxjxi; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHuOxjxi"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-414633f7a52so2631515e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 Mar 2024 13:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710968086; x=1711572886; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9OJbJMLYpLTqaMrgQ5F4CTDV8TnBXcToRrQB4UYTw0=;
        b=iHuOxjxihfxhh+nihBd8RtilLYA48Lbj36NvyVPo6vs7zIH2yoXKw/zd2onhaV9aU8
         D71cmFC2jGKTk+c4F7hHR0rcTC0bZwEpaPETCzAwHbfpQ1KbxitTuIadQLxG+xlFcJhU
         DKgMqcbODWSleP7qp3UaGTiKBp7q8WWiJBIAs7T5HY5ymD6h0ZUYWrdqq8YpYBACtfCa
         hqew1CuxCDlZSuv5wF1PpErM62WsFJxJNkbM9JtLuX4ZM++zBQdQEWiizIzT0zTt9CUi
         yzgrC+2BW9oap2rBhwxcJGNzdIuQ+CY+qJi6LmetmIlIQm06CWA6nLOE7wxcFH6ONYPT
         t3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710968086; x=1711572886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M9OJbJMLYpLTqaMrgQ5F4CTDV8TnBXcToRrQB4UYTw0=;
        b=pA6sMI4pOUV/R86FR5Ge6yDonNXHbUzeNvlODX/bDOC29X+IPcr1e/6pDcGUv9pcbv
         WvodU2QuZveKrh1KwsYHIVtnzsfkdWxetBhSzkXq7i1u9LsMBzmn8RTtduuNSaVPvU5I
         LCeNI030vQQ5brWfdZyfYzUzVPFm2M8e4SEUredEdnqcludh7FzTJNdcbxAh7UPEGIiK
         QcAuh0pIR7ik9hdY7+R40dB6+xbIQP6eqksflfBgpGPm38Ydf6WZ8UtytRGUTqx3UMYG
         p5GLJV8iR3qMqwhEwlMCt9rCYLIKKwgnuV075iEQeePyEbcWNeZQSyiu7bsZljo+ySoe
         rwAQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1liXfVpFfd1rIGmFwlNy4mGeLwmjNTfIwWyR7dusk2zv/dXXCfq49jjXYdLFZtnN+XSCjKW+lz38FEHHQPrLonWhkuUhu
X-Gm-Message-State: AOJu0YwsMVKsnpkn2KaDnqLQ1RI8SkddWdUItF4Skkq+v6cTD34B+4gm
	316w0t0cH1dlkQ6ET2aR7ubD1r7MSiAFHY7UO7nzQLZXItiZhJHZl7VS+lIcgGJxyKHKICZ5LVX
	/838dvF4CLEY6GGMWQjBb0WcKWS/jfRTnOUOZ
X-Google-Smtp-Source: AGHT+IH87XnoWDBP/JxyANKouNDuOvhC2d4maSHSsazIVN31uoJwJMNqdiRF8UnED+uAboiXZOXtAHHYnunpxv28wyE=
X-Received: by 2002:a05:6000:4020:b0:341:906b:3351 with SMTP id
 cp32-20020a056000402000b00341906b3351mr284860wrb.0.1710968086423; Wed, 20 Mar
 2024 13:54:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZfG801lYHRxlhZGT@google.com> <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
 <ZfHKoxVMcBAMqcSC@google.com> <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com>
 <ZfHhqzKVZeOxXMnx@google.com> <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
 <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com> <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
 <ZfMjCXZWuUD76r_5@google.com> <ZfMxj_e7M_toVR3a@google.com> <ZfSMaUFa5hsPP-eR@google.com>
In-Reply-To: <ZfSMaUFa5hsPP-eR@google.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 20 Mar 2024 13:54:07 -0700
Message-ID: <CAJHvVchGxd3ECA4mySYmUBNgq+N_4ws3aE6thSjBtjicJDJD=g@mail.gmail.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
To: Sean Christopherson <seanjc@google.com>
Cc: David Stevens <stevensd@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024 at 10:59=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Mar 14, 2024, Sean Christopherson wrote:
> > +Alex, who is looking at the huge-VM_PFNMAP angle in particular.
>
> Oof, *Axel*.  Sorry Axel.


No worries. Believe it or not this happens frequently. :) I'm well
past being bothered about it.

>
>
> > On Thu, Mar 14, 2024, Sean Christopherson wrote:
> > > -Christ{oph,ian} to avoid creating more noise...
> > >
> > > On Thu, Mar 14, 2024, David Stevens wrote:
> > > > Because of that, the specific type of pfns that don't work right no=
w are
> > > > pfn_valid() && !PG_Reserved && !page_ref_count() - what I called th=
e
> > > > non-refcounted pages in a bad choice of words. If that's correct, t=
hen
> > > > perhaps this series should go a little bit further in modifying
> > > > hva_to_pfn_remapped, but it isn't fundamentally wrong.
> > >
> > > Loosely related to all of this, I have a mildly ambitious idea.  Well=
, one mildly
> > > ambitious idea, and one crazy ambitious idea.  Crazy ambitious idea f=
irst...
> > >
> > > Something we (GCE side of Google) have been eyeballing is adding supp=
ort for huge
> > > VM_PFNMAP memory, e.g. for mapping large amounts of device (a.k.a. GP=
U) memory
> > > into guests using hugepages.  One of the hiccups is that follow_pte()=
 doesn't play
> > > nice with hugepages, at all, e.g. even has a "VM_BUG_ON(pmd_trans_hug=
e(*pmd))".
> > > Teaching follow_pte() to play nice with hugepage probably is doing, b=
ut making
> > > sure all existing users are aware, maybe not so much.


Right. The really basic idea I had was, to modify remap_pfn_range so
it can, if possible (if it sees a (sub)range which is aligned + big
enough), it can just install a leaf pud or pmd instead of always going
down to the pte level.

follow_pte is problematic though, because it returns a pte
specifically so it's unclear to me how to have it "just work" for
existing callers with an area mapped this way. So I think the idea
would be to change follow_pte to detect this case and bail out
(-EINVAL I guess), and then add some new function which can properly
support these mappings.

>
> > >
> > > My first (half baked, crazy ambitious) idea is to move away from foll=
ow_pte() and
> > > get_user_page_fast_only() for mmu_notifier-aware lookups, i.e. that d=
on't need
> > > to grab references, and replace them with a new converged API that lo=
cklessly walks
> > > host userspace page tables, and grabs the hugepage size along the way=
, e.g. so that
> > > arch code wouldn't have to do a second walk of the page tables just t=
o get the
> > > hugepage size.
> > >
> > > In other words, for the common case (mmu_notifier integration, no ref=
erence needed),
> > > route hva_to_pfn_fast() into the new API and walk the userspace page =
tables (probably
> > > only for write faults, to avoid CoW compliciations) before doing anyt=
hing else.
> > >
> > > Uses of hva_to_pfn() that need to get a reference to the struct page =
couldn't be
> > > converted, e.g. when stuffing physical addresses into the VMCS for ne=
sted virtualization.
> > > But for everything else, grabbing a reference is a non-goal, i.e. act=
ually "getting"
> > > a user page is wasted effort and actively gets in the way.
> > >
> > > I was initially hoping we could go super simple and use something lik=
e x86's
> > > host_pfn_mapping_level(), but there are too many edge cases in gup() =
that need to
> > > be respected, e.g. to avoid mapping memfd_secret pages into KVM guest=
s.  I.e. the
> > > API would need to be a formal mm-owned thing, not some homebrewed KVM=
 implementation.
> > >
> > > I can't tell if the payoff would be big enough to justify the effort =
involved, i.e.
> > > having a single unified API for grabbing PFNs from the primary MMU mi=
ght just be a
> > > pie-in-the-sky type idea.

Yeah, I have been thinking about this.

One thing is, KVM is not the only caller of follow_pte today. At least
naively it would be nice if any existing callers could benefit from
this new support, not just KVM.

Another thing I noticed is, most callers don't need much; they don't
need a reference to the page, they don't even really need the pte
itself. Most callers just want a ptl held, and they want to know the
pgprot flags or whether the pte is writable or not, and they want to
know the pfn for this address. IOW follow_pte is sort of overkill for
most callers.

KVM is a bit different, it does call GUP to get the page. One other
thing is, KVM at least on x86 also cares about the "level" of the
mapping, in host_pfn_mapping_level(). That code is all fairly x86
specific so I'm not sure how to generalize it. Also I haven't looked
closely at what's going on for other architectures.

I'm not sure yet where is the right place to end up, but I at least
think it's worth trying to build some general API under mm/ which
supports these various things.

In general I'm thinking of proceeding in two steps. First,
enlightening remap_pfn_range, updating follow_pte to return -EINVAL,
and then adding some new function which tries to be somewhat close to
a drop-in replacement for existing follow_pte callers. Once I get that
proof of concept working / tested, I think the next step is figuring
out how we can extend it a bit to build some more general solution
like Sean is describing here.

> > >
> > > My second, less ambitious idea: the previously linked LWN[*] article =
about the
> > > writeback issues reminded me of something that has bugged me for a lo=
ng time.  IIUC,
> > > getting a writable mapping from the primary MMU marks the page/folio =
dirty, and that
> > > page/folio stays dirty until the data is written back and the mapping=
 is made read-only.
> > > And because KVM is tapped into the mmu_notifiers, KVM will be notifie=
d *before* the
> > > RW=3D>RO conversion completes, i.e. before the page/folio is marked c=
lean.
> > >
> > > I _think_ that means that calling kvm_set_page_dirty() when zapping a=
 SPTE (or
> > > dropping any mmu_notifier-aware mapping) is completely unnecessary.  =
If that is the
> > > case, _and_ we can weasel our way out of calling kvm_set_page_accesse=
d() too, then
> > > with FOLL_GET plumbed into hva_to_pfn(), we can:
> > >
> > >   - Drop kvm_{set,release}_pfn_{accessed,dirty}(), because all caller=
s of hva_to_pfn()
> > >     that aren't tied into mmu_notifiers, i.e. aren't guaranteed to dr=
op mappings
> > >     before the page/folio is cleaned, will *know* that they hold a re=
fcounted struct
> > >     page.
> > >
> > >   - Skip "KVM: x86/mmu: Track if sptes refer to refcounted pages" ent=
irely, because
> > >     KVM never needs to know if a SPTE points at a refcounted page.
> > >
> > > In other words, double down on immediately doing put_page() after gup=
() if FOLL_GET
> > > isn't specified, and naturally make all KVM MMUs compatible with pfn_=
valid() PFNs
> > > that are acquired by follow_pte().
> > >
> > > I suspect we can simply mark pages as access when a page is retrieved=
 from the primary
> > > MMU, as marking a page accessed when its *removed* from the guest is =
rather nonsensical.
> > > E.g. if a page is mapped into the guest for a long time and it gets s=
wapped out, marking
> > > the page accessed when KVM drops its SPTEs in response to the swap ad=
ds no value.  And
> > > through the mmu_notifiers, KVM already plays nice with setups that us=
e idle page
> > > tracking to make reclaim decisions.
> > >
> > > [*] https://lwn.net/Articles/930667
