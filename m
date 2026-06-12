Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759363DEAE4
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781249915; cv=none; b=KV8a04r7288NQWvTydP4iWjzNAYEeEyk25PUevk2LNpmO+qOMsgFLMfkL+J6uwXKxznWXbn2x/YJn5iTE8kgmNnYJ32K2ld9+p8dcGHmgrFuX/KJYR5+XWO2taPAB21Es+jaLuLixvHSM+TXuscoM5Rqe6QLzHL6B4yhBjV/c5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781249915; c=relaxed/simple;
	bh=eLHYaD3aabJYgk6mZSNoqgNzVMTl3beyvXF39qeuuQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LirCioFHE08cqlVNfCzaks2al0sPVZ3N0f9z+tbiqJOFxx07zpgYKTXdf1iiAjHsNvfe0xiS2PpdQmng8gFLxRGt0+FOaEyuNfGMhr98IYf4qiudO5DSYONSzp2jrEFXgEHY1isQdGMXHQZImV+Ovogd4mpbef/Y02xgmiGcrsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B6QzWegT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6QzWegT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781249911;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36OuNx9nK8T/nKzXs0flx3BkMIs014GXg11EFPwESHM=;
	b=B6QzWegTPurpDZMys4sTVu3AaTCLsROrNSz98JZEXfCeFJfZs6CFCRDEVECwBz8JmcJaCA
	CbMt+/LqAPN68qxznPUF/DchYszDeRGlyY6RFDYlEURoduywJ1zbrFz/pdwEq3GFJDzvjY
	pMZeKKHOrDI5dydrIQncgSOk80k4Uew=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-8Z1OdmCBOSGCNO_ovBUvvw-1; Fri, 12 Jun 2026 03:38:29 -0400
X-MC-Unique: 8Z1OdmCBOSGCNO_ovBUvvw-1
X-Mimecast-MFC-AGG-ID: 8Z1OdmCBOSGCNO_ovBUvvw_1781249908
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45f3d008865so516695f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 00:38:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781249908; x=1781854708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=36OuNx9nK8T/nKzXs0flx3BkMIs014GXg11EFPwESHM=;
        b=VBkrXbY9mZ2wlKIHOQ8vyjKVpbAJaX96DHPrQ0LqxUj19imhwC474OYngRWcGXyI64
         Y8UAqdgj3rE3zUN0M99OD60JkYMK0E5mtb+sI+HFdk9e2ml6lYI1Cy1N2vsY08vIAC6I
         zWvcncgB0+MTrHv0OQkSBELGSYJmdCcrtIOG5sf98jDAhxZNtGuV/caGAT+oa7yB3I1a
         NvUO+jDcmd/k0cxU9AAS/QO8R4ZuEWTDvaCkL2NqkflE8v1epB24wbfalrOqtBdxnFuB
         +0bzQwgEqr1/gsT5GatMyPFuCKX+SNdjRbpn7jssCNgSlBFtivwYIQZz+OsPzoqgcXDy
         8ITQ==
X-Forwarded-Encrypted: i=1; AFNElJ8B89TOXVnamjCVq20Xc92h91xDKA0NF7YB6CkpouQl0GkXgfW0y2v93SDku5A2d8MtHrWfyMU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIBnC/OAq531W18NMW6RTvooR8P7S1Xg1tnx41GhMlrc2qp08X
	9vcjYupG0CF92x7Va8CMKLUAbtEI/p/J2WRaKEuOfKD4bWm+M6/HCsM1gWJUbMcPpC0FrXHw8Xf
	GRsjADQg5lW1b9wWJJJw/AQ/Q+C/MOpAuUp7T0UJcX/WCsUOOJG0Yi8Wjrw==
X-Gm-Gg: Acq92OG9wWPpzn5hJgIZXNLdCoxtb4xbFkYLLqPIvG5ZrLqe6niXpSp+vOX3LMXyO4v
	j5sUCOsf78gyLs5UZRNboWNiZX1Xn5YtFrNGvmYQnG72EXDSI21HNXrpnQY3mwGrHTJF8PHZ/ys
	u2xy6hX8G1+lpijgay4erqjUA7K58FTd1at9ImJ/hlM1KhzD6yfkjIdoIfzkOIP8J1Y11o4d2bh
	sQdovp2BL1dRO8a5S5JVDJ4twhP19ukjWMnRalRUHepbrubTpsoV4qnk/Jd3WQrIq1v1ugynKno
	piuFcHoqVpb03yMv1HxwTDxYrqW/B1inQXB4POiuGfYArZd6Xboe0tpd6uicgd8H4oogBtYF0Yq
	sq0odMM0i4oKsbFT2PfwdrNq9UdkJhoD9aCKEaOBafWWz0L83UdFKXjAK85cq5297t5Mzfw==
