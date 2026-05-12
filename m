Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6406E3630B2
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 14:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778597535; cv=none; b=NVP8BZtXXQuqcCt8vqqJ0YAyvXf9D6dT5RTTb0HT5V3iBvPQfryG7dwPdTmbSIBzo1rQVJriOZAD5gVADE96MWx2SQS48rVwB0fTmPX9rNxrnEq2u03NDixdk2lwMo76buBRVRoIVBX1Wj3YqDNjgYde4T7Zuxny+33mISoCua4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778597535; c=relaxed/simple;
	bh=f3ipFm9YfVgVekTYDbb4xs9k2/lpYwiYamD7JBx4sUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=StPH8VsviOyXFgme3vq08/kvCVVV/3OCU3OwfU41HBqfaPUmZpU+cKjsJOD1FC8Cw+ccxFL5+RnwM0WGhCPt90yjdR4zjCXDf70tJCbdfHQfiEeAXvaTgz+k8UoUvE73qIhcXex2Dig87gurVROeuv3u4/aPKxMTlr8QLgChUXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HDbgbHC0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HDbgbHC0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778597532;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9sxtl+GdLK5NvMOI7xxInAx13XkVbqDs2a0iwKfW4fk=;
	b=HDbgbHC0EYjtnFrGTCb+tqiQwxZqxjWCQiqbn/sLgGOlA+CHxs+plzgmHyMQTEtxH4fnM/
	n68XkQUbphSR3U3TGc9QIjDEOAb4gZ1hsFs9sFBO2Qug1bM8gMNFsIimSDh1afhjXebPEN
	Isvbf2kOMVg9zdJBxVGo4sQMhTU1Qy0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-tvJfpJu0MpOgDmj-XI9AMQ-1; Tue, 12 May 2026 10:52:09 -0400
X-MC-Unique: tvJfpJu0MpOgDmj-XI9AMQ-1
X-Mimecast-MFC-AGG-ID: tvJfpJu0MpOgDmj-XI9AMQ_1778597528
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-bcf70e19516so239137766b.2
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 07:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778597528; x=1779202328;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9sxtl+GdLK5NvMOI7xxInAx13XkVbqDs2a0iwKfW4fk=;
        b=snAExqS1fnpA1KMpwjN/Wzps46pxJDwoqvcBvpMukwZUhJWWeww6+9EWXCTSC7gJme
         lBzAsAsjzfZqCFM65mmPr55D005R/BLe8J7pfrJZ3rStZQ/NvnsEct3mWHp9WFg8CaT1
         5hdIl4Ts3flujeclaQGRi6nEJd4e9OOPlxrNR8w4cXjTw436dbO77FKvcmTjWhSfkRpZ
         A5ip29yduLDeedAb7CGAH85+/ydtul98iWCxthJ30Lddv5UfpwmDEmxlT+2q37jayERa
         F9PO1gXfOmI+d/ltjrFxCn/MYq1hZnxvRVKhCDKi2kPeebFss389K7P6ffWNSaWDH1z1
         8B0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+mMl4mj7ez+ZQ06pLwwy0k0Vb8VNqx63OkDquQySIQgw/Z9cBl6ouqJ12HMddLR8S3QBojaQA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4BJXRN9LW+cNOBA3HYBPYoVUK1s0dpI7NASPkdvSmFJzQby62
	aKcgRUBnGgBNnCSCUgSQ0HO5A4/RhPCmqUjbKSpoCdWcotWw6kiA0qAOPPi9Aw7UjzukGcH9u7o
	1WMd8p0O/nMpWzjVY9NSMMNhFCT2lWdzcPt4dqp0K9NSbsdzOvn1MvsgOYA==
