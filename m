Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE51A18BC16
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 23:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728342516; cv=none; b=XDBrULX1EjqY4kUxMXaGc/LLlCm7VgO2NfhL/KvShvEcweY6dw1XLvIJwOp8/0EEy0wj4pp0HV9odzi6tQN2vdJkoSkIe6mgZKu/GnWjH6cDwrmwfkS1o0I2zNmKsalmBFc/prfw7TB1PZQjV6P6+reGmlyASfTezx6MwmbMInk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728342516; c=relaxed/simple;
	bh=sFKC8oum4eACHS/9pWNfotlCf3EQRPXmA4khW9IqDfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=um/5oa2avYLsthDPFQifT3e8luOt1IPbWnvu7kdLuZKP3radRih4PEt5cR00t44A4q+FZyfEZYFwMwgE/AW4sCuD9/JNrgOvqGOGVQjGf5JjJaS262DL6j2ls28QxHzUWv8CQvBqqykshw+Y1XWL7trc+QtbLM7Jly3FUGk7rB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3nS+JsR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3nS+JsR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728342513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AfJmONIqkrrRodARYVzXrl8zpLHbhe4TWvVFD3MTZqg=;
	b=e3nS+JsRwI8j/+zpPeBCSkDJZbuyoyFVU3Vbq+gGoAh9qsF6lJgKKA7vhqAJyz5v9PSZce
	zRrNnPf8l6b0zbUaIbjGdAlDo6QvGHddCLnQ5PlDvphYjzyQ4CXjsCO8JSlJWQOI580FB9
	ELM4wt2ErFalUX63FdSDdx+EtkBbUsw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-Zc8o2gJ5OmeK5JsH0dpK3A-1; Mon, 07 Oct 2024 19:08:30 -0400
X-MC-Unique: Zc8o2gJ5OmeK5JsH0dpK3A-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2070e327014so48597665ad.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 16:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728342509; x=1728947309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AfJmONIqkrrRodARYVzXrl8zpLHbhe4TWvVFD3MTZqg=;
        b=FbBsNLWQ0NhmIicL5eRmWpHOPYh+ccieXY45fWp37FFCpS5IyEiuE/IdLiKSVhucT9
         FJNRE6EMhWiXmJKinVRPMkdSEw1oofeN+75G0gffPG+c60VoEcbDsVYSyu4TcGzKtpFV
         +g7MCnI3hNtWIMhFeUReWVMX7MYs4KhZcaRIVNDnJGa+X+B66i1o94FZVnN/9aX/brOD
         /ScusfMnp2ppNEsEE3QcjXBInOMS6p74VIFeYPlm4kBV55jfsTALvuvcfsAnVNvTott0
         OL1z5mZN35x3+fgAozdz+ZBi6rdkNvuXd02yQ9vJywznEiXpDnLcjxtZ2sZRk1szn6tW
         jCGw==
X-Forwarded-Encrypted: i=1; AJvYcCWqF3cCQecjYnvdgj/uiCT5EGZ66ruPKv1eaypM7w1LllArSjv/NDJiR8QpsYe0/NCZsE6EVzo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIkV1bu8aS3yjIS2vOxm47T7Admn9WgU3yRIcEfA+iKm6qR9L8
	6+iLcJRbJYwNsDXecWzhsEsyu2gIarq3MJ8ZOPg+sN640Fp6I7QuCPm9DewU38AM/EplSdt+fKh
	00Z0n9dJNGW+V0TAYTdpWEV+bxm1aZDf6HCAvLW3jkMtOEIQzOF5g0Q==
X-Received: by 2002:a17:903:40d1:b0:205:9220:aa37 with SMTP id d9443c01a7336-20bfdfd31c5mr168800605ad.22.1728342509507;
        Mon, 07 Oct 2024 16:08:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxry6Ql2xA8l+3h1gl4I/L2BZcrkbVPn5b4zTTD+RDz9IJ0w2m9Xz1rJHClf446EHVSuntWw==
