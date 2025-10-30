Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00992D12EB
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761841137; cv=none; b=jXq4ZSsC3Q1+ppYIo/55VGqBcdJ4GlSXSBqY8lgEIkQhXQ4t6WwpBnXKN+6u781atY2cl06okqbo7jI6dZslG6mMnlosrK2jDS0DfCb7NW5RQbo8rWH79F2Qea6u5KgNwmp7LTaA2QwSKE17vgJab1pgjkfwI3GfQ3lhsMVtXMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761841137; c=relaxed/simple;
	bh=kauf8BeeZKXNoc5KIySCo8bhaQstpzy8PANGBYI/d0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s8+S15liu/YqzbSH/1uMd4N/RxpX61Ud4elG5te3rmImduEXJrZfKD2MSYYt5PIBA0pp3RLfmPHbQTSlWcPg5CYp/yK2saiCJ8DBcqCkd4dE2PUtNSierleo2wwtRas8lz0bZN7DhF2R+kCRQjF+N1tipV0RoiZhQShc3jBOPf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=0cZGVsWp; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="0cZGVsWp"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-378d50e1c82so12055271fa.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 09:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1761841134; x=1762445934; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rqNtoyinBX8qcU7mGg+XDQHvMcc/k1G1RSgPd+RXN58=;
        b=0cZGVsWpgUTyNvJsZn+FqwABqkB+jeIMIRmEhQ6ZgLU9wh3whENno81oEbEtWwyi6J
         bL0h3yUQHeTgL9TCiYUl3slCcEgv52HUe6/37cuiVNa3+q+fS3jh2xOIVk/OQOPTQxPO
         Uq3NQZ71aCIxVVv357BrWQNiFZt6yb7lGUMokruJwoEGe2FoQUb9+jHxXviZ170MjP9D
         vWcKYddRxSsRxfyIjvVLjkSFqw41mgWnoTYVRJ8De21rJwesOGDqeRe1pxiUnq5I1yH8
         lphokqEDTnmYnjCwb+vm8lM+qoINph5qAIB07EwCwVcFWLewdKho51qTURtnA77fmIDL
         cygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761841134; x=1762445934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqNtoyinBX8qcU7mGg+XDQHvMcc/k1G1RSgPd+RXN58=;
        b=YWJ4LIlevOX9B8BlNf9oddtAQKICv5wVQnTKHutMSGWs0nXC44/1rnxXk5fIum4pYf
         tplTK8FjTc2b3DrfgdwaREYSskXobryHnse/BiLZyevbW9NzBhIu1mTC15uY3P3HplM5
         RYnFP7zxNBUW1sOs74cr7kLaQDu4RSrIE0mX7GdMIcBB2SHg8oysBhWf1SKsAPZdsdHi
         bQSOLU30XSB5cHNayFicon1e1VPpPWqxwUZGb49xgYrrNBvLHwdSeSq0vxINYw5lX/OP
         jaS4VETBqSC9pdcsiOsI0OeNXzwCe6nu6dP3Fzj2n3qPcELMjWiikAnADpG8Hm5CC9aO
         IQJg==
X-Forwarded-Encrypted: i=1; AJvYcCV5nk9Pq2f6kP0/w2pdwVy8UE9F2YWNwI/0HHz/8SVxaFzAJIHTkxMZbVV9vgMY60lxEjQnQdY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrogqcQlh838JCLLRCwn4H0QdNHi1q2U5yMB0nKzC/1Kiouxpe
	yAp8UxLnUlGG+oyg8Huq4M5rqZtZYGbckXicaJPMI4kGbhVjI3GhMw6apht/qXh5efI=
X-Gm-Gg: ASbGnctLVNSDyGObGDvtu+djOs4gZEnozu6u/DmkAowtJC8XClgqUSi7YqoUOdQR8lD
	q5UYAXIZRns3gKhmmadV9Nbv3piOx1h7/WNm5aUpOMrYrW4zxzd0UwQRJhmYw/PlMXiiCXzpJzY
	ZkCaQZux2uHFGFkivFATNO7fNL7AwPe2c0BpI0tgmFLlK2SObqMWafT/MFLh0Pb+kSAim/xj+Aa
	mxu9I/uwXcYDs0SJtrkBfzrnK/YSBV1x+JZtTpvi/qp5EtrjggkQYOQbzTtj5t+7iEFl1thXAgE
	iK1iF6E2g6T2cGrA0AS0rZm99yzdK8tNaWWrndm9iOxRgpFAqw1TVn1EQ0moPZmixCZlWaDXGcy
	R9j59EiMq1gL1+J7bvjaaAN8VhJjGdF249YlmZVLdpcNQFHEpaOOHpGiqieagEHnHgYnQsiZyCp
	3XB9ceetMkGC5LzXRDTzlCanAIhukmlvaWfG/COQOUMa5YBBXcqbX51QePtjh1v1Adcg==
