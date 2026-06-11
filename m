Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71048339861
	for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 10:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781173409; cv=none; b=SQJJDsahOaQh5PHoRhxUGGLYXDT1ciT1XFbj6rdmU86FWbhCCxRg7i+K0VElE2p0ap0n2Q+gP+czoyX/kkdYlkgabRZ0foYPGMHCi0nDXz1HG8GqtR2XVnkjTrMvYf3a47+eGkAN1QIiFcWZllV3y6M3M0Lf6eciXynq5hs/Tdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781173409; c=relaxed/simple;
	bh=eD31NaAQdrh/zu+6IbhMqo/U/Qb0bYpibROp5yWND8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLpb39B2USHJmEh90dgrYQsMni6ei8JXq3zCImX7JhCXqL4TUnj8fzNthBjoqJcbLMaJHDTyGoK6EUiXl4z3W01KCGH9xmJRNp4ebEJ7Jm0mtwXiCF2MNRq84aiUKZieByIB1MlyAOdQufkDWU9IfDl/Vx3+IrdB4JiLW5XU/JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KEICe75V; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KEICe75V"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c8584e80bd9so3052099a12.3
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 03:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781173407; x=1781778207; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTQLbrDptBniTVJpw5ZWV9E0sbp4op67GXB1lfNz+Nc=;
        b=KEICe75VDGfSswauKIjrUnq98HX9ohLVKcV/PjXWfqnhup9dF96Q1D+aTriOFXG/Md
         km0qpOwHl8yLJ0i2bnZ9GSOwh05anGGnu6vPe4AIvaCwuOHTOd9emKRYxiT/twT7pdDG
         9rxRg/CbCMBky0ifX/BW6M3TxFUOq0d9LdmVZzuAAGoowEMsIwOxaSN2rhl9yBWWr+RQ
         X0MiqIfQLJbUvem5GhQaUVHKKuyzj7g4huoemjEwqMuxo1dFg2VcRZ2luOskdV9PIic8
         Yg+c0A95UKiAPtkcbuRvpOrQotT18IH3zPobT4/j9OaNvXYZbTuAh0VGQxo/QejitBtC
         so5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781173407; x=1781778207;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QTQLbrDptBniTVJpw5ZWV9E0sbp4op67GXB1lfNz+Nc=;
        b=UwNLQKVeCZiwSuJx65CRwHdrQKXF9GIzWh9rzO93kt4AvV0GilE2i1SrSlfbp6i3CL
         ZnOEX9vHhMfD6ngeyGTRpXZpXGnghPT1HukPR+zsFvfL6O3e7IrpeLS2UaJ21xsoMPLP
         HFEQxOZqSNHg7FpNKh1qKrMRAXu04Be/8uKbLpMvZ6ERSLJ7UR6GbnxOErVtFE3U4NCa
         quGbLkhXx0eNor0KBXZTXAeSRfZk52CgZW2TfcSC48390JcTK0yff/Do7IcD3p8Tx+do
         cCIuzgBYDrODSoO6JMCEJ4cscOGtGLSXdbCO9rB9KP1+La7IGqz3uFFCTVl9s+wGKa7/
         Vbvw==
X-Forwarded-Encrypted: i=1; AFNElJ/pqJuxOuG2rlV//MI+4Tka3aFLNgZkeEV5nR/uuzYz4RfTuZikCsk7B+FIa6hikCQVdBwG3GM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEg6KblM02Jzu9EuxHEH6xEB6ouyMGAWtRC/xy4LdCmf5rXul2
	1+64nwZTj3ocCK7FPCrBGYEL8Cj7rS7hr/Ssar2IAtWh4u2qCE/YctqB
X-Gm-Gg: Acq92OFXFqLe+yDe2BDzs9VTTSaDfpAfCis4OHTxAy9cDTWe+8qhGLoClzzl6zm+Gyx
	A9uZmvTObvqdVq414oe+tk2zm/MenlLOwkvaVVsjefPDvTqoSEWwL0ZSnYSHvFVZTDk/aaVANEh
	lWlQYDEQvkwIJssI/Nyfpm83lzMWVc/W3fRLfgWBMyXpr5dOZCiyi8QA9JD+6Baf1geLc9mgdYQ
	rA65Qw1DlCiiIruODpkHS2izRzjvL5unRJC+KrV3pDdZgqeAsAAUyJwbE7G8YhkA6D5l+ZgWrGl
	xZf5hZ5005vZLpmotFmPhk0kHxdVrLE5/laWwDB884D58+Kmctw3RoqeQpwYeH5c7PBp8Mp7KPK
	HoSm+dPwHSBDoDjpTzx8mzRDUQpDrQWrbPk/HR0w4hSJODt+i7JDaAL522m571ovV0FGVxh/lSP
	jlASYvo5qeolRf5GKZsK2NxIsgSM0=
