Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FAF22370C
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025579; cv=none; b=EurJTnY9MsNxgYskIOYN5yn6m8bR750rTWlnbFHfeyCqNPzd5QxtivnOI5rSg7A1RH33c289BAwqau4jKw4iC4BnsRCgZWcYB6kLlvaLZxIVz3ooXLYBCMT4eWaEQjy+kyaek2v0jr7kRXK7MuoU2qJtlWRkLwfD4vSxMpEdjo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025579; c=relaxed/simple;
	bh=yBznrJE56VRWhrBvxk3/sZkoRE2CzrKK9JIJqvtRp14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ThT+7zpjiYIiF6Gs2z9ON3gyWq00tv2fgr8Y66yOirhdnIpo2/reuge/iZN9ShVjz+FZQ28yQU/VoK68IsP4YEpPG06amlCOSixIy0ibN5Jv5hCj6Zpt4ZdepA6Je7NFcs2V6dqmDt+64OrRvYTYXR/zo2k7quBJXVYz0whx84o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GLLVdX+n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GLLVdX+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734025575;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yBznrJE56VRWhrBvxk3/sZkoRE2CzrKK9JIJqvtRp14=;
	b=GLLVdX+nrfzWjWkfYrgi3h/7m0U8Y4IoxQyZPqFTE1mwdeqZ4Iinq1cP8X64rC6+jjwIER
	fwVbkVsHZGf/yqiUtfWZDFbUqizayb8LfF0ZOWMjP/7df4Tg1Nu0IzYkrOYQFZrnLdLrFR
	8kPBFB0se7lXpEqwBYDWx479WpER+Jw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-bXWYHW6DNiGex-VE02dERA-1; Thu, 12 Dec 2024 12:46:14 -0500
X-MC-Unique: bXWYHW6DNiGex-VE02dERA-1
X-Mimecast-MFC-AGG-ID: bXWYHW6DNiGex-VE02dERA
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-46775c891d2so27871581cf.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 09:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734025574; x=1734630374;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yBznrJE56VRWhrBvxk3/sZkoRE2CzrKK9JIJqvtRp14=;
        b=oVoHxlqJKxHt3YWnI56tBXsQyjSmvHfvGm5XuphhJiE6wCh2G6DSfmMmFq6lHuEOCi
         jZcrZrt2IEU7k9ykNYfBw84HhlP89DxT/umpoqkQbeBJXCgMnCzHDgWJbPH1wsfoFpQB
         DKNDdjfO87Tz3+XSipe1I9FA3x4wfg42nUPTjuYmkp+vxywuQ8HmhgeLAwXXirBy1Ua9
         WdH6z3DwcqJItxSkc7h86TnWnFLi94yw7zlf8bxs9X6TpncMg5vYFnVwACT7qzskY0GB
         lZKvYIER36yiAk6XUhmwt+G2PVzRvra8Q3bZIRTO32Bcl2VNSShXXkXQ8MMpyu1e1m/H
         rpIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE1KDB3EChGYs0n0khgiEc/8tBlWXA3XIC1p3Hc6549Ubjetoe8eIOlU8rQrkbf1d/lpqJikc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuSXQNR0FVwpos1XAfBplKeLFststUjVJpIjTH6Vox+I99Q38S
	9vE65cB/PV+/o7q4G2p8jRVy47JgbqI1Dr6nBHQdGl7LaAabWR0DxJrRcd7C8NY3a+jIufzH+30
	t0IWjayutb0U2feCMa/lQuHpEgHc5r8JWykQd2nPiOB6ph4OAx1kvnw==
X-Gm-Gg: ASbGncsza8tvd8AX5GYxpTe6+egLraJm2cF3/1KEPr+QCR5zfscH0sWJTXMBnqisJ3W
	3etPZAkBVMqzs6tz97IfQOwZNKeur+kCKNTgY1zuvk1arUeyrs7yZsMC0zIPWuAZCKoBiqVjIj4
	L1IdTJNw6iEKgD7sS7DVJysf9jnKMouvyjXPALUkxk/35X3vIIXu1OsCpRHHjlh0BCxC/Mx1wVD
	kNF0PIpww0E8mIvfoiMzGpD0cZTnaVNVa0QQKgfYJYSpXxm1fFZyvl8r7eYVNu8u1Potc1qLdR+
	pSv2/i86kiktiK9gqEtazVRdKELl
