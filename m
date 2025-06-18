Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157D5475E
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 00:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750207226; cv=none; b=DOgZ6mfI6kirGrl6bG+HdxHcR3TMcvVesu2NMMoWjp5WEmY3I+sMYal4lOKyrjZZWAiZLSXN8YNazL0+POnhIDiS/ME2hHTZVVQLQSH0e97ti8l6B8cWFzslowgOP7sMfz6/COCo6ggINC1w4Q1jfLJ+RviHg140J9eznMnfvu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750207226; c=relaxed/simple;
	bh=Yvp8SNdsJcGrrxssUzVqkAxiC5tM/QgGNkfM+x9d4NA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aBWc5rTUliWeaPfwVtX8kL5b/24eD2W2iVatgoRoD7fSnfWsD5RXGj7J10oOg3fMp3xG8mLGaTqf9xOd82tdXtoXt/3lUfkZ2hy/v4Guks42SwvgGwTvpxJRiJuVxphfakrNe1JJW9bauGSx+2q4Immz+3Yny+RTNtmYRVuLnTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OlQhYu4s; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OlQhYu4s"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747cebffd4eso4922234b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 17:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750207224; x=1750812024; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k/9aJlHm+goEi0z8rczKBwE3W8+faYM+8dllr+qUaic=;
        b=OlQhYu4s9WB/hzQe9vLwOqBsUMi71Ll+uXtLSt7Wlw6XrXQ45nU2PgLZXYmyrQlvBq
         AzhmqQ3kGID6VyIDIaUVEb+omHQQcXIiIZaHFfl6eHyuq1bvrpx5RlMrezLH5ujzP+eO
         70bRwNZVvejPS0LQGjtNqgXn24HkbwyFrwEq642YpJeeAKgYEVKcTH9ET9pek4xzZv5l
         lt5p8ZEJWjAU9ON33AL8D7Tk+hEWAtu+q0R2toJWMdpNcVahr8TATg7bDKzf1Md6s9pO
         E4QWmir7qj14mc5V0fFKa9lDmp3dHodqcr2ttF5m1FjE2fgAk0cfv38LMSkXZcQz8OSI
         T11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750207224; x=1750812024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/9aJlHm+goEi0z8rczKBwE3W8+faYM+8dllr+qUaic=;
        b=uFngNJfrwWc2IrFwDgRFzVKtrQrH3KhA0GQ5mLpPDt/GWRMNPHJsPJSsULMpRrcoz4
         fycWd0LBBc7+nOv0WSmpvOmjVVjBqB0gBkg2FTp6iRfDLQ1PJlmxAnZA4c4DOKon+G5F
         AS4XzflFk6KFui1+JG1xZuSTY1Cw4hQeGk2nY5u672V0qJnbQgoZNCc/EejuRg6TNsrj
         xNL2JKweVjjaJVq/u3D74Co2lRRlahpKx5zEE26xdmxWPNBXuRpzUjJtygRPX+5pTJtl
         l2CULSRmUtgstKkbXfS8x4Px87Ope3FixHA8+Hbkz3dluVtBywrD+bTfnH4wPkrh3SzP
         yfbA==
X-Forwarded-Encrypted: i=1; AJvYcCXTD6XgpilxXhei+0fNdReAcfMjLsDgydKFhaY8Dn79g+IFETUfSuHFrZnlZ0D//WSNw11lfbw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBPxu9vkIkP3lWOOf+mBrtciYkyLzWMstEH514CCXh2HclV3/3
	PdHmvwUIZuQsz02YeVIh3y0dho04UhydY13MCAH/1fROsrXaz551vuIGSNoi5FxeyYzmFG/rWtA
	gDTwEYA==
