Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C311822D4
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213022; cv=none; b=ZVeSCpEXyvOa8+1VReElyttnFpRlCGzOX+91FuDxk6tnE1DbUmKrq7YDeip0k/LvkpSwkrNbQF2Knu7oLsmEi6wZSAY9eQzloei2jM8zHEE8rlxZxwmg3OnvlCIKTZhYzwl9jYpELeMcVsx6xjij3ALq5cCfEtL3SWyvULoD21s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213022; c=relaxed/simple;
	bh=qvzOGVZF1aFjcNNXoWdAyWZv4lQeSovWWQTrEs6pNdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aoRqN3oc7tIhx/2Yhh3XOBj0HPWpf7TpbcAzD9bew5/UyWb1jxqLEOxKG0x46/Q0lIvWWiNvS7qOBiiG7vAJoSLv/QvC7KMif+gqteMtqIjFiffqQyU0LD0F7505RkOQ6X9M0fLoFhoXn6iNN0t/w2JM1Xb4qMIJofVa4ny2pt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KzL2J8Ks; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KzL2J8Ks"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df773f9471fso133075276.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 10:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718213020; x=1718817820; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0uZvClGSP7b0LMzzAPVM0AhM29ZDe2y2D54OZuyJ4o=;
        b=KzL2J8KsBodp3/QKW4QGaj05VKwKRTbALUBaJHVfCestmWt1B/yKaGrwyWIelwo48Z
         Sxh7o+coMBFJYC6g3qJGkiCoxq8Y6aVHyngpsVaO22JgG//sOSfKav6FcdPPLbnS2X4k
         +nULF8Pjt1AqLUzDVVbRLQFS4gq01yDuTFaC0ydGfkUev+o9E03zsC4ouwn131Jmu/vm
         pHeM65pKBaT3QCa9KYrRtCecCzoR3BAVb/LjA6wuZl4MUH9aTF77nrYGLMTb0oEr9G3b
         IXx2SruW1S1dVEpHCnZB/GFfaxAu7WKO1u4GTtLPtUaap7AfZo2Gbm3zyrKzqUf6eEOW
         mkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718213020; x=1718817820;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v0uZvClGSP7b0LMzzAPVM0AhM29ZDe2y2D54OZuyJ4o=;
        b=p/9JlY/NrNAyKTOf3pGJchb0MVUsi88eYkm9zaFRJunnmjsQguxABggjrVWQag3KTy
         g+Sy/x8dMGOZ9Ha42/w11xeBR5wQcqJICIxCr/k6apyYjo1O4PmZwZxs7/JwBn37BNS4
         CIj9MrhL1Xle5V6rozyyw/y0zvNqYzNISfIw1j/9zaoJKA13GMETgHaTLMegJbNOcQts
         A4DIeaskHaYuH0vow8iQSIGESq8Aj8QFCMoKXxxqq0pmPOvu+eURW8uK/II6Wqv4nuW+
         OKXEFuj+8v9CfkP+60subocLsZbPccSfX+VXdVcHumjdHqCBJsS/FHpKvu6QOW5lixjv
         8c4g==
X-Forwarded-Encrypted: i=1; AJvYcCXt0N4gK942Jmqr+P8QQQI5+Vh9ZI57dtNa3x29OiYZi8z0CZ9lvd1tsCAIyWjrTeOQCKen2nlvS3ohS6ZnIMWmUGIRKQgQ
X-Gm-Message-State: AOJu0YwKK02bv9lMGucBF67BbHx74xFGGs54oU8vKwrVyj9+rb2oo0dh
	pQj0G6kAA1vGFiDnjACKSjcu+NEH6QanMEoP020YVwhgC6mUCPz5Mp+FWgUMd+whDcvce9WwCsa
	oMQ==
X-Google-Smtp-Source: AGHT+IHsuziTjwu8H3LsGOZG3nq2ECdUkM7fJ/s+9lw1k304/SuAsQ64WUp2lf97WzRuhz9PeWwlSE0Bo58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:729:b0:dfb:b4e:407a with SMTP id
 3f1490d57ef6-dfe68035fbemr647880276.9.1718213020117; Wed, 12 Jun 2024
 10:23:40 -0700 (PDT)
Date: Wed, 12 Jun 2024 10:23:38 -0700
In-Reply-To: <CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <ZmnGlpBR91TyI3Lt@google.com>
 <CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com>
Message-ID: <ZmnZmj8iVmcLf8fo@google.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024, Yu Zhao wrote:
> On Wed, Jun 12, 2024 at 10:02=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Tue, Jun 11, 2024, James Houghton wrote:
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index e8fc5ecb59b2..24a3ff639919 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -870,13 +870,10 @@ static bool folio_referenced_one(struct folio *=
folio,
> > >                       continue;
> > >               }
> > >
> > > -             if (pvmw.pte) {
> > > -                     if (lru_gen_enabled() &&
> > > -                         pte_young(ptep_get(pvmw.pte))) {
> > > -                             lru_gen_look_around(&pvmw);
> > > +             if (lru_gen_enabled() && pvmw.pte) {
> > > +                     if (lru_gen_look_around(&pvmw))
> > >                               referenced++;
> > > -                     }
> > > -
> > > +             } else if (pvmw.pte) {
> > >                       if (ptep_clear_flush_young_notify(vma, address,
> > >                                               pvmw.pte))
> > >                               referenced++;
> >
> > Random question not really related to KVM/secondary MMU participation. =
 AFAICT,
> > the MGLRU approach doesn't flush TLBs after aging pages.  How does MGLR=
U mitigate
> > false negatives on pxx_young() due to the CPU not setting Accessed bits=
 because
> > of stale TLB entries?
>=20
> I do think there can be false negatives but we have not been able to
> measure their practical impacts since we disabled the flush on some
> host MMUs long ago (NOT by MGLRU), e.g., on x86 and ppc,
> ptep_clear_flush_young() is just ptep_test_andclear_young().

Aha!  That's what I was missing, I somehow didn't see x86's ptep_clear_flus=
h_young().

That begs the question, why does KVM flush TLBs on architectures that don't=
 need
to?  And since kvm_mmu_notifier_clear_young() explicitly doesn't flush, are=
 there
even any KVM-supported architectures for which the flush is mandatory?

Skipping the flush on KVM x86 seems like a complete no-brainer.

Will, Marc and/or Oliver, what are arm64's requirements in this area?  E.g.=
 I see
that arm64's version of __ptep_clear_flush_young() does TLBI but not DSB.  =
Should
KVM be doing something similar?  Can KVM safely skip even the TBLI?

> theoretical basis is that, given the TLB coverage trend (Figure 1 in
> [1]), when a system is running out of memory, it's unlikely to have
> many long-lived entries in its TLB. IOW, if that system had a stable
> working set (hot memory) that can fit into its TLB, it wouldn't hit
> page reclaim. Again, this is based on the theory (proposition) that
> for most systems, their TLB coverages are much smaller than their
> memory sizes.
>=20
> If/when the above proposition doesn't hold, the next step in the page
> reclaim path, which is to unmap the PTE, will cause a page fault. The
> fault can be minor or major (requires IO), depending on the race
> between the reclaiming and accessing threads. In this case, the
> tradeoff, in a steady state, is between the PF cost of pages we
> shouldn't reclaim and the flush cost of pages we scan. The PF cost is
> higher than the flush cost per page. But we scan many pages and only
> reclaim a few of them; pages we shouldn't reclaim are a (small)
> portion of the latter.
>=20
> [1] https://www.usenix.org/legacy/events/osdi02/tech/full_papers/navarro/=
navarro.pdf
