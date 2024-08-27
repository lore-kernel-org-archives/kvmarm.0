Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F351854
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 07:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742083; cv=none; b=V7gtwBXU6X5WRHCFAzOhStDjxqJDUfy2gCNZrpMJheFwW6fNVXZ58gOo5bbNMp22lW2bRlyDfB9Fg3/s+0xxS15yFem+8UXKZ1UBRNtOyByyYqOTLmQsoTBkIX9Z0weXKMo0LU7W7eFhFMH4QAEy44rIY/I4dZqCCksW8K7DFCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742083; c=relaxed/simple;
	bh=qVRZOnR3iBZ7KNZ3lUscpxiB6Ig2csGS9p0ZZrEiT0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhyDjf9Y7r4emC7+OGWFVa7tkQRULHCEtxHqMfngTc+Qs2cvtpTmQ8ewU19d+S9h+FWu/3YbsxFXmZlHG9+Jg7+bM0o1kdj6K1Y9CuWZxuogAViwl+l4Sjl317Of+ZH501Pl//nXZbH4fx0F6rm89v9dLzEWiugRlBGtN7Fs8WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dVp6nHO5; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dVp6nHO5"
Date: Tue, 27 Aug 2024 00:01:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724742078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LCZto46Oql9ITvqT1x4W20RV9lpPDbDDuODidlE2w2Y=;
	b=dVp6nHO5n1Kb0QNlTJQK//lKQRNLrcrilyhEM8c4VFOqhS8jsEcKIsiVpDiFv8LlZBNwRg
	YNp/dDJNJteeQkq9ohg8S4MfxeYaQ+2qQptrtAM3hzWQ/cYIv2GDsXQ+jPiJQesvDZGHMs
	m6KZAJOrXBr1M8ugoeKumWPEvYS2Sc4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Add EL2 PMU event filtering support
Message-ID: <Zs15t5JVqcG6AYjF@linux.dev>
References: <20240824001402.3909504-1-oliver.upton@linux.dev>
 <86v7zpvwym.wl-maz@kernel.org>
 <Zsy6zNQT2o6sTidY@linux.dev>
 <86r0aawk0s.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0aawk0s.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 27, 2024 at 07:35:15AM +0100, Marc Zyngier wrote:
> > Thoughts?
> 
> I see that you have already posted your proposed approach, but allow
> me to say what I have in mind.
> 
> We have three possibilities:
> 
> - either we go with your approach, which has the advantage of not
>   requiring any new trap description, but breaks the (unwritten)
>   promise that we don't do any "local" handling at this stage
> 
> - or we perform the handling where we normally do it (in sys_regs.c),
>   but we start littering the already overly complicated emulation code
>   for something that is barely a trap reinjection

Hell no :)

> - or (and this is my preferred option), we treat it as a "fast" trap,
>   which would match what we do for other things that we trap and that
>   behave differently when 'InHost' (ERET, TLBIs).
> 
> This last option does require another bit of decoding, but has the
> following advantages:
> 
> - it follows the existing model for 'InHost' trap handling
> 
> - it is close to optimal from a performance perspective
> 
> - it doesn't change the existing behaviour of the xarray handling
> 
> The way I think of it, this sort of EL0->EL2 trap reinjection is
> simply the other side of the ERET coin, and I would very much like to
> keep this symmetry, unless I have missed something obvious.
> 
> What do you think?

My primary concern about stuffing more things into the fast path is the
limited debuggability since we can't use instrumentation in a
not-quite-kernel context.

I do generally agree with the intent of organizing it all similarly,
just that the traps infrastructure is _really_ handy for doing the job.

Let me take an accounting of how many other 'InHost' trap bits we have
and get a feel for if we need a generalized solution or if I can do
something PMU-specific here.

-- 
Thanks,
Oliver
