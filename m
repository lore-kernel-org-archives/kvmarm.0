Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C587F7F3
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320112; cv=none; b=LuSxAJ5cG879hiMQ+niPoIMbsTLOqXU+0+0Vjq5ypxwvsJwG34Om32cjkO29C98Ek/fo5SZE64iXPNMo03qoHqD2tWK081M9f8okxWRVAdfzaAQFeUW+BvPjF91CQ7GhUO8yF5/fJZL8w0aK1hVhxylbOL8WRBm4wWaJfG/1VH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320112; c=relaxed/simple;
	bh=CwV1A4uK5GmAyxOXYq/FsdNF/7KtFozivV5RY9X8wcw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R4tKAYtnSjd1jTIgD7M8fA1GII8UAGkS33ijVv63uburgqkYxYqKB+KkItNbb8jNECsUtreabCUS16W5pejuhk0lYjs8BCc81mPYqs6al5jayKA8Ys2mo0PR/3VWwHhHV/ePuIpePhe3hzlbLKq7gPDUy6m8CH4jd4F1lA1vsQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ChemETCL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ChemETCL"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e0519304b2so750268b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 07:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707320109; x=1707924909; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSeG2eqmAx2jExNdfFUztfiEkREy+BFe1695QlzXVIE=;
        b=ChemETCLnWFPLJM/9OmLCuQt8QWbQmjyCdHfgOuk5U7LhZ4EySQonXMit0odRvVvGg
         eH8BGHfstEhlpHkIf0xFMLXVlwbOhbl1pwdyIANOhWRBtdMWYd5KohHdrN7TJmPjYblu
         QbpcFt2hLDU/E+cGeXY5XWIf25Flj0LndXXxQZlyuvzxAFfs594x2q6cPIgr3c1sBzME
         XwiDxAZOmJqpC4rLEAfNtKB1EhytNUP7FOh8Yiy6RhYPHqCtLblWNTBkRRgzm6PBWjdE
         GQ3bFOZeRofHK4BgbgTiZoEpJuNn8YC0zmDMlTm1BUm5mn8PTus6WWzYbcLc90C011wC
         jtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320109; x=1707924909;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wSeG2eqmAx2jExNdfFUztfiEkREy+BFe1695QlzXVIE=;
        b=AOeWscnHI/282vDHMoyDf3+3pI3ZxXEdaAuG0GnvVp/PLYyqlMUvqXTnZCnLZR/6cM
         8hYEJ4xkqAsspOwdNJFBPCobi0FbSzZGBl+pBmNEiEkYnx39B7T9py0yaxo1D60O8x5Z
         TfNoiXw6WmWiTyU4O6+6nBZike1Ild/oLD6Qg81HwxD3PZN4JrUVlYbh9jhz3D7Md+G/
         r6gEi5Jr73NjpDiPK9xM9/Ilpr2JDJ2T8OGMZbsByqKckax/Oxjshxgiu1OB0VzrsiOQ
         TrdXK0TseHJyl+ipxBDCl0exWOcyr12RW9274eqByoON2LVk5zXNLXFbbC+aLL8JJCwh
         FfKA==
X-Gm-Message-State: AOJu0YzGH90eQb+rNamvwuZ6uVKgLZ6XsxMGbM9u9qTNjP2itq27nu0x
	cKIAaTxSPCSpj6j6/m4wTFdvP6dQvMhyYPxOhccGYWAkqDyxUbED60a4XpkP4JHj8AFFMlMxrCV
	Rcg==
X-Google-Smtp-Source: AGHT+IGsbkoD2FJ2/8WDV2J4uygfhhxJUf4mK7R3Ftk1NHOFsCN9F7TwWUTEGOj7G2AbtTdqxQxgnbqaH5M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d84:b0:6e0:3f5d:8222 with SMTP id
 fb4-20020a056a002d8400b006e03f5d8222mr125395pfb.3.1707320108692; Wed, 07 Feb
 2024 07:35:08 -0800 (PST)
Date: Wed, 7 Feb 2024 07:35:07 -0800
In-Reply-To: <CAF7b7morHn_-WQBPFexpS_Eb-bXSyu_7CCf-EpBWbAvxReWZXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <ZbvCU5wPAnePJZtI@google.com> <CAF7b7morHn_-WQBPFexpS_Eb-bXSyu_7CCf-EpBWbAvxReWZXg@mail.gmail.com>
Message-ID: <ZcOjK9UzmCzu8s0r@google.com>
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

On Thu, Feb 01, 2024, Anish Moorthy wrote:
> On Thu, Feb 1, 2024 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Jan 31, 2024, Anish Moorthy wrote:
> > > On Tue, Jan 30, 2024 at 4:26=E2=80=AFPM James Houghton <jthoughton@go=
ogle.com> wrote:
> > > >
> > > > Feel free to add:
> > > >
> > > > Reviewed-by: James Houghton <jthoughton@google.com>
> > >
> > > > If we include KVM_MEM_GUEST_MEMFD here, we should point the reader =
to
> > > > KVM_SET_USER_MEMORY_REGION2 and explain that using
> > > > KVM_SET_USER_MEMORY_REGION with this flag will always fail.
> > >
> > > Done and done (I've split the guest memfd doc update off into its own
> > > commit too).
> > >
> > > > > @@ -3070,6 +3074,15 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struc=
t kvm_memory_slot *slot, gfn_t gfn,
> > > > >                 writable =3D NULL;
> > > > >         }
> > > > >
> > > > > +       if (!atomic && can_exit_on_missing
> > > > > +           && kvm_is_slot_exit_on_missing(slot)) {
> >
> > Operators go on the preceding line:
>=20
> Thanks. On a side note, is this actually documented anywhere? I
> searched coding-style.rst but couldn't find it.

Maybe?  But the fact there are very few, if any, patterns like this in KVM =
should
be a big clue that it's not the One True Way.  The formal docs will never b=
e 100%
complete, and preferences do evolve and change, but if your code sticks out=
 like
a sore thumb, odds are good you're doing something wrong.
