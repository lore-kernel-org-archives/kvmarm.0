Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACB1470438
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786547824; cv=none; b=l4xAuG8sH7N0Q2bgulTugnURFnG2dGrVvXLEfsppnh2nqh23xIpIROw2ofpasDZyBetXfMR3XIalAB7//79z6KbrzEULLE+KPjtFwwCljGNd5LXFQSNGXwxjyLA1hl8R1oWobRMD8KN1cQZl1lHe0eAZqsteIFmNVNGMpwHsFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786547824; c=relaxed/simple;
	bh=J01m2VjqnZE9DK85EfK7dUjiX+YGBCOKhqiUW+HEEmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nm2iA8pIs6Kd7blm4uVUDNwDQOBIy6HropnX8pTtlYYT8XyCJJNUKVuvndFzQERva6fu+rXrWypSYoVIyIOJAqW32jPmS5aE5t1KbF1a55tr58OX0SQt/CEHkHbti0uUDoS5XHmwwumgSEAQNprg/MUt2WQVqx0ripDYlSFmEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wn0GmY9r; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wn0GmY9r"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84859a64079so1425807b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 08:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786547821; x=1787152621; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=97wksvVZ+thl5LcpXUGbBxNzodsfrcBWwlOTdvF+br0=;
        b=Wn0GmY9rT9jaCMW5B6+Psyj+e4z7Ct8+oMx5cUM6dYjE7roU7KvqXxjf3daxsuvHuD
         7p/liWXcvGlCS9RdRTQ3zq3EUzUXeehqdHyxnvWeZKKgU+zGw2MjPUT42TXPOp5wZB54
         Tf/a3DOzVgjXTiTH9YyHSPKWRBxRo9WT2HPu55BK87KN6uVid2rUUl9/tU1KwPK9puwa
         1o5Vrp8fLzHhAL529+k/XMQL+jo5mF6X1SFGtLyYlSw+PwPQglyaDDq1nMBCtHT/jg3F
         yA3bNt5bvhBcVNIntA+VO3yfr9XR/eCUV2Km6b5LxnyP7VAoUXcpglRHYic6L/+1d/an
         ERtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786547821; x=1787152621;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=97wksvVZ+thl5LcpXUGbBxNzodsfrcBWwlOTdvF+br0=;
        b=YQrHobwqKV3QIvIjDaKiXVqdsWWIPvxcG5t79t84tDHezhiHRCJTsox7OOMNUxle0r
         6x1mrp3FUUuaRaRoOYQdraq5z3i6VttLozMpJhZie6a6tgOC6MPigFuL3gyA4Soqnudq
         cMS7AzJqv3kHTopffg3GYlPHYZepMhHZ8rpQ3sSIHSrYxnsDNqh48P/aXbJoKukR/zFV
         sPCS1/rgpdOjStjWwrck473TfzDqBViBE+0JS8SLddcso+zmGx95VfObH/HX1fu20Yt1
         1SNXcevmT0hGCZC5NDjmCZTuV5bbv0mFAaYtqLzLBhdsrBDlM84G1j1VMEZ2BB6bYQyX
         O3sQ==
X-Forwarded-Encrypted: i=1; AHgh+RougYE21Pvs9mzrnpuYvm+TW2rv0JgWZ6nyQsEbvbEg5Ki0uccbaAng8955ObIJUlH55VNQvw8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQnNOMbQ6JBgrqL1/DDo71dXzHg2nAcrOwOm3nOkS7b7YgkLLe
	NBp4d2O+5X3DbUFF+1DuuX1OruwtTacCJPRGqibup/8Y7YAtfEJRTr+jOGhvKP9rHv1uTsfowv+
	5/RP49Q==
X-Received: from pfbcv13.prod.google.com ([2002:a05:6a00:44cd:b0:847:7f5d:6b90])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4fc5:b0:845:4cb5:2343
 with SMTP id d2e1a72fcca58-84fb551821bmr6172462b3a.19.1786547821109; Wed, 12
 Aug 2026 08:17:01 -0700 (PDT)
