Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365E2F6577
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 21:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765573617; cv=none; b=fRnpkZCo0n7WPB/NH/2hAyb/fYjym2dD9JdRcVqB3iwpRfqqYituqwzKmvo4KqLkbWxwDaZCV0NVoJxQ/SryuRh94rPEc7yjIteoiUwqYQjTOlApsxQCNOvCq3N/iGWAWVL1Aibw4j73y3hJRIBJG+f8yHZvDwvyhaRPR6D20Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765573617; c=relaxed/simple;
	bh=j4zmNXaHcAhBlyQ7iWB1i9Dwg1d4I/P9T1rUCk2IZys=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=oigxpBehvCYb8VUzqySkX655ZSYDETbwj+kKVcWzUzVrZwiJE8tD1YgJL5Jipbg97PM0aG8ZmMYlZ0mWH8VFo1mrpWGQiMCs4Ft4XJ0L5STDElLS+VXsWRu2VFEkuPhWRpQZ439pzYNBzD80GF9qWT9JxsrGMgFUf3J4obVHaoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BaL7Zs5H; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BaL7Zs5H"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c7046514a2so1503893a34.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 13:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765573614; x=1766178414; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NvEO8IWge7rjEvmTvBLfyyCkg8YrPNESaGlmNB9KmuA=;
        b=BaL7Zs5Hd6ZSaspW8zp/ZVch1w61zbp+nIzoZ8YCU9dAlgNErTI4W3R78d4bFkn8lQ
         Z3MR8SyqLL/zBh7Pp7LKQlJ9HqplWQozKsaySWO46+d4Km1jquCMBaM7zTm9CCwVA+NM
         KPTDvA1peH0qenClKQfPKuWlSAajDbFNO8cZaDYwJK3aZI20YIHThHrjIJjxUMjEttEP
         RiB2cWCM2P8yGyctFKPjH0EqBqjd/iYV5o7IUywnl64l0vl4bEYmRYE0EP3JCT2r88rZ
         ZEh5IroJcqpXPeIRu7Bmn2L4VnSdw8+KWxuCgFqcfF11L1v6okgVdOJ4kXyQ4sxJbV1Z
         1okg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765573614; x=1766178414;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvEO8IWge7rjEvmTvBLfyyCkg8YrPNESaGlmNB9KmuA=;
        b=EkNJ6KGbiK1pR5Fw/cCyyZc8j/0np02/FrwSlUD2+1maf9I3OTtPk+9bEKyzbrtXpD
         54AAZhhv56jN2YUSqq98SdrGTYCu7MjLOtskzbxlPwLMio5aDSDCqmXgQF/yEsaSwKmC
         Q7YTeYzQk2C27FVTXnJ4begWdBpBNcIDSd/b3gcBkLDyQpkWFmCiLn1FTK3G/1ybWnT9
         aOgmMUctC7JOlZOmVhZtyxKU8OEWs/Nx5b0qEJYwb+tdJ23oL7n21NN+Gsw/XJVMQpPo
         KUXfChOdUbUxy99THzmCiHMkKaWQoug1ZDS3Cp1v12Wb6tMsr/N0+FBh/lmIkSaXpQgM
         pW5w==
X-Forwarded-Encrypted: i=1; AJvYcCXk3GZZAnwFDrtuIHE6a77WFpcr+LKrvFH85IO3MIOTQMIlfHSQXnf7E+NsgAD3rR0ZYiJrGMQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx32K/GTdbyzBvGeuUyVSbH8/FIZeWpTQJzfvP40LuilfwSeZAr
	kyUtTdFWlfeZz2SLD2yIXdjo1s1yGp4EwrB0wJC53cZR5xLlqw8nJ4qLa5b5OvrUQ0Soz3Eot30
	UO+G3egx7eYgHwUpoBPEAAYNRVw==
X-Google-Smtp-Source: AGHT+IGLtIUbFameZTVObRWcG+lq04RJyrGiyVy+qxibJohcLHDXgLx6kR5HPWzG4MF6bmkp/GMqRXiYMN5HlbpHeg==
X-Received: from ilbcb7.prod.google.com ([2002:a05:6e02:3187:b0:430:c30d:ac37])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1899:b0:659:9a49:8dde with SMTP id 006d021491bc7-65b45172277mr1612721eaf.32.1765573614348;
 Fri, 12 Dec 2025 13:06:54 -0800 (PST)
Date: Fri, 12 Dec 2025 21:06:53 +0000
In-Reply-To: <aTiSTODjzaLzwAPN@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 13:19:08 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntsedf2yvm.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 13/24] KVM: arm64: Writethrough trapped PMOVS register
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

> On Tue, Dec 09, 2025 at 08:51:10PM +0000, Colton Lewis wrote:
>> Because PMOVS remains trapped, it needs to be written through when
>> partitioned to affect PMU hardware when expected.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/include/asm/arm_pmuv3.h | 10 ++++++++++
>>   arch/arm64/kvm/sys_regs.c          | 17 ++++++++++++++++-
>>   2 files changed, 26 insertions(+), 1 deletion(-)

>> diff --git a/arch/arm64/include/asm/arm_pmuv3.h  
>> b/arch/arm64/include/asm/arm_pmuv3.h
>> index 60600f04b5902..3e25c0313263c 100644
>> --- a/arch/arm64/include/asm/arm_pmuv3.h
>> +++ b/arch/arm64/include/asm/arm_pmuv3.h
>> @@ -140,6 +140,16 @@ static inline u64 read_pmicfiltr(void)
>>   	return read_sysreg_s(SYS_PMICFILTR_EL0);
>>   }

>> +static inline void write_pmovsset(u64 val)
>> +{
>> +	write_sysreg(val, pmovsset_el0);
>> +}
>> +
>> +static inline u64 read_pmovsset(void)
>> +{
>> +	return read_sysreg(pmovsset_el0);
>> +}
>> +
>>   static inline void write_pmovsclr(u64 val)
>>   {
>>   	write_sysreg(val, pmovsclr_el0);
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 2e6d907fa8af2..bee892db9ca8b 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1307,6 +1307,19 @@ static bool access_pminten(struct kvm_vcpu *vcpu,  
>> struct sys_reg_params *p,
>>   	return true;
>>   }

>> +static void writethrough_pmovs(struct kvm_vcpu *vcpu, struct  
>> sys_reg_params *p, bool set)
>> +{
>> +	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
>> +
>> +	if (set) {
>> +		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
>> +		write_pmovsset(p->regval & mask);
>> +	} else {
>> +		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(p->regval & mask));
>> +		write_pmovsclr(p->regval & mask);
>> +	}

> There's only ever a single canonical guest view of a register. Either it  
> has
> been loaded onto the CPU or it is in memory, writing the value to two
> different locations is odd. What guarantees the guest context is on the
> CPU currently? And what about preemption?

My thinking here was pmovs is trapped so the "canonical" view is in
memory, but the guest still expects it to have an effect immediately.

Otherwise we would have to wait until the next load before the value
makes it to hardware. Are you okay with that latency? I'm not sure
how well that's going to work. Consider PMEVTYPER as an example. If I
don't write it to hardware immediately, a guest may expect a counter to
start counting as soon as it is written, but if it's only in memory the
counter won't start until the next load.

Echoing discussion on the previous patch, I wasn't aware preemption was
possible while servicing these register writes. I'll figure out how to
account for that.
