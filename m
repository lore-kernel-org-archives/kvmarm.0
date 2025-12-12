Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BEA1E9B12
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 11:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765538152; cv=none; b=DDnMEkA4FH6EPd9btoP0xfwVsIvviSab1C306GZp9uJHPGSoe+xyUTLLuPc5dWOuk3AfjF6Fi+63fc5D3huWdUP+bIwIujWrnb0y4mD+QCvNIGDVBxDawcinpQzuHcnJ5E46SOlrKKheq4IMZFtKTGOyEkco+MqYb4omclCEaUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765538152; c=relaxed/simple;
	bh=TqInXmZyT3WqM9ceOBImM3NApmzpQ4l7kKGaDWHEby8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQJqfw2+rLDN6gr9YLPjDYzPrQnoNEb6r8+8yUxkF/SaBkORNSqCkP/jnpMBkUjqTLxRYF1OlyQqkUHE1hoKqYmWz/enpS2v3e+T5j7Cj6urU1OnDYdEnW6cEeqNqD7ioytzza3V+AefbnfSg3HCmFcIIJWTuFNURc0k4i4cSnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93603FEC;
	Fri, 12 Dec 2025 03:15:36 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 678893F73B;
	Fri, 12 Dec 2025 03:15:43 -0800 (PST)
Date: Fri, 12 Dec 2025 11:15:41 +0000
From: Leo Yan <leo.yan@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 00/35] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <20251212111541.GA138375@e132581.arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251211163425.GA4113166@e132581.arm.com>
 <aTvr8_xjoKY6pB8P@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aTvr8_xjoKY6pB8P@raptor>

On Fri, Dec 12, 2025 at 10:18:27AM +0000, Alexandru Elisei wrote:

[...]


> > 3) In the end, the KVM hypervisor pins physical pages on the host
> >    stage-1 page table for:
> 
> By 'pin' meaning using pin_user_pages(), yes.
> 
> > 
> >    The physical pages are pinned for Guest stage-1 table;
> 
> Yes.
> 
> >    The physical pages are pinned for Guest stage-2 table;
> 
> Yes and no. The pages allocated for the stage 2 translation tables are not
> mapped in the host's userspace, they are mapped in the kernel linear address
> space. This means that they are not subject to migration/swap/compaction/etc,
> they will only be reused after KVM frees them.
> 
> But that's how KVM manages stage 2 for all VMs, so maybe I misunderstood what
> you were saying.

No, you did not misunderstand.  I did not understand stage-2 table
allocation before — it is allocated by KVM, not from user memory via
the VMM.

[...]

> > Due the host might migrate or swap pages, so all the pin operations
> > happen on the host's page table.  The pin operations never to be set up
> > in guest's stage-2 table, right?
> 
> I'm not sure what you mean.

Never mind.  I think you have answered this below (pin user memory via
pin_user_pages() and no matter with stage-2 tables).

> > My understanding is that there are two prominent challenges for SPE
> > virtualization:
> > 
> > 1) Allocation: we need to allocate trace buffer with mapping both
> >    guest's stage-1 and stage-2 before enabling SPU.  (For me, the free
> 
> It's the guest responsibility to map the buffer in the guest stage 1 before
> enabling it. When the guest enables the buffer, KVM walks the guest's stage 1
> and if it doesn't find a translation for a buffer guest VA, it will inject a
> profiling buffer management event to the guest, with EC stage 1 data abort.

IIUC, KVM will inject a buffer management interrupt to guest and then
guest driver can detect EC="stage 1 data abort".  KVM does not raise a
data abort exception in this case.

> If the buffer was mapped in the guest stage 1 when the guest enabled the buffer,
> but at same point in the future the guest unmaps the buffer from stage 1, the
> statistical profiling unit might encounter a stage 1 data abort when attempting
> to write to memory. If that's the case, the interrupt is taken by the host, and
> KVM will inject the buffer management event back to the guest.

Hmm... just a note, it would be straightforward for guest to directly
respond IRQ for "stage-1 data abort" (TBH, I don't know how to inject
IRQ vs fast-forward IRQ, you could ignore this note until I dig a bit).

Thanks for quick response.  The info is quite helpful for me.

Leo
