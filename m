Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FEA28C009
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 15:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748445957; cv=none; b=Nmz8ZrOPO++1CdcD8CVC5bROH1JbZ0EbRvFB0J5ZqtCANmOGvu9ilebbf4MybHEKL9GZDvPi3u5Q/8WwlXUfu/ve6eLsY3WOIV2LczGy18oaRShkxZpz9+Tm9d0UW5RSmpfHhptOZZhAd+6gFkW8M3wAOfbjPIWr7dLphRnBt8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748445957; c=relaxed/simple;
	bh=JB4V1mXB50dIS2i0RJuuug4gKKlxLvXfYIwuNLk4WtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQLp76F+ngZjNrXU585HgagdEDfdTyEVJLtWDhn1xAzorpAQSRQ0hPnt1e21E/Ba11rkS0qHFfnD+H6ZUfFHYiqkIVH8EyykxOKSxSU0TVqDzvFT0J28K7O5sHS9pFbE44eUJXeqIjo5uJn2NWcHuFZoy/wu6drOBwFSwuPmW8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=onE5VmUA; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="onE5VmUA"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-70e78e04e48so16202907b3.1
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 08:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748445954; x=1749050754; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZ+8fLpUTUE00SwjTXDSYLrDkmSnBdYHcuMZzbgG8cE=;
        b=onE5VmUAZmFPEwDJ4LZSuPOGE6dd7sOTiVrFUhayYE72q8U+02BS8s9FQb3QQ7ab5w
         aguV7D7qhvkwZyT6xg5dRqSO0URv1wPCiEyZjLiVLU4UZr5LnShoB6P0hJcdFi4I1iGr
         PU9V9Nu+kUxCPA/la1eNeGuxH/FaMpc1pVdQdv0Vd4xMy6LnRseDCdGb1lseGJRTY6K/
         QTkjHzWSQVni771cSa3+kjwK+5nEupIjRdSwKJsH6f1i+AVPGDqw/BE4Te4QpXLcSTQv
         t15qYrKa2vmu7zs+soEDHiRB7JmaE0w3fsm+HQNnUJ3Z3JOGLLqzj8o4Ntifdx+krLzz
         fdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748445954; x=1749050754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZZ+8fLpUTUE00SwjTXDSYLrDkmSnBdYHcuMZzbgG8cE=;
        b=ffbBvM9jAm2h+b7e0UvA8i2trnPNPNpSGzcDVDN5hE2JKoVzP0VYTS+KlCiml3GuBp
         WnMcPzaxJMpLG1vR+lwDmTO6TsskcZ+uOkbq8epN3pWox7c5oEzvjpVan5SFlMeytISC
         umHfp4GxwY6yudrQpYy5PFIXv5dMPc6+cu/4JqyBZojjLv/HET2W6kVT1pujqSv3XsBj
         o5csuNnjH5c4/z8szjU+vt/AjKTLrRSL+JReAS1Hn48/5HnF5SjA1u3oZGCtto3rb1GN
         Sdf6yFWvmo+LdrRgTLsHfEZZ46o9vxAStsJ/Ar7wwbJH5VjkuElWh+HjkbbXugaFGrbO
         spVA==
X-Forwarded-Encrypted: i=1; AJvYcCX1e1N5rr/k8NnsQEKP6znoTyOvWMIDHUPoQO/wUV5KZ0mYco5xcqDKuM0Vyg4MJtANrKK3Lek=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxxVV45LasT4lhBQAvz1fZ/V0eL/aN0BrzyP1INX9bKpwhCFQ8
	zFvrCh5dHiV39HComs1/buZwt9TEEw7i6LLo93f6pjeIvDHmubeTQT+mGd2Lfzrl83fzuYPEhx/
	yK3y/09bCQZ3XQlVykOaCRSo2aBwAwA5PjarwmifD
X-Gm-Gg: ASbGncvYNeWsbwh4W0aZQX83udL+ovkQwSgMxTxBoOR0Q99TnqEE8gmDQaEEQMQgpR+
	u0T7kz+C/pqX+YWAg04pXgw6r36QMc3QBSc5kxBCGqi7wOO3OHWoIYOjSxMUjJtrklCC+a+8Tg4
	zHCmbU76DDhv10ckGGTIBQApXPvC5cnf9EK3Gt3Xt3aPzLVCHdVZmNGUwA2havzIgogGu97uHWR
	s2p1A==
X-Google-Smtp-Source: AGHT+IHHTjFjHU0PvV1+djItsz78YttpGm4E3LPln4uNDhF+ecRDSLHAHEgplJviovwSCSuAsvDL2RN+PvRS8fF8nxk=
X-Received: by 2002:a05:690c:6382:b0:6fb:a696:b23b with SMTP id
 00721157ae682-70e2daa40e4mr229796257b3.33.1748445954277; Wed, 28 May 2025
 08:25:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-7-jthoughton@google.com> <aBqkINKO9PUAzZeS@google.com>
 <CADrL8HXDDRC6Ey5HYWvtzQzjcM2RNX7c7ngGyjUsD3WiBF3VYA@mail.gmail.com>
In-Reply-To: <CADrL8HXDDRC6Ey5HYWvtzQzjcM2RNX7c7ngGyjUsD3WiBF3VYA@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:25:18 -0400
X-Gm-Features: AX0GCFsuA5ETDJCRPXwcAF_CgwvMWNwjHd-w8eEw30VBFRDQPn6RHYkUrDT3M_g
Message-ID: <CADrL8HXS7zvJZjOxTxPKH0dAGoMXnFrrxCW7J7CXRtaeV6izjQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 11:09=E2=80=AFAM James Houghton <jthoughton@google.=
com> wrote:
>
> On Tue, May 6, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Jan 09, 2025, James Houghton wrote:
> > > @@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm =
*kvm,
> > >                                  enum kvm_mr_change change)
> > >  {
> > >       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_=
PAGES;
> > > +     u32 new_flags =3D new ? new->flags : 0;
> > > +     u32 changed_flags =3D (new_flags) ^ (old ? old->flags : 0);
> >
> > This is a bit hard to read, and there's only one use of log_dirty_pages=
.  With
> > zapping handled in common KVM, just do:
>
> Thanks, Sean. Yeah what you have below looks a lot better, thanks for
> applying it for me. I'll post a new version soon. One note below.
>
> >
> > @@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm *=
kvm,
> >                                    const struct kvm_memory_slot *new,
> >                                    enum kvm_mr_change change)
> >  {
> > -       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_=
PAGES;
> > +       u32 old_flags =3D old ? old->flags : 0;
> > +       u32 new_flags =3D new ? new->flags : 0;
> > +
> > +       /* Nothing to do if not toggling dirty logging. */
> > +       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> > +               return;
>
> This is my bug, not yours, but I think this condition must also check
> that `change =3D=3D KVM_MR_FLAGS_ONLY` for it to be correct. This, for
> example, will break the case where we are deleting a memslot that
> still has KVM_MEM_LOG_DIRTY_PAGES enabled. Will fix in the next
> version.

Ah it wouldn't break that example, as `new` would be NULL. But I think
it would break the case where we are moving a memslot that keeps
`KVM_MEM_LOG_DIRTY_PAGES`.

>
> >
> >         /*
> >          * At this point memslot has been committed and there is an
> >          * allocated dirty_bitmap[], dirty pages will be tracked while =
the
> >          * memory slot is write protected.
> >          */
> > -       if (log_dirty_pages) {
> > +       if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
> >
> >                 if (change =3D=3D KVM_MR_DELETE)
> >                         return;
