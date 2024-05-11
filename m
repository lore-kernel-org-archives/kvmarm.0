Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB1C1BC41
	for <kvmarm@lists.linux.dev>; Sat, 11 May 2024 18:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715451362; cv=none; b=sKLOGsJ9RJ61PP9YnWDyTjrQYvHlSaflYEoARFTvOBexGw9xYTCg5+0I/oTEY6kpHTFXYXQ29G+MtOkAKjclakcZyi4pMXajLSeWxC37ECVVLKqPjjP1DA4Si+gf1WBptYkaWUj0qMMUD2mo/crppbFY+sQqwJuonQPT2qkMljw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715451362; c=relaxed/simple;
	bh=WpNr6hNodntnKcR7MWRxa31zGxMxUHB4EnQiMOlRZ0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pK8MToOaJSH3ol2zduFmglXSs+2J7nrWgZLTPKhdNSotGislF+LMAbNplo6f/hfvD+8Ik7tgnHVGYs1PDyXC45E+4cCUz+Z4xeRL9E8Ct7ZFku19UhqI6fwzcA4vU6VpJGRUQ9BAuIX4GjFjae6PQbZoovrtreDwH3lN6EILLzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RB6QaO0K; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RB6QaO0K"
Date: Sat, 11 May 2024 13:15:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715451357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C6PdZilKg3NtgXTzxUK+/FBNZHai3mrpX8SQCmkXmuQ=;
	b=RB6QaO0KV2r7n2VJGtCLvdMBt+C0c95I3MGJY5GdImIpYQ/ustBSkMBgHeTKEP9xuGOjPM
	7PY5YttgisXpgi1ngDnwOSQYYDoSbLs8WvUL/6U47mjcHRB9tBkkFOIBRjAebqGF9CEQfm
	XdTVjgznV30MdptZF0/vV2I/evxp6TA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
Message-ID: <Zj-10O_rbwnNadpZ@linux.dev>
References: <20240423150538.2103045-1-tabba@google.com>
 <20240423150538.2103045-2-tabba@google.com>
 <4ec3be32-476a-14f2-7826-2171df1c9f77@huawei.com>
 <CA+EHjTwPWP1exm_bb_bSKF154W4doZvKxk5=AqFrBkUy_UsvaQ@mail.gmail.com>
 <d1435598-9a4d-1fc0-3355-9db78e6a7e27@huawei.com>
 <CA+EHjTzoD4wXhiG-uQ2xzrZkw5fLqjdOsiE87EdY5Z1qfvF7_g@mail.gmail.com>
 <86ttj6p062.wl-maz@kernel.org>
 <CA+EHjTyFanD2R2QXy005RujcXeT3GTPRw+e4yfS77KfWbxTVRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyFanD2R2QXy005RujcXeT3GTPRw+e4yfS77KfWbxTVRg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 10, 2024 at 09:00:54AM +0100, Fuad Tabba wrote:

[...]

> > > For protected VMs, we don't want to lazily save/restore the host's
> > > fpsimd state, because that could leak information to the host that the
> > > protected guest is using fpsimd. Therefore, for protected VMs, the
> > > host fpsimd state is maintained (saved/restored) in hyp (at EL2),
> > > without the host needing to know or do anything about it.

I'm a bit confused by this statement. Isn't pKVM downstream lazily
managing fpsimd state on behalf of the host for protected guests? IOW,
don't we return to the host with traps enabled at EL2 and load state
after the trap?

> > But I think that's a regression from the current status. It looks like
> > now that the state is really private to EL2, nothing will restore the
> > FP context on exit, while this was the case before we reworked this.
> >
> > It'd be good to plug this in 6.10, as this is a regression.
> 
> You're right. I'll send a patch to fix this.

I'd be fine with a hack that *eagerly* saves/restores the fpsimd state
on every exit in protected mode for the time being. Not great, but
obviously correct and its not like protected mode is very useful
upstream to begin with.

-- 
Thanks,
Oliver
