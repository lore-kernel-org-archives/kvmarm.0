Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCA84CB8D0;
	Wed, 30 Sep 2026 12:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790772476; cv=none; b=IzRgZNhpiexO4e1v8WXV1jHpSCDPA4aVNBcYS2szeyN2I+Xg/ku2WLO4HmyijbL6vBfFQ+z2r+rIlV53rFUHLyQxzj6/JUchwiSWvggJxY/NDz2FEE7Ix3FFRPuvPWrpZVJWshzB2NeFm8mW38SqVOUP91pVgx1ajpKxUeW7Y/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790772476; c=relaxed/simple;
	bh=XSxUOWy6/i2pHRQoyR+pRBw8GLAglNiW8ucXPa+ua2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nuTWS81piFPG4nUmZayMyHbuvEa9da1Re4dTDrj/4uDff1z36dkk/Z6T2ctRhCoY56WfC1r0/XGlj0Lqou8uFB3tVByqJDpvNAxXUiX6vNaJA6g8Noz9rPtUaznhOn1duOw16pRGDx4oIbj8z44AbNucxhke1vrosbHic6GbE3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sPjyAGUL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sPjyAGUL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8397C497;
	Wed, 30 Sep 2026 05:47:46 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DBD33F85F;
	Wed, 30 Sep 2026 05:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790772469; bh=XSxUOWy6/i2pHRQoyR+pRBw8GLAglNiW8ucXPa+ua2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sPjyAGULKD9PkR/+zPN+CoAKsJcaKiFs97aaVMAEhj+whK/A2nwHAqZsBENcqUCWu
	 ee5jHrvUlzYiKD35l0dRchtPoFvUbg61JriWBcZK4Vv7ktDlVpXveN0+sYo+2pDal2
	 lMaPN0u/BqkAjoWLofB/apY/534GPeErbDxXtl2g=
Message-ID: <fee0d1b7-8569-4235-b200-03490b78637e@arm.com>
Date: Wed, 30 Sep 2026 13:47:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 9/9] firmware: arm_rmm: hotplug: Skip memory added to
 ZONE_MOVABLE
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
 yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-10-suzuki.poulose@arm.com>
 <4d3be415-6d51-46f7-81ca-ab2dcf0f0f74@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <4d3be415-6d51-46f7-81ca-ab2dcf0f0f74@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/09/2026 13:22, David Hildenbrand (Arm) wrote:
> On 9/30/26 00:16, Suzuki K Poulose wrote:
>> If the hotadded memory is in ZONE_MOVABLE, we could allow that to proceed
>> without the RMM having fine grained tracking, as we won't allocate pages
>> from there for guest-memfd or kernel allocation
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v19:
>>   - New patch in v20, keeping this at the tail to allow for the rest of the
>>     series to proceed, while this patch gets discussed.
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index d4d098448e46e..ef0a171ba9677 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -1043,6 +1043,18 @@ static int rmi_memory_notifier(struct notifier_block *nb,
>>   	start = PFN_PHYS(arg->start_pfn);
>>   	end = PFN_PHYS(arg->start_pfn + arg->nr_pages);
>>   
>> +	/*
>> +	 * If the hotplugged memory region is in ZONE_MOVABLE, neither the
>> +	 * guest-memfd nor the kernel allocations can come from there. So we are
>> +	 * fine to skip this.
>> +	 * For boot time memory, we don't allow this discount, as the
>> +	 * decision to move boot memory pages to ZONE_MOVABLE is purely
>> +	 * a kernel choice and the firmware must have decided what it covers.
>> +	 */
>> +	if (page_zonenum(pfn_to_page(arg->start_pfn)) == ZONE_MOVABLE &&
>> +	    page_zonenum(pfn_to_page(arg->start_pfn + arg->nr_pages - 1)) == ZONE_MOVABLE)
>> +		return NOTIFY_DONE;
>> +
> 
> is_zone_movable_page(pfn_to_page(start_pfn)
> 
> as used by virtio-mem should be sufficient. Checking only the start pfn is
> sufficient.

Thanks David, I will update it.

Cheers
Suzuki

> 

