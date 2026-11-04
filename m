Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793788761;
	b=QTPa74j+GiY9rY/YXSOh22qSre8Sdb2oQt5muh5LwbnxSPl9OffqeYt7I/LKacXAuPuG
	 h360eumh5LUhxS5XmKT32H2xc0jzAaDzrEalmV0jc6SjkxoRfiyAQeJIuKS2xp5rmqvy2
	 JA1y+02t0QxO1vkvoW1AQ+82hcykgPZ6Zd1dpvEAupyy2/hisPOAExMkz1hoE94i2EYLX
	 tyeJD+lljhcm7MoDAaOogGSwPzrF7eAaYwpn1YO3SnrB6uSoK4wabnxQPWQl7S/Dtm1Xv
	 zXEzi4SJbOeDhkBvrCUVF3VtKKQdU5LsQ24lLDJvmucSgEB+KAq3645qDkyAig+tgnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793788761;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=nssP4eGI3zXDuFonBDPkQJxTRjYQwrWbLZScwkFMK9E=;
	b=UftnHc9Ro7W1qAUzhBYI3DhWxmzg5bjm2S7++7MecbzdP7wcJeVZqILGql5J38LiNq6g
	 ZAC97+SURC1tBveGGhsos/MOIWCmexlCbMfBDjzbzQOrwu9WSSyxdJttULCIsFzhbLUJQ
	 zDeJkT9BhDwftRtD46Vt9KvU03rNRU918JtR/xVjxhOJlYt8CVH2z00IOwVY5hUEaeJ18
	 rwTxtlkCZ6ZfZgmkxwY/Qf0883Px5aJjar6NFvgTmwggSNNNOpLK5gNwiQ29Bh2udirgJ
	 AOY9BOLTTJYbigQltPdcr9IYt+Jx9MPAL2P9tC/QuK/xvHlmpHzacFylTXh49Ft6k7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eDsuvw7f;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E0E606A328;
	Wed,  4 Nov 2026 10:39:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33E0E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eDsuvw7f
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 272AB1650;
	Wed,  4 Nov 2026 02:39:17 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AE4E3F628;
	Wed,  4 Nov 2026 02:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793788760; bh=uv4Nu83ZWi1bXtWcHnSpsPJ7BG6d6N7mX+McDBYbtuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eDsuvw7fRB91gXRC27O09DhHBx6xx9ag5Cesox1gcq2YZ8yZGORGZhEXCRlb3OFoZ
	 KitHx/tyq6HfjbQo7e/ec30gUCsMaQyAysA2e+QxXv2XSRh9Vp6SgUEQspDGAzk4lq
	 ZH24ZRdFSyXCgXan1tWqS7NumGlOoCyoWJYBzQhk=
Message-ID: <415f6a96-9ac2-4256-a9b9-e976bd0e73a8@arm.com>
Date: Wed, 4 Nov 2026 10:39:15 +0000
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
Subject: Re: [PATCH 03/11] KVM: arm64: CCA: Check for RMI support at KVM init
To: Kohei Enju <enju.kohei@fujitsu.com>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-4-steven.price@arm.com>
 <ausEnXB1TE_moI0E@FCCLS0092175.localdomain>
 <ausIgejq7Io9VjZL@FCCLS0092175.localdomain>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ausIgejq7Io9VjZL@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kohei

On 04/11/2026 10:27, Kohei Enju wrote:
> On 11/04 19:23, Kohei Enju wrote:
>> Hi Steven,
>>
>> On 11/02 14:12, Steven Price wrote:
>>> Check if the RMI support is sufficient for using in KVM. Specifically, we
>>> will only support creating realm VMs when KVM is set to 'rmm' mode.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>   arch/arm64/kvm/Kconfig | 1 +
>>>   arch/arm64/kvm/rmi.c   | 4 +++-
>>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>> index cecea0820e52..d067063a3686 100644
>>> --- a/arch/arm64/kvm/Kconfig
>>> +++ b/arch/arm64/kvm/Kconfig
>>> @@ -34,6 +34,7 @@ menuconfig KVM
>>>   	select GUEST_PERF_EVENTS if PERF_EVENTS
>>>   	select KVM_GUEST_MEMFD
>>>   	select KVM_GENERIC_PRE_FAULT_MEMORY
>>> +	select ARM_RMM_RMI
>>>   	help
>>>   	  Support hosting virtualized guest machines.
>>>   
>>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>> index 5ecc8b349869..9d118768550d 100644
>>> --- a/arch/arm64/kvm/rmi.c
>>> +++ b/arch/arm64/kvm/rmi.c
>>> @@ -3,6 +3,7 @@
>>>    * Copyright (C) 2023-2026 ARM Ltd.
>>>    */
>>>   
>>> +#include <linux/arm-rmi-cmds.h>
>>>   #include <linux/kvm_host.h>
>>>   
>>>   #include <asm/virt.h>
>>> @@ -12,7 +13,8 @@ void kvm_init_rmi(void)
>>>   	if (kvm_get_mode() != KVM_MODE_RMM)
>>>   		return;
>>>   
>>> -	/* TODO: Check if the RMI is available */
>>> +	if (!is_rmi_available())
>>> +		return;
>>
>>  From an admin/operator's perspective, kvm_rmi_is_available would
>> silently remain FALSE in either of the following cases:
>> - kvm-arm.mode=rmm is set, but RMI is not available for some reason.

We could add a kvm_info() message for this.

>> - RMI is available, but the admin forgot to set kvm-arm.mode=rmm.

But not this one. We are additionally planning to move the RMM
activation to gate on kvm-arm.mode=rmm. I will send out a patch
soon.

Cheers
Suzuki


