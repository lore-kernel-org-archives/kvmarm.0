Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B87C4279E9
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894687; cv=none; b=OhUIDcwGdNt0/mdCH/kgTY9+Hs5ZLybv6bpqW88nwQalCHi8AdHFUKApm3402EmV64UGoyKFPVgAMLqqo7bBcTFwps5Tk2hnbRrKLJvZzqTUINseHnzKcBFGubpFqU3kSDGlWtnNxzcIzRZWrQIdiq9CtstTvYF5uUxr00iMIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894687; c=relaxed/simple;
	bh=105ZKNzyCkrbWn5n6AK9W5fQvKGv7RrvTPuZ8XeUY3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uL+oIup0Tuf5uW7WF3H9UvcGZU5t2GLmSwvMxTxVPSZEGwwFXaDKCv0xDavcnXtnEd79wcNQT6nN4Bi8e4V4AGgPqpC4bFPfdtIrgzB4GQudKnIwJPyxsfXW7M1VyRKE1jWcnW3anXa/P+OfgO/Zm+gxe4ZEx3jhkWbnXqk5HB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fV/LWujZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fV/LWujZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779894684;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gEJcXPLx6uljtp8toNSGlyGTFwh0jJNdOwJtnugnvM=;
	b=fV/LWujZsJ2VcqRvOCZPwdZs+qsSF+RcxJOp5lqQ0vKc1Keioar3ko5RyV5tnudFe7U+gy
	62tiK971V0duZNJ7whbpoB48NHO1dDJxUkZmX6s7Mv/IDCU6O9vm1AKLIFZZFDxyg1qLP2
	8U2mlMo3LzGrXymPTkAknDtfOpoPaWg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-Clt-ikXnNBm_WoXC-D2U0g-1; Wed, 27 May 2026 11:11:23 -0400
X-MC-Unique: Clt-ikXnNBm_WoXC-D2U0g-1
X-Mimecast-MFC-AGG-ID: Clt-ikXnNBm_WoXC-D2U0g_1779894682
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4411a36715dso7759617f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894682; x=1780499482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gEJcXPLx6uljtp8toNSGlyGTFwh0jJNdOwJtnugnvM=;
        b=Y2mrtWLA6EUa5wEe9auZ8L3jRAthDQ615iBuGJMFwaG/42oWo9uI2FaKW4JGj+rjYu
         vahunXLUnNuHtInO9YfiSIToLPsVGgN1XMoFK+hYjPGI21gXmOgyfsenUf449hezUg1D
         ooxETjbP/xSfoxaApELRkICzPhc7b9rae535AZBJdnUUWzI30ooc2xaWhbTX6pGTIk0N
         nAtOTdhkEWAyeJJT0m76BHIMTbJtkosjOviH7DUP950bS6FnkETJ++8qbts2ldUKgpiU
         iuQfvB0SzXab/IJvA7uMvni8c/c+1FulpX/ZtD3nzgm40Ir2B2VNokp0M6SzxRn4PKsK
         ehwQ==
X-Forwarded-Encrypted: i=1; AFNElJ99gEcXSSF5gjan5hPDkGJHNTjwvgtVnMneI9BZNBolwIxaDOyUN8FfLef1rhiZXRbEhGpIYdU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZg3+6nKZsyJAjOJZQ0RpuKIBRrHJzxIt7QWyqk69q87HbvJxf
	pslb5Gu8OWMr2zHODKwIuNu/KkFJD/2922GgOYfTTAZb0WxSrKd1n0OASuv7f0mBAEFF2zcR/aX
	oga1movcCqjbNA0zb1Y8qIyndT+0bq5IiVFUpUGTMItFfyqRF6XG6AgskvA==
X-Gm-Gg: Acq92OHSSttcyQCUKTrKe0c8LCH0Q0ksboymitK/cEIEiRT5xU1tyvialtXXM5LHpdw
	VgtdSDipu7IvnxD6lI0Lh6+u0EVso9ziIHWfJ7dazODRTd+cHff9fKlklukapwlbpwn/WVPsvnh
	4MsBqk47ayJTEU47kGXL2fIMTAoyj80NWJAHAN6oIoOuW8alGb0hhM6eLdRqOi/q2sB3w5HrO5r
	QgIeI0nCOkwqhhvFQVtIOU4Xolb3B3uxpzOegJOAXtS7S06B31b7eBgNCTDDY1HtnVA+quZmdbm
	X4UodgjUOMPFJ9vAawsizfGu5lKJb7TZ8A4qRAhbuVMlop80IcezF5QcNTKasHf02qa5RiJoluN
	alavL5MD35MUOBDdLshXAqujqNKRKX0fGrzpjwPHslR/SYIO3KZTDLocm9nCFeGzKj2EA0chLtG
	TTgJRY
