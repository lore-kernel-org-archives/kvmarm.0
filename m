Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EBE51C055
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790692139; cv=none; b=Km5dT3acyw7xoZCy5MjiypXt4GtXBwRRYdalZa/zdOFG1xenqOm7qsKF3i0MkfuDv0Ukjiq6n57GilIiLUonv8wFJVca+eNhxx1afoO/okFKZiEocphnrV3sWzV4l2yA/UI1PXbiNbw4iGfjbjd3avxoM+cK6XXDJKvlfWy55DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790692139; c=relaxed/simple;
	bh=0Pgq/03mGKHYriZa4yyn1yV/nWojIDthW0YRtQtLklk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qmTV0cSALv8pnIc0/29g1IZAhvyLBnZ8lDtEWgi45ZyPJ5sq5eqWPtg7lK838rgS5EWnJAVdoQKgVyuS73xkJ+6Q/M8QGQ55ebAxxJ6JS1i5EHWv1EuT0mr2fse9P16RsgpeHZbJiEZB3uk8W9dx5dTvhFQxdM+TT1Dx8k/AmAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UUIV86im; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UUIV86im"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790692136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iMdZTUzW6tmk9U3S/ve1XyBxFEFKMSJBuUIFy11JJ4=;
	b=UUIV86imPbcfu7bPZ11j18mBdILuBADfhfpNk3v+TgxQfplVXZNwAPGfZH9bMQPf28PMvr
	WxnQ9xv8IZ8pIp/hRjSup5uDSixBdovTq8Zz8/W9JDgOoAjiYxtz2CyUsPHqW9RFqd7+zX
	KB0w+7rwp+J84Jnw+DoBZO+OLP6TRJc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-sfrkFW5dOFu3l9aBmMD5Nw-1; Tue, 29 Sep 2026 10:28:53 -0400
X-MC-Unique: sfrkFW5dOFu3l9aBmMD5Nw-1
X-Mimecast-MFC-AGG-ID: sfrkFW5dOFu3l9aBmMD5Nw_1790692132
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49ffe48d1dfso35089465e9.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 07:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790692132; x=1791296932;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+iMdZTUzW6tmk9U3S/ve1XyBxFEFKMSJBuUIFy11JJ4=;
        b=hwdR9TM4dcC7PY0ymaeZwVSJQ+C2IQErgp9orl+Fh/UUXUl+XPB490V9tPWagvrdN8
         I4pfYPjSnKGg51JIK7G/qqjdBOgy2Jn6T8L7IgZPWhtMkHm1mrTBx4w6OE3ONVrBPUod
         73Y84ub4mL74/XZ9za1KTmWiW1x/16776vvfLcRZcQk+Cjjzgik93X/qWFua1Y4cMPs6
         FC/01OcKzHtPjX2uy//3lum13RaShXPXUrSJu9/BY5gQjKUbQoeD14Nlt3DlFnrbDnxC
         KChWggMEaz2l+45eDOLtOrbAKXO3fwtzJAd2uySz1jKUM/KXLF0rV2CilVvCY4zgfPWE
         /4OQ==
X-Forwarded-Encrypted: i=1; AKwUvByQfk1fO+KfO2feHbRwko/o3p9odlaRCnPfNmg7bYvB/J/le7NrZ+ROh5uqeZKEMR4czi3jTko=@lists.linux.dev
X-Gm-Message-State: AFuF++lKpAGnUfBu5F/oUzbZ3/aUc14DSTuGujZS9V0YROUkhRTibxBE
	xyBfNJOI/4OVNBeQJzUkcoKL/HcwtEJj0ZbViq2Yuh+xEcT28FpJ19v6DH2xZNGSA/1/CDKmjFd
	VY1UTgr6NDkzeT3gDQNsFbPGWoAUp2kgb9jlMi45eahPrBl5X/AkLrMGEuQ==
