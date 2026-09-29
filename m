Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E937E514770
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 12:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790685080; cv=none; b=felXIRDIQEiGPqkbsN8+TJJaQ7ujbXyYcO5/qb6NIAtYY0QhNFzPxvENb3fWmWb+SKsY/yM+5rYIym0kQu2bjJlrypKLs+W3pbd45vWKd2mXDzp/rgV3q3Fv2tadV/vI/5NsKfXj64euP3MD5Kc7rcPqXfBKSlx8OrmcjGPbgvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790685080; c=relaxed/simple;
	bh=yyc5GQ+N0c4TIRTCuCQMp1dksC3iFUzCplRROOd8F04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WV7M8X9xOZyxczDTaDJqVm4oJnTli0Xtvf87l6i01DhSjpiZZNWWdsr/aX3TPhRo8O8u7j+nGgjK2UeHjqf1uBHwI9IERlnm1gRYzUIJRxytyYROamocijUcBiDlYQd0jST7qFturm8zZu0flyXzNWdhSOP2L9a2WDMmQJyZoIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d7BIb9BQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d7BIb9BQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790685077;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WGg/57fwo23jQlqOupCF+5aZuHcAbwT6zsy3md/Vuc=;
	b=d7BIb9BQKYpoWbtiQ1PFts0mPiFxob1Ix/aAnD4VAZzR8ozo8brwdIWC3oJXAdpRgQWYT+
	GDQh+OwNWEp1yI84c+9d0A842YH9TRSOcLXFFLhvSMVpws7Y/tWsMaOT6P0hcZ4GhH5cIZ
	RoZRor9d8rsEJq3D1H8UFBe//gtiMfI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-PWMDeXN9PRmEJANg81OVCA-1; Tue, 29 Sep 2026 08:31:16 -0400
X-MC-Unique: PWMDeXN9PRmEJANg81OVCA-1
X-Mimecast-MFC-AGG-ID: PWMDeXN9PRmEJANg81OVCA_1790685075
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49fcc575709so42070455e9.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 05:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790685075; x=1791289875;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+WGg/57fwo23jQlqOupCF+5aZuHcAbwT6zsy3md/Vuc=;
        b=dypgpWI0gNmhDAupgQvSoDD//C4aVdyzfCgFd2s+XBnGFxG0wkFjy/XYEcDDWN3E1P
         OAlroYEGt6GGO4skgiYZLesj9No7QIYep4JXbWCuO4/IeRqyTBfoEH64+DjFn5ZEv94a
         lqLz3p+NdXHyZ/RsmGYBWVhy40Vm+SJpTe9UUfZuEOrJN74ErR/qiPK2xN9CzxWdnp+u
         1al4ybnfL+I9M3TAHosq9QSZ9VDQIqAFDX4VkehXJB/mF+W+tBhvAHHNvd6AVlqeJ3R2
         uLt3c1OtEqGjNSdpLGdGuYNf8akXdlx6tzqDxaVhwjThKTw96iEeC889vG+IU9TL2PFB
         Madg==
X-Forwarded-Encrypted: i=1; AKwUvBw4ZBlGzUhbfbYgrJc9kU2UGFlWCqeI9lJhuL+3bFXZfmod23AZJ0hl/uZmFfDZUuB9dQ602fU=@lists.linux.dev
X-Gm-Message-State: AFuF++kqGoMorDOdKO6rN0ulyEXR358U61L30u82/XJAzPb1zse9rhxY
	QNz7RF6zX1496HDQzDoh6IWWyU0byvEge/af5CCZv+pbmHiF/GgCSG26u+FAdltkzBX9jDLxWSq
	EYb1WAGiECiKv0DXVOKKibfhQJthh54C41xmOS/CKVt9ZDIUfkPxk3cdMbg==
X-Gm-Gg: AYBFou2a4PkuFbuuYSQPH90PK1tfjvcSUPRuS78hdHQosRQ5kxcgkaUveEU9EhVqNEt
	zDnbxEPC/P6hbkTSLb2OxIfr8hwydzuOkFbmqKUUUypkOdZIgJIaZW9SAFh31LCbtn3yhblSDaB
	sz+zOLY5ztciHyddufbqbQdUe/DxOOVGIsGYfigw9LMPYqfyMGKvkgeZUdrieUGOGHvkt2Dh5Ce
	9NaXWn5tmeolQJtqbO8leKUh5dSXbtCFBQxTC/GzOcoOwd7KY2nJifiaS5rdgODXRzCLvBQuQvV
	4f75ngUe0ubU6lrZS4FaX+Wz7KBZ59Y1Ul+XSgALSTx5Hnw48gM2FOjlKSmO6n/rn1q9J1dzWqT
	Oqpj+IY6+RXXRNBzR4dpMufuKK60nub/V+vAe/2T85/JhEr2G
