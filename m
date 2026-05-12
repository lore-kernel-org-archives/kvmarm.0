Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0583672BC
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 06:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778567960; cv=none; b=of0aHo+L/aRtAuLX9aUvVjKl8fE/NrtgjC875v/5WoOXJ2MsQDeuROv5sLv97EqshpFonAw8WTY+bAKb6G0zPnFB5jAuXhe9F0mrKqc3hGWsuxZ0dIp9jNDUZ+05qzdPzUnAFAze+sOlOhoHImFosp8SGNPD3phtFueZa/hVgzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778567960; c=relaxed/simple;
	bh=AaF7Pg49ZtOu/qWrq8MAFB6/VISZqWhNUbuQ8l0sY4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UfEpcU05wBkasa3J4D3p/XVyWCirfbvbBC/hKowD33lHEGBc2aLUBNiIDm7EabA7URhIKNC5EWxdFnVkLXuiG06OcztOU+kP8j/g78cY2ukteeesjDp60qN9Pe9kN+4hQt8kqoxqFlttCkrFb8m09pKWCpPy3qWS+1OJJKon7B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cLYwxtUP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cLYwxtUP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778567944;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NoVJ+c/uz80TrOdip6QXqOUN43LCIvcXnIK/rRMfnkc=;
	b=cLYwxtUP/ZfIsM6IyKDBHYiUNg0vS4M19qMqzaLPwNSWL7Lh79DZvHf0FCxMXditTwPB8s
	DR4qNR5FKCK9Nobb8U0z+JDoTo5R2wKwz82Ilk3eV0dnRgbGaW5bsBVeRQEjXu4dF5NnrM
	DDZJHMoEZTITli39ZH++95yuHH4h6hs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-OcN-N_LFMGiKn0ObpW95yA-1; Tue, 12 May 2026 02:39:03 -0400
X-MC-Unique: OcN-N_LFMGiKn0ObpW95yA-1
X-Mimecast-MFC-AGG-ID: OcN-N_LFMGiKn0ObpW95yA_1778567941
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4518f777225so3244022f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 23:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778567941; x=1779172741;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NoVJ+c/uz80TrOdip6QXqOUN43LCIvcXnIK/rRMfnkc=;
        b=S42H7lB7HBqpqf7wQXxE+3R6BIz79WaN7kCFAHPBfy2U/Q/pqKbd4vdNdaXDAOlMiK
         J/r5fh+SV/TM9JKD1LA+ZQ+HU4pTXhgCQtfSxpb9mvAwtZ0LTWrrLjDRSFlbdvsxVERC
         S29aNiv+SwNnIiGEviXkMHHHBtAewL8o0fl0u1UJ36keWjxS9Odwe6cDahJb4Yy/Xt5F
         Vg9w+LDmCVjr+tsDsh/nPiGNNv/Vt9zlbURTM5jw0SVbfLy6jJe8iYD52OvbYU6u574H
         2KyRI9QptdMPGwCZ3FdPsk2tsX6V/v0JDCHvBpa6RbSPQPDH0xDiLFB6Qb81ZOYPulMA
         JO3g==
X-Forwarded-Encrypted: i=1; AFNElJ/CFuTiAa2l89GczdiV8DYQDrURtLKs4lJgRHLe/lVoW/fck/Cyot3rqpK0UO5QvzaNJTGAaak=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPH39TSSprGqOa7+bq/u6pMYpH8k8rXMq828qkR2Ie4q5KkOKV
	SiSXJ38v4IM/FJ+S75ydtPQp1+VWzTWji60kBQp/qDthhdFQk7jWlnJSy7qkKTzflfr5Rp/Elqv
	EBrXI2ORho7cNb/ymdLtNZBbkj3WdHPy53vPWBAQqrA1w9M6anj+ErqjQNg==