Date: Wed, 12 Aug 2026 08:17:00 -0700
In-Reply-To: <2vxzik5f311e.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org> <anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
Message-ID: <anyObKiZIhfok5mk@google.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Sean Christopherson <seanjc@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 12, 2026, Pratyush Yadav wrote:
> On Tue, Aug 11 2026, Sean Christopherson wrote:
> 
> > On Tue, Aug 11, 2026, Pratyush Yadav wrote:
> >> On Mon, Aug 10 2026, Sean Christopherson wrote:
> >> 
> >> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
> >> >> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
> >> >> to serialize and deserialize VM state across kexec live updates.
> >> >> 
> >> >> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
> >> >> of VM preservation.
> >> >
> >> > Why?
> >> >
> >> >> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
> >> >> kvm_create_vm_file() and use an atomically incremented ID for the internal
> >> >> fdname, as the final fdname assigned by userspace is not yet known during
> >> >> retrieval. As this fdname is only used in debugfs infra, This will not break
> >> >> any UAPI.
> >> >> 
> >> >> This infrastructure establishes the foundation for preserving guest_memfd
> >> >> instances across live updates, and can be expanded in the future to
> >> >> preserve additional VM state.
> >> >
> >> > Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
> >> > guest_memfd should be the _last_ thing we support, not the first.  As evidenced
> >> > by the last two decades, it's very doable to have KVM VMs without guest_memfd,
> >> > but it's rather hard to have VMs without vCPUs.
> >> 
> >> You _can_ preserve vCPUs today using KVM_{GET,SET}_REGS, they just won't
> >> run in the background during the reboot.
> >
> > What about x86 CoCo VMs?  Which are quite literally _the_ reason guest_memfd was
> > created in the first place.  
> 
> I don't know much about the history but I thought these days guest_memfd
> is used for more than just encrypted memory. I have seen talk of it
> being used for non-confidential VMs. For example these patches [0][1][2].

It's getting there, but it's all still very nascent.

> The CoCo parts can follow, but IIUC guest_memfd is being used to back
> guest memory on non-CoCo VMs too.

Not using upstream code, though there are most definitely folks using guest_memfd
in production with out-of-tree patches.

But that's all beside the point.  What I'm saying is that SNP and TDX *must* use
guest_memfd, whereas guest_memfd is optional for all other VM types.  And so adding
LUO support for guest_memfd without even sketching out a plan for CoCo VMs feels
backwards.

I'm not necessarily opposed to gradual guest_memfd support, but there needs to be
a clear plan of how all of this is going to fit together.  It doesn't need to be
perfect, and I'm sure we'll make mistakes along the way, but I want to at least
try not to paint ourselves into a corner, especially with respect to the ABI.

> >> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
> >> > is going to be in knowing what to save/restore, and how, which is much more about
> >> > KVM than it is about liveupdate.
> >> 
> >> I think it is fine if you want to take these changes through the KVM
> >> tree, but I would like live update maintainers to be listed as reviewers
> >> at least.
> >
> > Why not simply add a file pattern match to the LIVE UPDATE entry?
> >
> > diff --git MAINTAINERS MAINTAINERS
> > index 8014b9f8253e..2eb57b22c37f 100644
> > --- MAINTAINERS
> > +++ MAINTAINERS
> > @@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
> >  F:     include/uapi/linux/liveupdate.h
> >  F:     kernel/liveupdate/
> >  F:     lib/tests/liveupdate.c
> > -F:     mm/memfd_luo.c
> >  F:     tools/testing/selftests/liveupdate/
> > +N:     [^a-z]luo
> >  
> >  LLC (802.2)
> >  L:     netdev@vger.kernel.org
> 
> This would list us as maintainers of kvm_luo.c and the tree as liveupdate.git, 

It would list both "LIVE UPDATE" and "KERNEL VIRTUAL MACHINE (KVM)", as KVM would
still cover the files via "F:	virt/kvm/*".  And my read of MAINTAINERS is that
N: and K: entries are "secondary" if the files/scope is covered by an F: entry.

E.g. arch/x86/kvm/vmx/tdx.c is covered by "KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
via "F:	arch/x86/kvm/*/", and also by "X86 TRUST DOMAIN EXTENSIONS (TDX)" via
"N:	tdx" (or maybe "K:	\b(tdx)"?  I haven't bothered to check which one
triggers).  And while I don't think there was ever any formal discussion, AFAIK
everyone reads the situation as KVM still being the primary maintainer/tree for
that code.

