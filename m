Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263AC2F3E
	for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 06:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751006210; cv=none; b=D2b9yscP9TEIzeTt3szCCKPf4N5PIsjLZHlqsCB6FGu+itJIi9DtP6DUmLYaPo8f0TFjVQwyX55l8LOCMRNR9G4Jl7H7r60ij9O79/f7Z7kC0hR3zCeChe31EilzrAsBP5fVPDdRD6BI29uYN6i1LlFgtNCeJHJoIQnrt0Za1VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751006210; c=relaxed/simple;
	bh=yfoxD1mvMpT0kdTLMcyGUJHKtOqp1CDhSIEAAz9GMpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=UZETSZD0ew5wJ1HfYnrQOJfKZkJZoXRDU/4epj3o+4+0kDhFJeaaWUwz5QJNSiIV6gVwcLakmbjx1yIA8ovOR2TqnQ7YYCqSPzI09rD14VABXvvnSz3nAmS98Ow6lGc7GrP8h9rcUix2QtR1vKFV41YCTpDZM/wkugrsMhwyeWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bT5MW08hzz2CfnR;
	Fri, 27 Jun 2025 14:32:39 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 688091A0188;
	Fri, 27 Jun 2025 14:36:37 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Jun 2025 14:36:37 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Jun 2025 14:36:36 +0800
Message-ID: <0b54db94-8a6f-cea0-a6f7-dbe8650d66dd@hisilicon.com>
Date: Fri, 27 Jun 2025 14:36:31 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] ARM64: errata: Add workaround for HIP10/HIP10C erratum
 162200803
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<tangnianyao@huawei.com>, <wangwudi@hisilicon.com>
References: <20250626124142.2035110-1-wangzhou1@hisilicon.com>
 <86wm8ybpk5.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <86wm8ybpk5.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/6/26 21:27, Marc Zyngier wrote:
> On Thu, 26 Jun 2025 13:41:42 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> For GICv4.0 of Hip10 and Hip10C, it has a SoC bug with vPE schedule:
>> when multiple vPEs are sending vpe schedule/deschedule commands
>> concurrently and repeatedly, some vPE schedule command may not be
>> scheduled, and it will cause the command timeout.
>>
>> The hardware implementation is that there is one GIC hardware in one CPU die,
>> which handles all vPE schedule operations one by one in all CPUs of this die.
>> The bug is that if the number of queued vPE schedule operations is more
>> than a certain value, the last vPE schedule operation will be lost.
>>
>> One possible way to solve this problem is to limit the number of vLPIs, so
>> the hardware could spend less time to scan virtual pending table when it
>> handles the vPE schedule operations, so the queued vPE schedule operations
>> will never be more than above certain value.
>>
>> Given the number of CPUs of die, and imagine there is 100 vPE schedule
>> operations per second one CPU, it can be calculated that we can limit
>> the number of vLPI to 4096 for virtual machine to avoid the issue.
>>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> ---
>>  Documentation/arch/arm64/silicon-errata.rst |  2 ++
>>  arch/arm64/Kconfig                          | 12 ++++++++++++
>>  arch/arm64/include/asm/cputype.h            |  4 ++++
>>  arch/arm64/kernel/cpu_errata.c              | 15 +++++++++++++++
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c          |  5 +++++
>>  arch/arm64/tools/cpucaps                    |  1 +
>>  include/linux/irqchip/arm-gic-v3.h          |  1 +
>>  7 files changed, 40 insertions(+)
>>
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index ae4c0593d114..495a56e9dc4b 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -81,6 +81,11 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>  		if (vgic_has_its(vcpu->kvm)) {
>>  			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
>>  			value |= GICD_TYPER_LPIS;
>> +			/* Limit the number of vlpis to 4096 */
>> +			if (cpus_have_final_cap(ARM64_WORKAROUND_HISI_162200803) &&
>> +			    kvm_vgic_global_state.has_gicv4 &&
>> +			    !kvm_vgic_global_state.has_gicv4_1)
>> +				value |= 11 << GICD_TYPER_NUM_LPIS_SHIFT;
> 
> This really doesn't solve your problem. Yes, the guest *may* honor
> this limit. But KVM doesn't care and will happily allocate 2^16 vLPIs
> if the guest asks -- there is no code enforcing this limit.

Hi Marc,

I am not sure if there is any other place guest can ask vLPI over
the limitation except for MAPTI/MAPT below?

> And even if we did. What would we do on a MAPTI command that tries to
> map a vLPI outside of the allowed range? Do we need to tell the guest
> it has screwed up?

Thanks for pointing this. Yes, we miss the lpi_nr checking in vgic_its_cmd_handle_mapi.
In fact, the fix of this errata introduces the usage of GICD.num_LPI,
so we need make related logic right as well.

I am not sure that if we could add related checking for lpi_nr in MAPTI/MAPI
as part of this errata fix, or we should add the basic support for
GICD.num_LPI before adding this errata?

Thanks,
Zhou

> 
> Thanks,
> 
> 	M.
> 