X-Gm-Gg: AYBFou3BSjHXluV9aR6/LXYG1LrMqB2ah/kOzjv+1JqQyb5ektaTMucLD8YM0FOC17E
	si69n7oKD5LiDA7VPKngw2K9tdLNOrHBM0+B3KXdUhxVqobhILvHJ9oWIYpd3rHarDAqji3dW/f
	on+hHHJW0XeXBcd1MdY607oZIHFHoLBnXPfJVXFKBen+twi0qPssaXrMMsb6rCOpZW1rkW4bG4c
	oXJAC9Os4yDL6uBaC+5no68Xymb+cokATfFTKATyJ7L/mEBIkBYK0z5iYyw76SBUPe8bJ+esxRd
	Qr+B3e4U8TrXHxMZW/lT3jlT/TkA0Z5JtRYFJm7iM/9swyOYFi18GXNLXgZ92UbnsG/Pv4+TVF4
	cz1fgRbCW+rU7K48qAzTz2aE7I7PABfQPHPRw9q6U+FE=
X-Received: by 2002:a05:600d:8498:10b0:4a0:98c:e082 with SMTP id 5b1f17b1804b1-4a0098ce21emr57437975e9.13.1790692131729;
        Tue, 29 Sep 2026 07:28:51 -0700 (PDT)
X-Received: by 2002:a05:600d:8498:10b0:4a0:98c:e082 with SMTP id 5b1f17b1804b1-4a0098ce21emr57437325e9.13.1790692131246;
        Tue, 29 Sep 2026 07:28:51 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af4f88352sm4803116f8f.4.2026.09.29.07.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 07:28:50 -0700 (PDT)
Message-ID: <5e122995-d733-41ff-af4b-c6133ebba83e@redhat.com>
Date: Tue, 29 Sep 2026 16:28:41 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/26] scripts: introduce
 scripts/update-aarch64-cpu-sysregs-header.py
