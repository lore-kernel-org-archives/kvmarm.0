Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE3D3CE4B2
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894858; cv=none; b=rfWXGegN1EBJuAVmTbNLm1j5O1Wr8PTXGiGZ1bJo/B5Iuyccivj85RRLdY6R8Wo5P4x0wCU+rhUnjNGqpnjsyHWglbaUY5Tx6QtIZoRbBHnaTdN775UYW2D+0wuikMqAAyeCkMTKbvnvMjTwynnEMpW1MSGP9uMLrZm+/lfmBDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894858; c=relaxed/simple;
	bh=51hWyjc4+NxntmbLHLHBPkWJjuuxkFQn1FjbGOX0oG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rp4SdttHDs5M5BS9ZswjmxDu96LCTIPQJ4bKaQJpv06ghjkKz8rvKU20Q8VOAK3ayStkQlAmlQ+lfBT4F86EEx2NUZqbiux2wIwaoUuDjN0aBI73qwG4pGGB7IFzCFAvLuVqurDv9CMUVajLQYwlJhRdXmy9TJvnvbfs6svo2po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MiN/eaBq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MiN/eaBq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779894856;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YHNZso132dglP2payHGFSmMwbdloulfUIzdNpbPvJbc=;
	b=MiN/eaBqVkI18+oHWCqt6/LzVLWEsqHvAsji+wfymYI4Knu2/G6G/zKdUHZ0XiM5GLpxCg
	g19R/kf562vNNT6XVtrCyAKF5f/0n8mCbeIM92O60Pol5lM1uVzIp4w3vntUSmlDU75Jzb
	CSYpGhkbeXd1ZM3xzOMmk/k1KE6oseg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-i94gvooGO_yrmhQb24lVpQ-1; Wed, 27 May 2026 11:14:14 -0400
X-MC-Unique: i94gvooGO_yrmhQb24lVpQ-1
X-Mimecast-MFC-AGG-ID: i94gvooGO_yrmhQb24lVpQ_1779894853
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49081106196so9058805e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894853; x=1780499653;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHNZso132dglP2payHGFSmMwbdloulfUIzdNpbPvJbc=;
        b=NOyeUucTno+kUNGe27IbRW56ffBHaer/8P9Ijxyfj+RqHy8dAHukOh2VQKTd57Vq27
         zoXHfXOp92rvhHbG+U/3Bq2JdzvOYPs7FbLbQSAEl1/NzMjRbGkr1Ol8zw5gWgBNtoC0
         dUUBDrOZnR2JJOd0sFBEKYXNDDas6VWpv7S/EiyI64s/s43mMKTymuvwYLblNTfQbNrQ
         6/xJnjgSX6+IJ58jnkhn3A/FM7r84xTjNSkIAu0uSlSDisv4jBeE/ib0dqaypfj178+I
         QtQlJgTmC7AuePllVVO5yHU6tuztx7KLkE//Nw5wdbgv5qHHReupxv+pLhTDReXYcCax
         7NTg==
X-Forwarded-Encrypted: i=1; AFNElJ9Olj6BN4tuQ1LCv/pxXeYHwa5FvznhuqQavgTkUI3NyB3LxTPItDYUaeKTSvCIBa7HuuUlM2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHDlp9alECgzF/aLs1kmDSQaB9gxu+rh4vj51ygrVS1nO6eXS4
	B4kdF1ex3xVihTVLSz7IQG1aD/zqM34d68d2Q/v736wjWlC7MHaGM1WroMRZLQijedx3H84z7v9
	Q3ECfT6x8NcErPkphNYvKTdESFcv8JkJd9ppKwSNwhFzh5Uj2KuekpMMl3Q==
X-Gm-Gg: Acq92OEASqUoYvQWbdVniQs7UhYx3u2dEdFQ5u4Sm3aN0qAkSXUuS4jvUb8BSsjjHDP
	2WOYpNyjSqN/nsqXJDsLfty6ke0zo289U+u1IxXkSzP1JOsQ862ChlpDA7MKDwV6aOWRqHUOr58
	Q7X6YLnzCJdX55zwtpzxMpLz0cfzvoBWwynImS+Nei1jw2paCvVVSM5xdDsZuX/6mdnKSCT0y8n
	lfngTnFVRNSHIrUAO/v+KrPx0eCw1GnkkUWROo9rRrtFphdfl6J5rIxV/monFtWU4XfDPwXAIOz
	PipiKx9Aaa/UsfEZtkn2Oa1GBJeIoyNnE5UJov/YvrPEq2Ns6wcOq+lOurYL5kOTkioVD0yj558
	lqPOe7edeYgjB2NLwC3gNIRCPwfJol8B89xeCULI9qweYL71ke9oRqWKzFgprposU8+1gAotEBO
	k+mqO/
