Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E7A3254BE
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763433108; cv=none; b=fSsHDdJv2XaRC4x4XyA+5ovmg0Rixvo/5sknKkWRkeUQxKbtqfyT76E3TzIUv4v+P0HrkNxDGkZS32BnLY0TUPP4wx15YV/F9OLcAiRzCl0L1BVb4ZmijSabPPdT+Sefaiq3X7fo79swAqezWVZt7V/dkABRwbRSvYO9IQS5S6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763433108; c=relaxed/simple;
	bh=dPepyjj6C20m9g93FagchOPOIv+WHd7rd4fcXcbpzys=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gIDftSCYt/WacislOsMFWIYTytrLnWozZ+XwIFvsvyyQV2Kii+qJGs/YOfi1OIg+znlqxUUQ5czKViZDUTvN9f3zqxOG9gHvzsM4Sm6puEEaZ36fZj1Hd4MaabtseL0/YK5Idfn5BFrXEB9pb5QKI9xqet8SBDPvgVsGVvR4OcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d9T9K3hxvznTxM;
	Tue, 18 Nov 2025 10:30:13 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B95EF140158;
	Tue, 18 Nov 2025 10:31:41 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 10:31:41 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 10:31:40 +0800
Message-ID: <6d6fad8d-e4e4-b973-6431-34a37003d363@hisilicon.com>
Date: Tue, 18 Nov 2025 10:31:40 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, Yicong Yang
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
 <861pm4vn02.wl-maz@kernel.org>
 <b1407660-9b69-7e21-328a-0f969fffa554@hisilicon.com>
 <c72411f9-a77e-4a72-a401-5110b919a2df@app.fastmail.com>
 <1ed610f5-3f0b-614d-5e7f-2c643238bec3@hisilicon.com>
 <113db0fb-d879-49d7-a5f2-7755558f29dd@app.fastmail.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <113db0fb-d879-49d7-a5f2-7755558f29dd@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/11/14 17:37, Arnd Bergmann wrote:
> On Fri, Nov 14, 2025, at 10:25, Zhou Wang wrote:
>> On 2025/11/14 0:26, Arnd Bergmann wrote:
>>>
>>> Are you using a particular device, or are you trying to enable
>>> the support in general? If you have a specific device you are
>>> working on, does it use the PASID data or not?
>>
>> Many thanks for your careful explanation! I got the pointer here.
>>
>> We have a real device in our SoC, which supports LS64B/ST64B/ST64BV.
>> For ST64BV, Our device just receives 64B data atomically, not interpret
>> it with PASID data.
> 
> Ok, I see. So I assume this is either a kind of dedicated work queue
> where the IOMMU PASID is set up in advance for the user MMIO area,

Yeah, it is something like you mentioned above. MMIO area is binded with
a work queue, a PASID is set up in advance for this work queue.

> or it is a device that does not do any DMA at all, correct?
> 
> In this case, would the device also work correctly with ST64BV0 if
> the ACCDATA register is fixed to a value of zero and you can only
> use the upper 480 bits? Would it also work if there is an
> unpredictable value in ACCDATA that may match the PASID of another
> device used by the same process?

We do not support ST64BV0, so above case will not happen. I think ST64BV0
will trigger a illegal instruction exception in our system.

Best,
Zhou

> 
>          Arnd
> .
