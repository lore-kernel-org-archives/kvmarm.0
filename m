Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6B0DDC1
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747149134; cv=none; b=ZLvVDuJt4E8vaOMeTjWKrsXRM63iL2H0BH9wDucE/AtS2f2oavJxGfex3ejIZst5/ozUVahjdaI7in8jvwQ/xI9Mv2n/AoVNsdvwAVBHG7ZzPEvMT0ZU7o+4TPsyPid6zaVcJqwKudGX/NODmmfYeh7PDelvAZs3NO11iVe7D20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747149134; c=relaxed/simple;
	bh=6iZl9S4154iRf5imzlhS0ufjexBvA/6fq/N+eKhXqQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TZ2URCY37CTDymFfbBlN2qcev2AgkzRhhAUMxBvzYwaV5ACB3o+HMydHOYKEBdkokKmtCyp6Kc3N4vxLkA4+fsfcIK9Bx6paCQlo1Ns6/gaVw2z7hXX65juWcVqglfGxdNOb/vQ140sSh38VxyZqRuq7c0JAfVQaau2iheYkhcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmiP0BWP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmiP0BWP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747149131;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/KQTBCUFT6lIczxYv9kya2WRKORWdtfT/IOQQeFA4I=;
	b=cmiP0BWPAGr6kyGci+k5KeZcMo4tQ7mm6bDKpXXoaySQNGwKa3X3KJRMjKjFY5l2EUuUCk
	5IIWLTmHaYERV9FFz30IEIcYe2AJPu1AZ2tTTtH74PjYjMf+lPYpKqJ03DztWli6c56Gdp
	kV5pM9kONAuAnluAlBXealAwPYXNWk4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-0poZA9_wPNO3R7nkuAQUtQ-1; Tue, 13 May 2025 11:12:04 -0400
X-MC-Unique: 0poZA9_wPNO3R7nkuAQUtQ-1
X-Mimecast-MFC-AGG-ID: 0poZA9_wPNO3R7nkuAQUtQ_1747149123
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-442ccf0eb4eso42564515e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 08:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747149123; x=1747753923;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8/KQTBCUFT6lIczxYv9kya2WRKORWdtfT/IOQQeFA4I=;
        b=P8EJ2H01IYOU+QWSLYI8k5KlghogLO+xhja7SK4BC4bk1qkm+HR1Z0qeZwfVjtwVq9
         P8+dZ5KTPQJ8mvhwS3j2QC02KpCGVLcHxZubkNhGyQ672CuN2vUxHXjEiqPcgXs/s0Nf
         cEpBq3xDotUsaTplrbaaaoD6a2MdIYGEKHCyrXBBJEPGBy3G0iLsHdZGEBpM9AygT6kz
         A535cXIKQQu64cN6y3h4yl3s7Eiz4RkN+OCn2zDk5rcL86EZAmuNWKZ5U+4yH4YUkY1u
         owzppVgb2iPK9P076zBgE772xUIQT25eLJ5aSB1SZL5tP627edKbnWWeXjTUAfyJgV8i
         1oMw==
X-Forwarded-Encrypted: i=1; AJvYcCUGCHwqg3caTNDamxjaSwi/vi992fl6TgJmKWwmvYiEoGX+3EOG1q2clrJZqYvvb2KMERof91A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQLthYzPoDR9lSzlSaGZlhSh1dmD2+tyYqHnmBclPXnHgUxTma
	rWJYkEIK1K5NifkXYAihz4us4ICf13eP8RZazf9Vd53hsWQrIfaaAUO7//oxL6Ihms/BX2xkRW+
	ODIwAOBHDJ8eeimKUtMG1vMOUBg+IrBuf4e4YAQdvlJ4eZDHctcfTUg==
X-Gm-Gg: ASbGncuI+DKuKRhbgr9BTfa1ITe6AXiDEa3cJLyQV842YpQ8hKTZvO1rX0qlAmyoEHg
	qFcS/+a68KN0kSlvZ9xPSNO6L4eldJ+OrtXOqukDtgDyS5Ous1b1CfLAAIPj6/6jh5J6RCK7D01
	D/6KMuJsxvCzXoXD02j31sPbxvBRMji1Z1QD7oy8h+io7lqXAyoszejZqxU7uujQtxUNZnMug5l
	z6JvhTWfjfcq1n5dDUF9NPEUPeGnhjx8REZ7CI/qS7ODmzuHugInryjCRNg1d/WB0KRo647Jg4M
	qRrEyFkCouiDgLzZO4puX8dXbw4OS7RxzDaBMDGMVH8kPWdLO+Y4xCEP0mI=
X-Received: by 2002:a05:600c:4454:b0:440:6a5f:c308 with SMTP id 5b1f17b1804b1-442d6d44bd0mr180390815e9.13.1747149122880;
        Tue, 13 May 2025 08:12:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEWMXqYkLvMeaU7iQvq+Zw2kcbCGYoc0n05zU9v6tGqcMeMfS9BUjhUzvzh7oe31939OLWUQ==
X-Received: by 2002:a05:600c:4454:b0:440:6a5f:c308 with SMTP id 5b1f17b1804b1-442d6d44bd0mr180390485e9.13.1747149122480;
        Tue, 13 May 2025 08:12:02 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4c76dsm16745142f8f.92.2025.05.13.08.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 08:12:01 -0700 (PDT)
