Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABCA13AEA
	for <kvmarm@lists.linux.dev>; Thu,  7 Sep 2023 21:17:44 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-26f3bf964feso1731982a91.1
        for <kvmarm@lists.linux.dev>; Thu, 07 Sep 2023 14:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694121463; x=1694726263; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x2FV0KT3ajRCKjsxeJWop7JpKlW5LxN1WJvX27m94bE=;
        b=y9EHs7gb1Iw3h4RQCe1jNiVxhrphrjaNw/TXBmyRxmbasDnyfblk+CivX9fg/mDtT6
         KqPFjOG31BZ6FDK/STjQJ++5d+8WS12L3er2YHtrknxC8+aB4M3K66U94e7vaXzVO33V
         7mh8/MzsGSjFEgvn1FcIKv857m1XlGRakHuPxWeyzOrj8/1WSuIChn9U3Su8cSkK5KHt
         fmK0GM5wfP+msCiKuDJoDzQd/r1HAaXEe2b1/3htkUkDm4nUaa36xYkxTCgXLwJ2ucJn
         eD7XYbj3qwE+acB6dU7iyeQJsbtxVIctyCUfRpFusjYjIYHQVgFRX86aSg/47vaRqric
         LGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694121463; x=1694726263;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x2FV0KT3ajRCKjsxeJWop7JpKlW5LxN1WJvX27m94bE=;
        b=BZUzJTG/8onc2FX4Ak3hnLV+G1y5b9X36y77BCUR+VlgNbFGsDkSD79hJe1U5Gx1zF
         nvJtJ9ZqYZzXqqC9SPPOEhdpCKpR7j9B6AFyLtxDa0DfJw4hP3k4/lT6UptmO4XCg1A+
         RRKMD8Ufu1yLpPC5zNU/VizGAAYpiD68yRtKbc5ajC+A29FzAVZj1AkEO6o0ScthOTfl
         DejmLuVDEJN6s1w7UjikM7A5cxSi3x56lmp8vO3CwKoj+riwE4W/1qqgyNpnnKOxgcVb
         ug0gUyh0tyE1mqfbgytFSUAddSz9y7uvzF4ULhHr5zvn+KP1UwbCZp5gNUuniuTZso/X
         3QNQ==
X-Gm-Message-State: AOJu0YwTY89CeWnDI2CHZuQkcjoFCvqjCj6k5b5pvAGKRDL9qYKLXluc
	ecXQhNrhsDWeW6o/OiqSxeSIOzFqCfY=
X-Google-Smtp-Source: AGHT+IFCGloeQ0Oj5HJp+rhtm5WjIIX/BxQGbKeMxm29FlKJB9A1h+gozoGcsghka1qv+6uCO236IXkkCDI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fd8b:b0:26c:f05d:1f2 with SMTP id
 cx11-20020a17090afd8b00b0026cf05d01f2mr211835pjb.7.1694121463436; Thu, 07 Sep
 2023 14:17:43 -0700 (PDT)
Date: Thu, 7 Sep 2023 14:17:42 -0700
In-Reply-To: <CAF7b7mr1EHF3EAU9PAFV16N0y52N2Ek8vPEcr60NQL7jd85PLg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <CAF7b7mqKJTCENsb+5MZT+D=DwcSva-jMANjtYszMTm-ACvkiKA@mail.gmail.com>
 <CAF7b7mrabLtnq+0Gtsg9FA+Gfr12FqbmfxwJZuQcBNDz1+3yLw@mail.gmail.com>
 <ZK11Sxobf53RsAmH@google.com> <CAF7b7mp1Bspeqc9n==gE5NgPwxfYLtu9G3=+OTwAcipeYRkPKg@mail.gmail.com>
 <ZO50Nvl5QaQMmNqX@google.com> <CAF7b7mr1EHF3EAU9PAFV16N0y52N2Ek8vPEcr60NQL7jd85PLg@mail.gmail.com>
Message-ID: <ZPo99vGUMqbl0RJF@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: "stevensd@chromium.org" <stevensd@chromium.org>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30, 2023, Anish Moorthy wrote:
> On Tue, Aug 29, 2023 at 3:42=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Aug 24, 2023, Anish Moorthy wrote:
> > > On Tue, Jul 11, 2023 at 8:29=E2=80=AFAM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > Well, that description is wrong for other reasons.  As mentioned in=
 my reply
