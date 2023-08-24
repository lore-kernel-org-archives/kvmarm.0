Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA15013AFD
	for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 17:24:57 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-267f00f6876so16115a91.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 10:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692897897; x=1693502697;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qNhRIgPPAJgYOdqHkEPXtIgEpiaV0ld4q4V+3f9cbvg=;
        b=b+eh84rDiYn74BODGnelrlrFZ73uaoyKIKI+U1ElBMKEziMehrGetltgu2hoGQtRPz
         YRZSy3GYMvtuV4abKayFmhLVWTYvDvihdhd1MZMJSCJM+C6yLOJsXjGQox4jNxxrHzgQ
         QI19VSjzefsSmzHXToTAbMS7mn9S165fS82twRJ1wz0aIulkLX4e/UH4Jn8qhZxmy8vo
         79Y+fzOdDLUtuWQn7I9hVyUshqWB4JBJ5/6w8EWqQuCZXdjyfo8M47EjRMbjsuEhss5E
         tFqWJTybLGA8sU6F/tTw9jvlWLPRAjv10LdQnozSRSo2wblLahrk44xDDlNt+ush4XjR
         gjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692897897; x=1693502697;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qNhRIgPPAJgYOdqHkEPXtIgEpiaV0ld4q4V+3f9cbvg=;
        b=gT7QUCD8MmjpS6VzaSK4qSjALynC6I5a9McESaOA0VlCAI/qF5t5MpIsRxVdkOzW4d
         0IT62AkcgeLJT2pDiVpSoSvG68HF4smPQCuiiqBc1ST8CtClhfK6+pn5iMkj6SXElC6C
         6U5ZzL/fpqkZzbM9G0ELZQKGaQkRSrzQHqpIjYZ+qd5bR5QDccwTKtEv0Nyy0P62foJp
         hDrqoUC3Xy+BlZ4Nx4vqN43hT7r0WL1yNDejmHf0/ul0dIKP//I5iVrTlNVwVbm0yu8j
         jSjAdKbBFnAMk1OdzvMrn/YFLbro19wld5c1o83p0RyEdqPBtdfVe+MM580tDgym+GU0
         nmQw==
X-Gm-Message-State: AOJu0Yy4ltcqDLQUgyg5QK7LIih9wf1/mMjVbPbQapw2ytXjwGuVklZN
	WBGDnv08ORBlhscj8/wRrLB86ApGN/A=
X-Google-Smtp-Source: AGHT+IGKVz1fW1rh3wqfCqAzHna18XbrxT1X4An+gth8oKwk+SMzB/Wl4eiKhX+nKQuki7Cesth/BLh7CYM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c717:b0:26b:b78:c94f with SMTP id
 o23-20020a17090ac71700b0026b0b78c94fmr3978564pjt.7.1692897896801; Thu, 24 Aug
 2023 10:24:56 -0700 (PDT)
Date: Thu, 24 Aug 2023 10:24:55 -0700
In-Reply-To: <CAF7b7mpPcbxLKhPvLwVg4mwSbXRQ-zRhz8Osj-CVqhMnG6NRkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
 <ZNzyHqLKQu9bMT8M@google.com> <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
 <ZN60KPh2uzSo8W4I@google.com> <CAF7b7mo3WDWQDoRX=bQUy-bnm7_3+UMaQX9DKeRxAZ+opQCZiw@mail.gmail.com>
 <ZOaGF6pE5xk7C1It@google.com> <CAF7b7mpPcbxLKhPvLwVg4mwSbXRQ-zRhz8Osj-CVqhMnG6NRkw@mail.gmail.com>
Message-ID: <ZOeSZ5zScxM/DRf0@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2023, Anish Moorthy wrote:
> On Wed, Aug 23, 2023 at 3:20=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > I don't anticipate anything beyond the memory fault case.  We essential=
ly already
> > treat incomplete exits to userspace as KVM bugs.   MMIO is the only oth=
er case I
> > can think of where KVM doesn't complete an exit to usersapce, but that =
one is
> > essentially getting grandfathered in because of x86's flawed MMIO handl=
ing.
> > Userspace memory faults also get grandfathered in because of paravirt A=
BIs, i.e.
> > KVM is effectively required to ignore some faults due to external force=
s.
>=20
> Well that's good to hear. Are you sure that we don't want to add even
> just a dedicated u8 to indicate the speculative exit reason though?

Pretty sure.

> I'm just thinking that the different structs in speculative_exit will
> be mutually exclusive,

Given that we have no idea what the next "speculative" exit might be, I don=
't
think it's safe to assume that the next one will be mutually exclusive with
memory_fault.  I'm essentially betting that we'll never have more than 8
"speculative" exit types, which IMO is a pretty safe bet.

> whereas flags/bitfields usually indicate non-mutually exclusive condition=
s.
