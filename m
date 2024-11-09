Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12729CF4
	for <kvmarm@lists.linux.dev>; Sat,  9 Nov 2024 17:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731172392; cv=none; b=nojbpiFYArM2x26ipMZr1m8XWZqMvLAEe5Ixqi6Bf3WKyGlI/g+qbV+JeBW7BY/Lf6SBPjGWfMJxUhhPUwsyHYeTyDPQxMvyBkTfd2UbnkhMnAr6+Btji2PGhR4lMF3kyXg20BMEoQ2Xcdq+cOvmj7rHoWQ8rgPCDtvajzsHB5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731172392; c=relaxed/simple;
	bh=1sF1CfzCNwx7wRmUBuJq/O6vFlYZewAS1XnOLETNtSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eyxj7A4TvXOxIkBB7Qj0GnCU33nCYSihx4ua7pu6Q5Lt6c1hqPUqKbJOS+tqgp1WNH3A7GsCumi2PIP7X0pJoYHB0ZkrVYtBKdyihtanvE3M+RBWstsLFIylsFk+uF7jlvguCgi3s15Hb8KSXlUxoO+/SSrw9wGMUrReBPPrzOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UcqA/luM; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UcqA/luM"
Date: Sat, 9 Nov 2024 09:13:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731172388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZVJ2yKL999DAadT8Uoyu4r2k3/SbaiDSdbXd45wWVo=;
	b=UcqA/luM5PKh/BgItmAkU7joFDw+4v0WtmyrRQ76RXsWHSkxMTBY84eAOPrL00LlzQ4ots
	IhPg4Wy/Dr1aMddqzxxf+RPmNBjTd7uh+k4WeB49sntmJ06KFlTnsBW7+mLKKef5ZQ+//G
	y4pBIAJy7LFNq0XVRnukOMrUZNo+zSk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 08/15] KVM: arm64: Select debug state to save/restore
 based on debug owner
Message-ID: <Zy-YIIGzdIhwlZRQ@linux.dev>
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <20241108222418.1677420-9-oliver.upton@linux.dev>
 <861pzk1ux1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861pzk1ux1.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 09, 2024 at 11:57:46AM +0000, Marc Zyngier wrote:
> > +#define vcpu_debug_regs(vcpu)					\
> > +({								\
> > +	struct kvm_guest_debug_arch *__d;			\
> > +								\
> > +	switch ((vcpu)->arch.debug_owner) {			\
> > +	case VCPU_DEBUG_FREE:					\
> > +		WARN_ON_ONCE(1);				\
> > +		fallthrough;					\
> > +	case VCPU_DEBUG_GUEST_OWNED:				\
> > +		__d = &(vcpu)->arch.vcpu_debug_state;		\
> > +		break;						\
> > +	case VCPU_DEBUG_HOST_OWNED:				\
> > +		__d = &(vcpu)->arch.external_debug_state;	\
> > +		break;						\
> > +	}							\
> > +								\
> > +	__d;							\
> > +})
> 
> Any particular reason why this can't be an actual function? Or at
> least a function taking a kvm_ vcpu_arch as a parameter, and a
> preprocessor wrapper for the vcpu->arch pointer chasing?

None, I'll actually just throw this whole thing into debug-sr.h as a
function.

I wasn't sure if I was going to keep the tracepoints around at the time
I did this, so I needed an implementation I could use in the kernel side
of things as well.

-- 
Thanks,
Oliver
