Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24DF197
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 00:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GKhlf/1b"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59c09bcf078so21307417b3.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 17:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696551470; x=1697156270; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=McJdi/j/1GKFjqEOteMsFmQa6CgQZT5EeqPYROfMhbk=;
        b=GKhlf/1bciDNM4KSxGpsoz/quZJjTzCRAZzDEUHGfoM5RGVdC/9i9auuCIWrTpbACP
         xIVKz7O7V9oXncLys9iXZgoSETwDU89qHtTc+T+m+cyL9YpMpSL+WXEDi/IiDyE+cal3
         H2kJmfa9K9baxMB6bG+ahDLFU5eb2ejWOPlFZJScAcPwns+qwHYzMeF0BKkRwW4WNTAN
         RzVkjZLbXVxqslym+DxaOfZIo+sDt1FNt4rvhhTpqFUjeo5xsqDRVSMv0JPIOGB/6JK5
         kkHh5mpIJTHWTEdYqSFbHxNhuePC9VJQwc9MXR8BfJlqvN95NMrdvwW94ZMCSOBz91Nn
         Xw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696551470; x=1697156270;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=McJdi/j/1GKFjqEOteMsFmQa6CgQZT5EeqPYROfMhbk=;
        b=M5tWwgxbtut4YrdRrMA24DJZtiF6NZTl0UHF1QVMOHiQrd2/RNKzrx4DbB6GxWC2fp
         2J993d0cbO4hz+ngRw3VttWimNMqbV3jovAcRVg6TLKrJQfQWeziRghl/GqOTUUESkSZ
         TV78E7zOZyegLd+SwhEHdN8/pZCPSs3VDtLcikNq8dnubfoN3GkQeHY/YYk4a6cpXiM+
         zTmrPQfS9AM3O7s9MlVPqfHfVkzdB9wHt9SzHni1ztCTQ7vfjaPG0iqO1D8vy4LDfu2y
         DhXfPZswxZWYzjGONNQVB4/tNhdb6X8uB5ff9IUVeG2anajjtcRIGXUbQycU4MwvVKpS
         rivg==
X-Gm-Message-State: AOJu0YwsgnnESj5kT/WsWTiTKCnqRHGtJP5+vXBn5oV3bwtIH+3kjX5w
	JVQ76ST4W9oGbJmyGXMJ12AJHBMvXLg=
X-Google-Smtp-Source: AGHT+IHitULJr7kPwzCJOPk3YaN6WA3g1yti650435QLOqCIesvbT6fAE5o/0S84/9L7cBx2w8foopHaCq0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4197:0:b0:d78:f45:d7bd with SMTP id
 o145-20020a254197000000b00d780f45d7bdmr104941yba.4.1696551470557; Thu, 05 Oct
 2023 17:17:50 -0700 (PDT)
Date: Fri, 6 Oct 2023 00:17:48 +0000
In-Reply-To: <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
Message-ID: <ZR9SLOQcFEqPg01A@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05, 2023, Anish Moorthy wrote:
> On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Eh, the shortlog basically says "do work" with a lot of fancy words.  I=
t really
> > just boils down to:
> >
> >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MI=
SSING
> >
> > On Fri, Sep 08, 2023, Anish Moorthy wrote:
> > > Change the "atomic" parameter of __gfn_to_pfn_memslot() to an enum wh=
ich
> >
> > I've pushed back on more booleans multiple times, but IMO this is even =
worse.
> > E.g. what does an "upgrade" to atomic even mean?
>=20
> Oh, that bad huh? Based on what you mentioned earlier about some
> callers of __gfn_to_pfn_memslot() needing to opt out of the memslot
> flag, it seemed like there were basically three ways (wrt to @atomic)
> that function needed to be called
>=20
> 1. With atomic =3D true
> 2. With atomic =3D false, and some way to make sure that's respected
> whatever the memslot flag says
> 3. With atomic =3D false, but respecting the memslot flag (ie, changing
> to atomic =3D true when it's set).
>=20
> An "upgrade" in this context was meant to describe case 3 (when the
> memslot flag is set). Anyways despite terminology issues, the idea of
> an enum encapsulating those three cases seems like, essentially, the
> right thing to do. Though of course, let me know if you disagree :)

The problem is that the three possibilities aren't directly related.  The e=
xisting
use of atomic truly means "this call can't sleep/block".  The userfault-on-=
missing
case has nothing to do with sleeping being illegal, the behavior of @atomic=
 just
happens to align exactly with what is needed *today*.

E.g. if there was a flavor of gup() that could fault in memory without slee=
ping,
that could be used for the @atomic case but not the userfault-on-missing ca=
se.
I doubt such a variation will ever exist, but "that probably won't happen" =
isn't
a good reason to conflate the two things.

> > Since we have line of sight to getting out of boolean hell via David's =
series,
> > just bite the bullet for now.  Deciphering the callers will suck, but n=
ot really
> > anymore than it already sucks.
>=20
> Sorry, what exactly are you suggesting via "bite the bullet" here?

Add another boolean, the "bool can_do_userfault" from the diff that got sni=
pped.
