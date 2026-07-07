Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C80374E42
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 02:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783392107; cv=none; b=FA8QzCu6sm4g4MyNUgxBPFaZ0/r2Ou9icINTsq80BGm8GR5z+rd9kiO9R2E8Q71QO8sRHAus1NzabLrkHS+eDNk+ZhqOKzmDD9Ls78tN5LUby6bXqV1e9/ixrMRcIgCqbzecSWLrDJql5EMMfH7M6244dIlv3ouTI53SwveFdns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783392107; c=relaxed/simple;
	bh=0HsC0zCTmL+EJAAANm6RO7WiBTjTUlFI8YMAQTT8Hys=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JstClJyjfgYCkueq/yto99rAUFT0mRM8aegp6QeBf+0kWGzyZmwn6T5DNVA1N06MmT2T+RPkqTS6QbD4niyatzVWYP8eLzOa5tIjmkk1K5DiTbACYWxDsOORppQ2QoWsF4IaIiouyDI4UmDNqxYW9r8zCllwIlytA4i0UZO/eEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=D5lqzzCj; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="D5lqzzCj"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=582ssehZuBggHrWvwnV4WymCsZ3Xyi0XLCoJ7Dsgrkk=;
	b=D5lqzzCjwEmH2rlh0kb0PeRmTsagbVwz4s4VpznnNnwi9OaJ83s30xwuC4w3yiYGljO4eRYl7
	S8g4zAs88nmaKBzWYgB3zZ28JDNBlqA9pQ8xV89wxT4denFMcVSQevn4hlyELetPMsVxOqZnv27
	pTMdvE+LIPUK8pzs9lnbcFs=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gvQHD3qqLzRhQg;
	Tue,  7 Jul 2026 10:32:24 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 7BC6440591;
	Tue,  7 Jul 2026 10:41:36 +0800 (CST)
Received: from kwepemq500001.china.huawei.com (7.202.195.224) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jul 2026 10:41:36 +0800
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemq500001.china.huawei.com (7.202.195.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jul 2026 10:41:35 +0800
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
To: Mark Rutland <mark.rutland@arm.com>
CC: Marc Zyngier <maz@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>,
	<oupton@kernel.org>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, "guoyang (C)"
	<guoyang2@huawei.com>, "huanglingyan (A)" <huanglingyan2@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
 <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
 <292b5734-9005-6db0-da08-3da04628e620@huawei.com>
 <86o6gkpokm.wl-maz@kernel.org>
 <21eb51aa-443c-4d08-b4dd-3f813bbc9880@huawei.com>
 <86jyr8pkw8.wl-maz@kernel.org>
 <5685cdb9-95d8-9ead-4d24-d6ad06dd9547@huawei.com>
 <akvKvePWiu4pB47Q@J2N7QTR9R3.cambridge.arm.com>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <7d97b19a-ef56-dea1-cd99-056e0e34a7fa@huawei.com>
Date: Tue, 7 Jul 2026 10:41:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <akvKvePWiu4pB47Q@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500001.china.huawei.com (7.202.195.224)



On 7/6/2026 23:33, Mark Rutland wrote:
> On Mon, Jul 06, 2026 at 10:15:04PM +0800, Tangnianyao wrote:
>> Two SMT threads(PE0,PE1) on the same physical core share TLB.
> Critially those are *NOT* allowed to share entries allocated with
> CnP==0, and are only allowed to share entries where CnP was enabled at
> stage 1 (and stage 2 if applicable).
>
> Please see the ARM ARM:
>
>   https://developer.arm.com/documentation/ddi0487/mc/
>
> Specifically, section D8.12.3.4 "Common not private translations":
>
>   https://developer.arm.com/documentation/ddi0487/mc/-Part-D-The-AArch64-System-Level-Architecture/-Chapter-D8-The-AArch64-Virtual-Memory-System-Architecture/-D8-16-Translation-Lookaside-Buffers/-D8-16-3-Use-of-ASIDs-and-VMIDs-to-reduce-TLB-maintenance-requirements
>
>> VM0 has 2 vcpus, vcpu0 and vcpu1 that share all architectural context
>> except the address translation context.
>>
>> Vcpu0 may observe TLB entries that are supposed to be private to vcpu1
>> in the following case:
>>
>>     PE0(core0,smt0)         PE1(core0,smt1)
>> vcpu0 load           
>> vcpu0 va->pa0        
>> vcpu0 put            
>>                                        vcpu1 load
>>                                        vcpu1 flush local tlb
>>                                        vcpu1 modify desc to va->pa1
>> vcpu0 load
>> vcpu0 hit *va->pa1*
> How is CnP managed in this example?
>
> If *either* of the vCPUs don't set TTBRn_EL1.CnP, that is not permitted
> to happen.
>
> If *both* of the vCPUs set TTBRn_EL1.CnP, then surely that is
> indistinguishable from physical CPUs:
>
>     PE0(core0,smt0)         PE1(core0,smt1)
>     cpu0 va->pa0        
>                             cpu1 flush local tlb
>                             cpu1 modify desc to va->pa1
>     cpu0 hit *va->pa1*
>
> Mark. 
>
> .
>
Thanks for the clarification.
Stage-1 CnP determines whether Stage-1 translation entries may be shared
across vCPUs, and the hardware is responsible for enforcing the
architectural semantics.

Given that, why does KVM still need to guarantee that TLBs are private to
each vCPU?

Assuming VTTBR_EL2.CnP == 1:
If TTBRx_EL1.CnP == 1, the guest is responsible for ensuring that the
translations referenced by TTBRx_EL1 are shareable, as required by the
architecture.
If TTBRx_EL1.CnP == 0, the hardware must ensure that Stage-1 translations
are not shared, again according to the architectural definition.

The reason I'm asking is the potential performance impact. In a scenario
where multiple vCPUs of the same VM are scheduled onto a single PE, this
TLB flush may prevent a vCPU from reusing its previously populated
translation entries, potentially increasing TLB misses.

Thanks,
Nianyao Tang
