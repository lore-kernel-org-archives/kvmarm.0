Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED865293F7
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694914; cv=none; b=UsO2FpmzyDQE9hG8WU7KZGbWa8M3wM9AOORvgpmPsDRs6/EFk1WX5TZI7ySYx3WWpzznf0XAUsv6lazLFefw6cDiUfEDYOADi7f/u4BdopQNXNqDQPFWMiJEabnwGLYlnsOhmb7yFNItHURtg9VI1cRRz3W9cjgCYcCGsx/v1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694914; c=relaxed/simple;
	bh=dEk+koK+5iLbz1KPSISrSNnbxWr8kw6xIZPT+BiIQO4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qsJY+ZN9/uZDHXmZnFxn9LHPLcLB0OcO49khaEpmjkGcJYESXg1OosruZmXl20X37JQsKFrC1sWd2YXA9OmIAOFbtITL3tRUoN7Bon/0WsdO0/cAiCvWDw/CyBI++LmaVpCZQcOkX9FBhOVRVnm9+HxnoRZAd2WWQKV7xZipeHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMlG5De0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMlG5De0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790694905;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOApTsat11TyDtgWvjLxw13wZQJsxnVP6eQIqfbbNYA=;
	b=FMlG5De0AmUZErNOtn2qqAi+1soOA/iQlJUOXMCrhJKniUqel0c954p48/qZyHhCvw8x9D
	do3kD4z/Mof5Mrg/bfg/ak/FcXdG8af5eOu+FX2FEqzPpud0hki/qswkSaw5S8nfiIdJ8N
	F+jP6gb6GUi32IYq1zJLYWIHG515Bmc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-Pj1GOsImM62jdrESbqmtsQ-1; Tue, 29 Sep 2026 11:15:03 -0400
X-MC-Unique: Pj1GOsImM62jdrESbqmtsQ-1
X-Mimecast-MFC-AGG-ID: Pj1GOsImM62jdrESbqmtsQ_1790694903
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e635a6002so50484015e9.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 08:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790694902; x=1791299702;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:reply-to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JOApTsat11TyDtgWvjLxw13wZQJsxnVP6eQIqfbbNYA=;
        b=dqpoV12kjtiY8ZnxNzyflQBuxmp38+HCjFnjkDdytu59jPT+RgsQPO1r6ZFAmOHXFA
         ChIs3y0ERwWQK+hJxvFHVmn5hy026w3VTSNz0nMz3eFjU4OVHzLiRLHDm1QG5eHIa5Hw
         WSYedegKknrm2PyiR1TPtHj3zZpsdkUB87/nIysQ6KyESzT/uOoOfENrDvl8Gv+GIVOT
         E+0JKxJq1y2d9sym6No7QrLRiUAvg3kjKhm6OR2YjlZtyPZnY2LC830Vck+Q/N5vcex5
         BKOawKzRACYeZ1M98rvYq2mN3hGsjxiqImstJot9vP1A35k9nNNWQeVyYMeezKJWW/Xz
         C6pg==
X-Forwarded-Encrypted: i=1; AKwUvBz1SmW0H67AB9+Drw+sxOTSvFrvp/YSE1iCIUKvgE3vz5SErscgQvGsT4iRAevY2VnWFE2HFkI=@lists.linux.dev
X-Gm-Message-State: AFuF++mPX5HRf+5pXelRpGEAdaNgSOA4ln8cf0DRTkF7D6Iy9Qty168h
	oo+Ik8viVAOTWkmAv4w058IAfJBHiMiPG75fby4kQfghFMW8vpizuPJkbMxSY6Q/OsHgRsuu0Vi
	SFzDTGew5Zqgwb00CYtYk565GjnxEFbLdflxOyJXZj9TYJEbIl5aRdjlxzg==