X-Gm-Gg: Acq92OFAahjdHaF2ePPH1ivJxSqbr6VVPy9fS3IZG4ytEMN5MJdiM5V+tIL/C5IcGN1
	ena2C7WJ0KASiTYlFYhv5ckfv0GirtnZaDvKjsbCVpmbRn4On4sRkNAUKfwp+09CHtJCni4Aql3
	o3jchj6DpaaJfANwZ29T0k/suwqml8Ukx9RNztbH6uRWC33qq+13JMt8pQvw6ilZc/xz3ZwpNSf
	I3c7hhuvcEClQxipZqJpXGObS6gxXEGA7obSoTI9K6AcbhNR45W3AH/rn2E/2JH3fHHD5n6RGWA
	SPFhwIB2aoKo6Z5BK/7JEnVN5lAOcieFE67tFrrzmxiwXoAVeAdYAppHgtzVIydGi96M7h7jv2W
	n1l8kpDWQKlb+KMJqCjdhbnpPvA/2ZXHtC1FZNzFY9o1DL0FEp3K/kMkMEsW0NlXl13dx6w==
X-Received: by 2002:a17:907:d388:b0:bd3:8192:c8ed with SMTP id a640c23a62f3a-bd38192d0camr8429066b.34.1778597528138;
        Tue, 12 May 2026 07:52:08 -0700 (PDT)
X-Received: by 2002:a17:907:d388:b0:bd3:8192:c8ed with SMTP id a640c23a62f3a-bd38192d0camr8424866b.34.1778597527658;
        Tue, 12 May 2026 07:52:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0dfd367sm5202207a12.17.2026.05.12.07.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 07:52:06 -0700 (PDT)
