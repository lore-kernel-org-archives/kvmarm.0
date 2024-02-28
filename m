Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7273508
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709127262; cv=none; b=Fr4h3BpW3WSBRlO3ef25ygCk2V8wE3mXGlc2ZvRYxmmlTeHB3662Ywszetjm+CPYy+yvOX/IfWB3NB80FkUOY2IgXuQeK/CAByVR32doI3v1ztpxCK1SaUtUR2ePpdjkw+Xl9FHtc/fokpc+L/mVozdAzNC4NhczuJ8RHiVmbcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709127262; c=relaxed/simple;
	bh=ozl/hlU5zrJ7KnWlGiIKpovQ2nRt/k20Uwxhv7QksG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bAGhsNAAT0qp+Ah8sQfSmaR0q9rqWLzHeGHolJjxruCBWxG/x+QyulRDmO4E8rJVXklL4zn//0u8+2n5l/4W/+JSX86Kz1wf4oRpPIKEtuhgf2tBhSuiBH/em1Cp3CAfS8DaJMTs5WLwu6C2magMPcgTn9+7ZeqRZqW4SIiT9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sAxZDwVx; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sAxZDwVx"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-512e39226efso7168581e87.0
        for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 05:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709127259; x=1709732059; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b+Bseu6VndN9Do7y+rDI8MGihp4rvxQrjFB6082I5iE=;
        b=sAxZDwVxphK9qGMKH5vOPIUdHdiRojKnkiAt5G0xJh4TTOOP1vQ9DptIkg0ma3WxNo
         bnwZPumY5taXSK86aynw/IvcSNIBbzEiq88UyFHYnUqt9RqAo4G7nFOIegsosh/guINY
         puaEtZ3C3ISLEeI527PkqEqT8qkKJ9QsAckZ6iNzrHmMBJ3DauxwGzKmHrdoQERUZaSq
         F6t5N7IeT9PMmPtJXB7KPOoIe9CYEZAnUEC6n3inA3poI08qr+1czarH9J1l8Zai5+uX
         30POgroWIwo+PbnhGo6ThWQ2iDst0PkLpgrzlTbVnypPHHJlXVSg5B21Jn14h3f0mqyZ
         QJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709127259; x=1709732059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+Bseu6VndN9Do7y+rDI8MGihp4rvxQrjFB6082I5iE=;
        b=OFRtsLzO9WRADtwxqTGwJ9GDa6O+BWhIQPe7a5Iz6r4vfsLOvGHqjjTJW6FUCtnemA
         ODfiqn+uiUDn0LL4CdUdzvwTgmW2YPa3k0pgOR748WYCimekIYBwgSFFAfpgddaEpGc1
         u0rp8T706s2+2vBBF6MY2Vet1l/HUF2zecXCNOkWMupwDor70TbiBDIWK+n7Gjajkxc+
         iNSQt+F7ng5GsVb/QmRirB609HeBNDkrXRm0AEBSQrfplXyjGFRe04rCJ3+cjmzhenzB
         RfJO2kYHwOEwz6+z+SzyVX/GbiOirxRRQQRz4Cnpf8fi94KrukCnQuABMAiC2BUXRyux
         ksAA==
X-Forwarded-Encrypted: i=1; AJvYcCX+qEadGfLiYZYSTo0c9v0aAIdktTfLE1M2K5XbnNlHlJZpLF9uDPbyVqewcCoXIZJ2XNtWr1hocoSsX/flVj5cBA/dhh05
X-Gm-Message-State: AOJu0YwMpu9b09UNASOi4kDVT2vjuiW57Vg6d9Ruz1PQL0Z0YzP8o7wy
	w/mH1J3UEhG2ZTPJaUklFdhqrFEunSOa62bdh59jeO0Zr1C2KkiSSstydDEtJA==
X-Google-Smtp-Source: AGHT+IHx9YONxPQwfsNJ4nIYylqWhaR1HBz0xEBN39j+kSw5uXUNC/Qhzhc9E2hw/epJxMh2XsXTaQ==
X-Received: by 2002:a05:6512:3450:b0:513:150c:dca2 with SMTP id j16-20020a056512345000b00513150cdca2mr1981528lfr.37.1709127258676;
        Wed, 28 Feb 2024 05:34:18 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id if3-20020a0564025d8300b0056659364b0fsm1012216edb.51.2024.02.28.05.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 05:34:18 -0800 (PST)
Date: Wed, 28 Feb 2024 13:34:15 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <Zd82V1aY-ZDyaG8U@google.com>
References: <20240222161047.402609-1-tabba@google.com>
 <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
 <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>

On Wednesday 28 Feb 2024 at 14:00:50 (+0100), David Hildenbrand wrote:
> > > > To add a layer of paint to the shed, the usage of SIGBUS for
> > > > something that is really a permission access problem doesn't feel
> > > 
> > > SIGBUS stands for "BUS error (bad memory access)."
> > > 
> > > Which makes sense, if you try accessing something that can no longer be
> > > accessed. It's now inaccessible. Even if it is temporarily.
> > > 
> > > Just like a page with an MCE error. Swapin errors. Etc. You cannot access
> > > it.
> > > 
> > > It might be a permission problem on the pKVM side, but it's not the
> > > traditional "permission problem" as in mprotect() and friends. You cannot
> > > resolve that permission problem yourself. It's a higher entity that turned
> > > that memory inaccessible.
> > 
> > Well that's where I'm not sure to agree. Userspace can, in fact, get
> > back all of that memory by simply killing the protected VM. With the
> 
> Right, but that would likely "wipe" the pages so they can be made accessible
> again, right?

