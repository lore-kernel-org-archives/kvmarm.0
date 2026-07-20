Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B096E44331D
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784566008; cv=none; b=UlvXnCLAGNyT5PlPkOQRAvq6hNEjr/whFofFmuC2XD7cbwXr6c/MvgaYSxpQ/ISAGNhnYXsNdgeUabUuaCdjXTZCrDbBNV+98bjPZkDZDN1Pb5P02bmHD0pLFQsrSBh+vu1MojDWYUAQysnXBDk7dqBHnB4CSJrRx0KO8q0EI5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784566008; c=relaxed/simple;
	bh=XIao6mIlaKS8X9ZP1wVKDebqhjcSXIh5nEXgFPo3CXA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rJOCU8MO6ccsWsHgGGUXRnjyWNYwc87qBG+E+tfgRfCBtDT8uH2kBJ/euVd48zZBPm5jeC5KMJZq3P6FW7+vKG/w3hQS0pckLPvuShaCIeWcS5jpDIpmaSuH9etfQNKRB1ynDLSqTsqG2UG7RR5JcJKyg/PpOwgSbai07vpMJ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qPxm1Tll; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qPxm1Tll"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-475417f010dso5766379f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 09:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784566000; x=1785170800; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UMSpywKxqagrBACgJFmPd3iIfkAUv2kJob+ZiosLjg0=;
        b=qPxm1TllbMa6bW3BtWr2wN68o9Qt1qvdTP430iGeV9tfEC7q0SZ8nHY47n11coFeTt
         cY2tkVgZ++yleAhfKxnDByGmEWH5dIsFWN+yjO8WP1FmzamQISryGVeWRAHsH1OUMIT/
         8WKWh/Z4pBvNfe5W0LNjsiEP6VcFOi1GwBjcYs+agNvY5W8F2H0N+VrBkfJvtvudnScW
         KLSnUWMpQY/NMuHz0o7JLcQASgDCcQg+F1zxJbJZd/u3fLm6fT7C0BimkzKR6OqxnTgD
         pCev4F0JX4CKbNAk7pKvhRHjW9dIZpkzMbsfI/PgDUdKx+v6GHGW9IO4dIgYf/98kKc1
         S4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784566000; x=1785170800;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UMSpywKxqagrBACgJFmPd3iIfkAUv2kJob+ZiosLjg0=;
        b=e7huFTftVXOD+moAlrfDRVVs4sF6va+KpuatlsyKedAnF/dm+2RdB4NHHwtA5qyLZq
         8+9xRwWl5ZTSgQ7awm0yqPaQdORwenW+6NfStsnt/7WXcxJhfhZOs+m3IPhDYD1QNIVr
         a2fnZDCGOtUYSY88I+gIfOPCEa78BOkJcTH/lbHGUmaYaD0sbRGceeocBMTcYvr+y978
         t9saSKtUwzJ/Y7/TF7uKGWSgXm2kiEJfFNGQ9j+iUeoCTcW9qTUL/UxC8JMygf8WQ0n7
         YVMePd04GGAeQijBfBf+MGDekav9Xpj3Q5hnqiUG9HjT0tbtDCMfpsQRsowM4B+M7Ez/
         CsRg==
X-Forwarded-Encrypted: i=1; AHgh+Rrz7zIS3S65rK9NiKi64bxUhfg03dlO2g2cJYeO1c595tw1ODsV4YvmIUcSk8gphYj4b05IWo8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuEz67KO0iw1BDa5iIwk3iGhXzacTQ4RvbCzKUjaQL5QN05Rz2
	Z/QKWC4P9FbGcoOEoq4tBWEvocpQ3Zi4yUy6TRk+fnLRSeyXS57x4C0rvguLXRZwlio=
X-Gm-Gg: AR+sD138ZvLmtpZm4j01TlUzHsh+bRXhJIHSHaL3ksE3iUGa+BlTEP6mWb5G2mFO9eJ
	kODFSqUSXhsiOACKhT7IEqXVvaqMVLo4hPutUgT4ht9pgcmqQgP120pCGr4bW8tOowQtiTjdALh
	ax/z/THjR9qt2nDrBoxDf0qShk08TMzYZOyR0Tvxw83ZLTdirPENjeGvcwDW+Tk+NqCu/XdhsJY
	eExPHC4x4R6YAs2Q7RJWvoxP90cdcOt6nzWJoF4SeVNbUag9A75AviC0SUbICkPAPapjt5/mpnE
	Fbu9aah46GK8rzv98xtILzKAfe+uIC18lmt3PpDkOwc2Lqcezo6b/d8vGWTz3/ipPJBMn153Eau
	pT2l+Sk3aKaFpEk20atCVj3vFRLG56LVkKUwOmePR7PpmvCWPiHWLtPDuBNqpOtp+gf/ibBkUZx
	zroaJtypg=
