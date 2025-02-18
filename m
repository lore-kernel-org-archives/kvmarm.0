Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1306826E14D
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739894829; cv=none; b=U5uQzaTED4wbL2PhH1zsmPRyjrmoDEdKlqr2xom6OGCbyzkvgrgQvXjA6vpT1N7CN0+aiUNVDrmzVYFBlag61qb8pmRK04SY6gXeEUQhltWhABnm5yRsbhKxCOXpsp+GK5j4r77lANt7+S5W3Xk8qfu1VGZKUyzN3n+APK3SyR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739894829; c=relaxed/simple;
	bh=4ByBBFaaCEMoC0oeFDSKsmFyc9EF0AePoZXdya7Aj/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EmxCVoHbvR4dH1Y2VAAaxvdcRcy52z+372G5ZPYedBghmdLoD206wF9Yrlgno9AtzqFmw7hv6H+BUF0LuqL9iJ0Rx4jZEsu/FH2bVBEsmIX+Je760+PT8a3FZv4VgOPqX8H9gXf8q1RHPvdz7AG0NxLWEiJJiOB6nqqn3OXu1Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bIA+EUBP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bIA+EUBP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739894825;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3g9jows/4/+ShPFJxsYWAQAkLb0y/5Wvk4/3mwEv5w=;
	b=bIA+EUBPLP3F5v5svIcKylLJGiIHmNEk/eFbNAnY9a8fV4meHGdx030ePBk1+yCnyIy6pH
	qDoqUjVR47/i2LOXFJGizT9PKydAMBzlm1Jc6N4lk6K1XAOrey5WO6xIRBCf+AyI+2mW9i
	eVv9hp+DB0Exkkr0rdZiTqjY+j6Hags=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-x6y-7QhbMwGTRtoKzDQvNQ-1; Tue, 18 Feb 2025 11:07:03 -0500
X-MC-Unique: x6y-7QhbMwGTRtoKzDQvNQ-1
X-Mimecast-MFC-AGG-ID: x6y-7QhbMwGTRtoKzDQvNQ_1739894823
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43943bd1409so47291185e9.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 08:07:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739894822; x=1740499622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s3g9jows/4/+ShPFJxsYWAQAkLb0y/5Wvk4/3mwEv5w=;
        b=t/AfLCr4Plpirqj+daI2pjKAN0yz3+IEfXTz9waE2qyDurujvpPoZ2KUiUjIGEx1NE
         LMKFLNvsW5PeJ+Ftt0cnUubfCWc4VUv/fvmtfbcmD8f+KcibBO4nlciKm/AycIM/o1KY
         kFFHtvWi/ZrUbT2tZDL+D0kjYjXqxKGMl90qB/uhP2bfNll3kHitjKHpTJ8UNNY/7Hz2
         Ta/Ny622vrVYncHkAYQTsMmDDvPJ3yFJBp4xb1Mhwd/BqPiuogw6d6wW6OJkMRjOXV32
         LQBXPIq+5a4HYgK8al6vSH4KUTlI9ljG1gbu1aCd9xFDfcXnRr3SosYi5Bdg7l+UaGUl
         IkWg==
X-Forwarded-Encrypted: i=1; AJvYcCVHX5hkpOM4YSp33VakmO1WePc6L2JNU0BmoNxdvgd5tr0OWIyIKzE1FhDoljikHCgaC+Dab6k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA1xlnp/A5JvjUhXy5tdR9thhN9EPpGdZ+m5FN9nernmJb1ASA
	491Qb/+6xJdpDDhhA6EnXeqjVHqJOwiBxhPquqLt0rmFHDk4CiFurYEgo0b67fCkEuYCD0/zMs0
	I3g4LzF1zOMfHACAeBrdiTXt5wVl8f58q2Ah8kTNUkoR6i21DhSZxBHnY3viiJQ==
