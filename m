Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5E017B047
	for <kvmarm@lists.linux.dev>; Tue,  9 Jul 2024 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720545510; cv=none; b=hvvP3RO96/LktNsWeTbj0d9cWP80k91yApPB9sPn0cqwUPA6Sae/4uPrzfWiG4jEvSWxGRNy6R7lNkpGt5eCj8W9pFXN5ESsFNuXqC82LdcZknEueR9yD0jO28Xf+ZTzLjXWQ5kRTDVS1XgdgTfmaSdqEKo1R31Mna0zalV8ujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720545510; c=relaxed/simple;
	bh=ZtMn0LRwFtGxyVO7PDTRcOf9LNpyjB1lVBEmum938wY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QkvUq8/tDFVCK87DZ55d4AHJSDaBKj6nSe1q7irZC4M+kJ7wsASNg5yD0YgKvArwCFw5uSper0bw6E0G9HMLmcefANnkdXjSrM7DvMx4b63z64E+Wjs7XY0iZbab/pPtop6qw9CCwnZIj5Moy07EXZbpVFN16C0YCX9lW6hl/gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bzGYXzu3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bzGYXzu3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720545507;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txWFpwGnvOu9QFzJiCC8zu5uRGQCIBjC/kvWz1kKaQA=;
	b=bzGYXzu37bT0sr5xQXnMzPttdQbpQewsvmv9f0YTQVT0Pa3W8HJzUeMMM0eiuFsUsSSRfg
	9MgLNnrJVBLu1POR525uL7hfLtwMi71bOO0uA382UxY6R2+apn3+tpBWoRnP/DqXz5jRZp
	uJkZTO6ua7NO59oyR/HPEIrwHemgaHI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-ifJ2bwBbMXKc-G2ZGVFo_Q-1; Tue, 09 Jul 2024 13:18:25 -0400
X-MC-Unique: ifJ2bwBbMXKc-G2ZGVFo_Q-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3d923b2fe51so3634197b6e.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jul 2024 10:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720545505; x=1721150305;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=txWFpwGnvOu9QFzJiCC8zu5uRGQCIBjC/kvWz1kKaQA=;
        b=EJZWRDOwUgu3oovps7Guqh7OXAuJgKh3hKdU2ilfrLYKZG20HH0U7x7lqIJTAlgRhd
         Bw0N7G54hpvVwrMnxn/hRolzDUWSnzYTF1F4YdCQDr2FKt0FuaEZZLpgYDgXWbSuEcyt
         PvIGUFYKBGz8r+tg6jDz0xEOS7hsewEylgFhnuIyCEofUErSvT159DXAO31K9gtcoH4v
         HvWrDtxpDFX5p54aCewuXrAdZUhN4b81aOv9PJmdYxQmksGTueeIQzFK+OUd+F/qt5Wr
         KLBxM1qK0VCVxQ14B/fnV8z5I1ZSvvnoWNAFoMCTiLBERKIEnhf/nS9MJwDsr1rjNecc
         Rg6A==
X-Forwarded-Encrypted: i=1; AJvYcCWlO+v3QQxueUiWxMjd2FgPC+2ZFpkKppbKyMdI+zDKc1BRuacgLngw6aVv54VBwZ24VF0l76GYgYsl9LHkR52AKdfpdVjQ
X-Gm-Message-State: AOJu0YzgW41y/Q5yaoJrxTOoU+DN3xnLX5vWiGd7Ki2Q/MtV9qeB4jSj
	0ljAT5509RP2rPiPpNtU9223QZlO78yy33YhlbjdBbB2Uw1MIdv8Uex5RAfOk54+mY4mHxMLFp1
	TrJwrGkeLp/IQcPtS2wO/v44xIdQz/jLT1KuU8VHLQKQhhO+Qyuc3Hw==
X-Received: by 2002:a05:6808:140c:b0:3d9:2d9c:8aff with SMTP id 5614622812f47-3d93c085d8cmr3345134b6e.45.1720545504676;
        Tue, 09 Jul 2024 10:18:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCg8hXYGmEjThxs8qicr/EaSUtmrtO5gek2UVhqCZuwkZ1767RBJduAkyXwsp1LLvcYZ+Ylg==
X-Received: by 2002:a05:6808:140c:b0:3d9:2d9c:8aff with SMTP id 5614622812f47-3d93c085d8cmr3345103b6e.45.1720545504247;
        Tue, 09 Jul 2024 10:18:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f1902909asm114532285a.58.2024.07.09.10.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 10:18:23 -0700 (PDT)
Message-ID: <f36223a9-3db4-41be-81ef-b472cd34b607@redhat.com>
Date: Tue, 9 Jul 2024 19:18:19 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU introspection
 test if missing
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, pbonzini@redhat.com,
 drjones@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com, maz@kernel.org,
 Anders Roxell <anders.roxell@linaro.org>,
 Andrew Jones <andrew.jones@linux.dev>, "open list:ARM"
 <kvmarm@lists.linux.dev>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-2-alex.bennee@linaro.org> <Zoz7sQNoC9ePXH7w@arm.com>
 <CAFEAcA-LFtAi0DkFGc0Q3TYR_+X3TUWQru8crhbKun4EHctcdQ@mail.gmail.com>
 <87ed82slt8.fsf@draig.linaro.org> <Zo1RvCdNDhaZHKMb@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zo1RvCdNDhaZHKMb@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 7/9/24 17:05, Alexandru Elisei wrote:
