Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FA719BDF
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 15:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E04C433EF;
	Thu, 25 May 2023 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685030133;
	bh=QgYFhY03eBNOXHKTIvE6AGMDieLcw0Vh3Yokc3ipvrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2Ohl0G3gHcanACbUVsaI/O6pTRv6WE9jRIG7pzPtvxXMK8eSn7XWd1DHBCAWSgGW
	 qcEEisb4isdfqIa49hRxhX7SrUn18nHWHVbnXVWrvH3Ka2IVR8SXE/Xh5VSQH0KEJi
	 3AUXWNZb5iL82IgyYPxSu9Ot7uY9fhD/k+lc5OyIWpFRsEHMpWJFGh2VGwMqV1AVg8
	 JlHM7MJWaSIEYxFJclsFZG9Fpuc0ovxJSCDaGmcY6wM/RhW7UwqoIggzycEYi6c43k
	 xnaa8D+j1Jp2Xgw0uLktLDydu7tsr/YN77bo7t/JQIelr77AS0laXoBuqEnA3O1pW/
	 Ld/pCgvwa16uQ==
Date: Thu, 25 May 2023 08:55:30 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>, peterz@infradead.org,
	namhyung@kernel.org, eranian@google.com, acme@kernel.org,
	mark.rutland@arm.com, jolsa@kernel.org, irogers@google.com,
	bp@alien8.de, kan.liang@linux.intel.com, adrian.hunter@intel.com,
	maddy@linux.ibm.com, x86@kernel.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandipan.das@amd.com, ananth.narayan@amd.com,
	santosh.shukla@amd.com, maz@kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 3/4] perf/core: Remove pmu linear searching code
Message-ID: <20230525155530.GA546949@dev-arch.thelio-3990X>
References: <20230504110003.2548-1-ravi.bangoria@amd.com>
 <20230504110003.2548-4-ravi.bangoria@amd.com>
 <20230524214133.GA2359762@dev-arch.thelio-3990X>
 <f02c78e2-34b9-4985-640a-279dae1004a9@amd.com>
 <ZG8KLbZSECiYaKFc@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG8KLbZSECiYaKFc@linux.dev>

On Thu, May 25, 2023 at 07:11:41AM +0000, Oliver Upton wrote:
> On Thu, May 25, 2023 at 10:46:01AM +0530, Ravi Bangoria wrote:
> > On 25-May-23 3:11 AM, Nathan Chancellor wrote:
> > > My apologies if this has already been reported or fixed already, I did a
> > > search of lore.kernel.org and did not find anything. This patch as
> > > commit 9551fbb64d09 ("perf/core: Remove pmu linear searching code") in
> > > -next breaks starting QEMU with KVM enabled on two of my arm64 machines:
> > > 
> > > $ qemu-system-aarch64 \
> > >     -display none \
> > >     -nodefaults \
> > >     -machine virt,gic-version=max \
> > >     -append 'console=ttyAMA0 earlycon' \
> > >     -kernel arch/arm64/boot/Image.gz \
> > >     -initrd rootfs.cpio \
> > >     -cpu host \
> > >     -enable-kvm \
> > >     -m 512m \
> > >     -smp 8 \
> > >     -serial mon:stdio
> > > qemu-system-aarch64: PMU: KVM_SET_DEVICE_ATTR: No such device
> > > qemu-system-aarch64: failed to set irq for PMU
> > > 
> > > In the kernel log, I see
> > > 
> > > [   42.944952] kvm: pmu event creation failed -2
> > > 
> > > I am not sure if this issue is unexpected as a result of this change or
> > > if there is something that needs to change on the arm64 KVM side (it
> > > appears the kernel message comes from arch/arm64/kvm/pmu-emul.c).
> > 
> > Thanks for reporting it.
> > 
> > Based on these detail, I feel the pmu registration failed in the host,
> > most probably because pmu driver did not pass pmu name while calling
> > perf_pmu_register(). Consequently kvm also failed while trying to use
> > it for guest. Can you please check host kernel logs.
> 
> The PMUv3 driver does pass a name, but it relies on getting back an
> allocated pmu id as @type is -1 in the call to perf_pmu_register().
> 
> What actually broke is how KVM probes for a default core PMU to use for
> a guest. kvm_pmu_probe_armpmu() creates a counter w/ PERF_TYPE_RAW and
> reads the pmu from the returned perf_event. The linear search had the
> effect of eventually stumbling on the correct core PMU and succeeding.
> 
> Perf folks: is this WAI for heterogenous systems?
> 
> Either way, the whole KVM end of this scheme is a bit clunky, and I
> believe it to be unneccessary at this point as we maintain a list of
> core PMU instances that KVM is able to virtualize. We can just walk
> that to find a default PMU to use.
> 
> Not seeing any issues on -next with the below diff. If this works for
> folks I can actually wrap it up in a patch and send it out.

I can start QEMU on both the machines that had issues and my machines
continue to run without any visible issues but I have never done any
profile work within them. If there is any further testing or validation
that I should do, I am more than happy to do so. Until then, consider
it:

Tested-by: Nathan Chancellor <nathan@kernel.org>

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 45727d50d18d..cbc0b662b7f8 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -694,47 +694,26 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
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
> +	struct arm_pmu *arm_pmu = NULL, *tmp;
> +	struct arm_pmu_entry *entry;
> +	int cpu;
>  
> -	event = perf_event_create_kernel_counter(&attr, -1, current,
> -						 kvm_pmu_perf_overflow, &attr);
> +	mutex_lock(&arm_pmus_lock);
> +	cpu = get_cpu();
>  
> -	if (IS_ERR(event)) {
> -		pr_err_once("kvm: pmu event creation failed %ld\n",
> -			    PTR_ERR(event));
> -		return NULL;
> -	}
> +	list_for_each_entry(entry, &arm_pmus, entry) {
> +		tmp = entry->arm_pmu;
>  
> -	if (event->pmu) {
> -		pmu = to_arm_pmu(event->pmu);
> -		if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
> -		    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> -			pmu = NULL;
> +		if (cpumask_test_cpu(cpu, &tmp->supported_cpus)) {
> +			arm_pmu = tmp;
> +			break;
> +		}
>  	}
>  
> -	perf_event_disable(event);
> -	perf_event_release_kernel(event);
> +	put_cpu();
> +	mutex_unlock(&arm_pmus_lock);
>  
> -	return pmu;
> +	return arm_pmu;
>  }
>  
>  u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
> 
> -- 
> Thanks,
> Oliver