X-Received: by 2002:a05:622a:1481:b0:467:6486:beea with SMTP id d75a77b69052e-467a16d8d82mr17250521cf.38.1734025573789;
        Thu, 12 Dec 2024 09:46:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESjabeM15BdQhC8Wj8b+Ah/nkx1/l8WK0j38QBKEhg2gmiHasG+E2HVEBwie5+liQCRSqa5Q==
X-Received: by 2002:a05:622a:1481:b0:467:6486:beea with SMTP id d75a77b69052e-467a16d8d82mr17250071cf.38.1734025573505;
        Thu, 12 Dec 2024 09:46:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4674feaaab4sm59534911cf.18.2024.12.12.09.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 09:46:12 -0800 (PST)
Message-ID: <12a2ef7c-0ba3-49d9-9e08-733b8ca6a753@redhat.com>
Date: Thu, 12 Dec 2024 18:46:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 02/20] arm/cpu: Add sysreg definitions in
 cpu-sysregs.h
To: Richard Henderson <richard.henderson@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241206112213.88394-1-cohuck@redhat.com>
 <20241206112213.88394-3-cohuck@redhat.com>
 <2a83a49b-6863-4fb8-b5de-c3eacf3cdb77@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <2a83a49b-6863-4fb8-b5de-c3eacf3cdb77@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YU_5-Z7QZLNHm7zdghcH7-zTAK1Pu_lHG6C5AGEij80_1734025574
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Richard,
On 12/12/24 15:37, Richard Henderson wrote:
> On 12/6/24 05:21, Cornelia Huck wrote:
>> +#define SYS_ID_AA64PFR0_EL1                             sys_reg(3,
>> 0, 0, 4, 0)
> ...
>> +typedef struct ARMSysReg {
>> +    int op0;
>> +    int op1;
>> +    int crn;
>> +    int crm;
>> +    int op2;
>> +} ARMSysReg;
> ...
>> +static inline ARMSysReg sys_reg(int op0, int op1, int crn, int crm,
>> int op2)
>> +{
>> +        ARMSysReg sr = {op0, op1, crn, crm, op2};
>> +
>> +        return sr;
>> +}
>
> Not a fan.  Why take 20 bytes to represent these?
sure we can optimize it
>
> Our existing ENCODE_CP_REG and ENCODE_AA64_CP_REG macros seem much
> better, even if the argument ordering doesn't match the column
> ordering in Table D22-2.
>
>> @@ -841,6 +849,51 @@ typedef struct IdRegMap {
>>       uint64_t regs[NR_ID_REGS];
>>   } IdRegMap;
>>   +#define ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm,
>> op2)               \
>> +       
>> ({                                                              \
>> +                __u64 __op1 = (op1) &
>> 3;                                \
>> +                __op1 -= (__op1 ==
>> 3);                                  \
>> +                (__op1 << 6 | ((crm) & 7) << 3 |
>> (op2));                \
>> +        })
>
> Ah, well, this answers my question re patch 1.
>
> It seems a shame to use 128 slots to represent all 9 id registers in
> the op1={1,3} space.
wouldn't it make sense to use a hashtable then as we don't have
consecutive indexes?
>
> Do we really need anything beyond the defined registers, or even the
> defined registers for which qemu knows how to do anything?
what do you mean by "defined registers". The end goal is to be able to
tune any id reg that the kernel allows to write. So I guess we shall
encompass more regs than qemu currently handles.

Wrt op1={1,3}, tbh I initially sticked to the KVM API. Now looking at
D22-2, effectively we have very few ID regs there. If we were to use a
hashtable we may be more flexible in picking up the indexes that are
relevant for us.
>
> I'm certainly happy to replace ARMISARegisters fields with an array,
> but more like
>
> enum ARMIDRegisterIdx {
>     ID_AA64ISAR0_IDX,
>     etc
>     ordering arbitrary, either machine or macro generated,
>     but every register has a symbolic index.
>     NUM_ID_IDX,
> };
>
> enum ARMSysregs {
>     SYS_ID_AA64PFR0_EL1 = ENCODE_AA64_CP_REG(...),
>     etc
> };
>
> const uint32_t id_register_sysreg[NUM_ID_IDX] = {
>     [ID_AA64ISAR0_IDX] = SYS_ID_AA64PFR0_EL1,
>     etc
> };
>
> struct ARMISARegisters {
>     uint64_t id[NUM_ID_IDX];
> };
>
> This seems trivial to automate, and wastes no space.

Sure we will study such rework. As long as the key (ID_AA64ISAR0_IDX)
can be matched against the index used by the KVM API we should be fine.

Thanks

Eric
>
>
> r~
>

