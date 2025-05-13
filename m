Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC25B1EDA35
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 13:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747144384; cv=none; b=sB3u7081U+0lMkbnjiATYYZvTubXO168hIyjbnhpjXv01OjHZGDuX90MugIuegPD9Q6Uca7BB5TK5RnKKuMYbN87hHBn0g0vMYRWZ4UcWlq+q/G7XIQzB3lGXWgnPztn753nWYcXtMTxNDN1h77DWZB5+1ylF7IAx1mEqAv2Rns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747144384; c=relaxed/simple;
	bh=0VzUQ6CHSqSoj1K2sUWJiCFQkgN6gvu3e5jRWl2NhNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uQkgclk6beGrqVkDVWfM+R0n3qR6ZCTsSXMtRjhS4/MH59CeIVkmkawABGxS+spa7oteXaeYBeGo8mfgtAs0BjhaRkFgSdKCM7cq5gfpxdbAc9t9OqNH9ULny3bq7sSESX+HKjnyD3vzQsDJeAYYDLoYeBGx5nLcHDOSENsbgpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WLTwsq6Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLTwsq6Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747144381;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qd5j9HGmDqx5UKJ8JxQsW9/d5OfJ5IPgcMenkg8z06g=;
	b=WLTwsq6ZyZ6p4LViHAr+WxevCptooNgBhoGou14BHDguEH1SBF9TgsAMI667oyznpZTb/+
	whYogqnIZ+3V4RgI6MHWsJyv71y+h17wSQqHsvZTjjL09ddOqocNhSEYaF5UxxKDtFbnkV
	ozpCbNdXZyjCL9JgYN5CdvWy2jTxXng=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-SwoQWl7wO-aEycOsMoouxQ-1; Tue, 13 May 2025 09:53:00 -0400
X-MC-Unique: SwoQWl7wO-aEycOsMoouxQ-1
X-Mimecast-MFC-AGG-ID: SwoQWl7wO-aEycOsMoouxQ_1747144379
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a0b9bbfa5dso1976922f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 06:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747144379; x=1747749179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qd5j9HGmDqx5UKJ8JxQsW9/d5OfJ5IPgcMenkg8z06g=;
        b=tQFMk4WcGnaGnozoN6DmsB6gr9bXIuZvt2e+PRtiN9JRBcIccDzonHd+Xd74pu+qnQ
         kf61EiExG3octSLcp/Eul/h0Yz2fReAYBFv2HvCYG5PpsXnEf+Xwy2hxjnrtjDsj4Kid
         JWcDYRhjYtFClY5MrEEXAgdGTiNgVJ9Vz5EGtGX2a7Li6GYLhvwg218jXseIkX2CMtIW
         V11KagW/G3KmA7jgkkOTu5XWzj5fnYSI5QirVEEJ+Du+LFjI4MHX7/oyzmGRDhN2/Jk+
         qf9TgGRKl/FDYH7I5KYBlTYmh53KfM2hH7o99aUTkMCywX63KffzDT0BT2hGwUgTUZPL
         dabw==
X-Forwarded-Encrypted: i=1; AJvYcCW7Fje2V5EBrTRdYLnBq+p+9TPDuusvWWJjswo0iffc2E1zQdR71MWByB7e5zBE3NHky7xVjeE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxQICy18xRqZJ2vvVIni1ETmBCnXK4RckqPpCcv03b+tbPq/Ts
	cuzkp1FAN6iYbeLWHlyRwQCQvZ3Rc6I9ue/x6Y3+WiwHHPU5EIWITYRP5P0xqmfk1BR9oFGtCXI
	HB0OBd9a4G/FfiSZ9+/H3AIz+QDVHP3TUDCcxM1PcKdpVdOSwjvdZdGeOTSt4Sg==
X-Gm-Gg: ASbGncvBtdi6a2iENYi2nxAJP1DeCj0MX98at5qIBJCFkicaN6dv7/yby6N9VjLWcwo
	vAtxYuGW/3z7pQWWllk4KrQ0aBkVB+7Wio3SZwUqP6t5af+SCuZPnbEcfCYeGAttPwirIkWgKwC
	N33CT4wbrIir51oLEn4dSUVCxJTa8+H9axtpM0LrHTc2gjmLIGJ1tgkzB7m+iSVe9iinZWk/c5v
	04fuYqCkdRWwCB/N6nZgd4XskhK3DLXLcHpdA1fYXMiA8WdgB5BInNZO/V0MHL2TK4vQediT+a2
	WBnCfmJZGaQTzAJ4w3t/Uf0h7+3IQv8J+KdZW9MGYJd4scpQitZVGj3BBJc=
X-Received: by 2002:a5d:584c:0:b0:3a0:a8b1:cf17 with SMTP id ffacd0b85a97d-3a1f643711emr13945580f8f.15.1747144378718;
        Tue, 13 May 2025 06:52:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFM5FdATd8pnIJT4WuzmTHicRYMn8uCdk8+cKg2mhf50laTdgXXTyYFJcNb5j0s2R6fWv37Yg==
X-Received: by 2002:a5d:584c:0:b0:3a0:a8b1:cf17 with SMTP id ffacd0b85a97d-3a1f643711emr13945557f8f.15.1747144378233;
        Tue, 13 May 2025 06:52:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57ddd5esm16148585f8f.6.2025.05.13.06.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 06:52:57 -0700 (PDT)
Message-ID: <6c06a198-1608-4919-8b6e-68e3c28c2526@redhat.com>
Date: Tue, 13 May 2025 15:52:56 +0200
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
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250414163849.321857-2-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 34yWQS_3MXLHC-r3z_kncQMjHFr0iq3ega02JVH2SHU_1747144379
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,

