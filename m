Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB851BDE4
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OHEedhRs"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5b31e000e97so14876697b3.1
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 07:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698935488; x=1699540288; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lAaMrTmFkqkQBDJIun0NhM/ukv/V2L1IOTp3rGU5ITI=;
        b=OHEedhRsECXudrtnag0+kLBECB7qeAuxIAdwAsqdUbZjPoyjEHxr///+pUG36Qfzi2
         NIpVYaVaDWIr8Vi24ZjroIz/nxJO0ITMnHaCac0exKpX9wljvRc1QC2XfHDFS8P72UJO
         YJQhA+oO7kZ10whv2uVmn7d1iHMmZoV0BJnBAVsf7xPlHuBFL/XFcaOdZN5x30y6Vef9
         DtSMep88PgOLfEh2nE30iCAOvOjBcUtBsDCameCfkj7koW3SWR1wPxwtsXXwHYpgdTYv
         +2/DSx783gk4mhx3CspP4PP/UnxetyUoDo6Vzt4CmkYJ4Tl6zRmcyAAmkaxOkpzPeF4H
         6fGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698935488; x=1699540288;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lAaMrTmFkqkQBDJIun0NhM/ukv/V2L1IOTp3rGU5ITI=;
        b=onQBF9t7TOl38NeZrloQ/IzzxrcWm9i66VTwFWm1Z32xvkog7gdQRO4oU53jBYVsAg
         zqQsWmDD168tayP2XTgmiO4hp23d/bdd4C1t7DaKUx+x3OA9T4xWutgFQGbCpBVPWPYP
         LZE1/e02GGJC+r3SP2AL3iM4VE9sf4BjSzcox5c16jm9kTCB47U0S8N0B6s/byFRkRvy
         589lVS+L7h0vAeT19aeYhqw5BLKLLlGIyoKsalOxXZokGnqr+xwBUq5vpbgHNXA10C4e
         c2+sMsNrCMvyWdcKPtrb+Kk/Vx0RhkusrihyvpOElYkIEk6pmTy6Bxw+mO/cW07h2pHH
         YlEw==
X-Gm-Message-State: AOJu0YxePxuwdVniiKGQd6gp2XTBO7QokQelYPj9cygdPnZVsd2dISpS
	e+Wd84qKiDiZuGNku3c+2ELb4fhLnkc=
X-Google-Smtp-Source: AGHT+IFt5OlbwPoWBLHdP1x9iWe1p/R5K4XFVEL+0pJMEt6E5XClHt/AagSNfWvU17EPnbEIB37aU8lKvgo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4f4e:0:b0:586:50cf:e13f with SMTP id
 d75-20020a814f4e000000b0058650cfe13fmr390775ywb.1.1698935488657; Thu, 02 Nov
 2023 07:31:28 -0700 (PDT)
Date: Thu, 2 Nov 2023 07:31:27 -0700
In-Reply-To: <CAF7b7mo0Pbju__J+58-0zHxNFn7R2=8WKTHmKYtcb_4eEa5bTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-12-amoorthy@google.com>
 <ZR4WzE1JOvq_0dhE@google.com> <CAF7b7mo0Pbju__J+58-0zHxNFn7R2=8WKTHmKYtcb_4eEa5bTw@mail.gmail.com>
Message-ID: <ZUOyvwfLKlDKZKf8@google.com>
Subject: Re: [PATCH v5 11/17] KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 01, 2023, Anish Moorthy wrote:
> On Wed, Oct 4, 2023 at 6:52=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Fri, Sep 08, 2023, Anish Moorthy wrote:
> > > The relevant __gfn_to_pfn_memslot() calls in __kvm_faultin_pfn()
> > > already use MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.
> >
> > --verbose
>=20
> Alright, how about the following?
>=20
>     KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING
>=20
>     __gfn_to_pfn_memslot(), used by the stage-2 fault handler, already
>     checks the memslot flag to avoid faulting in missing pages as require=
d.
>     Therefore, enabling the capability is just a matter of selecting the =
kconfig
>     to allow the flag to actually be set.
>=20
> > Hmm, I vote to squash this patch with
> >
> >   KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
> >
> > or rather, squash that code into this patch.  Ditto for the ARM patches=
.
> >
> > Since we're making KVM_EXIT_MEMORY_FAULT informational-only for flows t=
hat KVM
> > isn't committing to supporting, I think it makes sense to enable the ar=
ch specific
> > paths that *need* to return KVM_EXIT_MEMORY_FAULT at the same time as t=
he feature
> > that adds the requirement.
> >
> > E.g. without HAVE_KVM_USERFAULT_ON_MISSING support, per the contract we=
 are creating,
