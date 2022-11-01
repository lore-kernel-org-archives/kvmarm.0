Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ED87B
	for <kvmarm@lists.linux.dev>; Tue,  1 Nov 2022 20:46:31 +0000 (UTC)
Date: Tue, 1 Nov 2022 20:46:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1667335584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6x7DY2gFzopQuMFwkeq+iyUXN3O/bFmTMTh5Iwt6CyU=;
	b=Ntzyn+Jf1qlzNpR43HCbuxbzt104ksD0+HTq91Wbi7fM3ZJX+fuyM9zeZERcfo5B9ME3QU
	sNiBtHDKWktUciuMiYOqDL3Sx8rR8pqU4HneKRow7juwaiH+PSmc+w7NJIfezOQb25Kn7T
	1JxNVgb//P6smSrAzNQdZs3fjKuMhIU=
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
Subject: Re: [PATCH v3 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <Y2GFliAVxui9VyK2@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-10-oliver.upton@linux.dev>
 <Y2GBVML5MWXZE9Na@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2GBVML5MWXZE9Na@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221101204614.kqimwRxDINXrD-NIeaUu5fFWmyX9Rf88HNJi7E4YSak@z>

On Tue, Nov 01, 2022 at 08:28:04PM +0000, Sean Christopherson wrote:
> On Thu, Oct 27, 2022, Oliver Upton wrote:
> > There is no real urgency to free a stage-2 subtree that was pruned.
> > Nonetheless, KVM does the tear down in the stage-2 fault path while
> > holding the MMU lock.
> > 

[ copy ]

> This is _very_ misleading.  The above paints RCU as an optimization of sorts to
> avoid doing work while holding mmu_lock.  Freeing page tables in an RCU callback
> is _required_ for correctness when allowing parallel page faults to remove page
> tables, as holding mmu_lock for read in that case doesn't ensure no other CPU is
> accessing and/or holds a reference to the to-be-freed page table.

Agree, but it is still important to reason about what is changing here
too. Moving work out of the vCPU fault path _is_ valuable, though
ancillary to the correctness requirements.

> IMO, this patch should to be squashed with the previous patch, "Protect stage-2
> traversal with RCU".  One doesn't make any sense without the other.

I had split these up back when this series was a lot more gnarly and
there was too much slop in a single diff. That isn't the case any more,
so yeah I'll squash them.

[ paste ]

> > Free removed stage-2 subtrees after an RCU grace period. To guarantee
> > all stage-2 table pages are freed before killing a VM, add an
> > rcu_barrier() to the flush path.

An aside, this is flat-out wrong now.

--
Thanks,
Oliver
