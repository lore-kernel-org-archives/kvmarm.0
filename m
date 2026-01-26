Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8D83B19F
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769394114; cv=none; b=QMpJ8JmldNQ7HrTlnLn8TDd9rahWSiSv9Qzf+qFU+Am9CwHK1xb3veOu+sKcWQOHbHvIINa496GiqhBEeRof6FR4A5r+vgSIkuzmf9Jj4+UKvL67fEbtwZ9WVdQ6+MLFgj/2S0bBUHPe80WOndM338B5lVwkpkli+PfMRSqNkt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769394114; c=relaxed/simple;
	bh=PXX80CT/S292WRWoCN59+BZhT6xQXxTstHEXrjq77dE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GXePxEQKz7NlLME0sLEM1xD3ZW3hcW4ipITd80KAyEDRURkjtRJPAD2NVHMxqbdEbQ0tdeDiP03hhTLYdP1OzO4oaSpnqeQXSjcbTgGvwRGdgALBFiKZwMrIBc8wqmUGgMy158rDejT/8/Fh1MgeenALra0rUS12g47AIxBW+YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=TR2o3w9P; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="TR2o3w9P"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LMRIcTRXNYBl6/YI3AO8HtkyX3snsSlrz/DhK+R8TBQ=;
	b=TR2o3w9PakzlTu3q+5SaIa459DX4tP6hjZUdnNRWlMKW7sSLscsYet2i9zkhny4L6wvrhzWou
	taZ+dp154MFldv0siFqJN82MGWX1ty08Go1a9c38NQ3JsLqzgtZk5pNnsoEWyQw7QXyRekyx3xi
	bKEcJUUWvIXScx6hPwI37fw=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dzsdf4d2kz1prL2;
	Mon, 26 Jan 2026 10:18:14 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 26C574056A;
	Mon, 26 Jan 2026 10:21:43 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 26 Jan 2026 10:21:42 +0800
Message-ID: <f27c6ada-7994-4ef8-a10e-27d26ed5af0f@huawei.com>
Date: Mon, 26 Jan 2026 10:21:42 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] arm64/sysreg: Add HDBSS related register
 information
To: Leonardo Bras <leo.bras@arm.com>, Marc Zyngier <maz@kernel.org>
CC: Tian Zheng <zhengtian10@huawei.com>, <oliver.upton@linux.dev>,
	<catalin.marinas@arm.com>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<will@kernel.org>, <linux-kernel@vger.kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>, <xiexiangyou@huawei.com>,
	<zhengchuan@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-2-zhengtian10@huawei.com>
 <86wm3iqlz8.wl-maz@kernel.org> <aXI-XHF2jz7arOwg@devkitleo>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <aXI-XHF2jz7arOwg@devkitleo>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 1/22/2026 11:12 PM, Leonardo Bras wrote:
> On Sat, Nov 22, 2025 at 12:40:27PM +0000, Marc Zyngier wrote:
>> On Fri, 21 Nov 2025 09:23:38 +0000,
>> Tian Zheng <zhengtian10@huawei.com> wrote:
>>>
>>> From: eillon <yezhenyu2@huawei.com>
>>>
>>> The ARM architecture added the HDBSS feature and descriptions of
>>> related registers (HDBSSBR/HDBSSPROD) in the DDI0601(ID121123) version,
>>> add them to Linux.
>>>
>>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>> ---
>>>   arch/arm64/include/asm/esr.h     |  2 ++
>>>   arch/arm64/include/asm/kvm_arm.h |  1 +
>>>   arch/arm64/tools/sysreg          | 28 ++++++++++++++++++++++++++++
>>>   3 files changed, 31 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>>> index e1deed824464..a6f3cf0b9b86 100644
>>> --- a/arch/arm64/include/asm/esr.h
>>> +++ b/arch/arm64/include/asm/esr.h
>>> @@ -159,6 +159,8 @@
>>>   #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
>>>
>>>   /* ISS2 field definitions for Data Aborts */
>>> +#define ESR_ELx_HDBSSF_SHIFT	(11)
>>> +#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
>>>   #define ESR_ELx_TnD_SHIFT	(10)
>>>   #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
>>>   #define ESR_ELx_TagAccess_SHIFT	(9)
>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>> index 1da290aeedce..b71122680a03 100644
>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>> @@ -124,6 +124,7 @@
>>>   			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
>>>
>>>   /* VTCR_EL2 Registers bits */
>>> +#define VTCR_EL2_HDBSS		(1UL << 45)
>>
>> I think it is time to convert VTCR_EL2 to the sysreg infrastructure
>> instead of adding extra bits here.
> 
> 
> Hi Marc, Tian,
> 
> Marc, IIUC the above was implemented by
> https://lore.kernel.org/all/20251210173024.561160-1-maz@kernel.org
> 
> Which was recently applied to next, and it its way to mainstream.
> 
> Tian, I think it's worth rebasing this patchset on top of the above.
> 

Indeed, I've been following Marc's VTCR_EL2 patch and will rebase my
changes on top of it.

> BTW, I am working on using the feature enabled by this patchset on a new
> optimization, so please include me on any new release.

Sure, I'll make sure you're on the Cc list for the next revision.

> 
> Thanks!
> Leo
> 

