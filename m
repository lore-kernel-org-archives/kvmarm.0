Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5A123D297
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 22:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788820864; cv=none; b=upuOoDKBpwbVBY/rRiyDCuuP3ZTfDyyAMYAZq8eLeCVPSijjA7kJ0SYMZT3ZJduU8r3AGLPAftRMyjVNCV5HAjLGxZUQqq0IywAiNib7plGHC5LEtUdplkw+zJbTlU6NC/r9Pn6dpfPNX69iKZ/93GjP/GlCWjMM9ECHHvWPgdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788820864; c=relaxed/simple;
	bh=w6hnYrwGa6fUIEho02iLQbUb4586aB2uHSK/Hsp/sHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WhPquq1G6pH11zCgPnzZN5PhggKWlSzfbtg5sVTW5qOVr/symBXcxGgtdmJqb6ukwKWKD82SbNbArcj+8i3xXJfswHhQ34R/g3b1uB5EgLnBfnophSAqurHP4SA0GP/ckfoG1xz0LCxVVMRAbZr2f7FGNGrgHoBzFf07yKmknNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpNUMHaN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpNUMHaN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788820862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L602+dgOHuBuqXjtZSYxQyf+Lxw66t1x8qHXG257FZg=;
	b=CpNUMHaNfUDnX8+wCMSlcEercrwuB8Xmn8f9uH54AY9RfQCTBzY1iz3qtbQPFPhz287fva
	dXSiJmzT5JK7bKQzPA3smh4htnsoKgYc6/Is4ZertNfsQ2OskBzlO0O+3Fxqdo/9gVsHGN
	eJ6QzG+Y0NpZuGKZCOCPgXEbMhrd2YM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-9VoBi05_NZ-XggAuSog1DQ-1; Mon, 07 Sep 2026 18:41:00 -0400
X-MC-Unique: 9VoBi05_NZ-XggAuSog1DQ-1
X-Mimecast-MFC-AGG-ID: 9VoBi05_NZ-XggAuSog1DQ_1788820860
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d001671a54so69193295ad.2
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 15:41:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788820860; x=1789425660;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L602+dgOHuBuqXjtZSYxQyf+Lxw66t1x8qHXG257FZg=;
        b=ZXvRqIxm0udv1MXFAOGpSHBL37JULwjpp2RPlDHOFpAVyCmZ1zaE8peEdFHZ5tWbNb
         kBCE49r7EDC8ji/7o1ADCpruolXR1ynVNTes2+t9zG+c05xQNW9wZK5/GIobJ1KFSpk+
         8bCIgXG8ijyrhQUNbTwuBuxZMqWZalfF3oeVh94EfWc623GNv3jshtYJ05a/PLBFhkM0
         Yf8cLgp8zLIza16E0qEREqnRZ8LcGZdLRn/azpBQKl2kbmZDAT7xfr6CW8TMFLjd35nH
         CtgCgZLhJ5CUpivv9R98ieVgLPF35A9ge6eTdBveNgWTeF5C94RtOtW2yo4tZ3ot8PTD
         JIfg==
X-Gm-Message-State: AFuF++mg26dUwE5pXM978GJbOumNGZ6DW2IcF3yDj2O9vjDS7kuxAFzH
	M6S1PuJapyOx4Rcw+yRKcivez2v6LdCiq2AUsB6r2ZD2uYkZB2Yk5STeZsTW+qff724lXNT9g1x
	o09pxceOOcCSDsIk33cKQjgJleXEF0kOd3hfR4PNCjQ0ysIuyRMQKc23wbQ==
X-Gm-Gg: AYBFou26rym0KI1mDN6CosA1Wx1YLFUJFgQFCPRFIplaZ6jbjdb7XAiLt6Sb5EKHknk
	HYgPmXWr92DppZqqBfMwlv5jXlo/htAX0wvUu0q2BAONM2788SQ5R0n6VphrK+bDfbMKYlSo4Hy
	64tJY5+Dzo9wDtAImQHpz8VsV69HpjZySIyx4P8huruFjG3hTOggBtgo1IjfvYU8E8pdurDMJdT
	WLBYmY4jWKyrQNACA9KOQVCslYCDivHfDhi54pZ2jFavkU5T/5TLLedRJOuP/AoBzN8BjD42hNE
	n0DgERvdPPm5/LUGjGfgyF1wXgpWdDI7Ir9dt2yAJa/4l3eNLgewL2rIZ123vCse8IJd0zbQMzf
	RHId+UEtCK8VfLPxinWjWv1MrAg7J9JVr4Eiu2B3psA==
X-Received: by 2002:a17:902:6ac3:b0:2ca:6c8:abd8 with SMTP id d9443c01a7336-2db127cde0fmr287844995ad.12.1788820859678;
        Mon, 07 Sep 2026 15:40:59 -0700 (PDT)
X-Received: by 2002:a17:902:6ac3:b0:2ca:6c8:abd8 with SMTP id d9443c01a7336-2db127cde0fmr287844615ad.12.1788820859141;
        Mon, 07 Sep 2026 15:40:59 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db146b9691sm49351165ad.0.2026.09.07.15.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 15:40:58 -0700 (PDT)
Message-ID: <64533fd0-5fe7-4839-8302-c5b6674bcb5a@redhat.com>
Date: Tue, 8 Sep 2026 08:40:50 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 3/7] firmware: arm_rmm: Configure the RMM with the
 host's page size
