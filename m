Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234D94A13B6;
	Tue, 22 Sep 2026 05:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790056769; cv=none; b=nOFGy1b8dDP9sUPjO7808AUI3buxVgR6SBoUKz0xaVB14KY/QGMXrDoqjAhEGepM4bU3+SxXIb4Vd1cjotKP1IqoynHiUUMf76cmSWlKbMTZ3crRm7Mp6We1rrtbwzRslcMBf9d/GcWLhwQ5nYaQUbWkQxsl0UK5KNBjIoq9F8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790056769; c=relaxed/simple;
	bh=w1JQDdlPmSHi6CzvgqcilWETunwCxK3NppQL7u//sQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rVAukOEZrDWhJcbKxNDuf1kkbszNut4LNFN/UZf2cou4nkH43Ui0c8yUnhIBXQs//j7FzoxeN9/Mi60Y5GGHdZj+fRqChmmktG5L/yQqpJ5uW7loDouvXQvadSG5WtNGRtI983ZdNfb1IrsHAlZXuxoQ4b+ztFS6SCdTOG7sakA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=bEWAp47S; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="bEWAp47S"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68M5x4KU057255
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 22 Sep 2026 14:59:05 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=6wkInr7cEVoZeTV+e/oTxw5aK0bHD5gTwzhJYnXD1CA=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1790056745; v=1;
        b=bEWAp47SNpDdPxk2xvf5pnpSfEFPmXrqKPp04n3q6vVQOuyE1GMRPiu/iIKkIfgk
         NTx0Ha3WmhUG+VHcCmniiMuAFs6wpYWHIzMEt4H2CUgJjFMZTfe2q2hXbUERH+k9
         IY97K/+KgmYdVztgM8quPlnueQh7zNy6TeivZEKvGNpG6ggTBGYwyi3txpItkGBw
         DPdvYznbnOuYdno1SLzyCikM9hK1i44OViMCTtoXEjhtUW3svXzElj9iKdIIEJh5
         bGgfKK7tn4D9y718n/ulY3QZslY1hRQFZSHsVCgUCdJi/41EUc5EpWXQ4ShBY3W6
         TKBuRqiEZPQUT9u8YYljiQ==
Message-ID: <0d065881-3d12-4750-973d-5ff6f3e10a91@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 22 Sep 2026 14:59:04 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 19/21] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920-hybrid-v11-19-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920114038.06BFF1F000FF@smtp.kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260920114038.06BFF1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/09/20 20:40, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kvm: arm64: PMU: host DoS via unprivileged user triggering TAINT_CPU_OUT_OF_SPEC
> --
> 
> commit d0f716fd067877dc7eca2170bb877659746aae89
> Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> KVM: arm64: PMU: Implement fixed-counters-only emulation
> 
> This commit adds a PMUv3 emulation mode that exposes only fixed event
> counters to the guest. It recreates the underlying host perf event dynamically
> if the vCPU thread migrates to a different physical CPU. If the destination
> CPU lacks a registered PMU implementation, it warns and adds a kernel taint.
> 
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
> [ ... ]
>> @@ -811,6 +812,32 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>>   	pmc->perf_event = event;
>>   }
>>   
>> +/**
>> + * kvm_pmu_create_perf_event - create a perf event for a counter
>> + * @pmc: Counter context
>> + */
>> +static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>> +{
>> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>> +	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
>> +
>> +	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
>> +		do {
>> +			arm_pmu = kvm_pmu_probe_armpmu(READ_ONCE(vcpu->cpu));
>> +
>> +			if (!arm_pmu) {
>> +				pr_warn_once("kvm: Unsupported PMU variation detected.\n");
>> +				add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
> 
> [Severity: High]
> Can this allow an unprivileged user to intentionally crash the host?
> 
> An unprivileged user could create a VM with fixed-counters-only enabled,
> and then use sched_setaffinity to force the vCPU thread to migrate
> to a physical CPU that does not have a probed PMU (like an asymmetric core or
> late-added CPU).
> 
> When the vCPU runs, kvm_pmu_create_perf_event() will detect the missing
> PMU and call add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK). If the host
> is configured with panic_on_taint enabled, this triggers a direct kernel
> panic.
> 
> Is there a way to return an error to userspace instead of adding a taint
> based on user-controlled thread affinity?

The commit message currently says:

 > Registered pPMUs must cover every CPU on which fixed-counters-only
 > emulation runs.

This wording may suggest that partial PMU coverage is supported, with
userspace responsible for keeping vCPUs on covered CPUs. Under that
interpretation, returning an error so userspace can adjust affinity
would make sense.

The intended requirement, however, is that registered pPMUs cover every
CPU. We do not intend to add complexity to either KVM or userspace to
support partial coverage. The taint indicates an unsupported host
configuration.

If another revision is needed, I will remove "on which
fixed-counters-only emulation runs" to make that requirement explicit.

I believe all other concerns raised by reviewers and Sashiko have now
been addressed.

Regards,
Akihiko Odaki

> 
>> +				return;
>> +			}
>> +
>> +			kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
>> +		} while (!cpumask_test_cpu(READ_ONCE(vcpu->cpu), &arm_pmu->supported_cpus));
>> +	} else {
>> +		kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
>> +	}
>> +}
>> +
> 