Message-ID: <3ad1d053-8a11-4a28-9a94-778389addfeb@redhat.com>
Date: Tue, 13 May 2025 17:12:00 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 01/10] arm/cpu: Add infra to handle generated ID
 register definitions
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 philmd@linaro.org, pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-2-cohuck@redhat.com>
 <6c06a198-1608-4919-8b6e-68e3c28c2526@redhat.com> <87bjrwppwj.fsf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87bjrwppwj.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gSgQrGBvjgRkZVpce1ufgiCVC5eEZPsNZu-va7VQYSE_1747149123
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/13/25 4:05 PM, Cornelia Huck wrote:
> On Tue, May 13 2025, Eric Auger <eric.auger@redhat.com> wrote:
>
>> Hi Connie,
>>
>> On 4/14/25 6:38 PM, Cornelia Huck wrote:
>>> From: Eric Auger <eric.auger@redhat.com>
>>>
>>> The known ID regs are described in a new initialization function
>>> dubbed initialize_cpu_sysreg_properties(). That code will be
>>> automatically generated from linux arch/arm64/tools/sysreg. For the
>>> time being let's just describe a single id reg, CTR_EL0. In this
>>> description we only care about non RES/RAZ fields, ie. named fields.
>>>
>>> The registers are populated in an array indexed by ARMIDRegisterIdx
>>> and their fields are added in a sorted list.
>>>
>>> [CH: adapted to reworked register storage]
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  target/arm/cpu-custom.h            | 60 ++++++++++++++++++++++++++++++
>>>  target/arm/cpu-sysreg-properties.c | 41 ++++++++++++++++++++
>>>  target/arm/cpu64.c                 |  2 +
>>>  target/arm/meson.build             |  1 +
>>>  4 files changed, 104 insertions(+)
>>>  create mode 100644 target/arm/cpu-custom.h
>> do we still want reference to the "custom" terminology, following
>> initial comments?
> Hm, maybe 'cpu-idregs.h'?
OK for me

Eric
>
>>>  create mode 100644 target/arm/cpu-sysreg-properties.c
>>>
>>> diff --git a/target/arm/cpu-custom.h b/target/arm/cpu-custom.h
>>> new file mode 100644
>>> index 000000000000..615347376e56
>>> --- /dev/null
>>> +++ b/target/arm/cpu-custom.h
>>> @@ -0,0 +1,60 @@
>>> +/*
>>> + * handle ID registers and their fields
>>> + *
>>> + * SPDX-License-Identifier: GPL-2.0-or-later
>>> + */
>>> +#ifndef ARM_CPU_CUSTOM_H
>>> +#define ARM_CPU_CUSTOM_H
>>> +
>>> +#include "qemu/osdep.h"
>>> +#include "qemu/error-report.h"
>>> +#include "cpu.h"
>>> +#include "cpu-sysregs.h"
>>> +
>>> +typedef struct ARM64SysRegField {
>>> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
>>> +    int index;
>> worth to add a comment saying this is the ARMIDRegisterIdx of the parent
>> sysreg.
> ok
>
>>> +    int lower;
>>> +    int upper;
>>> +} ARM64SysRegField;
>>> +
>>> +typedef struct ARM64SysReg {
>>> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
>>> +    ARMSysRegs sysreg;
>>> +    int index;
>> now that we have different kinds of indexing, may be worth adding a
>> comment to explain which one is being used.
>> I guess here it is ARMIDRegisterIdx. So you could even change the data type.
> Yeah, comments are good, I'll add some.
>
>>> +    GList *fields; /* list of named fields, excluding RES* */
>>> +} ARM64SysReg;
>>> +
>>> +void initialize_cpu_sysreg_properties(void);
>>> +
>>> +/*
>>> + * List of exposed ID regs (automatically populated from linux
>>> + * arch/arm64/tools/sysreg)
>>> + */
>>> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>>> +
>>> +/* Allocate a new field and insert it at the head of the @reg list */
>>> +static inline GList *arm64_sysreg_add_field(ARM64SysReg *reg, const char *name,
>>> +                                     uint8_t min, uint8_t max) {
>>> +
>>> +     ARM64SysRegField *field = g_new0(ARM64SysRegField, 1);
>>> +
>>> +     field->name = name;
>>> +     field->lower = min;
>>> +     field->upper = max;
>>> +     field->index = reg->index;
>>> +
>>> +     reg->fields = g_list_append(reg->fields, field);
>>> +     return reg->fields;
>>> +}
>>> +
>>> +static inline ARM64SysReg *arm64_sysreg_get(ARMIDRegisterIdx index)
>>> +{
>>> +        ARM64SysReg *reg = &arm64_id_regs[index];
>>> +
>>> +        reg->index = index;
>>> +        reg->sysreg = id_register_sysreg[index];
>>> +        return reg;
>>> +}
>>> +
>>> +#endif
>>> diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
>>> new file mode 100644
>>> index 000000000000..8b7ef5badfb9
>>> --- /dev/null
>>> +++ b/target/arm/cpu-sysreg-properties.c
>>> @@ -0,0 +1,41 @@
>>> +/*
>>> + * QEMU ARM CPU SYSREG PROPERTIES
>>> + * to be generated from linux sysreg
>>> + *
>>> + * Copyright (c) Red Hat, Inc. 2024
>> maybe increment the year now ;-)
> Wait, it is 2025 already? :)
>

