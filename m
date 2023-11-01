Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD7C15E83
	for <kvmarm@lists.linux.dev>; Wed,  1 Nov 2023 22:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cda7/MgK"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-280051630e5so417909a91.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Nov 2023 15:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698876215; x=1699481015; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ZU+1hGLS1p24YJ0Oz/rgPyiteG3BeX33TYEESUTVqo=;
        b=Cda7/MgKJTKe/lvWLxramPWTM33GbssktSNt/2xIx8oP5i+KYEoskpKq4ykiok3UOl
         b03X7DvlI+ww9lPbg1DhF8i7pbomeZDdQ9boozjlfcilqxRooNNiw1LiGYg2ZC84qEaP
         7KnT8dCEakd08EDm7Vhs4DAlYF8OUHM8/DOxkbIhOWM4OC29zvM8k+1uYauG6Hk7PlgC
         jKSs0Bzv0g2dnOeZ1bNbNwqleqkxGlDMobtC+FFi5/M+T8MufqITzyALJCfwQyCmSy19
         6jhxZgUpn/zW4rzo3SEDA7W4Su+2T3sjH6GWQQgTmSKo/mvF3SRv1MbPLhYNykSk9EQr
         i4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698876215; x=1699481015;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9ZU+1hGLS1p24YJ0Oz/rgPyiteG3BeX33TYEESUTVqo=;
        b=bYNZDDZYuGg+wxs9siBdmlbQRvt9J7WZ1hN8oimbC2kZZu/g1ns4mOWjsY2MTot6mq
         j35g1qqGQilInlJc+z9DyZaxv1HcvnKEIFZGqwaAEpjRRy0hf+wpd1HnMCe5svTyK2O4
         2PhRxR/sGI95cKr1mnwnB8oxR4ySDP8eckVjrw15o2eQgrn4lU32ax0oA78BWkDVyxo6
         3OJ2Ct1i/Rx1dnyU47su2/vOCGm044JA7gWQAs/bkV+RmIRHIU2nMsKr6RMe/3z89D02
         ld7OiPjVvTjyLL8ikQkdZKy5omBPpFPMeFf4BhCTVWZa4qSx/XueiXmZ87iUKOzXNQdC
         k8GA==
X-Gm-Message-State: AOJu0YwJ5jgB35qxTM5dTNrBlaFOSUUYD49nfp7KvOijN74IJMG4aYxA
	7i8j3TpXfVYgF7X+1U3ZFqgHrt0dsi8=
X-Google-Smtp-Source: AGHT+IHPcjgmyv9WoTbUQE58M8ZiWzPznaMabtLTbSV5dQBOxggN5DSgAVvI1zvZhKtsRySjP+UptSV3mCU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:185:b0:1cc:3da9:2b96 with SMTP id
 z5-20020a170903018500b001cc3da92b96mr284471plg.3.1698876214832; Wed, 01 Nov
 2023 15:03:34 -0700 (PDT)
Date: Wed, 1 Nov 2023 15:03:33 -0700
In-Reply-To: <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
Message-ID: <ZULLNdp6XKD6Twuc@google.com>
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
> On Wed, Oct 4, 2023 at 6:44=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Eh, the shortlog basically says "do work" with a lot of fancy words.  I=
t really
> > just boils down to:
> >
> >   KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MI=
SSING
>=20
> Proposed commit message for v6:
>=20
> > KVM: Implement KVM_CAP EXIT_ON_MISSING by checking memslot flag in __gf=
n_to_pfn_memslot()
> >
> > When the slot flag is enabled, forbid __gfn_to_pfn_memslot() from
> > faulting in pages for which mappings are absent. However, some callers =
of
> > __gfn_to_pfn_memslot() (such as kvm_vcpu_map()) must be able to opt out
> > of this behavior: allow doing so via the new can_exit_on_missing
> > parameter.
>=20
> Although separately, I don't think the parameter should be named
> can_exit_on_missing (or, as you suggested, can_do_userfault)-
> __gfn_to_pfn_memslot() shouldn't know or care how its callers are
> setting up KVM exits, after all.

Why not?  __gfn_to_pfn_memslot() gets passed all kinds of constraints, I do=
n't
see how "I can't handle exits to userspace" is any different.

> I think it makes sense to rename the new parameter and, for the same
> reasoning, the memslot flag to "forbid_fault_on_missing" and
> KVM_MEM_FORBID_FAULT_ON_MISSING respectively. Objections?

Yes.  I very strongly prefer KVM_MEM_EXIT_ON_MISSING.  As David pointed out=
, KVM
already has established nomenclature around exit, i.e. "exit on" should be =
quite
intuitive for most KVM developers.

"Forbid fault" is rather nonsensical because a fault has already happened. =
 The
confusion between "page fault VM-Exit" and "faulting in memory in the host"=
 is
the main reason we wandered away from anything with "fault" in the name.

That said, I do agree that can_do_userfault doesn't work with KVM_MEM_EXIT_=
ON_MISSING.
Maybe just a boring can_exit_on_missing?
