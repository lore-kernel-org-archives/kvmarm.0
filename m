Received: from out-46.mta0.migadu.com (out-46.mta0.migadu.com [91.218.175.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7671842
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 00:00:11 +0000 (UTC)
Date: Wed, 28 Jun 2023 00:00:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687910409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L8slz7l2d2NtGk0xl0oPNP/LaUMaD5wPj4T+5f/9a5c=;
	b=c89u9EwzjV3RDnKWYFOSiAwpuuuc3LcLL3QEbjcUa0KVKYbZPi+MCK3Opz3j2o3Ih5evfw
	ehVODi85nSuBCFZf1gZh+K1EyHYFlzhx+IoRV9IuX2SY8huWA+4F312y7+t5SxdEdSpGOI
	nYbUaeynTGn+8yQ6TS8WOGBWKs6//XE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Correctly handle page aging notifiers for
 unaligned memslot
Message-ID: <ZJt4BqFmYCLXxC2N@linux.dev>
References: <20230627235405.4069823-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627235405.4069823-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 27, 2023 at 11:54:05PM +0000, Oliver Upton wrote:
> Userspace is allowed to select any PAGE_SIZE aligned hva to back guest
> memory. This is even the case with hugepages, although it is a rather
> suboptimal configuration as PTE level mappings are used at stage-2.
> 
> The arm64 page aging handlers have an assumption that the specified
> range is exactly one page/block of memory, which in the aforementioned
> case is not necessarily true. All together this leads to the WARN() in
> kvm_age_gfn() firing.
> 
> However, the WARN is only part of the issue as the table walkers visit
> at most a single leaf PTE. For hugepage-backed memory in a memslot that
> isn't hugepage-aligned, page aging entirely misses accesses to the
> hugepage beyond the first page in the memslot.
> 
> Add a new walker dedicated to handling page aging MMU notifiers capable
> of walking a range of PTEs. Convert kvm(_test)_age_gfn() over to the new
> walker and drop the WARN that caught the issue in the first place. The
> implementation of this walker was inspired by the test_clear_young()
> implementation by Yu Zhao [*], but repurposed to address a bug in the
> existing aging implementation.
> 
> Cc: stable@vger.kernel.org # v5.15
> Fixes: 056aad67f836 ("kvm: arm/arm64: Rework gpa callback handlers")
> Link: https://lore.kernel.org/kvmarm/20230526234435.662652-6-yuzhao@google.com/
> Co-developed-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Derp. I blew away my patch that had comments here.

Marc, per our discussion forever ago, I went about implementing a
dedicated walker for handling the page aging notifiers. This aligns
pretty well with the test_clear_young() changes that Yu is working on.
So much so that I repurposed some of the plumbing.

I'd like to limit backports to 5.15, as making this patch work with the
old hva-to-gfn notifier dance doesn't seem worth the effort to me.
Tested with access_tracking_perf_test.

v1: https://lore.kernel.org/kvmarm/20230111000300.2034799-1-oliver.upton@linux.dev/

--
Thanks,
Oliver
