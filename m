Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CFD5234
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695016221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w7TSEWyUXJCeqtg0Djyj65qrS0+HnzgNG2tRE6DrFAI=;
	b=L0Hrdhij1FOUvxkcusm1zmuOs0uI1TzsftvlWLbutCFMadfomLmUCxDSo5PQVILpmX3IB6
	y7PPWIkW9951E2s6T1DsD+LdM9Z9HMVet1A8lFjsPsNbjTBXD1s+BP2QT2XrkxtnPlr1gV
	aUlTybwoROB/hRUIiU2FkWUTxSKWXQw=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-K6ymdxjQPB69Uaa1tqJWVg-1; Mon, 18 Sep 2023 01:50:17 -0400
X-MC-Unique: K6ymdxjQPB69Uaa1tqJWVg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3acfa8f8df3so5138883b6e.3
        for <kvmarm@lists.linux.dev>; Sun, 17 Sep 2023 22:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695016217; x=1695621017;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7TSEWyUXJCeqtg0Djyj65qrS0+HnzgNG2tRE6DrFAI=;
        b=HxNokUSFDB8wri7ijfeibNoj7Eg7ZxxyX8EYFmOudOrbRnjHRC5yfFX227mn3F9Ns/
         ftQ8PZcNZeHKN1pD8supcB9DQgrpMhcLYhlPkXBUBu4njFaanOKddBcvpFyeiGtik3S+
         lXOQUySdUE8cHzHK8T5t2Fqmv5LMbBU7gIjLZXnOIaAAxtnfqgKCxuoMVOVWWUQ+7GeA
         2dpsyTljfZS34xpjFwpBZfxz/Ja/L3jJ7xzT+cFUTVWcw3HpF56VWmZMxot50tXb1ZzK
         CjtVJMa8g1ZbN3xnXAW9uZD4kSLDcOoPx8EN5pCCKoSTX+U3vCEOjpnVf3BxczNAKR0W
         blrA==
X-Gm-Message-State: AOJu0YzGpVGJ2aFxZC6uBqT+aFHFDj8hCAoAOMVibZXfBAgdxuPd41gT
	uHApOO2Mf36WGZT0jOKGqyu6QKf3carKkL9yy9G4O0saOpjDyuhkvbItJ+iBEZHH+lQH2R3KKQv
	8dkfqTNb1LBT9IydX
X-Received: by 2002:aca:121a:0:b0:3a7:8fcd:3325 with SMTP id 26-20020aca121a000000b003a78fcd3325mr10015626ois.17.1695016217209;
        Sun, 17 Sep 2023 22:50:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoCM/tkJCT1jU0h2UbpaP8HBCFgV19s7sjBE5RVSp8/LXycbN7Ov8MEcZYxO77VSRowm8tHQ==
X-Received: by 2002:aca:121a:0:b0:3a7:8fcd:3325 with SMTP id 26-20020aca121a000000b003a78fcd3325mr10015608ois.17.1695016216974;
        Sun, 17 Sep 2023 22:50:16 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id m12-20020a17090a71cc00b00262d079720bsm8127581pjs.29.2023.09.17.22.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 22:50:16 -0700 (PDT)
Message-ID: <b8f430c1-c30f-191f-18c6-f750fa6ba476@redhat.com>
Date: Mon, 18 Sep 2023 15:50:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC PATCH v2 20/35] ACPI: Rename acpi_processor_hotadd_init and
 remove pre-processor guards
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 James Morse <james.morse@arm.com>
Cc: linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org,
 Salil Mehta <salil.mehta@huawei.com>, Russell King <linux@armlinux.org.uk>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
 justin.he@arm.com
References: <20230913163823.7880-1-james.morse@arm.com>
 <20230913163823.7880-21-james.morse@arm.com>
 <20230914151720.00007105@Huawei.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230914151720.00007105@Huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/15/23 00:17, Jonathan Cameron wrote:
