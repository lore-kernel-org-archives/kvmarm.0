Received: from out-208.mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9382AB3B
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ekM8vZzY"
Date: Fri, 6 Oct 2023 18:11:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696615894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L8lSHiz12Aav9oLTb3CvxyN/1lWwyX+P2/Gb3/jsWN8=;
	b=ekM8vZzYxNkS7ov34yAiI2ikVogB11+UMM8enyKgtFmPU0bJJuCG03J+tEnrvdgqESM/9n
	sQbJ/RtmtDy5DsVN276UDVnQt8i7GrUkAE2HwzwTB0DeQVs0XaUQ/Kgva1YqOcqt9cqGfQ
	240/dslRH4LQvWMLIdJzmBarVpzPiWI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Load the stage-2 MMU from vcpu_load()
 for VHE
Message-ID: <ZSBN0nAKANRHsxll@linux.dev>
References: <20231006093600.1250986-1-oliver.upton@linux.dev>
 <8634yongw3.wl-maz@kernel.org>
 <861qe8nd45.wl-maz@kernel.org>
 <86zg0vnaen.wl-maz@kernel.org>
 <86y1gfn67v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y1gfn67v.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Fri, Oct 06, 2023 at 04:03:32PM +0100, Marc Zyngier wrote:
> On Fri, 06 Oct 2023 14:33:04 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> 
> Still talking to myself! :D

Seems like you had a good bit of fun :)

> >
> > However, this isn't enough.
> > 
> > [   63.450113] Oh crap 400000435c001 vs 3000004430001
> > 
> > So there are situations where we end-up with the wrong VTTBR, rather
> > than the wrong VMID, which is even worse. Haven't worked out the
> > scenario yet, but it apparently involves being preempted by a vcpu
> > from a different VM and not doing the right thing.
> 
> Actually, no. It is the MMU notifiers kicking in and performing TLB
> invalidation for a guest while we're in the context of another. The
> joy of running 4 large VMs on a box with 2GB of RAM, basically running
> from swap.

Whelp, looks like my self-rule of no patches on the list after midnight
is in force again. Clearly this was all quite gently tested, thanks for
being the guinea pig.

> There's the sum of my hacks, which keeps the box alive.

Thanks! I'll roll it into v2 so we have something that actually works.

-- 
Thanks,
Oliver