X-Gm-Gg: ASbGncsmTnooP/JXKH8qfJTK8jWVTN56xmE+e66r4NS+/DDnk4yey0dkklUJJ01iG+N
	Qf2ClSwIpYekS28w0/RMfH9uE+6+i6HCM6tIMi9q2xVwibKq+JOa4Vfksw3nHZwHYzz0jPfKwxm
	Z61tpatpBEo8n158iwr2cqZ7f5/QxkB2I+TJ++rRKH+khbHbmHmxUv3ZdLlat2PM3Ynta6+v4hs
	LcXUdjojoyjh3DGejoOkTDKOnes5UeMKGCnhB9enGQo1Huy4NV6qfZ/YnTN8oqAYYh8Fw2D8/nQ
	H3KuED5aNKMZCITYRP2bM1aFsfKV+luFDWGJHVvEVMKPL7zb43NT
X-Received: by 2002:a05:600c:4e8c:b0:439:33dd:48ea with SMTP id 5b1f17b1804b1-43999d72091mr2202715e9.2.1739894822012;
        Tue, 18 Feb 2025 08:07:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsMyDHKAgJhzDk32tn0Woebs43BToX7M4ssqeiTBNIv2bgE7wYwZvGEHmCB35LNPrWcIT0yg==
X-Received: by 2002:a05:600c:4e8c:b0:439:33dd:48ea with SMTP id 5b1f17b1804b1-43999d72091mr2202075e9.2.1739894821469;
        Tue, 18 Feb 2025 08:07:01 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4398872fa85sm53409035e9.28.2025.02.18.08.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 08:07:00 -0800 (PST)
Message-ID: <05a1c41e-3436-4117-a22f-61b4e1e2de20@redhat.com>
Date: Tue, 18 Feb 2025 17:06:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 13/15] arm/cpu: Add infra to handle generated ID register
 definitions
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-14-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250207110248.1580465-14-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HhNHKrjdgNacoFjrsJHHxBe-wuXq7uCA3nJz5kILv0E_1739894823
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Connie,


On 2/7/25 12:02 PM, Cornelia Huck wrote:
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

I don't think we need all the infra related to properties in this
prerequisite series. I would postpone it until the main CPU model series.

You can just keep scripts/gen-cpu-sysregs-header.awk to generate the
sysreg definitions
>
> [CH: adapted to reworked register storage]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-custom.h            | 55 ++++++++++++++++++++++++++++++
>  target/arm/cpu-sysreg-properties.c | 41 ++++++++++++++++++++++
>  target/arm/cpu64.c                 |  2 ++
>  target/arm/meson.build             |  1 +
>  4 files changed, 99 insertions(+)
>  create mode 100644 target/arm/cpu-custom.h
>  create mode 100644 target/arm/cpu-sysreg-properties.c
>
> diff --git a/target/arm/cpu-custom.h b/target/arm/cpu-custom.h
by the custom we may get rid of the 'custom' terminology
> new file mode 100644
> index 000000000000..17533765dacd
> --- /dev/null
> +++ b/target/arm/cpu-custom.h
> @@ -0,0 +1,55 @@
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
> +    int lower;
> +    int upper;
> +} ARM64SysRegField;
> +
> +typedef struct ARM64SysReg {
> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
> +    ARMSysRegs sysreg;
> +    int index;
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
> index beba1733c99f..8371aabce5f4 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -35,6 +35,7 @@
>  #include "internals.h"
>  #include "cpu-features.h"
>  #include "cpregs.h"
> +#include "cpu-custom.h"
>  
>  void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
>  {
> @@ -894,6 +895,7 @@ static void aarch64_cpu_register_types(void)
>  {
>      size_t i;
>  
> +    initialize_cpu_sysreg_properties();
>      type_register_static(&aarch64_cpu_type_info);
>  
>      for (i = 0; i < ARRAY_SIZE(aarch64_cpus); ++i) {
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index 2e10464dbb6b..9c7a04ee1b26 100644
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
Thanks

Eric

