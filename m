Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CB732E757;
	Wed, 30 Sep 2026 01:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790732695; cv=none; b=i7w0RR4JypqFl9PggLRbTDh3vCAXlIbIyBlSi/c+Hgq+ZNaUewwfDW2Pivs1ZbuOOkMF1+z3vNv8tOVH7qb5xm5nYssFcmZ0HGKGSPLG8iZqBqnNiB8LzRk09aV8EzZhidxcUz15cLZyYjWHJvsSYs2BUidFoM5nyY7jMpWtOMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790732695; c=relaxed/simple;
	bh=3fNq/xN0h430HQsMTd63roWjBs5boGCWu7pNTnREaH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LHj6o1XVUMS/YdWiwPCMcv179YZ59r2sd/GaXgrg8an+m7R2Xq/s6BXt2iE57uH002nBtGymkxlzDFk74WDnms24S68MJoC5hsC782AORazTALrBQMHbq1i229XqUu+DPDXJDwU4nMSW9wVXZiWkn17NuEzHrBmad67/x9xlKoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1TXQ+L1F; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1TXQ+L1F"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ihc5SseKl/AQM92jQ4PAex3Oz7TkINI/rCAtYAPWwGU=;
	b=1TXQ+L1FnKr8oEYcb9B1Fbq9njwrSCYqpr/G1tAysIuXy2dJNbk7nhVso6G4ym9pwej5aP/OE
	rQME8NVaQQF9BHW4W96ko+lL6tLRA18RkItq8lhcBsP6fropvJSXXdKt2kRP0S7mWVlX4ELd4Gs
	MUnFRpt9O8fOYKXQq51TK1Q=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hvcwm5wkyzKm4b;
	Wed, 30 Sep 2026 09:32:24 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id AC05240586;
	Wed, 30 Sep 2026 09:44:37 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 30 Sep 2026 09:44:37 +0800
Message-ID: <c624d394-d4c4-4335-9419-e83fdd0eae8f@huawei.com>
Date: Wed, 30 Sep 2026 09:44:36 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/15] KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
To: <sashiko-reviews@lists.linux.dev>
CC: <kvmarm@lists.linux.dev>, Oliver Upton <oupton@kernel.org>, Marc Zyngier
	<maz@kernel.org>, <kvm@vger.kernel.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-5-zhengtian10@huawei.com>
 <20260929105038.ED3781F000FF@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260929105038.ED3781F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/29/2026 6:50 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] kvm: arm64: host panic on nVHE due to EL1 access of EL2 sysregs in __load_stage2
> --
> 
> commit 982e8feb07630370c5da59ed6e47706db5188e18
> Author: Leonardo Bras <leo.bras@arm.com>
> Subject: KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
> 
> This commit adds a vcpu request to exit the guest, reload stage-2, and come
> back to the guest, anticipating subsequent patches for S2 HAFDBS and HDBSS.
> 
> Link: https://lore.kernel.org/all/20260901171558.2674031-5-leo.bras@arm.com/
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 0576c2022ef57..d9ad765943d9e 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
> 
> [ ... ]
> 
>> @@ -1175,6 +1175,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>   		if (kvm_dirty_ring_check_request(vcpu))
>>   			return 0;
>>   
>> +		if (kvm_check_request(KVM_REQ_RELOAD_STAGE2, vcpu)) {
>> +			unsigned long flags;
>> +
>> +			local_irq_save(flags);
>> +			__load_stage2(vcpu->arch.hw_mmu);
> 
> [Severity: Critical]
> Could this trigger a host kernel panic on systems running in nVHE or
> pKVM mode?
> 
> In nVHE or pKVM mode, the host kernel runs at EL1. The check_vcpu_requests()
> function executes from the host context. If a KVM_REQ_RELOAD_STAGE2 request
> is processed here, it calls __load_stage2(), which performs the following:
> 
> arch/arm64/include/asm/kvm_mmu.h:__load_stage2() {
>      write_sysreg(mmu->vtcr, vtcr_el2);
>      write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
>      ...
> }
> 
> Because vtcr_el2 and vttbr_el2 are EL2 system registers, writing to them
> from EL1 will cause an UNDEFINED instruction exception. This causes the CPU
> to trap to the hypervisor, which will intentionally panic upon receiving an
> unexpected sysreg trap from the host, crashing the system.
> 
> Since any unprivileged user with access to /dev/kvm could potentially trigger
> a memory region update that sets KVM_REQ_RELOAD_STAGE2, it seems this might
> provide a trivial path to trigger a host Denial of Service.
> 
> Would it be possible to add a has_vhe() guard here or handle the reload via
> a hypercall for non-VHE systems?
> 

Yes, you're right, that's my mistake. I'll add a has_vhe() guard in
check_vcpu_requests() as a defensive check, and also prevent the request
from being raised on nVHE at the source.



>> +			local_irq_restore(flags);
>> +		}
>> +
>>   		check_nested_vcpu_requests(vcpu);
>>   	}
>>
> 

