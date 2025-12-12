Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1E13126C3
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 10:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534716; cv=none; b=dq1RL0jgvKpqhap2MATX0mo0D8cRpbEdwrzGihLOABAn6Tizd1OITCxcwLNGKuMNOICxGC7kjOSGgRbegN9wg+EyldQ82qQ+nvYsCkhrNJZRDo8b4wMKo4QL7Ynap+s451KTjGKG+naixBXCmkQ0fFytAUiQ8BgMF8f0zVbwLos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534716; c=relaxed/simple;
	bh=mEvHTclAWCbw79Pwli8RqX1Xz1OJkY9J5ruX12QIkbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=os/VFFIq9lXQidoY/jEGhtQyVwSDqIVA818/1nKWBKg6Vno4TuSUXOagX/iF9NwNf49NfESh1iOP3U//PHIMmrZm0pXvHpOdHxzxRmQqaaOz+pbHksAisptiJBBb8nW1/VLWOvgUxxS94N2akNtMRVesoXhaxI3gdDSaxo4C8mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A2D41063;
	Fri, 12 Dec 2025 02:18:24 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4FB73F762;
	Fri, 12 Dec 2025 02:18:29 -0800 (PST)
Date: Fri, 12 Dec 2025 10:18:27 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Leo Yan <leo.yan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 00/35] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <aTvr8_xjoKY6pB8P@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251211163425.GA4113166@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211163425.GA4113166@e132581.arm.com>

Hi Leo,

On Thu, Dec 11, 2025 at 04:34:25PM +0000, Leo Yan wrote:
> Hi Alexandru,
> 
> Just couples general questions for myself to easier understand the series
> (sorry if I asked duplicated questions).
> 
> > I wanted the focus to be on pinning memory at stage 2 (that's patches #29, 'KVM:
> > arm64: Pin the SPE buffer in the host and map it at stage 2', to #3, 'KVM:
> > arm64: Add hugetlb support for SPE') and I would very much like to start a
> > discussion around that.
> 
> I am confused for "pinning memory at stage 2" and then I read "Pin the
> SPE buffer in the host".  I read Chapter 2 Specification, ARM DEN 0154,
> my conclusion is:
> 
> 1) You set PMBLIMITR_EL1.nVM == 0 (virtual address mode) so that the
>    driver uses the same mode whether it is running in a host or in a
>    guest.

KVM does not advertise FEAT_SPE_nVM and treats PMBLIMITR_EL1.nVM as RES0 on a
guest access. The value of PMSCR_EL2.EnVM is always zero while a guest is
running.

So yes, and the Linux driver is not aware of physical addressing mode and
that's what I used for testing.

> 
> 2) The KVM hypervisor needs to parse the VA -> IPA -> PA with:
> 
>    Guest stage-1 table (managed in guest OS);

Yes.

>    Guest stage-2 table (managed in KVM hypervisor);

Yes.

> 
> 3) In the end, the KVM hypervisor pins physical pages on the host
>    stage-1 page table for:

By 'pin' meaning using pin_user_pages(), yes.

> 
>    The physical pages are pinned for Guest stage-1 table;

Yes.

>    The physical pages are pinned for Guest stage-2 table;

Yes and no. The pages allocated for the stage 2 translation tables are not
mapped in the host's userspace, they are mapped in the kernel linear address
space. This means that they are not subject to migration/swap/compaction/etc,
they will only be reused after KVM frees them.

But that's how KVM manages stage 2 for all VMs, so maybe I misunderstood what
you were saying.

>    The physical pages are pinned for used for TRBE buffer in guest.

SPE, but yes, the same principle.

> 
> Due the host might migrate or swap pages, so all the pin operations
> happen on the host's page table.  The pin operations never to be set up
> in guest's stage-2 table, right?

I'm not sure what you mean.

> 
> > The problem
> > ===========
> > 
> > When the Statistical Profiling Unit (SPU from now on) encounter a fault when
> > it attempts to write a record to memory, two things happen: profiling is
> > stopped, and the fault is reported to the CPU via an interrupt, not an
> > exception. This creates a blackout window during which the CPU executes
> > instructions which aren't profiled. The SPE driver avoid this by keeping the
> > buffer mapped while ProfilingBufferEnabled() = true. But when running as a
> > guest under KVM, the SPU will trigger stage 2 faults, with the associated
> > blackout windows.
> 
> My understanding is that there are two prominent challenges for SPE
> virtualization:
> 
> 1) Allocation: we need to allocate trace buffer with mapping both
>    guest's stage-1 and stage-2 before enabling SPU.  (For me, the free

It's the guest responsibility to map the buffer in the guest stage 1 before
enabling it. When the guest enables the buffer, KVM walks the guest's stage 1
and if it doesn't find a translation for a buffer guest VA, it will inject a
profiling buffer management event to the guest, with EC stage 1 data abort.

If the buffer was mapped in the guest stage 1 when the guest enabled the buffer,
but at same point in the future the guest unmaps the buffer from stage 1, the
statistical profiling unit might encounter a stage 1 data abort when attempting
to write to memory. If that's the case, the interrupt is taken by the host, and
KVM will inject the buffer management event back to the guest.

>    buffer is never an issue as we always disable the SPU before
>    releasing the resource).
> 
> 2) Pin: the physical pages used by trace buffer and the relevant stage-1
>    and stage-2 tables must be pinned during the session.

If by pinning you mean pin_user_pages() and friends, then KVM does not need to
do that for the stage 2 tables, pin_user_pages() makes sense only for userspace
addresses.

Thanks,
Alex
