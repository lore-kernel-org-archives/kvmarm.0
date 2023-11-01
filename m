Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3411E6ABA
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 22:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hfQVcWSW"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4083f613272so2599115e9.1
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 15:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698878427; x=1699483227; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXPZ3AcawcA1W4QGM/w77ZoUKpuqMyLV5hPTKCTAkfk=;
        b=hfQVcWSWD/z9rN7f8ZYlb3kenCkD6WHO2LAgGXjDg7DkQIw7EQQiU45FgQZ9wsE5sB
         az1jDB/vC9/2WCBLvGi1kCaJV7wI8OG0xvufQ0Iy2yeZD6H/PgHjwgujCCipnuauz1pE
         5WONY/w6Lx8UcMiKdkPmQoOruO41Jg7vgYciRbNVDt3EEeL5dqtmU0C6e5PDh0KOgMIe
         HifKYy5jOy58E/eS5GSrRsHlk2LIHL0KUrxIG7LB9QW+KHWahN7NM/EQlTnjlNQeVSJL
         evzdBpBsP2mMEHtnn2u6c9JEGIqXyii+/6NySVZyhgK86vnEhtrcinM/frVe1Rg2Rkf4
         pCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698878427; x=1699483227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXPZ3AcawcA1W4QGM/w77ZoUKpuqMyLV5hPTKCTAkfk=;
        b=JEILJiwVdb/dDuVW7ExK6nBqbxliAw8MhFHttBoag5QSCLDMCdjX56UENYAng7pJBy
         WwoKevWR5cvA/q5vcsRbYjbCNP5EYZ5I0/n/gz9v5MCzot2+68ldWDOcls78KxYXcUkE
         1wOAcM1VKewn34EgD304dYoAvCpURcZFIqAtcDe36hxN8KhnzaSLh1APoG9i0jIRoyPI
         WraLXXP84QwTe6Sr9PA+3UPgFG622lEFhs++wxD23Nw96k7NcMbj7l+2o5c6XyHoLKyB
         0yvJpwYINMAi461G0bx+y3Twsd/VMg4O927dqgtOsm8HpR3TFSRdcJbUgRmO+0xRvfHJ
         nlbA==
X-Gm-Message-State: AOJu0YyotBbh4Lft1U1yRtVGSL5wFjoyMDofHMs1Ourn8Yeagn7n2A+/
	hVcH1Xp3b8I54ATGF2kI+NCBYguwDlcXGEXLrDq+HQ==
X-Google-Smtp-Source: AGHT+IGBIOI+1EwOPVneFxq7kiG8a/BAOPw8eWi65SiYX1SAEvO0e8gGOY7yFbmBjlohmXQzTCcPfGpIau9B57/jY+U=
X-Received: by 2002:a05:600c:a4c:b0:409:6737:326b with SMTP id
 c12-20020a05600c0a4c00b004096737326bmr183202wmq.11.1698878427291; Wed, 01 Nov
 2023 15:40:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <ZULLNdp6XKD6Twuc@google.com> <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
In-Reply-To: <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 1 Nov 2023 15:39:58 -0700
Message-ID: <CALzav=ccmnY1kb3KatbSuYtXzGjsh7xFSKzmfv10pAOGJV3g7Q@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Anish Moorthy <amoorthy@google.com>
Cc: Sean Christopherson <seanjc@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 3:26=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
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
>
> Well the thing is that __gfn_to_pfn_memslot() is orthogonal to KVM
> exits. Its callers are just using it to try resolving a pfn, and what
> they do with the results is up to them.
>
> Put more concretely, __gfn_to_pfn_memslot() has many callers of which
> only two (the stage-2 fault handlers) actually use it to set up a KVM
> exit- how does a parameter named "can_exit_on_missing" make sense to
> its callers in general?

"exit" is shorthand for "return_to_userspace" and all KVM code runs in
the context of ioctls (which eventually return to userspace). So I
think it makes sense in general.

And FWIW I found the MEMSLOT_ACCESS_ enum hard to read and agree a
boolean would be simpler.
