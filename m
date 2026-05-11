Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142DA3FF8B6
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778510880; cv=none; b=YLkiIrMfXg7N4rcH+GEZRcs6znjf1IYgEhHZVxTZULDCamFExI/obuElJEeX2KsBodFQC0HQv6wIAmX3X6JFsljDRO9LwdzFpwtro/ipLJQrFE5rNv9w0KnGl91J34jqQsksbxoIh2Mc7a1UitdqNWQktn8nFWRlqrwj0A9I0L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778510880; c=relaxed/simple;
	bh=iKF8FSLbp1eeIBdEg7i1+8WB8ugyhMDzVMP2Z+x3cvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=foZRYTRtTXhGf3qQjCSIuOlUynUxjRPPmTxCZhn/xL7AvPykMZM4L+8ULHWbIR0hoqv0Joj09a6dPUT0u1grEDK9lc8CqOSveuZcJ7vTMPq35pZ3u7RCTgS3aA5MAHoRMqU9MY8ifdZCWGP91YMe2orsbrSYgBmmYlc82WgdM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G01lwpuj; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G01lwpuj"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-449d6c68ed8so3819657f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1778510877; x=1779115677; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iaxiXYaFYeaH8Qp4J3ioh2j1XsATKbSVhM9o5LlP7fw=;
        b=G01lwpujH2xKsZ7vmUJ7pCPbursrXGSuUFIVwQod0cleu7tvJ3sA8/zuR/oGXM68gf
         4c2UGAWEqw/1Yqr5SlRNrO2mnwvVCqAvXW8MRhJjS44jJ+sr7od7H74PrAMV25ncT1f1
         mtnwabg1vMhGzfAxWRcnqTfM2yg8BcGDz1bGtbvffl4sx55SVGtLhm7ll2sSlvWHL92M
         llyVybs7wg9RPovHR0b5r9ahZ1/Ix5SzTf4zYZWSXb4bUL+07EJEIFdIOtda4yYBcKPC
         g2Ylb44ryke+yk8QudrySMKoSMeX9HJKu2G+axS5Q57UXyDEw1qDYO3os43kUFvYYKUk
         aC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510877; x=1779115677;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iaxiXYaFYeaH8Qp4J3ioh2j1XsATKbSVhM9o5LlP7fw=;
        b=LsHT1+mpRgErHFoZjlF+smtmbry8jasimvOyY1mvdh/eUSniVY6gHHevO2MD6Lyivv
         d7SKT/YUdntT2w62Kp8AzyE4VWp6t9oibd2fo88sPlCSjSXPNKB+9aouDRrbYuTnio3d
         fx63l0MH88ftOphiR9DaNvPDBM05lhP55Gn6bysicgnXWjKX39Y1DbHkmYvxZhY7rw5S
         KD/CdCSRzeBaSWN+RNuiW26J9zSxQinRae9q07k6d40PgtKOqaQEUV9MQlzX0Vj9RX2v
         IJBk2XMymjmc9PBSGChuhWDfkX74EapCqVQhiiBxo2mGu33XyMKExOUel5ou4L842lJv
         CjTg==
X-Forwarded-Encrypted: i=1; AFNElJ+l4XTeWdpzt0/4PGvrRODj736EL3UPLp4FJhUuy67D3Vt0mOOaAmb3GFQlGfSkUJp92G6UJpw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQL/WBdzd9q3eWy6y000d93FcZl24TLEoaICuPS3OvD7RhxsVl
	VKT9XPOKB3JaHQFBM02mbzST3srspxvu3RP20CyXMFCK6oMmvpJA9XuNzCELvgqXiBU=
