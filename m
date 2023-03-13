Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E129879C0
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 18:04:14 +0000 (UTC)
Date: Mon, 13 Mar 2023 18:04:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678730652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQYUbvnE136yUkG/cwkOWkXNIYV1jlaCbhEZUeHbp7E=;
	b=Ik/1GQ51Np77wdQJzc9ewDSJ17t7iO+Af6WIzQFIwZdtQlCVEeJvsoGYtSqXqBs4y6pVmT
	A5w9KSDLQOeU0XytCO9Dt+dN4wDXLx8HMFOfoSIT3G/L3n/dtPvL14nrESxcR9xeCxd5uo
	jvFneSLxcu72ZtmJarrzOB049rn6dQw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: PMU: Preserve vPMC registers properly
 on migration
Message-ID: <ZA9llyTSgLcV2a1s@linux.dev>
References: <20230313032905.1474705-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313032905.1474705-1-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Reiji,

On Sun, Mar 12, 2023 at 08:29:03PM -0700, Reiji Watanabe wrote:
> The series fixes two problems in preserving vPMU counter (vPMC)
> registers (PMCCNTR_EL0/PMEVCNTR<n>_EL0) during migration.
> 
> One of the problems is that KVM may not return the current values
> of the vPMC registers for KVM_GET_ONE_REG.
> 
> The other one might cause KVM to reset the vPMC registers on the
> first KVM_RUN on the destination. This is because userspace might
> save PMCR_EL0 with PMCR_EL0.{C,P} bits set on the source, and
> restore it on the destination.
> 
> See patch-1 and patch-2 for details on these issues respectively.
> 
> The series is based on v6.3-rc2.
> 
> v2:
>  - Collect Marc's r-b tags (Thank you!)
>  - Added "Fixes:" tags
>  - Added Cc: to stable
>  - Cosmetics change (remove one line break in kvm_pmu_handle_pmcr())
> 
> v1: https://lore.kernel.org/all/20230302055033.3081456-1-reijiw@google.com/
> 
> Reiji Watanabe (2):
>   KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current
>     value
>   KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

I received both of these patches as indepentent emails instead of replies to
the cover letter (i.e. In-Reply-To header is missing). I was able to find
both patches but just wanted to let you know so you can debug your tooling.

-- 
Thanks,
Oliver