On 4/14/25 6:38 PM, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
>
> The known ID regs are described in a new initialization function
> dubbed initialize_cpu_sysreg_properties(). That code will be
> automatically generated from linux arch/arm64/tools/sysreg. For the
> time being let's just describe a single id reg, CTR_EL0. In this
> description we only care about non RES/RAZ fields, ie. named fields.
>
> The registers are populated in an array indexed by ARMIDRegisterIdx
> and their fields are added in a sorted list.
>
> [CH: adapted to reworked register storage]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-custom.h            | 60 ++++++++++++++++++++++++++++++
>  target/arm/cpu-sysreg-properties.c | 41 ++++++++++++++++++++
>  target/arm/cpu64.c                 |  2 +
>  target/arm/meson.build             |  1 +
>  4 files changed, 104 insertions(+)
>  create mode 100644 target/arm/cpu-custom.h
do we still want reference to the "custom" terminology, following
initial comments?
>  create mode 100644 target/arm/cpu-sysreg-properties.c
>
> diff --git a/target/arm/cpu-custom.h b/target/arm/cpu-custom.h
> new file mode 100644
> index 000000000000..615347376e56
> --- /dev/null
> +++ b/target/arm/cpu-custom.h
> @@ -0,0 +1,60 @@
> +/*
> + * handle ID registers and their fields
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +#ifndef ARM_CPU_CUSTOM_H
> +#define ARM_CPU_CUSTOM_H
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "cpu.h"
> +#include "cpu-sysregs.h"
> +
> +typedef struct ARM64SysRegField {
> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
> +    int index;
worth to add a comment saying this is the ARMIDRegisterIdx of the parent
sysreg.
> +    int lower;
> +    int upper;
> +} ARM64SysRegField;
> +
> +typedef struct ARM64SysReg {
> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
> +    ARMSysRegs sysreg;
> +    int index;
now that we have different kinds of indexing, may be worth adding a
comment to explain which one is being used.
I guess here it is ARMIDRegisterIdx. So you could even change the data type.
> +    GList *fields; /* list of named fields, excluding RES* */
> +} ARM64SysReg;
> +
> +void initialize_cpu_sysreg_properties(void);
> +
> +/*
> + * List of exposed ID regs (automatically populated from linux
> + * arch/arm64/tools/sysreg)
> + */
> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
> +
> +/* Allocate a new field and insert it at the head of the @reg list */
> +static inline GList *arm64_sysreg_add_field(ARM64SysReg *reg, const char *name,
> +                                     uint8_t min, uint8_t max) {
> +
> +     ARM64SysRegField *field = g_new0(ARM64SysRegField, 1);
> +
> +     field->name = name;
> +     field->lower = min;
> +     field->upper = max;
> +     field->index = reg->index;
> +
> +     reg->fields = g_list_append(reg->fields, field);
> +     return reg->fields;
> +}
> +
> +static inline ARM64SysReg *arm64_sysreg_get(ARMIDRegisterIdx index)
> +{
> +        ARM64SysReg *reg = &arm64_id_regs[index];
> +
> +        reg->index = index;
> +        reg->sysreg = id_register_sysreg[index];
> +        return reg;
> +}
> +
> +#endif
> diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
> new file mode 100644
> index 000000000000..8b7ef5badfb9
> --- /dev/null
> +++ b/target/arm/cpu-sysreg-properties.c
> @@ -0,0 +1,41 @@
> +/*
> + * QEMU ARM CPU SYSREG PROPERTIES
> + * to be generated from linux sysreg
> + *
> + * Copyright (c) Red Hat, Inc. 2024
maybe increment the year now ;-)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see
> + * <http://www.gnu.org/licenses/gpl-2.0.html>
> + */
> +
> +#include "cpu-custom.h"
> +
> +ARM64SysReg arm64_id_regs[NUM_ID_IDX];
> +
> +void initialize_cpu_sysreg_properties(void)
> +{
> +    memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NUM_ID_IDX);
> +    /* CTR_EL0 */
> +    ARM64SysReg *CTR_EL0 = arm64_sysreg_get(CTR_EL0_IDX);
> +    CTR_EL0->name = "CTR_EL0";
> +    arm64_sysreg_add_field(CTR_EL0, "TminLine", 32, 37);
> +    arm64_sysreg_add_field(CTR_EL0, "DIC", 29, 29);
> +    arm64_sysreg_add_field(CTR_EL0, "IDC", 28, 28);
> +    arm64_sysreg_add_field(CTR_EL0, "CWG", 24, 27);
> +    arm64_sysreg_add_field(CTR_EL0, "ERG", 20, 23);
> +    arm64_sysreg_add_field(CTR_EL0, "DminLine", 16, 19);
> +    arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
> +    arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
> +}
> +
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 9769401a8585..839442745ea4 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -35,6 +35,7 @@
>  #include "internals.h"
>  #include "cpu-features.h"
>  #include "cpregs.h"
> +#include "cpu-custom.h"
>  
>  /* convert between <register>_IDX and SYS_<register> */
>  #define DEF(NAME, OP0, OP1, CRN, CRM, OP2)      \
> @@ -891,6 +892,7 @@ static void aarch64_cpu_register_types(void)
>  {
>      size_t i;
>  
> +    initialize_cpu_sysreg_properties();
>      type_register_static(&aarch64_cpu_type_info);
>  
>      for (i = 0; i < ARRAY_SIZE(aarch64_cpus); ++i) {
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index 3065081d241d..1c97c1ef7580 100644
> --- a/target/arm/meson.build
> +++ b/target/arm/meson.build
> @@ -14,6 +14,7 @@ arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
>  arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
>    'cpu64.c',
>    'gdbstub64.c',
> +  'cpu-sysreg-properties.c',
>  ))
>  
>  arm_system_ss = ss.source_set()

