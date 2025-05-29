Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2EF22D789
	for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748533099; cv=none; b=NiLaMfM0+D816NqElgsr2CEP1v6qUGDEXsyCxjkpP6bExcH+N8gIhFRqYYoFWMOaRxSYtcBkGLbB23LYscFgkyEb1cxdm0aCh+O+xCG5R03LM3MdIn9YGsIwdUEGLhalTW4QI2r5Tg3VJAuUiIV2NPjPTP1KU6eoyvavDPCWgMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748533099; c=relaxed/simple;
	bh=9dnD35XOCewsQPQpmkvlOmYPTq8w148rFOH/LXn7szk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DviTrMlLMs8Vh3Xn0VonxYzc4wHauWrFoHfML+jOJN2PkSfNy5SYTb4aCUaahgZyrO5H8ObNgqDkfci0Z8F34SS9S5VgMdiHsH6VXxIbnhXeEfZNU7WRkysKj+kIiwovQpxgxrLHRz2hLc/pONKjHIhRkz7CvRwWpmzA+5b+RHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SBFMtP8j; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SBFMtP8j"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e7dd151f79eso988049276.2
        for <kvmarm@lists.linux.dev>; Thu, 29 May 2025 08:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748533097; x=1749137897; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59hS0MkzKJXc59NrQgViQhOudUVo0YC4RPrtVcYEmhM=;
        b=SBFMtP8jvEs6lyCKwKEuyYE+m7q3VRMMvZOvtQonc/CHCDniziBh4lSyMZd4kTRH12
         U+2VApB4k5gRGrId8GtiFQihxNaUxxZbmQ0OnyTpx96XG2QAqY9F9yXMdtJqHXLVIjpT
         Fda56MmZXNW5KPHmA2/1j/AkuJ14vqIcCVvsVIYH0FU0/51GGlCNcgkuoFMiT32iJAbO
         RBLeof7YAjIaS6IGM+n1uv1iVofzy5T4NSp4/Be/7SRMxrjjkqYfxGA/VvaXhFBotvm7
         7uipLzSAGpc9REzJJEwbAsp0yjLQG7nebDcqmJlH0L3j6lv/DzRB0Dka4Mh2plOiXoec
         +FvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748533097; x=1749137897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=59hS0MkzKJXc59NrQgViQhOudUVo0YC4RPrtVcYEmhM=;
        b=f9BTmoHUg0Rk4IvuZj0vFrFtJrfXZx6InsXJqshvCKeEwf6riIX/0FuTXQDOKWtVt2
         ZfiXskzDkbbOlz1FvAnTYcwldHOORMyuIcNvPkhhNBH30F3zTlEnnyOvzCyePErm5tGO
         4Zr0NZZA2BTVsNasOltvqg8TXpmgLZro2uFOIfbaUoSYvGM5R+lf1yfYEDvYDlfqOtcy
         RjbVP3b3YZp4UriFRYvdOe+KEFLHb+EjhRfs9SGoP/CXX9IcfmytXwWzFGF0sVggx9gV
         p4ggGKVGhmSfEdw4eZ2VwKA6vjzEO/nzfIxsvYnouLYLPUh82lM+IM37gttkZ+YBW5vH
         ybSA==
X-Forwarded-Encrypted: i=1; AJvYcCUKTTJzoDgFp9PHI9imG7uczbCYa1g1tVTvlk2SA44O+T55j+iQg2cIWA53uR20cPTMsVdw8jk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRLLWLO0BwBpI7F5GvHrN+QSKd7YtEw1sprMAMZa7Pp8EntUWJ
	UzGG/8qpkyPi4O7MB3KzmaD9qfPdZYdUo57kLtabpAWBcgl747xLK0HdsbgeQfumbmFIAd/OuWx
	KWqOEFh2rP5frSLPTVKvXX5pUx/4/4/xAbN12+i7e
X-Gm-Gg: ASbGncun5Sj+9NjqDnN2iJHJ0e/gwoywkoQuNcrfnuj0XSiKVvAi3qrOBpqH8cqRgjV
	5x651os/yxwt326LiHayklO9r5kI50JVWuXe/JGQc5J4l7trSz9j9lAtckaIJmTvQT8EqifBVeo
	wq6bW4A5iYwEOICvN8WnVzFjkjoCHWGvr5dz2QlHdzPtxf/h6IzuN+qsLtJeqPwnjIn6ODcvHaS
	9DCGg==
X-Google-Smtp-Source: AGHT+IFR1qIxg3DrCDwLoec3/Bow8uX+lKtS4uCaQmLEMzaDiZzqKZfkx5upp36mpzAbpQJS3YxhrYvCs4/T2jiOb1I=
X-Received: by 2002:a05:690c:4c0f:b0:70f:87c5:5270 with SMTP id
 00721157ae682-70f8b54d40dmr38902587b3.19.1748533096510; Thu, 29 May 2025
 08:38:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-6-jthoughton@google.com> <aBqj3s8THH9SFzLO@google.com>
 <aDdwXrbAHmVqu0kA@linux.dev> <aDd-lbrJAX62UQLn@google.com> <aDh1sgc5oAYDfGnF@google.com>