X-Received: by 2002:a05:600c:3514:b0:49f:ce72:e931 with SMTP id 5b1f17b1804b1-49fe6701e7emr276898585e9.35.1790685074883;
        Tue, 29 Sep 2026 05:31:14 -0700 (PDT)
X-Received: by 2002:a05:600c:3514:b0:49f:ce72:e931 with SMTP id 5b1f17b1804b1-49fe6701e7emr276898035e9.35.1790685074310;
        Tue, 29 Sep 2026 05:31:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af502cd22sm3826417f8f.13.2026.09.29.05.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 05:31:13 -0700 (PDT)
Message-ID: <e230d00e-8c22-4d5e-bf40-e4ebed562ac7@redhat.com>
Date: Tue, 29 Sep 2026 14:31:11 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 01/26] scripts: introduce
 scripts/update-aarch64-cpu-sysregs-header.py
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
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-2-eric.auger@redhat.com>
 <A01DB50C-7455-4E60-9BF2-6F3C8369B529@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <A01DB50C-7455-4E60-9BF2-6F3C8369B529@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: voNNjHIQ4Vs0xI1DeDSgTwqPmJ1aVNgqmHt-jdK2IlA_1790685075
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/24/26 12:24 PM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Introduce a script that takes as input the Registers.json file
>> delivered in the AARCHMRS Features Model downloadable from the
>> Arm Developer A-Profile Architecture Exploration Tools page:
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__developer.arm.com_Architectures_A-2DProfile-2520Architecture-23Downloads&d=DwIDAg&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=SAaDSqqwmIC1nbrh-28kms6KiFYKvW8H_CIOKWgWjucuAn37j49gnNNnMIpoP_bK&s=sxOID-2FnhcQ56l1mmjKbXtXpcERk4oOXYiF3-6fenk&e= 
>> and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
>> under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>).
>>
>> We only care about IDregs with opcodes satisfying:
>> op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> [CH: note correct op1 range, don't skip CCSIDR]
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Message-ID: <20251208163751.611186-2-eric.auger@redhat.com>
>> ---
>> scripts/update-aarch64-cpu-sysregs-header.py | 146 +++++++++++++++++++
>> 1 file changed, 146 insertions(+)
>> create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
>>
>> diff --git a/scripts/update-aarch64-cpu-sysregs-header.py b/scripts/update-aarch64-cpu-sysregs-header.py
>> new file mode 100755
>> index 0000000000..ef1471a197
>> --- /dev/null
>> +++ b/scripts/update-aarch64-cpu-sysregs-header.py
>> @@ -0,0 +1,146 @@
>> +#!/usr/bin/env python3
>> +
>> +# This script takes as input the Registers.json file delivered in
>> +# the AARCHMRS Features Model downloadable from the Arm Developer
>> +# A-Profile Architecture Exploration Tools page:
>> +# https://urldefense.proofpoint.com/v2/url?u=https-3A__developer.arm.com_Architectures_A-2DProfile-2520Architecture-23Downloads&d=DwIDAg&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=SAaDSqqwmIC1nbrh-28kms6KiFYKvW8H_CIOKWgWjucuAn37j49gnNNnMIpoP_bK&s=sxOID-2FnhcQ56l1mmjKbXtXpcERk4oOXYiF3-6fenk&e= 
>> +# and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
>> +# under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>)
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
>> +
>> +def is_demux_register(r):
>> +    name = r.get('name', '')
>> +
>> +    if name.startswith("CCSIDR"):
>> +        return True
>> +
>> +    return False
>> +
>> +# Some regs have op code values like 000x, 001x. Anyway we don't need
>> +# them. Besides some regs are undesired in the generated file such as
>> +# VMPIDR_EL2 and VPIDR_EL2 which are outside of the IDreg scope we
>> +# are interested in and are tricky to decode as their system accessor
>> +# refer to MPIDR_EL1/MIDR_EL1 respectively
>> +
>> +skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', \
>> +            'VMPIDR_EL2', 'VPIDR_EL2’]
> I see VMPIDR_EL2/VPIDR_EL2 have op1=0100, they will automatically get skipped, why is this needed?

because op1=4 is outside of the IDreg range:
    op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

