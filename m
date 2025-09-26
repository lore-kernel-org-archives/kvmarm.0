Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BB9276028
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 07:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758870939; cv=none; b=iiGIEcUJsjQK3k3jJmUh/9y2t0MyULluusmEZzvCYZ2Vwr9ZGRRv/ZESjJ3gHg8DduHM4o3W5z9p2HK2lVpkv2nYSaMFs/4W48KvL+MY5hXr/7mH0ogBAdF7n7xqp/ScKa7JuBSi1nvFrRDNQcKfuOIJ2GT3+JYwY2FAWaP6q3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758870939; c=relaxed/simple;
	bh=pzDt3laCX4gpWoGmnSNBtd03hHaJ+z2XS3IbZ2qCNo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FFcyPsd7E62vRi3JwgufCbiYHnChYLf9xZCX3FqUc2ZfvHMzamsGh3E9X/WlC61npbko6+oMavLhqwcc0CgYduc1igeCFYb1CaAsojagowGfKrcjD7RsvulSI/0cDTPrMtdfS5b5mQybVy8qmgfyJgWSgVSI13R3AQv7ExR0Qfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cY1vX203cz2Cgn6;
	Fri, 26 Sep 2025 15:10:48 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AAF521402C4;
	Fri, 26 Sep 2025 15:15:27 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Sep 2025 15:15:27 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Sep 2025 15:15:26 +0800
Message-ID: <3d518b64-d66b-ca1e-0893-5b1f0faa17ee@hisilicon.com>
Date: Fri, 26 Sep 2025 15:15:16 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 0/4] Add workaround for HIP10/HIP10C erratum 162200802
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<oliver.upton@linux.dev>, <tangnianyao@huawei.com>, <wangwudi@hisilicon.com>,
	<liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
References: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
 <fc7763d5-bed6-ace6-ace8-a50c031cab36@hisilicon.com>
 <87wm5uxwvc.wl-maz@kernel.org>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <87wm5uxwvc.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/9/19 23:52, Marc Zyngier wrote:
> On Mon, 01 Sep 2025 11:55:49 +0100,
> Zhou Wang <wangzhou1@hisilicon.com> wrote:
>>
>> On 2025/8/25 10:39, Zhou Wang wrote:
>>> As the discussion from V1 series, V2 series firstly adds GICD.num_LPIs
>>> writable support, then add HiSilicon erratum 162200802.
>>>
>>> Erratum number should be 162200802, make a mistake in V1, so fix it as
>>> well.
>>>
>>> Zhou Wang (4):
>>>   KVM: arm64: Allow userspace to write GICD_TYPER.num_LPIs
>>>   KVM: arm64: selftests: Add test for GICD.num_LPIs
>>>   Documentation: KVM: arm64: Add GICD_TYPER.num_LPIs writable
>>>     description
>>>   ARM64: errata: Add workaround for HIP10/HIP10C erratum 162200802
>>
>> Hi Marc and Oliver,
>>
>> As the discussion in V1 series, this series firstly adds GICD.num_LPIs
>> writable support, then add erratum patch.
> 
> Given the state of this HW (as per [1]), I'd rather we start by
> working out the strategy at the GIC level, rather than exposing stuff
> to userspace before we agree on a way to make it work in the kernel.

This bug is in GICv4.0([1] is in GICv4.1), and seems having a clear way
to fix. How about merging this fix firstly, then continue to try to solve [1]?

Best,
Zhou

> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20250909110615.129179-1-wangzhou1@hisilicon.com
> 
