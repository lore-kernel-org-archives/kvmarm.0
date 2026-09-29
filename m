Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D037551D518;
	Tue, 29 Sep 2026 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684078; cv=none; b=nyuexRgSHMo7Z9AKZioRV8TYPPHMvNDxlVrdQXvAPfgo+UZD70vrk4Q0ycR8sWjpk1HGC0xFA3rHp8QsvRhZzNVKo9xYe+9h2wCGS9X9ZSWTgKA+gUMt9NnLRNf7TiXTnPk1Uj+b+V/oyShC67MPD9PcjgEJ7kD8d468koevU3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684078; c=relaxed/simple;
	bh=KpbRo5wvWYYEvhUJ8NixQglOE8FclIcuHa9+3zDEXSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3Oa+zeybQ27WzwpvuqoXHXokIBOsc8Y2nEvrtPXKVdTJay1M8C/UrhVic4Y3XD+QVOLuyUEOSCsly84AXZ8ch0JmAlAnQ+nEDmkp50ZsOjgej2LCgJR4yZv1ymNZ40Gf4Qc97yMn1TNbEO00eJ0rAxqf85wUNvLjOlMeW9bavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Gj3lVZyc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Gj3lVZyc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C140A1516;
	Tue, 29 Sep 2026 05:14:32 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C2F83F86F;
	Tue, 29 Sep 2026 05:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790684076; bh=KpbRo5wvWYYEvhUJ8NixQglOE8FclIcuHa9+3zDEXSg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gj3lVZyccDDRPlbotO7N9QaG7/lLlhFDj/O4VW4/SVs/zSipgDwsdhSfIr35e/TwW
	 Kbm62sJwIYm+/mS3vWKQOXaPkD4vwsdzVO04Ch4k4woBd0+4Jj/v8rhORtdte4EgHn
	 f4jELitrKpY8/XVi6KsgpNC4q2ErFwxb6jvKrq1c=
Message-ID: <b9744fc2-ecc6-406b-ae33-62ba374a87fc@arm.com>
Date: Tue, 29 Sep 2026 13:14:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <aruWz-QkcdD9ETbC@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aruWz-QkcdD9ETbC@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/09/2026 11:50, Catalin Marinas wrote:
> On Thu, Sep 24, 2026 at 02:51:54PM +0100, Suzuki K Poulose wrote:
>>   arch/arm64/Kconfig                |    1 +
>>   arch/arm64/kernel/cpufeature.c    |    1 +
>>   drivers/firmware/Kconfig          |    1 +
>>   drivers/firmware/Makefile         |    1 +
>>   drivers/firmware/arm_rmm/Kconfig  |   25 +
>>   drivers/firmware/arm_rmm/Makefile |    2 +
>>   drivers/firmware/arm_rmm/rmi.c    | 1072 +++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h      |  558 +++++++++++++++
>>   include/linux/arm-smccc-rmi.h     |  505 ++++++++++++++
> 
> One more nit: patches 1 and 2 I think add new header files without a
> MAINTAINERS entry. You can add them to arm64.

Ack, I have added them. Thanks

Suzuki
> 