Message-ID: <9e1ef1c6-3ae1-4952-a295-147c1dfe82de@redhat.com>
Date: Tue, 12 May 2026 16:52:05 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 04/17] arm/cpu: Add infra to handle generated ID
 register definitions
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-5-eric.auger@redhat.com>
 <CH3PR12MB7548456E92BB5137C5B5846FAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB7548456E92BB5137C5B5846FAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v0hjaB0tn5EaFgf-I80s8pA8Nb62nJsRxIWDuwJ-5H4_1778597528
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/7/26 10:58 AM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:33
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 04/17] arm/cpu: Add infra to handle generated ID register
>> definitions
>>
>> External email: Use caution opening links or attachments
>>
>>
>> The known ID regs are populated in a new initialization function
>> named initialize_cpu_sysreg_properties(). That code will be
>> automatically generated from AARCHMRS Registers.json. For the
>> time being let's just describe a single id reg, CTR_EL0. In this
>> description we only care about non RES/RAZ fields, ie. named fields.
>>
>> The registers are populated in an array indexed by ARMIDRegisterIdx
>> and their fields are added in a sorted list.
>>
>> [CH: adapted to reworked register storage]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu-idregs.h            | 59 ++++++++++++++++++++++++++++++
>>  target/arm/cpu-sysreg-properties.c | 30 +++++++++++++++
>>  target/arm/cpu64.c                 |  3 ++
>>  target/arm/meson.build             |  3 +-
>>  4 files changed, 94 insertions(+), 1 deletion(-)
>>  create mode 100644 target/arm/cpu-idregs.h
>>  create mode 100644 target/arm/cpu-sysreg-properties.c
>>
>> diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
>> new file mode 100644
>> index 0000000000..4a9034594d
>> --- /dev/null
>> +++ b/target/arm/cpu-idregs.h
>> @@ -0,0 +1,59 @@
>> +/*
>> + * handle ID registers and their fields
>> + *
>> + * SPDX-License-Identifier: GPL-2.0-or-later
>> + */
>> +#ifndef ARM_CPU_CUSTOM_H
>> +#define ARM_CPU_CUSTOM_H
> ARM_CPU_IDREGS_H ?
indeed: TARGET_ARM_CPU_IDREGS__H
>
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "cpu.h"
>> +#include "cpu-sysregs.h"
>> +
>> +typedef struct ARM64SysRegField {
>> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
>> +    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
>> +    int lower; /* lowest bit number of the field in the register */
>> +    int upper; /* highest bit number */
>> +} ARM64SysRegField;
>> +
>> +typedef struct ARM64SysReg {
>> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
>> +    ARMSysRegs sysreg;
>> +    ARMIDRegisterIdx index; /* register index, e.g. CTR_EL0_IDX */
>> +    GList *fields; /* list of named fields, excluding RES* */
>> +} ARM64SysReg;
>> +
>> +void initialize_cpu_sysreg_properties(void);
>> +
>> +/*
>> + * List of exposed ID regs (automatically populated from AARCHMRS
>> Registers.json)
>> + */
>> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>> +
>> +/* Allocate a new field and insert it at the head of the @reg list */
> It says insert at the head...
>
>> +static inline GList *arm64_sysreg_add_field(ARM64SysReg *reg, const char
>> *name,
>> +                                     uint8_t min, uint8_t max) {
>> +
>> +     ARM64SysRegField *field = g_new0(ARM64SysRegField, 1);
>> +
>> +     field->name = name;
>> +     field->lower = min;
>> +     field->upper = max;
>> +     field->index = reg->index;
>> +
>> +     reg->fields = g_list_append(reg->fields, field);
> But this is adding to the tail, right?
indeed use prepend instead
>
>> +     return reg->fields;
> Don't think the return is used anywhere.
now becoming static inline void 

arm64_sysreg_add_field()

Thanks

Eric

>
> Thanks,
> Shameer
>
>> +}
>> +
>> +static inline ARM64SysReg *arm64_sysreg_get(ARMIDRegisterIdx index)
>> +{
>> +        ARM64SysReg *reg = &arm64_id_regs[index];
>> +
>> +        reg->index = index;
>> +        reg->sysreg = id_register_sysreg[index];
>> +        return reg;
>> +}
>> +
>> +#endif
>> diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-
>> properties.c
>> new file mode 100644
>> index 0000000000..5cc06c8f24
>> --- /dev/null
>> +++ b/target/arm/cpu-sysreg-properties.c
>> @@ -0,0 +1,30 @@
>> +/*
>> + * QEMU ARM CPU SYSREG PROPERTIES
>> + * will be automatically generated
>> + *
>> + * Copyright (c) Red Hat, Inc. 2026
>> + *
>> + */
>> +
>> + /* SPDX-License-Identifier: GPL-2.0-or-later */
>> +
>> +#include "cpu-idregs.h"
>> +
>> +ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>> +
>> +void initialize_cpu_sysreg_properties(void)
>> +{
>> +    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NUM_ID_IDX);
>> +    /* CTR_EL0 */
>> +    ARM64SysReg *CTR_EL0 = arm64_sysreg_get(CTR_EL0_IDX);
>> +    CTR_EL0->name = "CTR_EL0";
>> +    arm64_sysreg_add_field(CTR_EL0, "TminLine", 32, 37);
>> +    arm64_sysreg_add_field(CTR_EL0, "DIC", 29, 29);
>> +    arm64_sysreg_add_field(CTR_EL0, "IDC", 28, 28);
>> +    arm64_sysreg_add_field(CTR_EL0, "CWG", 24, 27);
>> +    arm64_sysreg_add_field(CTR_EL0, "ERG", 20, 23);
>> +    arm64_sysreg_add_field(CTR_EL0, "DminLine", 16, 19);
>> +    arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
>> +    arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
>> +}
>> +
>> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
>> index a93ad2da5a..b940842d9e 100644
>> --- a/target/arm/cpu64.c
>> +++ b/target/arm/cpu64.c
>> @@ -37,6 +37,7 @@
>>  #include "hw/core/qdev-properties.h"
>>  #include "internals.h"
>>  #include "cpu-features.h"
>> +#include "cpu-idregs.h"
>>
>>  /* convert between <register>_IDX and SYS_<register> */
>>  #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
>> @@ -906,6 +907,8 @@ static void aarch64_cpu_register_types(void)
>>  {
>>      size_t i;
>>
>> +    initialize_cpu_sysreg_properties();
>> +
>>      for (i = 0; i < ARRAY_SIZE(aarch64_cpus); ++i) {
>>          arm_cpu_register(&aarch64_cpus[i]);
>>      }
>> diff --git a/target/arm/meson.build b/target/arm/meson.build
>> index 192ac7c31e..e2f740e48f 100644
>> --- a/target/arm/meson.build
>> +++ b/target/arm/meson.build
>> @@ -9,7 +9,8 @@ arm_user_ss.add(files('gdbstub.c'))
>>
>>  arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
>>    'cpu64.c',
>> -  'gdbstub64.c'
>> +  'gdbstub64.c',
>> +  'cpu-sysreg-properties.c',
>>  ))
>>
>>  arm_common_ss.add(files(
>> --
>> 2.53.0

