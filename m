Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2A4312831
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666914; cv=none; b=Y2w09m9XnkMLapjqmKOijuCflJY0YC0YTiLLynD8g5V1X3ww0J/tLOUAWsGbml5oT6F1M9s/NLS7BqSMS9x3+xEDAL6DkTPavCJHuitC+PbjzP6AKJhITq7pLJr4yejzPFe859sK+ZtuMv6ooDi2msH9yQgknIsq0K5oPlVsa/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666914; c=relaxed/simple;
	bh=eRyCAnTvCytxzxDV4hPXBI+Jj6EN2uKgvrTbE+uDtfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oxhsQqlGxNsPPnqrWi8/4TjKUDmR8y7MCYXEhLmR5yHcFEmmcu53QnX7qEyRyZ7psVhHzVTIuxdzOYYYmU0UvU53o/yFidzY0x4CdZ/KSLZaHb/uVn4ITFtTml6XTH+l7C+GnbypTxgaaca5EBtF4FZE6c8wJaupCa8ndi+CDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eouqqe9j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eouqqe9j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787666910;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWZ36ssQuMggl10NX4pB67A6/gc4A8ViF4utTFslLtk=;
	b=Eouqqe9jqLRRntTeMu3WP2o0mJ5evn5Qqo5cWUKUUYG3z7tQTlB26hCbj0weGV78ZXh8XE
	F+lnodPwD2+pwuscodCpmVHgHl+gL0JJznbNCvDn0y+8ER17HtXoDdVeWdA3nieTj9queq
	CvKAyhRpqJfz8GXHMOa1RD7SA7873Lc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-a7e8G2azP7Co85ZLQXoL_A-1; Tue, 25 Aug 2026 10:08:29 -0400
X-MC-Unique: a7e8G2azP7Co85ZLQXoL_A-1
X-Mimecast-MFC-AGG-ID: a7e8G2azP7Co85ZLQXoL_A_1787666908
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15f0aea084so145997366b.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 07:08:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666908; x=1788271708;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RWZ36ssQuMggl10NX4pB67A6/gc4A8ViF4utTFslLtk=;
        b=aRdqIn7TgTPgTnF8opg+QoKEBJT+md9B3XPc69xr4tFyUCyGPIb8gEGKR9WW+X31jO
         a240o4jUI87Mxs9ppcLTlzOuGhBdMlm5A4m//qnzbGVcz+LGCrRh+yu//NwU26o93l84
         jD5GUoxBuvGP4NCpEanWEPPFiLnqxyLA5vvI1TJbyhhiUAApMIYOC6W5HlAFSid5gabI
         HKTXcU1Yrk04jeofvJnwDkhS5QPz6qcXEuJtf7YaOHqVrtJYjAFAD9EUYQLe3Sgx/vVH
         btL8dKs8dQUdoByd26WV8iYePW6N/yEcfbc8G0xCo6bPZzENMvvIgMHId+z6ZED4+Akd
         p4KQ==
X-Forwarded-Encrypted: i=1; AHgh+RonDjCbXkzRamgiym/8ndmhSgoSK0CUmfewT0PbuMeTitd1nTGhBd3gw2p2nUKYTIPHR+Ffi8Y=@lists.linux.dev
X-Gm-Message-State: AFuF++nZjmov1Yt1oKmJbjQDfuxkDzUkEo6Mo+mGSljVER80uHOp8ZhT
	xtMZ6WHzkMJnZl/Tli23yA/cryBztkeax6uZmyCypEJ3YB+q8usYTBPR8xIs0ng51zKzZWxmA+1
	D3wiesX2Mu3uVAQCCzCmTjFsDs0I3kFNCuBhMAEZ91d9L69yI/B14PyG0nQ==
