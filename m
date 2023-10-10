Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9057032C7E
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 22:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l0Mn+DtM"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3296b3f03e5so4181509f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 15:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696976527; x=1697581327; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJR3kzvdFAtjI4futU9HjQ8SFStLu7+FAsB2B+oCyxc=;
        b=l0Mn+DtML4EiE7IbNdrickBT0v8FNjSU5Zl1HoqLcopBcXNLaljDz8RQfTObos9NkY
         W1cmG+onD8zXrZJAm7VpfPuXy4T7o0DEukncEvq+xQEVuYIIl74015e3HyX/VNVv+C/z
         wmd//K+pZD//+p3rZERXhU5QdJ84llLiVLlhRmw7LnHynmrtNBms5rBinN2I+nEMCBNO
         GwhelKBvcjoGAwp94jPe5EXCXOPAszFm3ZAEdjfbSuvcwRU5Lg+RZDWbi6k1SFrFi3EI
         CBSEtzMSYrO56fjhqjqmdnbt06/wLj1R58ixG815jx4ulOxKfHA0cv02llha6rKrSB43
         8MtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696976527; x=1697581327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJR3kzvdFAtjI4futU9HjQ8SFStLu7+FAsB2B+oCyxc=;
        b=nHzTMiUyrUovjXXC6+V4/tmKsW6Idpg00IrP7T0mw6BSI5+73AuZePTtYy90ib/t67
         wKzlrTjHSPvGyDKjg0dmP4BzuLmbmT/uBp/LynRJS1EWiO7kD+S+Ua+ItADHTOv2CmDr
         c8bSWrpUrJuvKJ9uZoArjKbG2/7Hqx7ff199hHKQpfHGhv5dFDq4sXMzo12whOBKgjAQ
         kNj1HsXztI+p3VzM5qdUWzzLR2saiW+MYNMPm0vY3D/OLGA54/EpNfpFBKQ8ZHheryoH
         sf3OdNvMdIrY7luW/EA7qXRNUG9Bc7WENAFJhQo7dSLXIYu5twbO12XGg53ht2s9T10v
         d2pw==
X-Gm-Message-State: AOJu0YyJ7ZYJhivJmDDz0P2T0e4bgpBE5aWs0uWh1yjUcJK6gwYV0KYQ
	3gFfhZD07KqeIWjh4mnmSdi8LvXKEfVWjhJsKeOIAA==
X-Google-Smtp-Source: AGHT+IE6wUAcmy5tCDBI++Cod8BpbZvHkWf4nr2c4NaKC7jYGq++eFgXeJn8k5isETu4e/PYxkU5T6JY0G5SV14gtk0=
X-Received: by 2002:a5d:56d0:0:b0:31c:5c77:48ec with SMTP id
 m16-20020a5d56d0000000b0031c5c7748ecmr15648255wrw.62.1696976526640; Tue, 10
 Oct 2023 15:22:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
 <ZRyn0nPQpbVpz8ah@google.com> <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
 <ZR88w9W62qsZDro-@google.com>
In-Reply-To: <ZR88w9W62qsZDro-@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 10 Oct 2023 15:21:37 -0700
Message-ID: <CALzav=csPcd3f5CYc=6Fa4JnsYP8UTVeSex0-7LvUBnTDpHxLQ@mail.gmail.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 5, 2023 at 3:46=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Oct 05, 2023, Anish Moorthy wrote:
> > On Tue, Oct 3, 2023 at 4:46=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace =
could be
> > > "unreliable" is if something other than a memory_fault exit clobbered=
 the union,
> > > but didn't signal its KVM_EXIT_* reason.  And that would be an egregi=
ous bug that
> > > isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption =
would affect
> > > each and every other KVM_EXIT_* reason.
> >
> > Keep in mind the case where an "unreliable" annotation sets up a
> > KVM_EXIT_MEMORY_FAULT, KVM_RUN ends up continuing, then something
> > unrelated comes up and causes KVM_RUN to EFAULT. Although this at
> > least is a case of "outdated" information rather than blatant
> > corruption.
>
> Drat, I managed to forget about that.
>
> > IIRC the last time this came up we said that there's minimal harm in
> > userspace acting on the outdated info, but it seems like another good
> > argument for just restricting the annotations to paths we know are
> > reliable. What if the second EFAULT above is fatal (as I understand
> > all are today) and sets up subsequent KVM_RUNs to crash and burn
> > somehow? Seems like that'd be a safety issue.
>
> For your series, let's omit
>
>   KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page
>
> and just fill memory_fault for the page fault paths.  That will be easier=
 to
> document too since we can simply say that if the exit reason is KVM_EXIT_=
MEMORY_FAULT,
> then run->memory_fault is valid and fresh.

+1

And from a performance perspective, I don't think we care about
kvm_vcpu_read/write_guest_page(). Our (Google) KVM Demand Paging
implementation just sends any kvm_vcpu_read/write_guest_page()
requests through the netlink socket, which is just a poor man's
userfaultfd. So I think we'll be fine sending these callsites through
uffd instead of exiting out to userspace.

And with that out of the way, is there any reason to keep tying
KVM_EXIT_MEMORY_FAULT to -EFAULT? As mentioned in the patch at the top
of this thread, -EFAULT is just a hack to allow the emulator paths to
return out to userspace. But that's no longer necessary. I just find
it odd that some KVM_EXIT_* correspond with KVM_RUN returning an error
and others don't. The exit_reason is sufficient to tell userspace
what's going on and has a firm contract, unlike -EFAULT which anything
KVM calls into can return.

>
> Adding a flag or whatever to mark the data as trustworthy would be the al=
ternative,
> but that's effectively adding ABI that says "KVM is buggy, sorry".
>
> My dream of having KVM always return useful information for -EFAULT will =
have to
> wait for another day.
