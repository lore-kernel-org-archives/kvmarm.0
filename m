Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A748626B3
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706803799; cv=none; b=fkjtwWYRAfRhIgrn6ZN7JQR8tWX6oXlT8GrGmhNO/NqeYyxtacomqFs3bcdRPGsloO+n23wE7O4uSQzfAItA6A7IFHXRV9QNvaIXf/GVvLYKkrq0XoiQbccvPStsW3YQxS9oWKXu8D88Mf6ijlu2MLFt7gtl8yoJcq4r1FAsNDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706803799; c=relaxed/simple;
	bh=7CSEMHGFIzUqMuP3BxvtQKRgmSmzo+WkEAQHpp7aqbQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qIdssOmJd8T0On1ThdoFH4/yf7k2jsqXzfArTddaJ2WAa4fBPWQL6AusPQfZELl+FwqvY7brfNCSGv2SkWXpNxnGI8wxLPwhWVX8ePk2ONNjsTL8iypJF0otcEZd6VzPEmIW05y1Ch7pO4iyYbfe4Lp+adMxjBINSq+nV1ELqDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ks9lk/xU; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ks9lk/xU"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6ade10cb8so2048530276.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 08:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706803797; x=1707408597; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5D6A9MAokm1eQJhhhCS/vvtEFg3NRQqyUoXU7zcFXbM=;
        b=ks9lk/xUACD73DdWyLqutWBICkpw/Nmnqi4xTS7vsfwd8Hp2XQqaN1lxeJNB3jEWUZ
         exjTu9iAZZ/cUWgJKR66HWM/vbs1eslU7tXsaVUCQDCgnRKCqaj++Iv/dVi3lw5tjXge
         5TlVkmzZ6VW3Exztpqc1+8Gu8aDTJzwmZV1HAaTr9ouIRChT5Mg6OqW2sIqyjQ2UkYd1
         L6KnGt3mzbNis4iJyhznAkqHcN3e0Fboaykdx1EwVL/bO9yMYTbqbIekIqKcPQv74HtP
         kX5zCqnX9wtTRCYAmdtK7n+3qx+xaxcLapexj6K54fGUU1yLze5g6XMOR1rsvPKzwCy9
         jt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706803797; x=1707408597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5D6A9MAokm1eQJhhhCS/vvtEFg3NRQqyUoXU7zcFXbM=;
        b=kxYJV6iTzOAqdH4kBK9luAXcm4GXBGALGaECcTwFpzcnOkXeh0otIExLS2Hhc9D2B+
         cQQkYsmZesKvy1wDJRely0VDmRUHTv/8lF18DETHdh4Xj1jSzbIjOJax4yfdkU+NH/9Y
         eZKiiwLNFiF0tLs3rqKuOf/ToSUOVuCG02AOZJyRWD0eN3TKJiGh0HJO+ifObn6FaBOK
         n6Val2cWtO1zqmhCD+ipjR1jf9c7ajqIfSjKdk/dc8eytv9d008EtavIvhR8lP0Q4k4h
         WeJcVZQ16d6nSSDdmcUxSn3IYBoXHIX85COYCRmBk+HVykyBTT6QptkD5TW29tf/Ux8D
         JfHA==
X-Gm-Message-State: AOJu0Yy8JzGcwRPL+xem0ovfxDdxqVjVsiYksycyYsEIBmK4LyEsqLFP
	vZK7mrpwHiTz/H4+gOn2QpRrAmnHIcOMC9ZRx8R7g1PMHe7YVzQHTlHDqnb8ncsfGgJSTdrLf9o
	wSQ==
X-Google-Smtp-Source: AGHT+IH+OpGONSjXILl9u3ckR2DfQpvHTkdIoYM8QZCypQrXj2y1qc/DOfkdyz811+61uoLrP/+1GQZPrKY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2404:b0:dc2:51f6:9168 with SMTP id
 dr4-20020a056902240400b00dc251f69168mr1296460ybb.2.1706803797347; Thu, 01 Feb
 2024 08:09:57 -0800 (PST)
Date: Thu, 1 Feb 2024 08:09:55 -0800
In-Reply-To: <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com> <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
Message-ID: <ZbvCU5wPAnePJZtI@google.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024, Anish Moorthy wrote:
> On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > Feel free to add:
> >
> > Reviewed-by: James Houghton <jthoughton@google.com>
>=20
> > If we include KVM_MEM_GUEST_MEMFD here, we should point the reader to
> > KVM_SET_USER_MEMORY_REGION2 and explain that using
> > KVM_SET_USER_MEMORY_REGION with this flag will always fail.
>=20
> Done and done (I've split the guest memfd doc update off into its own
> commit too).
>=20
> > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kv=
m_memory_slot *slot, gfn_t gfn,
> > >                 writable =3D NULL;
> > >         }
> > >
> > > +       if (!atomic && can_exit_on_missing
> > > +           && kvm_is_slot_exit_on_missing(slot)) {

Operators go on the preceding line:

	if (!atomic && can_exit_on_missing &&
	    kvm_is_slot_exit_on_missing(slot))

> > > +               atomic =3D true;
> > > +               if (async) {
> > > +                       *async =3D false;
> > > +                       async =3D NULL;
> > > +               }
> > > +       }
> > > +
> >
> > Perhaps we should have a comment for this? Maybe something like: "If
> > we want to exit-on-missing, we want to bail out if fast GUP fails, and
> > we do not want to go into slow GUP. Setting atomic=3Dtrue does exactly
> > this."
>=20
> I was going to push back on the use of "we" but I see that it's all
> over kvm_main.c :).

Ignore the ancient art, push back.  The KVM code base is 15 years old at th=
is
point.  A _lot_ of has changed in 15 years.  The fact that KVM has existing=
 code
that's in violation of current standards doesn't justify ignoring the stand=
ards
when adding new code.