Eric
>
> Warm Regards,
> Khushit
>> +# returns the int value of a given @opcode for a reg @encoding
>> +def get_opcode(encoding, opcode):
>> +    fvalue = encoding.get(opcode)
>> +    if fvalue:
>> +        value = fvalue.get('value')
>> +        if isinstance(value, str):
>> +            value = value.strip("'")
>> +            value = int(value, 2)
>> +            return value
>> +    return -1
>> +
>> +def extract_idregs_from_registers_json(filename):
>> +    """
>> +    Load a Registers.json file and extract all ID registers, decode their
>> +    opcode and dump the information in target/arm/cpu-sysregs.h.inc
>> +
>> +    Args:
>> +        filename (str): The path to the Registers.json
>> +    returns:
>> +        idregs: list of ID regs and their encoding
>> +    """
>> +    if not os.path.exists(filename):
>> +        print(f"Error: {filename} could not be found!")
>> +        return {}
>> +
>> +    try:
>> +        with open(filename, 'r') as f:
>> +            register_data = json.load(f)
>> +
>> +    except json.JSONDecodeError:
>> +        print(f"Could not decode json from '{filename}'!")
>> +        return {}
>> +    except Exception as e:
>> +        print(f"Unexpected error while reading {filename}: {e}")
>> +        return {}
>> +
>> +    registers = [
>> +        r for r in register_data
>> +        if isinstance(r, dict)
>> +        and r.get('_type') == 'Register'
>> +        and not is_demux_register(r)
>> +    ]
>> +
>> +    idregs = {}
>> +
>> +    for register in registers:
>> +        reg_name = register.get('name')
>> +
>> +        is_skipped = any(term in (reg_name or "").upper() for term in skiplist)
>> +
>> +        if reg_name and not is_skipped:
>> +            accessors = register.get('accessors', [])
>> +
>> +            for accessor in accessors:
>> +                type = accessor.get('_type')
>> +                if type in ['Accessors.SystemAccessor']:
>> +                    encoding_list = accessor.get('encoding')
>> +
>> +                    if isinstance(encoding_list, list) and encoding_list and \
>> +                       isinstance(encoding_list[0], dict):
>> +                        encoding_wrapper = encoding_list[0]
>> +                        encoding_source = encoding_wrapper.get('encodings', \
>> +                                                               encoding_wrapper)
>> +
>> +                        if isinstance(encoding_source, dict):
>> +                                op0 = get_opcode(encoding_source, 'op0')
>> +                                op1 = get_opcode(encoding_source, 'op1')
>> +                                op2 = get_opcode(encoding_source, 'op2')
>> +                                crn = get_opcode(encoding_source, 'CRn')
>> +                                crm = get_opcode(encoding_source, 'CRm')
>> +                                encoding_str=f"{op0} {op1} {crn} {crm} {op2}"
>> +
>> +                # ID regs are assumed within this scope
>> +                if op0 == 3 and (op1 == 0 or op1 == 1 or op1 == 3) and \
>> +                   crn == 0 and (crm >= 0 and crm <= 7) and (op2 >= 0 and op2 <= 7):
>> +                    idregs[reg_name] = encoding_str
>> +
>> +    return idregs
>> +
>> +if __name__ == "__main__":
>> +    # Single arg expected: the path to the Registers.json file
>> +    if len(sys.argv) < 2:
>> +        print("Usage: python scripts/update-aarch64-cpu-sysregs-header.py "
>> +              "<path_to_registers_json>")
>> +        sys.exit(1)
>> +    else:
>> +        json_file_path = sys.argv[1]
>> +
>> +    extracted_registers = extract_idregs_from_registers_json(json_file_path)
>> +
>> +    if extracted_registers:
>> +        output_list = extracted_registers.items()
>> +
>> +        # Sort by register name
>> +        sorted_output = sorted(output_list, key=lambda item: item[0])
>> +
>> +        # format lines as DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>)
>> +        final_output = ""
>> +        for reg_name, encoding in sorted_output:
>> +            reformatted_encoding = encoding.replace(" ", ", ")
>> +            final_output += f"DEF({reg_name}, {reformatted_encoding})\n"
>> +
>> +        with open("target/arm/cpu-sysregs.h.inc", 'w') as f:
>> +            f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
>> +            f.write("/* This file is autogenerated by ")
>> +            f.write("scripts/update-aarch64-cpu-sysregs-header.py */\n")
>> +            f.write("/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */\n\n")
>> +            f.write(final_output)
>> +        print("updated target/arm/cpu-sysregs.h.inc")
>> -- 
>> 2.53.0
>>

