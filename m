Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCE7E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 00:11:24 +0000 (UTC)
Date: Thu, 13 Apr 2023 00:11:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681344683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/xuOUgwS7TiFTRCp7ny40dhXaDJWfispO1TUSx/Mbis=;
	b=b+vcXBq5wvyopZkHQAHD0NtZXphddOBWAPktMo4f69NnKfebtEF46yZUg7HUtmelvVLg1R
	doFyHmUTgqvYxljC5p+HVfGeT8UFIA4tMXL/xhSC+ft+cDOUQoZ/O4Hfe1IBlV/paD9HiY
	VcFtRAjNPuZqRduARLxik/Pl0nqtX2U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: arm64: vhe: Synchronise with page table
 walker on MMU update
Message-ID: <ZDdIp3j1r5ym4nb4@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-5-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 08, 2023 at 05:04:26PM +0100, Marc Zyngier wrote:
> Contrary to nVHE, VHE is a lot easier when it comes to dealing
> with speculative page table walks started at EL1. As we only change
> EL1&0 translation regime when context-switching, we already benefit
> from the effect of the DSB that sits in the context switch code.
> 
> We only need to take care of it in the NV case, where we can
> flip between between two EL1 contexts (one of them being the virtual
> EL2) without a context switch.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
