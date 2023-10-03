Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94A93FB09
	for <kvmarm@lists.linux.dev>; Tue,  3 Oct 2023 23:46:28 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-27756e0e4d8so1300053a91.3
        for <kvmarm@lists.linux.dev>; Tue, 03 Oct 2023 16:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696376788; x=1696981588; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gaHRh+iyoB6/OttqFX2Q86pGvl0bhGVCVyqFTvtoGcw=;
        b=G7l2tqIVlTwsZ9Yt4fL1/qrWtFhDiM9EGgsMJCHpMSViMponGp/7jizAXiYXMUatsI
         qzDFWIsBunCb+kE+OAtPzzHKXjEd7xu3V3lfg1CwWSQrmkMtnMrRalMXYwv6L9jplmFE
         DxQvf6fwRujZ3XtHalnBo74y1Zd1bUqYTiFy+FNJ5O7BgmXlZ71vzvDSMj6FTiMwZLH3
         jgUBrXgmx8o9nF03xSLnQyZiN4lrZEaYMspwoMawRP4b+Ax0l09kpDjTK9zDb+6kDJ8M
         hpN670L17HiA45thZUE4boUw77zTKqNHKgOhfGewXPG7IA7VYm6wwQsAeD4mFAnoVFRy
         qVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696376788; x=1696981588;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gaHRh+iyoB6/OttqFX2Q86pGvl0bhGVCVyqFTvtoGcw=;
        b=A3qItbMRQ9PXRL19hS3bqk35As1/iBAuc07LyIDeSUQOOBeyzKLQP4Gn9A+8obFy/Y
         u30VW7+5JH0GId5n/doX/gMWitNSXPKzcpU+wTF8koq8IfVmcdzVTJvDbcO1iRPWV4Sf
         Zs2cqB+TmsIhLkTCt4klQA3bkLW/gD6mFxFDAANGc4V8DA2Ny8bqTZbeGjBR04Y3TvaB
         HrYJXW/41B1HhPEHZ6c9O5WX3oGTtFHRrMtWG51nw0qinf+wAqcOMseyn36fhxuO6wAa
         Btv8YUSZD5IoqvemVvvPdN03+Ooow9rLsN/BET+BCN7bd80bHx8zy5tEzkQppfNeeWDZ
         Fmwg==
X-Gm-Message-State: AOJu0YzkjX0zmD1nROV58R42FSEEE+xQ9oLD4O5JQT6yWEnSJW5JpNvV
	8smkCXyLEXu8W46NK50zy5mfltWXOb0=
X-Google-Smtp-Source: AGHT+IE1XHpyO3fF4751nYD6L1cufL1XUM2b3xSCMQMb58rp5yQSCvcWy8YfsNAskAty/E/22t80Ux7giMw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8186:b0:274:6af0:d75b with SMTP id
 e6-20020a17090a818600b002746af0d75bmr12051pjn.7.1696376787828; Tue, 03 Oct
 2023 16:46:27 -0700 (PDT)
Date: Tue, 3 Oct 2023 16:46:26 -0700
In-Reply-To: <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
Message-ID: <ZRyn0nPQpbVpz8ah@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 03, 2023, Anish Moorthy wrote:
> On Mon, Oct 2, 2023 at 6:43=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > > - I should go drop the patches annotating kvm_vcpu_read/write_page
> > > from my series
> >
> > Hold up on that.  I'd prefer to keep them as there's still value in giv=
ing userspace
> > debug information.  All I'm proposing is that we would firmly state in =
the
> > documentation that those paths must be treated as informational-only.
>=20
> Userspace would then need to know whether annotations were performed
> from reliable/unreliable paths though, right? That'd imply another
> flag bit beyond the current R/W/E bits.

No, what's missing is a guarantee in KVM that every attempt to exit will ac=
tually
make it to userspace.  E.g. if a different exit, including another memory_f=
ault
exit, clobbers an attempt to exit, the "unreliable" annotation will never b=
e seen
by userspace.

The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace could =
be
"unreliable" is if something other than a memory_fault exit clobbered the u=
nion,
but didn't signal its KVM_EXIT_* reason.  And that would be an egregious bu=
g that
isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption would =
affect
each and every other KVM_EXIT_* reason.

The "informational only" part is that userspace can't develop features that
*require* KVM to exit.

> > > - The helper function [a] for filling the memory_fault field
> > > (downgraded back into the current union) can drop the "has the field
> > > already been filled?" check/WARN.
> >
> > That would need to be dropped regardless because it's user-triggered (s=
adly).
>=20
> Well the current v5 of the series uses a non-userspace visible canary-
> it seems like there'd still be value in that if we were to keep the
> annotations in potentially unreliable spots. Although perhaps that
> test failure you noticed [1] is a good counter-argument, since it
> shows a known case where a current flow does multiple writes to the
> memory_fault member.

The problem is that anything but a WARN will go unnoticed, and we can't hav=
e any
WARNs that are user-triggerable, at least not in upstream.  Internally, we =
can
and probably should add a canary, and an aggressive one at that, but I can'=
t think
of a sane way to add a canary in upstream while avoiding the known offender=
s. :-(

> [1] https://lore.kernel.org/all/202309141107.30863e9d-oliver.sang@intel.c=
om
>=20
> > Anyways, don't do anything just yet.
>=20
> :salutes:

LOL
