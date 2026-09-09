Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC95F47F2C9;
	Wed,  9 Sep 2026 08:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788944138; cv=none; b=bRnMnrWzmU9CkwJAWJBqxrfp3FGoTxapc2JsnuR9jING7s3UuP+U30OIdGqlcoo79nwQmC+BHwVxVBe/n+Uo/u0XVJnrAw6mJFDVHNCUX4scS21OYtyzrtF/kfgJDEitgbej7unsnlbsTyLgx5H9dwKnJA2eFgp5ZlIXdtrSt2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788944138; c=relaxed/simple;
	bh=lJDJz6lETRllb1wBQU19zV4OLNHqoK3MIQ/bs71SEBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGs6XX/oTXuRzDu18gVi8fIEzMJauqybvccJISLcZKOOKpL/37ZWvEzAfFkVY261CBON9aNTULwEnhdetE1tbxTU2wGmOl2Rla83IIsz6/Q4aRJqVtVLB7lfHiJdtVLxsvClJPOTsVyoUaE+es3m4hJviA+r9dGDArRpPTJuaik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LZXOxeag; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LZXOxeag"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60CB31576;
	Wed,  9 Sep 2026 01:55:31 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66B0E3F7B4;
	Wed,  9 Sep 2026 01:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788944135; bh=lJDJz6lETRllb1wBQU19zV4OLNHqoK3MIQ/bs71SEBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LZXOxeaghjFTVejUYIz42ta9EdC/XzJtbaXMq7kG5rYlpmWL0I9CHrpcDsUMw5j67
	 5DyX181jUhzTNqnqD+cX0PchoWXiDxLuhN6TGcCTQxw7rTSd4wSUfayizASiLuT7tB
	 xCbp4eyGD/aT2RavQKL3aJGnaTJ6x+WQzEe/PeHM=
Message-ID: <aa928fb0-1aad-4244-8b03-85a87db35dad@arm.com>
Date: Wed, 9 Sep 2026 09:55:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 7/7] firmware: arm_rmm: Add wrappers for Realm related
 RMI commands
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-8-suzuki.poulose@arm.com>
 <de7e2d98-2faa-4e16-8164-d7247d31dbd5@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <de7e2d98-2faa-4e16-8164-d7247d31dbd5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/09/2026 08:15, Gavin Shan wrote:
> On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> Introduce wrappers for the RMI functions needed for creating and
>> managing realm guests. This will be used by the KVM to manage the
>> Realms
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v16:
>>    * Split into a separate patch and move away from arch/arm64 to
>>      include/linux/.
>>    * Also moved into the firmware_rmm series from the KVM CCA support.
>>      This is done in a hope to reduce the merge conflicts and make
>>      the KVM CCA upstreaming in independent parallel chunks
>> ---
>>   include/linux/arm-rmi-cmds.h | 453 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 453 insertions(+)
>>
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> index 79e2c1f165112..746257d77dd61 100644
>> --- a/include/linux/arm-rmi-cmds.h
>> +++ b/include/linux/arm-rmi-cmds.h
>> @@ -222,4 +222,457 @@ static inline long 
>> rmi_granule_range_undelegate(unsigned long base,
>>       return ret;
>>   }
>> +/**
>> + * rmi_rtt_data_map_init() - Create a protected mapping with data 
>> contents
>                                  
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> s/Create a protected mapping with data contents/Create a mappings in 
> protected IPA with known contents

Ack.

> 
> With this, it's consistently counterpart of the comments for 
> rmi_rtt_data_map().
> 
>
>

...


> 
> The nested if statements can be avoided if we have:
> 
>      if (ret != RMI_SUCCESS)
>          return ret;
> 
>      if (out_top)
>          *out_top = regs.a1;
>      if (out_range)
>          *out_range = regs.a2;
>      if (out_count)
>          *out_count = regs.a3;
> 
>      return RMI_SUCCESS;

Done for all of them.

...
>> +/**
>> + * rmi_realm_activate() - Active a realm
>> + * @rd: PA of the RD
>> + *
>> + * Mark a realm as Active signalling that creation is complete and 
>> allowing
>                                                           ^^^^^^^^
> 
> s/complete/completed ?

I have changed this :

  /**
- * rmi_realm_activate() - Active a realm
+ * rmi_realm_activate() - Activate a realm
   * @rd: PA of the RD
   *
- * Mark a realm as Active signalling that creation is complete and allowing
+ * Mark a realm as Active, signalling that creation is completed, allowing
   * execution of the realm.

Addressed the rest of the comments.

Thank you for your detailed look at the patches, much appreciated !

Cheers
Suzuki
