Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3891E00B6
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 22:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733265172; cv=none; b=WjEuqhHi6E3q0KlxLmGwpjMTSKkAPjrdyafmf+92n2qbfaBTcmfBiCmYnICQ7GS1EJgVWS/EP/t0nwkICWzXCXdMhbljM/XrgV2gbo8HnBPgl4irdsg3uBR371qvl+/NS4JmKsvIJyb+WSXDgYcTyqYJhE5fYD9wT4wSzTuFhS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733265172; c=relaxed/simple;
	bh=5xMXuje2rUezOB3vk/lCC+YV5xNh0tfH3rMlg84BM68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOriIiw8Tg8AZWbUQ+kICkWHC+VZVLPn39QC6K6y+kbH6QPVaBeW1ywQY6x5vqH3LNw4QbhXY2aNuPRFIIgGlPJmOQp+7g11ks/A82dEFEbWC7OKMPddaidM8d9f/LoDTQYUKXSMsHskx8GOFZTKiTG59+bzMy7ljbx3sbktToQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lKeUpq1H; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lKeUpq1H"
Date: Tue, 3 Dec 2024 14:32:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733265168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hW6mNNVP48/Mj7mfy3CFRZP/i3VCK2OWGnyJMzSgKV8=;
	b=lKeUpq1HixcYGhKHPIjBx5QNSGodFFQIQucOMLyelNmPqr3SCb6YdppIiid4Fl1hXAcTEX
	paJ1KXPjqk2uMXzF/3ifnchnBBeUQUhezqTLsRyfaCJIEhd+DDnQOw8HBeLP7nZTCdH73E
	mxQwVWdcMoCujqQhOH+fthdwYpPQL5k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 05/14] KVM: arm64: Always allow fixed cycle counter
Message-ID: <Z0-HBsBgf6WB7x4R@linux.dev>
References: <20241203193220.1070811-1-oliver.upton@linux.dev>
 <20241203193220.1070811-6-oliver.upton@linux.dev>
 <87ldwwsbad.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldwwsbad.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 03, 2024 at 09:32:10PM +0000, Marc Zyngier wrote:
> On Tue, 03 Dec 2024 19:32:11 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > The fixed CPU cycle counter is mandatory for PMUv3, so it doesn't make a
> > lot of sense allowing userspace to filter it. Only apply the PMU event
> > filter to *programmed* event counters.
> 
> But that's a change in ABI, isn't it? We explicitly say in the
> documentation that the cycle counter can be filtered by specifying
> event 0x11.

Yeah... A bit of a dirty shortcut I took because I don't like the ABI,
but distaste isn't enough to break it :)

> More importantly, the current filtering works in terms of events, and
> not in terms of counters.
> 
> Instead of changing the ABI, how about simply not supporting filtering
> on such non-compliant HW? Surely that would simplify a few things.

Yeah, that sounds reasonable. Especially if we allow programmable event
counters where the event ID space doesn't match the architecture.

-- 
Thanks,
Oliver
