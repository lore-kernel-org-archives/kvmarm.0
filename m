Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EE946A607;
	Wed,  9 Sep 2026 08:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942331; cv=none; b=lMruBbSbrT9SCmgrCIMtL/EbeYbc9YgJgF5ka6JGw1UT8DVrX7cyS+rGsPxL8Qy2/6uPj8Yr17beZxarjSCr60GpFW2NKfxprShEkiBZUyy3l8MaMA++oLOSlZmqUrl+pZePJJJzAdzubw8nF4/gZqaIZaPISrwe2TrjB9H5AMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942331; c=relaxed/simple;
	bh=N24DhcCC5ydA9nr2zsNvy8r3yE4PWUoxuwS0bDkHXGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nfjrOv4GjjDdo3LjOsC6MBi5qUrcwcSYG7TT0FWbBNLboVr48a9kihS1tQ2NvyeWsOSSpR6yzGoaELmQ12SyWp/IEdSHQ5Z7p8YX8so0T/FqSwKERtU8diVWNeYtVtU0LcujWyKBOEiz12Cz5FocYw/e1jHBjEF2Ioludbtg7Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ing/0ysP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ing/0ysP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3ACB51576;
	Wed,  9 Sep 2026 01:25:21 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D21C23F86C;
	Wed,  9 Sep 2026 01:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788942324; bh=N24DhcCC5ydA9nr2zsNvy8r3yE4PWUoxuwS0bDkHXGM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ing/0ysP1l94WDE2visx2y8ApcV1aD4pOHBc2/CvCfjdX59lB3dHvS/pA1ieQ8+4K
	 Mki0U3i0ObXJB8GhUpnMkFyhjRr4zVW/0Q9fk3qRFpUJyiftQu1YoR4p7vYb9puCAb
	 p9Ix0TzUWBl2hkWAUsOIwnfHiowf7LmPqbBb+XW4=
Message-ID: <5e6ce734-d2e8-40b5-a76a-a6c591047123@arm.com>
Date: Wed, 9 Sep 2026 09:25:20 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 5/7] firmware: arm_rmm: Activate the RMM
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-6-suzuki.poulose@arm.com>
 <aac304fa-a371-4210-8703-74281c9748f8@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aac304fa-a371-4210-8703-74281c9748f8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/09/2026 05:29, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> Activate the RMM after the basic configuration. This is a memory 
>> transferring,
>> stateful operation.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v16:
>>   * Split into a new patch
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 17 +++++++++++++++--
>>   include/linux/arm-rmi-cmds.h   | 11 +++++++++++
>>   2 files changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> index 42c973c3a98bb..d969c8738efde 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -641,7 +641,8 @@ static int rmi_configure(void)
>>   static int __init arm64_init_rmi(void)
>>   {
>> -    int ret;
>> +    int ret = 0;
>> +    struct rmi_sro_state *sro = NULL;
> 
> Why we need to initialize those local variables ('ret' and 'sro')? :-)
> Also, we can use the scope-based cleanup function supported by cleanup.h
> for @sro.
> 
>      struct smi_sro_state *sro __free(kfree) = NULL;
> 
> With the scope-based cleanup in place, we needn't explict 'kfree(sro)' at
> end of this function.
> 

Ack.

>>       /* Continue without realm support if we can't agree on a version */
>>       ret = rmi_check_version();
>> @@ -656,7 +657,19 @@ static int __init arm64_init_rmi(void)
>>       if (ret)
>>           return ret;
>> -    return 0;
>> +    /* Activate the RMM */
>> +    sro = kmalloc_obj(*sro);
>> +    if (!sro)
>> +        return -ENOMEM;
> 
>      if (!sro) {
>          pr_err("Unable to alloc SRO object for RMM activation\n");
>          return -ENOMEM;
>      }
> 

Ack

>> +
>> +    ret = rmi_rmm_activate(sro);
>> +    if (ret) {
>> +        pr_err("RMM activate failed\n");
>> +        ret = ret < 0 ? ret : -ENXIO;
>> +    }
>> +
>> +    kfree(sro);
>> +    return ret;
>>   }
>>   /*
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> index fed0f3421895d..dea7c7004d35f 100644
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
>> @@ -64,6 +64,17 @@ static inline int rmi_rmm_config_set(unsigned long 
>> cfg_ptr)
>>       return res.a0;
>>   }
>> +/**
>> + * rmi_rmm_activate() - Activate the RMM
>> + * @sro: Preallocated SRO context to be used
>> + *
>> + * Return: 0 on success, positive RMI result code or negative Linux 
>> error code
>> + */
>> +static inline long rmi_rmm_activate(struct rmi_sro_state *sro)
>> +{
>> +    return rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
>> +}
>> +
> 
> rmi_rmm_acvivate() would be used for once by rmi.c::arm64_init_rmi(). Lets
> not expose the function by combining the logic to rmi.c::arm64_init_rmi().

Have done that already in my local tree.


Thanks for the review.

Cheers
Suzuki


