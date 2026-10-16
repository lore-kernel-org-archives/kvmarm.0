Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562A741D4FC
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 07:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135140; cv=none; b=ZDicBCMRNueIJTv9KiafuR0DBtUgrCXIOdKiv4VmvyaFVPY0rEP3g6GdIUOh02LCW1DHnpHe6xluGbyKleRLwyU9Jv+97nzhpp+YOFKZMvn8riiIk2vvdugKfDJlMTW/iKksBcGpZhuV55le1q5MrBKM0btqe7/FdOjcSx1X6+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135140; c=relaxed/simple;
	bh=eKijwLCO2V7yadAIq/s8K7fKLUMrlInze4joXo3VfiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0nLm9SGHqa+AFd4Galh/1pV2xM0ljx9bhVI/hK41RQMllvfEo1hC3zJGGorlKRs40pl8YHQA1Q9he6cPdOO+y6Jlo5QN/13iBpwCKF9LJR6Ja6EHBCoSSFB7OvyNwxLRuLa8v2+s6ICHfzjMGYhjJV5PnOSfuAUq24StFbQMd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K+6QSHUo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+6QSHUo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792135138;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3f9/6LgmaKsPXYha8cSw0gPoaJfxngHRSEJk4YtEG3A=;
	b=K+6QSHUoS5z+rtuewR4Ei/X8MLubfRzLNDiKJHplcxP7VmlYcYC3NVHz3pXmpx+D0v71Hu
	JXL7kUTDJlY5QJH+BN5B+OJ+4N8R6eCqwrM5BowuHrfw7RMpxUsjH5e68G6TUl5kGJlaOz
	fAkRTIukzDjsmd6VMQOmQnTnWcOqYRU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-Z0v_x4o1OcSD2rV3PwCz0g-1; Fri, 16 Oct 2026 07:18:57 +0000
X-MC-Unique: Z0v_x4o1OcSD2rV3PwCz0g-1
X-Mimecast-MFC-AGG-ID: Z0v_x4o1OcSD2rV3PwCz0g_1792135136
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a01b112fa2so39947585e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 00:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792135136; x=1792739936;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3f9/6LgmaKsPXYha8cSw0gPoaJfxngHRSEJk4YtEG3A=;
        b=idXZIg9xp+NwWJlbcBjSFtkoRGEuimcf9mPegHDctKrx+wYwThozHmEgzjgebPFHnt
         1AXycmEnEDWKfwuCRZ3/Nh94B/ZV/+H3Yz1i1rxf3aAeQpC6kweT0RgvngRHK0nAW+CA
         enVKaxUQk+i606bKwj2G9xQTjlAUfqYd0Y8mTbv022yRJVP6LMTbCuDKRnrM8U+7pzn3
         O+5LhlunDajQ7a1JfWjXu+uzNxqkLoOlYEiAkv+Ldwr1DrJtTKhRBvpY3s3IM02CzrdM
         /j3dtskKvyPE3WHNvLSRhnlqa75yFiGkUSeX9sB1BctkFFgfxpnxbi3SDVUdTk8M7pCt
         gqsQ==
X-Forwarded-Encrypted: i=1; AKwUvByxVRtGCpPyr1hbffhk8vvtkNljI7KYRrrn39m9Of/ik7OnpwreAoeIw0i0zQ8zIVEkHpPlnuY=@lists.linux.dev
X-Gm-Message-State: AFq9FYLVPXOJhs7G86cISevLzn4ps3A7Wsbgvd0LDwD2gV21wKupe5X9
	mAhSg+VL60+m07fjFh9Xj7p3iCfBt+VSd2LXcxGewMbDGwtUaakvQZ1J8yy/tKX7qjUomsVcyRo
	Zt5V2lWvzzGKRijeY7oc4qqLRVPXFPI4zuun1mc2Un9n0OZosDraQSZ5LzA==
X-Gm-Gg: AYBFou2c0JA6hWfo0v7+lPmhpL2HWuH80hYXS/X8bvGes9I/aCSSlax0G8cjqAXlCUA
	ZXkXJtZLJQ1/2QtsqwMDyuHb50Qu1pXmvQBihsjVuLfG1RaS3oizYLDdFfQZzDXacyrRjJ2qAnJ
	bV97v02rUxevydc8eigoBpGmAZL9jKvSj5fy1UHCXYbVjP/ikWGjdlx0FUrnSImdZX+8p2PrSmS
	u6rGzJcnnPAzXOv/3Xy+YhiKxj/+74fiaslFCj0ubCfmxHAoSDasZa1eDutbm3rI5+EqYuHxZnR
	ORdG0ic0StsiERyO0jt70yd0mNjb8qxk4PLlPo6tIiX19A4nMKyiFThxZjkht2KVQgD+2vbLzN7
	2GGsLVLgxQmOnbsgYeHqJsCIpYZwGN6bhYxLuEdg/++rg8zEW
