Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF7725B31D
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771602506; cv=none; b=Ozv5yixIxPZu9gEUuR7JCY9VPL0IawwXOQz4JCX4sj0uS2/Fdignivs4NhrGyqmwQgUO9ZIPH2JmcBXry8AkoX1X/PzLhG4ojSAxszaRF1lygPvQ3JIpnqgOosBkdGEuMRy0g3irYcW8LhxjYmiSR2twFDOOk7tLbuwBP6l0Lpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771602506; c=relaxed/simple;
	bh=YYsPCPCPBBvHa//zHJ7bg6IST+k1syMn2JCG4pQxHik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9zhsa8O0WPuRGc6nmx4YEV+aU4cG2Vb5a+au1hCO/X5wyblneEhwZ1wKkiAvBBapK/TJfOA/vIMBPVzCXBNqCZAqduOrtPDJnTW6U94VO9e79Ugxr8hxlAtVNv8gIv3XYn1u5QQfkKYXPpWaNj/zB4N2jA7aAnT/AtHuDKXA6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE889339;
	Fri, 20 Feb 2026 07:48:16 -0800 (PST)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABB5C3F7D8;
	Fri, 20 Feb 2026 07:48:22 -0800 (PST)
Date: Fri, 20 Feb 2026 15:48:20 +0000
From: Leo Yan <leo.yan@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: James Clark <james.clark@linaro.org>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
Message-ID: <20260220154820.GG136967@e132581.arm.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <868qcsbsbd.wl-maz@kernel.org>
 <076e013a-b66d-4985-9709-734d7184ad72@linaro.org>
 <867bscbpmp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867bscbpmp.wl-maz@kernel.org>

On Mon, Feb 16, 2026 at 04:49:02PM +0000, Marc Zyngier wrote:

[...]

> > > But that's *not* working. If you trace EL1 only, even with a VHE host,
> > > the result is not usable.
> > > 
> > 
> > Do you mean not working because of the missing exceptions? I did a bit
> > of testing before and the trace did seem somewhat usable to me. It had
> > EL1 and EL0 atoms in there.
> 
> Sure. Now try to look at what that means for NV, where all the
> EL1->EL2 exceptions are emulated, where all the EL2->EL1 exception
> returns are emulated.
> 
> What does it give you? A bag of nonsense.

Sorry for jumping in.

If we enable TRBE in a VM, whether nested or not, why is it necessary to
capture trace data for the exception transition between the VM and its
higher level host(s)?

Seems to me, regardless of what happens during exception emulation, once
the VM is switched out, tracing will be stopped, and then re-enabled
when the VM is switched back.  In that case, we should be able to record
the complete trace data for whatever occurs while the VM is running.

On the other hand, when launch a trace within a VM, I think we should
not trace higher level's hypervisor or hosts, this is concerned for
security leakage.

> Same thing for EL2->EL0, by the way, so you can't even correctly
> profile an EL0 program that performs a syscall, or that gets
> interrupted. And while without NV, these exceptions are rare, having a
> trace that is unreliable has the potential of being worse than no
> trace at all.
> 
> Until the architecture grows a way for KVM to inject the missing
> information into the trace, TRBE support for guest will stay out.

I agree we need to understand what is actually blocking issues for TRBE
virtualization.

Essentially, I'd confirm the methodology for trace virtualization.  I
assume it allows a higher privilege OS to trace a lower privilege OS,
but not the other way around.

Thanks,
Leo