X-Received: by 2002:a05:600c:3b02:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-490424b2cf1mr398245395e9.12.1779894853271;
        Wed, 27 May 2026 08:14:13 -0700 (PDT)
X-Received: by 2002:a05:600c:3b02:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-490424b2cf1mr398244605e9.12.1779894852820;
        Wed, 27 May 2026 08:14:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904561a198sm393501675e9.10.2026.05.27.08.14.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 08:14:12 -0700 (PDT)
Message-ID: <35a3fb6f-cb9a-4d47-af6c-1b9c23a6a66b@redhat.com>
Date: Wed, 27 May 2026 17:14:10 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 08/18] target/arm/cpu_idregs: generate tables for Arm64
 ID registers and fields
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
 <20260519132905.145643-9-eric.auger@redhat.com>
 <E6706A9A-B0E0-4A1B-B7E9-8A0BF73A1170@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <E6706A9A-B0E0-4A1B-B7E9-8A0BF73A1170@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rnP0PApF793FZa7W-bj9Q8wPadg7lJGANPbIo9qiyOE_1779894853
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 4:52 PM, Khushit Shah wrote:
>
>> On 19 May 2026, at 6:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> From: Shaju Abraham <shaju.abraham@nutanix.com>
>>
>> Include cpu-idregs.h.inc multiple times with different definitions for the
>> X-macros. This will generate tables for all Arm64 ID registers and their
>> fields. Additionally, initialize the tables with all architecturally defined
>> values. These tables will be consumed by the property layer in future
>> patches.
>>
>> Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
>> Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>> target/arm/cpu-idregs.c | 50 +++++++++++++++++++++++++++++++++++++++++
>> target/arm/meson.build  |  1 +
>> 2 files changed, 51 insertions(+)
>> create mode 100644 target/arm/cpu-idregs.c
>>
>> diff --git a/target/arm/cpu-idregs.c b/target/arm/cpu-idregs.c
>> new file mode 100644
>> index 0000000000..f79b22680c
>> --- /dev/null
>> +++ b/target/arm/cpu-idregs.c
>> @@ -0,0 +1,50 @@
>> +/*
>> + *   ARM ID register field table.
>> + *
>> + *   Builds the per-id-register field descriptor arrays and the global
>> + *   arm_idregs[] table.
>> + *
>> + *  SPDX-License-Identifier: GPL-2.0-or-later
>> + */
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "qapi/error.h"
>> +#include "cpu.h"
>> +#include "cpu-idregs.h"
>> +
>> +#define IDREG_START(reg) \
>> +    static ARM64SysRegField reg##_fields[] = {
>> +
>> +#define IDREG_END(reg) \
>> +    };
>> +
>> +#define IDREG_FIELD(reg, field, _shift, _length) \
>> +    { \
>> +        .name = #field, \
>> +        .index = reg##_IDX, \
>> +        .shift = (_shift), \
>> +        .length = (_length), \
>> +    },
>> +#include "cpu-idregs.h.inc"
>> +#undef IDREG_START
>> +#undef IDREG_END
>> +#undef IDREG_FIELD
>> +
>> +/* generate an array of top level ID registers */
>> +#define IDREG_END(reg)
>> +#define IDREG_FIELD(reg, field, shift, length)
>> +
>> +#define IDREG_START(reg) \
>> +    [reg##_IDX] = { \
>> +        .name = #reg, \
>> +        .index = reg##_IDX, \
>> +        .fields = reg##_fields, \
>> +        .fields_count = ARRAY_SIZE(reg##_fields), \
>> +    },
>> +
>> +ARM64SysReg arm64_id_regs[NUM_ID_IDX] = {
>> +#include "cpu-idregs.h.inc"
>> +};
>> +#undef IDREG_START
>> +#undef IDREG_END
>> +#undef IDREG_FIELD
>> diff --git a/target/arm/meson.build b/target/arm/meson.build
>> index 4723f9f170..64d1ec63ab 100644
>> --- a/target/arm/meson.build
>> +++ b/target/arm/meson.build
>> @@ -19,6 +19,7 @@ arm_common_ss.add(files(
>>
>> arm_common_system_ss.add(files(
>>   'arm-qmp-cmds.c',
>> +  'cpu-idregs.c',
>> ))
>> arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
>> arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
>> -- 
>> 2.53.0
>>
> We can also store writable_masks here. writable_mask exposed by KVM is
> static. It does not change in any configuration hence can be fetched once 
> during scratch vCPU creation

I agree. Nevertheless when using the KVM API we need an array to store
the bitmasks anyway. That's why I initially saved it in the CPU state.
We can copy the bitmask to each id reg struct though

Eric
>
> Warm Regards,
> Khushit

