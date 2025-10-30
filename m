Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412B82FB977
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761830955; cv=none; b=KtnlbolhGc2gjF/ZsVIJ3z66wXpGBUpW6J/alhMsvHckAH0TilnBfvlow78ZYiGpm/0MTURqJW2HnYyh5WKX9FXt6/ADNi05zHwJuDTE5uxmcDGK4FPqfr4yN+GqgzfWj/iggrZnaCi+BFXcO73VGiLJaq9/n1wAtBmY3PkSXK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761830955; c=relaxed/simple;
	bh=Vs0+cyBDqRmqBNfMhGNE41BaBBwZK0FNmTvnCgVzops=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lLFkuBq49dkG/bMCyCxgS5QjzESu+SRNYlJRleHoeIg/nst1D/Rme872g6gPR+MQaLenK2So5CSyIbCiamKtWVXdDJkNCwaP28PFO4DHl6V22FR8NwZtvKOnnBz9GVvL4u8M//uC6HA1+wMyvpzjVam65Lm5ZJ1hDP6e1EAvOsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=sWH6XEuq; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="sWH6XEuq"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59310014b8eso1079840e87.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 06:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1761830951; x=1762435751; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=auJLL78IWvyRiv8Z3SkGGwJVdNC/ugwPZHVGdPaUXw4=;
        b=sWH6XEuq+B1VLIIziZ6MRIMR1AHEQO2OxhOLh5Eb4bsBWvvdbHc9q0xp4ERgwzUHIg
         10tj9wdINy05iHjxd7YqkeVHXcoBm8bWvWsGRZ+WyQSwZoaz8LVDpLVKJedzIH70eXer
         J8tFJWcoNm67NU3UjFKXFmxsNmMXtqoQTjpmY0E5EVvggXcZ7GJ/jsVVsSEtz8KcKg6f
         qgIyMfHBMlQd2JAMw9YfH975NUffpPsYO5SwJeI1JPZf9BOTHnlRibbS40Tvuc+VXYlD
         Z49GcmK9G/L4u+qj1wKLKQxCF+HIJqrXTMYEdaZ+gcyChSvYgJ7mZnNjVjeiBHwchcqw
         UVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761830951; x=1762435751;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=auJLL78IWvyRiv8Z3SkGGwJVdNC/ugwPZHVGdPaUXw4=;
        b=Dia2m3rPJ3orK6LJd1wRQGs93PLzykQJmmDdngZpVxFs6rNxvB+NUSR29/V0K0oyRJ
         btXzQnM8Evc1L0EcULefsmhpNtggkfk6gs9/Atic1u02XJEt5k/niUAO4BVXcmLv4aCt
         iMEbxjEW8XrtzxhRcV6Mdihd4lOXGXKelUKSh2P74kRSHM7A7jtyeLUKyNXkHScweJ9y
         q8dce1mbVgUn0JgfgxZpJDmp8QKjthTc/pLpQpM3VlEO2hlXOwkVLdOOVpDD4aZC90l2
         naRmbrUqJjyypZXP0mqqNvUvbKmyDSAji7jRqf8EJ+9eUvTjpAUDacMaS6vkfkzvyt39
         2ONw==
X-Forwarded-Encrypted: i=1; AJvYcCVbkWrGCKVu8+5eNSB99kwoks0msF+haBE4UmN2dz6OzOJrQDtrdrbsPaLUry2GbYZOc1U+OZY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx63kPzR+nGwuTQ4FwMkRDwlWjS+a50vWMJOf9kkeOaWfvA2IoL
	R6g2ItFBU8S1/cRudzz4AGP+EBoMupMi8VO33EsJymJFN5NpHb3tMVRFQknr6T3vDQg=