> both of which is something you're saying you _don't_ want.

No, what I don't want is a dedicated "KVM LIVE UPDATE" entry, because I think most
people would read "F:     virt/kvm/kvm_luo.c" and "F:     virt/kvm/guest_memfd_luo.c"
as being more precise than KVM's "F:   virt/kvm/*" and thus would read things as
"KVM LIVE UPDATE" being the primary maintainer.

In other words, I'm more than ok with LUO being looped in on KVM LUO changes and
having the authority to object to problematic changes, but I'm not ok with LUO
taking primary ownership of KVM code.

I realize there's more than a bit of nuance in my interpretation of N: and K:,
but again my experience with TDX is that so long as the maintainers are aligned
on expectations, it's a non-issue in practice.

> >> At the same time, I also keep being (pleasantly)
> >> surprised at preservation being relatively simple. For example, the code
> >> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
> >> of which is comments. The code of course has some limitations, but it is
> >> good enough for use in production.
> >> 
> >> For one, we care about ABI breakages and versioning. 
> >
> > Which is amusing to me because that implies KVM does not, and I would hazard to
> 
> No, it doesn't. What I'm saying is I care about changes to the _live
> update ABI_. Just like you probably care about changes to KVM ABI but
> not so much about BPF for example.
> 
> > guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
> > country mile (though I'm probably wildly underestimating the effective ABI surface
> > of filesystems).
> >
> >> The serialized state is a part of live update ABI and changes to it should be
> >> ACKed by us. 
> >
> > Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
> > see why liveupdate needs special treatment.
> 
> Ironically enough, you miss my point. I'm not talking about userspace
> ABI. We all know not to break that. I am talking about live update
> _serialization ABI_. See the stuff under include/linux/kho/abi. This
> series also adds things there.

No, I understand exactly what ABI you're talking about.

> This is ABI between kernels. It needs to be stable-ish so you can move
> from one kernel version to another. At the same time, unlike userspace
> ABI, it can change.

Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
ABI that needs to be backwards and forwards compatible between different kernels
in order to support both upgrade and rollback scenarios via live migration.

KVM also has immutable ABI between itself and guest kernels, including implicit
"ABI" in the form of not changing guest-visible behavior.

> Today we don't have any rules and let you change things freely as long as you
> do a version bump. But at a later point, the plan is to add some stability
> requirements to the ABI so you can actually upgrade the kernel across major
> versions.
> 
> So at least for ABI changes, there should be an explicit ACK from the
> live update group.

I don't entirely agree.  I get where you're coming from, and I 100% agree that
the more eyeballs on changes that may affect ABI, the better.

Where I have problems with the above is that it doesn't account for the nuances
of save/restore across different kernels.  The literal format of the serialized
data is the most obvious form of ABI, but it's absolutely possible to change ABI
without changing the data format.

E.g. say there's a flags field in some serialization structure, and flags X and Y
are mutually exclusive in current kernels.  If a future kernel relaxes that
restriction for whatever reason, then the effective ABI has been broken because
state created and saved on new kernels can't be restored on old kernels.  And
this is not a theoretical concern, KVM has run afoul of this a few times (though
thankfully very rarely).

I don't think it's reasonable to expect LUO maintainers to gain enough expertise
in each subsystem to be able to ensure changes are forwards and backwards
compatible.  The only way I see LUO being successful in the long term is to get
subsystem maintainers/contributors to understand *and buy-in* to the LUO model
and rules, so that each subsystem can largely be self-sustatining.  I.e. setting
yourselves up as literal gatekeepers will help prevent blatant breakage, but it's
less likely to help guard against more subtle breakage, and in my experience,
subtle breakage is by far harder to detect and more painful to deal with.

Somewhat of a side topic: in my experience, using monotonically increasing version
numbers is a horrible way to enumerate features/content.  So for me, allowing
KVM's LUO ABI to change with a verson bump is probably a non-starter.  I.e.
whatever gets merged needs to be more future-proof than "we'll deal with it later".