X-Google-Smtp-Source: AGHT+IEr5Z9g4wWlPda3oSInszfMw3AYzjKy3w2kVd2XI9iVXSOcL/bI6ZR5gKAx0+1+VUI13DCoYw==
X-Received: by 2002:a05:6512:3b89:b0:594:1b24:b419 with SMTP id 2adb3069b0e04-5941d4febfbmr110344e87.3.1761841133288;
        Thu, 30 Oct 2025 09:18:53 -0700 (PDT)
Received: from [192.168.1.11] (0x5da5f0d7.static.cust.fastspeed.dk. [93.165.240.215])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-378ee0c6269sm40611501fa.30.2025.10.30.09.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 09:18:52 -0700 (PDT)
Message-ID: <fb69e006-8460-4a5d-a19e-28bdec10434d@immunant.com>
Date: Thu, 30 Oct 2025 17:18:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host
 handler
To: Yeoreum Yun <yeoreum.yun@arm.com>, perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ben Horgan <ben.horgan@arm.com>, Armelle Laine <armellel@google.com>,
 Sebastien Ene <sebastianene@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20251030-host-direct-messages-v1-0-463e57871c8f@google.com>
 <20251030-host-direct-messages-v1-1-463e57871c8f@google.com>
 <aQNsrjceYM3RvY0e@e129823.arm.com>
Content-Language: en-US
From: Per Larsen <perl@immunant.com>
In-Reply-To: <aQNsrjceYM3RvY0e@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yeoreum,

On 10/30/25 2:48 PM, Yeoreum Yun wrote:
> Hi Per and Sebasian,
> 
>>
>> Allow direct messages to be forwarded from the host.
>>
>> Signed-off-by: Sebastian Ene <sebastianene@google.com>
>> Signed-off-by: Per Larsen <perlarsen@google.com>
>> ---
>>   arch/arm64/kvm/hyp/nvhe/ffa.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
>> index 4e16f9b96f637599873b16148c6e40cf1210aa3e..191dcb301cca3986758fb6a49f15f1799de9f1d1 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
>> @@ -857,6 +857,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>>   	hyp_spin_unlock(&host_buffers.lock);
>>   }
>>
>> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
>> +			      struct kvm_cpu_context *ctxt,
>> +			      u64 vm_handle)
>> +{
>> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
>> +
>> +	arm_smccc_1_2_smc(args, res);
>> +}
>> +
> 
> TBH, I don't have a strong comment for this but, I'm not sure why
> it is necessary.
> Since it calls just "smc" with the passed argments,
> I think it can be handled by default_smc_handler() without adding this
> function but return the ture for DIRECT MSG2 in ffa_call_support().
> 
> Am I missing something?
Calling `do_ffa_direct_msg` from the host ffa proxy ensures that the 
caller has negotiated a FF-A version with the hypervisor first. In turn,
this means that `ffa_call_support` can use the negotiated version to 
decide whether to proxy this interface or not.

Moreover, `kvm_host_ffa_handler` currently proxies host FF-A calls. 
Android also proxies FF-A calls from guest VMs via a similar function: 
`kvm_guest_ffa_handler` so this function avoids duplication if/when 
adding a guest proxy. This function is also where one would check FFA 
IDs before forwarding messages (to prevent spoofing). You can see the 
downstream implementation here 
https://android-review.googlesource.com/c/kernel/common/+/3422040.

> 
>>   bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>>   {
>>   	struct arm_smccc_1_2_regs res;
>> @@ -915,6 +924,13 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>>   	case FFA_PARTITION_INFO_GET:
>>   		do_ffa_part_get(&res, host_ctxt);
>>   		goto out_handled;
>> +	case FFA_ID_GET:
>> +		ffa_to_smccc_res_prop(&res, FFA_RET_SUCCESS, HOST_FFA_ID);
>> +		goto out_handled;
> 
> I think FFA_ID_GET should be a seperated patch?
Agreed. I've dropped it from this patch set as I don't think we need it.>
>> +	case FFA_MSG_SEND_DIRECT_REQ:
>> +	case FFA_FN64_MSG_SEND_DIRECT_REQ:
>> +		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
>> +		goto out_handled;
>>   	}
>>
>>   	if (ffa_call_supported(func_id))

Thanks,Per
