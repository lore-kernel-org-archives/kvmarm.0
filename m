Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C91FBE8A
	for <kvmarm@lists.linux.dev>; Thu, 19 Jun 2025 01:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750297690; cv=none; b=vEjtsDA2IMD1h9T2uLg7N6rkI8JMcrU/tbFSLEDA4LKxuFqQovLAqaMe+obBPu45Q1jUwCCWJ0x9ifZrdI3IFQm0NEASMudsvi7P/1AULpfjUch4eePnQtawAskNmJSC5ZMamaoPKcVRufrbMupHUFAQ84p8nobO3/lYhTKoMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750297690; c=relaxed/simple;
	bh=81o6bescB9v3lhPMTrOg1UBMsSJ474FvjKsHJN3ltGw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t22I3YTCNuoDdoXtWeKjXTzTjDf2vPVsbNK0bbeRiejnOHUA4MKx0rO5EiFy8NlywPFpl0UucNZeb2caTJNKsW017aCXqSAM6KBPIQYbVIxulqc5Tc2uEbL+Md09GXC+nSCLucyQ7ZqjEoW1RvIKeemYPD9R60SgspWdYgBqWeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3qEbnIRS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3qEbnIRS"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d670ad35so193713a91.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 18:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750297688; x=1750902488; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iK4ZjkA8jkWCWhJSogXww/jXtNZjhSvpmcPS6ek9IU8=;
        b=3qEbnIRSSLqyNyt5paZWEieGwKRWDFxA6pfxICfDpt9PK8crIGsl68KixNPYb5MMYh
         iMTJf4mUEt52W2ToG4er99dkbTRQdtII2d6WF8VvZMh6JUO2bUZ+BFj0sFBVkcp/pULp
         LXY9FjVmwwMZIPt5Lh6XfZUpIKSj5qlbyKMXytWIdaS3fVsz6nQD0Sqqi9EZpOQI4jJ2
         tihwziqCW2PvTpaF4HYzzk+52kYH52GdVe/gix6jHv+opLqqxFyYJ4XlzQoAEWQG/PAq
         hqNIqlKoxxApqXTlaDGCeN/2jc0RfvoyHxLdGSNJ1ddl6WXG2j03Y5vUYRyeyY47AKK7
         /2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750297688; x=1750902488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iK4ZjkA8jkWCWhJSogXww/jXtNZjhSvpmcPS6ek9IU8=;
        b=hrIRfjzjy9H80gfOZuq5SlYiXZ+PmkJAmz7fgxM3ckacQaeLFzzmuS1IfCUdxnpjI8
         HcwVw83Ho/usltuRt1BuOYP8Zo03kBDQy+PEdQAeWTiRRYfFytWnOMaR3iAoIQle07wA
         9miu7riLcFHbwBfGk45DbwDvxzsgBRvD2KQgF9o9yPQJ++JcaeaDoz4pog/npkBsvtia
         iAZx6NE+PYmjKXFcDmCpYrwjXmhV+ZxrZsh4HkEYQUo9wOZbEQ51VOEvqv2Ic0mvVRAw
         aRD0MJCkNACo3AnpGfVIBHBRPfmfM9c3iUDW0T9wciTakxNSy7e/Ut4ZWvQDbvBdcA8c
         FXVg==
X-Forwarded-Encrypted: i=1; AJvYcCVo7pu2VKaXhYXA3j7zyhFLO5qMoIgERFiL4pX5fxTiBbJ/jU0uvX0k2MLiGhfTd8TjpOmgbfE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxgVNCcTeUk0C++Tb0b1qrxIoTyvywl9XVdaj+2poztCSPWd4yf
	Fv7gAG6bfjz4wJTWGrMI9IVnELvOA3oPgsCFsDz1q/FHrBjYF8wdKipkPuokUqtuUBRGqSHsbBj
	Ht/oQvA==