X-Gm-Gg: ASbGncswT+u62pwxakgzd5eWMeFfFDkIDXwwHtFmGJ0fn8HxL/bvfzrnPeoVt1EUkHp
	25+2pKuP8yW4oq2IKAqL03Bc2GrY2WWmGET9/DEsLndYiFr3ZHQr2lzfju9CG5hjID+NbX8Pdhk
	fZU4kz/Eyl9uB0KQUNLye7/bcGqXr8aZsCuSJlCdImBG1fxSFeivuog3f0v5cxxW2JIl+j8nnxZ
	PjDfJ3QlNIBugC0woIl+v5U8gAfhkJvD3bDPFejdjEgJDvj1CgLxJf8IdsHAmrypFRZftlGh7eO
	1+FpifL3W4eALU0+XUtk9rzqDiqpAqyAz0cJtPx02a+gP/pwnS1qXSYp7++cfe0Hb6kSzLtPsV/
	Ma/VCsqYaPJtJ8vjB339ITelXnBiXoTyyiWikzw919ktg4jgbrMJdOB2QbCeqMY9lngzmbkL2JU
	Sj/9i/EVrVArKI6aw40mnWbVYqpamAfRuosNaU1hcae5mf3d9dWrfFVWKsGwLzRLMIOQ==
X-Google-Smtp-Source: AGHT+IH+7r03/reqlDO5F/xWopHhAZmJ6AzdE8dl2+vnGjXgF+KVVuZqJNmKyiG5BCz+kU/FitGyxg==
X-Received: by 2002:a05:6512:2312:b0:591:d903:4384 with SMTP id 2adb3069b0e04-594128df108mr2867146e87.51.1761830950729;
        Thu, 30 Oct 2025 06:29:10 -0700 (PDT)
Received: from [192.168.1.11] (0x5da5f0d7.static.cust.fastspeed.dk. [93.165.240.215])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59301f48bc5sm4562968e87.30.2025.10.30.06.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 06:29:09 -0700 (PDT)
Message-ID: <96171283-6f2a-45b5-b889-be1bee91678c@immunant.com>
Date: Thu, 30 Oct 2025 14:29:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: arm64: support optional calls of FF-A v1.2
To: Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, perlarsen@google.com, ayrton@google.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-3-yeoreum.yun@arm.com>
 <f5aa3c19-fdea-4f62-9541-530e59b20a87@arm.com>
 <aQEwVe8+okm/Nmso@e129823.arm.com>
 <61e923d6-388b-4cc6-8c26-5581a1e1cc10@arm.com>
 <aQIYZoP5iKcwtXwW@e129823.arm.com>
Content-Language: en-US
From: Per Larsen <perl@immunant.com>
In-Reply-To: <aQIYZoP5iKcwtXwW@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yeoreum,

