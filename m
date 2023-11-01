Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077221B27B
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 22:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VmOXTf6H"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6d2efe8c43eso675038a34.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 15:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698877554; x=1699482354; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=294ol75obltyYqEqfl+9y62VRvfSAWQRBPN9Wezacbg=;
        b=VmOXTf6HiqiWS02Ub+zpB4LVHEuhEy87zlZ2lXZln9buYVyiOxyGm0KknrYGTuJMed
         +DuLq9AIKGJdGf8PojlbcvxtuuO2nHSZsxI5nw08WblrmzcsVK5MyDyrzludgNg/qRqa
         ROWCFJ20qO8WhZGpjrewqYSUNiGyb1ejkCSKDlQ4ohMO5l69bgBx22uvS2vZ0ZH3aBew
         vmjgB1k3piyLd4cZihNgpMW9sBGweR7WtTRqPDFbnRU5Wl1GuNLqrxgECazzqcaabHzz
         uGZuseiNKNhFft1MhPUK+Javp+ZHbNn+Jvpcvwq18G15wVpVORmH4FAO/J2NsVj3SYPw
         z4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698877554; x=1699482354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=294ol75obltyYqEqfl+9y62VRvfSAWQRBPN9Wezacbg=;
        b=wfPle9r/C/oXDpsUB5gehSQ5F+zQUfHU/8ncipALSoiFOBJALjuU0sfWHY3QSxk+dX
         lrvF1bI54puBeCkDKh8Sq+sOMnBWVoS1gsd0sJZ3i1HtbOYojJN5s97mvlvUB1uoJ1uI
         K4sqEeL4gQIEctPie4/sN142HjARuwfua31qW5vuzIj/MjuW/3xSXFdxLWGBzXCJ0G/R
         L5gsRVJk7b+0ZDUienVYgPDrvkKYRJGjChRxtarZCj5Xkz3pUQJNGFtgvFa4c/YWBeh8
         KL/J1my992KkmDkwe6T8F+TIo/C53n3loE+a6Epi3HqBN6g0e8bsfMoEVZHCG7jwQ8EV
         0MlA==
X-Gm-Message-State: AOJu0Yy5d94sErmzuTP+SLJN61ousMcXAzkV1QH3rpCthRFVjvMVU+aO
	JUn/Jb6Z5m/MGzGn3/wpNY+i86j/0rGFvwYuSe2W0w==
X-Google-Smtp-Source: AGHT+IEz52TIIahqocPRQHTgpnNRkVELhbb8QsFoXnxMsUeqH1qkZEFXxONxXhy1tVdwDNDCy4jVR8qXcK82xhTcmaY=
X-Received: by 2002:a05:6830:3149:b0:6bd:62c1:65c with SMTP id
 c9-20020a056830314900b006bd62c1065cmr2188470ots.18.1698877553954; Wed, 01 Nov
 2023 15:25:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <ZULLNdp6XKD6Twuc@google.com>
In-Reply-To: <ZULLNdp6XKD6Twuc@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 1 Nov 2023 15:25:17 -0700
Message-ID: <CAF7b7mqEU0rT9dqq5SXvE+XU0TdCbXWk0OW2ayrW5nBg3M_BFg@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 1, 2023 at 3:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Nov 01, 2023, Anish Moorthy wrote:
> > On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > Eh, the shortlog basically says "do work" with a lot of fancy words. =
 It really
> > > just boils down to:
> > >
> > >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_=
MISSING
> >
> > Proposed commit message for v6:
> >
> > > KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in __=
gfn_to_pfn_memslot()
> > >
> > > When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> > > faulting in pages for which mappings are absent. However, some caller=
s of
> > > __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt o=
ut
> > > of this behavior: allow doing so via the new can_exit_on_missing
> > > parameter.
> >
> > Although separately, I don't think the parameter should be named
> > can_exit_on_missing (or, as you suggested, can_do_userfault)-
> > __gfn_to_pfn_memslot() shouldn't know or care how its callers are
> > setting up KVM exits, after all.
>
> Why not?  __gfn_to_pfn_memslot() gets passed all kinds of constraints, I =
don't
> see how "I can't handle exits to userspace" is any different.

Well the thing is that __gfn_to_pfn_memslot() is orthogonal to KVM
exits. Its callers are just using it to try resolving a pfn, and what
they do with the results is up to them.

Put more concretely, __gfn_to_pfn_memslot() has many callers of which
only two (the stage-2 fault handlers) actually use it to set up a KVM
exit- how does a parameter named "can_exit_on_missing" make sense to
its callers in general? If it were __gfn_to_pfn_memslot() itself that
was populating the run struct in response to absent mappings then I
would agree that the name was appropriate- but that's not what's going
on here.

(side note, I'll assume that aside from the current naming discussion
the commit message I proposed is fine)
