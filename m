Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4FC17B402
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756736212; cv=none; b=X9DNTKjbaCzvqzjZFI5v9qfJeoDkIWLwekTbXStXHVh+BxnCUaW1bvlG+BUKF8onptvyS4UuCk5IMzcxdvKc+CmZUamoeJGnUVAnFyGmRKQ7jickV/tRcx8wK+S61OUI7NfELMvWePgMaaM7isSax9nCqR/UMff/RC3D8H/AhB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756736212; c=relaxed/simple;
	bh=jt+tul4E9f3ksTeOn/sSTakfsjMH5U1DeVEhi6a5AEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pU7nmkxw6iwoIRQ0oS2DSY6gr7Q60xCj88Fq0+ySzd/CtIXXWe49px2nxxONnD1HMbKfMmuDzLJtEvdE0d7oR11CGplJVaWWvoXka82avASSjiAx8v/Flsoi5fsHxrZd5dVSOHFeg3WWLr0g/KJXBedAbf+tr6uMiRVNLA4a/Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BymF0noq; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BymF0noq"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3d1bf79d758so1835061f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756736209; x=1757341009; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iESc6dfW9RcmL1rZ9bcUT9E2jgBG3o06ZEwcLauMwJI=;
        b=BymF0noqtrq5QVBdOoBVGGXre86NRvKsUhAz6l6cQWFl0gseHurnsIflqs9YSkMYWu
         NHNgr6ACcjMJ4z47WibRgtVAZVMRmXwwnLz6NWwPvFY+xXPUSS3Z6nzE64JWNofn7zlY
         GyFt+SEB52axgCoA3PJOAixaxWBU49AV6fKpPxPagIKfqylN5poAfiw/1v8mZWhWRqMU
         fZcKSZMGxwPBf+uNEq/ZvBctDcvnlOo4IwxG1koLkS1IMva2kyaiJoqC0fx/dlpDmhFi
         cXtmHx4o0DA81shNgWKEWxwq+nPWRJ92DvLqr0iTOdO9OSPPNyxxPXBM6bRZSllSyWtd
         SXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756736209; x=1757341009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iESc6dfW9RcmL1rZ9bcUT9E2jgBG3o06ZEwcLauMwJI=;
        b=uK4XERYAYH/AKVEKmo4lurhqxwbh2fIwVetGhVetcMUc0I4g78vhwKg3g6sXrAZJQl
         1UjcV2D9CE9DE0L1GYwTupD71Fy0eG92+H9j4Yfm0ShrXkfrA8aamKKpKeOMxEuddqP1
         4RyXSI5ngc/Gd3lubJB5TDg8lElg19FMA8gIiaM6bkJTcgGk3ZbTy8buIJw7OfoAob+5
         sSBOBo/xlmtpGnsvverpOvwXbXBEWZ0h6aCIZ4A0ayX7SHlC2xy2riOmKpi7H7moVGTY
         jRYscdvE0V096HW3gD8pPPosnfptA2raeUlQGVGsqgWlek3Di+KTMcHn/Jfm0c2KQTQS
         SwNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV33xfBYlLvG+YtXlMrtQ9c1mLV5bCy+xJ3y1qHCK1tSHZ6wLDlFTyf3mFLG4ml9IlqvDVuttk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAr/6RR4SDvhepcbcGGd2MsbVpHsGiWdUs+kngf5BKd6XXMG+h
	AUpsI+25qn9W/ZPl4ptYLM31Hgtt15UwxbYeC3dclYyPOcWOB1qqOBKWQ8MSErncCtA=
X-Gm-Gg: ASbGncvW4TFsuCN31NZgIYrgjUnVglEpBsCWZkohJm7oWh7h1N/VJNv2wKbirbuo48j
	GWzjfxRLWWQNc4RHKFIQ5VidtYG38B+JkaViu3ttXovMdVMwC3lP8eNoWmlJA4EaaRSXQHcXjF5
	6UmJjIY/HzxgHYs7SIimRwa2EZ1CUYoMJFejDSFG1Jo7yfV+kZD54UrAfF7PANwLYxG6vTIWpwz
	v/qNuLSbBOjCikqorpFRnJJxs9F9lJ09bhtK3N+rtxHnJx9JeeX22L5bAAqlZ2hEiiZTDCymq8E
	KVCCN5Dap07gkMYwmno57jtf9NZ3mt/bjDjyOP4EuKVhncII90XlQUNjkVWeNIQCHi1UfRuMrBb
	T/X2QmOvzvybIZM1JH7JIi+ZxLhU=
