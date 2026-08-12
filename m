Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3680471263
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 17:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786555660; cv=none; b=gxSUbbtRSb8CDJw+KKtoqXpSqfgu9mGqgC/axhCMJyz20BJfi5pFIYLfuVepPP28wm1RoYbFeqmuSA+z9hMx2TWnmSBVAISzbdlFQExP2pIId5vf4zih+QyXaCfUp0PveBnwSiFbYdZntijQDR5cX3Xtt8ofg2J0A/Al4Md0jKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786555660; c=relaxed/simple;
	bh=WJPLHXt8itB/Cw880Ar8NhbyTTeEUpwQxfJvdcAm5iw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aQLbsfilyYZC0e2GXaHUA/kOpqQ5DOi25CmNiRT5VYWMuyZ9izBUbuviAelx7dcZMBkjU1pRFgGw6Nebs+xOkm4oNRJr/gszpFeZq2KhFRSnZYWaZ64GsIpui8Q+Y0xJLpDYXsDxH4xNq7r4d4ODVNzN8oUcZfItC5NTmK1imuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jwSvUCMl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jwSvUCMl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786555659; x=1818091659;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WJPLHXt8itB/Cw880Ar8NhbyTTeEUpwQxfJvdcAm5iw=;
  b=jwSvUCMlc5rI50YMMFht4yNKyz9ajttHHpXEoFQOMPE4k48kCMtzqw90
   VR7vDM1q37HJvMkkJiiaHds5/++lu2VhNe95kF8vpjjFLWKc+ZFDDBVN7
   hyhqACzDxM9XnD5qozg5VUHOcmSc0tjmka12CWrmKWlXkKN5VXo2DYxO+
   xm5+M/chtEhX+jkovg4pWRyPVgUMct49Wa+jf2qF9W+08FA80/KL3Ypw4
   AUK5achkseH0292SvcjE+YfOa9x/+OlWKVM24nzNLp6bPxaEteVyFvkLH
   vU4rgLTMe/yuCzWPZaXbbz6XfDrxo4Cmka7iEB8/oI636XlRjaKUd4pQ8
   A==;
X-CSE-ConnectionGUID: L3uHKZ7sSOmKn027Cu8LyA==
X-CSE-MsgGUID: fXMSWGn+RLG9inLmNYs9SA==
X-IronPort-AV: E=McAfee;i="6800,10657,11873"; a="90996222"
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="90996222"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 10:27:38 -0700
X-CSE-ConnectionGUID: e4SWaOEVTd+gRiS5EYjQbg==
X-CSE-MsgGUID: Auz9Ud84QUGgNeZ3b4NBoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="261936541"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.122.185.5]) ([10.122.185.5])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 10:27:36 -0700
Message-ID: <16296d40-67f3-4e50-923c-5b26fc122121@intel.com>
Date: Wed, 12 Aug 2026 12:27:35 -0500
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/21] KVM: arm64: Apply dynamic guest counter
 reservations
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260612192909.1153907-1-coltonlewis@google.com>
 <20260612192909.1153907-15-coltonlewis@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20260612192909.1153907-15-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/12/2026 2:29 PM, Colton Lewis wrote:
