Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09393C3448
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 08:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783326368; cv=none; b=RRmLYfUKaXO4BftC18ncLu3xkieuqK9nTfAcF4Fb45QtA0JMJWUJOyQ2gNjjRtEmWmkWVJlm5lKaFXeoCVpotkbNSxXUPt/IUtBR3G8ILdnJHJCQXhy4JaBOaqOhrg90D6kZzjLgRHz0G1iiVas8rYsXOgbDX3M9UCB9ZAhQSpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783326368; c=relaxed/simple;
	bh=eo7khvNd3lFAVrArYsAcVORYTVzNouFKGa6OioR3Rjk=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rZDy2z+w4zwZ5GK+SjZ+LjQ+iKQgy6Yw+w7Ctb+rUrsRhiMJfrKaUZSGZa1IQMVnaUPOseKwDJVDf3P30+r81v5DG+qUCV9tRBpdYuj6PM2jGcs/bGKB/U9SZZaQvnZT8E0CEgF3hSzEb7gjIiYnxl7cF3KezWQo5ULuiHRG8uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=yRyhSjHm; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="yRyhSjHm"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=v4FdqJvosPko5czYRrhhNlwZrhnoPDJZNAF44CKBIgw=;
	b=yRyhSjHmg8xHc3laHVlNNk8GwIsBQ+p3A5QoB6CXkKneF229G2n/jiQBC7IZjodBiK8jF+IRK
	MUtt780CxaPMW8NHPSCzjaOL5vEL1pN/BxexONNhSzOkDmlinWz+OMaH861WRvRaR6yJV1HNiVD
	UJ41OYl5IE5yl98dYayxxes=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gtxzW1C9YzpSvQ;
	Mon,  6 Jul 2026 16:17:11 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BF20040579;
	Mon,  6 Jul 2026 16:25:47 +0800 (CST)
Received: from kwepemq500001.china.huawei.com (7.202.195.224) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 16:25:47 +0800
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemq500001.china.huawei.com (7.202.195.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 16:25:46 +0800
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
To: Marc Zyngier <maz@kernel.org>
CC: Wei-Lin Chang <weilin.chang@arm.com>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <seiden@linux.ibm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, "guoyang (C)" <guoyang2@huawei.com>,
	"huanglingyan (A)" <huanglingyan2@huawei.com>, "Wangzhou (B)"
	<wangzhou1@hisilicon.com>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
 <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
 <292b5734-9005-6db0-da08-3da04628e620@huawei.com>
 <86o6gkpokm.wl-maz@kernel.org>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <21eb51aa-443c-4d08-b4dd-3f813bbc9880@huawei.com>
Date: Mon, 6 Jul 2026 16:25:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86o6gkpokm.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500001.china.huawei.com (7.202.195.224)



On 7/6/2026 15:25, Marc Zyngier wrote:
> On Mon, 06 Jul 2026 04:30:30 +0100,
> Tangnianyao <tangnianyao@huawei.com> wrote:
>>
>>
>> On 7/6/2026 1:28, Wei-Lin Chang wrote:
>>> Hi,
>>>
>>> Let me try to answer this:
>>>
>>> On Sat, Jul 04, 2026 at 03:45:56PM +0800, Tangnianyao wrote:
>>>> Hi, all
>>>>
>>>> I'm trying to understand the TLB and I-cache invalidation in
>>>> `kvm_arch_vcpu_load()` that is intended to "guarantee that both TLBs and
>>>> I-cache are private to each vCPU".
>>>>
>>>> As I understand it, when `VTTBR_EL2.CnP == 1`, `__kvm_flush_cpu_context()`
>>>> only performs a local TLB and I-cache invalidation, which does not seem
>>>> sufficient to guarantee that property.
>>>>
>>>> In fact, even if the invalidation were extended to the Inner Shareable
>>>> domain, it still seems difficult to guarantee “TLBs and I-cache are
>>>> private to each vCPU”, when `VTTBR_EL2.CnP == 1`, as long as multiple
>>>> vCPUs from the same VM may be running concurrently on different PEs.
>>> I think you have missed that when 2 stages are involved, both stages
>>> have to set CnP == 1 in order to share TLB entries (Arm ARM R_ZVRZW).
>>> So if TLB entry sharing happens, the guest kernel must have allowed it
>>> in the first place (by setting TTBR0/1_EL1.CnP == 1), hence accidental
>>> sharing that you are worried about won't happen.
>>>
>>> __kvm_flush_cpu_context() is solving problems that occur when multiple
>>> vCPUs of a VM are multiplexed on a single physical CPU.
>> Thanks for you answer.
>>
>> If guest kernel allow TLB shared across CPUs by setting TTBR0/1_EL1.CnP == 1,
>> does kvm still need to guarantee that TLBs are private to each vCPU?
> Yes, because there is nothing that describes which physical CPUs
> actually share TLBs. So the only possible course of action is to
> ignore what the guest says and fallback to something that is safe.
>
>>>> So I have two questions:
>>>>
>>>> 1. What is the rationale behind the comment that "guarantee that both TLBs
>>>> and I-cache are private to each vCPU"?
>>> I assume you are asking why keeping both TLBs and I-cache private per
>>> each vCPU is required. The fundamental answer is that each physical CPU
>>> is expected to have its own TLB and I-cache, so we must uphold that
>>> property for vCPUs as well. vCPUs can be scheduled on the same physical
>>> CPU, and use the same physical TLB/I-cache, obviously, so extra
>>> invalidations need to be done.
>> Let's assume that both Stage-1 CnP and Stage-2 CnP are enabled.
>>
>> As I understand it, the architecture permits TLB to be shared by multiple
>> PEs within an Inner Shareable domain. Right?
>>
>> If an implementation allows TLB entries to be shared in this way, it seems
>> that the current invalidation performed by kvm would no longer be sufficient
>> to guarantee that TLBs are private to each vCPU.
> Care to explain why?
>
> The core assumption is that a TLBI take effect on all the PEs the TLB
> is shared with. If this doesn't work, then CnP is unusable, because it
> is then impossible to guarantee that a translation will be refetched
> (you could always hit in another PEs TLBs). Such an implementation
> would be terminally broken.
>
> 	M.
>
For example:
Sharing the TLB between the two SMT threads of the same physical core can
reduce hardware cost while increasing the effective TLB coverage.
A local TLBI take effect on the whole TLB shared by the two SMT threads,
with the sharing enabled by CnP.

In this scenario, enabling CnP in KVM appears to break the guarantee that
TLBs are private to each vCPU when multiple vCPUs of the same VM run
concurrently on different SMT threads of the same PE.

Thanks
Nianyao Tang
