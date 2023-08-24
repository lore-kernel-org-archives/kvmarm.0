Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF64C5696
	for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 08:03:24 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2b95d5ee18dso99078621fa.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 01:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864202; x=1693469002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwL3iE/sigInGebDo7+XC2zrCJyIJXwWg9T7XgYdvUo=;
        b=gxvA/c6f/mD+SfAn3i79Fac49CIYCfuEAc0NJXFLYFB579Htuh0raSgmo5mwINjJKP
         6mZXPbJVoLaq/tx8bw95ips+dNfMElarUiEFePbfy6xKS2dz4ss1ZXXCCdNYMwI1jeLf
         17LTOViCbmKzZvWJJEazhuc9QUFLtiG02+szQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864202; x=1693469002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwL3iE/sigInGebDo7+XC2zrCJyIJXwWg9T7XgYdvUo=;
        b=LpqKO4RuSHDTyB/9FqbxIslNqjgbrxtY67Z0BB6v+TVOjh0v90Sy4FwOK1ynbuBGr9
         3hlgh09TnUWau8GHOnxrX6+lyxnlp7y/F17bwAEcXTrCOqlvdO3A2+XTGWu9/h85w7ls
         EqSTSc9XABxRZoTBWL5anoMI7OCfcnjanwAF849mm4h6sgTlYhCu8DddjCP1rzeToBXz
         3QJeJvogAMqH3IdASNR/3HP+IZA7G20tZ8nUaoCtnhq9bM+31yragHGMbphaJnkUe8y8
         KcQvKlyDaH5u/fc89AlE8+aJyNBhJEuchzOIRBxAu1FhYr9rYjXWx5hj6U9DBYDafkFo
         DSBA==
X-Gm-Message-State: AOJu0YzcmrV/eIlNceffCjlydu1FknQuPQ9+X62YYdfOHkNTU90te0id
	3u1IXnEQ8PBy6hW7mFz9nBPW31ISWxs09S5U1R/GqQ==
X-Google-Smtp-Source: AGHT+IEJrvoCh3YeHUxATo9a8VY8kdH7uwNLYGWpcGp3BdwVjU+SPGgyEkpIPGghrgwO/hJ/muX8oz01uFd1YWIRnOA=
X-Received: by 2002:a2e:8e97:0:b0:2bb:aaab:b42f with SMTP id
 z23-20020a2e8e97000000b002bbaaabb42fmr10476719ljk.49.1692864202467; Thu, 24
 Aug 2023 01:03:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-5-stevensd@google.com>
 <20230706015449.GB3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230706015449.GB3894444@ls.amr.corp.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 24 Aug 2023 17:03:11 +0900
Message-ID: <CAD=HUj43RG6M5_TEKBjv+Aioj8rZXKZFN_R8dinjhcpnN219hg@mail.gmail.com>
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 6, 2023 at 10:54=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:49PM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > From: David Stevens <stevensd@chromium.org>
> >
> > Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ec169f5c7dce..e44ab512c3a1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *=
vcpu, struct kvm_async_pf *work)
> >  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fa=
ult *fault)
> >  {
> >       struct kvm_memory_slot *slot =3D fault->slot;
> > -     bool async;
> > +     struct kvm_follow_pfn foll =3D {
> > +             .slot =3D slot,
> > +             .gfn =3D fault->gfn,
> > +             .flags =3D FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> > +             .allow_write_mapping =3D true,
> > +     };
> >
> >       /*
> >        * Retry the page fault if the gfn hit a memslot that is being de=
leted
> > @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *v=
cpu, struct kvm_page_fault *fault
> >                       return RET_PF_EMULATE;
> >       }
> >
> > -     async =3D false;
> > -     fault->pfn =3D __gfn_to_pfn_memslot(slot, fault->gfn, false, fals=
e, &async,
> > -                                       fault->write, &fault->map_writa=
ble,
> > -                                       &fault->hva);
> > -     if (!async)
> > -             return RET_PF_CONTINUE; /* *pfn has correct page already =
*/
> > +     foll.flags |=3D FOLL_NOWAIT;
> > +     fault->pfn =3D __kvm_follow_pfn(&foll);
> > +
> > +     if (!is_error_noslot_pfn(fault->pfn))
>
> We have pfn in struct kvm_follow_pfn as output. Can we make __kvm_follow_=
pfn()
> return int instead of kvm_pfn_t?  KVM_PFN_* seems widely used, though.

Switching __kvm_follow_pfn to return an int isn't difficult, but doing
is cleanly would require reworking the kvm_pfn_t/KVM_PFN_ERR_* api,
which as you said is quite widely used. That's a bit larger scope than
I want to do in this patch series.

-David
