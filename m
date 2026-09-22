Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A91A4EFFC8;
	Tue, 22 Sep 2026 22:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790117764; cv=none; b=pSwVlFCwvj/oXvQ4xtEg1Xkt03F5dnOocaazCtBDql/nHbXF5z6j3wJgpB1UqAy1tBK8VMAT37S7wVPjf17LFqdLFsfDFVHXgc5jLyUuz2gFSlRkbfFDLQJfqg6Pp1ozzK/a2qiAjGWAZSLHsUaelDw0m8lX+20BYVjNOvJJFj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790117764; c=relaxed/simple;
	bh=qVCjW+bKUVgRJaxooxblKpYN+hplHE+53CuW6GhbhWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a+BSCTDlXaTVu+icciRFvMyUiGxoQcrn8ERi1anX1Sr9Q/nGqK0B5vH2RGitMvqVlBkrpuEI59Awm1gz3mlAvZzjAVW6PQEi0R6GcJ/kjjAr9UnNWSfX1VFDbhYHO51P+yYn+69BuLA/HDnA6PZlmXrPrRwfjcOHjbTt4+XX/dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NYFlzv5R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NYFlzv5R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 267771576;
	Tue, 22 Sep 2026 15:55:53 -0700 (PDT)
Received: from [10.57.9.113] (unknown [10.57.9.113])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A07BB3F632;
	Tue, 22 Sep 2026 15:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790117756; bh=qVCjW+bKUVgRJaxooxblKpYN+hplHE+53CuW6GhbhWg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NYFlzv5R7+kCofQIFQDwJs6xa1Tp35O7ZW6qtSA9fT4Pygzy9yDpBiIqnoRsXfoCU
	 Iog5eoTK90Q60dmjkNHrvRS3Q5CEV4M8UtI0CW1l5b4iP1hxxa3rR2tGoXJzpqMeaj
	 c5IADN5feKzMA5TDTPUIgueobeOVzZWzDfkDuvhM=
Message-ID: <2164b046-bbbb-4cfb-b797-5df27fbe313f@arm.com>
Date: Tue, 22 Sep 2026 23:55:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
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
 <20260912083611.2513845-7-suzuki.poulose@arm.com>
 <178978126543.2352296.12214136703168879825.b4-review@b4>
 <65b0c03b-36b9-4e60-aa55-c3b4b85e21ee@arm.com>
 <93aea89c-0a05-4b5a-905d-2e8c14a9e894@arm.com>
 <20260921145838.00003b04@oss.qualcomm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260921145838.00003b04@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/09/2026 22:58, Jonathan Cameron wrote:
> 
>>>>>    static int __init arm64_init_rmi(void)
>>>>>    {
>>>>>        int ret;
>>>>> @@ -786,8 +970,24 @@ static int __init arm64_init_rmi(void)
>>>>>        if (ret) {
>>>>>            pr_err("RMM activate failed\n");
>>>>>            ret = ret < 0 ? ret : -ENXIO;
>>>>> +        return ret;
>>>>
>>>> Why did this change?
>>>
>>> Rebase messed up. I will restore it.
>>
>> Actually this is not. We dont have to check the metadata if
>> we couldn't activate the RMM. Also, the failure path at the
>> bottom has "deactivate", which again is not needed. So
>> it is the right thing to do.
> 
> Only after this patch? Not from the previous patch?
> 
>>
>>>    
>>>>   
>>>>>        }
>>>>> +    ret = rmi_init_metadata();
>>>>> +    if (ret)
>>>>
>>>> And this is hitting another bit of guidance in cleanup.h.
>>>> Functions shouldn't be mixing __free and friends with
>>>> gotos.  Again, not a bug here but there are large ugly
>>>> monsters around this stuff, hence the blanket guidance.
>>>> I haven't thought that hard on how you avoid it here, but
>>>> usually it's a combination of suitable helpers and wrappers
>>>> and resulting code is often more readable as a result.
>>
>> I could change the hunk to something like, but that looks ugly.
>>
>> @@ -1010,20 +1010,12 @@ static int __init arm64_init_rmi(void)
>>                   return ret;
>>           }
>>
>> -       ret = rmi_init_metadata();
>> -       if (ret)
>> -               goto out_deactivate;
>> +       if (!rmi_init_metadata() &&
>> !register_memory_notifier(&rmi_memory_nb)) {
>> +               arm64_rmi_is_available = true;
>> +               pr_info("RMI configured\n");
>> +               return 0;
>> +       }
>>
>> -       ret = register_memory_notifier(&rmi_memory_nb);
>> -       if (ret)
>> -               goto out_deactivate;
>> -
>> -       arm64_rmi_is_available = true;
>> -       pr_info("RMI configured\n");
>> -
>> -       return 0;
>> -
>> -out_deactivate:
>>           WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
>> SMC_RMI_RMM_DEACTIVATE));
>>           return ret;
>>    }
>>
>>
>> Either ways, we have to cleanup the object on return, no matter
>> the route we take. So the original form is much more readable
>> for me.
> 
> Agree to more readable, but that fragility of mixing __free() and
> goto is a real problem that has tripped many folk up - hence
> the perhaps overly strict guidance.  Rather than avoiding the goto, I'd just
> not use __free()  - go old school and have two labels for errors
> and an extra manual free in the good path.
> 
> 	pr_info("RMI configured\n:);
> 	kfree(sro);
> 
> 	return 0;
> 
> out_deactivate:
> 	WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE));
> out_free_sro:
> 	kfree(sro);
> 	return ret;
> }
> 
> Sometime the new toys aren't the right answer.

I have the following hunk on top of this patch, that could do the trick.

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index bcdbed26cf08d..4385f49068965 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -1033,20 +1033,19 @@ static int __init arm64_init_rmi(void)
                 return ret;
         }

-       ret = rmi_init_metadata();
-       if (ret)
-               goto out_deactivate;
-
-       ret = register_memory_notifier(&rmi_memory_nb);
-       if (ret)
-               goto out_deactivate;
-
-       arm64_rmi_is_available = true;
-       pr_info("RMI configured\n");
-
-       return 0;
-
-out_deactivate:
+       do {
+               ret = rmi_init_metadata();
+               if (ret)
+                       break;
+               ret = register_memory_notifier(&rmi_memory_nb);
+               if (ret)
+                       break;
+               arm64_rmi_is_available = true;
+               pr_info("RMI configured\n");
+               return 0;
+       } while (0);
+
+       /* De-activate the RMM and reclaim any donated memory */
         WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, 
SMC_RMI_RMM_DEACTIVATE));
         return ret;

Cheers
Suzuki

> 
> Jonathan
> 
> 
> 
> 
>>
>> Cheers
>> Suzuki
>>
>>>>   
>>>
>>> I will see if I can improve it.
>>>
>>> Cheers
>>> Suzuki
>>>    
>>
> 

