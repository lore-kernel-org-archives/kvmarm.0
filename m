Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FCA32BF37
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756729890; cv=none; b=Ue1AanVrKC9IQVIUJDX2pZCbVv+r84On+Cx23hsPPJmVITSJpKUaA5iYW0WiqYb8V6vCaLQWcI53t7a3ovp8KJHgZSwKWmuePki0cnAUbmmk4zM0U8wtxEmcTcYpReStjWUOpQO+iEDaAy75xw31rIelDh3o3bvNLWyygwIK7Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756729890; c=relaxed/simple;
	bh=iyLwVvKtSqvmkoT65Xghp9KzQmET6zudks0Ut550uSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqrF9DK5mLumx7oaxjEo6rsGAIsamgD3ErcprxxZWalgZLkJkhdmvJPpR746NHHyqz5UgOAqzPkYs0Sm7wqatcg+fMw+TIyobPv4/Pf31SIOgWb1QykLjYe4HKMd+ltSdDaEtud1tGM+DZq7YBTLMopbmLFxcSupxBZM8hajuzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nzsngdna; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nzsngdna"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ceb830dd58so2289605f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756729886; x=1757334686; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X4N+q8o8KXEkY16pL6AM0vbzSxIIo1LQ5f2tTSY1L9I=;
        b=NzsngdnaHFauOvj0+MHIHWL0kx8WuitnaS9JD3Gc9aIPECjDwSsB2rZVQNwXYPFdfJ
         uISD/sblvEUlHu/bvLCYuPOjoYW+s3KvxtE12OXxdMazhTkDjUDsHkKVr98uLXsdaDO1
         62Yic5Jk7FHLbHIL7ZDmbuoq+VPG548THvEYq0BAP3X7xApOUjiwWuntr3yM3QlZUcJD
         TEEnZwXLdL/nj02O+NnpaZ3cMa3pZB2pDJocOfEga4tP9S2TjnS6uXuU04I/zlA8Ysz8
         opNez40l5/bQO2JpacSIETE9c5OmO8mIwqXwkqcTpxSPbrOCbvnf03xQaH4a9ELhn+5f
         /x3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729886; x=1757334686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4N+q8o8KXEkY16pL6AM0vbzSxIIo1LQ5f2tTSY1L9I=;
        b=b0uZ/X1JyeTRzyXJnflmwNSXppliVpPMchPJXa0I3VNMRCn3oWp3yeEgZ/dnxXpzwX
         obUuqzrNJURpGaL6m7ckT3pw4JM1eryhtK1HgxVPlkoX/0LhwYzIuKROCubeXQz/hNSz
         xW6f1rAleoY5GA2GhU7UWJariIPLhOixpaja7HXveVwtLN1bJ/9TjeSN296eCGdWTLrZ
         aSwyh5LtZ8QjVUB+H4pTUvzFlitQ5sz5mGicTpCld4efg6YaVO4cqYsMwYZzfJIG1QVj
         VrKi/W1QbL1AKRKPOnNBIynWotWDvvYJrjH1bIgMIFDqmC/o0vDlI7pUWdLLYRssCCCl
         qFFw==
X-Forwarded-Encrypted: i=1; AJvYcCUCcUE0LJyX09WuobDcAdM94NT6MoLTyCpwq7n4XPbgwYJqXFRGGTRgY+YRaFEDMPxq+sYF9dM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+BmZL6L3dAgtmysQIPrgLEl3Fmm8ukuY0r4GZKD+NqbOOJZTE
	Gx/mdRDUigmiiIoucO25ZXFlNgegS0wKxuLdrsUPG7EzrE4tf0SveW4xqwhVMY87itJ2OcbiytO
	rMttitlE=
X-Gm-Gg: ASbGnctXuClSa8hJ8aaigm9wSASoBhs8aS4erxMNf4ZT7VbuO6QDwaNjFvNvwYCJD7V
	mGvAMru18vW4LJvQdOlAZyQ3ecbUM7Xzhxv1Rpk/G3hrYHudU8NpO7OHANuiFC4614laj+JzEIJ
	h039a+ILnJVmP3B1urfnwRFucBCZLTlKEz2Nbi5U4SXnPOymdhCAiQB65TWVKDETg8KNMx3ZbsA
	/imBC08j9wPoVxM3N7PJLrsoVJLpJc0YPrDDTU0DcTy0eQAnZV7Umzg8Xjd8KJ/4FmoUwqX8PDD
	srdo2VBnbPq8bNof33fYNre/r3HaKDvDW1xnqKG4phmhQuC7890oyGXfOiXkLUIjXqFNKMh37n5
	OWtIrS6pHbonloTZsFGrMXvFPb5sugiI+3DRT7EveP/tObcxT