X-Received: by 2002:a05:6000:4310:b0:47d:ecaa:3f97 with SMTP id ffacd0b85a97d-47f6233db68mr17307845f8f.45.1784566000150;
        Mon, 20 Jul 2026 09:46:40 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e496afsm32530307f8f.1.2026.07.20.09.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 09:46:39 -0700 (PDT)
Message-ID: <3fc867c3-67a0-4fdd-b871-f2ba4d642f1f@linaro.org>
Date: Mon, 20 Jul 2026 17:46:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: James Clark <james.clark@linaro.org>
Subject: Re: [PATCH 11/21] KVM: arm64: Context swap Partitioned PMU guest
 registers
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
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260612192909.1153907-1-coltonlewis@google.com>
 <20260612192909.1153907-12-coltonlewis@google.com>
Content-Language: en-US
In-Reply-To: <20260612192909.1153907-12-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/06/2026 20:28, Colton Lewis wrote:
> Save and restore newly untrapped registers that can be directly
> accessed by the guest when the PMU is partitioned.
> 
> * PMEVCNTRn_EL0
> * PMCCNTR_EL0
> * PMSELR_EL0
> * PMCR_EL0
> * PMCNTEN_EL0
> * PMINTEN_EL1
> 
> If we know we are not partitioned (that is, using the emulated vPMU),
> then return immediately. A later patch will make this lazy so the
> context swaps don't happen unless the guest has accessed the PMU.
> 
> PMEVTYPER is handled in a following patch since we must apply the KVM
> event filter before writing values to hardware.
> 
> PMOVS guest counters are cleared to avoid the possibility of
> generating spurious interrupts when PMINTEN is written. This is fine
> because the virtual register for PMOVS is always the canonical value.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm/include/asm/arm_pmuv3.h |   4 +
>   arch/arm64/kvm/arm.c             |   2 +
>   arch/arm64/kvm/pmu-direct.c      | 183 +++++++++++++++++++++++++++++++
>   include/kvm/arm_pmu.h            |  16 +++
>   4 files changed, 205 insertions(+)
> 

[...]

> +
> +/**
> + * kvm_pmu_put() - Put untrapped PMU registers
> + * @vcpu: Pointer to struct kvm_vcpu
> + *
> + * Put all untrapped PMU registers from the VCPU into the PCPU. Mask
> + * to only bits belonging to guest-reserved counters and leave
> + * host-reserved counters alone in bitmask registers.
> + */
> +void kvm_pmu_put(struct kvm_vcpu *vcpu)
> +{
> +	struct arm_pmu *pmu;
> +	unsigned long guest_counters;
> +	unsigned long flags;
> +	u64 mask;
> +	u8 i;
> +	u64 val;
> +
> +	/*
> +	 * If we aren't guest-owned then we know the guest is not
> +	 * accessing the PMU anyway, so no need to bother with the
> +	 * swap.
> +	 */
> +	if (!kvm_pmu_is_partitioned(vcpu->kvm))
> +		return;
> +
> +	preempt_disable();
> +
> +	pmu = vcpu->kvm->arch.arm_pmu;
> +	guest_counters = kvm_pmu_guest_counter_mask(pmu);
> +
> +	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
> +		if (i == ARMV8_PMU_CYCLE_IDX)
> +			val = read_pmccntr();
> +		else
> +			val = read_pmevcntrn(i);
> +
> +		__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, val);
> +	}
> +
> +	val = read_sysreg(pmselr_el0);
> +	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
> +
> +	val = read_sysreg(pmcr_el0);
> +	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, val);
> +
> +	/* Mask these to only save the guest relevant bits. */
> +	mask = kvm_pmu_guest_counter_mask(pmu);
> +
> +	val = read_sysreg(pmcntenset_el0);
> +	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
> +
> +	val = read_sysreg(pmintenset_el1);
> +	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
> +
> +	/* Save pending guest hardware overflows. */
> +	local_irq_save(flags);
> +	val = read_sysreg(pmovsset_el0);
> +	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
> +	write_sysreg(val & mask, pmovsclr_el0);
> +	local_irq_restore(flags);
> +
> +	/* Stop guest counters and disable interrupts in hardware. */
> +	write_sysreg(mask, pmcntenclr_el0);
> +	write_sysreg(mask, pmintenclr_el1);
> +
> +	kvm_pmu_set_guest_counters(pmu, 0);

Hi Colton,

This function doesn't get added until "KVM: arm64: Apply dynamic guest 
counter reservations" a few commits later.

kvm_pmu_guest_counter_mask() is also used in a commit before it's added.