X-Gm-Gg: Acq92OECFJJbMC6rSYSfP4Z2mg23DquWaDYnG7SdR4DlMVN/yk93GlEaGgVrqLXszzc
	TEXpTWxrSa/QkS5pB4Cml6FoZqXB6g/5JAxp5U+8JyNMbGtoifC79MWDBIK9VxYNFBux3hMLfe1
	voR1/P56xum/s50Cgc+VJ1Mx/luB32yFwffFXsCmYmcEf7tJLnR8p+tZ8zldk96rtljyqsLn6xD
	lz5N1vm4T/AUj8DTN0pPSRYN8xTJCnHe83ro7s0qtS15L0xEZJNWxR6Fr+eRTVmSssw1PuYtWIr
	Gh7XM0Mz7ZxpKeuoqqKwQFib1+zN4Po3EeNrA00yyMUsyHNz5KAK3coy2q1m8mLRna9kalr+K+P
	Ll0ObwR7x08gZk9/n3xkZn7E3ZMpcN7oZfGFgNCwLYug3reg1UONq199LGhiyOlUsABtNSw==
X-Received: by 2002:a05:600c:c058:b0:48e:6db3:ff33 with SMTP id 5b1f17b1804b1-48e6db40058mr168505705e9.14.1778567941134;
        Mon, 11 May 2026 23:39:01 -0700 (PDT)
X-Received: by 2002:a05:600c:c058:b0:48e:6db3:ff33 with SMTP id 5b1f17b1804b1-48e6db40058mr168505275e9.14.1778567940725;
        Mon, 11 May 2026 23:39:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a5b65sm31614561f8f.8.2026.05.11.23.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 23:39:00 -0700 (PDT)
Message-ID: <c7bfd8f7-3e3f-49fe-a8f4-ac0212a1762b@redhat.com>
Date: Tue, 12 May 2026 08:38:58 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-4-eric.auger@redhat.com>
 <CH3PR12MB7548C2AB4989FEF96C247D47AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB7548C2AB4989FEF96C247D47AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5L4RgsKQX00GJc0MEUl6RxLNx1nkx4yf5SsnQ769Fus_1778567941
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shameer,

On 5/7/26 10:45 AM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:33
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with
>> automatic generation
>>
>> External email: Use caution opening links or attachments
>>
>>
>> Generated definitions with scripts/update-aarch64-cpu-sysregs-header.py
>> based on "AARCHMRS containing the JSON files for Arm A-profile
>> architecture (2026-03)" Registers.json file.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Message-ID: <20251208163751.611186-4-eric.auger@redhat.com>
>> ---
>>  target/arm/cpu-sysregs.h.inc | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
>> index d61f0d0a19..2188cd7be0 100644
>> --- a/target/arm/cpu-sysregs.h.inc
>> +++ b/target/arm/cpu-sysregs.h.inc
>> @@ -1,15 +1,25 @@
>>  /* SPDX-License-Identifier: GPL-2.0-or-later */
>> +
>> +/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-
>> header.py */
>> +/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
>> +
>> +DEF(AIDR_EL1, 3, 1, 0, 0, 7)
>> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
>>  DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
>>  DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>>  DEF(CTR_EL0, 3, 3, 0, 0, 1)
>>  DEF(DCZID_EL0, 3, 3, 0, 0, 7)
>> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
>>  DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
>>  DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
>>  DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
>>  DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
>> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
>> +DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
>>  DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
>>  DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
>>  DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
>> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
>>  DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
>>  DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
>>  DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
>> @@ -39,6 +49,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
>>  DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
>>  DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
>>  DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
>> +DEF(MIDR_EL1, 3, 0, 0, 0, 0)
>> +DEF(MPIDR_EL1, 3, 0, 0, 0, 5)
> Do we need MPIDR_EL1 as well? Is this considered as a feature ID
> register and is writable? I don't think so.
MPIDR_EL1 is part of the ID regs range defined in the kernel doc

op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

That's why the python script extracts it. Effectively it is not writable yet.

I can exclude it from the automatic generation but do we really need to? Any specific reason?

Thanks

Eric


> Thanks,
> Shameer
>
>>  DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
>>  DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
>>  DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
>> +DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
>> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
>> --
>> 2.53.0