X-Google-Smtp-Source: AGHT+IH0S4sTgNfQTnXRI0LudR80zD5+ZfC1keDZdSJ/oEiPdxO1oTocHeU7oQD+khKpjNKxQMuv3Q==
X-Received: by 2002:a5d:64cb:0:b0:3d4:1acb:aeda with SMTP id ffacd0b85a97d-3d41acbb2d4mr4092257f8f.15.1756729885028;
        Mon, 01 Sep 2025 05:31:25 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf275d2717sm15246537f8f.15.2025.09.01.05.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 05:31:24 -0700 (PDT)
Message-ID: <80178c90-b9f3-4e1f-baa5-f54aa89ec927@linaro.org>
Date: Mon, 1 Sep 2025 13:31:23 +0100
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
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <863496e4yg.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 01/09/2025 1:24 pm, Marc Zyngier wrote:
> On Mon, 01 Sep 2025 11:36:11 +0100,
> James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 01/09/2025 11:01 am, Yingchao Deng wrote:
>>> When linux is booted in EL1, macro "host_data_ptr()" is a wrapper that
>>> resolves to "&per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)",
>>> is_hyp_mode_available() return false during kvm_arm_init, the per-CPU base
>>> pointer __kvm_nvhe_kvm_arm_hyp_percpu_base[cpu] remains uninitialized.
>>> Consequently, any access via per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)
>>> will result in a NULL pointer.
>>>
>>> Add is_kvm_arm_initialised() condition check to ensure that kvm_arm_init
>>> completes all necessary initialization steps, including init_hyp_mode.
>>>
>>> Fixes: 054b88391bbe2 ("KVM: arm64: Support trace filtering for guests")
>>> Signed-off-by: Yingchao Deng <yingchao.deng@oss.qualcomm.com>
>>> ---
>>> Add a check to prevent accessing uninitialized per-CPU data.
>>> ---
>>>    arch/arm64/kvm/debug.c | 7 ++++---
>>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>>> index 381382c19fe4741980c79b08bbdab6a1bcd825ad..add58056297293b4eb337028773b1b018ecc9d35 100644
>>> --- a/arch/arm64/kvm/debug.c
>>> +++ b/arch/arm64/kvm/debug.c
>>> @@ -233,7 +233,7 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
>>>    void kvm_enable_trbe(void)
>>>    {
>>>    	if (has_vhe() || is_protected_kvm_enabled() ||
>>> -	    WARN_ON_ONCE(preemptible()))
>>> +	    WARN_ON_ONCE(preemptible()) || !is_kvm_arm_initialised())
>>
>> Hi Yingchao,
>>
>> There shouldn't be a warning for this, at least for the case where
>> it's not initialized and never will be. If you're never going to run a
>> guest these functions can all skip, the same way for !has_vhe() etc.
> 
> It's not a warning. It's a bona-fide crash:
> 
> void kvm_enable_trbe(void)
> {
> 	if (has_vhe() || is_protected_kvm_enabled() ||
> 	    WARN_ON_ONCE(preemptible()))
> 		return;
> 
> 	host_data_set_flag(TRBE_ENABLED); <--- Explodes here
> }
> 
> So the write of the flag has to be skipped if KVM is available, even
> if KVM is compiled in.
> 
> 	M.
> 

Yeah. And just in case there is any confusion, I didn't mean that we 
should not have the check entirely, just that it shouldn't be in the 
WARN_ON_ONCE(). We should put it in the part that makes the functions 
silently skip:

   if (has_vhe() || is_protected_kvm_enabled() ||
       !is_kvm_arm_initialised() ||
       WARN_ON_ONCE(preemptible()))
           return;

And the same for kvm_disable_trbe() and kvm_tracing_set_el1_configuration().

James


