Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104C9EBFF
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 23:55:41 +0000 (UTC)
Date: Wed, 9 Nov 2022 23:55:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668038136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CMDbvPwRm+rrl6bjWjpWDOlNg7vwputyd1P9f5sAr6k=;
	b=TdavPo/9nDF2eoDdQROxJ9deOixtHkiiM66l+3DB4HC/VxfCurqHMnXZgooMmawAqSAHEp
	dq3CDwbPCdQ4Y+S+dZSll286UnKJcKfKIw6vJitHvjbCJtNDshGqU2kiQYxQOu1dw535fw
	LK72OZDLP2NaLxzryR8sVaq9n09Q8Xw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2w98zPmtefJlNfa@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <Y2whaWo3SIOOMKOE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2whaWo3SIOOMKOE@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221109235531.GqyreEEht-_DAoPYPrCvyWA2FFJIuT9n7DB3CpNWVX0@z>

On Wed, Nov 09, 2022 at 09:53:45PM +0000, Sean Christopherson wrote:
> On Mon, Nov 07, 2022, Oliver Upton wrote:
> > Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> > release the RCU read lock when traversing the page tables. Defer the
> > freeing of table memory to an RCU callback. Indirect the calls into RCU
> > and provide stubs for hypervisor code, as RCU is not available in such a
> > context.
> > 
> > The RCU protection doesn't amount to much at the moment, as readers are
> > already protected by the read-write lock (all walkers that free table
> > memory take the write lock). Nonetheless, a subsequent change will
> > futher relax the locking requirements around the stage-2 MMU, thereby
> > depending on RCU.
> 
> Two somewhat off-topic questions (because I'm curious):

Worth asking!

>  1. Are there plans to enable "fast" page faults on ARM?  E.g. to fixup access
>     faults (handle_access_fault()) and/or write-protection faults without acquiring
>     mmu_lock?

I don't have any plans personally.

OTOH, adding support for read-side access faults is trivial, I just
didn't give it much thought as most large-scale implementations have
FEAT_HAFDBS (hardware access flag management).

>  2. If the answer to (1) is "yes!", what's the plan to protect the lockless walks
>     for the RCU-less hypervisor code?

If/when we are worried about fault serialization in the lowvisor I was
thinking something along the lines of disabling interrupts and using
IPIs as barriers before freeing removed table memory, crudely giving the
same protection as RCU.

--
Thanks,
Oliver
