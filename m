Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5C11D54B
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lHMcZqBM"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5788445ac04so864080a12.2
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 10:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698946651; x=1699551451; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uN1ssLkZHjDTrGZRWby6miGmTEsoKqfVN3YbqYw1LLA=;
        b=lHMcZqBMylOF5FJTlERs60/dfyfkW/gsoEvqM6HOx3dspDZbpY9mkm8zqGKoCOUNdo
         +zSLEBohdPzDyCWKEahn6tUFIP0KTedPbYS7cNiVD/rKMpjHzQgmPD9kleaQx6P0nRCQ
         JiaGJianHlT0sDRo6K/0l8YajkgPmXuMS8SRmMLaLPhd1ufNnoetoeKRgGrtqM/aLmyV
         gqctGyp2R3aUO/cwLt+2ibLgA5AMQIdnOYbwk4Fy+AhhaHnVrpV4TDjc+Gj4tvMZtjgS
         tlKlodH7wRLqWQkqcj3NPnjbb4RUqNuAthG5wSHsdG/58eDxIQoDmLH9Or7W9jQesMBC
         4S+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698946651; x=1699551451;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uN1ssLkZHjDTrGZRWby6miGmTEsoKqfVN3YbqYw1LLA=;
        b=B3HxQ5tyr7An8zn6pQBvk5XXUUK7Ag3xEj46Avb6rfR6sMKmgfBV83qAeq0jWJAokp
         ZnaXwWcr51hL/WNcu2WtoQmcjm2zF8rnInGtJOCy9ed6dvYguQAbI6KT8ZtK/QO7qPA6
         3SEd1Wmc0yfpAoWY8NZ5nt+sEBKs1w/sP91dnD263nsGZ1RlQSqzEPf3yj1VfPaVARDX
         aopAvmJbWfJH/vjT/s4yD539ODGBMepsqxJdhEpXB4UkyXgLWo0rmRaqqBR8onSP8Au9
         CUalPLfunVZER+BJwfJJn+OhiPykJEG0cX0p4DDMPP98YGbB4CjXK278U0/mQx+Yj7Li
         xahQ==
X-Gm-Message-State: AOJu0YzSa5tw1z3T/6q6vrFlW1lQ75pL9f/tl8o1LFKKgZd29kDYMySS
	R53X7E1sw4YihqrMbSoWGQZCRLgppxQ=
X-Google-Smtp-Source: AGHT+IHO2BmoMwEG0Z4p7dUErvps7DbkHqeEBbdPqNa8vmvQCAafmC1+rihoFOkAVlqXxxzUlxPm8WkwUZU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:25d2:b0:1cc:2ffe:5a27 with SMTP id
 jc18-20020a17090325d200b001cc2ffe5a27mr287356plb.9.1698946650780; Thu, 02 Nov
 2023 10:37:30 -0700 (PDT)
Date: Thu, 2 Nov 2023 10:37:29 -0700
In-Reply-To: <CALzav=eaVc5rzmHwnQr7aotyTKi9Agdte7NAL0NvBeE+f6zYoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <ZUFGRyQEuWj4RJS0@google.com> <ZUFzZf-YmCRYP6qo@google.com>
 <CALzav=d9eXZfK=op7A=UftbpuPpUbxqV6CmkqqxxBNuNsUU4nw@mail.gmail.com>
 <6642c379-1023-4716-904f-4bbf076744c2@redhat.com> <ZUPIXt1XzZrriswG@google.com>
 <CALzav=eaVc5rzmHwnQr7aotyTKi9Agdte7NAL0NvBeE+f6zYoA@mail.gmail.com>
Message-ID: <ZUPeWTdbMhvMO4QL@google.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 02, 2023, David Matlack wrote:
> On Thu, Nov 2, 2023 at 9:03=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Thu, Nov 02, 2023, Paolo Bonzini wrote:
> > > On 10/31/23 23:39, David Matlack wrote:
> > > > > > Maybe can you sketch out how you see this proposal being extens=
ible to
> > > > > > using guest_memfd for shared mappings?
> > > > > For in-place conversions, e.g. pKVM, no additional guest_memfd is=
 needed.  What's
> > > > > missing there is the ability to (safely) mmap() guest_memfd, e.g.=
 KVM needs to