X-Google-Smtp-Source: AGHT+IFnYwYFUetnQyZQ6TOSbasVaExJ476XGu1ioWQ0wajRmFxtx38py86YH2tJpmtJ5k1m1wGBTN+0spM=
X-Received: from pfbch3.prod.google.com ([2002:a05:6a00:2883:b0:746:22b3:4c0d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a19:b0:746:1e35:3307
 with SMTP id d2e1a72fcca58-7489cfd5ee0mr20211902b3a.14.1750207224147; Tue, 17
 Jun 2025 17:40:24 -0700 (PDT)
Date: Tue, 17 Jun 2025 17:40:22 -0700
In-Reply-To: <701c8716-dd69-4bf6-9d36-4f8847f96e18@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com> <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch>
 <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com> <CA+EHjTxvqDr1tavpx7d9OyC2VfUqAko864zH9Qn5+B0UQiM93g@mail.gmail.com>
 <701c8716-dd69-4bf6-9d36-4f8847f96e18@redhat.com>
Message-ID: <aFIK9l6H7qOG0HYB@google.com>
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

On Mon, Jun 16, 2025, David Hildenbrand wrote:
> On 16.06.25 16:16, Fuad Tabba wrote:
> > On Mon, 16 Jun 2025 at 15:03, David Hildenbrand <david@redhat.com> wrote:
> > > > > IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
> > > > > weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
> > > > > novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
> > > > > is to share memory, but that's a _use case_, not the property of guest_memfd that
> > > > > is being controlled by userspace.
> > > > > 
> > > > > And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
> > > > > memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
> > > > > instance is the _only_ entry point to the memslot.
> > > > > 
> > > > > So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
> > > > 
> > > > If we are going to change this; FLAG_MAPPABLE is not clear to me either.
> > > > The guest can map private memory, right?  I see your point about shared
> > > > being overloaded with file shared but it would not be the first time a
> > > > term is overloaded.  kvm_slot_has_gmem() does makes a lot of sense.
> > > > 
> > > > If it is going to change; how about GUEST_MEMFD_FLAG_USER_MAPPABLE?
> > > 
> > > If "shared" is not good enough terminology ...
> > > 
> > > ... can we please just find a way to name what this "non-private" memory
> > > is called?

guest_memfd?  Not trying to be cheeky, I genuinely don't understand the need
to come up with a different name.  Before CoCo came along, I can't think of a
single time where we felt the need to describe guest memory.  There have been
*many* instances of referring to the underlying backing store (e.g. HugeTLB vs.
THP), and many instances where we've needed to talk about the types of mappings
for guest memory, but I can't think of any cases where describing the state of
guest memory itself was ever necessary or even useful.
 
> > > That something is mappable into $whatever is not the right
> > > way to look at this IMHO.

Why not?  Honest question.  USER_MAPPABLE is very literal, but I think it's the
right granularity.  E.g. we _could_ support read()/write()/etc, but it's not
clear to me that we need/want to.  And so why bundle those under SHARED, or any
other one-size-fits-all flag?

> > > As raised in the past, we can easily support read()/write()/etc to this
> > > non-private memory.
> > > 
> > > I'll note, the "non-private" memory in guest-memfd behaves just like ...
> > > the "shared" memory in shmem ... well, or like other memory in memfd.
> > > (which is based on mm/shmem.c).
> > > 
> > > "Private" is also not the best way to describe the "protected\encrypted"
> > > memory, but that ship has sailed with KVM_MEMORY_ATTRIBUTE_PRIVATE.

Heh, I would argue that ship sailed when TDX called the PTE flag the Shared bit :-)

But yeah, in hindsight, maybe not the greatest name.

> > > I'll further note that in the doc of KVM_SET_USER_MEMORY_REGION2 we talk
> > > about "private" vs "shared" memory ... so that would have to be improved
> > > as well.
> > 
> > To add to what David just wrote, V1 of this series used the term
> > "mappable" [1].  After a few discussions, I thought the consensus was
> > that "shared" was a more accurate description --- i.e., mappability
> > was a side effect of it being shared with the host.

As I mentioned in the other thread with respect to sharing between other
entities, simply SHARED doesn't provide sufficient granularity.  HOST_SHAREABLE
gets us closer, but I still don't like that because it implies the memory is
100% shareable, e.g. can be accessed just like normal memory.

And for non-CoCo x86 VMs, sharing with host userspace isn't even necessarily the
goal, i.e. "sharing" is a side effect of needing to allow mmap() so that KVM can
continue to function.

> > One could argue that non-CoCo VMs have no concept of "shared" vs
> > "private".

I am that one :-)

> A different way of looking at it is, non-CoCo VMs have
> > their state as shared by default.

Eh, there has to be another state for there to be a default.  

> All memory of these VMs behaves similar to other memory-based shared memory
> backends (memfd, shmem) in the system, yes. You can map it into multiple
> processes and use it like shmem/memfd.

Ya, but that's more because guest_memfd only supports MAP_SHARED, versus KVM
really wanting to truly share the memory with the entire system.

Of course, that's also an argument to some extent against USER_MAPPABLE, because
that name assumes we'll never want to support MAP_PRIVATE.  But letting userspace
MAP_PRIVATE guest_memfd would completely defeat the purpose of guest_memfd, so
unless I'm forgetting a wrinkle with MAP_PRIVATE vs. MAP_SHARED, that's an
assumption I'm a-ok making.

If we are really dead set on having SHARED in the name, it could be
GUEST_MEMFD_FLAG_USER_MAPPABLE_SHARED or GUEST_MEMFD_FLAG_USER_MAP_SHARED?  But
to me that's _too_ specific and again somewhat confusing given the unfortunate
private vs. shared usage in CoCo-land.  And just playing the odds, I'm fine taking
a risk of ending up with GUEST_MEMFD_FLAG_USER_MAPPABLE_PRIVATE or whatever,
because I think that is comically unlikely to happen.

> I'm still thinking about another way to call non-private memory ... no
> success so far. "ordinary" or "generic" is .... not better.

As above, I don't have the same sense of urgency regarding finding a name for
guest_memfd.
