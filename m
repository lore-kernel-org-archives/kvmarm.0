Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EAD444707
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 14:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786457150; cv=none; b=oXoUrZmo4ZcGPVYtrzonmm52sOl5nb4vXjqJ4TVC2Ba2lVbdFhUtLviX64Fwhwe3TsTwSafClpumchHigdci6nt47Vsbq+nxgXTJ5yVcwCDEJwLLw1+TW75kZxpPkUMMLy6kU21vPVAtY2TmPU0OFxKkNssamiGRtJX/sabggrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786457150; c=relaxed/simple;
	bh=IpGRwjcNXY0ZjSkV0KzCG7krK0XNKqIE0KLfGji2OHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KHVY6ltWe3XBP+VjctRfjNtXe5PnRw3rQo2AEJtF9xyWvA6rFHYYmDmUZoQ4d8qi/Wg4A2IvF/Ur5azQkohxZqpZ50bzh0gwtyn1Elw+QGkK8PWQmGFHJZSIJQRTpOpZmXivr1PGPQX/h4zFiC7QMQeoL6gZbF/gfZPvtAhFaCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tZ8zN1G+; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tZ8zN1G+"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cf7dd9fd91so31221575ad.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 07:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786457146; x=1787061946; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iAJktWiCLBpTuTmwKXB+qiv4Wjmxms+UGlXDoh/JJdk=;
        b=tZ8zN1G+rJmIkECc31ba88c372hz7h/S7L/vaOI5PvD/supEcT19fbpu3lKYdWFMzc
         rmjMq6bHGbrtB12j6Sqtg/1V2Z1rvYSAPuuAX4ILB//MSr+GSyG0EX0dLctws0F3Cfzi
         9FI19DlY5vuH95EtZk0MNKCBA4BWDJkqlGfwWDFkLmPDM1g3EEh1H74jN4PlJFuH0iLu
         oBHcpsAcKsK+67L2GMXptxHjv1nNMRqBQAzjkVNzOh3ZBqLoVgyWYOPeT5Bw69KuneCz
         m12HVzCT1Jf7hPck8qXbZajewTvGRIfCJH5q55IFaNUd9hbZiqBuNQFsMQqk68YjV2gO
         fCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457146; x=1787061946;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iAJktWiCLBpTuTmwKXB+qiv4Wjmxms+UGlXDoh/JJdk=;
        b=bJIWIAmtu+zx4TAVY0GAoWRfsaPjqfLJFvkwnQaNEEA8E+2vMELF7sDRawiP/xUVrv
         zlB0NCDwPY/BN+zYb0dQI15g3LYgzAdqTUAN1J6gkwBwM7tHGN3VxQ2dgCS13kla2baO
         jnP4eRDV9WmD+fhJRChULRWaveNEpicmBT58W4IdgMb+AUfFxdKKVSQuLaEmKujz8IJQ
         XEMA0WrCoK4GaljOzD7G2ZGCU1AnhEsXJGXlxmIpOIP0ryOJzUQs1wRApjw5XdF6aXNl
         GOQgod8VlV58jbzpImpHRAdaOTcwAy4KSDAVxkunmpwyRd7ptrahu4c4tifPC0wcgwk8
         Z7HQ==
X-Forwarded-Encrypted: i=1; AHgh+RqpxFbGNAiebbA4trXBQsqZNXmTAm+2lHVsNDCI6LMVCQni16CP9mOd0jl6pBHRbeGCpWJfLN8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9hw/S2KifoykGlhaB9yhAMp9lBXqEFiML+rQcnPOYD1ERaU2s
	9qOkb5ZL9Pm60JwbBZAkHa+enOKlz6wtFh7LEqb5UOQh/1Ax/w5zz1be+GQztS/f1YjB4TIji4R
	pwZxwMA==
X-Received: from plok3.prod.google.com ([2002:a17:903:3bc3:b0:2cc:8fa5:7221])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f64a:b0:2c6:a012:6241
 with SMTP id d9443c01a7336-2d3177a171dmr43949945ad.6.1786457145880; Tue, 11
 Aug 2026 07:05:45 -0700 (PDT)
Date: Tue, 11 Aug 2026 07:05:45 -0700
In-Reply-To: <2vxzpkzo51wg.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
Message-ID: <anssOQFNZ2LfihbU@google.com>
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