X-Google-Smtp-Source: AGHT+IEE4ydtFaw4e1z+EoMImiqkpcubj+zuBIUlhh64xauiektJcBJlVfVom5ZkidUtziKce7G2cJ/ISuk=
X-Received: from pjm13.prod.google.com ([2002:a17:90b:2fcd:b0:312:15b:e5d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c86:b0:311:b3e7:fb31
 with SMTP id 98e67ed59e1d1-313f1b2bbdbmr33782851a91.0.1750297688027; Wed, 18
 Jun 2025 18:48:08 -0700 (PDT)
Date: Wed, 18 Jun 2025 18:48:06 -0700
In-Reply-To: <3fb0e82b-f4ef-402d-a33c-0b12e8aa990c@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com> <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch>
 <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com> <CA+EHjTxvqDr1tavpx7d9OyC2VfUqAko864zH9Qn5+B0UQiM93g@mail.gmail.com>
 <701c8716-dd69-4bf6-9d36-4f8847f96e18@redhat.com> <aFIK9l6H7qOG0HYB@google.com>
 <3fb0e82b-f4ef-402d-a33c-0b12e8aa990c@redhat.com>
Message-ID: <aFNsVreb41robgbv@google.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Fuad Tabba <tabba@google.com>, Ira Weiny <ira.weiny@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, David Hildenbrand wrote:
> On 18.06.25 02:40, Sean Christopherson wrote:
> > On Mon, Jun 16, 2025, David Hildenbrand wrote:
> > > On 16.06.25 16:16, Fuad Tabba wrote:
> > > > On Mon, 16 Jun 2025 at 15:03, David Hildenbrand <david@redhat.com> wrote:
> > > > > That something is mappable into $whatever is not the right
> > > > > way to look at this IMHO.
> > 
> > Why not?  Honest question.  USER_MAPPABLE is very literal, but I think it's the
> > right granularity.  E.g. we _could_ support read()/write()/etc, but it's not
> > clear to me that we need/want to.  And so why bundle those under SHARED, or any
> > other one-size-fits-all flag?
> 
> Let's take a step back. There are various ways to look at this:
> 
> 1) Indicate support for guest_memfd operations:
> 
> "GUEST_MEMFD_FLAG_MMAP": we support the mmap() operation
> "GUEST_MEMFD_FLAG_WRITE": we support the write() operation
> "GUEST_MEMFD_FLAG_READ": we support the read() operation
> ...
> "GUEST_MEMFD_FLAG_UFFD": we support userfaultfd operations
> 
> 
> Absolutely fine with me. In this series, we'd be advertising
> GUEST_MEMFD_FLAG_MMAP. Because we support the mmap operation.
>
> If the others are ever required remains to be seen [1].

Another advantage of granular flags that comes to mind: WRITE (and READ) could
be withdrawn after populating memory, e.g. to harden against unexpected accesses
once the VM has been initialized.

And FWIW, I'm pretty sure it's only MMAP that *needs* userspace to opt-in.  If it
weren't for the change in memslot behavior, i.e. to always look at the guest_memfd
fd and ignore the hva, then MMAP wouldn't need a userspace opt-in.  Though we
might *want* an opt-in, e.g. for hardening purposes.

> 2) Indicating the mmap mapping type (support for MMAP flags)
> 
> As you write below, one could indicate that we support "mmap(MAP_SHARED)" vs
> "mmap(MAP_PRIVATE)".
> 
> I don't think that's required for now, as MAP_SHARED is really the default
> that anything that supports mmap() supports. If someone ever needs
> MAP_PRIVATE (CoW) support they can add such a flag
> (GUEST_MEMFD_FLAG_MMAP_MAP_PRIVATE). I doubt we want that, but who knows.
> 
> As expressed elsewhere, the mmap mapping type was never what the "SHARED" in
> KVM_GMEM_SHARED_MEM implied.
> 
> 
> 3) *guest-memfd specific* memory access characteristics
> 
> "private (non-accessible, private, secure, protected, ...) vs.
> "non-private".
> 
> Traditionally, all was memory in guest-memfd was private, now we will make
> guest_memfd also support non-private memory. As this memory is
> "inaccessible" from a host point of view, any access to read/write it (fault
> it into user page tables, read(), write(), etc) will fail.

...

> > As I mentioned in the other thread with respect to sharing between other
> > entities, simply SHARED doesn't provide sufficient granularity.  HOST_SHAREABLE
> > gets us closer, but I still don't like that because it implies the memory is
> > 100% shareable, e.g. can be accessed just like normal memory.
> > 
> > And for non-CoCo x86 VMs, sharing with host userspace isn't even necessarily the
> > goal, i.e. "sharing" is a side effect of needing to allow mmap() so that KVM can
> > continue to function.
> 
> Does mmap() support imply "support for non-private" memory or does "support
> for non-private" imply mmap() support? :)

...

> > Ya, but that's more because guest_memfd only supports MAP_SHARED, versus KVM
> > really wanting to truly share the memory with the entire system.
> > Of course, that's also an argument to some extent against USER_MAPPABLE, because
> > that name assumes we'll never want to support MAP_PRIVATE.  But letting userspace
> > MAP_PRIVATE guest_memfd would completely defeat the purpose of guest_memfd, so
> > unless I'm forgetting a wrinkle with MAP_PRIVATE vs. MAP_SHARED, that's an
> > assumption I'm a-ok making.
> 
> So, first important question, are we okay with adding:
> 
> "GUEST_MEMFD_FLAG_MMAP": we support the mmap() operation

Probably stating the obvious, but yes, I am.

> > If we are really dead set on having SHARED in the name, it could be
> > GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
> > to me that's _too_ specific and again somewhat confusing given the unfortunate
> > private vs. shared usage in CoCo-land.  And just playing the odds, I'm fine taking
> > a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or whatever,
> > because I think that is comically unlikely to happen.
> 
> I think in addition to GUEST_MEMFD_FLAG_MMAP we want something to express
> "this is not your old guest_memfd that only supports private memory". And
> that's what I am struggling with.
> 
> Now, if you argue "support for mmap() implies support for non-private
> memory", I'm probably okay for that.

Yep, that essentially what I'm advocating.

> I could envision support for non-private memory even without mmap() support,
> how useful that might be, I don't know.

It _could_ be very useful, e.g. to have very strong confidence that nothing in
userspace can accidentally clobber guest memory.  The problem is that reality gets
in the way, and so unfortunately I don't see this idea ever coming to fruition
(though I really, really like the concept).

> But that's why I was arguing that we mmap() is just one way to consume
> non-private memory.

I agree that mmap() is just one way to interact with non-private memory, but
in addition to wanting to avoid having to name "non-private memory", I also want
to avoid bundling all of those ways together.  I.e. I want to start with the bare
minimum and add functionality if/when it's needed.  Partly so that we don't have
to spend much time thinking about the unsupported methods, but mostly because
adding functionality is almost always way easier than taking it away.
