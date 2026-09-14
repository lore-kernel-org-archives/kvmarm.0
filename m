Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8BE26A0D5;
	Mon, 14 Sep 2026 06:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367664; cv=none; b=J3RxK2MnI1eNL/SBmC1Qp11g8E5jjure0fxttO4HNr5wqNBOrsX/aeKWmbSPgutwQUtlao5mQ4m7Qho9tPF3xjc6tYlrzh3LJVsCtyySIIHCrij54EfAJBuFb+UNalmxPXre07kTpzIkUd1PZt1xMUv5WR7goj5RRktRJSzCXmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367664; c=relaxed/simple;
	bh=3UFhIq4QHq9TytrWQywRZzXOkkTaNlRDCVMLHz/qIj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m1cFxjEHMYW+JwnhdTChF4wTwHfCgqEiPgiybAd4ztRA0q7q7fMSt9Zo00CKEOs+1YC94sNh0f9ypeGiWfINE2mvoy0l11GwWW7v4n0t09BP1xTAWl32aP5NL/DH7sOW9ymvfehOCf6bAZaVwwimV6GnNJyMqoJVyIEE9EBap6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MK8BiM95; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MK8BiM95"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09A641570;
	Sun, 13 Sep 2026 23:34:18 -0700 (PDT)
Received: from [10.57.10.40] (unknown [10.57.10.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C28623F7B4;
	Sun, 13 Sep 2026 23:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789367661; bh=3UFhIq4QHq9TytrWQywRZzXOkkTaNlRDCVMLHz/qIj0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MK8BiM95/KvV+tBcwk8Ima8+QslWVJKy2xivHr6522TXYYXfDNC/qhggcF5gATKdR
	 TrrjiHONVKxa17sth4M+XYpVIG6qhwn4cZl8lIPEQxa9SjrixubT0ENswtzTlv5p5Y
	 PaCRo9aJG3WP7tak+IsS8z2yN/Q22Li8OhMIbb3s=
Message-ID: <a9587df6-b866-4d3b-880e-638537a96e3a@arm.com>
Date: Mon, 14 Sep 2026 07:34:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-4-suzuki.poulose@arm.com>
 <6d204c05-1338-4ee5-9ac9-5d9447e329ee@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <6d204c05-1338-4ee5-9ac9-5d9447e329ee@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/09/2026 02:21, Gavin Shan wrote:
> On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> RMM v2.0 brings the ability to set the RMM's granule size. Check the
>> feature registers and configure the RMM so that it matches the host's
>> page size. This means that operations can be done with a granularity
>> equal to PAGE_SIZE.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   Changes since v17:
>>    * Move rmi_config_set() out of the header file.
>>    * Print the error message for rmi_config_set if it fails
>>   Changes since v15:
>>    * Actually check the feature register for the host's page-size 
>> support.
>>   Changes since v14:
>>    * Move the implementation into drivers/firmware/arm_rmm.
>>   Changes since v13:
>>    * Moved out of KVM.
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 79 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 79 insertions(+)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> index 2fd538c937dca..5b0e342ce3d58 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -35,6 +35,25 @@ static int rmi_features(unsigned long index, 
>> unsigned long *out)
>>       return args.a0;
>>   }
>> +/**
>> + * rmi_rmm_config_set() - Configure the RMM
>> + * @cfg_ptr: PA of a struct rmm_config
>> + *
>> + * Sets configuration options on the RMM.
>> + *
>> + * Return: RMI return code
>> + */
>> +static int rmi_rmm_config_set(unsigned long cfg_ptr)
>> +{
>> +    struct arm_smccc_1_2_regs regs = {
>> +        SMC_RMI_RMM_CONFIG_SET, cfg_ptr,
>> +    };
>> +
>> +    rmi_smccc_invoke(&regs);
>> +
>> +    return regs.a0;
>> +}
>> +
> 
> The comments for rmi_rmm_config_set() can be dropped since its logic is 
> simply enough and
> the code is self-explainning. Besides, I would move this right before 
> its only caller
> rmi_configure().

Ack

> 
> I would suggest drop this function by combining its logics into the only 
> caller
> rmi_configure(), seeing below for more details.

That looks a bit odd in the middle of a function, given the argument 
setting. I have moved it closer to the configure().

Cheers
Suzuki


