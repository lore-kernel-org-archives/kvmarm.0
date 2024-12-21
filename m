Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E53B1D9324
	for <kvmarm@lists.linux.dev>; Sat, 21 Dec 2024 22:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734818466; cv=none; b=LacpBk2M9Xm/l/pnPJYKuU1M2BxJMrXnJsQ+UthVdeJocNIGz78afsHuh+4V9scIUiJiGLPu/z7UJyx71wcnn0YMuB8G6vMiVmWXoYJB3sKtPolH/aUg+1Rd2PwH/E0UNCWc4M/DJqvwTSTzBRJc9777HX8oe4KYcW35dECH7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734818466; c=relaxed/simple;
	bh=ZzOzZ4Day6uqjpAziRgRMUNWfdjcLILmrgF7Aw7AoyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qamPPSShVfjJvxUgYSWx/XnJXcb6xYJLmJNNLv0UJ3f3MVgvzboIWvvLLEnjZjye5kR/bZr78Jz60G46cem/XDP2IwZwoMPTqOnsPSITb731jVO8+zHEN51TfYB0wI2n6Uekp3nuqMkXv3UR3hPBaFnBPBZ4svVlthCkaAmY8BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WzuOPhXk; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WzuOPhXk"
Date: Sat, 21 Dec 2024 14:00:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734818460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PATFMChhLOatUbs24Qo4cqgbFe2Ze6ssjZjOW46/WfE=;
	b=WzuOPhXkJksF0wAENIQ9XoOTaFFCHj0JIOeK/r3zILJCMewYLuvquL3gR16FTHAvpwPULy
	OBGCZtoLmUqjLtsQ3o4Of4W8i14rywD5zqW/MijE+0R2UuWYYWh7fCmPpVym5eKdo8JOWt
	WFguTLjlNP+qeULVBqxlQeCJJHbE38A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Janne Grunau <j@jannau.net>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	asahi@lists.linux.dev
Subject: Re: [PATCH 00/18] KVM: arm64: Support FEAT_PMUv3 on Apple hardware
Message-ID: <Z2c6l1cTM7V1Jy7V@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
 <20241221134549.GA2917938@robin.jannau.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221134549.GA2917938@robin.jannau.net>
X-Migadu-Flow: FLOW_OUT

On Sat, Dec 21, 2024 at 02:45:49PM +0100, Janne Grunau wrote:
> On Tue, Dec 17, 2024 at 01:20:30PM -0800, Oliver Upton wrote:
> > One of the interesting features of some Apple M* parts is an IMPDEF trap
> > that routes EL1/EL0 accesses of the PMUv3 registers to EL2. This allows
> > a hypervisor to emulate an architectural PMUv3 on top of the IMPDEF PMU
> > hardware present in the CPU.
> > 
> > And if you squint, this _might_ look like a CPU erratum :-)
> > 
> > This series takes advantage of these IMPDEF traps to provide PMUv3 to
> > KVM guests. As a starting point, only expose the fixed CPU cycle counter
> > and no event counters. Conveniently, this is enough to get Windows
> > running as a KVM guest on Apple hardware.
> > 
> > I've tried to keep the deviation to a minimum by refactoring some of the
> > flows used for PMUv3, e.g. computing PMCEID from the arm_pmu bitmap
> > instead of reading hardware directly.
> > 
> > RFC -> v1:
> >  - Rebase to 6.13-rc3
> >  - Add support for 1 event counter in addition to CPU cycle counter
> >  - Don't sneak past the PMU event filter (Marc)
> >  - Have the PMU driver provide a PMUv3 -> HW event ID mapping (Marc)
> > 
> > Tested on my M2 with Linux and Windows guests. If possible, I'd
> > appreciate someone testing on an M1 as I haven't added those MIDRs to
> > the erratum yet.
> 
> Tested on M1 (t8103) with perf in a Linux guest and the patch below
> 
> Tested-by: Janne Grunau <j@jannau.net>
> 
> I'll import this into the downstream asahi kernel as there was a request
> for performance counters to aid FEX-Emu development recently.
> 
> Janne

Awesome, greatly appreciate the testing Janne. Hopefully we can get this
worked out for upstream too :)

-- 
Thanks,
Oliver
