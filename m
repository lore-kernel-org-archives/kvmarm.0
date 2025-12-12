Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725F030DD35
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 20:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765572882; cv=none; b=neW1CS81G0vzgfj9iP63EOizqzPdAWzXdk88/WpB+Mzn2zMHPUxeXciQ+AfZusmME0T4RRL2aSw76lmOjNZ/dRB0N4LjgVbYlP5YoQgZXAHi3jbxlUy+YSWN7uketnru8M9XGlN8lwv2Mldtd1m5IJR3nZ/IEvghfjinhUOh9sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765572882; c=relaxed/simple;
	bh=KRrYXDgotZ3hkrFWqT2Xxzs4T7VsdVUIUvNsM4Tt2CA=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Y33X89pC7ZfsvT8b4yTHW5akIGT7w4ndEymYbccE9EKlivf5BlikQamTGKL+UkDptT9tWyF/A3BngkCfuqYKIWBMshnS9fumtRF1aqf7DDhLsWH+gLxddpXvVFkOvowcQboiGa/zJZUPr764aRqDn0xE00yndMzmDqRBEaSBOSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HDTnHavx; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HDTnHavx"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-45396d397e0so1335671b6e.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 12:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765572879; x=1766177679; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3FXn5oKHBMgqIJsfuynoMoNzKyF0I0AGnsGa5FlNVAQ=;
        b=HDTnHavxpnntVt2ADSohx0p4fYG9+wPk2TXk9vVh7m1CIq9Ujuu8VQXip2kd/Op4Kg
         vPXtCOv9TJVXtBXUspGwsjQy57Yj0UHUwar92dOcyENB0igxE3/11Mpu7wLzSVfUty5h
         BMe/wa0Ejw/3Cmb07GnpJGoxPbykTYdtmsH3WzNM213+iZN6MiTo7u4L8AJFz/PMNsvg
         tw07Ci93ps8LbM2eLvQVrU3LSOURbt6zYDCzVGxZn3DaJhR3qCPP/cq3Xl1xHxIhMZX4
         Uanx5lNPTqiTf8B9qd9JNsv+tq4t7B6HTELlYKwTWZjjDNULvJ4nmIhNyzc8e1L4F1FT
         7n9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765572879; x=1766177679;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FXn5oKHBMgqIJsfuynoMoNzKyF0I0AGnsGa5FlNVAQ=;
        b=AT52FzdZrhESKnemnyvh3IMtUwtg0cw58XnTdtADKPGokSfdnZCL1CLeTjXwgazVNA
         mFdBVY+PtSrvPipiGK336Dzd2jY2R0wFpeKHqYVqdYG+8bUl/uZ0BWLT/08vyvGiK9tH
         sXh7utmPSBg/qGJxx0/cfQMeHFJYdJYfcrGwMKTONz0ymOyTTg2VT1pQpjxdR4Zxq9+W
         1DLwPzBZImCPW+wEytguoMWdSzhGP1bgw+QiyNnXNNDmiiBqAQRDh+e8qxQyergh02k9
         1k4WfHPoSUaoT8tP2uAhQsjtVNufEVHzQ9npEyBql8eIxhmXtp864wePMJMr6bU/Y5qu
         eb8w==
X-Forwarded-Encrypted: i=1; AJvYcCX09xwDAhwhUCcPWWLVzCrVfZahtwKL5enrkJjiBch3C/xsCMUBZ0zqLI7JveoPEdfkrhk9hkU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPdvaAfDxwwWRIfe6B40mUEXp4w5b/Ml5tdMhrZYen+IkNIFpO
	ozE2Adsw80lYn/tcwJyQ3jabStaFvZGaskiQYGsZ/d1Cag2ZF3UUB0B5KF9p2l3Zj+50HjFHdZW
	iHRWdQ0exSQG34HL8/aYwq3UuTA==
X-Google-Smtp-Source: AGHT+IH6fb4UumzYsfcjXdyetsttD/1JFDYI7F758xyq6M3c7XHveoyP9rAiScoRQhR1KR8axHNUmY6AiGo2XvKjTQ==
X-Received: from oaeh14.prod.google.com ([2002:a05:6870:170e:b0:3f5:b0db:411a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1814:b0:450:d504:9295 with SMTP id 5614622812f47-455ac957f68mr1619808b6e.44.1765572879590;
 Fri, 12 Dec 2025 12:54:39 -0800 (PST)
Date: Fri, 12 Dec 2025 20:54:38 +0000
In-Reply-To: <aTiRG0I1FZzntHtH@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 13:14:03 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntv7ib2zg1.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 12/24] KVM: arm64: Use physical PMSELR for PMXEVTYPER
 if partitioned
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> On Tue, Dec 09, 2025 at 08:51:09PM +0000, Colton Lewis wrote:
>> Because PMXEVTYPER is trapped and PMSELR is not, it is not appropriate
>> to use the virtual PMSELR register when it could be outdated and lead
>> to an invalid write. Use the physical register when partitioned.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/include/asm/arm_pmuv3.h | 7 ++++++-
>>   arch/arm64/kvm/sys_regs.c          | 9 +++++++--
>>   2 files changed, 13 insertions(+), 3 deletions(-)

>> diff --git a/arch/arm64/include/asm/arm_pmuv3.h  
>> b/arch/arm64/include/asm/arm_pmuv3.h
>> index 27c4d6d47da31..60600f04b5902 100644
>> --- a/arch/arm64/include/asm/arm_pmuv3.h
>> +++ b/arch/arm64/include/asm/arm_pmuv3.h
>> @@ -70,11 +70,16 @@ static inline u64 read_pmcr(void)
>>   	return read_sysreg(pmcr_el0);
>>   }

>> -static inline void write_pmselr(u32 val)
>> +static inline void write_pmselr(u64 val)
>>   {
>>   	write_sysreg(val, pmselr_el0);
>>   }

>> +static inline u64 read_pmselr(void)
>> +{
>> +	return read_sysreg(pmselr_el0);
>> +}
>> +
>>   static inline void write_pmccntr(u64 val)
>>   {
>>   	write_sysreg(val, pmccntr_el0);
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 0c9596325519b..2e6d907fa8af2 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1199,14 +1199,19 @@ static bool writethrough_pmevtyper(struct  
>> kvm_vcpu *vcpu, struct sys_reg_params
>>   static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct  
>> sys_reg_params *p,
>>   			       const struct sys_reg_desc *r)
>>   {
>> -	u64 idx, reg;
>> +	u64 idx, reg, pmselr;

>>   	if (pmu_access_el0_disabled(vcpu))
>>   		return false;

>>   	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
>>   		/* PMXEVTYPER_EL0 */
>> -		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu,  
>> PMSELR_EL0));
>> +		if (kvm_vcpu_pmu_is_partitioned(vcpu))
>> +			pmselr = read_pmselr();
>> +		else
>> +			pmselr = __vcpu_sys_reg(vcpu, PMSELR_EL0);

> This isn't preemption safe. Nor should the "if (partitioned) do X else do  
> Y" get
> open-coded throughout the shop.

Okay. I had not known the register access stuff wasn't. I'll fix that.


> I would rather this be handled with a prepatory patch that provides
> generic PMU register accessors to the rest of KVM (e.g.
> vcpu_read_pmu_reg() / vcpu_write_pmu_reg()). Internally those helpers
> can locate the vCPU's PMU registers (emulated, partitioned in-memory,
> partitioned in-CPU).

That seems like a good idea.

> Thanks,
> Oliver
