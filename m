Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280913AA49
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 20:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708028111; cv=none; b=BUfNLVar01i13VK30BsbB4gIrWq7QizXADZMgzSrvC/AIbQD43HA23U1Wrd5siGNOxeIH8yCAWiaGAa5KWGxO4y8uPlvWRdygY2lr9DRaZDWvd3oR49b4hKMYksqYuSJFXvktrv/n9HvRyHm5V8VMcE18vlQT6mKk53NPPblX0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708028111; c=relaxed/simple;
	bh=KtSlZAZEM4MerD+7iGc6Kd7M/eunyWwhgefG5ILU9M4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+0n9mCt7Svxy9HYO5xaUFFFPuVeAF6nPDMBsN6RyiPfv5YI3bKklJW6z4oILYyYFKR0f3IsgKLk6C8huOdj/lg4ekAXubkFBh+pFdKNemFyP806Rb3Iu50SmGG9363kqJ1fhaHn5XaBgDfpU/rj3nx5uQ7Z5bJv6c7zQ4O32fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XEP/k07f; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XEP/k07f"
Date: Thu, 15 Feb 2024 20:15:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708028106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5uwlfDYuFJvuqLH4pa8qd6E84geWbBOm7pjVTTBFxmE=;
	b=XEP/k07fKmoIyNq8fd5yN5fw4v1roiz/KUhfmrWsHqEYGM6Ivtr+lWJ+eYW5pHFsJzp1cN
	iZ12zj6kH8gfqAMlrtP4/keZ0jpkNSwe4pwFGHrCJfPx1j4/kZBZusBRblQLzo8S159twB
	fN+TnqU3YSD9oaSoN0HHOpqt/lghqOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] KVM: arm64: Improvements to LPI injection
Message-ID: <Zc5wxKnqHomScT2f@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
 <86y1bn3pse.wl-maz@kernel.org>
 <Zc0JG8pNRanuXzvR@linux.dev>
 <86jzn54u2e.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jzn54u2e.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 03:37:45PM +0000, Marc Zyngier wrote:
> > I'd really like to de-risk the performance changes from the cleanups, as
> > I'm convinced they're going to have their own respective piles of bugs.
> > 
> > How does that sound?
> 
> Yup, I'd be on board with that. If you can respin the first part with
> bugs fixed and without the stats, that'd be great. We can further
> bikeshed on the rest in the 6.10 time frame.

Cool. That makes things much easier to manage. I'll respin the get / put
improvements shortly, and hopefully this time I actually fix the stupid
lock imbalance :)

> Also please Cc: Eric Auger, as he dealt with a lot of the ITS
> save/restore stuff.

Always happy to designate another victim to review my crap.

-- 
Thanks,
Oliver