X-Received: by 2002:a05:6a20:160f:b0:3b4:8268:23e8 with SMTP id adf61e73a8af0-3b5e334dd4bmr2445120637.21.1781173406766;
        Thu, 11 Jun 2026 03:23:26 -0700 (PDT)
Received: from [10.253.74.50] ([115.108.63.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c865861226fsm1473268a12.15.2026.06.11.03.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 03:23:26 -0700 (PDT)
Message-ID: <5f1cfbc0-8358-4f8e-86d1-85d160a31ea9@gmail.com>
Date: Thu, 11 Jun 2026 18:23:21 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: arm64: Skip unreset vCPUs in MPIDR lookup table
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev
References: <20260611090934.84469-3-fuqiang.wng@gmail.com>
 <20260611092823.6E5201F00893@smtp.kernel.org>
From: fuqiang wang <fuqiang.wng@gmail.com>
In-Reply-To: <20260611092823.6E5201F00893@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/26 5:28 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The `kvm_vcpu_mpidr_is_reset()` check unconditionally evaluates to false due to bitmasking and sign-extension bugs, causing the MPIDR lookup table to remain unpopulated and forcing a slow linear-search fallback for almost all vCPUs.
> --
> 
> commit 492eed93a0927af5d722a777b1e148b77bf39d93
> Author: fuqiang wang <fuqiang.wng@gmail.com>
> 
> KVM: arm64: Skip unreset vCPUs in MPIDR lookup table
> 
> This commit attempts to fix an issue where unreset vCPUs overwrite the MPIDR
> lookup table index for vCPU0 by skipping vCPUs that do not have the RES1 bit
> set in their MPIDR_EL1 value.
> 
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
> [ ... ]
>> @@ -506,6 +506,15 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
>>   	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>>   }
>>   
>> +/*
>> + * Check if MPIDR matches hardware reset value. RES1 bits are set after reset,
>> + * while a zero default indicates a vCPU that has not been reset.
>> + */
>> +static inline bool kvm_vcpu_mpidr_is_reset(u64 val)
>> +{
>> +	return (val & MIDR_RES1_MASK) == MIDR_RES1_MASK;
>> +}
> 
> [Severity: High]
> Does this check always evaluate to false due to sign-extension? MIDR_RES1_MASK
> is defined as (1 << 31), which evaluates to a signed 32-bit int. When compared
> against the unsigned 64-bit integer val, the mask is sign-extended to
> 0xffffffff80000000ULL.
> 
> Since val only contains the lower 32 bits, the bitwise AND will never match
> the sign-extended mask.
> 
> [ ... ]
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
> [ ... ]
>> @@ -884,6 +884,16 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
>>   		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
>>   		u16 index = kvm_mpidr_index(data, aff);
>>   
>> +		/*
>> +		 * In the CPU hot-plug scenario, the kvm_for_each_vcpu() macro
>> +		 * iterates over all possible vcpus. For vcpus that are not
>> +		 * reset, kvm_vcpu_get_mpidr_aff() returns 0, then the index
>> +		 * computed by kvm_mpidr_index() will also be 0, thereby
>> +		 * overwriting the original value of vcpu0.
>> +		 */
>> +		if (!kvm_vcpu_mpidr_is_reset(aff))
>> +			continue;
> 
> [Severity: High]
> Will this unconditionally skip all vCPUs?
> 
> The aff argument passed here is obtained from kvm_vcpu_get_mpidr_aff(), which
> masks the raw MPIDR value with MPIDR_HWID_BITMASK (0xff00ffffff). This
> explicitly clears bits 24-31, stripping the RES1 bit (bit 31) from the
> returned value before the check even occurs.
> 
> Because the check will always fail, the continue statement executes for
> every vCPU, leaving the cmpidr_to_idx table completely zero-initialized.
> This causes all MPIDR lookups to fail the cache verification check and
> permanently fall back to the slow linear search.
> 
>>   		data->cmpidr_to_idx[index] = c;
>>   	}
> 

I'm very sorry. I made a very low-level mistake and will fix it in the next
patch and also do sufficient checks and tests before sending out the patch...

fuqiang

