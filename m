Received: from out-26.mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AECD2F7
	for <kvmarm@lists.linux.dev>; Fri, 24 Mar 2023 18:16:36 +0000 (UTC)
Date: Fri, 24 Mar 2023 18:16:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679681794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FjtAZRcYQB+WxYXahyZSw4SActJDxTb2jNLzvVaf6N4=;
	b=KiFGURPqsiOxa4c3ajiqE9o83acFTRdlPjfFzHhShyE+lz5IwbTg2HNfCFofuSCRAAGH2q
	DmEZKMj2LNkCqw0pd/pfXwXDAEO2taZ0dQ2uZTTuz1VCNTqGtuzr3y05xFcuu1/oyBLSBJ
	GAnYiV1cFwCEGDp4PBSorReYSkP/ook=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: maz@kernel.org, reijiw@google.com, dmatlack@google.com,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #2
Message-ID: <ZB3o/jsQIwS+4g4E@linux.dev>
References: <ZBPZ4D9MIsaCNDh6@thinky-boi>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBPZ4D9MIsaCNDh6@thinky-boi>
X-Migadu-Flow: FLOW_OUT

Paolo,

Pinging this PR in case you missed it, the issues around host page table walks
are particularly urgent as the race on host page table teardown has been
reproduced on some setups.

--
Thanks,
Oliver

On Thu, Mar 16, 2023 at 08:09:20PM -0700, Oliver Upton wrote:
> Hi Paolo,
> 
> Another week, another set of fixes for KVM/arm64.
> 
> Description can be found in the tag, but the teardown race when walking
> host page tables is particularly nasty and currently causing problems
> for folks. The fix is quite simple by disabling interrupts when walking
> host page tables, as the thread must be IPI'ed before the table memory
> can actually be freed.
> 
> Please pull,
> 
> Oliver
> 
> The following changes since commit 47053904e18282af4525a02e3e0f519f014fc7f9:
> 
>   KVM: arm64: timers: Convert per-vcpu virtual offset to a global value (2023-03-11 02:00:40 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.3-2
> 
> for you to fetch changes up to 8c2e8ac8ad4be68409e806ce1cc78fc7a04539f3:
> 
>   KVM: arm64: Check for kvm_vma_mte_allowed in the critical section (2023-03-16 23:42:56 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.3, part #2
> 
> Fixes for a rather interesting set of bugs relating to the MMU:
> 
>  - Read the MMU notifier seq before dropping the mmap lock to guard
>    against reading a potentially stale VMA
> 
>  - Disable interrupts when walking user page tables to protect against
>    the page table being freed
> 
>  - Read the MTE permissions for the VMA within the mmap lock critical
>    section, avoiding the use of a potentally stale VMA pointer
> 
> Additionally, some fixes targeting the vPMU:
> 
>  - Return the sum of the current perf event value and PMC snapshot for
>    reads from userspace
> 
>  - Don't save the value of guest writes to PMCR_EL0.{C,P}, which could
>    otherwise lead to userspace erroneously resetting the vPMU during VM
>    save/restore
> 
> ----------------------------------------------------------------
> David Matlack (1):
>       KVM: arm64: Retry fault if vma_lookup() results become invalid
> 
> Marc Zyngier (2):
>       KVM: arm64: Disable interrupts while walking userspace PTs
>       KVM: arm64: Check for kvm_vma_mte_allowed in the critical section
> 
> Reiji Watanabe (2):
>       KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
>       KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
> 
>  arch/arm64/kvm/mmu.c      | 99 ++++++++++++++++++++++++++++++-----------------
>  arch/arm64/kvm/pmu-emul.c |  3 +-
>  arch/arm64/kvm/sys_regs.c | 21 +++++++++-
>  3 files changed, 85 insertions(+), 38 deletions(-)
> 

-- 
Thanks,
Oliver
