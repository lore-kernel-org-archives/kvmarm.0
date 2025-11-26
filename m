Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4C81E231E
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764177250; cv=none; b=Nj3etCZUrLpA+QiUpK/GWOK7b3qFLFqvNZui9cDG9PcZ2VzOjpLn/rcMlVHHo4B1YkjyGuk/c/3oR2tUbgKlEEzaT8i8ZKC9qfkUoF11lP0D9R86H9JYsRxv18fvDch+J7iR1UCllRyQweUrEawwK/PP9Ovrzz0WdOOqnC0oHZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764177250; c=relaxed/simple;
	bh=3Ejxx6pAoM1ChRfzDminYzCeEx52+t9tKpy08nqT/aQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BObCk90AU6NFhBAbwwNDYbJvzOLEy00X1aHXJS2XcfjzxjDIwNwOssawIrvj4HFLv/eJsr5Xk1z64CIhXYI4sM3o1TND2tjiM6alt2HS6J7YU1BmI7uRb25X9kTaJpN6rUUH8ggBZDMunBqJpXeTXspD+AprtpvrWotmnEx6BRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V4tHY9va; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4tHY9va"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so46598605e9.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 09:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764177247; x=1764782047; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKxxWS88sRLsch0GDN5eUzk0Z8XTysZ7hNh3XkKXTY0=;
        b=V4tHY9vaaU2TQDhila3J6SciaVi6aDDfl2zZQn6KgX7lpwcrtgaOh5ZjI7cCCmtvvm
         Mr3HorfZPk4dNuKJ+d+Deplv+eqll0iqUM2iNgqO9kRID6g4W0vsnKXFs14sleBj0NOI
         AW14eo71GQYGB2gkuHSJgPie1zEHBnpw6RFiKSnCbJfnPlRDNQ1cWcVjWOsjHpG6JcD3
         GHnuh3RgTlF5ea6fy1suWuZGhTDf3JeYUQL1OmqDO4+jJBIyKF8f3FQ8j8RGP6WQWEmO
         VgVyOBB1T+U+7zI6BZvEj3ayZADLDFZPwuhj/HJX4fzYKd1tVqJsV4GuwVpUj94VqF6t
         Nvgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764177247; x=1764782047;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EKxxWS88sRLsch0GDN5eUzk0Z8XTysZ7hNh3XkKXTY0=;
        b=GQSo45sEc1e3Kwyq6FeaUMKJbsPgyrvm2p4TSMpeuJA+xtTkP9ApOFTGPfNshy1NdN
         BcSDpsO7+CisWPHHrQWLd4y8+z1Tq/ZDB9NuxAtDwf/lr4Au6iPOFcrzbh1Wrdr0D9ix
         ViG23vydA/7K4hi2sZY/4iLGWBta4DCuTdW9oLR+DYa73La+iFWxhDi4zaIQMNU7NzKn
         OOv3qjYh1+VOQ3VYkkXFv7gqC5J1DVMoruso+PS70kSHy/AOboLuEiEkvWGLnNbfTq2f
         v+72Rq223tSoHbXF2gC/GOeuFhG3l6GoJg9HeldymCZNUfIlZiaUBObVqEEZbS9YfNbw
         cygg==
X-Forwarded-Encrypted: i=1; AJvYcCXEap4Asr+5ov/hubFL17YDM+XQ2O0xEWdrBcpSE5RaHDXEIdr69MzwMdWxEg5zt3UieT511EQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPT0zVXQ89i20jXzR57F34bnfvS6uqB0UXI5bGHxon436Cngfd
	AvQKDiPqLbryF8+U0K12Q+Z25MiIymeTJ13R9tDRVdxdJxdwfFeo3AOV
X-Gm-Gg: ASbGncu4Kn6nFvmo+moAHaGnC7epVC/vzfy/rNKReHsZKx4SI9YPwf8BUpNqwPEUvTf
	ffpPbKlx1I2pYIcO4ugziK7oMirXPBF70tMEdeAI7/EyG91E4k3J+wN+jim8YK+Ff00GkSA9HSx
	u3ZGRjNBYzaYNO7FQ3T0UQSED+F0ABU51JVBWe5hFhXu6VuMnot07dj2juOmNfHxFN6MUMMiBnV
	jj0FTPRnHPsQCwGXK/iN53uXTdbMFoflRJ6KVhNum0sDvufM56DDEGMXQXC7b/sktgSMisU7mvy
	gGQ2f7fzh2py8LP607EiTrODfh3Namorb4eOZfB3jx+0bRtE6Yy4blAj+SwZu8ha2w2/29AboKS
	KtzCEPq8AndFjCW9S/X9KmTn/Em/VO8mAo9HcjMPFwxdUJg28P3DTMOEDQAVNuBTSXDcgYs60j/
	NFLr7dOgK1Yi2135NENQhg6+ZrkE7qrZHVWg==
X-Google-Smtp-Source: AGHT+IEeUlabJkkeU4URSCYq6YEVT7i8LLPu8eSrASZVzCkAxvaNf+MzxONBZP4ebaKs4/OMcLwVpg==
X-Received: by 2002:a05:600c:1d1b:b0:477:9671:3a42 with SMTP id 5b1f17b1804b1-477c1133e4bmr203373495e9.35.1764177246757;
        Wed, 26 Nov 2025 09:14:06 -0800 (PST)
Received: from [10.24.66.241] ([15.248.2.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f34ffesm42577404f8f.10.2025.11.26.09.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 09:14:06 -0800 (PST)
Message-ID: <5cffcb56-26f7-4dac-a0ae-44329084d27d@gmail.com>
Date: Wed, 26 Nov 2025 17:14:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] KVM: arm64: Add pre_fault_memory implementation
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, isaku.yamahata@intel.com,
 xmarcalx@amazon.co.uk, kalyazin@amazon.co.uk, jackabt@amazon.com
References: <20251119154910.97716-1-jackabt.amazon@gmail.com>
 <20251119154910.97716-2-jackabt.amazon@gmail.com>
 <86see3r7e9.wl-maz@kernel.org> <86pl97r3ox.wl-maz@kernel.org>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <86pl97r3ox.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 24/11/2025 12:54 pm, Marc Zyngier wrote:
> On Mon, 24 Nov 2025 11:34:38 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Wed, 19 Nov 2025 15:49:08 +0000,
>> Jack Thomson <jackabt.amazon@gmail.com> wrote:
>>>
> 
> [...]
> 
>>> +	fault_info->hpfar_el2 = HPFAR_EL2_NS |
>>> +		FIELD_PREP(HPFAR_EL2_FIPA, ipa >> 12);
>>> +
>>> +	if (kvm_slot_has_gmem(memslot)) {
>>> +		ret = gmem_abort(vcpu, ipa, NULL, memslot, false);
>>> +	} else {
>>> +		hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
>>> +		if (kvm_is_error_hva(hva)) {
>>> +			ret = -EFAULT;
>>> +			goto out;
>>> +		}
>>> +		ret = user_mem_abort(vcpu, ipa, NULL, memslot, &page_size, hva,
>>> +				     false);
>>> +	}
> 
> And thinking of it a bit more, this is completely broken. What happens
> if the vcpu is in a nested context? You just populate random pages in
> an IPA space that is not relevant at all, corrupting the guest state.
> 
> You must correctly handle the context the vcpu is in, instead of
> assuming that this is the canonical context. This means going via the
> *guest's* S2 translation, just like handle_mem_abort() does.
> 
> 	M.
> 

Thanks Marc for taking a look, I'll update to fix these issues and
address the other comments.

-- 
Thanks,
Jack