X-Gm-Gg: AR+sD10R2UkuRPCIdgczdQvuLC5gJ0s2Ay+lQ3OSGJ2+YCF6ewyKNSjUU6OqFobFUYV
	/mcghtRJBalxE7fVBaHO7XMAjWGCzjJg8LQYu16lQbqId1vXPAgPhKbzcz1lE/LJjEwKDTQ9q6M
	KT2zs8AY3DC0ZYJ04wC7pOrhMSvJB8cGlv+HDwR+s1UcxPzPERzRPFZX17fJDii2YW7ByotG6bO
	PJoGJNP2MSJ3xB2el2gMXcJABkqh55MXSJMBaxUG9qcBl5zN4Fuxn4D6/FdccUMzHpIXGEU/Zep
	J7Gf8IUOiOu+wMbF8Or6vSLgU5OwZLTcnIT7Zyr3tp2wwr1b6OYRxY/KPCRwi25Noxiw+PqnczX
	V9RZhSiGdzFl6vRrHaXb2nzBx+9SoEw+JhQxhJ/WlL6j2WyyD
X-Received: by 2002:a17:907:8990:b0:c20:3679:a2e6 with SMTP id a640c23a62f3a-c24925eb3ffmr3225006066b.10.1787666907617;
        Tue, 25 Aug 2026 07:08:27 -0700 (PDT)
X-Received: by 2002:a17:907:8990:b0:c20:3679:a2e6 with SMTP id a640c23a62f3a-c24925eb3ffmr3224991966b.10.1787666906874;
        Tue, 25 Aug 2026 07:08:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606b161sm1933953266b.11.2026.08.25.07.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 07:08:25 -0700 (PDT)
Message-ID: <09b39de5-b0ae-40ec-9977-00fefa59561f@redhat.com>
Date: Tue, 25 Aug 2026 16:08:23 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v7 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
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
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-5-eric.auger@redhat.com>
 <557850AC-880C-4A6D-AA7A-7A0F38B3C9CD@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <557850AC-880C-4A6D-AA7A-7A0F38B3C9CD@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RncY1_KnoqwxgiVS3NxS1ips62vyd8CuSNbHCEowols_1787666908
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 8/20/26 8:35 AM, Khushit Shah wrote:
>
>> On 26 Jul 2026, at 8:59 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Introduce an infrastructure to store the definition of all ID regs:
>> This include their name, index and array of named fields.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
>>
>> ---
>>
>> v5 -> v6:
>> - add ArmIdRegArchVal
>> ---
>> target/arm/cpu-idregs.h | 41 +++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 41 insertions(+)
>> create mode 100644 target/arm/cpu-idregs.h
>>
>> diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
>> new file mode 100644
>> index 0000000000..245f1c8103
>> --- /dev/null
>> +++ b/target/arm/cpu-idregs.h
>> @@ -0,0 +1,41 @@
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
>> +typedef struct ArmIdRegArchVal {
>> +    uint64_t value;
>> +    const char *name;
> I guess the name is not required, right?

indeed, this is not required. Removed and used uint64_t in place of 

typedef struct ArmIdRegArchVal in subsequent patches.

Thanks!

Eric

>
>> +} ArmIdRegArchVal;
>> +
>> +typedef struct ARM64SysRegField {
>> +    const char *name; /* name of the field, for instance CTR_EL0_IDC */
>> +    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
>> +    int shift; /* lsb of the field in the register */
>> +    int length; /* highest bit number */
>> +    ArmIdRegArchVal *arch_vals;
>> +    uint32_t arch_vals_count;
>> +} ARM64SysRegField;
>> +
>> +typedef struct ARM64SysReg {
>> +    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
>> +    ARMIDRegisterIdx index; /* register index, e.g. CTR_EL0_IDX */
>> +    struct ARM64SysRegField *fields;
>> +    uint32_t fields_count;
>> +    uint64_t writable_mask;
>> +} ARM64SysReg;
>> +
>> +/*
>> + * List of exposed ID regs (automatically populated from AARCHMRS Registers.json)
>> + */
>> +extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
>> +
>> +#endif
>> -- 
>> 2.53.0
>>