> Apply dynamic guest counter reservations by checking if the requested
> guest mask collides with any events the host has scheduled and calling
> pmu_perf_resched_update() with a hook that updates the mask of
> available counters in between schedule out and schedule in.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/arm64/kvm/pmu-direct.c  | 69 +++++++++++++++++++++++++++++++++++-
>  include/linux/perf/arm_pmu.h |  1 +
>  2 files changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 49f1feb5d280c..044f011c9c84b 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -87,6 +87,73 @@ u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
>  		ARMV8_PMU_PMCR_N);
>  }
>  
> +/* Callback to update counter mask between perf scheduling */
> +static void kvm_pmu_update_mask(struct pmu *pmu, void *data)
> +{
> +	struct arm_pmu *arm_pmu = to_arm_pmu(pmu);
> +	unsigned long *new_mask = data;
> +
> +	bitmap_copy(arm_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
> +}
> +
> +/**
> + * kvm_pmu_set_guest_counters() - Handle dynamic counter reservations
> + * @cpu_pmu: struct arm_pmu to potentially modify
> + * @guest_mask: new guest mask for the pmu
> + *
> + * Check if guest counters will interfere with current host events and
> + * call into perf_pmu_resched_update if a reschedule is required.
> + */
> +static void kvm_pmu_set_guest_counters(struct arm_pmu *cpu_pmu, u64 guest_mask)
> +{
> +	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
> +	DECLARE_BITMAP(guest_bitmap, ARMPMU_MAX_HWEVENTS);
> +	DECLARE_BITMAP(new_mask, ARMPMU_MAX_HWEVENTS);
> +	bool need_resched = false;
> +
> +	bitmap_from_arr64(guest_bitmap, &guest_mask, ARMPMU_MAX_HWEVENTS);
> +	bitmap_copy(new_mask, cpu_pmu->hw_cntr_impl, ARMPMU_MAX_HWEVENTS);
> +
> +	if (guest_mask) {
> +		/* Subtract guest counters from available host mask */
> +		bitmap_andnot(new_mask, new_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS);
> +
> +		/* Did we collide with an active host event? */
> +		if (bitmap_intersects(cpuc->used_mask, guest_bitmap, ARMPMU_MAX_HWEVENTS)) {
> +			int idx;
> +
> +			need_resched = true;
> +			cpuc->host_squeezed = true;
> +
> +			/* Look for pinned events that are about to be preempted */
> +			for_each_set_bit(idx, guest_bitmap, ARMPMU_MAX_HWEVENTS) {
> +				if (test_bit(idx, cpuc->used_mask) && cpuc->events[idx] &&
> +				    cpuc->events[idx]->attr.pinned) {
> +					pr_warn_once("perf: Pinned host event squeezed out by KVM guest PMU partition\n");
> +					break;
> +				}
> +			}
> +		}
> +	} else {
> +		/*
> +		 * Restoring to hw_cntr_impl.
> +		 * Only resched if we previously squeezed an event.
> +		 */
> +		if (cpuc->host_squeezed) {
> +			need_resched = true;
> +			cpuc->host_squeezed = false;
> +		}
> +	}
> +
> +	if (need_resched) {
> +		/* Collision: run full perf reschedule */
> +		perf_pmu_resched_update(&cpu_pmu->pmu, kvm_pmu_update_mask, new_mask);
> +	} else {
> +		/* Host was never using guest counters anyway */
> +		bitmap_copy(cpu_pmu->cntr_mask, new_mask, ARMPMU_MAX_HWEVENTS);
> +	}
> +}
> +
>  /**
>   * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
>   * @pmu: Pointer to arm_pmu struct
> @@ -209,6 +276,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
>  
>  	pmu = vcpu->kvm->arch.arm_pmu;
>  	guest_counters = kvm_pmu_guest_counter_mask(pmu);
> +	kvm_pmu_set_guest_counters(pmu, guest_counters);
>  	kvm_pmu_apply_event_filter(vcpu);
>  
>  	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
> @@ -317,7 +385,6 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
>  	/* Stop guest counters and disable interrupts in hardware. */
>  	write_sysreg(mask, pmcntenclr_el0);
>  	write_sysreg(mask, pmintenclr_el1);
> -
>  	kvm_pmu_set_guest_counters(pmu, 0);

I must have missed something.

Here, vcpu->kvm->arch.arm_pmu->cntr_mask is restored to cntr_mask_impl.
Is this same struct shared with the perf driver
(to_arm_pmu(event->pmu)), and shared across other vCPUs as well?

If so, if another pCPU still has a PMU-partition-enabled vcpu loaded
with guest-owned counters (MDCR_EL2.HPMN is set), could a host event be
scheduled onto one of those guest-owned counters, conflicting with the
guest?

>  	preempt_enable();
>  }


