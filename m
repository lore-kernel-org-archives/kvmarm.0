Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2A012B74
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 22:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mpE4wy5r"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2775a7f3803so1370864a91.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Oct 2023 15:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696543985; x=1697148785; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnXAgmYjWV4CQ2aJrszJtrf0PhF8V6dwxv1eIYoBHbA=;
        b=mpE4wy5rB7mB28+LqFp4QVw7kpWfjVIuPaLnkF97wdsjYsoasFjanYWpxYEp4JKIeZ
         ziyidMXU4a9zwho2ZDYVNwCsVquB9tOxe6p1zTJTDtd+n0YsjAvPnxgrg20ktXHa4Pwe
         rk2FN3MFvc8ZdSYbhSiIQbvWTMF/LiCn+KwUTEult8NbqXHsls0rJzsFY3yitcWYeuvj
         AaSeKKUfm97M8+wKCIZq5eA0+XxajlS0Rui6RyvJv9+lVKDFbiNVk4D4u8QDxVbSWmSC
         BFS0BNvaLdLiSWQZSVrGyPmia69jCFwjrWbcfiY05AjquFnC4LpAkukj989yfWwh0k11
         YM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696543985; x=1697148785;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GnXAgmYjWV4CQ2aJrszJtrf0PhF8V6dwxv1eIYoBHbA=;
        b=haQ5ApGUPWWgplYVNlhpm/hoAG3Ocz/vHT5gkzOm7gfeJC3AwCC0fhRHhVVBYov3tv
         FOR1w16UkFNz8Im03Hq0TEnYblRoliAePhubl4n5+3mpdjyaY4R5jieXs/zOs+biTobW
         zJbj+JmzhisoligSaPXvnmUqtfvwWrYovezIakU2O6Cg4h1Pjub3KJ6vuSvdKmRvUSiK
         GNoOjXKnyfdhw46D90Y1F8NEoHJPtk7N6xQrDeY9J7u0Bk+Tj2wrbavS5GsENeJrxFLO
         R9FJr6mc3cHouALTpARKRQKC9lrzbmggS4XLnPa+v+at9s0r5WfnzeJx1tiUfB47aONK
         M5VA==
X-Gm-Message-State: AOJu0Yyjxqm0n+6C1+kDRxbkE7DFqeK4V1io1bQ/rhdF1qQwBLefpiYN
	DZbPz5ZPocTc9Z6VPn/ee8h/GInPP5E=
X-Google-Smtp-Source: AGHT+IF1mCbw2/u0ploN08QMjX7gv1FuTEbeeim8gFeu1LQBP/sup1ckQwFmhuEJoEnMwmMZs/vciGiNjEw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a393:b0:274:90a4:f29 with SMTP id
 x19-20020a17090aa39300b0027490a40f29mr104682pjp.1.1696543985158; Thu, 05 Oct
 2023 15:13:05 -0700 (PDT)
Date: Thu, 5 Oct 2023 15:13:03 -0700
In-Reply-To: <CAF7b7moE19p+kDXuwaxHCY6=NXB95fNJ7ectNRxdUMMBpgT0Fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <ZR4N8cwzTMDanPUY@google.com> <CAF7b7moE19p+kDXuwaxHCY6=NXB95fNJ7ectNRxdUMMBpgT0Fg@mail.gmail.com>
Message-ID: <ZR807zVvDytyO1zV@google.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
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
> On Wed, Oct 4, 2023 at 6:14=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > And peeking at future patches, pass in the RWX flags as bools, that way=
 this
> > helper can deal with the bools=3D>flags conversion.  Oh, and fill the f=
lags with
> > bitwise ORs, that way future conflicts with private memory will be triv=
ial to
> > resolve.
> >
> > E.g.
> >
> > static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> >                                                  gpa_t gpa, gpa_t size,
> >                                                  bool is_write, bool is=
_exec)
> > {
> >         vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
> >         vcpu->run->memory_fault.gpa =3D gpa;
> >         vcpu->run->memory_fault.size =3D size;
> >
> >         vcpu->run->memory_fault.flags =3D 0;
> >         if (is_write)
> >                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLA=
G_WRITE;
> >         else if (is_exec)
> >                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLA=
G_EXEC;
> >         else
> >                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLA=
G_READ;
> > }
>=20
> Is a BUG/VM_BUG_ON() warranted in the (is_write && is_exec) case do
> you think?

Nah, not here.  If we really wanted to add a sanity check, a KVM_MMU_WARN_O=
N()
in kvm_mmu_page_fault() would be the way to go.

> I see that user_mem_abort already VM_BUG_ON()s for this case, but if ther=
e's
> one in the x86 page fault path I don't immediately see it. Also this help=
er
> could be called from other paths, so maybe there's some value in it.
>=20
> > I'll send you a clean-ish patch to use as a starting point sometime nex=
t week.
>=20
> You mean something containing the next spin of the guest memfd stuff?
> Or parts of David's series as well?

guest_memfd stuff.  Effectively this patch, just massaged to splice togethe=
r all
of the fixups.