> Hi,
>
> On Tue, Jul 09, 2024 at 03:05:07PM +0100, Alex Bennée wrote:
>> Peter Maydell <peter.maydell@linaro.org> writes:
>>
>>> On Tue, 9 Jul 2024 at 09:58, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>> Hi,
>>>>
>>>> On Tue, Jul 02, 2024 at 05:35:14PM +0100, Alex Bennée wrote:
>>>>> The test for number of events is not a substitute for properly
>>>>> checking the feature register. Fix the define and skip if PMUv3 is not
>>>>> available on the system. This includes emulator such as QEMU which
>>>>> don't implement PMU counters as a matter of policy.
>>>>>
>>>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>>>> Cc: Anders Roxell <anders.roxell@linaro.org>
>>>>> ---
>>>>>  arm/pmu.c | 7 ++++++-
>>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>>> index 9ff7a301..66163a40 100644
>>>>> --- a/arm/pmu.c
>>>>> +++ b/arm/pmu.c
>>>>> @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
>>>>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>>>>>
>>>>>  #define ID_DFR0_PMU_NOTIMPL  0b0000
>>>>> -#define ID_DFR0_PMU_V3               0b0001
>>>>> +#define ID_DFR0_PMU_V3               0b0011
>>>>>  #define ID_DFR0_PMU_V3_8_1   0b0100
>>>>>  #define ID_DFR0_PMU_V3_8_4   0b0101
>>>>>  #define ID_DFR0_PMU_V3_8_5   0b0110
>>>>> @@ -286,6 +286,11 @@ static void test_event_introspection(void)
>>>>>               return;
>>>>>       }
>>>>>
>>>>> +     if (pmu.version < ID_DFR0_PMU_V3) {
>>>>> +             report_skip("PMUv3 extensions not supported, skip ...");
>>>>> +             return;
>>>>> +     }
>>>>> +
>>>> I don't get this patch - test_event_introspection() is only run on 64bit. On
>>>> arm64, if there is a PMU present, that PMU is a PMUv3.  A prerequisite to
>>>> running any PMU tests is for pmu_probe() to succeed, and pmu_probe() fails if
>>>> there is no PMU implemented (PMUVer is either 0, or 0b1111). As a result, if
>>>> test_event_introspection() is executed, then a PMUv3 is present.
>>>>
>>>> When does QEMU advertise FEAT_PMUv3*, but no event counters (other than the cycle
>>>> counter)?
>> The other option I have is this:
>>
>> --8<---------------cut here---------------start------------->8---
>> arm/pmu: event-introspection needs icount for TCG
>>
>> The TCG accelerator will report a PMU (unless explicitly disabled with
>> -cpu foo,pmu=off) however not all events are available unless you run
>> under icount. Fix this by splitting the test into a kvm and tcg
>> version.
> As far as I can tell, if test_event_introspection() fails under TCG without
> icount then there are two possible explanations for that:
>
> 1. Not all the events whose presence is checked by test_event_introspection()
> are actually required by the architecture.
>
> 2. TCG without icount is not implementing all the events required by the
> architecture.
>
> If 1, then test_event_introspection() should be fixed. I had a look and the
> function looked correct to me (except that the event name is not INST_PREC,
> it's INST_SPEC in the Arm DDI0487J.A and K.a, but that's not relevant for
> correctness).
>
> From what I can tell from what Peter and you have said, explanation 2 is the
> correct one, because TCG cannot implement all the required events when icount is
> not specified. As far as test_event_introspection() is concerned, I consider
> this to be the expected behaviour: it fails because the required events are not
> implemented. I don't think the function should be changed to work around how
> QEMU was invoked. Do you agree?
>
> If you know that the test will fail without special command line parameters when
> accel is TCG, then I think what you are suggesting looks correct to me: the
> original test is skipped if KVM is not present, and when run under TCG, the
> correct parameters are passed to QEMU.
This looks sensible to me too

Eric
>
> Thanks,
> Alex
>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>
>> 1 file changed, 8 insertions(+)
>> arm/unittests.cfg | 8 ++++++++
>>
>> modified   arm/unittests.cfg
>> @@ -52,8 +52,16 @@ extra_params = -append 'cycle-counter 0'
>>  file = pmu.flat
>>  groups = pmu
>>  arch = arm64
>> +accel = kvm
>>  extra_params = -append 'pmu-event-introspection'
>>  
>> +[pmu-event-introspection-icount]
>> +file = pmu.flat
>> +groups = pmu
>> +arch = arm64
>> +accel = tcg
>> +extra_params = -icount shift=1 -append 'pmu-event-introspection'
>> +
>>  [pmu-event-counter-config]
>>  file = pmu.flat
>>  groups = pmu
>> --8<---------------cut here---------------end--------------->8---
>>
>> which just punts icount on TCG to its own test (note there are commented
>> out versions further down the unitests.cfg file)
>>
>> -- 
>> Alex Bennée
>> Virtualisation Tech Lead @ Linaro