To: eric.auger@redhat.com, Khushit Shah <khushit.shah@nutanix.com>
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
 <e230d00e-8c22-4d5e-bf40-e4ebed562ac7@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <e230d00e-8c22-4d5e-bf40-e4ebed562ac7@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zV2bWWEK8gJCjM46pBQeYgagYbbkgyjMHWzOZ0JEIdA_1790692132
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/29/26 2:31 PM, Eric Auger wrote:
> 
> 
> On 9/24/26 12:24 PM, Khushit Shah wrote:
>>
>>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>>
>>> !-------------------------------------------------------------------|
>>>  CAUTION: External Email
>>>
>>> |-------------------------------------------------------------------!
>>>
>>> Introduce a script that takes as input the Registers.json file
>>> delivered in the AARCHMRS Features Model downloadable from the
>>> Arm Developer A-Profile Architecture Exploration Tools page:
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__developer.arm.com_Architectures_A-2DProfile-2520Architecture-23Downloads&d=DwIDAg&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=SAaDSqqwmIC1nbrh-28kms6KiFYKvW8H_CIOKWgWjucuAn37j49gnNNnMIpoP_bK&s=sxOID-2FnhcQ56l1mmjKbXtXpcERk4oOXYiF3-6fenk&e= 
>>> and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
>>> under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>).
>>>
>>> We only care about IDregs with opcodes satisfying:
>>> op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> [CH: note correct op1 range, don't skip CCSIDR]
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> Message-ID: <20251208163751.611186-2-eric.auger@redhat.com>
>>> ---
>>> scripts/update-aarch64-cpu-sysregs-header.py | 146 +++++++++++++++++++
>>> 1 file changed, 146 insertions(+)
>>> create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
>>>
>>> diff --git a/scripts/update-aarch64-cpu-sysregs-header.py b/scripts/update-aarch64-cpu-sysregs-header.py
>>> new file mode 100755
>>> index 0000000000..ef1471a197
>>> --- /dev/null
>>> +++ b/scripts/update-aarch64-cpu-sysregs-header.py
>>> @@ -0,0 +1,146 @@
>>> +#!/usr/bin/env python3
>>> +
>>> +# This script takes as input the Registers.json file delivered in
>>> +# the AARCHMRS Features Model downloadable from the Arm Developer
>>> +# A-Profile Architecture Exploration Tools page:
>>> +# https://urldefense.proofpoint.com/v2/url?u=https-3A__developer.arm.com_Architectures_A-2DProfile-2520Architecture-23Downloads&d=DwIDAg&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=SAaDSqqwmIC1nbrh-28kms6KiFYKvW8H_CIOKWgWjucuAn37j49gnNNnMIpoP_bK&s=sxOID-2FnhcQ56l1mmjKbXtXpcERk4oOXYiF3-6fenk&e= 
>>> +# and outputs the list of ID regs in target/arm/cpu-sysregs.h.inc
>>> +# under the form of DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>)
>>> +#
>>> +# Copyright (C) 2026 Red Hat, Inc.
>>> +#
>>> +# Authors: Eric Auger <eric.auger@redhat.com>
>>> +#
>>> +# SPDX-License-Identifier: GPL-2.0-or-later
>>> +
>>> +
>>> +import json
>>> +import os
>>> +import sys
>>> +
>>> +def is_demux_register(r):
>>> +    name = r.get('name', '')
>>> +
>>> +    if name.startswith("CCSIDR"):
>>> +        return True
>>> +
>>> +    return False
>>> +
>>> +# Some regs have op code values like 000x, 001x. Anyway we don't need
>>> +# them. Besides some regs are undesired in the generated file such as
>>> +# VMPIDR_EL2 and VPIDR_EL2 which are outside of the IDreg scope we
>>> +# are interested in and are tricky to decode as their system accessor
>>> +# refer to MPIDR_EL1/MIDR_EL1 respectively
>>> +
>>> +skiplist = ['ALLINT', 'PM', 'S1_', 'S3_', 'SVCR', \
>>> +            'VMPIDR_EL2', 'VPIDR_EL2’]
>> I see VMPIDR_EL2/VPIDR_EL2 have op1=0100, they will automatically get skipped, why is this needed?
> 
> because op1=4 is outside of the IDreg range:
>     op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

sorry I misunderstood the actual point. Althouth op1=4 I get them if I
don't explicitly put them in the skiplist.

What is output is:
> DEF(VMPIDR_EL2, 3, 0, 0, 0, 5)
> DEF(VPIDR_EL2, 3, 0, 0, 0, 0)

As mentionned in the above comment the reason we get them is among
accessors the script finds MPIDR_EL1/MIDR_EL1.

this is due to this specificity: "If EL2 is not implemented, reads of
this register return the value of the MPIDR_EL1/MIDR_EL1 and writes to
the register are ignored.". Since it is a very special case, I prefer to
skip them explicitly knowing that anyway they are outside of the
interest scope.

Eric


> 
> Eric
>>
>> Warm Regards,
>> Khushit
>>> +# returns the int value of a given @opcode for a reg @encoding
>>> +def get_opcode(encoding, opcode):
>>> +    fvalue = encoding.get(opcode)
>>> +    if fvalue:
>>> +        value = fvalue.get('value')
>>> +        if isinstance(value, str):
>>> +            value = value.strip("'")
>>> +            value = int(value, 2)
>>> +            return value
>>> +    return -1
>>> +
>>> +def extract_idregs_from_registers_json(filename):
>>> +    """
>>> +    Load a Registers.json file and extract all ID registers, decode their
>>> +    opcode and dump the information in target/arm/cpu-sysregs.h.inc
>>> +
>>> +    Args:
>>> +        filename (str): The path to the Registers.json
>>> +    returns:
>>> +        idregs: list of ID regs and their encoding
>>> +    """
>>> +    if not os.path.exists(filename):
>>> +        print(f"Error: {filename} could not be found!")
>>> +        return {}
>>> +
>>> +    try:
>>> +        with open(filename, 'r') as f:
>>> +            register_data = json.load(f)
>>> +
>>> +    except json.JSONDecodeError:
>>> +        print(f"Could not decode json from '{filename}'!")
>>> +        return {}
>>> +    except Exception as e:
>>> +        print(f"Unexpected error while reading {filename}: {e}")
>>> +        return {}
>>> +
>>> +    registers = [
>>> +        r for r in register_data
>>> +        if isinstance(r, dict)
>>> +        and r.get('_type') == 'Register'
>>> +        and not is_demux_register(r)
>>> +    ]
>>> +
>>> +    idregs = {}
>>> +
>>> +    for register in registers:
>>> +        reg_name = register.get('name')
>>> +
>>> +        is_skipped = any(term in (reg_name or "").upper() for term in skiplist)
>>> +
>>> +        if reg_name and not is_skipped:
>>> +            accessors = register.get('accessors', [])
>>> +
>>> +            for accessor in accessors:
>>> +                type = accessor.get('_type')
>>> +                if type in ['Accessors.SystemAccessor']:
>>> +                    encoding_list = accessor.get('encoding')
>>> +
>>> +                    if isinstance(encoding_list, list) and encoding_list and \
>>> +                       isinstance(encoding_list[0], dict):
>>> +                        encoding_wrapper = encoding_list[0]
>>> +                        encoding_source = encoding_wrapper.get('encodings', \
>>> +                                                               encoding_wrapper)
>>> +
>>> +                        if isinstance(encoding_source, dict):
>>> +                                op0 = get_opcode(encoding_source, 'op0')
>>> +                                op1 = get_opcode(encoding_source, 'op1')
>>> +                                op2 = get_opcode(encoding_source, 'op2')
>>> +                                crn = get_opcode(encoding_source, 'CRn')
>>> +                                crm = get_opcode(encoding_source, 'CRm')
>>> +                                encoding_str=f"{op0} {op1} {crn} {crm} {op2}"
>>> +
>>> +                # ID regs are assumed within this scope
>>> +                if op0 == 3 and (op1 == 0 or op1 == 1 or op1 == 3) and \
>>> +                   crn == 0 and (crm >= 0 and crm <= 7) and (op2 >= 0 and op2 <= 7):
>>> +                    idregs[reg_name] = encoding_str
>>> +
>>> +    return idregs
>>> +
>>> +if __name__ == "__main__":
>>> +    # Single arg expected: the path to the Registers.json file
>>> +    if len(sys.argv) < 2:
>>> +        print("Usage: python scripts/update-aarch64-cpu-sysregs-header.py "
>>> +              "<path_to_registers_json>")
>>> +        sys.exit(1)
>>> +    else:
>>> +        json_file_path = sys.argv[1]
>>> +
>>> +    extracted_registers = extract_idregs_from_registers_json(json_file_path)
>>> +
>>> +    if extracted_registers:
>>> +        output_list = extracted_registers.items()
>>> +
>>> +        # Sort by register name
>>> +        sorted_output = sorted(output_list, key=lambda item: item[0])
>>> +
>>> +        # format lines as DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>)
>>> +        final_output = ""
>>> +        for reg_name, encoding in sorted_output:
>>> +            reformatted_encoding = encoding.replace(" ", ", ")
>>> +            final_output += f"DEF({reg_name}, {reformatted_encoding})\n"
>>> +
>>> +        with open("target/arm/cpu-sysregs.h.inc", 'w') as f:
>>> +            f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
>>> +            f.write("/* This file is autogenerated by ")
>>> +            f.write("scripts/update-aarch64-cpu-sysregs-header.py */\n")
>>> +            f.write("/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */\n\n")
>>> +            f.write(final_output)
>>> +        print("updated target/arm/cpu-sysregs.h.inc")
>>> -- 
>>> 2.53.0
>>>
> 