X-Google-Smtp-Source: AGHT+IHlQJYM2HX5g9ub7kOJOAXNXL4BWDzftuXNNBg0pmc4Ys0RWFLMX49ejuXDiUIn/rslt0RP/A==
X-Received: by 2002:a05:6000:4021:b0:3ce:e9d6:ad24 with SMTP id ffacd0b85a97d-3d1e05bab3dmr5752072f8f.50.1756736209038;
        Mon, 01 Sep 2025 07:16:49 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d21a32dbc5sm11053282f8f.11.2025.09.01.07.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 07:16:48 -0700 (PDT)
Message-ID: <239f2e3d-1fb5-4d53-869f-aba2d7a6530d@linaro.org>
Date: Mon, 1 Sep 2025 15:16:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Fix NULL pointer access issue
To: Marc Zyngier <maz@kernel.org>,
 Yingchao Deng <yingchao.deng@oss.qualcomm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, quic_yingdeng@quicinc.com,
 jinlong.mao@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20250901-etm_crash-v1-1-ce65e44c137c@oss.qualcomm.com>
 <450f11c2-6c11-4ffa-ae20-db4ea419a3ca@linaro.org>
 <863496e4yg.wl-maz@kernel.org>
 <80178c90-b9f3-4e1f-baa5-f54aa89ec927@linaro.org>
 <86y0qycnb8.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <86y0qycnb8.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 01/09/2025 2:30 pm, Marc Zyngier wrote:
> On Mon, 01 Sep 2025 13:31:23 +0100,
> James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 01/09/2025 1:24 pm, Marc Zyngier wrote:
>>> On Mon, 01 Sep 2025 11:36:11 +0100,
>>> James Clark <james.clark@linaro.org> wrote:
>>>>
>>>>
>>>>
>>>> On 01/09/2025 11:01 am, Yingchao Deng wrote:
>>>>> When linux is booted in EL1, macro "host_data_ptr()" is a wrapper that
>>>>> resolves to "&per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)",
>>>>> is_hyp_mode_available() return false during kvm_arm_init, the per-CPU base
>>>>> pointer __kvm_nvhe_kvm_arm_hyp_percpu_base[cpu] remains uninitialized.
>>>>> Consequently, any access via per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)
>>>>> will result in a NULL pointer.
>>>>>
>>>>> Add is_kvm_arm_initialised() condition check to ensure that kvm_arm_init
>>>>> completes all necessary initialization steps, including init_hyp_mode.
>>>>>
>>>>> Fixes: 054b88391bbe2 ("KVM: arm64: Support trace filtering for guests")
>>>>> Signed-off-by: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
>>>>> ---
>>>>> Add a check to prevent accessing uninitialized per-CPU data.
>>>>> ---
>>>>>     arch/arm64/kvm/debug.c | 7 ++++---
>>>>>     1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>>>>> index 381382c19fe4741980c79b08bbdab6a1bcd825ad..add58056297293b4eb337028773b1b018ecc9d35 100644
>>>>> --- a/arch/arm64/kvm/debug.c
>>>>> +++ b/arch/arm64/kvm/debug.c
>>>>> @@ -233,7 +233,7 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
>>>>>     void kvm_enable_trbe(void)
>>>>>     {
>>>>>     	if (has_vhe() || is_protected_kvm_enabled() ||
>>>>> -	    WARN_ON_ONCE(preemptible()))
>>>>> +	    WARN_ON_ONCE(preemptible()) || !is_kvm_arm_initialised())
>>>>
>>>> Hi Yingchao,
>>>>
>>>> There shouldn't be a warning for this, at least for the case where
>>>> it's not initialized and never will be. If you're never going to run a
>>>> guest these functions can all skip, the same way for !has_vhe() etc.
>>>
>>> It's not a warning. It's a bona-fide crash:
>>>
>>> void kvm_enable_trbe(void)
>>> {
>>> 	if (has_vhe() || is_protected_kvm_enabled() ||
>>> 	    WARN_ON_ONCE(preemptible()))
>>> 		return;
>>>
>>> 	host_data_set_flag(TRBE_ENABLED); <--- Explodes here
>>> }
>>>
>>> So the write of the flag has to be skipped if KVM is available, even
>>> if KVM is compiled in.
>>>
>>> 	M.
>>>
>>
>> Yeah. And just in case there is any confusion, I didn't mean that we
>> should not have the check entirely, just that it shouldn't be in the
>> WARN_ON_ONCE(). We should put it in the part that makes the functions
>> silently skip:
>>
>>    if (has_vhe() || is_protected_kvm_enabled() ||
>>        !is_kvm_arm_initialised() ||
>>        WARN_ON_ONCE(preemptible()))
>>            return;
> 
> Which is exactly what the OP wrote, except for swapping the last two
> terms.
> 
> 	M.
> 

Hah! So it is. Being on the same line as the warning really threw me 
despite looking at it 10 times.

Not sure if it's just me but I think having the warning at the end or on 
its own line is more readable.

Either way:

Reviewed-by: James Clark <james.clark@linaro.org>