X-Gm-Gg: AYBFou17PCdQjJKPIBova1eZK9xIk8/mnuzrvOX1nxABLCdzj4r2oRgs0PTQUfUyUX7
	HfHnOUUhJgS5AG711hhHVAzkty00teS9B0rTCHYA4VGx2n5AmWNoZEXzbs1CaNvUNxoh0VLxu4n
	3vK7Tnglni5IGV3tO+YCmmeJ3OKEUCwYn2PpPpELJ32CKerrczown8MKgpsx4S/uBnelaIwx/4m
	ACEXelDfYLfmLPzXFKfMc1YJR+natd/GBC+KotqdLZukcYDb/EspjGRnMMKplqyjIcVpdDzOQo2
	rZvBj+Zjx2S+VmLCziLjzhkFrlRUP5yVDxaEBQIfdyE0puziT6sWHFCqhfSsonZnt8i3XeSdN9d
	GOhPsI3R0GOLbe3My/NxzEIMQDdwMhr3tRyO7r2qfc3pkwNZN
X-Received: by 2002:a05:600c:4ed2:b0:49f:e3f2:f5a3 with SMTP id 5b1f17b1804b1-49fe6685393mr292557485e9.0.1790694902328;
        Tue, 29 Sep 2026 08:15:02 -0700 (PDT)
X-Received: by 2002:a05:600c:4ed2:b0:49f:e3f2:f5a3 with SMTP id 5b1f17b1804b1-49fe6685393mr292556905e9.0.1790694901810;
        Tue, 29 Sep 2026 08:15:01 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00ebcd353sm105153995e9.3.2026.09.29.08.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 08:15:00 -0700 (PDT)
Message-ID: <f5e2e972-b521-41f5-80f1-f5e4adb1ebfe@redhat.com>
Date: Tue, 29 Sep 2026 17:14:59 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 05/26] scripts: Introduce
 scripts/aarch64_sysreg_helpers module
Reply-To: eric.auger@redhat.com
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
 <20260916144721.751810-6-eric.auger@redhat.com>
 <5538C4CB-1B66-48A4-BA44-EF93CADE5C48@nutanix.com>
In-Reply-To: <5538C4CB-1B66-48A4-BA44-EF93CADE5C48@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DZPzBtbOC7SKveLfk77aCVPok-433s70hzcHgRFU7mw_1790694903
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/24/26 12:18 PM, Khushit Shah wrote:
> Only few nits.
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> We plan to reuse get_opcode() and extract_idregs_from_registers_json()
>> functions in another script. So let's move them into a module
> Nit: fullstop.
yes
>
>> No functional change intended.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reviewed-by: Khushit Shah <khushit.shah@nutanix.com>
>> ---
>> scripts/aarch64_sysreg_helpers.py            | 121 +++++++++++++++++++
>> scripts/update-aarch64-cpu-sysregs-header.py |  97 +--------------
>> 2 files changed, 122 insertions(+), 96 deletions(-)
>> create mode 100644 scripts/aarch64_sysreg_helpers.py
>>
>> diff --git a/scripts/aarch64_sysreg_helpers.py b/scripts/aarch64_sysreg_helpers.py
>> new file mode 100644
>> index 0000000000..24bbc5bb3d
>> --- /dev/null
>> +++ b/scripts/aarch64_sysreg_helpers.py
>> @@ -0,0 +1,121 @@
>> +#!/usr/bin/env python3
>> +
>> +# Helpers used in aarch64 sysreg definition generation
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
>> +            'VMPIDR_EL2', 'VPIDR_EL2']
>> +
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
> ^^ does not apply now.
indeed
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
> Can we put is_demux_register inside loop? 
done
>
>> +    ]
>> +
>> +    idregs = {}
>> +
>> +    # Some regs have op code values like 000x, 001x. Anyway we don't need
>> +    # them. Besides some regs are undesired in the generated file such as
>> +    # VMPIDR_EL2 and VPIDR_EL2 which are outside of the IDreg scope we
>> +    # are interested in and are tricky to decode as their system accessor
>> +    # refer to MPIDR_EL1/MIDR_EL1 respectively
>> +
>> +    skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', \
>> +                'VMPIDR_EL2', 'VPIDR_EL2’]
> I see the op1 of VMPIDR_EL2/VPIDR_EL2 is 0b100, why are they needed in the skip-list, as they will anyway be skipped...
see previous replies.

Note I have squashed the initial script + intro of the module + the
update because it is much simpler to maintain while staying functionaly
consistent.

