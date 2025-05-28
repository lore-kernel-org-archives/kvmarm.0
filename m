Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599F41922C0
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748453423; cv=none; b=WNEauqgLsibYOoISzZK+h/AoprLp2S/7biHRN7j8zsECY9qe3ae52/n+sGBm1RCtNnVSEM1fDKlLO/7C0YDgTf41pKt+oHruQ+xtLXwo3pWkt5ZrNYoI8XB/q9XphqxR84nyVf9JRsAgiBrC3tr4LGlU0HTFl0edLSNMOwlet/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748453423; c=relaxed/simple;
	bh=ARY8CwNgeEkx4xeewofft7OOZG05/4+sLW6rStZljR4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A5ZHhtISNk/GQx41+vK7hFQgFqr4takWWqrbG1u9d8gdJou7nDv/o1SjT3vwRiSy86GzI1H53utho89mvrfyF7xvpReuCuGr0CSbGWsFTz+PSZ5JdSpNJJPkAZEPLmzGdkUo3D01mcVQna85PsNW+L95ZbjrONFP+kbS6m4EMdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=awzwTCDp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="awzwTCDp"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3108d54d423so893993a91.1
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 10:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748453421; x=1749058221; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5lk3aR+RzRKEkMTxOWzVHzMD+THYlxrp/Tixh3xiWc=;
        b=awzwTCDpBWfRbf1I9fDQOmlagontk20xcgfharoDYpZZrbRU+upy/a/jgsqmShwyQK
         0YgPHMeeIE09P82NzPtK6+g8jx3h3a1/3T/N+uEG2eLTNHwCxYFw//iSjWKGist7yUU1
         r0WU5xHKa/R9tnlaDcW3jpXhf/v0xVN6bUFFDiTC4+W1VDbvOU4W2we5s6PYcTaUs6G7
         P5CzUBSgDaOrLs99nZrrxcoXoY7mGc7zzR1Jw3YXS44l1dLGQT9PY3id1lfIrVnr4gx8
         gt1+Ub1Af934opxEwb772Xcv6ku3LtOonWJ8eF1iKuw9PvyKAzq15Ws4MRCZ9EtyaKpd
         Ar4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748453421; x=1749058221;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X5lk3aR+RzRKEkMTxOWzVHzMD+THYlxrp/Tixh3xiWc=;
        b=j+yzxGwcNx1cq2QTVNDx+hIDPOxWoeH2uGwslwFtCEY2oZ+6Z863KqqBidmH5Vq9z0
         yCGVPnXl/M+DM7C1P/IQPyFClYZJ9GIxetj7c8NyHUI7QB7Yt16l/DZ5Ay6AUysDRwsU
         oQquHr5bMUK3iUf4OgYeWy3cohp8i/YcSepvPGcAnwCNZdTcQOCD/DtVcKFf3bzyOtVu
         gVviqQlfpNKZFiUCnb1yv7tFuUk8QM+iT8/cwbJ7RuclkFhWYXCqmnGkb675iIGdBsBx
         kBKMkizxkjWZHtzWti3ZQiY+2I6juVUqBEt6phOqPGZbxhwbbKtDnpgLYTuzHcsuaMWJ
         lTtw==
X-Forwarded-Encrypted: i=1; AJvYcCXErAYyTSQdS3hnHlDMHonDl9GhtXMqQMEJOfzepsTT2Lbz2RH6E1kNZfk9rOKJPSYxAVH5aAI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxo44YJfF1kWgrVnlOeRuOkQV1JVy17u8BqAMFgCbuOm4SRb6U6
	TxMsQznOL5XjtWtYBFws3KQEwCqvnqDf6RPWkkm76zSrKmp+cgWLe58HZQFwBgeGwgQ2CllW9LJ
	eT/RMCg==
X-Google-Smtp-Source: AGHT+IEsnEf7VuMExZRw8wVJdfyr2XCnHx5H/B/LOCvx+d5raumWeIsp3ExyZi0ZxIt7xWBlYTiCNvkn+ag=
X-Received: from pjbpx18.prod.google.com ([2002:a17:90b:2712:b0:311:8076:14f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3848:b0:311:be43:f09a
 with SMTP id 98e67ed59e1d1-31214e6e01dmr517950a91.9.1748453421388; Wed, 28
 May 2025 10:30:21 -0700 (PDT)
Date: Wed, 28 May 2025 10:30:20 -0700
In-Reply-To: <CADrL8HXS7zvJZjOxTxPKH0dAGoMXnFrrxCW7J7CXRtaeV6izjQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-7-jthoughton@google.com> <aBqkINKO9PUAzZeS@google.com>
 <CADrL8HXDDRC6Ey5HYWvtzQzjcM2RNX7c7ngGyjUsD3WiBF3VYA@mail.gmail.com> <CADrL8HXS7zvJZjOxTxPKH0dAGoMXnFrrxCW7J7CXRtaeV6izjQ@mail.gmail.com>
Message-ID: <aDdILHOu9g-m5hSm@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025, James Houghton wrote:
> On Wed, May 28, 2025 at 11:09=E2=80=AFAM James Houghton <jthoughton@googl=
e.com> wrote:
> >
> > On Tue, May 6, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Thu, Jan 09, 2025, James Houghton wrote:
> > > > @@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kv=
m *kvm,
> > > >                                  enum kvm_mr_change change)
> > > >  {
> > > >       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRT=
Y_PAGES;
> > > > +     u32 new_flags =3D new ? new->flags : 0;
> > > > +     u32 changed_flags =3D (new_flags) ^ (old ? old->flags : 0);
> > >
> > > This is a bit hard to read, and there's only one use of log_dirty_pag=
es.  With
> > > zapping handled in common KVM, just do:
> >
> > Thanks, Sean. Yeah what you have below looks a lot better, thanks for
> > applying it for me. I'll post a new version soon. One note below.
> >
> > >
> > > @@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm=
 *kvm,
> > >                                    const struct kvm_memory_slot *new,
> > >                                    enum kvm_mr_change change)
> > >  {
> > > -       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRT=
Y_PAGES;
> > > +       u32 old_flags =3D old ? old->flags : 0;
> > > +       u32 new_flags =3D new ? new->flags : 0;
> > > +
> > > +       /* Nothing to do if not toggling dirty logging. */
> > > +       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> > > +               return;
> >
> > This is my bug, not yours, but I think this condition must also check
> > that `change =3D=3D KVM_MR_FLAGS_ONLY` for it to be correct. This, for
> > example, will break the case where we are deleting a memslot that
> > still has KVM_MEM_LOG_DIRTY_PAGES enabled. Will fix in the next
> > version.
>=20
> Ah it wouldn't break that example, as `new` would be NULL. But I think
> it would break the case where we are moving a memslot that keeps
> `KVM_MEM_LOG_DIRTY_PAGES`.

Can you elaborate?  Maybe with the full snippet of the final code that's br=
oken.
I'm not entirely following what's path you're referring to.
