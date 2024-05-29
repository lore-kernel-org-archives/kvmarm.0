Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886EC181CF7
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716997868; cv=none; b=NfITC0ip4Cq1hMdc0fPVjfrzKJ2bPs0k4dRl5JL46kNpCnw6HCu/18KSeYAB2dB72yS/FT9yipESihfBRsEI7XPJqZ1NGZcGjdIGXWZNMtUBUEeFxkZGceoigp9O4j5pzmAiKC9y6/C137jViSUKy6ywubHF35Ga9ohrQL8F5HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716997868; c=relaxed/simple;
	bh=nPh/k750oWFllKMqo44WmSkl8MopO1VSvwnk7Titii8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZpU1uv/b3D3ZUpzvzH1KDUy5bFcvi7opyJ0HCmiQl4YYczb1mv5qDBWIxV/Cg5W7ayt/HX7l7gl9dZVCk7b98gtSQDWaeQJoXs4wMmH3tSsskCsrtnFMFTMZRDxO4CED8Q4/lBHfFeojNC11P7FQBgU1D7+1Rg6lVpv6HogafRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YsMm92V+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsMm92V+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716997865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wj1aC4UtCyPUM4QTC8xzhgQZJugAFw5/FZACWc0ZVRo=;
	b=YsMm92V+hZG3ZXTbisjAsykub4E/PsNiXP7FM4e1N/HLIIj8SaquO2FWHi+7X37+Y/tsL7
	1WtXIK+J4WTnrDRWVbfJD2wZPEXOfb4Y8LMbQCwPSJRr+goahqRllo3i9G5iYq3er6nHAt
	I4GrhvMMDQqstSCFZL6/P5HzsrwElg0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-seLG0OtRNx20zpSk8NOYrA-1; Wed, 29 May 2024 11:51:04 -0400
X-MC-Unique: seLG0OtRNx20zpSk8NOYrA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-420eed123a2so16678785e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 08:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716997863; x=1717602663;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wj1aC4UtCyPUM4QTC8xzhgQZJugAFw5/FZACWc0ZVRo=;
        b=EGMe4/bjPz9SVT0pVEsPgn1kt4+glr2gd3WOE8VX4vXPersSHWzRFKi2kkBpGVPYER
         E/m5BJeK+RkJn9UYkhdUbw1dvK+0f28Jxu1lbS6te+dshrO9y9kKxPXlEOKoOL4bUkc9
         KaN9WbhSzHvMR2fQ1DFbfhX8YFTTuFXmseMSocfjbiWEfqHxnAMfHBeC0yvbP7KNWB/9
         4KCvyJd15LXvMFJtBpBsFCjLO4fpyPVLSVVJmgiYq7atqpL/qfzaN0oB0yh9hTitwonS
         /F+zMMHqHW9Jq7Al30Xf1IoUtcmX8GB1Qn0XOuzFeGucWM+rarC8o3JDI6KjGHnWrjZG
         sX0A==
X-Forwarded-Encrypted: i=1; AJvYcCVGu4mG6q8euNz9vfRBQa7RFEuz/sJZt8oBf0iSVo9xKMSCXBwrqnh3x3/0XLlAn16toZlnvqIjMHitSoA21pDfWbqwtpxr
X-Gm-Message-State: AOJu0Yy7pBBNYdYO/B35XuVoaZPo5NJU4F82N52GnPVVdoIfYH8LjhvU
	0fO18wvAZAeHVd5s5Us2OT8w433rm4+lPuytxFjmsgra4NLCcJCzNlT6UrCqmyPGXxZ66DSghz1
	uT+Q+zmEWcN3VnJBpvz4mluipNyTA6xCWUX0PNNRwWnXrTliIdOHRbA==
X-Received: by 2002:a05:600c:4506:b0:421:205f:52de with SMTP id 5b1f17b1804b1-421205f543bmr41308765e9.26.1716997862737;
        Wed, 29 May 2024 08:51:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnxWP0k/VdlV2yzLTOufK9dfVKQxMD5gYEbM+NMCUK0CifwlvRGzVwfVWIWgQnenP9G0xAbw==
X-Received: by 2002:a05:600c:4506:b0:421:205f:52de with SMTP id 5b1f17b1804b1-421205f543bmr41308605e9.26.1716997862342;
        Wed, 29 May 2024 08:51:02 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100f14436sm216520275e9.17.2024.05.29.08.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 08:51:02 -0700 (PDT)
Date: Wed, 29 May 2024 17:51:01 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eauger@redhat.com>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 2/6] KVM: arm64: maintain per VM value for CTR_EL0
In-Reply-To: <edbe3039-ed42-432e-8309-5a0a46cc2d5c@redhat.com>
Message-ID: <90e53cc7-039f-5abc-f94c-cf53a1602a2a@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com> <20240514072252.5657-3-sebott@redhat.com> <edbe3039-ed42-432e-8309-5a0a46cc2d5c@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hej Eric,

On Wed, 29 May 2024, Eric Auger wrote:
>>  static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>>  		      u64 val)
>>  {
>> -	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
>>  	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
>> +	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
>>
>>  	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
>>  		return -EINVAL;
> nit: you may update the function doc comment which the extra handling of
> CTR_EL0.

Hm, there's no extra handling of CTR_EL0 it just uses the emulated value.

>> @@ -3557,6 +3557,13 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>>  	struct kvm *kvm = vcpu->kvm;
>>  	unsigned long i;
>>
>> +	if (!kvm_vcpu_initialized(vcpu))
> at this stage of the reading, why is the above check needed?

To make sure that a later call to this function doesn't overwrite
the value provided by userspace. (See e016333745c "KVM: arm64: Only
reset vCPU-scoped feature ID regs once").

Sebastian