> > it would be totally fine for KVM to not use KVM_EXIT_MEMORY_FAULT for t=
he page
> > fault paths.  And that obviously has to be the case since KVM_CAP_MEMOR=
Y_FAULT_INFO
> > is introduced before the arch code is enabled.
> >
> > But as of this path, KVM *must* return KVM_EXIT_MEMORY_FAULT, so we sho=
uld make
> > it impossible to do a straight revert of that dependency.
>=20
> Should we really be concerned about people reverting the
> KVM_CAP_MEMORY_FAULT_INFO commit(s) in this way?

Yes.  A revert is highly unlikely, but possible.  Keep in mind that with up=
stream
KVM, there are a *lot* of end users that don't know the inner workings of K=
VM
(or the kernel).  When things break, the standard approach for such users i=
s to
bisect to find where things first broke, and then to try reverting the susp=
ected
commit to see if that fixes the problem.

In the (again, highly unlikely) case that filling run->memory_fault breaks =
something,
an unsuspecting user will bisect to that commit and revert.  Then they're s=
uddenly
in a situation where they've unknowing broken KVM, and likely in a way that=
 won't
immediately fail.

*Nothing* in either changelog gives any clue that there is a hard dependenc=
y.
Even the slightly more verbose version above provides almost no indication =
of the
real dependency, as it primarily talks about __gfn_to_pfn_memslot() and
KVM_CAP_EXIT_ON_MISSING.
=20
And now that we've punted on trying annotate "everything", there's no sane =
way
for the "Annotate -EFAULTs from kvm_handle_error_pfn()" changelog to commun=
icate
that it will have a hard dependency in the future.  If the changelog says "=
this
will be used by blah blah blah", then it raises the question of "well why i=
sn't
this added there?".

And the patches are tiny.  Having a final "enable and advertise XYZ" patch =
is
relatively common for new features, but that's often because the enabling o=
f the
new feature is spread across multiple patches.  E.g. see the LAM support si=
tting
in "https://github.com/kvm-x86/linux.git lam".  And in those cases, the har=
d
dependency is always very obvious, e.g. if someone complained that revertin=
g
"Virtualize LAM for user pointer" but not "Advertise and enable LAM (user a=
nd
supervisor)" caused problems, we'd be like, "well, yeah".

> I see what you're> saying- but it also seems to me that KVM could add oth=
er
> things akin to KVM_CAP_EXIT_ON_MISSING in the future, and then we end up =
in
> the exact same situation.

No, it's not the exact same situation.

First and foremost, we *can't* solve that problem, because some future feat=
ure
doesn't exist yet.

Second, merging features into two different kernel releases creates a very =
different
situation.  Let's say this goes into kernel 6.9, and then some future featu=
re
lands in kernel 6.11 and has a hard dependency on the annotations.  The odd=
s of
needing to revert a patch from 6.9 while upgrading to 6.11 are significnatl=
y lower
than the odds of needing to revert a patch from 6.9-rc1 between when rc1 is=
 released
and a user upgrades to 6.9.  And users aren't stupid; they might not know t=
he inner
workings of KVM, but bisecting to a patch from 6.9 when upgrading to 6.11 w=
ould
give them pause.

Third, with the patches squashed, to revert the annotations, a person would=
 also
be reverting _this_ patch (because they'd be one and the same).  At that po=
int,
they're no longer reverting a seemingly innocous "give userspace more info"=
 commit,
they're reverting something that clearly advertises a feature userspace, wh=
ich
again provides a clue that a straight revert might not be super safe.

> Sure the squash might make sense for the specific commits in the series, =
but
> there's a general issue that isn't really being solved.

Patches within a series and future series are two very different things.

> Maybe I'm just letting the better be the enemy of the best,

The "best" isn't even possible, unless we never ship anything, ever.

> but I do like the current separation/single-focus of the commits.

Because you already know what the entire series does.  Someone looking at t=
his
patch without already understanding the big picture is going to have no ide=
a that
these two patches are tightly coupled.

And again, now that we've punted on annotating everything, I see zero reaso=
n to
split the patches.  Maybe you could argue it provides a new bisection point=
, but
again the patches are _tiny_, and that same bisection point is effectively =
achieved
by running with an "older" userspace, i.e. a userspace that doesn't utilize=
 the
KVM_MEM_EXIT_ON_MISSING, which is literally every userspace in existence ri=
ght now.

> That said, the squash is nbd and I can go ahead if you're not convinced.