> On Wed, 13 Sep 2023 16:38:08 +0000
> James Morse <james.morse@arm.com> wrote:
> 
>> acpi_processor_hotadd_init() will make a CPU present by mapping it
>> based on its hardware id.
>>
>> 'hotadd_init' is ambiguous once there are two different behaviours
>> for cpu hotplug. This is for toggling the _STA present bit. Subsequent
>> patches will add support for toggling the _STA enabled bit, named
>> acpi_processor_make_enabled().
>>
>> Rename it acpi_processor_make_present() to make it clear this is
>> for CPUs that were not previously present.
>>
>> Expose the function prototypes it uses to allow the preprocessor
>> guards to be removed. The IS_ENABLED() check will let the compiler
>> dead-code elimination pass remove this if it isn't going to be
>> used.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> ---
>>   drivers/acpi/acpi_processor.c | 14 +++++---------
>>   include/linux/acpi.h          |  2 --
>>   2 files changed, 5 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
>> index 75257fae10e7..22a15a614f95 100644
>> --- a/drivers/acpi/acpi_processor.c
>> +++ b/drivers/acpi/acpi_processor.c
>> @@ -182,13 +182,15 @@ static void __init acpi_pcc_cpufreq_init(void) {}
>>   #endif /* CONFIG_X86 */
>>   
>>   /* Initialization */
>> -#ifdef CONFIG_ACPI_HOTPLUG_PRESENT_CPU
>> -static int acpi_processor_hotadd_init(struct acpi_processor *pr)
>> +static int acpi_processor_make_present(struct acpi_processor *pr)
>>   {
>>   	unsigned long long sta;
>>   	acpi_status status;
>>   	int ret;
>>   
>> +	if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_PRESENT_CPU))
>> +		return -ENODEV;
>> +
>>   	if (invalid_phys_cpuid(pr->phys_id))
>>   		return -ENODEV;
>>   
>> @@ -222,12 +224,6 @@ static int acpi_processor_hotadd_init(struct acpi_processor *pr)
>>   	cpu_maps_update_done();
>>   	return ret;
>>   }
>> -#else
>> -static inline int acpi_processor_hotadd_init(struct acpi_processor *pr)
>> -{
>> -	return -ENODEV;
>> -}
>> -#endif /* CONFIG_ACPI_HOTPLUG_PRESENT_CPU */
>>   
>>   static int acpi_processor_get_info(struct acpi_device *device)
>>   {
>> @@ -335,7 +331,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>>   	 *  because cpuid <-> apicid mapping is persistent now.
>>   	 */
>>   	if (invalid_logical_cpuid(pr->id) || !cpu_present(pr->id)) {
>> -		int ret = acpi_processor_hotadd_init(pr);
>> +		int ret = acpi_processor_make_present(pr);
>>   
>>   		if (ret)
>>   			return ret;
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index 651dd43976a9..b7ab85857bb7 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -316,12 +316,10 @@ static inline int acpi_processor_evaluate_cst(acpi_handle handle, u32 cpu,
>>   }
>>   #endif
>>   
>> -#ifdef CONFIG_ACPI_HOTPLUG_PRESENT_CPU
>>   /* Arch dependent functions for cpu hotplug support */
>>   int acpi_map_cpu(acpi_handle handle, phys_cpuid_t physid, u32 acpi_id,
>>   		 int *pcpu);
>>   int acpi_unmap_cpu(int cpu);
> 
> I've lost track somewhat but I think the definitions of these are still under ifdefs
> which is messy if nothing else and might cause build issues.
> 

Yup, it's not safe to use 'if (!IS_ENABLED(CONFIG_ACPI_HOTPLUG_PRESENT_CPU))' in
acpi_processor_make_present() until the ifdefs are removed for those two functions
in individual architectures.

>> -#endif /* CONFIG_ACPI_HOTPLUG_PRESENT_CPU */
>>   
>>   #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
>>   int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);

Thanks,
Gavin