In-Reply-To: <aDh1sgc5oAYDfGnF@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 May 2025 11:37:39 -0400
X-Gm-Features: AX0GCFvRkUpRdhgyNhHX3Yph3U7NSJ2ckkL4g5EEunTqQRjiIBENP29k9ut9k84
Message-ID: <CADrL8HWgnuU9pyQfLcm9qpSJicfwgmc9qRzksA38x5_utexaug@mail.gmail.com>
Subject: Re: [PATCH v2 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 10:56=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, May 28, 2025, Sean Christopherson wrote:
> > On Wed, May 28, 2025, Oliver Upton wrote:
> > > On Tue, May 06, 2025 at 05:05:50PM -0700, Sean Christopherson wrote:
> > > > > +       if ((old_flags ^ new_flags) & KVM_MEM_USERFAULT &&
> > > > > +           (change =3D=3D KVM_MR_FLAGS_ONLY)) {
> > > > > +               if (old_flags & KVM_MEM_USERFAULT)
> > > > > +                       kvm_mmu_recover_huge_pages(kvm, new);
> > > > > +               else
> > > > > +                       kvm_arch_flush_shadow_memslot(kvm, old);
> > > >
> > > > The call to kvm_arch_flush_shadow_memslot() should definitely go in=
 common code.
> > > > The fancy recovery logic is arch specific, but blasting the memslot=
 when userfault
> > > > is toggled on is not.
> > >
> > > Not like anything in KVM is consistent but sprinkling translation
> > > changes / invalidations between arch and generic code feels
> > > error-prone.
> >
> > Eh, leaving critical operations to arch code isn't exactly error free e=
ither :-)
> >
> > > Especially if there isn't clear ownership of a particular flag, e.g. =
0 -> 1
> > > transitions happen in generic code and 1 -> 0 happens in arch code.
> >
> > The difference I see is that removing access to the memslot on 0=3D>1 i=
s mandatory,
> > whereas any action on 1=3D>0 is not.  So IMO it's not arbitrary sprinkl=
ing of
> > invalidations, it's deliberately putting the common, mandatory logic in=
 generic
> > code, while leaving optional performance tweaks to arch code.
> >
> > > Even in the case of KVM_MEM_USERFAULT, an architecture could potentia=
lly
> > > preserve the stage-2 translations but reap access permissions without
> > > modifying page tables / TLBs.
> >
> > Yes, but that wouldn't be strictly unique to KVM_MEM_USERFAULT.
> >
> > E.g. for NUMA balancing faults (or rather, the PROT_NONE conversions), =
KVM could
> > handle the mmu_notifier invalidations by removing access while keeping =
the PTEs,
> > so that faulting the memory back would be a lighter weight operation.  =
Ditto for
> > reacting to other protection changes that come through mmu_notifiers.
> >
> > If we want to go down that general path, my preference would be to put =
the control
> > logic in generic code, and then call dedicated arch APIs for removing p=
rotections.
> >
> > > I'm happy with arch interfaces that clearly express intent (make this
> > > memslot inaccessible), then the architecture can make an informed
> > > decision about how to best achieve that. Otherwise we're always going=
 to
> > > use the largest possible hammer potentially overinvalidate.
> >
> > Yeah, definitely no argument there given x86's history in this area.  T=
hough if
> > we want to tackle that problem straightaway, I think I'd vote to add th=
e
> > aforementioned dedicated APIs for removing protections, with a generic =
default
> > implementation that simply invokes kvm_arch_flush_shadow_memslot().

I'm happy to add something like kvm_arch_invalidate_shadow_memslot()
which invokes kvm_arch_flush_shadow_memslot() by default (and has a
lockdep assertion for holding the slots lock), with no architectures
currently providing a specialization. Feel free to suggest better
names.

Or we could do kvm_arch_userfault_changed(/* ... */, bool enabled),
and, for the default implementation, if `enabled =3D=3D true`, do
kvm_arch_invalidate_shadow_memslot(), else do nothing. Then x86 can
specialize this. This arguably still leaves the responsibility of
unmapping/invalidating everything to arch code...

Let me know your preferences, Sean and Oliver.

>
> Alternatively, we could punt on this issue entirely by not allowing users=
pace to
> set KVM_MEM_USERFAULT on anything but KVM_MR_CREATE.  I.e. allow a FLAGS_=
ONLY
> update to clear USERFAULT, but not set USERFAULT.
>
> Other than emulating poisoned pages, is there a (potential) use case for =
setting
> KVM_MEM_USERFAULT after a VM has been created?

Today, Google's userspace does not know when creating memslots that we
will need to enable KVM_MEM_USERFAULT. We could delete and re-add the
memslots of course, but overall, for any userspace, I think adding
this restriction (for what seems to be a non-issue :)) isn't worth it.

Thanks!
