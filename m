Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B45ACA76
	for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 18:46:04 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d74b711ec0dso193364276.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Aug 2023 11:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692902763; x=1693507563;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jxvSonwCPl7HzvAeeiStfZghiC+PCdMyvX2s7XAS0qg=;
        b=NVzIkEv1YN/fNfmOUW8+mCw4FGt9HP7CdvoVunxChDSreigmd4y8LfpytQe/AqNyk6
         SwtnQuX90QpPGaLd6tImxYVQyNzKUv8yN83q39jElkG6uSHjlKz6kU2oPBtRB5gAMh6o
         aMpmuTuXTnRULhbBAQ4vAMBl9b0WrIvPS+km14SYltNvzy4lWKgOetCmSN1OhEgpzdry
         ewT5BOv0btzFrSk0bYtrPvxTYNpRLFSWbdonYryyUQL/0fqlkg3f6ZjQK9urPIgCKVVr
         UjF/beO0p+u0oXMoXOaco7kmoUYr0lZoCXyO3/23am30ZXFVu4BsB394CHWzmvtIuc3m
         zhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692902763; x=1693507563;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jxvSonwCPl7HzvAeeiStfZghiC+PCdMyvX2s7XAS0qg=;
        b=ipD3z/Fe+3RA4TGnAnmfWKCZmWfISY0O9w3o0W2zmGUStr0sMxIGVhyjNe+aO5sfG5
         Mj0BD6CLmrGsU64bzxv1WLphzvPmqFXYtcnFi1Y+5/XXos5aaNhmmIF6h+/CSCvcHaWM
         P4yBQVf09EqgnG4yY3r308Rm7FvgMn9JakdwqeNbOE6/HvkHBLXorD+o4hk5LJ7WFaHn
         WKyYW+BYdcQTOF8BeD0xZ/Wn1QEJwMXJlCkyMggTLiKUVhY/HWW9jdxkAqC54zm46j5X
         C6oteKV34Zqj09LHGJOWc8vcffLmXg9urQvtc/BHGCE/Xiq7KLel3vIS8pQ1H8Dp8vqK
         e+vw==
X-Gm-Message-State: AOJu0Yyrd+AwyogzDzcj4oC8wfevkIgRZ5kWspLDEobeGxnqW+oueB2V
	OwYooZ56I1Xw+tV6id9bf7AjL2LHhxxj21B7QQ==
X-Google-Smtp-Source: AGHT+IHoz5xvutY055FyMb5A0+qKLbY91XiIs6jQGzBhrR+guKJhhRsG+9n92YHGqxDntUt9XeD1fRmg2IQaszGJIw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:aba2:0:b0:d77:f6f9:159 with SMTP
 id v31-20020a25aba2000000b00d77f6f90159mr62888ybi.9.1692902763449; Thu, 24
 Aug 2023 11:46:03 -0700 (PDT)
Date: Thu, 24 Aug 2023 18:46:02 +0000
In-Reply-To: <20230824-0c7416fcdabc1f5f04a53560@orel> (message from Andrew
 Jones on Thu, 24 Aug 2023 09:47:59 +0200)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: microbench: Benchmark with virtual
 instead of physical timer
From: Colton Lewis <coltonlewis@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, peter.maydell@linaro.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Andrew Jones <andrew.jones@linux.dev> writes:

> On Thu, Aug 24, 2023 at 09:29:33AM +0200, Andrew Jones wrote:
>> No need to speculate, QEMU is open source :-)  QEMU is setting on offset,
>> but not because it explicitly wants to.  Simply reading the CNT register
>> and writing back the same value is enough to set an offset, since the
>> timer will have certainly moved past whatever value was read by the time
>> it's written.  QEMU frequently saves and restores all registers in the
>> get-reg-list array, unless they've been explicitly filtered out (with
>> Linux commit 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array).
>> So, to restore trapless ptimer accesses, we need a QEMU patch like below
>> to filter out the register.

>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index 94bbd9661fd3..f89ea31f170d 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -674,6 +674,7 @@ typedef struct CPRegStateLevel {
>>    */
>>   static const CPRegStateLevel non_runtime_cpregs[] = {
>>       { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
>> +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
>>   };

>>   int kvm_arm_cpreg_level(uint64_t regidx)

> Actually, the QEMU fix above is necessary for more than just trap
> avoidance. The ptimer will lag more and more with respect to other time
> sources, even with respect to the vtimer (QEMU only updates the vtimer
> offset when the VM is "paused".)

> I'm not sure when I'll have time to test and post the QEMU patch. It may
> be better if somebody else picks it up.

I haven't posted any QEMU patches before, but I think I can handle this.