Yep, indeed.

> That's the whole point why we are handing the pages over to the "higher
> entity", and allow someone else (the VM) to turn them into a state where we
> can no longer read them.
> 
> (if you follow the other discussion, it would actually be nice if we could
> read them and would get encrypted content back, like s390x does; but that's
> a different discussion and I assume pretty much out of scope :) )

Interesting, I'll read up. On a side note, I'm also considering adding a
guest-facing hypervisor interface to let the guest decide to opt out of
the hypervisor wipe as discussed above. That would be useful for a guest
that is shutting itself down (which could be cooperating with the host
Linux) and that knows it has erased its secrets. That is in general
difficult to do for an OS, but a simple approach could be to poison all
its memory (or maybe encrypt it?) before opting out of that wipe.

The hypervisor wipe is done in hypervisor context (obviously), which is
non-preemptible, so avoiding wiping (or encrypting) loads of memory
there is highly desirable. Also pKVM doesn't have a linear map of all
memory for security reasons, so we need to map/unmap the pages one by
one, which sucks as much as it sounds.

But yes, we're digressing, that is all for later :)

> > approach suggested here, the guestmem pages are entirely accessible to
> > the host until they are attached to a running protected VM which
> > triggers the protection. It is very much userspace saying "I promise not
> > to touch these pages from now on" when it does that, in a way that I
> > personally find very comparable to the mprotect case. It is not some
> > other entity that pulls the carpet from under userspace's feet, it is
> > userspace being inconsistent with itself that causes the issue here, and
> > that's why SIGBUS feels kinda wrong as it tends to be used to report
> > external errors of some sort.
> 
> I recall that user space can also trigger SIGBUS when doing some
> mmap()+truncate() thingies, and probably a bunch more, that could be fixed
> up later.

Right, so that probably still falls into "there is no page" bucket
rather than the "there is a page that is already accounted against the
userspace process, but it doesn't have the permission to access it
bucket. But yes that's probably an infinite debate.

> I don't see a problem with SIUGBUS here, but I do understand your view. I
> consider the exact signal a minor detail, though.
> 
> > 
> > > > appropriate. Allocating memory via guestmem and donating that to a
> > > > protected guest is a way for userspace to voluntarily relinquish access
> > > > permissions to the memory it allocated. So a userspace process violating
> > > > that could, IMO, reasonably expect a SEGV instead of SIGBUS. By the
> > > > point that signal would be sent, the page would have been accounted
> > > > against that userspace process, so not sure the paging examples that
> > > > were discussed earlier are exactly comparable. To illustrate that
> > > > differently, given that pKVM and Gunyah use MMU-based protection, there
> > > > is nothing architecturally that prevents a guest from sharing a page
> > > > back with Linux as RO.
> > > 
> > > Sure, then allow page faults that allow for reads and give a signal on write
> > > faults.
> > > 
> > > In the scenario, it even makes more sense to not constantly require new
> > > mmap's from user space just to access a now-shared page.
> > > 
> > > > Note that we don't currently support this, so I
> > > > don't want to conflate this use case, but that hopefully makes it a
> > > > little more obvious that this is a "there is a page, but you don't
> > > > currently have the permission to access it" problem rather than "sorry
> > > > but we ran out of pages" problem.
> > > 
> > > We could user other signals, at least as the semantics are clear and it's
> > > documented. Maybe SIGSEGV would be warranted.
> > > 
> > > I consider that a minor detail, though.
> > > 
> > > Requiring mmap()/munmap() dances just to access a page that is now shared
> > > from user space sounds a bit suboptimal. But I don't know all the details of
> > > the user space implementation.
> > 
> > Agreed, if we could save having to mmap() each page that gets shared
> > back that would be a nice performance optimization.
> > 
> > > "mmap() the whole thing once and only access what you are supposed to
 (> > > access" sounds reasonable to me. If you don't play by the rules, you get a
> > > signal.
> > 
> > "... you get a signal, or maybe you don't". But yes I understand your
> > point, and as per the above there are real benefits to this approach so
> > why not.
> > 
> > What do we expect userspace to do when a page goes from shared back to
> > being guest-private, because e.g. the guest decides to unshare? Use
> > munmap() on that page? Or perhaps an madvise() call of some sort? Note
> > that this will be needed when starting a guest as well, as userspace
> > needs to copy the guest payload in the guestmem file prior to starting
> > the protected VM.
> 
> Let's assume we have the whole guest_memfd mapped exactly once in our
> process, a single VMA.
> 
> When setting up the VM, we'll write the payload and then fire up the VM.
> 
> That will (I assume) trigger some shared -> private conversion.
> 
> When we want to convert shared -> private in the kernel, we would first
> check if the page is currently mapped. If it is, we could try unmapping that
> page using an rmap walk.

I had not considered that. That would most certainly be slow, but a well
behaved userspace process shouldn't hit it so, that's probably not a
problem...

> Then, we'd make sure that there are really no other references and protect
> against concurrent mapping of the page. Now we can convert the page to
> private.

Right.

Alternatively, the shared->private conversion happens in the KVM vcpu
run loop, so we'd be in a good position to exit the VCPU_RUN ioctl with a
new exit reason saying "can't donate that page while it's shared" and
have userspace use MADVISE_DONTNEED or munmap, or whatever on the back
of that. But I tend to prefer the rmap option if it's workable as that
avoids adding new KVM userspace ABI.

> As we want to avoid the rmap walk, user space can be nice and simply
> MADV_DONTNEED the shared memory portions once it's done with it. For
> example, after writing the payload.

That makes sense to me.

Thanks,
Quentin
