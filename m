Received: from out-45.mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA57B3D62
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 08:41:27 +0000 (UTC)
Date: Fri, 26 May 2023 08:41:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685090485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YrvyE7ft+O1a2YmaBkGP2B4OHtGroGZVXu5T5D1iBKQ=;
	b=m4R6r3kuWQTrxP2HQ3L91XgqxrdQjWVYZ6Lcd8rVsjxaoDWKmOt+4yhW6rUr2drSe2d8kL
	LE1aeBxwZkon7g5B2e9VW59TOhw6IJsgqc5jdQ3jFhNmpBsR834NDr27n50OvLj9gXVQBK
	uU4LsnCwsl2U+a7cEJqHZEP748J8gUo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Reiji Watanabe <reijiw@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Nathan Chancellor <nathan@kernel.org>, mark.rutland@arm.com
Subject: Re: [PATCH 1/2] KVM: arm64: Iterate arm_pmus list to probe for
 default PMU
Message-ID: <ZHBwscC3aAq9KBB9@linux.dev>
References: <20230525212723.3361524-1-oliver.upton@linux.dev>
 <20230525212723.3361524-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525212723.3361524-2-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, May 25, 2023 at 09:27:21PM +0000, Oliver Upton wrote:
> To date KVM has relied on using a perf event to probe the core PMU at
> the time of vPMU initialization. Behind the scenes perf_event_init()

Oops:

s/perf_event_init/perf_init_event/

> would iteratively walk the PMUs of the system and return the PMU that
> could handle the event. However, an upcoming change in perf core will
> drop the iterative walk, thereby breaking the fragile dance we do on the
> KVM side.
> 
> Avoid the problem altogether by iterating over the list of supported
> PMUs maintained in KVM, returning the core PMU that matches the CPU
> we were called on.
> 
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/pmu-emul.c | 46 ++++++++++-----------------------------
>  1 file changed, 12 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 45727d50d18d..5deddc49e745 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -694,45 +694,23 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>  
>  static struct arm_pmu *kvm_pmu_probe_armpmu(void)
>  {
> -	struct perf_event_attr attr = { };
> -	struct perf_event *event;
> -	struct arm_pmu *pmu = NULL;
> -
> -	/*
> -	 * Create a dummy event that only counts user cycles. As we'll never
> -	 * leave this function with the event being live, it will never
> -	 * count anything. But it allows us to probe some of the PMU
> -	 * details. Yes, this is terrible.
> -	 */
> -	attr.type = PERF_TYPE_RAW;
> -	attr.size = sizeof(attr);
> -	attr.pinned = 1;
> -	attr.disabled = 0;
> -	attr.exclude_user = 0;
> -	attr.exclude_kernel = 1;
> -	attr.exclude_hv = 1;
> -	attr.exclude_host = 1;
> -	attr.config = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
> -	attr.sample_period = GENMASK(63, 0);
> +	struct arm_pmu *tmp, *pmu = NULL;
> +	struct arm_pmu_entry *entry;
> +	int cpu;
>  
> -	event = perf_event_create_kernel_counter(&attr, -1, current,
> -						 kvm_pmu_perf_overflow, &attr);
> +	mutex_lock(&arm_pmus_lock);
>  
> -	if (IS_ERR(event)) {
> -		pr_err_once("kvm: pmu event creation failed %ld\n",
> -			    PTR_ERR(event));
> -		return NULL;
> -	}
> +	cpu = smp_processor_id();
> +	list_for_each_entry(entry, &arm_pmus, entry) {
> +		tmp = entry->arm_pmu;
>  
> -	if (event->pmu) {
> -		pmu = to_arm_pmu(event->pmu);
> -		if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
> -		    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> -			pmu = NULL;
> +		if (cpumask_test_cpu(cpu, &tmp->supported_cpus)) {
> +			pmu = tmp;
> +			break;
> +		}
>  	}
>  
> -	perf_event_disable(event);
> -	perf_event_release_kernel(event);
> +	mutex_unlock(&arm_pmus_lock);
>  
>  	return pmu;
>  }
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog
> 

-- 
Thanks,
Oliver