X-Gm-Gg: Acq92OH1HZKSoYGlYwDAqW1GiD2jBrI3zE74coJgnaE3rgMrSqbD5taDvAAZL87jaBV
	ggBLMuMMOO1d2K1JBitOQwksK97a4WS+2AhvTu9y10sEc1YHoNBkIwym+/Sue0DkP1iiWLSRjFv
	BE0n8xZYqDaEne1nrOEWLVRooQBA56DcisKGER2hua5gcZR0E2EJe9oER2A6M05lsbfUmyarfxO
	rJ2JmE2/VySyQmSXU/BK6Lz4sZNj+UhrEN6rD9E/+f+jqTjTLxKOSJal0YgIcAYP1Q47iKM4Jg8
	dMFXkp3BQYE0+bX29KI0dIYgHnHAIPpE5r34iooxebXcSWVfoxUN2aWEfhRQ3Bfni6JoqSYs234
	eoZi4xhhYBn7tSa9St2hbuIxyYxWESEzTSF27Gya8ZbgmK8miNIMCHZLwlhDA0FLTmiS1z04AXy
	ZRDLis88ZMV2+ZyGVInSfiWEthOdH46JDgxIm77TGO9FJhkfZBCQ==
X-Received: by 2002:a05:6000:543:b0:456:e591:4b84 with SMTP id ffacd0b85a97d-456e5914b94mr9935298f8f.3.1778510876575;
        Mon, 11 May 2026 07:47:56 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a5b65sm27064913f8f.8.2026.05.11.07.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 07:47:56 -0700 (PDT)
Message-ID: <e2a7679d-e61a-43ac-a1d7-72f7e815c400@linaro.org>
Date: Mon, 11 May 2026 15:47:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/20] KVM: arm64: Apply dynamic guest counter
 reservations
To: Colton Lewis <coltonlewis@google.com>
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
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <20260504211813.1804997-1-coltonlewis@google.com>
 <20260504211813.1804997-14-coltonlewis@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260504211813.1804997-14-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 04/05/2026 10:18 pm, Colton Lewis wrote:
> Apply dynamic guest counter reservations by checking if the requested
> guest mask collides with any events the host has scheduled and calling
> pmu_perf_resched_update() with a hook that updates the mask of
> available counters in between schedule out and schedule in.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm64/kvm/pmu-direct.c  | 69 ++++++++++++++++++++++++++++++++++++
>   include/linux/perf/arm_pmu.h |  1 +
>   2 files changed, 70 insertions(+)
> 
> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 2252d3b905db9..14cc419dbafad 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -100,6 +100,73 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
>   	return *host_data_ptr(nr_event_counters);
>   }
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
> +	bitmap_copy(new_mask, cpu_pmu->hw_cntr_mask, ARMPMU_MAX_HWEVENTS);
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
> +					pr_warn_ratelimited("perf: Pinned host event squeezed out by KVM guest PMU partition\n");

Hi Colton,

I get "perf: Pinned host event squeezed out by KVM guest PMU partition" 
even with arm_pmuv3.reserved_host_counters=3 for example. I would have 
expected any non zero value to stop the warning.

I think armv8pmu_get_single_idx() needs to be changed to allocate from 
the high end host counters first. A more complicated option would be 
checking to see if there are any non-pinned counters in the host 
reserved half when a new pinned counter is opened, then swapping the 
places of the new pinned and existing non-pinned counters so pinned 
always prefer being put into the host half. But it's probably not worth 
doing that.

James

> +					break;
> +				}
> +			}
> +		}
> +	} else {
> +		/*
> +		 * Restoring to hw_cntr_mask.
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
>   /**
>    * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
>    * @pmu: Pointer to arm_pmu struct
> @@ -218,6 +285,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
>   
>   	pmu = vcpu->kvm->arch.arm_pmu;
>   	guest_counters = kvm_pmu_guest_counter_mask(pmu);
> +	kvm_pmu_set_guest_counters(pmu, guest_counters);
>   	kvm_pmu_apply_event_filter(vcpu);
>   
>   	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
> @@ -319,5 +387,6 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
>   	val = read_sysreg(pmintenset_el1);
>   	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
>   
> +	kvm_pmu_set_guest_counters(pmu, 0);
>   	preempt_enable();
>   }
> diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
> index f7b000bb3eca8..63f88fec5e80f 100644
> --- a/include/linux/perf/arm_pmu.h
> +++ b/include/linux/perf/arm_pmu.h
> @@ -75,6 +75,7 @@ struct pmu_hw_events {
>   
>   	/* Active events requesting branch records */
>   	unsigned int		branch_users;
> +	bool host_squeezed;
>   };
>   
>   enum armpmu_attr_groups {

