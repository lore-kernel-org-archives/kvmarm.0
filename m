Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536722F747A
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672109; cv=none; b=lYsj3Kd33Qj1RI54ul7UI4F0SA5npuFnJ8gTrLPl37pgxqChxVQ4719cQtPm4zmrX7G2YcIC9yu8GYtirhCSVp42xALzs6ruA1QCoVrIyKB227ZMgxn3JGhp0rgIUAK98CHQ6ViFl+awL6IDuC8dc9hXhUOhL9ttb+tL90nI3Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672109; c=relaxed/simple;
	bh=P3yJhjcp0BtJWj8V9iL9D/pBzBMmS4yf6GnFieutv74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L5rsojavcRzNsfmZpOXDwjqEUmM98Cfb2zFFWK/dzCM2WVUjhGR7hL+xi2CAoUL2g4unjjhuEGj+P1gFNT+KlfeDxF/D7YaIu4t3Rx9GiBe9hJpyLvmfOdHFMNV7AlXzfExIVgo/zPRFICMwMAF6Slx1LpWL1peIPoeLONvZ9qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eze8KP6Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eze8KP6Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787672104;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ppgXbPiE+3Uv8DDxwDgRxNERk1v/95srvtY0MygFPJY=;
	b=eze8KP6QOyB9ZqWFdjKoFt/vBisND4Mqnrh++g1+xDyvV0wQX7uJ71TQgMqgG2yYVVIHrK
	4E/e6BZhsBCltWATLKDsmUqHssoaA9UnLbKxkcaDv07tcD0bGPPMsKiqZCJo/r4Ec8kgxV
	AyUOwTnJuxnmkxQAYSbmlAunDArrNxc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-flx99D4YMCucOCwfypkIrA-1; Tue, 25 Aug 2026 11:35:02 -0400
X-MC-Unique: flx99D4YMCucOCwfypkIrA-1
X-Mimecast-MFC-AGG-ID: flx99D4YMCucOCwfypkIrA_1787672100
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-69841da1946so4354974a12.2
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672100; x=1788276900;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ppgXbPiE+3Uv8DDxwDgRxNERk1v/95srvtY0MygFPJY=;
        b=YQtKvLfNKryIeXxNtZ/i6oh/ITk/2xBr9frmXoxp1uI7rE5syUx0M/iH2OyVQk5EKp
         J2Y41R9nhEAcM0/mGiilGiVDLwMbKsINJjDuDo/m2Om/vi+YB43q7N6OTTV/8JuA6ihp
         CQ5VnGF9iEf1840Zo7O9wwXeY8rbD23TMXZ2KIorOgcPMjIT9eat9n/VFT0tuZ8+u4/S
         AFDL0mvDj5zuwxgOZVVamEBjd3LHHOAp52zByByNw6ODi2SMK9VXGwr1Jo5T58/+vkkf
         p788/3leOPBvI8Eo/eYqFJCd1sFCkZFA87gqlPpTVU/5HMZ5AYIiJfAadwDUQI/iQYEe
         NikQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPSOVbRUmcJWqiI9qqENq2V3AeykezYt0fZ+3f9Lfc60k8sjBpDNG+Oe0iDZLhKmFnJGQ9QpE=@lists.linux.dev
X-Gm-Message-State: AFuF++kykROHv2nWfLdFvutS8HOYaEWk9MsgHmQ2l7odyUCDRDxXAria
	ovKqW2PWuR+kBlJ+9YsTTpccRZ88cz+xer/kzawy7OO7cUXFgLLhuOIBcIQWJtEue6xwfsa4uMr
	9v3KdFhITwj5lkReueQMqhyhoXkYMIl5D3uoNEw0FlvorH1MRvtXyhq04rg==
X-Gm-Gg: AR+sD11KRSdmbp+GbKs+KbvKXqTGHX+4mqJvR+UvQyghWf3IdENbo66uqlSBOzsMKHi
	12p72kV0GxcHeqnSCDxodlLfZ+jGMxNvkbAcmuNWLl/BGGkdiEkz4f94X+wD9BI8Jk+GhLl+tPJ
	74caOQ4XFmZeX8RGAVvowo1mznnYd5WE/XzbLSdTcsyrxgogKN3AMky2gp0H6+yqlq89YXD/5hE
	wrVenQjXTSskTCAUTvz0toLOpZ0R23rW6ZUKAKnlsVg/PfHYN8T7wRw1BMbOtHFyQK15zAJZQZ8
	biG8lCC52fr7X8rcRufaK0wL7THozUxDNliiizugWUXZmUoptRAi3zgJuwp/YahO+EjXE+a8qgo
	L3QPS8bpvMxeG+pXHFWdAxrEKl9BbJRhUXLHu3rQDhTyC6vkx
