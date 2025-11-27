Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD26258EF3
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 11:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764244131; cv=none; b=ZzBK2DLxU9bLnGdesSbwpMHbtxJlWWfw7qoipeZWbB6/hvTRP0bkA4gGq+6af3nrEd4R4wDLUsjl0IvRlDQGXDuDMLnHtIWGIbGd8HnFp5DhyleBWsL5ch4iVsMBhI+kPMJDMSFPhygILijb2ReIqIbe7ufwvdaKBbh3z36/Hzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764244131; c=relaxed/simple;
	bh=Kmy6fbm4AVNE0igIM0FCeD2lcq4jABrCROTkwk52m3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=McUcO+k3Tyr6/P7dsSmw0kMSg5txb7mWWaL+sOsEk6lY+N1y0bdITR+N0xWNAz6OWCIPFp2nmm3IzOASN7U6HEa7dQGM6YlMKqRy6UbrRZy+NlIGx9bG2WQJVyvCgVXzZnz9cbFv5qUmRFZOvpEHoiHWG03X2qkWdrZdiPcBblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=XWTtN5L7; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="XWTtN5L7"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Dw31ylgTw5lVkOHJ0GjXBHniTQtPSmoq+7esHDkGbVw=;
	b=XWTtN5L7zPwfC0KqbuHtes1A/mmqYWRuONQsCEL6DCH3mFXhGME9j5wthhQnM0qC+Zl4U0HD2
	A92Y/JUbpG8MX5P7KuhPOd6V4u9tYnk12FGAqW3P2OfgoM7gvrdlRUBIGm7kqBGCxxQ7KkmJrmL
	Rp4BQuZcRuDEgxiHbEZ+R1c=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dHF5w4WDwznTY0;
	Thu, 27 Nov 2025 19:47:16 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 9687A140135;
	Thu, 27 Nov 2025 19:48:39 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 27 Nov 2025 19:48:38 +0800
Message-ID: <54558610-1062-4632-a44c-d06443bdc736@huawei.com>
Date: Thu, 27 Nov 2025 19:48:38 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] arm64/sysreg: Add HDBSS related register
 information
To: Marc Zyngier <maz@kernel.org>, Tian Zheng <zhengtian10@huawei.com>
CC: <oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<pbonzini@redhat.com>, <will@kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-2-zhengtian10@huawei.com>
 <86wm3iqlz8.wl-maz@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <86wm3iqlz8.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 2025/11/22 20:40, Marc Zyngier wrote:
> On Fri, 21 Nov 2025 09:23:38 +0000,
> Tian Zheng <zhengtian10@huawei.com> wrote:
>>
>> From: eillon <yezhenyu2@huawei.com>
>>
>> The ARM architecture added the HDBSS feature and descriptions of
>> related registers (HDBSSBR/HDBSSPROD) in the DDI0601(ID121123) version,
>> add them to Linux.
>>
>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/esr.h     |  2 ++
>>   arch/arm64/include/asm/kvm_arm.h |  1 +
>>   arch/arm64/tools/sysreg          | 28 ++++++++++++++++++++++++++++
>>   3 files changed, 31 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index e1deed824464..a6f3cf0b9b86 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -159,6 +159,8 @@
>>   #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
>>
>>   /* ISS2 field definitions for Data Aborts */
>> +#define ESR_ELx_HDBSSF_SHIFT	(11)
>> +#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
>>   #define ESR_ELx_TnD_SHIFT	(10)
>>   #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
>>   #define ESR_ELx_TagAccess_SHIFT	(9)
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 1da290aeedce..b71122680a03 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -124,6 +124,7 @@
>>   			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
>>
>>   /* VTCR_EL2 Registers bits */
>> +#define VTCR_EL2_HDBSS		(1UL << 45)
> 
> I think it is time to convert VTCR_EL2 to the sysreg infrastructure
> instead of adding extra bits here.
> 
Sure, I will move VTCR_EL2_HDBSS into the sysreg description file
alongside VTCR_EL2.
> 	M.


