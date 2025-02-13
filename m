Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D9A11CAF
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 04:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739422800; cv=none; b=t1IsmGnAYQK5RMUM8RCLmJTRq0y48aXNhl+NoVSeZyJ7MYgztFxLILjCcLjYUKSajNY/l6WrEIXQZoqhMOJRtsczuvRy7HxafeZyDpNKqbpK25QpGdH2pggxHBJjaXguHklctu6BXiiE6FJN1/3+fqLdXz0pG1jQRxll0+Vd7kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739422800; c=relaxed/simple;
	bh=eZLJORHlbMg16Ty/8ofBrzAExQN95XvvrRtj6043rAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bt/zeN0v+yxVhoys4QZMbFs11yrpw3CwS4UiWIvXvSvYckPcJcGsSPu8gBCOMr+390H1Q9rjeUO6YhR2v0MjWXoBsNx98lywEaC1Fc6ZAJFsCHOP3B+1bUzjRGHnNxIx0L0iYsT8i3imceeCO6Fae1tJWe5OxxFyPEJFEUVGGrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BpBvj3oR; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BpBvj3oR"
Date: Wed, 12 Feb 2025 20:59:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739422795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hg+0ovnbSnDJZTuZ98LHTcj7nTMSLyKl8yiqTcFehjM=;
	b=BpBvj3oRPNxSC4NdwdyyVbzORG6QzyE0/tiBnryhTUU8/eqQ49e9bamKsN1h89wCm/Nmx4
	pFc/jBZ2rpS9lYkQCuwThacavCkTvCkthS9PlH8E46qsJjpkNOXfcffGD6Ce+UxaiCagk7
	P3vm/bG5qbQLMXfSJGWADeMzkyIwZH8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Assorted vgic fixes for 6.14
Message-ID: <Z618Rd__s7g8xWNP@linux.dev>
References: <20250212182558.2865232-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212182558.2865232-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 12, 2025 at 06:25:56PM +0000, Marc Zyngier wrote:
> Alexander, while fuzzing KVM/arm64, found an annoying set of problems,
> all stemming from the fact that the vgic can be initialised or
> destroyed in parallel with the rest of the guest still being live.
> 
> Yes, this is annoying.
> 
> This second version takes a different approach at the problem,
> plugging the glaring hole we have between vgic creation and private
> interrupt allocation.
> 
> Although this is more invasive, I'm more confident about this one than
> the initial version I posted a week ago.

Much better place now! Here's to the next pile of syzkaller bugs :)

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> Alex, I'd very much appreciate your testing on this.

I too would like to see the tires kicked before we pick this up, if it
isn't too much trouble Alex.

> Marc Zyngier (2):
>   KVM: arm64: timer: Drop warning on failed interrupt signalling
>   KVM: arm64: vgic: Hoist SGI/PPI alloc from vgic_init() to
>     kvm_create_vgic()
> 
>  arch/arm64/kvm/arch_timer.c     | 16 ++++---
>  arch/arm64/kvm/vgic/vgic-init.c | 74 ++++++++++++++++-----------------
>  2 files changed, 44 insertions(+), 46 deletions(-)
> 
> -- 
> 2.39.2
> 
