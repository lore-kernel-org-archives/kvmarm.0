Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4B035C183
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 09:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781600881; cv=none; b=oNL25Acp1bBeLRZrOPzuvDTEO4hvDfQNYqUx247lhad4vleJuh+Af+5d1sNTYXNHWaQmOwuB9ZQJOqyKul4aSgVYw51uc7RQxgfigmPHCbPPmc1iqQgsdsR09GbUPSQlG9v2+tAfUBWAZAJbasY0Q1aYt4DJnWEm9C51mNp9oZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781600881; c=relaxed/simple;
	bh=s4SMwKlC/vOKKlZaGssZALB68bILzCaOblVSJpSShi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QoZ8rfxdRCagwyamhQvt+P3+XHRehoPc2pqC4wAXUgPVafkMGMJN2S5hGbaqWK9DkGM7ESRrQjrxNYuDyJmaK1Va14RQjg6kole5mRMb/57xOPNeObSpfn1+xzF0qK0zj8rdRlzdQFfnxGFbcRlOWt54d+s+SjRe2jwH76IMOEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ptQ3lVuP; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ptQ3lVuP"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sU3QkWiFrN4SZorLI8GgUb3+KhkdTqA+waJhyvDUrRY=;
	b=ptQ3lVuPq4HoFoxQoiDf81+5iqfP5Xi9RbH0Mjcou6X98sDc9Nc6dVXQKiJQlcbUwpkUzFi8+
	vowuf4jlqCC/8z8m/3YdsDMiWEFdTSsI9S5uau1II6Obp9meNJfyS9gpltVfJ2rPdgG9HOzvZIq
	VXJXF4bKX8ns5TqH2ovoIjY=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gfgt10GB9z1K9D8;
	Tue, 16 Jun 2026 16:59:53 +0800 (CST)
Received: from kwepemo100012.china.huawei.com (unknown [7.202.195.139])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B03A405D2;
	Tue, 16 Jun 2026 17:07:49 +0800 (CST)
Received: from [10.67.120.222] (10.67.120.222) by
 kwepemo100012.china.huawei.com (7.202.195.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 16 Jun 2026 17:07:48 +0800
Message-ID: <df30b9e0-6938-47f5-bb5d-5b1e67c8879c@huawei.com>
Date: Tue, 16 Jun 2026 17:07:48 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/20] KVM: arm64: Enforce PMU event filter at
 vcpu_load()
To: Colton Lewis <coltonlewis@google.com>, <kvm@vger.kernel.org>
CC: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Russell King
	<linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, Shuah Khan
	<shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Clark <james.clark@linaro.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-perf-users@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, wangyushan <wangyushan12@huawei.com>,
	<fanghao11@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
References: <20260504211813.1804997-1-coltonlewis@google.com>
 <20260504211813.1804997-12-coltonlewis@google.com>
From: wuyifan <wuyifan50@huawei.com>
In-Reply-To: <20260504211813.1804997-12-coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo100012.china.huawei.com (7.202.195.139)

Hi Colton,

On 5/5/2026 5:18 AM, Colton Lewis wrote:
> +	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
> +		if (i == ARMV8_PMU_CYCLE_IDX) {
> +			val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
> +			evsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
> +		} else {
> +			val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> +			evsel = val & kvm_pmu_event_mask(vcpu->kvm);
> +		}
> +
> +		guest_include_el2 = (val & ARMV8_PMU_INCLUDE_EL2);
> +		val &= ~evtyper_clr;
> +
> +		if (unlikely(is_hyp_ctxt(vcpu)) && guest_include_el2)
> +			val &= ~ARMV8_PMU_EXCLUDE_EL1;
> +
> +		if (vcpu->kvm->arch.pmu_filter &&
> +		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
> +			val |= evtyper_set;
> +
> +		if (i == ARMV8_PMU_CYCLE_IDX) {
> +			write_sysreg(val, pmccntr_el0);
This should be pmccfiltr_el0.
Writing the filter bits to pmccntr_el0 would corrupt the cycle count value.
> +		} else {
> +			write_sysreg(i, pmselr_el0);
> +			write_sysreg(val, pmxevtyper_el0);
> +		}
> +	}
> +}
Thanks,
Yifan
