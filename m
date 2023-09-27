Received: from out-201.mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E403A1F611
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 08:28:27 +0000 (UTC)
Date: Wed, 27 Sep 2023 08:28:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695803306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JsXW76YQkWWd3KcbYHc5LUjz+hl6N7YHm4uh3HGSGpg=;
	b=LtQiyZ0uGVb8Rv3QD8dC2/G/zWWQ27meJIFYdXmORPcx9sijsUdn9u4ERK8b39FP/ukuy8
	BCwdmxf2jvUydfPuh8l4+/VfBqpgi+cJEQg26cLsFreEJdOvIXD9YkQ4iqFwAnVgrLYM+Y
	LbqEHZKO/CXJnfFtvt7NvdbReUkAVB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Colton Lewis <coltonlewis@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add handler for MOPS exceptions
Message-ID: <ZRPnpHwiRhrYwfSM@linux.dev>
References: <20230922112508.1774352-1-kristina.martsenko@arm.com>
 <20230922112508.1774352-2-kristina.martsenko@arm.com>
 <87sf734ofv.wl-maz@kernel.org>
 <9f731870-ed36-d2e4-378b-f7fbf338ebd6@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f731870-ed36-d2e4-378b-f7fbf338ebd6@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 25, 2023 at 04:16:06PM +0100, Kristina Martsenko wrote:

[...]

> > What is the rationale for advancing the state machine? Shouldn't we
> > instead return to the guest and immediately get the SS exception,
> > which in turn gets reported to userspace? Is it because we rollback
> > the PC to a previous instruction?
> 
> Yes, because we rollback the PC to the prologue instruction. We advance the
> state machine so that the SS exception is taken immediately upon returning to
> the guest at the prologue instruction. If we didn't advance it then we would
> return to the guest, execute the prologue instruction, and then take the SS
> exception on the middle instruction. Which would be surprising as userspace
> would see the middle and epilogue instructions executed multiple times but not
> the prologue.

I agree with Kristina that taking the SS exception on the prologue is
likely the best course of action. Especially since it matches the
behavior of single-stepping an EL0 MOPS sequence with an intervening CPU
migration.

This behavior might throw an EL1 that single-steps itself for a loop,
but I think it is impossible for a hypervisor to hide the consequences
of vCPU migration with MOPS in the first place.

Marc, I'm guessing you were most concerned about the former case where
the VMM was debugging the guest. Is there something you're concerned
about I missed?

-- 
Thanks,
Oliver
