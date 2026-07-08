Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904E83F7A84
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 08:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783498236; cv=none; b=iaSfeWhbXsfXDWiNd6bwJRZoaaAMz2Vg+BXosX98smSUrWMnyemCNXRW1ajP0OG6WjD8m5T2bwNwztP8d5bL9Cu3NivkS8dWD9c33/TKDgu7WDu3cpjiMPwqwUowz3XFigHQcSe+9TZOMwlYsy9cdu30o9ereWmTM3J4zHihm8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783498236; c=relaxed/simple;
	bh=42ZnsNEzYU3qeOHMIxvJnRrAOG+XDR4kOm+vyUij7Ko=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gOnDNN+NuJ/Nai2uJ/REYAQns8vFwuLGrJvnrszlvmsMwDEACouVmnaQ7kkYiwL0QiDbFVpM4MpzdMdE24KzEkPwn0r7VdqVP07AJfqSyH8tG2zCikP9rgHe+8qQK2jVk0Bb7LLT/UgOeSySRnzJG5wUMIBNCjUIvc5IA7ESwxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cZ5Mo1cT; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cZ5Mo1cT"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=47j1tF26x6yEbj/B+EdsoVKcuds2e4qIDMPTidVXRP4=;
	b=cZ5Mo1cTlxIyNqwxhoF5dogAW8csvXRhcbfaU+tjzIdKJvQ1L7fwjbbBToUf1lkpvMBN82aXh
	es5eKyFp/PcASbMIPD+R2fBp8abjeHWeCJCR4eszQDyRdygM9Jkc9GV41izViCtZT9L23FXu8Kn
	mhWhk9Ju4xk2eVJ1VJjvhtE=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gw9X60kprz1K9XX;
	Wed,  8 Jul 2026 16:01:10 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id DB8624055B;
	Wed,  8 Jul 2026 16:10:22 +0800 (CST)
Received: from kwepemq500001.china.huawei.com (7.202.195.224) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 8 Jul 2026 16:10:20 +0800
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemq500001.china.huawei.com (7.202.195.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 8 Jul 2026 16:10:19 +0800
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
To: Oliver Upton <oupton@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, "guoyang (C)" <guoyang2@huawei.com>,
	"huanglingyan (A)" <huanglingyan2@huawei.com>, "Wangzhou (B)"
	<wangzhou1@hisilicon.com>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
 <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
 <292b5734-9005-6db0-da08-3da04628e620@huawei.com>
 <86o6gkpokm.wl-maz@kernel.org>
 <21eb51aa-443c-4d08-b4dd-3f813bbc9880@huawei.com>
 <86jyr8pkw8.wl-maz@kernel.org>
 <5685cdb9-95d8-9ead-4d24-d6ad06dd9547@huawei.com>
 <akvKvePWiu4pB47Q@J2N7QTR9R3.cambridge.arm.com>
 <7d97b19a-ef56-dea1-cd99-056e0e34a7fa@huawei.com>
 <akyeWPzrMDuAGRXP@kernel.org>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <007d69fe-9554-b9c1-dd89-23856d78571b@huawei.com>
Date: Wed, 8 Jul 2026 16:10:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <akyeWPzrMDuAGRXP@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500001.china.huawei.com (7.202.195.224)



On 7/7/2026 14:36, Oliver Upton wrote:
> On Tue, Jul 07, 2026 at 10:41:35AM +0800, Tangnianyao wrote:
>> On 7/6/2026 23:33, Mark Rutland wrote:
>>> If *both* of the vCPUs set TTBRn_EL1.CnP, then surely that is
>>> indistinguishable from physical CPUs:
>>>
>>>     PE0(core0,smt0)         PE1(core0,smt1)
>>>     cpu0 va->pa0        
>>>                             cpu1 flush local tlb
>>>                             cpu1 modify desc to va->pa1
>>>     cpu0 hit *va->pa1*
>>>
>>> Mark. 
>>>
>>> .
>>>
>> Thanks for the clarification.
>> Stage-1 CnP determines whether Stage-1 translation entries may be shared
>> across vCPUs, and the hardware is responsible for enforcing the
>> architectural semantics.
>>
>> Given that, why does KVM still need to guarantee that TLBs are private to
>> each vCPU?
>>
>> Assuming VTTBR_EL2.CnP == 1:
>> If TTBRx_EL1.CnP == 1, the guest is responsible for ensuring that the
>> translations referenced by TTBRx_EL1 are shareable, as required by the
>> architecture.
>> If TTBRx_EL1.CnP == 0, the hardware must ensure that Stage-1 translations
>> are not shared, again according to the architectural definition.
>>
>> The reason I'm asking is the potential performance impact. In a scenario
>> where multiple vCPUs of the same VM are scheduled onto a single PE, this
>> TLB flush may prevent a vCPU from reusing its previously populated
>> translation entries, potentially increasing TLB misses.
> The problem is you can't infer the state of the TLB based on the current
> value of CnP at stage-1. CnP only applies to the current TTBR;
> nothing stops the guest from using a mix of CnP=0/1 for different TTBRs.
>
> KVM still needs to invalidate in the case that the PE retained a CnP=0
> TLB entry for a different stage-1 context than the one configured at
> the time of vcpu_load().
>
> Thanks,
> Oliver
> .
>

Thanks for the explanation. When the guest uses `Stage-1 CnP = 0`, kvm
does need the flush to maintain the "private to each vCPU" guarantee.

Thanks,
Nianyao Tang