Eric
>
> Warm Regards,
> Khushit
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
>> +
>> +
>> diff --git a/scripts/update-aarch64-cpu-sysregs-header.py b/scripts/update-aarch64-cpu-sysregs-header.py
>> index ef1471a197..43107264e9 100755
>> --- a/scripts/update-aarch64-cpu-sysregs-header.py
>> +++ b/scripts/update-aarch64-cpu-sysregs-header.py
>> @@ -17,102 +17,7 @@
>> import json
>> import os
>> import sys
>> -
>> -def is_demux_register(r):
>> -    name = r.get('name', '')
>> -
>> -    if name.startswith("CCSIDR"):
>> -        return True
>> -
>> -    return False
>> -
>> -# Some regs have op code values like 000x, 001x. Anyway we don't need
>> -# them. Besides some regs are undesired in the generated file such as
>> -# VMPIDR_EL2 and VPIDR_EL2 which are outside of the IDreg scope we
>> -# are interested in and are tricky to decode as their system accessor
>> -# refer to MPIDR_EL1/MIDR_EL1 respectively
>> -
>> -skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', \
>> -            'VMPIDR_EL2', 'VPIDR_EL2']
>> -
>> -# returns the int value of a given @opcode for a reg @encoding
>> -def get_opcode(encoding, opcode):
>> -    fvalue = encoding.get(opcode)
>> -    if fvalue:
>> -        value = fvalue.get('value')
>> -        if isinstance(value, str):
>> -            value = value.strip("'")
>> -            value = int(value, 2)
>> -            return value
>> -    return -1
>> -
>> -def extract_idregs_from_registers_json(filename):
>> -    """
>> -    Load a Registers.json file and extract all ID registers, decode their
>> -    opcode and dump the information in target/arm/cpu-sysregs.h.inc
>> -
>> -    Args:
>> -        filename (str): The path to the Registers.json
>> -    returns:
>> -        idregs: list of ID regs and their encoding
>> -    """
>> -    if not os.path.exists(filename):
>> -        print(f"Error: {filename} could not be found!")
>> -        return {}
>> -
>> -    try:
>> -        with open(filename, 'r') as f:
>> -            register_data = json.load(f)
>> -
>> -    except json.JSONDecodeError:
>> -        print(f"Could not decode json from '{filename}'!")
>> -        return {}
>> -    except Exception as e:
>> -        print(f"Unexpected error while reading {filename}: {e}")
>> -        return {}
>> -
>> -    registers = [
>> -        r for r in register_data
>> -        if isinstance(r, dict)
>> -        and r.get('_type') == 'Register'
>> -        and not is_demux_register(r)
>> -    ]
>> -
>> -    idregs = {}
>> -
>> -    for register in registers:
>> -        reg_name = register.get('name')
>> -
>> -        is_skipped = any(term in (reg_name or "").upper() for term in skiplist)
>> -
>> -        if reg_name and not is_skipped:
>> -            accessors = register.get('accessors', [])
>> -
>> -            for accessor in accessors:
>> -                type = accessor.get('_type')
>> -                if type in ['Accessors.SystemAccessor']:
>> -                    encoding_list = accessor.get('encoding')
>> -
>> -                    if isinstance(encoding_list, list) and encoding_list and \
>> -                       isinstance(encoding_list[0], dict):
>> -                        encoding_wrapper = encoding_list[0]
>> -                        encoding_source = encoding_wrapper.get('encodings', \
>> -                                                               encoding_wrapper)
>> -
>> -                        if isinstance(encoding_source, dict):
>> -                                op0 = get_opcode(encoding_source, 'op0')
>> -                                op1 = get_opcode(encoding_source, 'op1')
>> -                                op2 = get_opcode(encoding_source, 'op2')
>> -                                crn = get_opcode(encoding_source, 'CRn')
>> -                                crm = get_opcode(encoding_source, 'CRm')
>> -                                encoding_str=f"{op0} {op1} {crn} {crm} {op2}"
>> -
>> -                # ID regs are assumed within this scope
>> -                if op0 == 3 and (op1 == 0 or op1 == 1 or op1 == 3) and \
>> -                   crn == 0 and (crm >= 0 and crm <= 7) and (op2 >= 0 and op2 <= 7):
>> -                    idregs[reg_name] = encoding_str
>> -
>> -    return idregs
>> +from aarch64_sysreg_helpers import extract_idregs_from_registers_json
>>
>> if __name__ == "__main__":
>>     # Single arg expected: the path to the Registers.json file
>> -- 
>> 2.53.0
>>

