Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D7202C4A
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 23:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736377595; cv=none; b=IuaaGiEUsjOK7iBdZ+Ows0pf6BotIisn/kILsce3WmwwqlM0errVEzSfoRUyckQFrknBIOcV92fYtHy+lWCmlYtus8uu57vL2rdgh3xBpQgfkl+/Orc7+9ES+fHdnSVB08RBAr33qlJ/VV3Tgx74XP/z0FSFCKobOgnARYFKve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736377595; c=relaxed/simple;
	bh=g6e70Xxe6M1gWAuwHE38f+lQTGpfCJEzJHqYpWPfWIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0xBsIr/XvqIgSaOUQtsubHaevQVZXK5jVBx4G/KFrTHhiJw4jJMlRNSQT0jfqDSxVrpJvR0/Z9oWqUOaSz9gqP4RBCMZcmq6AyJrV2MwRM/OjY0wRxD3Njq++LKW56c3kcr0icTmw22kxctVt0aay4fKZDIQHkCmmoMErlYK1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RoyE56dL; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RoyE56dL"
Date: Wed, 8 Jan 2025 15:06:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736377576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vgCJheOFNNrmteKZk0wzRAtFXLDsAQbokdoxMYfFalE=;
	b=RoyE56dLBW3iwVFoe4/0jZuzFyNsE0AxyizsfrjApzlczaZ9iaQ4zVx1/j57m6P4c40Rgt
	C0rqUt+JRAMyK+uPEa6hg80NmzL/6IKYbtL95Hp9W+DU+SpiNvVt44EEujX4Tgfj4NnJiY
	01nr+YtvrbmxnICjtMV21yHlwbga2oo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] KVM: arm64: Support FEAT_PMUv3 on Apple hardware\
Message-ID: <Z38E4hRMlBp3CBz0@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
 <20250108123840.GA9197@willie-the-truck>
 <Z37cjxFu2CPi_xNr@linux.dev>
 <87jzb5q9nl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzb5q9nl.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 08, 2025 at 09:26:54PM +0000, Marc Zyngier wrote:
> On Wed, 08 Jan 2025 20:14:07 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Hey Will,
> > 
> > On Wed, Jan 08, 2025 at 12:38:41PM +0000, Will Deacon wrote:
> > > What's your plan for this series? I started looking at it and I can take
> > > the first four apple_m1 patches if you like?
> > 
> > I plan on posting a respin of it by next week, which should look pretty
> > much the same besides cleaning up the build error I introduced :)
> > 
> > Besides that, I think we need to decide on the KVM side of things
> > whether or not we want to support an event counter in addition to the
> > PMU cycle counter. Janne's FEX use case would certainly benefit from it.
> 
> I think we should always be able to support *one* counter on top of
> the cycle counter. Doing more than that would result in inconsistent
> behaviours (some events only count on a single counter).
> 
> Unless we restrict ourselves to a very small set of events that we can
> always schedule on any counter, but this doesn't sound very promising.

I definitely agree that a single event counter is the way to go. Dealing
with this IMPDEF crud is gross already, and coping with event affinities
would only make it worse.

I was more wanting to test the idea that we want programmable event
counters at all, although it isn't that much of a burden on top of the
cycle counter.

I'll un-RFC the tail of the series in v2 then.

-- 
Thanks,
Oliver
