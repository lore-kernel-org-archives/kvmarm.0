Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5FD431813A
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765540458; cv=none; b=KPtdJtNQc/w61FtwrYo1M/riGZUyvtvVcmmYt2+5bVQYn0AnJVaRAe1auxaXc4EzUV023oMCM2WGyxQxS76TIpc1EdvG3pJQG1M5ldqQ0xOO5JY55ZDYmiSfbRY+Te8U3ERJevfJw4ptMaxDeewVtm7QESEwYsZ5Fudv5X2S3N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765540458; c=relaxed/simple;
	bh=4szydTubd78idCqvCQNH6GHfh3O4QQR6BAWxfFRcut8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V052fLYBRzpOMzhZ7gTsGcS/CsGlznxBjSr9KhoPUFz+XeDfoPtpIlXmPsYtphkA73ok+bhZOOIMWswpuu5++ElQdX02LKdLG1fnl3JzsfCjT6aGgr3faCR2JaBFJ2RhxY1pmAknls+Setp2z4Yox2hI2WjM2ElWPKlbivZwV9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E9B1FEC;
	Fri, 12 Dec 2025 03:54:07 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 810F53F762;
	Fri, 12 Dec 2025 03:54:12 -0800 (PST)
Date: Fri, 12 Dec 2025 11:54:09 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Leo Yan <leo.yan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 00/35] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <aTwCYSitrJHIue8t@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251211163425.GA4113166@e132581.arm.com>
 <aTvr8_xjoKY6pB8P@raptor>
 <20251212111541.GA138375@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251212111541.GA138375@e132581.arm.com>

Hi Leo,

On Fri, Dec 12, 2025 at 11:15:41AM +0000, Leo Yan wrote:
> On Fri, Dec 12, 2025 at 10:18:27AM +0000, Alexandru Elisei wrote:
> 
> [...]
> 
> 
> > > 3) In the end, the KVM hypervisor pins physical pages on the host
> > >    stage-1 page table for:
> > 
> > By 'pin' meaning using pin_user_pages(), yes.
> > 
> > > 
> > >    The physical pages are pinned for Guest stage-1 table;
> > 
> > Yes.
> > 
> > >    The physical pages are pinned for Guest stage-2 table;
> > 
> > Yes and no. The pages allocated for the stage 2 translation tables are not
> > mapped in the host's userspace, they are mapped in the kernel linear address
> > space. This means that they are not subject to migration/swap/compaction/etc,
> > they will only be reused after KVM frees them.
> > 
> > But that's how KVM manages stage 2 for all VMs, so maybe I misunderstood what
> > you were saying.
> 
> No, you did not misunderstand.  I did not understand stage-2 table
> allocation before — it is allocated by KVM, not from user memory via
> the VMM.
> 
> [...]
> 
> > > Due the host might migrate or swap pages, so all the pin operations
> > > happen on the host's page table.  The pin operations never to be set up
> > > in guest's stage-2 table, right?
> > 
> > I'm not sure what you mean.
> 
> Never mind.  I think you have answered this below (pin user memory via
> pin_user_pages() and no matter with stage-2 tables).
> 
> > > My understanding is that there are two prominent challenges for SPE
> > > virtualization:
> > > 
> > > 1) Allocation: we need to allocate trace buffer with mapping both
> > >    guest's stage-1 and stage-2 before enabling SPU.  (For me, the free
> > 
> > It's the guest responsibility to map the buffer in the guest stage 1 before
> > enabling it. When the guest enables the buffer, KVM walks the guest's stage 1
> > and if it doesn't find a translation for a buffer guest VA, it will inject a
> > profiling buffer management event to the guest, with EC stage 1 data abort.
> 
> IIUC, KVM will inject a buffer management interrupt to guest and then
> guest driver can detect EC="stage 1 data abort".  KVM does not raise a
> data abort exception in this case.
> 
> > If the buffer was mapped in the guest stage 1 when the guest enabled the buffer,
> > but at same point in the future the guest unmaps the buffer from stage 1, the
> > statistical profiling unit might encounter a stage 1 data abort when attempting
> > to write to memory. If that's the case, the interrupt is taken by the host, and
> > KVM will inject the buffer management event back to the guest.
> 
> Hmm... just a note, it would be straightforward for guest to directly
> respond IRQ for "stage-1 data abort" (TBH, I don't know how to inject
> IRQ vs fast-forward IRQ, you could ignore this note until I dig a bit).

PMBIRQ is a purely virtual interrupt for KVM. Very early on guest exit, KVM
saves the hardware value for PMBSR_EL1 and clears PMBSR_EL1.S, which leads to
the SPU deasserting PMBIRQ to the GIC.

From my very limited testing, the GIC is always fast enough to deasserts the
interrupt to the CPU before interrupts are enabled much later in the VCPU run
loop. If that doesn't happen (GIC is still asserting PMBIRQ when interrupts on
enabled on the CPU), the SPE driver interrupt handler will treat it as a
spurious interrupt because the driver reads PMBSR_EL1.S = 0.

Thanks,
Alex
