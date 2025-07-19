Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9D078F3A
	for <kvmarm@lists.linux.dev>; Sat, 19 Jul 2025 05:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752904472; cv=none; b=BorIIdXlz6UKLbDHxxndytfRaYvWyu+wQ+2QoNti+9CoVH4efzSd3ljyFMFdFP+1EuqvDd9O+0U7L8GdKiMJEygtREYFIUwiNt18RblSww0o2NpP+JHFjVCoVXS7KlkpWf5IaHDBRha1UOwSd2zsd84e+jjrLl+0L4oYjNuK0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752904472; c=relaxed/simple;
	bh=z6chSU3eFDIu7oSauxwGG+lVTiDwXpBG7DUNIBDDZrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAvSlQathLB06jPc3oW/f6Ab7wMaVF7maAzFsjvpjfhkiQfQ8Nhw930cqF+yhp7XhEwaeN5btHjhpgkNPZi/1uQruHQVYshjYoEmLAm4bWrklbaUfXCMO3NaH+kv1yOpqyXbmATjhs2h9+fH6Mn7nB+lLFW56tsxkn1h4sP0z2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=ObCTJDm1; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="ObCTJDm1"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-31ca042d3b8so2323732a91.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Jul 2025 22:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1752904469; x=1753509269; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5MAFw1hksH4hBe8O936uvTNwJh1WrybPOdWARRA6K2w=;
        b=ObCTJDm1sZ1SKkIWohtzVUHEgkEOVo/Q0Uah6AUxPusTOYxudlIcXDD5vDN5r+zQmg
         r/s2cBUGlUsEVmn/lFrhOwLaNCMZudOp4HBAt/6YRK+6kmiHRSAkBADeB++YWLqvJIRc
         DQXSjOPDp/PZpjVm3Mrfn2/tGb0kknkwf6shYJamPU9V8CImi8wj3mbMzJFvEoLYMxw/
         KsSkNyBMupWjxzKIhNxx9OumQK/O9xlvpDYSJHqu2hSm1gbXdNj3nbYDYCUZbqi0bdmS
         vHqzcqBoGJLpTniMWVL7Ree7ao1sjQfnEn3ai3Wus7ZOGubrgFL0wpXPNpRhbVqIrjcn
         h8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752904469; x=1753509269;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5MAFw1hksH4hBe8O936uvTNwJh1WrybPOdWARRA6K2w=;
        b=Dg8YeWL+jib48cdQs7bIvnFA7jqJUhBh/MDtN6qjh7+LrTWnkRK64I3KEAYETVYl6U
         bhyiKMPazaqF+wkVaPUBTiyHgTvtM2hgwpvuGJgr4XFHxvSb3UzTwO51/7q/zi+Jyfc1
         ZzPXsBstf/sCYn7qoO1l2NPT3We3n+c5h0l5HdEDMHZLBNGv55DRx9koCsHZq9QyLvUL
         PGUn181SALds2hkIu1l85S4sup5eJfNBPKfP7NBmhlE4phpbtcFWG1Qs6DAqr3NVAY8n
         hfyekOOMs04iY8KKHAPR6/MVYeRxxwbr47/PfZ6duhiR5PiXGQmGZhd/DTawNpRdXJW+
         l6Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXrUTXLuv8u29Ak1DRRDRc8Ye9R8tj+vEGmaKcHxLHW8npbP7yCyGLwW9/6waCkIh36cYH5DNs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9F1jrkodWsr+nwVeEG2aHyAw/A/Yg4lKIeXDG87xgUS+efMAi
	nJIAuOlWJvqQ4dsmkbSeW6bOmye1skewcU3smFXA/9ymMtheoOWOTizHOyFV2qfigu0=
X-Gm-Gg: ASbGnctkVoBR8jJjmRDsxQcYU/iCjnqh9SmfXhtOMjsS1qChgvRfdnXNQNIXBDRa7D+
	ujBz1+SOw7qWd+f4jwQmDIpEVoDNdyuvU0I4pYguu7RlaIfloMpHIINLehv7Cae5RJhjU7+BfIK
	zNIb3M86BMLLEAakL08PcVd80iO/9ffu3hvtetG1H+GjO3gL+GmCwdClXLuHDZ0pkXRUHf4WwCo
	NK5aYalQbA7kAZBimP1vUVV3ik/WVsZNy9fJGRNE3tn4Ke/Vz1v7zEgqNtQwJQYtHQWwdS05c/g
	SxsQUFtxBM/W9c8Q7z95Qc9c8U2xjbNoslW1BDwVsyqHe91PPCFdFvPknzIJFtZi+kIn1FFWFs8
	kdOJ+xQwblv+TYQWM/FlyxaTO6U2b9TLlYS9zM9nx7dWK+44JTwQlo9w/NkYkEeQ4E/fVYrDN61
	Sp8FpuE0aFyEzVrC3nvhFkfJx7Qvk=
