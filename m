Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B1C1C28E
	for <kvmarm@lists.linux.dev>; Fri,  5 Dec 2025 06:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764917237; cv=none; b=mx8KWu52HkUFiGlffNznossZfqxIvPbDuDNcM13fSi6OxsLNSjfvkAexX6D9sFOhYxpE9ho9/CCI6BCZJ5qQNEj71DmRPi4Qrp69SZsNeVOJ2j6r3pozQXqwfVWXs/IdO623+D4xVsA3hnEpKnowZPtyOYWNdP/+OaXRbhxXr4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764917237; c=relaxed/simple;
	bh=z2COgYmZozPyfHZLAU3pgs07jK9J/UmeMsjadC1m6lY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iumhT41deJZFYTNt3n6oy0sKcEG+Q7IuqFdlpnwtWvJooSuUoo+m5VGZ4yxX3Dx+NDiVHCcDvrqyc36LTn9L6JdxrttJUoeXbnxg8dF5WY6cWWsekHdOUuQNeUP60rnbVA9iA0d0cbRcEF5qZEzJTJX+vJcSinnk0b9IoYDncwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dN21n5yd4z1cyPx;
	Fri,  5 Dec 2025 14:45:17 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E8FA1402C6;
	Fri,  5 Dec 2025 14:47:11 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Dec 2025 14:47:11 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Dec 2025 14:47:10 +0800
Message-ID: <734163cd-3692-3be2-9f2a-5364d9f5980c@hisilicon.com>
Date: Fri, 5 Dec 2025 14:47:09 +0800
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
 <6d6fad8d-e4e4-b973-6431-34a37003d363@hisilicon.com>
 <f641d3f2-dac9-4a9e-92a4-0805e6561418@app.fastmail.com>
 <e6cffbce-7cd4-3fe3-a9bd-935efedaebd0@hisilicon.com>
 <7d2ea8c6-e54f-4a57-843c-e0c6c33c02c5@app.fastmail.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <7d2ea8c6-e54f-4a57-843c-e0c6c33c02c5@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/11/27 23:37, Arnd Bergmann wrote:
> On Thu, Nov 27, 2025, at 04:51, Zhou Wang wrote:
>> On 2025/11/18 15:36, Arnd Bergmann wrote:
>>> On Tue, Nov 18, 2025, at 03:31, Zhou Wang wrote:
>>>
>>> The easiest setup I can think of that still supports your machine
>>> would look something like:
>>>
>>> - have the kernel choose between st64bv and st64bv0 at early boot,
>>>   based on platform configuration, use st64bv0 by default if
>>>   available in hardware and not disabled in EL3, EL2 or kernel
>>>   command line.
>>> - Change pasid handling in iommu_sva_bind_device() so drivers
>>>   have to explicitly request one of the modes before establishing
>>>   a pasid, refuse this on incompatible systems, update the
>>>   three existing callers (idxd, amdxdna, uacce) accordingly.
>>> - on systems with st64bv but no st64bv0, enable st64bv for
>>>   all CPUs at boot time to avoid context switch overhead, but
>>>   forbid mapping shared hardware workqueues into userspace.
>>> - postpone full support for st64bv0 until we have a device that
>>>   actually uses this and can be tested. I think most of it is
>>>   already there in the iommu code, but the ACCDATA setup needs
>>>   to be integrated into the switch_mm()/__switch_to() code
>>>   and possibly a trap handler like on x86.
>>
>> Hi Arnd,
>>
>> Sorry for late to reply, I double checked with our SoC and device
>> colleagues, currently only st64b has been used in our system.
>>
>> So I think we could upstream FEAT_LS64 firstly as it seems easy
>> to be merged. After this, we continue to discuss FEAT_LS64V and
>> FEAT_LS64_ACCDATA solution if there is a real system need them.
> 
> As I understand it, using ST64B is usually more efficient than
> ST64BV if you can use either, since it is a normal posted bus
> transaction rather than a synchronous atomic. If that works for
> you, I think what we should plan for is to let you use ST64B
> on this particular hardware and never support ST64BV from
> userspace, the same way we do it on Intel hardware with ENQCMD.

I missed the email as it has been filtered into other fold, my bad :(
I think it works fine in our system. I planned to remove whole ST64BV
support in next version, so what you suggested is not to export
ST64BV to userspace?

> 
> As there are already CPUs out there that do include ST64BV0,
> I think we also want to support those soon. Not having to
> support both ST64BV and ST64BV0 from userspace makes it a lot
> easier, but I think we'd still want to only enable ST64BV0
> on a per-task base when mapping a shared workqueued into the
> user address space on a task that has an active mm->iommu_mm.
> 
> If that makes sense to you, I can try to come up with a
> prototype based on your current patches to add the context
> switching and enable logic.

I am OK with this, even though currently we do not have a real
hardware to test ST64BV0 related codes.

Best,
Zhou

> 
>       Arnd
> .
