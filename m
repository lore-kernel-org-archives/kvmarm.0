Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FB816405
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 22:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n4gzq0Nb"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1ef370c2e12so232796fac.1
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 15:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698879365; x=1699484165; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrvYQU4WA1un1SeaZQLwsW4KzArk33583vMtLvNHy+s=;
        b=n4gzq0NbnN/NgHQk0//3knGG4ihnIVNOyLagy2d8+Ks2NIikn47Is3kuXuaNGOGuuo
         Q4m+vfbLHpHICJ5IOiHE6HfAF2rAe0OIdDecWBoAESw+D2D7Jqqhu5588iLxcJZ51cDE
         RGnXajMpl1kuq/fsC++e+0lLwgRd2dsLV1PDNg8WPvpqFpjQnODqi6JmI8p2aKKMr8gW
         O2g1jG9yOhnBdXNqOdyENi23oEGLeLZTtPhF88C6ydxYHGRZbmI1Iz25SP7MGUcxHoId
         y17wKAorHd2GN8o4IIEZOnTrEw4bCb344jUKSnVrJ9adDn4honxCvLXew3T/o8hbMy3n
         bhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698879365; x=1699484165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrvYQU4WA1un1SeaZQLwsW4KzArk33583vMtLvNHy+s=;
        b=BlnjLrTA4V0QfN+9zjT+hSDBZorOZN27kZYqjEl7Yl2tp4ZI6bhwF2sYlzjz2A8RNv
         a3ZjW7TxtMWrztDiD3f8YNU33mPGB6qRxiiEhuUZnoH7Xw9Cisu7C9qXXot2Id/GIvyQ
         8tH71jXNoU36JeJjWJLuPJJ6w7Q5atxEi/B+jgbm9a81WOscqv7TpBw74TG8pNEJqw7Q
         hd7zwvrLEIxg6oYo+y9M4Xd0RhGHu5d1kpm0aMEjOFND0DySu6YUsZmBmu4eIwW6ecst
         DFzfjEElAXmOJnPsJfZsex7PjPblEOet3P4gSQCWz3cQMc8kbAMYZvyCX4U1VsyTCe6F
         oVCQ==
X-Gm-Message-State: AOJu0YykXSa1vscNXbC/sBuTqZcuwl9X/DhBgq/HIaBWCgYmP+MxVPyh
	K07CVbWKsmodo2qBPghMNR+hcnCrqlgqx4B47BXyqQ==
X-Google-Smtp-Source: AGHT+IH+2aIZiuOrtKGaaevt7OnKP2TRzw53ixw7u/I6WI7t+0IGfCTUwcgoNgYWrurLwuw9EkLvMEhLMOj9Z8J00go=
X-Received: by 2002:a05:6870:6b0c:b0:1e9:cde8:6db0 with SMTP id
 mt12-20020a0568706b0c00b001e9cde86db0mr24144773oab.50.1698879365487; Wed, 01
 Nov 2023 15:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-12-amoorthy@google.com>
 <ZR4WzE1JOvq_0dhE@google.com>
In-Reply-To: <ZR4WzE1JOvq_0dhE@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 1 Nov 2023 15:55:29 -0700
Message-ID: <CAF7b7mo0Pbju__J+58-0zHxNFn7R2=8WKTHmKYtcb_4eEa5bTw@mail.gmail.com>
Subject: Re: [PATCH v5 11/17] KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 4, 2023 at 6:52=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Sep 08, 2023, Anish Moorthy wrote:
> > The relevant __gfn_to_pfn_memslot() calls in __kvm_faultin_pfn()
> > already use MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.
>
> --verbose

Alright, how about the following?

    KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING

    __gfn_to_pfn_memslot(), used by the stage-2 fault handler, already
    checks the memslot flag to avoid faulting in missing pages as required.
    Therefore, enabling the capability is just a matter of selecting the kc=
onfig
    to allow the flag to actually be set.

> Hmm, I vote to squash this patch with
>
>   KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
>
> or rather, squash that code into this patch.  Ditto for the ARM patches.
>
> Since we're making KVM_EXIT_MEMORY_FAULT informational-only for flows tha=
t KVM
> isn't committing to supporting, I think it makes sense to enable the arch=
 specific
> paths that *need* to return KVM_EXIT_MEMORY_FAULT at the same time as the=
 feature
> that adds the requirement.
>
> E.g. without HAVE_KVM_USERFAULT_ON_MISSING support, per the contract we a=
re creating,
> it would be totally fine for KVM to not use KVM_EXIT_MEMORY_FAULT for the=
 page
> fault paths.  And that obviously has to be the case since KVM_CAP_MEMORY_=
FAULT_INFO
> is introduced before the arch code is enabled.
>
> But as of this path, KVM *must* return KVM_EXIT_MEMORY_FAULT, so we shoul=
d make
> it impossible to do a straight revert of that dependency.

Should we really be concerned about people reverting the
KVM_CAP_MEMORY_FAULT_INFO commit(s) in this way? I see what you're
saying- but it also seems to me that KVM could add other things akin
to KVM_CAP_EXIT_ON_MISSING in the future, and then we end up in the
exact same situation. Sure the squash might make sense for the
specific commits in the series, but there's a general issue that isn't
really being solved.

Maybe I'm just letting the better be the enemy of the best, but I do
like the current separation/single-focus of the commits. That said,
the squash is nbd and I can go ahead if you're not convinced.