On 10/29/25 2:36 PM, Yeoreum Yun wrote:
> Hi Ben,
> 
>>
>> On 10/28/25 21:06, Yeoreum Yun wrote:
>>> Hi Ben,
>>>
>>>>> To use TPM drvier which uses CRB over FF-A with FFA_DIRECT_REQ2,
>>>>> support the FF-A v1.2's optinal calls by querying whether
>>>>> SPMC supports those.
>>>>>
>>>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>>>> ---
>>>>>   arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
>>>>>   1 file changed, 18 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
>>>>> index 0ae87ff61758..9ded1c6369b9 100644
>>>>> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
>>>>> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
>>>>> @@ -646,6 +646,22 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>>>>>   		ffa_to_smccc_res(res, ret);
>>>>>   }
>>>>>
>>>>> +static bool ffa_1_2_optional_calls_supported(u64 func_id)
>>>>> +{
>>>>> +	struct arm_smccc_1_2_regs res;
>>>>> +
>>>>> +	if (!smp_load_acquire(&has_version_negotiated) ||
>>>>> +		(FFA_MINOR_VERSION(FFA_VERSION_1_2) < 2))
>>>>> +		return false;
>>>>> +
>>>>> +	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
>>>>> +		.a0 = FFA_FEATURES,
>>>>> +		.a1 = func_id,
>>>>> +	}, &res);
>>>>> +
>>>>> +	return res.a0 == FFA_SUCCESS;
>>>>> +}
>>>>> +
>>>>>   /*
>>>>>    * Is a given FFA function supported, either by forwarding on directly
>>>>>    * or by handling at EL2?
>>>>> @@ -678,12 +694,13 @@ static bool ffa_call_supported(u64 func_id)
>>>>>   	case FFA_NOTIFICATION_SET:
>>>>>   	case FFA_NOTIFICATION_GET:
>>>>>   	case FFA_NOTIFICATION_INFO_GET:
>>>>> +		return false;
>>>>>   	/* Optional interfaces added in FF-A 1.2 */
>>>>>   	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
>>>>>   	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
>>>>>   	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
>>>>
>>>> Looking at table 13.54 in the FF-A 1.2 spec FFA_CONSOLE_LOG is only supported in secure FF-A
>>>> instances and not from the normal world.
>>>
>>> Thanks. in that case, we can return false for FFA_CONSOLE_LOG
>>> unconditionally.
>>>
>>>>
>>>>>   	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
>>>>> -		return false;
>>>>> +		return ffa_1_2_optional_calls_supported(func_id);
>>>>>   	}
>>>>
>>>> I don't think that an smc call here is the right thing to do. This changes this from a light
>>>> weight deny list to an extra smc call for each ffa_msg_send_direct_req2 from the driver.
>>>>
>>>> Instead, I would expect this patch just to remove FFA_MSG_SEND_DIRECT_REQ2 from the deny list
>>>> and rely on the TPM driver to use FFA_FEATURES to check whether it's supported.
>>>>
>>>> So, just this change:
>>>>
>>>> @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
>>>>          case FFA_NOTIFICATION_GET:
>>>>          case FFA_NOTIFICATION_INFO_GET:
>>>>          /* Optional interfaces added in FF-A 1.2 */
>>>> -       case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
>>>>          case FFA_MSG_SEND_DIRECT_RESP2:         /* Optional per 7.5.1 */
>>>>          case FFA_CONSOLE_LOG:                   /* Optional per 13.1: not in Table 13.1 */
>>>>          case FFA_PARTITION_INFO_GET_REGS:       /* Optional for virtual instances per 13.1 */
>>>>
>>>> Am I missing something?
>>>
>>> Nope. I think you don't think you miss anything and
>>> I also think about it.
>>>
>>> But, I'm not sure about "support" means in the pkvm about FF-A.
>>> Anyway unless the SPMC doesn't support the specific FF-A ABI,
>>> I don't know that's meaningful to return "TRUE" in here.
>>> IOW, suppose pkvm returns supports of  FFA_MSG_SEND_DIRECT_REQ2
>>> but user receive when it calls FFA_MSG_SEND_DIRECT_REQ2 with NOT SUPPORTED.
>>
>> As I understand it, the ffa_call_supported() is used in two places:
>> 1. To return NOT SUPPORTED to an FFA_FEATURE call for ffa calls that are
>> on the deny list.
>> 2. To block ffa calls if they are on the deny list.
>>
>> For both your patch and just removing FFA_MSG_SEND_DIRECT_REQ2 from the
>> denylist I think the behaviour is the same.
>>
>> If FFA_MSG_SEND_DIRECT_REQ2 is not supported at the spmc then:
>> a) an FFA_FEATURE call will return not supported
>> b) an FFA_MSG_SEND_DIRECT_REQ2 will return not supported
>>
> 
> Right! I've missed the FFA_FEATURE handles via default_host_smc_handler().
> As you said, it just a deny list.
> 
> Thanks. I'll change it.
Sorry to jump into the discussion very late. I uploaded a patch set 
which adds support for the FFA_MSG_SEND_DIRECT_REQ2 interface which was 
originally developed for the Android common kernels:

https://lore.kernel.org/all/20251030-host-direct-messages-v1-0-463e57871c8f@google.com/T/#t 


Since there appears to be an upstream use case for this functionality, 
it might be a good building block for the present patch set.

Thanks,
Per