To: Suzuki K Poulose <suzuki.poulose@arm.com>, sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-4-suzuki.poulose@arm.com>
 <20260907101446.1DA321F00A3A@smtp.kernel.org>
 <bade4920-2db1-4a8a-99d1-ca2694647ec8@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <bade4920-2db1-4a8a-99d1-ca2694647ec8@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jHCKOTeeA30VmDeJeiEBZIWMLo3g1_brzXGYOL0Mo_w_1788820860
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Suzuki,

On 9/7/26 10:02 PM, Suzuki K Poulose wrote:
> On 07/09/2026 11:14, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>> - [High] The SMC call leaves parameters X2-X7 uninitialized, violating the RMM's RES0 requirement.
>> - [High] The `struct rmm_config` fields are populated using native endianness, which breaks on Big Endian kernels.
>> -- 
>>
>> commit 1741e17729c2ff5e23bc8bfb00cc50a61f38ebb7
>> Author: Steven Price <steven.price@arm.com>
>> firmware: arm_rmm: Configure the RMM with the host's page size
>>
>> This commit adds support to configure the RMM's granule size to match the
>> host's page size during kernel initialization. It reads the feature
>> registers to ensure the requested page size is supported and sends the
>> configuration to the RMM via an SMC call.
>>
>>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>>> index 008a783407b4e..76f91c145e1fd 100644
>>> --- a/drivers/firmware/arm_rmm/rmi.c
>>> +++ b/drivers/firmware/arm_rmm/rmi.c
>>> @@ -77,6 +77,60 @@ static int rmi_read_features(void)
>>>       return 0;
>>>   }
>>> +static int rmi_configure(void)
>>> +{
>>> +    unsigned long granule_feature;
>>> +    unsigned long granule_size;
>>> +    int ret = 0;
>>> +    struct rmm_config *config;
>>> +
>>> +    switch (PAGE_SIZE) {
>> [ ... ]
>>> +
>>> +    config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
>>> +    if (!config)
>>> +        return -ENOMEM;
>>> +
>>> +    config->rmi_granule_size = granule_size;
>>> +
>>> +    /*
>>> +     * For now we set the tracking_region_size to 0 which is the only option
>>> +     * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
>>> +     * TODO: Support other tracking sizes via Kconfig option for other
>>> +     * PAGE_SIZES
>>> +     */
>>> +    config->tracking_region_size = 0;
>>
>> [Severity: High]
>> Does this code handle endianness correctly?
>>
>> The struct rmm_config fields are populated using native u64 assignments.
>> On an ARM64 kernel compiled with CONFIG_CPU_BIG_ENDIAN=y, this writes
>> big-endian bytes into the shared memory. The RMM, which runs in little-endian
>> at EL2, will misinterpret these fields.
>>
>> Will this cause the RMM firmware to read invalid configuration values (like a
>> byte-swapped granule size) and fail to configure, breaking RMI support on Big
>> Endian systems?
>>
> 
> We don't plan to support RMM for Big Endian Linux. I have now made the ARCH_SUPPORTS_RMM to depend on !CPU_BIG_ENDIAN
> 

You probably need to avoid referring to CPU_BIG_ENDIAN as it's being dropped
by PATCH[v2 13/14] in Will's series to removed unused big-endian support on
arm64 [1].

[1] [PATCH v2 00/14] arm64: Remove unused big-endian support
     (https://lore.kernel.org/linux-arm-kernel/20260907163726.17104-14-will@kernel.org/)

Thanks,
Gavin

>>> +
>>> +    ret = rmi_rmm_config_set(virt_to_phys(config));
>>> +    if (ret) {
>>> +        pr_err("RMM config set failed\n");
>>> +        ret = -EINVAL;
>>> +    }
>>> +
>>> +    free_page((unsigned long)config);
>>> +    return ret;
>>> +}
>> [ ... ]
>>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>>> index 2fb1f7f86d71e..9aa27697e2377 100644
>>> --- a/include/linux/arm-rmi-cmds.h
>>> +++ b/include/linux/arm-rmi-cmds.h
>>> @@ -12,6 +12,23 @@
>>>   unsigned long rmi_feat_reg(unsigned long id);
>>> +/**
>>> + * rmi_rmm_config_set() - Configure the RMM
>>> + * @cfg_ptr: PA of a struct rmm_config
>>> + *
>>> + * Sets configuration options on the RMM.
>>> + *
>>> + * Return: RMI return code
>>> + */
>>> +static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
>>> +{
>>> +    struct arm_smccc_res res;
>>> +
>>> +    arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
>>
>> [Severity: High]
>> Does this SMC call leave parameters x2 through x7 uninitialized?
>>
>> The arm_smccc_1_1_invoke macro only generates inline assembly constraints
>> for the explicitly provided arguments. It does not zero-pad omitted arguments,
>> leaving registers x2 through x7 with whatever was previously in them.
>>
>> Since the RMM firmware expects unused SMC parameters to be zero (RES0),
>> could passing uninitialized values cause the RMM to reject the command
>> with an INVALID_PARAMETER error and sporadically break RMM initialization?
> 
> Correct, I have now moved all RMI calls to smccc_1_2, making sure that
> all the undefined arguments are initialised to 0.
> 
> Cheers
> Suzuki
> 
> 
>>
>>> +
>>> +    return res.a0;
>>> +}
>>
> 
> 