X-Received: by 2002:a05:6000:2586:b0:460:684d:d565 with SMTP id ffacd0b85a97d-4606f255ab8mr1753985f8f.15.1781249907936;
        Fri, 12 Jun 2026 00:38:27 -0700 (PDT)
X-Received: by 2002:a05:6000:2586:b0:460:684d:d565 with SMTP id ffacd0b85a97d-4606f255ab8mr1753954f8f.15.1781249907598;
        Fri, 12 Jun 2026 00:38:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f726sm3028887f8f.15.2026.06.12.00.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 00:38:26 -0700 (PDT)
Message-ID: <51ba045f-6ecf-4703-92c6-f362724c408e@redhat.com>
Date: Fri, 12 Jun 2026 09:38:25 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>,
 "khushit.shah@nutanix.com" <khushit.shah@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-5-eric.auger@redhat.com>
 <CH3PR12MB7548D1CA4348E04A14725645AB152@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB7548D1CA4348E04A14725645AB152@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gr68Ux6xXD-F6MhCX2OwHquTVGFuj0WG1XS6HYUc_oQ_1781249908
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shameer,

On 6/1/26 4:28 PM, Shameer Kolothum Thodi wrote:
> Hi Eric,
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 19 May 2026 14:27
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; shaju.abraham@nutanix.com;
>> khushit.shah@nutanix.com; yangjinqian1@huawei.com;
>> cohuck@redhat.com; richard.henderson@linaro.org; sebott@redhat.com;
>> Shameer Kolothum Thodi <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID register
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
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>> ---
>>
>> v4 -> v5
>> - ifdef TARGET_ARM_CPU_IDREGS_H
>> - s/g_list_append/g_list_prepend
>> - void arm64_sysreg_add_field()

Effectively the whole commit desc is outdated now that I have migrated
to Khushit description of idregs and their fields. No need for list nor 

arm64_sysreg_add_field anymore.

Arrays are populated in [PATCH v5 08/18] target/arm/cpu_idregs: generate tables for Arm64 ID registers and fields
This is much nicer.

Thanks

Eric

> Looks like this patch is missing the above and file:
> target/arm/cpu-sysreg-properties.c
>
> Please check.
>
> Thanks,
> Shameer
>
>> ---
>>  target/arm/cpu-idregs.h | 33 +++++++++++++++++++++++++++++++++
>>  1 file changed, 33 insertions(+)
>>  create mode 100644 target/arm/cpu-idregs.h
>>
>> diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
>> new file mode 100644
>> index 0000000000..664e2d6ddd
>> --- /dev/null
>> +++ b/target/arm/cpu-idregs.h
>> @@ -0,0 +1,33 @@
>> +/*
>> + * handle ID registers and their fields
>> + *
>> + * SPDX-License-Identifier: GPL-2.0-or-later
>> + */
>> +#ifndef TARGET_ARM_CPU_IDREGS_H
>> +#define TARGET_ARM_CPU_IDREGS_H
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/error-report.h"
>> +#include "cpu.h"
>> +#include "cpu-sysregs.h"
>> +
>> +typedef struct ARM64SysRegField {
>> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
>> +    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
>> +    int shift; /* lsb of the field in the register */
>> +    int length; /* highest bit number */
>> +} ARM64SysRegField;
>> +
>> +typedef struct ARM64SysReg {
>> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
>> +    ARMIDRegisterIdx index; /* register index, e.g. CTR_EL0_IDX */
>> +    struct ARM64SysRegField *fields;
>> +    uint32_t fields_count;
>> +} ARM64SysReg;
>> +
>> +/*
>> + * List of exposed ID regs (automatically populated from AARCHMRS
>> Registers.json)
>> + */
>> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>> +
>> +#endif
>> --
>> 2.53.0

