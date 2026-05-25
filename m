Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420793AC0FF
	for <kvmarm@lists.linux.dev>; Mon, 25 May 2026 06:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692352; cv=none; b=eMKnEFA6HT3JIkIHjgdi40Qv0tElnaeOKMdPWRnd4zrddidmL5UQpfHcQqWR3t1XzhY9ABdN/IkvlaY9fUGHywm/DR3v86VCzvQIgftpZzM9mpfY8xrt2KRM58aBs8Fd3cDkjpUSP5Vg23O3+/Ef5MrGf1ih/R/6j7DpRJyRXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692352; c=relaxed/simple;
	bh=f3dsqInXFwi6ogPU7F9goitGLppUKRtIMT3SF9UiJXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bq4RE81BnkX4u16jmzi+7STusiGi1PnflJQkxZ129nAgnmrNQdv4hNyKUdyBEMJMMzfLWN3G4GULdVA7maSwk0qHZzsKO5oBL+kW6wt+rlwgG1uSQvGKeyNQ8nDTsFPQ78aSZ0vnfPnUOEhuutkwoL33ao+eRDbaeFqRqHuOdOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=co0zKW4G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="co0zKW4G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779692343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YKzbzsmYYSmbqPFZ4+On8kOHavD4IAbzLAjB1X3xbfQ=;
	b=co0zKW4G24l/6wM6QAaVJUH3NzJS9lExIEP9nLKgD4JLY5CUwqs9tZQM3WT507BEdxP/rm
	puMkEC6KzlykOk1U8mdxtAT3Bu0YuMYE/Jfs3TzwKQdMNy5TpPa49cScr/6aSKvaMF5VE0
	HNxEFlb94iduOSRh20+UKmj4yrgHy1o=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-sYU6JKLlPHO9X9wnQpvRzQ-1; Mon, 25 May 2026 02:59:01 -0400
X-MC-Unique: sYU6JKLlPHO9X9wnQpvRzQ-1
X-Mimecast-MFC-AGG-ID: sYU6JKLlPHO9X9wnQpvRzQ_1779692340
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-369467ab5bfso7943603a91.0
        for <kvmarm@lists.linux.dev>; Sun, 24 May 2026 23:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779692340; x=1780297140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YKzbzsmYYSmbqPFZ4+On8kOHavD4IAbzLAjB1X3xbfQ=;
        b=DGIFYhrscUY+/T2EFmMp+K5aBycmQioZiqH7sw/MQEioMy6LDC8izoWIZ6gPQlF3qQ
         +jWMBKnurN85KFSy0zd16Zh14A/uJ9u4UmkPH/7jDpCm9x1q9rQ3UOFrhjFStkoanrl5
         FC1IJAcg8heA4E8F1ppvAxnRPrkLLO3MHN5rYgN4X+jFH2V8x7H+MyYZSVfCdrkA+jjA
         2250PLVTbyuv8CFJBYxTJlVuQcOFf5DDBzewwRbgJxQpnvrYePCcAx38repudonno7OU
         hOugh02VquGmHtxe8aYyyEKBcKosb7UA3yN6Sb1v4nmfGjquay8MyaBPstnb2hE9RHpM
         aVog==
X-Forwarded-Encrypted: i=1; AFNElJ8dlBCmvxMQ+T8YoUxigzoqBs4KZ+D4W0vaL48vYOZewRMnGySy9wk0NCXRJFh24rQpMi39Hc0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzU5Fq/0qWaCkeSEe2j74vApBkKC9XeIvZZ+p3eGOMYNeMrre2G
	Vh0nLejX4EbSTuc8ip84pJ9pYU/wmzj+HFo1gHOl043JuR8dCmBnIxFly2dIeuLTYWndu5nJRLb
	/7+JbPPyoue1vv0QQBmL3FzhI2fll+McKSSehYWF8dlwo+InsUky1qpRgrA==
X-Gm-Gg: Acq92OHobjBkTKVTqzMpDtsTSxB1v15PZHaeSPyJ4codrn5NmGgFzEIQSA7FruDRBt9
	kBx6o76xA0cw9ItKlsKAm51d35zLc1DDibiW3u9qvUz/6D7gOrt/xUkG1aTVkASdDAOpBIyJNQI
	SML0CspkjUo/gVh/NW6BB3EEkI9SMT5+M/YDPPVk846BNoullLb+T8hiFcRgYL7u+TGsdkkC1dy
	6Czoltbspuo8L5aiovoJILAkyxPgCL7eMKYjH5c6RYGO4acVSVAteixuO2cooeihww70rQrAr/H
	OQro0zse+1ei8PC2drSDvVh9PaOE7PIvTLzIkxAvDoiQLbFOSNsK7OIAf8vCGwxR6XcyvsSBL2T
	0IxrocRDCnV+wy5f4tMdQ39vrdCtqkrK/6e1FMLkHZhAv9GWOqpoQoPSgfRRRTDXt
X-Received: by 2002:a17:90b:264a:b0:36a:dd29:d7f5 with SMTP id 98e67ed59e1d1-36add29da45mr2445572a91.15.1779692340142;
        Sun, 24 May 2026 23:59:00 -0700 (PDT)
