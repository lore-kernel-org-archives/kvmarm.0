Received: from out-3.mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63077AD26
	for <kvmarm@lists.linux.dev>; Thu,  6 Apr 2023 16:56:38 +0000 (UTC)
Date: Thu, 6 Apr 2023 16:56:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680800196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hWGOnY/KsMmqLwQwCb4u5bdX0ysrjDAt55lAt16ploc=;
	b=NkEI1OIm2rU+3hnzMAsNu8DP68SPnZe0M2ge3UVbzLNf1YONeH1Gi8YIQLAloNq3dSiNlY
	ffsdK8Z+2FqZ8aeK5SPUHLcgJGXlXWPdDURaPVXEphxj5lPLstWvPVXSs3pKOYa+VPRwQN
	LJKwv5rO9zKBmeN5t4cCCkAEV8t10QU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: nvhe: Synchronise with page table walker
 on MMU update
Message-ID: <ZC75v6kEe06omSc6@linux.dev>
References: <20230330100419.1436629-1-maz@kernel.org>
 <20230330100419.1436629-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330100419.1436629-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Thu, Mar 30, 2023 at 11:04:18AM +0100, Marc Zyngier wrote:
> When taking an exception between the EL1&0 translation regime and
> the EL2 translation regime, the page table walker is allowed to
> complete the walks started from EL0 or EL1 while running at EL2.
> 
> It means that altering the system registers that define the EL1&0
> translation regime is fraught with danger *unless* we wait for
> the completion of such walk with a DSB (R_LFHQG and subsequent
> statements in the ARM ARM). We already did the right thing for
> other external agents (SPE, TRBE), but not the PTW.
> 
> In the case of nVHE, this is a bit involved, as there are a number
> of situations where this can happen (such as switching between
> host and guest, invalidating TLBs...).

I'm assuming that the dsb(ishst) done in some of the other TLB
invalidation handlers is sufficient, as R_LFHQG does not describe the
scope of the DSB (i.e. loads and/or stores). Nonetheless, short of any
special serialization rules, it seems probable for the PTW to have both
outstanding loads and stores.

Is there some other language in the architecture that speaks to the
effects of _any_ DSB on the PTW? I couldn't find it myself. In any case,
I'll have to take you at your word if you say it is sufficient :)

-- 
Thanks,
Oliver