On Tue, Aug 11, 2026, Pratyush Yadav wrote:
> On Mon, Aug 10 2026, Sean Christopherson wrote:
> 
> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
> >> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
> >> to serialize and deserialize VM state across kexec live updates.
> >> 
> >> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
> >> of VM preservation.
> >
> > Why?
> >
> >> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
> >> kvm_create_vm_file() and use an atomically incremented ID for the internal
> >> fdname, as the final fdname assigned by userspace is not yet known during
> >> retrieval. As this fdname is only used in debugfs infra, This will not break
> >> any UAPI.
> >> 
> >> This infrastructure establishes the foundation for preserving guest_memfd
> >> instances across live updates, and can be expanded in the future to
> >> preserve additional VM state.
> >
> > Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
> > guest_memfd should be the _last_ thing we support, not the first.  As evidenced
> > by the last two decades, it's very doable to have KVM VMs without guest_memfd,
> > but it's rather hard to have VMs without vCPUs.
> 
> You _can_ preserve vCPUs today using KVM_{GET,SET}_REGS, they just won't
> run in the background during the reboot.

What about x86 CoCo VMs?  Which are quite literally _the_ reason guest_memfd was
created in the first place.  

> This series can save you from dumping VM memory to disk if it is backed by
> guest_memfd.

Or to word it another way, one _can_ save guest_memfd, it's just slower.  My
point is that this series needs to provide a _lot_ more information about the
bigger KVM picture.  For those of us that are on the very fringes of live update,
it's practically impossible to review because, to us, it seems very arbitrary.

The part that's especially confusing is the saving of the VM type.  That comes
straight from userspace, so it's super bizarre to automatically save/restore that,
but nothing else.

> >> +KVM LIVE UPDATE
> >> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
> >> +M:	Mike Rapoport <rppt@kernel.org>
> >> +M:	Pratyush Yadav <pratyush@kernel.org>
> >> +R:	Tarun Sahu <tarunsahu@google.com>
> >> +L:	kexec@lists.infradead.org
> >> +L:	kvm@vger.kernel.org
> >> +S:	Maintained
> >> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> >
> > NAK on taking changes through a different tree.  This is KVM code, period.
> >
> > In general, I'm skeptical of the dedicated MAINTAINERS entry.  It's extremely
> > difficult to tell since this series is little more than a skeleton (either that
> > or liveupdate is way simpler that I was expecting), but I suspect that maintaining

...

> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
> > is going to be in knowing what to save/restore, and how, which is much more about
> > KVM than it is about liveupdate.
> 
> I think it is fine if you want to take these changes through the KVM
> tree, but I would like live update maintainers to be listed as reviewers
> at least.

Why not simply add a file pattern match to the LIVE UPDATE entry?

diff --git MAINTAINERS MAINTAINERS
index 8014b9f8253e..2eb57b22c37f 100644
--- MAINTAINERS
+++ MAINTAINERS
@@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
 F:     include/uapi/linux/liveupdate.h
 F:     kernel/liveupdate/
 F:     lib/tests/liveupdate.c
-F:     mm/memfd_luo.c
 F:     tools/testing/selftests/liveupdate/
+N:     [^a-z]luo
 
 LLC (802.2)
 L:     netdev@vger.kernel.org

> At the same time, I also keep being (pleasantly)
> surprised at preservation being relatively simple. For example, the code
> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
> of which is comments. The code of course has some limitations, but it is
> good enough for use in production.
> 
> For one, we care about ABI breakages and versioning. 

Which is amusing to me because that implies KVM does not, and I would hazard to
guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
country mile (though I'm probably wildly underestimating the effective ABI surface
of filesystems).

> The serialized state is a part of live update ABI and changes to it should be
> ACKed by us. 

Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
see why liveupdate needs special treatment.

> For another, how the file handlers interact with their dependencies can
> affect the behaviour that VMMs observe. Those changes should also pass by
> some live update eyes.

Perhaps in the short term, but IMO, that's not a winning strategy in the long
term.  From my perspective, that like saying the PAGE CACHE maintainers should
review every usage of the filemap APIs, because how the APIs are used impacts
the page cache and affects userspace-visible behavior.  There are myriad analogies
like that throughout the kernel.

Yes, liveupdate is new and shiny, but IMO for it to be successful and maintainable,
it needs to be treated like any other core infrastructure in the kernel, not a
special snowflake whose details are known only by a handful of people.  Because
I think it's likely liveupdate goes one of two ways: either liveupdate becomes a
very niche thing that is used sparingly throughout the kernel, or it becomes a
broadly used feature that is supported by many filesystems and subsystems.

If liveupdate is relegated to niche status, then it probably isn't going to see
a significant amount of ongoing development, at which point the folks working on
liveupdate will naturally migrate to other projects, and maintenance will largely
be left to subsystem maintainers.

If liveupdate is broadly used, then having a single group of people maintain
every subsystem's usage won't scale, and maintenance will again largely fall on
the shoulder of subsystem maintainers.  Which is totally fine and working as
intended, because that's exactly what subystem maintainers are signing up for
by merging support for liveupdate.