X-Received: by 2002:a17:90b:264a:b0:36a:dd29:d7f5 with SMTP id 98e67ed59e1d1-36add29da45mr2445545a91.15.1779692339628;
        Sun, 24 May 2026 23:58:59 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a6ec5a287sm4863571a91.0.2026.05.24.23.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2026 23:58:59 -0700 (PDT)
Message-ID: <3a0f6277-2b68-45db-a07f-16a177b0586d@redhat.com>
Date: Mon, 25 May 2026 16:58:44 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/44] arm64: RMI: Check for RMI support at init
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-7-steven.price@arm.com>
 <ee494ecd-8979-40f2-896e-82137abbf440@redhat.com>
 <78425c0d-86c5-457f-b171-a4c8dd3acb7d@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <78425c0d-86c5-457f-b171-a4c8dd3acb7d@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hnFfjZzvWxLdBbQZeklbdkz2gqAFVl2vI0FAgnOn1pk_1779692340
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Steve,

On 5/22/26 1:49 AM, Steven Price wrote:
> On 21/05/2026 01:39, Gavin Shan wrote:
>> On 5/13/26 11:17 PM, Steven Price wrote:
>>> Query the RMI version number and check if it is a compatible version.
>>> The first two feature registers are read and exposed for future code to
>>> use.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> v14:
>>>    * This moves the basic RMI setup into the 'kernel' directory. This is
>>>      because RMI will be used for some features outside of KVM so should
>>>      be available even if KVM isn't compiled in.
>>> ---
>>>    arch/arm64/include/asm/rmi_cmds.h |  3 ++
>>>    arch/arm64/kernel/Makefile        |  2 +-
>>>    arch/arm64/kernel/cpufeature.c    |  1 +
>>>    arch/arm64/kernel/rmi.c           | 65 +++++++++++++++++++++++++++++++
>>>    4 files changed, 70 insertions(+), 1 deletion(-)
>>>    create mode 100644 arch/arm64/kernel/rmi.c
>>>
>>
>> [...]
>>
>>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>>> new file mode 100644
>>> index 000000000000..99c1ccc35c11
>>> --- /dev/null
>>> +++ b/arch/arm64/kernel/rmi.c
>>> @@ -0,0 +1,65 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) 2023-2025 ARM Ltd.
>>> + */
>>> +
>>> +#include <linux/memblock.h>
>>> +
>>> +#include <asm/rmi_cmds.h>
>>> +
>>> +unsigned long rmm_feat_reg0;
>>> +unsigned long rmm_feat_reg1;
>>> +
>>> +static int rmi_check_version(void)
>>> +{
>>> +    struct arm_smccc_res res;
>>> +    unsigned short version_major, version_minor;
>>> +    unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>>> +                             RMI_ABI_MINOR_VERSION);
>>> +    unsigned long aa64pfr0 =
>>> read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
>>> +
>>> +    /* If RME isn't supported, then RMI can't be */
>>> +    if (cpuid_feature_extract_unsigned_field(aa64pfr0,
>>> ID_AA64PFR0_EL1_RME_SHIFT) == 0)
>>> +        return -ENXIO;
>>> +
>>> +    arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>>> +
>>> +    if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>>> +        return -ENXIO;
>>> +
>>> +    version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>>> +    version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>>> +
>>> +    if (res.a0 != RMI_SUCCESS) {
>>> +        unsigned short high_version_major, high_version_minor;
>>> +
>>> +        high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
>>> +        high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
>>> +
>>> +        pr_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
>>> +               version_major, version_minor,
>>> +               high_version_major, high_version_minor,
>>> +               RMI_ABI_MAJOR_VERSION,
>>> +               RMI_ABI_MINOR_VERSION);
>>> +        return -ENXIO;
>>> +    }
>>> +
>>> +    pr_info("RMI ABI version %d.%d\n", version_major, version_minor);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int __init arm64_init_rmi(void)
>>> +{
>>> +    /* Continue without realm support if we can't agree on a version */
>>> +    if (rmi_check_version())
>>> +        return 0;
>>
>> Is this still a valid point that we have to return zero on errors returned
>> from rmi_check_version() or other other function calls like rmi_features()?
>> arm64_init_rmi() is triggered by subsys_initcall() where the return value
>> needs to indicate success or failure. It's fine to return error code from
>> arm64_init_rmi() in the path.
> 
> Hmm, I guess now this is moved to arm64 code this indeed doesn't need
> to. Within a module I believe an error return can fail the module loading.
> 
> I'm not sure it really makes much difference though - if this
> initialisation fails then it's not really an error - it just means the
> feature is unavailable.
> 

I think the return value would be consistent to the value of 'arm64_rmi_is_available'.
'arm64_rmi_is_available' is true when zero is returned, otherwise, 'arm64_rmi_is_available'
is false.

With the consistency between the return value and 'arm64_rmi_is_available', users are
able to know the value of 'arm64_rmi_is_available' through kernel parameter 'initcall_debug'.
With the kernel parameter, the initcalls including arm64_init_rmi() are traced and its
return value is outputted in the traced messages, seeing do_trace_initcall_start().

> Thanks,
> Steve
> 
>>> +
>>> +    if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
>>> +        return 0;
>>> +    if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
>>> +        return 0;
>>> +
>>> +    return 0;
>>> +}
>>> +subsys_initcall(arm64_init_rmi);
>>

Thanks,
Gavin