> > > > (got snipped), the behavior is not tied to sleeping or waiting on I=
/O.
> > > >
> > > > >  Moving the nowait check out of __kvm_faultin_pfn()/user_mem_abor=
t()
> > > > > and into __gfn_to_pfn_memslot() means that, obviously, other call=
ers
> > > > > will start to see behavior changes. Some of that is probably actu=
ally
> > > > > necessary for that documentation to be accurate (since any usages=
 of
> > > > > __gfn_to_pfn_memslot() under KVM_RUN should respect the memslot f=
lag),
> > > > > but I think there are consumers of __gfn_to_pfn_memslot() from ou=
tside
> > > > > KVM_RUN.
> > > >
> > > > Yeah, replace "in response to page faults" with something along the=
 lines of "if
> > > > an access in guest context ..."
> > >
> > > Alright, how about
> > >
> > > + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS
> > > + The presence of this capability indicates that userspace may pass t=
he
> > > + KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS flag to
> > > + KVM_SET_USER_MEMORY_REGION. Said flag will cause KVM_RUN to fail (-=
EFAULT)
> > > + in response to guest-context memory accesses which would require KV=
M
> > > + to page fault on the userspace mapping.
> > >
> > > Although, as Wang mentioned, USERFAULT seems to suggest something
> > > related to userfaultfd which is a liiiiitle too specific. Perhaps we
> > > should use USERSPACE_FAULT (*cries*) instead?
> >
> > Heh, it's not strictly on guest accesses though.
>=20
> Is the inaccuracy just because of the KVM_DEV_ARM_VGIC_GRP_CTRL
> disclaimer, or something else? I thought that "guest-context accesses"
> would capture the flag affecting memory accesses that KVM emulates for
> the guest as well, in addition to the "normal" EPT-violation -> page
> fault path. But if that's still not totally accurate then you should
> probably just spell this out for me.

A pedantic interpretation of "on guest access" could be that the flag would=
 only
apply to accesses from the guest itself, i.e. not any emulated accesses.

In general, I think we should avoid having the name describe when KVM honor=
s the
flag, because it'll limit our ability to extend KVM functionality, and I do=
ubt
we'll ever be 100% accurate, e.g. guest emulation that "needs" kvm_vcpu_map=
() will
ignore the flag.

Regarding USERFAULT, why not lean into that instead of trying to avoid it? =
 The
behavior *is* related to userfaultfd; not in code, but certainly in its pur=
pose.
I don't think it's a stretch to say that userfault doesn't _just_ mean the =
fault
is induced by userspace, it also means that the fault is relayed to userspa=
ce.
And we can even borrow some amount of UFFD nomenclature to make it easier f=
or
userspace to understand the purpose.

For initial support, I'm thinking

  KVM_MEM_USERFAULT_ON_MISSING

i.e. generate a "user fault" when the mapping is missing.  That would give =
us
leeway for future expansion, e.g. if someday there's a use case for generat=
ing a
userfault exit on major faults but not on missing mappings or minor fault, =
we
could add KVM_MEM_USERFAULT_ON_MAJOR.
=20
> > > On Wed, Jun 14, 2023 at 2:20=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> >
> > We'll need a way to way for KVM to opt-out for kvm_vcpu_map(), at which=
 point it
> > makes sense to opt-out for kvm_vm_ioctl_mte_copy_tags() as well.
>=20
> Uh oh, I sense another parameter to __gfn_to_pfn_memslot(). Although I
> did see that David Stevens has been proposing cleanups to that code
> [1]. Is proper practice here to take a dependency on his series, do we
> just resolve the conflicts when the series are merged, or something
> else?

No, don't take a dependency.  At this point, it's a coin toss as to which s=
eries
will be ready first, taking a dependency could unnecessarily slow this seri=
es down
and/or generate pointless work.  Whoever "loses" is likely going to have a =
somewhat
painful rebase to deal with, but I can help on that front if/when the time =
comes.

As for what is "proper practice", it's always a case-by-case basis, but a g=
ood rule
of thumb is to default to letting the maintainer handle conflicts (though d=
efinitely
call out any known conflicts to make life easier for everyone), and if you =
suspect
that your series will have non-trivial conflicts, ask for guidance (like yo=
u just
did).
