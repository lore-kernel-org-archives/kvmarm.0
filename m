Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B8216E32
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 01:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757468546; cv=none; b=FiSqpMCrr7D8kBHBm6Ki7boPtUuBTmF6eeBbTLPfzkeoEMB7kv26ovVdAlXgH4B+y6iQ0NYdnZAwHRDZn+bN14PrKBgEOtWq6nP2jNVEEuCN3hoaEG0uMgLrEEMoYZfZLWfolNZxiIodZnLOkh42kW63oGKgmrhwG5iDOdeIO2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757468546; c=relaxed/simple;
	bh=6OqjZR9oFvkWiE5VSEPIINqSTbDNH6sz23EK/qxRKvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=g/P3bMVtqyMWQhc+JmSD+YapuYzc8N7ulg8wlhHMdIFgv1aP7al5UpUUSjCvpH7bxfzI1l4xy/IqHu1smZpFAI2mq3y9Lc6FGm7s/mPoYUaAWQMzuEDEM777MXHHq0JB79I2d3Ou4mscX3KPm/98q2GVSl6zJ+zScW2Gg128LB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cM3Lt6lpvztTX2;
	Wed, 10 Sep 2025 09:41:26 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 27FB9180B68;
	Wed, 10 Sep 2025 09:42:22 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 dggpemf500013.china.huawei.com (7.185.36.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 09:42:21 +0800
Message-ID: <3d57bacf-6ea7-4d95-b411-bde376006b9f@huawei.com>
Date: Wed, 10 Sep 2025 09:42:20 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] KVM: arm64: Make ID_AA64MMFR1_EL1.VH writable from
 userspace
To: Oliver Upton <oliver.upton@linux.dev>
CC: <yuzenghui@huawei.com>, <maz@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <liuyonglong@huawei.com>,
	<wangzhou1@hisilicon.com>
References: <20250909034415.3822478-1-yangjinqian1@huawei.com>
 <20250909034415.3822478-4-yangjinqian1@huawei.com>
 <aL-788d0xWThAVSl@linux.dev>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <aL-788d0xWThAVSl@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500013.china.huawei.com (7.185.36.188)



On 2025/9/9 13:32, Oliver Upton wrote:
> Hi Jinqian,
> 
> On Tue, Sep 09, 2025 at 11:44:15AM +0800, Jinqian Yang wrote:
>> Allow userspace to downgrade VH in ID_AA64MMFR1_EL1. Userspace can
>> only change this value from high to low.
> 
> I'm afraid we can't allow this. When we expose FEAT_VHE to the VM,
> HCR_EL2.E2H is RES1. Meaning, vEL2 is unconditionally in a VHE
> context.
> 
> I would be OK with a clarifying comment documenting why the field is
> non-writable.
> 

Okay, v3 will keep ID_AA64MMFR1_EL1.VH non-writable.

Thanks,
Jinqian
