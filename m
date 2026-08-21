Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA10F25783C
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787320925; cv=none; b=clJjvY8djSN45d2OKncqUWpsCHY/iZ6ijgV5WFXnOxWE1kgxwBuIHkRRw1w0UEQc4HslJVeCX4oixWlau5xRZrelJcZW19qce2oZWMBN0NgzQWzQtmGpzTQTtNtUbkzqC08/26cGIDwCnFl++v8PNTOkpWiuRSAMx+mlmhaYnvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787320925; c=relaxed/simple;
	bh=w/VwBDo9UPwUkAEyzce0Vi/QMwtEtK0I0XlnqIp4S9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUyURI7z6/wdnMy9x3GNx79cYPRE7Y4kRTjd5W11Hm6yMFJZcSTZka3RXTtthg8EjK2ErXlO4CUIctujkmFW2tbChv1739jcATtL6uIWMhS7iUDlfaPUvqYu8Lpm22whH+NqwAyu9jkgiduhLKogmz8Sn4XE0zMYPM/t5OxBhfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnwL8ImJ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnwL8ImJ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-495437bb891so5461775e9.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 07:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787320921; x=1787925721; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nQd8YnirXzo/05vCBWaK5j7dOswPV7dn2KgbQ3nhodY=;
        b=EnwL8ImJr4Tc7D26Sd5qtb4jgwhV7NULD2tHvx66eiB9fTmrV6HXLEqHUGQ5z/Yipk
         J6R8/CvmXpp1SkoBu98x19cFqxWz42MEuCvPiLdCf4z1zL7l5la7o0jjBr98PqaJwXM9
         sRrJqIRj98TgZDJ1OMY8Km4NkRfYi0AttMeULi/oVp6fThxk9gcbA7PGLKMfbSMXf/lf
         awIacjym2bpazUsuIj4NeMQQYy7n3OCY5K8qpklxyn0xjVrLOFtISibnI3u5shN0/xIy
         a4E69W/kCfbCUVT6TO7r2w9jBRFEZKlDPSDsWH3M8Vwr5KI+wJwwJpPZI+/mpYqf8MGE
         ie+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787320921; x=1787925721;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nQd8YnirXzo/05vCBWaK5j7dOswPV7dn2KgbQ3nhodY=;
        b=ZhjPuRQN0BHJz5eInLEamPqk0YwmMbtycrFs2+BzFo0UstteK8WpnJTunim88ow1/l
         JuOHry/ToGbVZL05WsIYK9Q/HcWOUzOFT11cvYXMfmVOYemGLx6M9KtKGOof7d0NqXR/
         JTGjMUAPGPKVar7hjZ1KTx+tfrpYv6QzMAWNFSrRdu4lI0rIy/yCmzxuIC7bBHqaYj0T
         EiMjR6ujE9m3Ia78DBaBPD2NvLJXA8OQdMRay81qhYPct5mSDJHC4OfApWWMqmNyCGKf
         C6rHBIiFA69lE5tmDrHmLOxSPshK+Z/e5VkUroxW14C0yDY75F3kXZQFYYrdkjVYDZSm
         sT+Q==
X-Forwarded-Encrypted: i=1; AHgh+RquJ8jppZ7seeLEElv388USVRqn2DgrLAAGuEsmu/TRz4zifY8FQ0IBQ4FPl3cEwx1kh0ifgMM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgXkFueT083BvRYiTT2o6ghPyQvdcWQsWc6PzUfcfVyYTceQ2P
	X/R58I2YzRUiiWVc0L8AAgrFhgwygy6u3NTIbkDTK3ZcrFTQs5jjLvjl
X-Gm-Gg: AR+sD11r2/tUhljBzwVBtxSnc0EuL90coDuyNgx8tMjKw9IVOG0WNTevWivlKu5KWOr
	HZKHg0WxSjFRuRg+Ob0aGHEZhQgDEDS/EIzixt1s37ENg5Poj6HuniaO5D7gXv0pkZzf0y5NqOt
	3tBz1Rt5UYY7Q2dm7FdMv7bcK8lBZGlF9Bskez04JyejtcpyhwbfYeL8A5o84rn4NjaPKCxYipI
	l71tp+6f/7lfFvOgLOR/kPVBhhrUngR1Ofk4feldrebDBF6NQ0jLqJPRmC9gmHm/F+ZYNoqPYKH
	dRq4lQBfOxn4rFzpDXbPiXc1oR8AcRDddMe0g8l7jMc1truRWcVqFDRKy0af3HAE7VAuC51hzIm
	bMlSY8WThfAPqrKasl6prj6bdagKkCX0G6kOTbSCmfNuwjthrywDlEYN+UeZoCVGOhKFIJ/xxGw
	n7L/35Y9ymk16I+cRzvGU6/MO+tj86YPbrtdUjqw/L/3Oor31s12d+LvyUtGv5fLtNYCKO42b9M
	YIY
X-Received: by 2002:a05:600c:1912:b0:499:8d9b:832c with SMTP id 5b1f17b1804b1-499b9182141mr59968525e9.4.1787320921200;
        Fri, 21 Aug 2026 07:02:01 -0700 (PDT)
Received: from [10.45.28.226] ([15.248.3.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499b90f8b4fsm34103715e9.9.2026.08.21.07.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 07:02:00 -0700 (PDT)
Message-ID: <6270fea8-aa08-48ca-ab1e-ab0ada105ded@gmail.com>
Date: Fri, 21 Aug 2026 15:01:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 shuah@kernel.org, corbet@lwn.net, vladimir.murzin@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 isaku.yamahata@intel.com, Jack Thomson <jackabt@amazon.com>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
 <20260612162354.73378-3-jackabt.amazon@gmail.com>
 <amc8zlGxegNKHxIY@google.com>
Content-Language: en-US
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <amc8zlGxegNKHxIY@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Vincent,

On 27/07/2026 12:11 pm, Vincent Donnefort wrote:
>> +	unsigned long		*page_size;
> 
> It looks a bit odd in that struct.
> 
> Also, transparent_hugepage_adjust() modifies pfn and gfn. So perhaps it'd be
> better to introduce a struct kvm_s2_fault_mapping that can be used to get what
> has actually been mapped in kvm_s2_fault_map()?
> 

Yeah that's much nicer I'll do that thanks for the suggestion!

>> +	if (vcpu_is_protected(vcpu))
>> +		return -EOPNOTSUPP;
> 
> It could just call pkvm_mem_abort() when the VM is protected?
> 

I see, I don't have a setup to test this properly myself, so at the
moment I left the protected vm's out and don't advertise the capability,
if there's a usecase happy to look at it as a follow-up.

>> +	/*
>> +	 * pKVM stage-2 mappings aren't directly walkable from the host; let
>> +	 * the fault path handle both new and existing mappings.
>> +	 */
> 
> pKVM has a host interval-tree where we keep track of what has been mapped and at
> what level. This tree is also protected with the mmu_lock.
> 

Thanks, that sounds better. I'll have a look at moving to that for v6 then.

-- 
Thanks,
Jack
