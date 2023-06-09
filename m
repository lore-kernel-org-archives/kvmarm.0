Received: from out-56.mta0.migadu.com (out-56.mta0.migadu.com [91.218.175.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E86F256D
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 14:51:18 +0000 (UTC)
Date: Fri, 9 Jun 2023 14:51:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686322274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ugtlLEv+hNjZV95DRBMsv7OADrgkWrCWZxoVXaMhWzM=;
	b=wl6Gjiblbj7fO7EYBkWbx3a+IBk/MtpnHPpaMubTxoj53g8s2Rcx5xm94W51E8Oty9MV90
	cvORNsoiQS5rS0pvl5s4vyD4mD83CYpo+bTyXAxRUZ8YydHp9RQxnxX2HDpIuwP3m6CXIO
	yTZCuO9vIGnNChBfIdcd4VlXZosEqHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Chun-Tse Shao <ctshao@google.com>
Cc: linux-kernel@vger.kernel.org, yuzhao@google.com,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ben Gardon <bgardon@google.com>,
	Gavin Shan <gshan@redhat.com>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 3/3] KVM: arm64: Using rcu_read_lock() for
 kvm_pgtable_stage2_mkyoung()
Message-ID: <ZIM8XccN31XSb+Qh@linux.dev>
References: <20230608220558.39094-1-ctshao@google.com>
 <20230608220558.39094-4-ctshao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608220558.39094-4-ctshao@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 08, 2023 at 03:05:41PM -0700, Chun-Tse Shao wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3b9d4d24c361..0f7ea66fb894 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1437,10 +1437,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  
>  	trace_kvm_access_fault(fault_ipa);
>  
> -	read_lock(&vcpu->kvm->mmu_lock);
> +	rcu_read_lock();
>  	mmu = vcpu->arch.hw_mmu;
>  	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
> -	read_unlock(&vcpu->kvm->mmu_lock);
> +	rcu_read_unlock();

What is the point of acquiring the RCU read lock here?
kvm_pgtable_walk_{begin,end}() already do the exact same for any
'shared' walk.

I agree with Marc that this warrants some very clear benchmark data
showing the value of the change. As I had mentioned to Yu, I already
implemented this for my own purposes, but wasn't able to see a
significant improvement over acquiring the MMU lock for read.

-- 
Thanks,
Oliver
