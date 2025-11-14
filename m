Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C96530C618
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 09:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763112348; cv=none; b=Y9vn0UfI3WxJ3JLiMDRtB94dKuHjx71UsifOV3bkdZuz9XOzArErA+RDtHjXUnB7OOtCJJr1iH1wnlCrNXf6wNyjcR+GeFCeUYWou1I8ZCKoBs/yayYLDW3RMAeWQla5nn7iJiZ5yDpJtddnaU/f+QrfqbIo3AQExwSCa1Zd82E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763112348; c=relaxed/simple;
	bh=VYmqQH1yGKXhR5LEWriiwBF7lN7lWF/3lnDYvA2VvMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=LTKaNP4tXXcNCp/4KiTWxvtfAdB1CzCeGJyMrAiY47dTyiqIc5Ye05Yqf61o4+MG5wlrmpR4XylhDGdsOjO4MTFir/SbH1xQnw/aQr8zZ6Bej7Tu3ZSLQUIDHMjALQ3WMQip8ZP6PPOv5JrGDynhSpsm+cqK1SKf0wmxAxvEA5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d7BXX1ZTYzLlVP;
	Fri, 14 Nov 2025 17:23:56 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 986E21400CF;
	Fri, 14 Nov 2025 17:25:36 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Nov 2025 17:25:36 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Nov 2025 17:25:35 +0800
Message-ID: <1ed610f5-3f0b-614d-5e7f-2c643238bec3@hisilicon.com>
Date: Fri, 14 Nov 2025 17:25:34 +0800
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
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <c72411f9-a77e-4a72-a401-5110b919a2df@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/11/14 0:26, Arnd Bergmann wrote:
> On Thu, Nov 13, 2025, at 15:40, Zhou Wang wrote:
>> On 2025/11/11 19:15, Marc Zyngier wrote:
>>> On Fri, 07 Nov 2025 07:21:25 +0000,
>>>
>>> But this doesn't mean that the system actually supports this. It is
>>> also trivial for EL0 to spoof a PASID using ST64BV, by populating the
>>> bottom 32bit with whatever it wants (hiding ST64BV0 doesn't prevent
>>> this).
>>
>> I am confused here, we enable FEAT_LS64 and FEAT_LS64V in this patch,
>> so only LD64B/ST64B/ST64BV are involved.
>>
>> Sending the value of ACCDATA(maybe a PASID) is defined in ST64BV0, which
>> is not enabled currently.
>>
>> If a bad system implements ST64BV wrongly, isn't the fault of this bad
>> system?
> 
> As far as I can tell, the design of ST64BV/ST64BV0 is a bit vague
> on this, both on the Arm architecture and the PCI side [1], which each
> leave the meaning of ACCDATA open to system design.
> 
> However, when the intention is to implement a shared hardware workqueue
> in the style of drivers/dma/idxd/ [2], the only sensible implementation
> is to follow the way that the corresponding Intel instructions work:
> 
> - movdir64b/st64b is a nonprivileged instruction to produce a posted
>   atomic 64-byte write TLP to a PCIe device, which can only be used
>   with a dedicated workqueue that is preconfigured to a fixed PASID
> 
> - enqcmds/st64bv is a privileged instruction to produce a non-posted
>   atomic 64-byte write Deferrable Memory Write (DMWr) TLP, which can be
>   used on a shared workqueue from kernel space, using an arbitrary PASID
>   value per transaction, which would normally correspond to the
>   physical address space when the kernel initiates DMA.
> 
> - enqcmd/st64bv0 is a nonprivileged instruction like enqcmds/st64bv
>   using the pasid from accdata that corresponds to 
>   current->mm->iommu_mm->pasid value [3] in the kernel for the task
>   that initates the transaction in userspace.
> 
> A PCIe device can tell the difference between a posted write and a
> non-posted DMWr, but it cannot tell the difference between st64bv
> and st64bv0, so the kernel must disallow st64bv from userspace if
> it can be used on a device that expects the PASID value in the
> low bits.
> 
> Things would be different if there is a PCIe device that expects
> a DMWr transaction but does not use it for a shared hardware
> workqueue with the PASID in that field.
> 
> Are you using a particular device, or are you trying to enable
> the support in general? If you have a specific device you are
> working on, does it use the PASID data or not?

Hi Arnd,

Many thanks for your careful explanation! I got the pointer here.

We have a real device in our SoC, which supports LS64B/ST64B/ST64BV.
For ST64BV, Our device just receives 64B data atomically, not interpret
it with PASID data.

Best,
Zhou

> 
> Things will clearly get a lot harder if we want to support a
> system that can have devices with conflicting interpretations
> of the ACCDATA value. Ideally we could always use the
> iommu_mm->pasid value here and enable st64bv0 globally like
> idxd does. If any devices requires the use of st64bv, that
> would have to be mutually exclusive with another driver
> handing out access to shared hardware workqueues.
> 
>      Arnd
> 
> [1] https://members.pcisig.com/wg/PCI-SIG/document/14237
> [2] https://www.kernel.org/doc/html/v6.1/x86/sva.html
> [3] drivers/iommu/iommu-sva.c
> .
