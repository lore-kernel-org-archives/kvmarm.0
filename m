Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C86221A92F
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779267113; cv=none; b=rjOTq2L2SYb9SBiTIyZhh/zHWPNPkHb7UCY2EbZwoWcL+9KnYwc/lFTK9t2BaCrAaIFaeCUmAdh6CTg2vBUXi4OPQE8JgKBOQO8Yrbun4jc0E4z1ToKJNQ1VV0bfgsoKsDCxXS63ioXvvAwU7B34u8n7eq2Yf8fDF/Tjj76frD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779267113; c=relaxed/simple;
	bh=9JAocrfSRE8OAcaCFSUKgWUvl095GAK8sITS8uCFLjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=E7duziOdiDfscyg9lEQvP34MqmSVEWvSFoFzz1JEWTCLr+CjBtZWnkSDBhd7jJPnJOxyZ1+aVygaRDPp8ipYbOg2xrYsu+n4beogOXrtsvpQmptRxykiUMGBQOI4WfW6EkPEkNwYbIXLDuadjZcwFflom22FqecZZLkZNzNFdcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ahldOXzR; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ahldOXzR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5ILLE5X/zh5Zp5m7SYWsEaC8ZBBvgKc8eCKNCOEyqYg=;
	b=ahldOXzRVBCatzSoLh4qIWjZNKkjLW+qbMChK+u+JTSiPCXdTZPYb9zQteodxgzTQLeiOjLFL
	1TOQJNZphPCA3XiHB3+YzYEx6XTyKjoXuFgzD869C++zx7TZXKvZ+XrYS/dQlY+k8Os8NGRpKvC
	x+HpkHsLmUgowgc8bj+OXyA=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gL4pP2yrDzcbR6;
	Wed, 20 May 2026 16:44:13 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 6149B4056E;
	Wed, 20 May 2026 16:51:47 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 20 May 2026 16:51:46 +0800
Message-ID: <cd330f4f-2604-48ce-bfcf-c9a79f48e66b@huawei.com>
Date: Wed, 20 May 2026 16:51:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] Support the FEAT_HDBSS introduced in Armv9.5
To: Will Deacon <will@kernel.org>, <maz@kernel.org>, <oupton@kernel.org>,
	<catalin.marinas@arm.com>, <corbet@lwn.net>, <pbonzini@redhat.com>, Tian
 Zheng <zhengtian10@huawei.com>
CC: <kernel-team@android.com>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <liuyonglong@huawei.com>, <yezhenyu2@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>, Jonathan Cameron
	<jic23@kernel.org>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
 <177918656142.736362.17906576792384645789.b4-ty@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <177918656142.736362.17906576792384645789.b4-ty@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 5/19/2026 11:23 PM, Will Deacon wrote:
> On Wed, 25 Feb 2026 12:04:16 +0800, Tian Zheng wrote:
>> This series of patches add support to the Hardware Dirty state tracking
>> Structure(HDBSS) feature, which is introduced by the ARM architecture
>> in the DDI0601(ID121123) version.
>>
>> The HDBSS feature is an extension to the architecture that enhances
>> tracking translation table descriptors' dirty state, identified as
>> FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
>> page tracking, aiming to significantly reduce the overhead of scanning
>> for dirty pages.
>>
>> [...]
> 
> Applied sysreg definitions to arm64 (for-next/sysregs), thanks!
> 
> [1/5] arm64/sysreg: Add HDBSS related register information
>        https://git.kernel.org/arm64/c/72f7be0c2e30
> 
> Cheers,

Thanks!
Tian

