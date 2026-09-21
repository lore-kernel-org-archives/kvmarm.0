Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F2F45DF4F;
	Mon, 21 Sep 2026 09:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981500; cv=none; b=m9oeS7pzucYbUKNO0uLyUiXKEaDE/gYt1/YZBjDClMa2iRh734I3zixhLO1sHLXIlBeEfIp8b5tADlxpGLpVru2Kic2QB1BTkAYpvAFLETo8bmyYBJMgXd5p83akwKvt+JSTqi+xXWkr2aRfPwJM1NOh0vCjxzfnpE8sji/ntdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981500; c=relaxed/simple;
	bh=UE/X0gcMPeiPPSKCeX1gWcGjezEgz5neWZ7i4wm/qgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QU8UVjgdPF/VremLzV+U2dtBHx2Zs2JsBoPehva2cQ3Ag+fkm1DQ1ilfBoFDgsNb+dckQWLHpLyhYAqZX1dpDNK7iMQ/XzVB6DbS+11oIR601oB9YHUNt7drFEYVd3Hnz7YYsqjgk+sTs2uWBIXXJB0Wl9ki0IblebETJQVGXxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Qh7mVIMI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Qh7mVIMI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEA5B1D15;
	Mon, 21 Sep 2026 02:04:54 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 22CA23F86F;
	Mon, 21 Sep 2026 02:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789981498; bh=UE/X0gcMPeiPPSKCeX1gWcGjezEgz5neWZ7i4wm/qgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qh7mVIMImrIyA1UX15dpadr1LMV3Kze+0L28tCkv4dH36w/Hz6pKo+WJZ1W8FVRo+
	 xeEolfEH3D0mZpSL2zzQiFX012Z6mt4274rlFjgoixZGWkKDIVtYHwWY8sdSZN+L+R
	 hQDlfTbxahWEb4hVwqB7ZYrSkcL0cL9cxwfbbXoA=
Message-ID: <5318f467-317b-4d67-a39b-39e5ce1d860c@arm.com>
Date: Mon, 21 Sep 2026 10:04:53 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 5/7] firmware: arm_rmm: Activate the RMM
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-6-suzuki.poulose@arm.com>
 <178978126542.2352296.10527413259157627665.b4-review@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <178978126542.2352296.10527413259157627665.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/09/2026 02:27, Jonathan Cameron wrote:
>> Activate the RMM after the basic configuration. This is a memory transferring,
>> stateful operation.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> With the declaration moved as per standard way of dealing with __free
> magic (there are docs in cleanup.h on this)
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> 
>> ---
>> Changes since v17:
>>   * Inline RMM_ACTIVATE command and remove the definitions from arm-rmi-cmds.h
>>   * Use scope-based cleanup to free sro object
>> Changes since v16:
>>   * Split into a new patch
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 14 +++++++++++++-
>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 4f9898ece754..ecc89e91d264 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -762,6 +762,7 @@ static int rmi_configure(void)
>>   static int __init arm64_init_rmi(void)
>>   {
>>   	int ret;
>> +	struct rmi_sro_state *sro __free(kfree) = NULL;
>>
> Read the guidance in cleanup.h
> 
> This is a path to a potentially grumpy Linus.  He's made the sensible
> point a number of times that putting the declaration of the destructor
> anywhere that isn't right next to the contstructor is a recipe for
> hard to read code and odd bugs (this one isn't buggy,
> but the principle is more general and the readability thing does hold!)

Ack

> 
>>   	/* Continue without realm support if we can't agree on a version */
>>   	ret = rmi_check_version();
>> @@ -776,7 +777,18 @@ static int __init arm64_init_rmi(void)
>>   	if (ret)
>>   		return ret;
>>   
>> -	return 0;
>> +	/* Activate the RMM */
>> +	sro = kmalloc_obj(*sro);
> 
> struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);

Thanks

> 
>> +	if (!sro)
>> +		return -ENOMEM;
>> +
>> +	ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
>> +	if (ret) {
>> +		pr_err("RMM activate failed\n");
>> +		ret = ret < 0 ? ret : -ENXIO;
>    		return ret < 0 ? ...
>> +	}
> 
> return 0;
> Perhaps to make it more obvious that any non 0 return means error?

We want to differentiate between the linux errnos vs RMM errors 
(positive). I will rework this to address the RMI_BLOCKED comment
from Sudeep.

Cheers
Suzuki


> 
> Doesn't really matter
> 

