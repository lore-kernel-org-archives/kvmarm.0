Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3165328AD
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173358; cv=none; b=UYuCao2eWF8jMxowxSLu7xleQfeHkCFu1AyzXUxR0T5NRj+z611s0nsIZdtg95CnjkdeQ/8/n/A80UAn5YIQ3kvKzohWyLPM2YYMFy9pCdro99/+HFvraPdUGm9EhpHP4YK11o6TsX5IA/nb0UWyYy4yxqxn/ypuLmYlqBt9rNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173358; c=relaxed/simple;
	bh=Y66yU8CmRvF6bykMUYL/w/kR8mpyIrE+j5w2IFYGRsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mlTVoJ2Mi0HqO8Qs1jyPZGaSRSnLv3jG/Bdv3wqRpYUWVhCa1svPe9660f/cu5n+bbuZCztCfm7Bw72bNKVWcqlLtkf+RZ4k3LNbBlyga7JSPDetDg1RNXsHV1r7WOMd07Jlt4AwhrXKXVyGZ/bvDERFXxp0/n5+74auWlBBCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SH7fD3Mw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SH7fD3Mw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790173354;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7aoaBOulFuwQYD1ITihbG/NdQqoYMQMji4H+L4BU2QU=;
	b=SH7fD3Mw0xPXn8GRm3/AVaj5hHMF0fxkcj/wYJdB6a0DLweYVwXiElnX9snaXMgBhpnXK9
	zENzBB/F0XGMiKH+utVVYyYUp7odURevPu0VUcT8wivOKzPBGkWKo9OSwCHot5Ex74Xr0f
	N0WExaGyZDNCpQLufEJKyJVKYgOeUEc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-kIAIkBJXPzqGhtd1-GJfvA-1; Wed, 23 Sep 2026 10:22:30 -0400
X-MC-Unique: kIAIkBJXPzqGhtd1-GJfvA-1
X-Mimecast-MFC-AGG-ID: kIAIkBJXPzqGhtd1-GJfvA_1790173349
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f2de3ba47so893769f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 07:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790173349; x=1790778149;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7aoaBOulFuwQYD1ITihbG/NdQqoYMQMji4H+L4BU2QU=;
        b=drGIMg5l1vkMTnlrjA8vtDW2+KkL85SgNzTxHBmBhUubEIL6D63FAHC6UMDpDyGsVH
         +7jPeFVfvZ5SdYRDmhLONGDAMQo5wd4k9gSPtVAPpNnF8JEq5+9tIPKNUn1lgdPkXPzG
         jSbMz7PFgugbSJ0cKK9RcDVacPW955UqbrDtvR1W0oUw3VGNFq26n0Ch1Cdi4RaVpaFp
         jI6FAYWwEZcckswUzdEvymbhmQs3Y/KvDBzWiDz6bWKu984NFRGJ/gpHrOyIMvjMh+Sy
         0g8ohheu9CYL78Y+Jo4gnOG36T4KoAioeZelgerHNc8XtUHWCNs/61QRp8KheTarHwnq
         MBzQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuHkCughoEyrtzVYHMXUA/Whj2tLr4O4TCv0BRFQmUiqP8i8fnwGMKt232rmKfekHnTjsxMbQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kv69yltu0Qkfhs9QrVJXdIr1ywaV3UUbTdSQgvnQKpkZesYtuG
	HVhkZKkdH4cViW2roU7aKt/wGjgqxE0sg3a6r1wI5I0rGJjZvUp0W4mcVOZ1Qdx2SKQao+VhFku
	GQye+qraknvt4yuC5q/oVPJnP8EA0dW0jeO3db0roHbd12yfXkXu+N7YaFg==
X-Gm-Gg: AYBFou1yAbULtRU/v6DlB7mRL7prw2niWeo9gCtG3cRoPat0JXalQkeJUWeimYNWdcX
	RyLio2NBmh8d9kCxux86Ff76ZyNf0Kylmnij+bCi0+lqqjgGvQ5Qm+4hhB4BmJjJ4NFome6UByB
	83xnh/ai0/r0t2DtCaeaODEbz1ZyuVGW8f1awjFgDWZzHif2CQ2FOo8Lf5zmjRnGgPGyyhFZ9e6
	Xrh/7CRCJuBMtyn2lYMnDoFmAqdwZL/Txt21XOJMLOPv6lXLIc+UOWKFe1/qXWdxmpGb/pnkq/z
	+2lrpvzjbvJHKM0/sdepYI5xOiojzlTfhUkUSfLrsOHELh/b0THw6T/8FQQ8+8/CP3/sLs5OIJ/
	YfCFbfntpwqVKyfagbqh/ddWeZUieooaNdxKdkUIjSS4t9Gy5
X-Received: by 2002:a05:6000:41dc:b0:486:f3c0:c26b with SMTP id ffacd0b85a97d-488670b9fcfmr4604089f8f.57.1790173349403;
        Wed, 23 Sep 2026 07:22:29 -0700 (PDT)
X-Received: by 2002:a05:6000:41dc:b0:486:f3c0:c26b with SMTP id ffacd0b85a97d-488670b9fcfmr4604051f8f.57.1790173348944;
        Wed, 23 Sep 2026 07:22:28 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488682673bdsm7266340f8f.2.2026.09.23.07.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 07:22:28 -0700 (PDT)
Message-ID: <ec8259c9-ce1a-4808-b37f-385a32c5325c@redhat.com>
Date: Wed, 23 Sep 2026 16:22:26 +0200
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
 <2A2EDB1C-E551-445A-A5CD-AE0786D21D60@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <2A2EDB1C-E551-445A-A5CD-AE0786D21D60@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 22ZzspZ0X88QkX3m0FAdynw0a82_0LW-YtAjg_jN3b8_1790173349
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,
On 9/23/26 9:08 AM, Khushit Shah wrote:
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
> Nit: unintended?
> Also, now Cornelia’s comment does not apply… (we are actively skipping CCSIDR)

effectively those mentions can be removed now

Thanks

Eric
>
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