X-Google-Smtp-Source: AGHT+IHA4ElNc5+YCunjXEAwqNpAKoUCVte5EKyMqMBM9+3Z43HkX9cWDPqipqHYDun8x/JIX6UYAQ==
X-Received: by 2002:a17:90b:5244:b0:312:db8:dbd2 with SMTP id 98e67ed59e1d1-31c9e75b9bcmr19779516a91.19.1752904469406;
        Fri, 18 Jul 2025 22:54:29 -0700 (PDT)
Received: from ?IPV6:2605:a601:a778:5100:80e3:c2d2:8a77:af5c? ([2605:a601:a778:5100:80e3:c2d2:8a77:af5c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6b4b20sm22529185ad.121.2025.07.18.22.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 22:54:28 -0700 (PDT)
Message-ID: <67cc6766-6493-4171-a6b1-2a105c3e6ff5@immunant.com>
Date: Fri, 18 Jul 2025 22:54:27 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/5] KVM: arm64: Use SMCCC 1.2 for FF-A initialization
 and in host handler
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, perlarsen@google.com,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, ahomescu@google.com,
 armellel@google.com, arve@android.com, ayrton@google.com,
 qperret@google.com, sebastianene@google.com, qwandor@google.com
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-2-995afc3d385e@google.com>
 <8634bdbgaz.wl-maz@kernel.org>
 <3b10fa81-bfdd-4325-a330-c79df2e21621@immunant.com>
 <aHpOClH1k-3NhI_y@willie-the-truck>
Content-Language: en-US
From: Per Larsen <perl@immunant.com>
In-Reply-To: <aHpOClH1k-3NhI_y@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/25 6:37 AM, Will Deacon wrote:
> On Mon, Jul 07, 2025 at 05:06:23PM -0700, Per Larsen wrote:
>> On 7/3/25 5:38 AM, Marc Zyngier wrote:
>>> On Tue, 01 Jul 2025 23:06:35 +0100,
>>> Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org> wrote:
>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
>>>> index 2c199d40811efb5bfae199c4a67d8ae3d9307357..65d241ba32403d014b43cc4ef4d5bf9693813809 100644
>>>> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
>>>> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
>>>> @@ -71,36 +71,68 @@ static u32 hyp_ffa_version;
>>>>    static bool has_version_negotiated;
>>>>    static hyp_spinlock_t version_lock;
>>>> -static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
>>>> +static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
>>>>    {
>>>> -	*res = (struct arm_smccc_res) {
>>>> +	*res = (struct arm_smccc_1_2_regs) {
>>>>    		.a0	= FFA_ERROR,
>>>>    		.a2	= ffa_errno,
>>>>    	};
>>>>    }
>>>> -static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
>>>> +static void ffa_to_smccc_res_prop(struct arm_smccc_1_2_regs *res, int ret, u64 prop)
>>>>    {
>>>>    	if (ret == FFA_RET_SUCCESS) {
>>>> -		*res = (struct arm_smccc_res) { .a0 = FFA_SUCCESS,
>>>> -						.a2 = prop };
>>>> +		*res = (struct arm_smccc_1_2_regs) { .a0 = FFA_SUCCESS,
>>>> +						      .a2 = prop };
>>>>    	} else {
>>>>    		ffa_to_smccc_error(res, ret);
>>>>    	}
>>>>    }
>>>> -static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
>>>> +static void ffa_to_smccc_res(struct arm_smccc_1_2_regs *res, int ret)
>>>>    {
>>>>    	ffa_to_smccc_res_prop(res, ret, 0);
>>>>    }
>>>>    static void ffa_set_retval(struct kvm_cpu_context *ctxt,
>>>> -			   struct arm_smccc_res *res)
>>>> +			   struct arm_smccc_1_2_regs *res)
>>>>    {
>>>> +	DECLARE_REG(u64, func_id, ctxt, 0);
>>>>    	cpu_reg(ctxt, 0) = res->a0;
>>>>    	cpu_reg(ctxt, 1) = res->a1;
>>>>    	cpu_reg(ctxt, 2) = res->a2;
>>>>    	cpu_reg(ctxt, 3) = res->a3;
>>>> +	cpu_reg(ctxt, 4) = res->a4;
>>>> +	cpu_reg(ctxt, 5) = res->a5;
>>>> +	cpu_reg(ctxt, 6) = res->a6;
>>>> +	cpu_reg(ctxt, 7) = res->a7;
>>>
>>>   From DEN0028G 2.6:
>>>
>>> <quote>
>>> Registers W4-W7 must be preserved unless they contain results, as
>>> specified in the function definition.
>>> </quote>
>>>
>>> On what grounds can you blindly change these registers?
>>  From DEN0077A 1.2 Section 11.2: Reserved parameter convention
>>
>> <quote>
>> Unused parameter registers in FF-A ABIs are reserved for future use by the
>> Framework.
>>
>> [...]
>>
>> The caller is expected to write zeroes to these registers. The callee
>> ignores the values in these registers.
>> </quote>
>>
>> My read is that, as long as we are writing zeroes into reserved registers
>> (which I believe we are), we comply with DEN0026G 2.6.>
> 
> Right, the specs make this far more difficult to decipher than necessary
> but I think SMCCC defers to the definition of the specific call being
> made and then FF-A is basically saying that unused argument registers
> are always zeroed.
> 
> Rather than have the EL2 proxy treat each call differently based on the
> used argument registers, we can rely on EL3 doing the right thing and
> blindly copy everything back, which is what you've done. So I think
> that's ok.
> 
>>>> +
>>>> +	/*
>>>> +	 * DEN0028C 2.6: SMC32/HVC32 call from aarch64 must preserve x8-x30.
>>>> +	 *
>>>> +	 * The most straightforward approach is to look at the function ID
>>>> +	 * sent by the caller. However, the caller could send FFA_MSG_WAIT
>>>> +	 * which is a 32-bit interface but the reply could very well be 64-bit
>>>> +	 * such as FFA_FN64_MSG_SEND_DIRECT_REQ or FFA_MSG_SEND_DIRECT_REQ2.
>>>> +	 *
>>>> +	 * Instead, we could look at the function ID in the response (a0) but
>>>> +	 * that doesn't work either as FFA_VERSION responses put the version
>>>> +	 * number (or error code) in w0.
>>>> +	 *
>>>> +	 * Set x8-x17 iff response contains 64-bit function ID in a0.
>>>> +	 */
>>>> +	if (func_id != FFA_VERSION && ARM_SMCCC_IS_64(res->a0)) {
>>>> +		cpu_reg(ctxt, 8) = res->a8;
>>>> +		cpu_reg(ctxt, 9) = res->a9;
>>>> +		cpu_reg(ctxt, 10) = res->a10;
>>>> +		cpu_reg(ctxt, 11) = res->a11;
>>>> +		cpu_reg(ctxt, 12) = res->a12;
>>>> +		cpu_reg(ctxt, 13) = res->a13;
>>>> +		cpu_reg(ctxt, 14) = res->a14;
>>>> +		cpu_reg(ctxt, 15) = res->a15;
>>>> +		cpu_reg(ctxt, 16) = res->a16;
>>>> +		cpu_reg(ctxt, 17) = res->a17;
>>>> +	}
>>>>    }
>>>
>>> I don't see how that can ever work.
>>>
>>> Irrespective of how FFA_MSG_WAIT actually works (and I couldn't find
>>> anything in the spec that supports the above), the requester will
>>> fully expect its registers to be preserved based on the initial
>>> function type, and that alone. No ifs, no buts.
>>>
>>> If what you describe can happen (please provide a convincing example),
>>> then the spec is doomed.
>>
>> DEN0077A 1.2 Section 8.2 (Runtime Model for FFA_RUN) and 8.3 (Runtime Model
>> for Direct request ABIs) contains Figures 8.1 and 8.2. Each figure shows
>> transitions between states "waiting", "blocked", "running", and "preempted".
>> Key to my understanding is that the waiting state in Figure 8.1 and Figure
>> 8.2 is the exact same state. This appears to be the case per Section 4.10.
>>
>> So we have to consider the ways to get in and out of the waiting state by
>> joining the state machines in Figures 8.1 and 8.2. Figure 8.1 has an edge
>> between "running" and "waiting" caused by FFA_MSG_WAIT. Figure 8.2 has an
>> edge between "waiting" and "running" caused by a "Direct request ABI".
>>
>> Direct request ABIs include FFA_MSG_SEND_DIRECT_REQ2 which is why the FF-A
>> 1.2 spec, in my read, permits the response to a 32-bit FFA_MSG_WAIT call can
>> be a 64-bit FFA_MSG_SEND_DIRECT_REQ2 reply.
> 
> That seems bonkers to me and I agree with Marc's assessment above. The
> SMCCC is crystal clear that a caller using the SM32/HVC32 calling
> convention can rely on x8-x30 (as well as the stack pointers) being
> preserved. If FF-A has a problem with that then it needs to be fixed
> there and not bodged in Linux.
Ack. Patchset v8 addresses Marc's feedback by using the func_id detect 
SMC64 instead.>
> Setting that aside, I'm still not sure I follow this part of your check:
> 
> 	if (... && ARM_SMCCC_IS_64(res->a0))
> 
> won't res->a0 contain something like FFA_SUCCESS? The FFA spec states:
> 
>    FFA_SUCCESS64, is used only if any result register encodes a 64-bit
>    parameter.
> 
> which doesn't really seem related to whether or not the initial call
> was using SMC32 or SMC64. What am I missing?I agree that we cannot use res->a0 to distinguish SMC32/SMC64 for the 
reason you stated.
