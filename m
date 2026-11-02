Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651789;
	b=RVlDSxaUwNuI3ey9dnusiXkhUzuiY2DPILG+dB6nZZOwtN7ammTlFnIq5MfdIqnf8G9p
	 lLS5Af3IGcNOKsZLqrd0g73e6Jy3RDR/fiIOfLi3tq12+Ho5/N2gBwrV1fEnhB7Rggk8y
	 I/b/ZX10M/rOZy0QwXiMC8H++YmHQ5RLve9hcVlVZ63cWs6LSlXnTVJeLdkCobDoLhDXn
	 rV1yYoV3jSpRYSdb6hlo768QIir70ZJaFavFhpbX2FyzNsPky1RZs8nMVVTr53Pbm0Tzb
	 yy+WtxrSdE/7HQ9kFKml9r8RFvjTyl0SyyI/WTdYnTNiPe37uryLo0ghHWDVZuOKEnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651789;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=MDDeRU4d0nx+E0eXi1w8CF2FxMkkVCg82SPJez1bIKw=;
	b=mTKY0j+biBYDkBD2S0vgrpoMtXiPXNGO3UPHfvG9KO6xUCUDSilSfuz/nmaZxTeobVml
	 6jcgtqfogjbyjrFvW59cmerfFAPXCkajTqYB5qW9HTw09FWkuXJJZe3t013DTz4Tp9EvU
	 67iWVvJ4WRI/66BwsOece6jTyyyyrsUN4v3O94hM5afBbJxGryGLxdq2iaVeMuVC2SzKl
	 XRpdAPBtbcxYn0JVk9g+RTlot8eop0m9xuqMK1ciNsTGu/C4Onr0rpTs8AYFwq1BJUfFT
	 Lxx8PNTVT8pNo6zqg1qxFH850t5w3vCFcxMtYVtxlILDIKIYc6cH/GuORPSZKURYIrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ql0I2vvo;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F55E606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:36:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F55E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ql0I2vvo
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFBA616A3;
	Mon,  2 Nov 2026 12:36:24 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A72363F59E;
	Mon,  2 Nov 2026 12:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793651787; bh=qa5nJdTMdWsjWuKo5pGJg/ac6E9Vv4VQtwfe5yhRkRY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ql0I2vvod+2atDtLyYSwBRnutRleT1fV8638Hu8VK1NIBdgA+87m6A6HZ2REfDqdd
	 jVQ5DHYX+JLbRxE8TYtU1bZ55gJwncX96qDG6A9nm1aC4rCpspLfXc8Hnt1imHsYf4
	 IfACKHPma8pYAwu+CxHfMw0JAe4HcF9xgZIIzFYk=
Message-ID: <eb50ce99-d586-45b3-9584-fc875ebc81fb@arm.com>
Date: Mon, 2 Nov 2026 20:36:25 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v3 06/21] irq: Allow the initial interrupt line
 number to be set
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-7-sascha.bischoff@arm.com>
 <6964001c-3032-4c69-b1a6-382749dfc73b@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <6964001c-3032-4c69-b1a6-382749dfc73b@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/10/2026 19:25, Vladimir Murzin wrote:
> On 10/16/26 16:39, Sascha Bischoff wrote:
>> GICv5 SPIs start at zero, while earlier GICs use an offset of 32.
>> Allow the offset to be changed before any line is allocated and set
>> it to zero when creating a GICv5 VM.
>>
>> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>> ---
>>   arm64/gic.c       |  6 ++++++
>>   include/kvm/irq.h |  1 +
>>   irq.c             | 15 ++++++++++++++-
>>   3 files changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm64/gic.c b/arm64/gic.c
>> index c1bd0771..23c68862 100644
>> --- a/arm64/gic.c
>> +++ b/arm64/gic.c
>> @@ -236,6 +236,12 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>>   	if (err)
>>   		goto out_err;
>>   
>> +	/* GICv5 SPIs start at zero. Set this before allocating IRQs. */
>> +	if (type == IRQCHIP_GICV5) {
>> +		err = irq__init_irq_offset(0);
>> +		if (err)
>> +			goto out_err;
>> +	}
>>   	vgic_is_v5 = type == IRQCHIP_GICV5;
>>   	return 0;
>>   
>> diff --git a/include/kvm/irq.h b/include/kvm/irq.h
>> index 2a3f8c9d..17113979 100644
>> --- a/include/kvm/irq.h
>> +++ b/include/kvm/irq.h
>> @@ -23,6 +23,7 @@ extern struct msi_routing_ops *msi_routing_ops;
>>   extern struct kvm_irq_routing *irq_routing;
>>   extern int next_gsi;
>>   
>> +int irq__init_irq_offset(u8 offset);
>>   int irq__alloc_line(void);
>>   int irq__get_nr_allocated_lines(void);
>>   
>> diff --git a/irq.c b/irq.c
>> index cdcf9923..7c4bfec4 100644
>> --- a/irq.c
>> +++ b/irq.c
>> @@ -8,6 +8,7 @@
>>   #include "kvm/irq.h"
>>   #include "kvm/kvm-arch.h"
>>   
>> +static u8 irq_offset = KVM_IRQ_OFFSET;
>>   static u8 next_line = KVM_IRQ_OFFSET;
>>   static int allocated_gsis = 0;
>>   
>> @@ -18,6 +19,18 @@ struct msi_routing_ops *msi_routing_ops = &irq__default_routing_ops;
>>   
>>   struct kvm_irq_routing *irq_routing = NULL;
>>   
>> +/* Override the default offset before the first IRQ allocation. */
>> +int irq__init_irq_offset(u8 offset)
>> +{
>> +	if (irq__get_nr_allocated_lines())
>> +		return -EBUSY;
>> +
>> +	irq_offset = offset;
>> +	next_line = offset;
>> +
>> +	return 0;
>> +}
>> +
>>   int irq__alloc_line(void)
>>   {
>>   	return next_line++;
>> @@ -25,7 +38,7 @@ int irq__alloc_line(void)
>>   
>>   int irq__get_nr_allocated_lines(void)
>>   {
>> -	return next_line - KVM_IRQ_OFFSET;
>> +	return next_line - irq_offset;
>>   }
>>   
>>   int irq__allocate_routing_entry(void)
>> -- 2.34.1
>>

Hi Vladimir,

> 
> Perhaps should be split into:
> - changes in generic infrastructure
> - plumbing of GICv5

I've created this split as you suggested.
> 
> Cheers
> Vladimir

Thanks,
Sascha