X-Received: by 2002:a05:6402:324d:b0:6a3:f47c:969 with SMTP id 4fb4d7f45d1cf-6a5c40ccb42mr8830749a12.3.1787672100327;
        Tue, 25 Aug 2026 08:35:00 -0700 (PDT)
X-Received: by 2002:a05:6402:324d:b0:6a3:f47c:969 with SMTP id 4fb4d7f45d1cf-6a5c40ccb42mr8830691a12.3.1787672099808;
        Tue, 25 Aug 2026 08:34:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5dea83babsm201637a12.16.2026.08.25.08.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:34:59 -0700 (PDT)
Message-ID: <71022115-11f5-41d7-96fe-14499952c10e@redhat.com>
Date: Tue, 25 Aug 2026 17:34:56 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v7 14/18] target/arm/cpu-idregs.h.inc: Generate
 reserved fields
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
 <20260726153221.24773-15-eric.auger@redhat.com>
 <F9333A1C-BBFF-4134-8FDB-5DC94CD31445@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <F9333A1C-BBFF-4134-8FDB-5DC94CD31445@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2EKdKBtf0lD_lNXF2OJXuQzsjfVs4EROfbFCPwiglNE_1787672100
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 8/24/26 8:55 AM, Khushit Shah wrote:
>
>> On 26 Jul 2026, at 8:59 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Extract reserved fields: RES0, RES1, RAZ, ...
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>> target/arm/cpu-idregs.h.inc                   | 69 ++++++++++++++-
>> .../update-aarch64-cpu-sysreg-properties.py   | 83 +++++++++++++++----
>> 2 files changed, 136 insertions(+), 16 deletions(-)
>>
>> diff --git a/target/arm/cpu-idregs.h.inc b/target/arm/cpu-idregs.h.inc
>> index 1c8b26133b..5fdc84237c 100644
>> --- a/target/arm/cpu-idregs.h.inc
>> +++ b/target/arm/cpu-idregs.h.inc
>> @@ -15,16 +15,20 @@ IDREG_START(AIDR_EL1)
>> IDREG_END(AIDR_EL1)
>>
>> IDREG_START(CCSIDR2_EL1)
>> +    IDREG_FIELD(CCSIDR2_EL1, RES0, 24, 40)
>>     IDREG_FIELD(CCSIDR2_EL1, NumSets, 0, 24)
>> IDREG_END(CCSIDR2_EL1)
>>
>> IDREG_START(CCSIDR_EL1)
>> +    IDREG_FIELD(CCSIDR_EL1, RES0, 56, 8)
>>     IDREG_FIELD(CCSIDR_EL1, NumSets, 32, 24)
>> +    IDREG_FIELD(CCSIDR_EL1, RES0, 24, 8)
>>     IDREG_FIELD(CCSIDR_EL1, Associativity, 3, 21)
>>     IDREG_FIELD(CCSIDR_EL1, LineSize, 0, 3)
>> IDREG_END(CCSIDR_EL1)
>>
>> IDREG_START(CLIDR_EL1)
>> +    IDREG_FIELD(CLIDR_EL1, RES0, 47, 17)
>>     IDREG_FIELD(CLIDR_EL1, Ttype7, 45, 2)
>>     IDREG_FIELD(CLIDR_EL1, Ttype6, 43, 2)
>>     IDREG_FIELD(CLIDR_EL1, Ttype5, 41, 2)
>> @@ -55,7 +59,10 @@ IDREG_START(CLIDR_EL1)
>> IDREG_END(CLIDR_EL1)
>>
>> IDREG_START(CTR_EL0)
>> +    IDREG_FIELD(CTR_EL0, RES0, 38, 26)
>>     IDREG_FIELD(CTR_EL0, TminLine, 32, 6)
>> +    IDREG_FIELD(CTR_EL0, RES1, 31, 1)
>> +    IDREG_FIELD(CTR_EL0, RES0, 30, 1)
>>     IDREG_FIELD_START(CTR_EL0, DIC, 29, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -73,23 +80,28 @@ IDREG_START(CTR_EL0)
>>         IDREG_FIELD_ARCH_VAL(2)
>>         IDREG_FIELD_ARCH_VAL(3)
>>     IDREG_FIELD_END(CTR_EL0, L1Ip)
>> +    IDREG_FIELD(CTR_EL0, RES0, 4, 10)
>>     IDREG_FIELD(CTR_EL0, IminLine, 0, 4)
>> IDREG_END(CTR_EL0)
>>
>> IDREG_START(DCZID_EL0)
>> +    IDREG_FIELD(DCZID_EL0, RES0, 9, 55)
>>     IDREG_FIELD(DCZID_EL0, TBS, 5, 4)
>>     IDREG_FIELD(DCZID_EL0, DZP, 4, 1)
>>     IDREG_FIELD(DCZID_EL0, BS, 0, 4)
>> IDREG_END(DCZID_EL0)
>>
>> IDREG_START(GMID_EL1)
>> +    IDREG_FIELD(GMID_EL1, RES0, 4, 60)
>>     IDREG_FIELD(GMID_EL1, BS, 0, 4)
>> IDREG_END(GMID_EL1)
>>
>> IDREG_START(ID_AA64AFR0_EL1)
>> +    IDREG_FIELD(ID_AA64AFR0_EL1, RES0, 32, 32)
>> IDREG_END(ID_AA64AFR0_EL1)
>>
>> IDREG_START(ID_AA64AFR1_EL1)
>> +    IDREG_FIELD(ID_AA64AFR1_EL1, RES0, 0, 64)
>> IDREG_END(ID_AA64AFR1_EL1)
>>
>> IDREG_START(ID_AA64DFR0_EL1)
>> @@ -136,6 +148,7 @@ IDREG_START(ID_AA64DFR0_EL1)
>>     IDREG_FIELD_START(ID_AA64DFR0_EL1, CTX_CMPs, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(15)
>>     IDREG_FIELD_END(ID_AA64DFR0_EL1, CTX_CMPs)
>> +    IDREG_FIELD(ID_AA64DFR0_EL1, RES0, 24, 4)
>>     IDREG_FIELD(ID_AA64DFR0_EL1, WRPs, 20, 4)
>>     IDREG_FIELD_START(ID_AA64DFR0_EL1, PMSS, 16, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>> @@ -209,6 +222,7 @@ IDREG_START(ID_AA64DFR1_EL1)
>> IDREG_END(ID_AA64DFR1_EL1)
>>
>> IDREG_START(ID_AA64DFR2_EL1)
>> +    IDREG_FIELD(ID_AA64DFR2_EL1, RES0, 28, 36)
>>     IDREG_FIELD_START(ID_AA64DFR2_EL1, TRBE_EXC, 24, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -221,6 +235,7 @@ IDREG_START(ID_AA64DFR2_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64DFR2_EL1, SPE_EXC)
>> +    IDREG_FIELD(ID_AA64DFR2_EL1, RES0, 8, 8)
>>     IDREG_FIELD_START(ID_AA64DFR2_EL1, BWE, 4, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -233,6 +248,7 @@ IDREG_START(ID_AA64DFR2_EL1)
>> IDREG_END(ID_AA64DFR2_EL1)
>>
>> IDREG_START(ID_AA64FPFR0_EL1)
>> +    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_AA64FPFR0_EL1, F8CVT, 31, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -257,10 +273,13 @@ IDREG_START(ID_AA64FPFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64FPFR0_EL1, F8MM4)
>> +    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 16, 10)
>>     IDREG_FIELD_START(ID_AA64FPFR0_EL1, F16MM2, 15, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64FPFR0_EL1, F16MM2)
>> +    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 8, 7)
>> +    IDREG_FIELD(ID_AA64FPFR0_EL1, RAZ, 2, 6)
>>     IDREG_FIELD_START(ID_AA64FPFR0_EL1, F8E4M3, 1, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -312,6 +331,7 @@ IDREG_START(ID_AA64ISAR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64ISAR0_EL1, RDM)
>> +    IDREG_FIELD(ID_AA64ISAR0_EL1, RES0, 24, 4)
>>     IDREG_FIELD_START(ID_AA64ISAR0_EL1, Atomic, 20, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(2)
>> @@ -335,6 +355,7 @@ IDREG_START(ID_AA64ISAR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(1)
>>         IDREG_FIELD_ARCH_VAL(2)
>>     IDREG_FIELD_END(ID_AA64ISAR0_EL1, AES)
>> +    IDREG_FIELD(ID_AA64ISAR0_EL1, RES0, 0, 4)
>> IDREG_END(ID_AA64ISAR0_EL1)
>>
>> IDREG_START(ID_AA64ISAR1_EL1)
>> @@ -498,6 +519,7 @@ IDREG_START(ID_AA64ISAR2_EL1)
>> IDREG_END(ID_AA64ISAR2_EL1)
>>
>> IDREG_START(ID_AA64ISAR3_EL1)
>> +    IDREG_FIELD(ID_AA64ISAR3_EL1, RES0, 48, 16)
>>     IDREG_FIELD_START(ID_AA64ISAR3_EL1, LSCP, 44, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -561,6 +583,7 @@ IDREG_START(ID_AA64MMFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(1)
>>         IDREG_FIELD_ARCH_VAL(2)
>>     IDREG_FIELD_END(ID_AA64MMFR0_EL1, FGT)
>> +    IDREG_FIELD(ID_AA64MMFR0_EL1, RES0, 48, 8)
>>     IDREG_FIELD_START(ID_AA64MMFR0_EL1, ExS, 44, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -713,6 +736,7 @@ IDREG_START(ID_AA64MMFR2_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64MMFR2_EL1, TTL)
>> +    IDREG_FIELD(ID_AA64MMFR2_EL1, RES0, 44, 4)
>>     IDREG_FIELD_START(ID_AA64MMFR2_EL1, FWB, 40, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -778,6 +802,7 @@ IDREG_START(ID_AA64MMFR3_EL1)
>>         IDREG_FIELD_ARCH_VAL(2)
>>         IDREG_FIELD_ARCH_VAL(3)
>>     IDREG_FIELD_END(ID_AA64MMFR3_EL1, SDERR)
>> +    IDREG_FIELD(ID_AA64MMFR3_EL1, RES0, 48, 4)
>>     IDREG_FIELD_START(ID_AA64MMFR3_EL1, ANERR, 44, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1031,6 +1056,7 @@ IDREG_START(ID_AA64PFR1_EL1)
>>         IDREG_FIELD_ARCH_VAL(1)
>>         IDREG_FIELD_ARCH_VAL(2)
>>     IDREG_FIELD_END(ID_AA64PFR1_EL1, SME)
>> +    IDREG_FIELD(ID_AA64PFR1_EL1, RES0, 20, 4)
>>     IDREG_FIELD_START(ID_AA64PFR1_EL1, MPAM_frac, 16, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1058,6 +1084,7 @@ IDREG_START(ID_AA64PFR1_EL1)
>> IDREG_END(ID_AA64PFR1_EL1)
>>
>> IDREG_START(ID_AA64PFR2_EL1)
>> +    IDREG_FIELD(ID_AA64PFR2_EL1, RES0, 48, 16)
>>     IDREG_FIELD_START(ID_AA64PFR2_EL1, VMTETCL, 44, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1117,6 +1144,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64SMFR0_EL1, FA64)
>> +    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 62, 1)
>>     IDREG_FIELD_START(ID_AA64SMFR0_EL1, LUT6, 61, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1136,6 +1164,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(15)
>>     IDREG_FIELD_END(ID_AA64SMFR0_EL1, I16I64)
>> +    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 49, 3)
>>     IDREG_FIELD_START(ID_AA64SMFR0_EL1, F64F64, 48, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1180,6 +1209,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64SMFR0_EL1, F32F32)
>> +    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 31, 1)
>>     IDREG_FIELD_START(ID_AA64SMFR0_EL1, SF8FMA, 30, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1192,6 +1222,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64SMFR0_EL1, SF8DP2)
>> +    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 26, 2)
>>     IDREG_FIELD_START(ID_AA64SMFR0_EL1, SBitPerm, 25, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1204,10 +1235,12 @@ IDREG_START(ID_AA64SMFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64SMFR0_EL1, SFEXPA)
>> +    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 17, 6)
>>     IDREG_FIELD_START(ID_AA64SMFR0_EL1, STMOP, 16, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64SMFR0_EL1, STMOP)
>> +    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 1, 15)
>>     IDREG_FIELD_START(ID_AA64SMFR0_EL1, SMOP4, 0, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1215,6 +1248,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
>> IDREG_END(ID_AA64SMFR0_EL1)
>>
>> IDREG_START(ID_AA64ZFR0_EL1)
>> +    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 60, 4)
>>     IDREG_FIELD_START(ID_AA64ZFR0_EL1, F64MM, 56, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1235,10 +1269,12 @@ IDREG_START(ID_AA64ZFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64ZFR0_EL1, SM4)
>> +    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 36, 4)
>>     IDREG_FIELD_START(ID_AA64ZFR0_EL1, SHA3, 32, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64ZFR0_EL1, SHA3)
>> +    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 28, 4)
>>     IDREG_FIELD_START(ID_AA64ZFR0_EL1, B16B16, 24, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1258,6 +1294,7 @@ IDREG_START(ID_AA64ZFR0_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_AA64ZFR0_EL1, EltPerm)
>> +    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 8, 4)
>>     IDREG_FIELD_START(ID_AA64ZFR0_EL1, AES, 4, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1274,9 +1311,11 @@ IDREG_START(ID_AA64ZFR0_EL1)
>> IDREG_END(ID_AA64ZFR0_EL1)
>>
>> IDREG_START(ID_AFR0_EL1)
>> +    IDREG_FIELD(ID_AFR0_EL1, RES0, 0, 64)
>> IDREG_END(ID_AFR0_EL1)
>>
>> IDREG_START(ID_DFR0_EL1)
>> +    IDREG_FIELD(ID_DFR0_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_DFR0_EL1, TraceFilt, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1328,6 +1367,7 @@ IDREG_START(ID_DFR0_EL1)
>> IDREG_END(ID_DFR0_EL1)
>>
>> IDREG_START(ID_DFR1_EL1)
>> +    IDREG_FIELD(ID_DFR1_EL1, RES0, 8, 56)
>>     IDREG_FIELD_START(ID_DFR1_EL1, HPMN0, 4, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1340,6 +1380,7 @@ IDREG_START(ID_DFR1_EL1)
>> IDREG_END(ID_DFR1_EL1)
>>
>> IDREG_START(ID_ISAR0_EL1)
>> +    IDREG_FIELD(ID_ISAR0_EL1, RES0, 28, 36)
>>     IDREG_FIELD_START(ID_ISAR0_EL1, Divide, 24, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1375,6 +1416,7 @@ IDREG_START(ID_ISAR0_EL1)
>> IDREG_END(ID_ISAR0_EL1)
>>
>> IDREG_START(ID_ISAR1_EL1)
>> +    IDREG_FIELD(ID_ISAR1_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_ISAR1_EL1, Jazelle, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1413,6 +1455,7 @@ IDREG_START(ID_ISAR1_EL1)
>> IDREG_END(ID_ISAR1_EL1)
>>
>> IDREG_START(ID_ISAR2_EL1)
>> +    IDREG_FIELD(ID_ISAR2_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_ISAR2_EL1, Reversal, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1458,6 +1501,7 @@ IDREG_START(ID_ISAR2_EL1)
>> IDREG_END(ID_ISAR2_EL1)
>>
>> IDREG_START(ID_ISAR3_EL1)
>> +    IDREG_FIELD(ID_ISAR3_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_ISAR3_EL1, T32EE, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1495,6 +1539,7 @@ IDREG_START(ID_ISAR3_EL1)
>> IDREG_END(ID_ISAR3_EL1)
>>
>> IDREG_START(ID_ISAR4_EL1)
>> +    IDREG_FIELD(ID_ISAR4_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_ISAR4_EL1, SWP_frac, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1519,12 +1564,12 @@ IDREG_START(ID_ISAR4_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_ISAR4_EL1, Writeback)
>> -    IDREG_FIELD_START(ID_ISAR4_EL1, WithShifts, 4, 4)
>> +    IDREG_FIELD_START(ID_ISAR4_EL1, WI, 4, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>         IDREG_FIELD_ARCH_VAL(3)
>>         IDREG_FIELD_ARCH_VAL(4)
>> -    IDREG_FIELD_END(ID_ISAR4_EL1, WithShifts)
>> +    IDREG_FIELD_END(ID_ISAR4_EL1, WI)
> unintended change?

Correct. This comes from an issue in the script

+                for r_type in ["RES0", "RES1", "RAZ", "RAO", "WI", "UNKNOWN"]:
+                    if r_type in name_upper:


r_type = "WI" in "WithShifts" evaluates to true
fixed by 

if r_type == name_upper:


>
> This is the problem with relying solely on AARCHMRS?
> Imagine a named model/management stack using _WithShifts
> prop, and suddenly it no longer exists.
In the unlikely case a field name has changed (again it is not the case
here), I guess we could rely on a property alias, update the model version.

Thanks!

Eric
>
>>     IDREG_FIELD_START(ID_ISAR4_EL1, Unpriv, 0, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1533,6 +1578,7 @@ IDREG_START(ID_ISAR4_EL1)
>> IDREG_END(ID_ISAR4_EL1)
>>
>> IDREG_START(ID_ISAR5_EL1)
>> +    IDREG_FIELD(ID_ISAR5_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_ISAR5_EL1, VCMA, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1541,6 +1587,7 @@ IDREG_START(ID_ISAR5_EL1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(ID_ISAR5_EL1, RDM)
>> +    IDREG_FIELD(ID_ISAR5_EL1, RES0, 20, 4)
>>     IDREG_FIELD_START(ID_ISAR5_EL1, CRC32, 16, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1565,6 +1612,7 @@ IDREG_START(ID_ISAR5_EL1)
>> IDREG_END(ID_ISAR5_EL1)
>>
>> IDREG_START(ID_ISAR6_EL1)
>> +    IDREG_FIELD(ID_ISAR6_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_ISAR6_EL1, CLRBHB, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1601,6 +1649,7 @@ IDREG_START(ID_ISAR6_EL1)
>> IDREG_END(ID_ISAR6_EL1)
>>
>> IDREG_START(ID_MMFR0_EL1)
>> +    IDREG_FIELD(ID_MMFR0_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_MMFR0_EL1, InnerShr, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1647,6 +1696,7 @@ IDREG_START(ID_MMFR0_EL1)
>> IDREG_END(ID_MMFR0_EL1)
>>
>> IDREG_START(ID_MMFR1_EL1)
>> +    IDREG_FIELD(ID_MMFR1_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_MMFR1_EL1, BPred, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1695,6 +1745,7 @@ IDREG_START(ID_MMFR1_EL1)
>> IDREG_END(ID_MMFR1_EL1)
>>
>> IDREG_START(ID_MMFR2_EL1)
>> +    IDREG_FIELD(ID_MMFR2_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_MMFR2_EL1, HWAccFlg, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1733,6 +1784,7 @@ IDREG_START(ID_MMFR2_EL1)
>> IDREG_END(ID_MMFR2_EL1)
>>
>> IDREG_START(ID_MMFR3_EL1)
>> +    IDREG_FIELD(ID_MMFR3_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_MMFR3_EL1, Supersec, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(15)
>> @@ -1772,6 +1824,7 @@ IDREG_START(ID_MMFR3_EL1)
>> IDREG_END(ID_MMFR3_EL1)
>>
>> IDREG_START(ID_MMFR4_EL1)
>> +    IDREG_FIELD(ID_MMFR4_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_MMFR4_EL1, EVT, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1809,6 +1862,7 @@ IDREG_START(ID_MMFR4_EL1)
>> IDREG_END(ID_MMFR4_EL1)
>>
>> IDREG_START(ID_MMFR5_EL1)
>> +    IDREG_FIELD(ID_MMFR5_EL1, RES0, 8, 56)
>>     IDREG_FIELD_START(ID_MMFR5_EL1, nTLBPA, 4, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1822,6 +1876,7 @@ IDREG_START(ID_MMFR5_EL1)
>> IDREG_END(ID_MMFR5_EL1)
>>
>> IDREG_START(ID_PFR0_EL1)
>> +    IDREG_FIELD(ID_PFR0_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_PFR0_EL1, RAS, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1863,6 +1918,7 @@ IDREG_START(ID_PFR0_EL1)
>> IDREG_END(ID_PFR0_EL1)
>>
>> IDREG_START(ID_PFR1_EL1)
>> +    IDREG_FIELD(ID_PFR1_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(ID_PFR1_EL1, GIC, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1902,6 +1958,7 @@ IDREG_START(ID_PFR1_EL1)
>> IDREG_END(ID_PFR1_EL1)
>>
>> IDREG_START(ID_PFR2_EL1)
>> +    IDREG_FIELD(ID_PFR2_EL1, RES0, 12, 52)
>>     IDREG_FIELD_START(ID_PFR2_EL1, RAS_frac, 8, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1949,11 +2006,14 @@ IDREG_START(MIDR_EL1)
>> IDREG_END(MIDR_EL1)
>>
>> IDREG_START(MPIDR_EL1)
>> +    IDREG_FIELD(MPIDR_EL1, RES0, 40, 24)
>>     IDREG_FIELD(MPIDR_EL1, Aff3, 32, 8)
>> +    IDREG_FIELD(MPIDR_EL1, RES1, 31, 1)
>>     IDREG_FIELD_START(MPIDR_EL1, U, 30, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>>     IDREG_FIELD_END(MPIDR_EL1, U)
>> +    IDREG_FIELD(MPIDR_EL1, RES0, 25, 5)
>>     IDREG_FIELD_START(MPIDR_EL1, MT, 24, 1)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -1964,6 +2024,7 @@ IDREG_START(MPIDR_EL1)
>> IDREG_END(MPIDR_EL1)
>>
>> IDREG_START(MVFR0_EL1)
>> +    IDREG_FIELD(MVFR0_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(MVFR0_EL1, FPRound, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -2002,6 +2063,7 @@ IDREG_START(MVFR0_EL1)
>> IDREG_END(MVFR0_EL1)
>>
>> IDREG_START(MVFR1_EL1)
>> +    IDREG_FIELD(MVFR1_EL1, RES0, 32, 32)
>>     IDREG_FIELD_START(MVFR1_EL1, SIMDFMAC, 28, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -2040,6 +2102,7 @@ IDREG_START(MVFR1_EL1)
>> IDREG_END(MVFR1_EL1)
>>
>> IDREG_START(MVFR2_EL1)
>> +    IDREG_FIELD(MVFR2_EL1, RES0, 8, 56)
>>     IDREG_FIELD_START(MVFR2_EL1, FPMisc, 4, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(1)
>> @@ -2059,6 +2122,7 @@ IDREG_START(REVIDR_EL1)
>> IDREG_END(REVIDR_EL1)
>>
>> IDREG_START(SMIDR_EL1)
>> +    IDREG_FIELD(SMIDR_EL1, RES0, 60, 4)
>>     IDREG_FIELD_START(SMIDR_EL1, NSMC, 56, 4)
>>         IDREG_FIELD_ARCH_VAL(0)
>>         IDREG_FIELD_ARCH_VAL(15)
>> @@ -2094,6 +2158,7 @@ IDREG_START(SMIDR_EL1)
>>         IDREG_FIELD_ARCH_VAL(2)
>>         IDREG_FIELD_ARCH_VAL(3)
>>     IDREG_FIELD_END(SMIDR_EL1, SH)
>> +    IDREG_FIELD(SMIDR_EL1, RES0, 12, 1)
>>     IDREG_FIELD(SMIDR_EL1, Affinity, 0, 12)
>> IDREG_END(SMIDR_EL1)
>>
>> diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
>> index e1d6c4afef..9e829fda2e 100644
>> --- a/scripts/update-aarch64-cpu-sysreg-properties.py
>> +++ b/scripts/update-aarch64-cpu-sysreg-properties.py
>> @@ -81,9 +81,13 @@ def collect_fields(item, bit_offset=0):
>>
>>     # Normal Field Types
>>     leaf_types = ['Fields.Field', 'Fields.ConstantField',
>> -                  'Fields.EnumeratedField', 'Fields.Bitfield']
>> +                  'Fields.EnumeratedField', 'Fields.Bitfield', 'Fields.Reserved']
>>     if _type in leaf_types:
>>         field_copy = item.copy()
>> +
>> +        if _type == 'Fields.Reserved' and not field_copy.get('name'):
>> +            field_copy['name'] = item.get('value', 'RES0')
>> +
>>         if field_copy.get('rangeset'):
>>             new_ranges = []
>>             for r in field_copy['rangeset']:
>> @@ -96,7 +100,7 @@ def collect_fields(item, bit_offset=0):
>>         return fields
>>
>>     # Traverse the hierarchy for other cases
>> -    for key in ['fields', 'values', 'fieldsets']:
>> +    for key in ['fields', 'values', 'fieldsets', 'constants']:
>>         for nested in item.get(key, []):
>>             fields.extend(collect_fields(nested, bit_offset))
>>
>> @@ -163,44 +167,95 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>>
>>         final_output += f"IDREG_START({reg_name})\n"
>>
>> -        unique_fields = {}
>> +        fieldset_variants = []
>> +
>>         for fieldset in register.get('fieldsets', []):
>> +            current_fieldset_fields = {}
>>             candidates = collect_fields(fieldset)
>> +
>>             for val in candidates:
>> -                name = (val.get('name') or val.get('label', '')).strip()
>> -                if not name or "RESERVED" in name.upper():
>> +                raw_name = val.get('name') or val.get('label') or val.get('value') or ''
>> +                name = raw_name.strip()
>> +                if not name:
>>                     continue
>> +
>> +                name_upper = name.upper()
>> +
>> +                # Check for architectural target states, including UNKNOWN remapping
>> +                base_reserved = None
>> +                for r_type in ["RES0", "RES1", "RAZ", "RAO", "WI", "UNKNOWN"]:
>> +                    if r_type in name_upper:
>> +                        base_reserved = "RES0" if r_type == "UNKNOWN" else r_type
>> +                        break
>> +
>> +                is_valid_reserved = base_reserved is not None
>> +                if "RESERVED" in name_upper and not is_valid_reserved:
>> +                    continue
>> +
>> +                # Force naming uniformity across padding blocks
>> +                if is_valid_reserved:
>> +                    name = base_reserved
>> +
>>                 for r in val.get('rangeset', []):
>>                     lsb = int(r.get('start'))
>>                     width = r.get('width')
>>                     msb = lsb + int(width) - 1
>>
>> -                    # Only keep the fields with the highest MSB
>> -                    # needed fir CCSIDR_EL1
>> -                    if name not in unique_fields or msb > unique_fields[name]['msb']:
>> -                        # extract enum values if any
>> +                    if is_valid_reserved:
>> +                        unique_key = f"{name}_{lsb}"
>> +                    else:
>> +                        unique_key = name
>> +
>> +                    if unique_key not in current_fieldset_fields or \
>> +                       msb > current_fieldset_fields[unique_key]['msb']:
>>                         enums = extract_field_enums(val)
>> -                        unique_fields[name] = {'lsb': lsb, 'msb': msb, 'width': width, 'enums': enums}
>> +                        current_fieldset_fields[unique_key] = {
>> +                            'raw_name': name,
>> +                            'lsb': lsb,
>> +                            'msb': msb,
>> +                            'width': width,
>> +                            'enums': enums
>> +                        }
>> +
>> +            if current_fieldset_fields:
>> +                fieldset_variants.append(current_fieldset_fields)
>> +
>> +        best_fieldset = {}
>> +        max_total_width = -1
>> +
>> +        for variant in fieldset_variants:
>> +            total_width = sum(f['width'] for f in variant.values())
>> +            # prioritize layout variants with the highest MSB coverage
>> +            max_msb = max(f['msb'] for f in variant.values()) if variant else 0
>> +
>> +            # Combine width and max_msb into a fitness score tuple
>> +            if (total_width, max_msb) > (max_total_width, max_total_width):
>> +                max_total_width = total_width
>> +                best_fieldset = variant
>> +
>> +        unique_fields = best_fieldset
>>
>>         # Sort decreasing lsbs
>>         sorted_fields = sorted(unique_fields.items(),
>>                                key=lambda x: x[1]['lsb'], reverse=True)
>>
>> -        for name, bits in sorted_fields:
>> +        for unique_key, bits in sorted_fields:
>>             enums_list = bits.get('enums', [])
>>
>> +            clean_name = bits.get('raw_name', unique_key)
>> +
>>             if enums_list:
>>                line = (f"    IDREG_FIELD_START({reg_name}, "
>> -                       f"{name}, {bits['lsb']}, {bits['width']})\n")
>> +                       f"{clean_name}, {bits['lsb']}, {bits['width']})\n")
>>             else:
>>                line = (f"    IDREG_FIELD({reg_name}, "
>> -                       f"{name}, {bits['lsb']}, {bits['width']})\n")
>> +                       f"{clean_name}, {bits['lsb']}, {bits['width']})\n")
>>             final_output += line
>>             # add the enum value definition if any
>>             for enum_item in enums_list:
>>                 final_output += (f"        IDREG_FIELD_ARCH_VAL({enum_item['value']})\n")
>>             if enums_list:
>> -               line = (f"    IDREG_FIELD_END({reg_name}, {name})\n")
>> +               line = (f"    IDREG_FIELD_END({reg_name}, {clean_name})\n")
>>                final_output += line
>>
>>         final_output += f"IDREG_END({reg_name})\n"
>> -- 
>> 2.53.0
>>

