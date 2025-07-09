Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A3E182
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 02:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752026932; cv=none; b=lQnB9OrxhT9Ej2ZS6yZaPUN87v1M07932oiuazHEVQ3a5IATAU3ALbGpStcVBIB8N9GZHcOdAo/5WFAl8tu7is4hiIxDO4buJCGKXXnsBSBjnZ3PljLj1lzEwxitEywfCMewB/1ejLCGw8Zzs4RHUgDB3yIT1fWB4aFebVXnbko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752026932; c=relaxed/simple;
	bh=666wrzJmzcf3+flfduB1n6PNzaeqDo4+8uaJkkv6hLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sn4sM1D5nSh0maIDZ+4GBaNLn/D2tWUv9SSszj+WuPd8ntmmRcm9c/DZcmcFSZmjXaBvznNYY7VnL2HtcM5QUNW1TapQnpPpVxq2Dmv/WbDQ3KjN+EorKngH3PgyWbD8V162eOGtGMLdxNvmGHihLQRkakh46gawLiIRUQz4QqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4bcLvG3Ym0z2BcpJ;
	Wed,  9 Jul 2025 10:06:50 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 142041800D0;
	Wed,  9 Jul 2025 10:08:46 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 9 Jul 2025 10:08:45 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 9 Jul 2025 10:08:43 +0800
Message-ID: <225bc7df-e08f-6bd9-4cb6-a2104b553823@hisilicon.com>
Date: Wed, 9 Jul 2025 10:08:42 +0800
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
 <0b54db94-8a6f-cea0-a6f7-dbe8650d66dd@hisilicon.com>
 <86h5zwba5i.wl-maz@kernel.org>
 <ffd3fccc-af4a-6667-3cf6-a55e866f3057@hisilicon.com>
 <864ivtbll0.wl-maz@kernel.org>
 <73ee91b8-ba15-2534-ab76-f64e59261b1e@hisilicon.com>
 <86sej6alxo.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <86sej6alxo.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/7/8 20:47, Marc Zyngier wrote:
> On Tue, 08 Jul 2025 13:05:24 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> On 2025/7/3 18:44, Marc Zyngier wrote:
>>> On Wed, 02 Jul 2025 10:57:13 +0100,
>>> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>>>
>>>> However，migration between different KVMs will be broken :(
>>>> I am not sure that should we consider this case as well?
>>>
>>> This isn't optional. You cannot break migration on existing systems,
>>> and the only case that *must* break is to restore a VM that hasn't
>>> seen this limitation on a HW that enforces it.
>>
>> So the whole story is that we should let GICD_TYPE.num_LPIs as a
>> writable field, and set this field from VMM(e.g. QEMU). And it will
>> be failed if doing migration between VMs with different num_LPI
>> configurations.
> 
> Note that on a non-broken system, setting num_LPIs to any value should
> always work.
> 
>> After above done, this errata could be added.
> 
> Which would be the only case where num_LPIs wouldn't be writable, and
> set to a fixed value.
> 
> Note that an alternative would be to not have a kernel erratum, but to
> force num_LPIs from userspace when running on your platform. But that
> implies that: you have your own, non-upstream VMM, and that there is
> no opportunity for userspace to adversely impact the system as a whole.

Got it. Seems it is better to have this erratum in kernel.

> 
>> Not sure my thought above is right? I will try to prepare a num_LPIs
>> writable patch if the direction is right.
> 
> I think you got the gist of it.

Thanks a lot for the whole discussion, I will prepare the new patch.

Best,
Zhou

> 
> Thanks,
> 
> 	M.
> 