X-Received: by 2002:a17:903:40d1:b0:205:9220:aa37 with SMTP id d9443c01a7336-20bfdfd31c5mr168800285ad.22.1728342509084;
        Mon, 07 Oct 2024 16:08:29 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c1393175csm44740705ad.140.2024.10.07.16.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 16:08:28 -0700 (PDT)
Message-ID: <2ed92455-b97f-40ba-b5d6-695e885be62f@redhat.com>
Date: Tue, 8 Oct 2024 09:08:18 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/11] arm64: rsi: Add RSI definitions
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Gavin Shan <gshan@redht.com>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-2-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-2-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:42 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by a realm guest through SMC (Realm Services Interface) calls.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0.
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Gavin Shan <gshan@redht.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---

[...]

> +
> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
> +						     phys_addr_t end,
> +						     enum ripas state,
> +						     unsigned long flags,
> +						     phys_addr_t *top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
> +		      flags, 0, 0, 0, &res);
> +
> +	if (top)
> +		*top = res.a1;
> +
> +	if (res.a2 != RSI_ACCEPT)
> +		return -EPERM;
> +
> +	return res.a0;
> +}
> +

Similar to rsi_attestation_token_init(), the return value type needs to be 'long'
since '-EPERM' can be returned from the function.

> +/**
> + * rsi_attestation_token_init - Initialise the operation to retrieve an
> + * attestation token.
> + *
> + * @challenge:	The challenge data to be used in the attestation token
> + *		generation.
> + * @size:	Size of the challenge data in bytes.
> + *
> + * Initialises the attestation token generation and returns an upper bound
> + * on the attestation token size that can be used to allocate an adequate
> + * buffer. The caller is expected to subsequently call
> + * rsi_attestation_token_continue() to retrieve the attestation token data on
> + * the same CPU.
> + *
> + * Returns:
> + *  On success, returns the upper limit of the attestation report size.
> + *  Otherwise, -EINVAL
> + */
> +static inline long
> +rsi_attestation_token_init(const u8 *challenge, unsigned long size)
> +{
> +	struct arm_smccc_1_2_regs regs = { 0 };
> +
> +	/* The challenge must be at least 32bytes and at most 64bytes */
> +	if (!challenge || size < 32 || size > 64)
> +		return -EINVAL;
> +
> +	regs.a0 = SMC_RSI_ATTESTATION_TOKEN_INIT;
> +	memcpy(&regs.a1, challenge, size);
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	if (regs.a0 == RSI_SUCCESS)
> +		return regs.a1;
> +
> +	return -EINVAL;
> +}
> +
> +/**
> + * rsi_attestation_token_continue - Continue the operation to retrieve an
> + * attestation token.
> + *
> + * @granule: {I}PA of the Granule to which the token will be written.
> + * @offset:  Offset within Granule to start of buffer in bytes.
> + * @size:    The size of the buffer.
> + * @len:     The number of bytes written to the buffer.
> + *
> + * Retrieves up to a RSI_GRANULE_SIZE worth of token data per call. The caller
> + * is expected to call rsi_attestation_token_init() before calling this
> + * function to retrieve the attestation token.
> + *
> + * Return:
> + * * %RSI_SUCCESS     - Attestation token retrieved successfully.
> + * * %RSI_INCOMPLETE  - Token generation is not complete.
> + * * %RSI_ERROR_INPUT - A parameter was not valid.
> + * * %RSI_ERROR_STATE - Attestation not in progress.
> + */
> +static inline int rsi_attestation_token_continue(phys_addr_t granule,
> +						 unsigned long offset,
> +						 unsigned long size,
> +						 unsigned long *len)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RSI_ATTESTATION_TOKEN_CONTINUE,
> +			     granule, offset, size, 0, &res);
> +
> +	if (len)
> +		*len = res.a1;
> +	return res.a0;
> +}
> +

The return value type of this function needs to be 'unsigned long' even it's
converted to 'int' in arm_cca_attestation_continue(). In this way, the wrapper
functions has consistent return value type, which is 'unsigned long' or 'long'.

Thanks,
Gavin