X-Received: by 2002:a05:6000:1888:b0:441:1e1e:a050 with SMTP id ffacd0b85a97d-45eb38b8a09mr40132434f8f.16.1779894681653;
        Wed, 27 May 2026 08:11:21 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:441:1e1e:a050 with SMTP id ffacd0b85a97d-45eb38b8a09mr40132343f8f.16.1779894681072;
        Wed, 27 May 2026 08:11:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb557545sm7375629f8f.12.2026.05.27.08.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:11:20 -0700 (PDT)
Message-ID: <fcc79400-aef5-4f64-b094-a2d3eb99bfa0@redhat.com>
Date: Wed, 27 May 2026 17:11:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 06/18] scripts: Introduce
 scripts/update-aarch64-cpu-sysreg-properties.py
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-7-eric.auger@redhat.com>
 <903E3FE0-1286-4917-8A90-5186562D3A6D@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <903E3FE0-1286-4917-8A90-5186562D3A6D@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PmAEx-nNIhhBpzjwL-wVf9nPuL9alv_d5jevQopoPtg_1779894682
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 5/27/26 4:35 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Introduce a script that takes as input the Registers.json file
>> delivered in the AARCHMRS Features Model downloadable from the
>> Arm Developer A-Profile Architecture Exploration Tools page:
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__developer.arm.com_Architectures_A-2DProfile-2520Architecture-23Downloads&d=DwIDAg&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=lifWLuAPiWiPtZHA1AnNwE36XKErpJppnuqSRce8eEXbd2seIXgOyghkIcv1h_tk&s=HRujmTCQGTPR11d90Orv_1iwKOLX_k3RFbkK_mx7A1s&e= 
>> and automates the generation of system register properties definitions.
>>
>> generates target/arm/cpu-idregs.h.inc containing definitions for
>> feature ID registers.
>>
>> We only care about IDregs with opcodes satisfying:
>> op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>> .../update-aarch64-cpu-sysreg-properties.py   | 168 ++++++++++++++++++
>> 1 file changed, 168 insertions(+)
>> create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
>>
>> diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
>> new file mode 100644
>> index 0000000000..3571e228ee
>> --- /dev/null
>> +++ b/scripts/update-aarch64-cpu-sysreg-properties.py
>> @@ -0,0 +1,168 @@
>> +#!/usr/bin/env python3
>> +
>> +# This script takes as input the Registers.json file delivered in
>> +# the AARCHMRS Features Model downloadable from the Arm Developer
>> +# A-Profile Architecture Exploration Tools page:
>> +# https://urldefense.proofpoint.com/v2/url?u=https-3A__developer.arm.com_Architectures_A-2DProfile-2520Architecture-23Downloads&d=DwIDAg&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=lifWLuAPiWiPtZHA1AnNwE36XKErpJppnuqSRce8eEXbd2seIXgOyghkIcv1h_tk&s=HRujmTCQGTPR11d90Orv_1iwKOLX_k3RFbkK_mx7A1s&e= 
>> +# and outputs target/arm/cpu-sysreg-properties.c content.
>> +# There, initialize_cpu_sysreg_properties() populates arm64_id_regs array
>> +# with the name of each ID register and definition of all its fields
>> +# including their name and min/max bit under the form of the below pattern:
>> +#
>> +# /* CCSIDR2_EL1 */
>> +# ARM64SysReg *CCSIDR2_EL1 = arm64_sysreg_get(CCSIDR2_EL1_IDX);
>> +# CCSIDR2_EL1->name = "CCSIDR2_EL1";
>> +# arm64_sysreg_add_field(CCSIDR2_EL1, "NumSets", 0, 23);
>> +#
>> +# Copyright (C) 2026 Red Hat, Inc.
>> +#
>> +# Authors: Eric Auger <eric.auger@redhat.com>
>> +#
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +
>> +import json
>> +import os
>> +import sys
>> +from aarch64_sysreg_helpers import extract_idregs_from_registers_json
>> +
>> +def collect_fields(item, bit_offset=0):
>> +    """
>> +    Recursively finds all field-like objects, handling Fields.Array,
>> +    Fields.ArrayField, and ConditionalField structures.
>> +    Applies bit_offset from containers to child fields.
>> +    """
>> +    fields = []
>> +    if not isinstance(item, dict):
>> +        return fields
>> +
>> +    _type = item.get('_type', '')
>> +
>> +    # Array types (for example CLIDR_EL1 Ctype<n>, Ttype<n>)
>> +    if _type == 'Fields.Array':
>> +        name_template = item.get('name') or item.get('label', '')
>> +        index_info = item.get('indexes', [{}])[0]
>> +        start_idx = index_info.get('start', 0)
>> +        count = index_info.get('width', 0)
>> +
>> +        full_range = item.get('rangeset', [{}])[0]
>> +        bit_start = full_range.get('start', 0) + bit_offset
>> +        elem_width = full_range.get('width', 0) // count if count else 0
>> +
>> +        for i in range(count):
>> +            idx = start_idx + i
>> +            # Correctly handle indexed names like Ctype1, Ctype2
>> +            field_name = name_template.replace('<n>', str(idx))
>> +            fields.append({
>> +                'name': field_name,
>> +                'rangeset': [{
>> +                    'start': bit_start + (i * elem_width),
>> +                    'width': elem_width
>> +                }],
>> +                '_type': 'Fields.Field'
>> +            })
>> +        return fields
>> +
>> +    # ConditionalFields
>> +    elif _type == 'Fields.ConditionalField':
>> +        inner_offset = bit_offset
>> +        if item.get('rangeset'):
>> +            # Parent container defines the absolute start bit
>> +            inner_offset = item['rangeset'][0].get('start', bit_offset)
>> +
>> +        for entry in item.get('fields', []):
>> +            inner = entry.get('field')
>> +            if inner:
>> +                fields.extend(collect_fields(inner, inner_offset))
>> +        return fields
>> +
>> +    # Normal Field Types
>> +    leaf_types = ['Fields.Field', 'Fields.ConstantField',
>> +                  'Fields.EnumeratedField', 'Fields.Bitfield']
>> +    if _type in leaf_types:
>> +        field_copy = item.copy()
>> +        if field_copy.get('rangeset'):
>> +            new_ranges = []
>> +            for r in field_copy['rangeset']:
>> +                nr = r.copy()
>> +                # Apply the cumulative offset to the field's start bit
>> +                nr['start'] = r.get('start', 0) + bit_offset
>> +                new_ranges.append(nr)
>> +            field_copy['rangeset'] = new_ranges
>> +        fields.append(field_copy)
>> +        return fields
>> +
>> +    # Traverse the hierarchy for other cases
>> +    for key in ['fields', 'values', 'fieldsets']:
>> +        for nested in item.get(key, []):
>> +            fields.extend(collect_fields(nested, bit_offset))
>> +
>> +    return fields
>> +
>> +
>> +def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>> +    with open(raw_json_path, 'r') as f:
>> +        register_data = json.load(f)
>> +
>> +    regs = {r.get('name'): r for r in register_data if r.get('_type') == 'Register'}
>> +
>> +    final_output = ""
>> +
>> +    for reg_name in id_reg_names:
>> +        register = regs.get(reg_name)
>> +        if not register:
>> +            continue
>> +
>> +        final_output += f"    IDREG_START({reg_name})\n"
>> +
>> +        unique_fields = {}
>> +        for fieldset in register.get('fieldsets', []):
>> +            candidates = collect_fields(fieldset)
>> +            for val in candidates:
>> +                name = (val.get('name') or val.get('label', '')).strip()
>> +                if not name or "RESERVED" in name.upper():
>> +                    continue
>> +                for r in val.get('rangeset', []):
>> +                    lsb = int(r.get('start'))
>> +                    width = r.get('width')
>> +                    msb = lsb + int(width) - 1
>> +
>> +                    # Only keep the fields with the highest MSB
>> +                    # needed fir CCSIDR_EL1
>> +                    if name not in unique_fields or msb > unique_fields[name]['msb']:
>> +                        unique_fields[name] = {'lsb': lsb, 'msb': msb, 'width': width}
>> +
>> +        # Sort decreasing lsbs
>> +        sorted_fields = sorted(unique_fields.items(),
>> +                               key=lambda x: x[1]['lsb'], reverse=True)
>> +
>> +        for name, bits in sorted_fields:
>> +            line = (f"    IDREG_FIELD({reg_name}, "
>> +                    f"{name}, {bits['lsb']}, {bits['width']})\n")
>> +            final_output += line
>> +        final_output += f"    IDREG_END({reg_name})\n"
>> +        final_output += "\n"
>> +
>> +    os.makedirs("target/arm", exist_ok=True)
>> +    with open("target/arm/cpu-idregs.h.inc", 'w') as f:
>> +        f.write("/* AUTOMATICALLY GENERATED, DO NOT MODIFY */\n\n")
>> +        f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
>> +        f.write("/* IDREG_START(REG) */\n")
>> +        f.write("/* IDREG_FIELD(REG, FIELD, SHIFT, LENGTH) */\n")
>> +        f.write("/* ... */\n")
>> +        f.write("/* IDREG_END(REG) */\n\n")
>> +        f.write(final_output)
>> +
>> +if __name__ == "__main__":
>> +    if len(sys.argv) < 2:
>> +        print("Usage: python scripts/update-aarch64-cpu-sysreg-properties.py "
>> +              "<path_to_registers_json>")
>> +    else:
>> +        json_path = sys.argv[1]
>> +
>> +        id_regs_dict = extract_idregs_from_registers_json(json_path)
>> +        sorted_names = sorted(id_regs_dict.keys())
>> +
>> +        if sorted_names:
>> +            generate_sysreg_properties_from_registers_json(sorted_names, json_path)
>> +            print("Generated target/arm/cpu-idregs.h.inc")
>> -- 
>> 2.53.0
>>
> Hi Eric,
>
> Can we also have the arch-defined values in here? It is already available in Registers.json easily, would be great if we can validate at-least the user
> set values are architecturally valid.

Yes valid values should be easily extractable

Thanks

Eric
>
> Warm Regards,
> Khushit
>

