Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09C5238C08
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765575109; cv=none; b=EOlKQ0ADjadkf4MuqohfeWkAsDxKb3yyRaY5eqbr7JuZ36Aat2pxMjn40n3FgjT9szIOs9T9ITolOGUqY3ymMcEs9zdjqMyhbq0AiGY/Mon9MFp0XMmmgwFxheBotAdYDDteakSpL+7pADaVY1kJjGCyWuQZF5HSZn6509MwXG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765575109; c=relaxed/simple;
	bh=3l391GJrmu2vQ09ks1w9jqj02asnWMy1KuP+zG+MYE8=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=IoslbgtvD/T5gX5bUse2Rb51cdXgsLUhFqvHMDTewyJo3j8cXPQajphDct2cFbNGLlK2r0Ekbf1P9DnXv9pjyI5DvvQ0KRK50oGl33lwUDyTqovK4oJ6vGOHg5xq6LzdIvJC8nYTQqe5ZRYHfuofRE12CPxfKm1cICC6qE5nQQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x/PTMRqN; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x/PTMRqN"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65b325457e5so1404119eaf.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 13:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765575107; x=1766179907; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=glFaNkoh8KYWfLmCHCO0uc2mAujAPglg5i0xIpFSAo0=;
        b=x/PTMRqNx7S43OHTaEYZZ72UhB54tIriV6aDNjCqD/goUKDejvSVLLAZ4qtzD47Hb2
         OyNXLSUZ+Agn9s2RGpOtwJqUscP0v31wC6ZvKn9cypLBkqA3MGo4gk7YWrnWWARy6Tu4
         Yf4jnGTrSEcpnQJHCLNRbAvGvg2ruElFg2VIZeBUj9tJ2+v3Nyq0aqGAsPMOJOwdPYIP
         X2lND5+WPRcCWB8c4Tre6GFX5S7Ka2p5r/qzX+ABS+PD+EiWTT9rRzoCCn8+jI+s/AAG
         tpLPL7yQ8Zv0Du5Wc5ZF5+ZskZNKqXuVpPsI08NgsmVp4QO4JkHE9hMm/QU9+j90TKVw
         xtaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765575107; x=1766179907;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=glFaNkoh8KYWfLmCHCO0uc2mAujAPglg5i0xIpFSAo0=;
        b=gIFo0ucwEWSoDkXRqV+GR3fdo+GyW+IpgTxaBW/0X/glcAvJtsleinA4+8HgqhH/WY
         bJtgHaL72u/pVRCzBTG9JXKVxWB2GjxDmE/L+AahIql9iX34L5U5CVnQUw6mkuGoqqVl
         gz2eedWeS2tESSQMtec7AykzhQzMps/y5vx+CRDS3zVw3D4pW2RReEtB44QnvVv+Gz/t
         QLczjoPkOFztj2CaKDhGfO3+ZdEGsnMNdQafhvgUdHi/ebQEDnLX8PR7pcfTmHCFJUVn
         SvuT4q0+jH/TxbZmgf3/JaGVoeoXeLwufUUBaXviJ8mPItXOpQLpj6bAsxLiKXqfVnOA
         deMA==
X-Forwarded-Encrypted: i=1; AJvYcCVUa13fZdke3OYc1z0mxxdjga1vTvGvLqgEkgvMZSYc4YIiFiXadUpTgWB02dZb5/u7KXupq94=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbOwOYSV/o9C1bKOIJU2rw6VDgvRzrvpKPa77DJXqhFPCP/Cwu
	jPh3CCwhSOTnmkuEupL8R9H37HL+dBo+GfbiSnVIKGuYRSHIJM9NxBZA9MDN7nbtHD1Pzx7R2Xa
	pWaI2t1KtXW24Z2x/FOK1Au+8Xw==
X-Google-Smtp-Source: AGHT+IFo/ZiQG26nv5+gQHvcotb1AIOm/8xhz9dzc9kzbBKDKtRIGeh0RuPM+qweY1hUtH68Xze57kOA5qfLCql13A==
X-Received: from ilbbb16.prod.google.com ([2002:a05:6e02:10:b0:42f:913a:9596])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1b0f:b0:659:9a49:8e83 with SMTP id 006d021491bc7-65b452c3646mr1638400eaf.83.1765575106969;
 Fri, 12 Dec 2025 13:31:46 -0800 (PST)
Date: Fri, 12 Dec 2025 21:31:46 +0000
In-Reply-To: <aTiWsAvK9krnEw7V@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 13:37:52 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntms3n2xq5.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 16/24] KVM: arm64: Account for partitioning in PMCR_EL0 access
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

> On Tue, Dec 09, 2025 at 08:51:13PM +0000, Colton Lewis wrote:
>> Make sure reads and writes to PMCR_EL0 conform to additional
>> constraints imposed when the PMU is partitioned.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/kvm/pmu.c      | 2 +-
>>   arch/arm64/kvm/sys_regs.c | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)

>> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
>> index 1fd012f8ff4a9..48b39f096fa12 100644
>> --- a/arch/arm64/kvm/pmu.c
>> +++ b/arch/arm64/kvm/pmu.c
>> @@ -877,7 +877,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu  
>> *vcpu)
>>   u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
>>   {
>>   	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
>> -	u64 n = vcpu->kvm->arch.nr_pmu_counters;
>> +	u64 n = kvm_pmu_guest_num_counters(vcpu);

> Why can't the value of vcpu->kvm->arch.nr_pmu_counters be trusted?

Similar to discussion on a previous patch, I need to move some
validation to the ioctl where it's set.

>> @@ -1360,7 +1360,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const  
>> struct sys_reg_desc *r,
>>   	 */
>>   	if (!kvm_vm_has_ran_once(kvm) &&
>>   	    !vcpu_has_nv(vcpu)	      &&
>> -	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
>> +	    new_n <= kvm_pmu_hpmn(vcpu))
>>   		kvm->arch.nr_pmu_counters = new_n;

> This is the legacy UAPI for setting the number of PMU counters by
> writing to PMCR_EL0.N.

> The 'partitioned' implementation should take a dependency on the
> SET_NR_COUNTERS attribute and reject attempts to change the value of
> PMCR_EL0.N. Just like nested.

Good! I hated making writes to PMCR_EL0.N work and only did it because
of selftests assuming it did.


> Thanks,
> Oliver
