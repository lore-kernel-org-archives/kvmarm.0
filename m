Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9377101EB
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 22:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QE5yv8Gz"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1cc41aed6a5so2315825ad.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 15:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698878556; x=1699483356; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=umjDrFbVsgqJ4z1yzhq3O2IkRl0O4dYLZdb427Y8d2o=;
        b=QE5yv8GzMo9VnJLuos7OtNjMmg6SBkpm5zsbfqieaqdM8osG6ZNwhpOpJVFt2wgHd5
         0nyYG5KpAgUbnJfdZR6mELfADFw9L8JeapCBpQxi5KBEYALTnHW9/aFFndx/rrGc0nR4
         9Ad9u76G+Ch7mmHM0UzwjiNG8N0IKxl7xyqOGbAkYdjeyMpY2DE/74pmGulr6T4/FQI1
         fNhOyqnwxWItG0KufhW04Fkcz8l2uUeWQ9/pq1FhgPNRNcHm83U3THlvQATIZIprdhgV
         5L1DMPAPGCv11i3Og5Ifd1MAUneHc0ahbAwNkNmIyNgFhoyiyZkfyzyb7UVmvnecLv6Y
         hgbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698878556; x=1699483356;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=umjDrFbVsgqJ4z1yzhq3O2IkRl0O4dYLZdb427Y8d2o=;
        b=lEpwCIujyIO8Il/D8ACem7KMMROqmRK2LiHB9P1jRLSbBNSmX+pmvPiE25ZTw8lAR0
         vP+z0WdpX04G4p33z8seVX4geceV7VstJnjQfBbgAdrOj5Elk54+RUc6algzbQB7qK+V
         WPpWCyGX0BAcHLKBIcDldxcqOJzWQ2SUMOx19iOsBg8PY0doz7u99h92ZwHxX1p25+5M
         qzOEFBkQe5YngG911SEImT+1FItwabqGkGOFqCIrIf0pKRK7F9bpYDl06QH8p/6HHsHq
         opYp+4fkunSFoEwZnEyMx9ZNz/sn6seMxZmT5grUxsMnFYQ76UfrnO8/+UZopy0/6wga
         J8hQ==
X-Gm-Message-State: AOJu0YynK5aNU6rOUp3G9E7j9lQuOAziKpV5QH5EcDUwpX94YY/MExLd
	j/WdAb5EVuTUWDBbPu9q/Kkjn32gbSw=
X-Google-Smtp-Source: AGHT+IHZiZiBBwgOEtn7XwGvRKxTq1DihI9O371Fd4mUOTueTSxdTjs+pzFnYEuqiPedMO22M49VARVvyww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:44b:b0:1cc:4136:2b4b with SMTP id
 iw11-20020a170903044b00b001cc41362b4bmr184833plb.4.1698878556010; Wed, 01 Nov
 2023 15:42:36 -0700 (PDT)
Date: Wed, 1 Nov 2023 15:42:34 -0700
In-Reply-To: <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <ZULLNdp6XKD6Twuc@google.com> <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
Message-ID: <ZULUWucAdR3oWR1y@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 01, 2023, Anish Moorthy wrote:
> On Wed, Nov 1, 2023 at 3:03=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Nov 01, 2023, Anish Moorthy wrote:
> > > On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > >
> > > > Eh, the shortlog basically says "do work" with a lot of fancy words=
.  It really
> > > > just boils down to:
> > > >
> > > >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_O=
N_MISSING
> > >
> > > Proposed commit message for v6:
> > >
> > > > KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in =
__gfn_to_pfn_memslot()
> > > >
> > > > When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> > > > faulting in pages for which mappings are absent. However, some call=
ers of
> > > > __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt=
 out
> > > > of this behavior: allow doing so via the new can_exit_on_missing
> > > > parameter.
> > >
> > > Although separately, I don't think the parameter should be named
> > > can_exit_on_missing (or, as you suggested, can_do_userfault)-
> > > __gfn_to_pfn_memslot() shouldn't know or care how its callers are
> > > setting up KVM exits, after all.
> >
> > Why not?  __gfn_to_pfn_memslot() gets passed all kinds of constraints, =
I don't
> > see how "I can't handle exits to userspace" is any different.
>=20
> Well the thing is that __gfn_to_pfn_memslot() is orthogonal to KVM
> exits. Its callers are just using it to try resolving a pfn, and what
> they do with the results is up to them.

But "how" the pfn is resolved is the business of the caller and of __gfn_to=
_pfn_memslot().
This already exits in the form of @async and @atomic, which respectively sa=
y
"don't wait on I/O" and "can't sleep, period".  The @async name is confusin=
g,
but David Steven's series is planning on replacing that with the much more =
literal
FOLL_NOWAIT (IIRC).

> Put more concretely, __gfn_to_pfn_memslot() has many callers of which
> only two (the stage-2 fault handlers) actually use it to set up a KVM
> exit- how does a parameter named "can_exit_on_missing" make sense to
> its callers in general?=20

It's a flag that says "I can't exit right now, please ignore exit_on_missin=
g".

> If it were __gfn_to_pfn_memslot() itself that was populating the run stru=
ct
> in response to absent mappings then I would agree that the name was
> appropriate- but that's not what's going on here.
>=20
> (side note, I'll assume that aside from the current naming discussion
> the commit message I proposed is fine)
