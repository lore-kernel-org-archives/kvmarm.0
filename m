Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53EC22068A
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765470870; cv=none; b=nKNNas+CqtlrB3sQq5ASSMIJfJyzICwPNJElUrNsII9VKlflYqfHCwW6/3R7TmRk9JC/sKXjdjtjW173BD3TKmJ8xICTrRWC5qzBfFfKChHuW5p9U/oeXOgeKT0dUtqt4qmenRjJds6m7zaktFmQdENeOx/2Fxe38Xaon46FZrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765470870; c=relaxed/simple;
	bh=gRMGTxk+E5OssCw7KLXY7ad4pHQi9rkNCPeKjCx/xSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJW0MhK4wZ+jbj4zRwmdnD7LxDtfpzkTanRjmCXLFvqDEUWnGxTbFCQKphSsOfATFQz+D4cQG3Ho0VQDbu5ZYBcQ46GFHJGBRx774MtVaB2HtAh25SYz63qvh2UslWos4ZTnLCOEZ4FeQZ8RrwQeOolklEDOnX+1xp6AX8QzWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E2D31063;
	Thu, 11 Dec 2025 08:34:20 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72A213F73B;
	Thu, 11 Dec 2025 08:34:27 -0800 (PST)
Date: Thu, 11 Dec 2025 16:34:25 +0000
From: Leo Yan <leo.yan@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 00/35] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <20251211163425.GA4113166@e132581.arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>

Hi Alexandru,

Just couples general questions for myself to easier understand the series
(sorry if I asked duplicated questions).

> I wanted the focus to be on pinning memory at stage 2 (that's patches #29, 'KVM:
> arm64: Pin the SPE buffer in the host and map it at stage 2', to #3, 'KVM:
> arm64: Add hugetlb support for SPE') and I would very much like to start a
> discussion around that.

I am confused for "pinning memory at stage 2" and then I read "Pin the
SPE buffer in the host".  I read Chapter 2 Specification, ARM DEN 0154,
my conclusion is:

1) You set PMBLIMITR_EL1.nVM == 0 (virtual address mode) so that the
   driver uses the same mode whether it is running in a host or in a
   guest.

2) The KVM hypervisor needs to parse the VA -> IPA -> PA with:

   Guest stage-1 table (managed in guest OS);
   Guest stage-2 table (managed in KVM hypervisor);

3) In the end, the KVM hypervisor pins physical pages on the host
   stage-1 page table for:

   The physical pages are pinned for Guest stage-1 table;
   The physical pages are pinned for Guest stage-2 table;
   The physical pages are pinned for used for TRBE buffer in guest.

Due the host might migrate or swap pages, so all the pin operations
happen on the host's page table.  The pin operations never to be set up
in guest's stage-2 table, right?

> The problem
> ===========
> 
> When the Statistical Profiling Unit (SPU from now on) encounter a fault when
> it attempts to write a record to memory, two things happen: profiling is
> stopped, and the fault is reported to the CPU via an interrupt, not an
> exception. This creates a blackout window during which the CPU executes
> instructions which aren't profiled. The SPE driver avoid this by keeping the
> buffer mapped while ProfilingBufferEnabled() = true. But when running as a
> guest under KVM, the SPU will trigger stage 2 faults, with the associated
> blackout windows.

My understanding is that there are two prominent challenges for SPE
virtualization:

1) Allocation: we need to allocate trace buffer with mapping both
   guest's stage-1 and stage-2 before enabling SPU.  (For me, the free
   buffer is never an issue as we always disable the SPU before
   releasing the resource).

2) Pin: the physical pages used by trace buffer and the relevant stage-1
   and stage-2 tables must be pinned during the session.

I will read (and learn) the patches in next days.

Thanks,
Leo