X-Received: by 2002:a05:600c:e54a:10b0:4a0:1f90:594b with SMTP id 5b1f17b1804b1-4a1c6f89db5mr26497465e9.22.1792135135745;
        Fri, 16 Oct 2026 00:18:55 -0700 (PDT)
X-Received: by 2002:a05:600c:e54a:10b0:4a0:1f90:594b with SMTP id 5b1f17b1804b1-4a1c6f89db5mr26496835e9.22.1792135135186;
        Fri, 16 Oct 2026 00:18:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfdeb18f8sm2607552f8f.20.2026.10.16.00.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 00:18:54 -0700 (PDT)
Message-ID: <88da51b4-bead-4446-8f33-d77ff605b59a@redhat.com>
Date: Fri, 16 Oct 2026 09:18:52 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 23/25] qmp: add query-cpu-props-info command
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 "ping@khushitshah.com" <ping@khushitshah.com>,
 Sandesh Patel <sandesh.patel@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-24-khushit.shah@nutanix.com>
 <543a8f0a-bd66-4c13-8117-07f069a754d8@redhat.com>
 <95CBB54C-21CB-4594-8EA4-9C596ADB65EE@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <95CBB54C-21CB-4594-8EA4-9C596ADB65EE@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sVHxWZGpaoDLoI4lETzr-OdPQPe2gh4VzEQkvtXYj4c_1792135136
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/16/26 8:57 AM, Khushit Shah wrote:
>
>> On 15 Oct 2026, at 7:50 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>>
>>
>> On 9/21/26 2:32 PM, Khushit Shah wrote:
>>> Introduce the 'query-cpu-props-info' QMP command. For each CPU model
>>> property, it reports the type (boolean or number) and the set of values
>>> supported under the active accelerator and host.
>>>
>>> This helps the management stack to discover which values are supported
>>> for a given CPU property. This is especially important for non-boolean
>>> properties, where knowing that the host has value 'x' does not
>>> inherently reveal the full range of valid values supported on the host.
>>> For example, an Arm host with CTR_EL0.L1Ip=3 (PIPT) also allows 2
>>> (VIPT) but a host with CTR_EL0.L1Ip=2 does not allow CTR_EL0.L1Ip=3
>>> for a guest.
>>>
>>> For numerical properties, the supported values are expressed as a list
>>> of inclusive {min, max} ranges. For boolean properties, they are
>>> represented as a list of true/false values.
>>>
>>> The command and its return types (CpuPropertyType, CpuPropertyInfo and
>>> friends) are defined in qapi/machine.json rather than an Arm-specific
>>> schema, since the concept applies to other targets (e.g. x86, RISC-V)
>>> too. Targets that do not implement it return an error.
>>> (The following commit implements the command for Arm KVM.)
>>>
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>> ---
>>> qapi/machine.json          | 82 ++++++++++++++++++++++++++++++++++++++
>>> stubs/meson.build          |  1 +
>>> stubs/qmp-cpu-props-info.c | 12 ++++++
>>> tests/qtest/qmp-cmd-test.c |  1 +
>>> 4 files changed, 96 insertions(+)
>>> create mode 100644 stubs/qmp-cpu-props-info.c
>>>
>>> diff --git a/qapi/machine.json b/qapi/machine.json
>>> index 2d63c1bac3..6e65bdad86 100644
>>> --- a/qapi/machine.json
>>> +++ b/qapi/machine.json
>>> @@ -2291,3 +2291,85 @@
>>> # Since: 1.2
>>> ##
>>> { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'] }
>>> +
>>> +##
>>> +# @CpuPropertyType:
>>> +#
>>> +# The type of a CPU model property.
>>> +#
>>> +# @boolean: the property is of type boolean.
>>> +#
>>> +# @number: the property is of type unsigned integer.
>>> +#
>>> +# Since: 11.2
>>> +##
>>> +{ 'enum': 'CpuPropertyType',
>>> +  'data': [ 'boolean', 'number' ] }
>> why do we still need the boolean type? Can't we simplify and stick to
>> uint64_t for all SYSREG props?
> Hi Eric,
>
> Bools to support existing properties (sve, pauth, etc…) are booleans.
>>> +
>>> +##
>>> +# @CpuPropertyValueRange:
>>> +#
>>> +# An inclusive range of numeric values supported for the property.
>>> +#
>>> +# @min: the lowest supported value.
>>> +#
>>> +# @max: the highest supported value.
>>> +#
>>> +# Since: 11.2
>>> +##
>>> +{ 'struct': 'CpuPropertyValueRange',
>>> +  'data': { 'min': 'uint64', 'max': 'uint64' } }
>>> +
>>> +##
>>> +# @CpuPropertyInfoBoolean:
>>> +#
>>> +# @supported-values: list of boolean values supported for the
>>> +#     property.
>>> +#
>>> +# Since: 11.2
>>> +##
>>> +{ 'struct': 'CpuPropertyInfoBoolean',
>>> +  'data': { 'supported-values': ['bool'] } }
>> why can't you model that with a range too?
> I’m sorry I didn’t get you.

I meant I don't really understand why we need to bother about boolean
props and why we don't just model everything with list of uint64 ranges.
I was puzzled by "list of boolean values supported for the property" Eric
>
> Thanks,
> Khushit
>>> +
>>> +##
>>> +# @CpuPropertyInfoNumber:
>>> +#
>>> +# @supported-values: list of numeric value ranges supported
>>> +#     for the property.
>>> +#
>>> +# Since: 11.2
>>> +##
>>> +{ 'struct': 'CpuPropertyInfoNumber',
>>> +  'data': { 'supported-values': ['CpuPropertyValueRange'] } }
>>> +
>>> +##
>>> +# @CpuPropertyInfo:
>>> +#
>>> +# Information about a single CPU model property, including the values
>>> +# the host/accelerator supports for it.
>>> +#
>>> +# @name: the name of the property.
>>> +#
>>> +# @type: the type of the property, which selects the layout of
>>> +#     @supported-values.
>>> +#
>>> +# Since: 11.2
>>> +##
>>> +{ 'union': 'CpuPropertyInfo',
>>> +  'base': { 'name': 'str',
>>> +            'type': 'CpuPropertyType' },
>>> +  'discriminator': 'type',
>>> +  'data': { 'boolean': 'CpuPropertyInfoBoolean',
>>> +            'number': 'CpuPropertyInfoNumber' } }
>>> +
>>> +##
>>> +# @query-cpu-props-info:
>>> +#
>>> +# Return information about the CPU model properties.  For each
>>> +# property it reports the values supported under the active
>>> +# accelerator and host.
>>> +#
>>> +# Since: 11.2
>>> +##
>>> +{ 'command': 'query-cpu-props-info',
>>> +  'returns': ['CpuPropertyInfo'] }
>>> diff --git a/stubs/meson.build b/stubs/meson.build
>>> index 3b2f2680b1..3bb4028bab 100644
>>> --- a/stubs/meson.build
>>> +++ b/stubs/meson.build
>>> @@ -83,6 +83,7 @@ if have_system
>>>   stub_ss.add(files('qmp-i386-sgx.c'))
>>>   stub_ss.add(files('qmp-i386-xen.c'))
>>>   stub_ss.add(files('qmp-cpu.c'))
>>> +  stub_ss.add(files('qmp-cpu-props-info.c'))
>>>   stub_ss.add(files('qmp-cpu-s390x.c'))
>>>   stub_ss.add(files('qmp-cpu-s390x-kvm.c'))
>>>   stub_ss.add(files('hmp-cmd-info_mem.c'))
>>> diff --git a/stubs/qmp-cpu-props-info.c b/stubs/qmp-cpu-props-info.c
>>> new file mode 100644
>>> index 0000000000..36b0530b98
>>> --- /dev/null
>>> +++ b/stubs/qmp-cpu-props-info.c
>>> @@ -0,0 +1,12 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>>> +
>>> +#include "qemu/osdep.h"
>>> +#include "qapi/error.h"
>>> +#include "qapi/qapi-commands-machine.h"
>>> +
>>> +CpuPropertyInfoList *
>>> +qmp_query_cpu_props_info(Error **errp)
>>> +{
>>> +    error_setg(errp, "query-cpu-props-info not supported on this target");
>>> +    return NULL;
>>> +}
>>> diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
>>> index 279a8f5614..2c25dbd8cb 100644
>>> --- a/tests/qtest/qmp-cmd-test.c
>>> +++ b/tests/qtest/qmp-cmd-test.c
>>> @@ -100,6 +100,7 @@ static bool query_is_ignored(const char *cmd)
>>>         "add-fd",
>>>         /* Success depends on target arch: */
>>>         "query-cpu-definitions",  /* arm, i386, ppc, s390x */
>>> +        "query-cpu-props-info", /* arm + kvm */
>>>         "query-gic-capabilities", /* arm */
>>>         "query-s390x-cpu-polarization", /* s390x */
>>>         /* Success depends on target-specific build configuration: */
>> Thanks
>>
>> Eric
>

