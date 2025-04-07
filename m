Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A488D212B05
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 03:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743997831; cv=none; b=XX677kTeShj6EagqZ+DGGEEp34Zt/VHNZBtYUvjJfW0B4tyndamtAKkq2XychRfIh9plk8qhN5GXSppRMRNSPy6H8ryB5ikSqy4cNuDIYwmxmc3+sejjI6HsmB3/geOJJBKo4UBcSJAVMhzxguIz7noXChoTX4bSczh2d6JYKd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743997831; c=relaxed/simple;
	bh=J0JV9o3uvSUkZOj02HE6iD1XPYSAmqALDCBrch3rG4g=;
	h=CC:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gtUCBYjbzQ9w1HTjyzimUU4Gr8QcG1N+Q20YzONzRB0qzL/RiCibiXIXO3me0Qg0qnzd+ooLrXOjYl2khbKc4R4TI9Sa6FeczAh+0NjrHIhgrYGfcrCR+hPXcDI85/ZnkhETm48uba5rDzvS21LJ2JLMwfMLGXz2f9KS132fm6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZWFBB5DwFz1R7g7;
	Mon,  7 Apr 2025 11:31:46 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F2091A0188;
	Mon,  7 Apr 2025 11:33:39 +0800 (CST)
Received: from [10.67.121.177] (10.67.121.177) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 7 Apr 2025 11:33:38 +0800
CC: <yangyicong@hisilicon.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<maz@kernel.org>, <corbet@lwn.net>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kselftest@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <shuah@kernel.org>, <jonathan.cameron@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <tangchengchang@huawei.com>
Subject: Re: [PATCH v2 5/6] arm64: Add ESR.DFSC definition of unsupported
 exclusive or atomic access
To: Oliver Upton <oliver.upton@linux.dev>
References: <20250331094320.35226-1-yangyicong@huawei.com>
 <20250331094320.35226-6-yangyicong@huawei.com> <Z-wRGyMrz0Tqh0CO@linux.dev>
From: Yicong Yang <yangyicong@huawei.com>
Message-ID: <9bb31e71-aa2b-329d-0d76-112824eb69c9@huawei.com>
Date: Mon, 7 Apr 2025 11:33:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Z-wRGyMrz0Tqh0CO@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200014.china.huawei.com (7.221.188.8)

On 2025/4/2 0:15, Oliver Upton wrote:
> On Mon, Mar 31, 2025 at 05:43:19PM +0800, Yicong Yang wrote:
>> From: Yicong Yang <yangyicong@hisilicon.com>
>>
>> 0x35 indicates IMPLEMENTATION DEFINED fault for Unsupported Exclusive or
>> Atomic access. Add ESR_ELx_FSC definition and corresponding wrapper.
>>
>> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> 
> Just squash this into the next patch. Adding a helper w/o any user
> usually isn't a good idea.
> 

sure, will squash this into the next patch.

Thanks.

