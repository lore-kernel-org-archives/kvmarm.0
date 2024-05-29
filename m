Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE79815CD44
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717004142; cv=none; b=tzgBOKWsFNKnF+JBsj3CmpdLmggpSfBGR5ZUheQas2of9LB2B/Uh8Hme5s6zWHMZ4Zxma/K+e9ZVRTPLO+Gg5cF0s3lSjBUa802bQVDiDIRHOpFSsYypD0Un9wGp0c6aWtxhHq3YloQb3PXNk6PClHBwwnIh7H+CzebS3qgIsoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717004142; c=relaxed/simple;
	bh=7qQLkzDYKjrcECLZwdp64idceuhEnjoqg60sDVOwDH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qh3SgFzMNIRxckZoWucPJLH45dFiDYz6gy2BPqAmT+SEBzSha/rwhWNdZ2RN5PhmU1bWzm36wb7P0BotG4OcpL8Cx+F5G9Lawhszt1h1jbD1KgFdTN+1JgeOaZYTQPL1E3EYcY4vXLWKxznB4qUo5wgkeWMKxqwCEgzTZm0X2o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N04GQHlS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N04GQHlS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717004139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGCd40WdtTorkfaaoKKX2Xm/h3qQtjnTG12sTYYmwaE=;
	b=N04GQHlSbQfffIWRY2CA/PZ6uqTb98nOHTW+lM+GwoOA6HUgAeCX2VcV0NvdAd77nfGEAd
	8UGAXjH5YKLkljvdis4C6IzbkrL06+7KWILokdWw2Cc0qRGIfkqVrmAbUB2KMCfHvjCAK6
	IwAcvZh9vmI0unVTmkfOZWGzAoHL/mk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-Sxslz_6aN2y3xv3Yrjc2Zg-1; Wed, 29 May 2024 13:35:36 -0400
X-MC-Unique: Sxslz_6aN2y3xv3Yrjc2Zg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-420fe1575bbso17261145e9.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 10:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717004135; x=1717608935;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGCd40WdtTorkfaaoKKX2Xm/h3qQtjnTG12sTYYmwaE=;
        b=AmyKVzESt2mKDpfqmoFE8w1hXq6NFKZGm3t9UMag/P4+Z4mVnEGxZnTTJjufEg7MYB
         ovfGfcim6kA/25j46CL4XeQkZGRTMWacwRBaig3AqXyYjde4Wk0sWtFZvtV2TB8piOcz
         N15lupNQvQrkl78ucnh+sDwZTrAgJcTuK+LjjYME8PTbYGk++5ePUK9PxIC9sqIDArAd
         rv0kLRKw4MyxHnKs9rTJDlTBZf4vipQeGFs2oO+n4ukvIqnn8eNvzgoYX48v1oFyaza9
         8JY7FuvPr8X8hYWChy/rtSB47APD6nOO2IInMWM8ZVyq9NeUBrqsMumDdMYP9dl0rv/R
         gVJA==
X-Forwarded-Encrypted: i=1; AJvYcCVMTtyuglzIF9KRDS5ag3Qx8nnbw1pQR95ngWqNCfi4QxBq+C8OJ/n8CnAdw6eKEObZhngTm0p3k3Pa+o1GfZ0cFojkCj+5
X-Gm-Message-State: AOJu0YxyDe1wDTK6++V6clzITAyUKdPS/HHJbZ+nYZXmdMDzFHmLSgLy
	+1TSDv55CzJCGFAEKCP851RqYJEEHK0JLDjvxQiNvyp+kk+jMmFOaKGYd+EkdsVwxpy4irGVhuA
	mrbmR1/4mX2P0dVe2nanw7/1jGRhjT9apmjIZeNuSrMDnTOHZNhHExA==
X-Received: by 2002:a5d:6c65:0:b0:356:c47a:87d2 with SMTP id ffacd0b85a97d-356c47a8ab8mr10001459f8f.6.1717004135402;
        Wed, 29 May 2024 10:35:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaxx0+teEcXMNT49ZjEv4m21C3jeDxUtDLzJuChV8/uQgMeO+CZV4KNMcg8G2fe5Szs10sfA==
X-Received: by 2002:a5d:6c65:0:b0:356:c47a:87d2 with SMTP id ffacd0b85a97d-356c47a8ab8mr10001445f8f.6.1717004135016;
        Wed, 29 May 2024 10:35:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35b1d7a496asm5599092f8f.87.2024.05.29.10.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 10:35:34 -0700 (PDT)
Message-ID: <2dcfc174-9384-4746-833d-1442bcfb6d11@redhat.com>
Date: Wed, 29 May 2024 19:35:33 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] KVM: arm64: maintain per VM value for CTR_EL0
To: Sebastian Ott <sebott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-3-sebott@redhat.com>
 <edbe3039-ed42-432e-8309-5a0a46cc2d5c@redhat.com>
 <90e53cc7-039f-5abc-f94c-cf53a1602a2a@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <90e53cc7-039f-5abc-f94c-cf53a1602a2a@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/29/24 17:51, Sebastian Ott wrote:
> Hej Eric,
> 
> On Wed, 29 May 2024, Eric Auger wrote:
>>>  static int set_clidr(struct kvm_vcpu *vcpu, const struct
>>> sys_reg_desc *rd,
>>>                u64 val)
>>>  {
>>> -    u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
>>>      u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) &&
>>> !CLIDR_LOUU(val));
>>> +    u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
>>>
>>>      if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
>>>          return -EINVAL;
>> nit: you may update the function doc comment which the extra handling of
>> CTR_EL0.
> 
> Hm, there's no extra handling of CTR_EL0 it just uses the emulated value.>
>>> @@ -3557,6 +3557,13 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>>>      struct kvm *kvm = vcpu->kvm;
>>>      unsigned long i;
>>>
>>> +    if (!kvm_vcpu_initialized(vcpu))
>> at this stage of the reading, why is the above check needed?
> 
> To make sure that a later call to this function doesn't overwrite
> the value provided by userspace. (See e016333745c "KVM: arm64: Only
> reset vCPU-scoped feature ID regs once").
but isn't it overwritten through the .reset=reset_ctr() that is
populated in next patch?

Eric
> 
> Sebastian
> 