> > > > > ensure there are no outstanding references when converting back t=
o private.
> > > > >
> > > > > For TDX/SNP, assuming we don't find a performant and robust way t=
o do in-place
> > > > > conversions, a second fd+offset pair would be needed.
> > > > Is there a way to support non-in-place conversions within a single =
guest_memfd?
> > >
> > > For TDX/SNP, you could have a hook from KVM_SET_MEMORY_ATTRIBUTES to =
guest
> > > memory.  The hook would invalidate now-private parts if they have a V=
MA,
> > > causing a SIGSEGV/EFAULT if the host touches them.
> > >
> > > It would forbid mappings from multiple gfns to a single offset of the
> > > guest_memfd, because then the shared vs. private attribute would be t=
ied to
> > > the offset.  This should not be a problem; for example, in the case o=
f SNP,
> > > the RMP already requires a single mapping from host physical address =
to
> > > guest physical address.
> >
> > I don't see how this can work.  It's not a M:1 scenario (where M is mul=
tiple gfns),
> > it's a 1:N scenario (wheren N is multiple offsets).  The *gfn* doesn't =
change on
> > a conversion, what needs to change to do non-in-place conversion is the=
 pfn, which
> > is effectively the guest_memfd+offset pair.
> >
> > So yes, we *could* support non-in-place conversions within a single gue=
st_memfd,
> > but it would require a second offset,
>=20
> Why can't KVM free the existing page at guest_memfd+offset and
> allocate a new one when doing non-in-place conversions?

Oh, I see what you're suggesting.  Eww.

It's certainly possible, but it would largely defeat the purpose of why we =
are
adding guest_memfd in the first place.

For TDX and SNP, the goal is to provide a simple, robust mechanism for isol=
ating
guest private memory so that it's all but impossible for the host to access=
 private
memory.  As things stand, memory for a given guest_memfd is either private =
or shared
(assuming we support a second guest_memfd per memslot).  I.e. there's no ne=
ed to
track whether a given page/folio in the guest_memfd is private vs. shared.

We could use memory attributes, but that further complicates things when in=
trahost
migration (and potentially other multi-user scenarios) comes along, i.e. wh=
en KVM
supports linking multiple guest_memfd files to a single inode.  We'd have t=
o ensure
that all "struct kvm" instances have identical PRIVATE attributes for a giv=
en
*offset* in the inode.  I'm not even sure how feasible that is for intrahos=
t
migration, and that's the *easy* case, because IIRC it's already a hard req=
uirement
that the source and destination have identical gnf=3D>guest_memfd bindings,=
 i.e. KVM
can somewhat easily reason about gfn attributes.

But even then, that only helps with the actual migration of the VM, e.g. we=
'd still
have to figure out how to deal with .mmap() and other shared vs. private ac=
tions
when linking a new guest_memfd file against an existing inode.

I haven't seen the pKVM patches for supporting .mmap(), so maybe this is al=
ready
a solved problem, but I'd honestly be quite surprised if it all works corre=
ctly
if/when KVM supports multiple files per inode.

And I don't see what value non-in-place conversions would add.  The value a=
dded
by in-place conversions, aside from the obvious preservation of data, which=
 isn't
relevant to TDX/SNP, is that it doesn't require freeing and reallocating me=
mory
to avoid double-allocating for private vs. shared.  That's especialy quite =
nice
when hugepages are being used because reconstituing a hugepage "only" requi=
res
zapping SPTEs.

But if KVM is freeing the private page, it's the same as punching a hole, p=
robably
quite literally, when mapping the gfn as shared.  In every way I can think =
of, it's
worse.  E.g. it's more complex for KVM, and the PUNCH_HOLE =3D> allocation =
operations
must be serialized.

Regarding double-allocating, I really, really think we should solve that in=
 the
guest.  I.e. teach Linux-as-a-guest to aggressively convert at 2MiB granula=
rity
and avoid 4KiB conversions.  4KiB conversions aren't just a memory utilizat=
ion
problem, they're also a performance problem, e.g. shatters hugepages (which=
 KVM
doesn't yet support recovering) and increases TLB pressure for both stage-1=
 and
stage-2 mappings.
