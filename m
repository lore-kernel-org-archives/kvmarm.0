Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8294C1C0DE6
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 12:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717071460; cv=none; b=NiNIvbAtuGF/SwPrPYq2G0gt4c0yZnqpTWwPzlkXnzyxTlYfatJWrzclHNWnhh0MqKjttif5g6mdkGUMVvbEtgyTQrHnkS5FfPmzC5hWZcTevWA726/BOyMNE3PJBD4dpljqUaN00PKI6XoQeRnw6jDBEXxek7By9Dy/NmaYg1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717071460; c=relaxed/simple;
	bh=V5hI7KMkzgVk/ALuPDZUKKRsX7oat0m5/GaY+dT+YqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nsmpRG1FwPtWnUDA8IvNpY3m67kCiRXk4gwtbgqgdyOvgCEiIRaZMCef32Iak1zDe+vnz6bUKOHo0A9nth6gQSxQXOfL09AzTNc+him43SMIYobgru+gMGHLlRnSu64qyu6ijy0rpFdJAeGyDidtGntbXNt8UnzpY8d48cW0Hts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ql48ey4Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ql48ey4Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717071458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UMT67zC+fbo2iQB9ZfpmsekE+SDPWB6XReNKWdjTg/c=;
	b=Ql48ey4QhicKWxG+D5Q/WvuCK4nnqRaKePjP4AWTxtz9i0nGGyLTRV0pE8rkxFAhjFbI7A
	eSWGumUm7lStyVl2cmu0RhmM9mREJmbbOOIA6oQZcFu/yS4JQPTRFYsj7JBu5Z3cJkQXqk
	p7diNOYvYslSHccrMdlvqQdQaVnXenI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-m6wUiO5EOzStcTvpRDWukA-1; Thu, 30 May 2024 08:17:37 -0400
X-MC-Unique: m6wUiO5EOzStcTvpRDWukA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-354f31fbe0bso706800f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 05:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717071456; x=1717676256;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UMT67zC+fbo2iQB9ZfpmsekE+SDPWB6XReNKWdjTg/c=;
        b=PEtf0wYjPF+ug19RgYpGfm6O4RLbRiGeGsKoMT60mMN4NxohtDGNP4bFguYBHGSZjS
         CC5zZXpg8wLkHMgU5POJLk8oZx5rZFMEySoHkL9RRg5DgNPDiyYp694XmVK6w9C6kZJJ
         3JZEynnD4HGXHcjZDymMhy6nrNTHQ+L0YfGiyRT80M8lNVLi6MfWEvZj+Wulgvkz6rFb
         9Jydn9IA1gC140rhgIl5+OruqKXzHd5YGZeCHaKcr7MQxAwNeXPJIAmWIya85/fOocyr
         XN+8SfwdMMnynzpyJtfjxh8Xe23pw8NNvS4Yh2I1JX/DrvK6IGu/WnrHmCQSiTpgDxi5
         3Zlw==
X-Forwarded-Encrypted: i=1; AJvYcCVk0Lf0o+4aWT7XJuplc3poCLbQsRte7B4lykaoSSEjW1wuZcHcudQLImrHxyVLMEYmSgvrLx6eN9FPIHI1d5Fxfsc0CDrR
X-Gm-Message-State: AOJu0Yxtpu+MtjCrFMSSrpRNg8Xkaz74tuQqCT1MGILxyc4Z5LMTC7DA
	12ems81WMqzof5mwuW0ylgnaL5HL+oThXhrxdqkm88FPSe0Xwh+dWXoOSdK07kcgNqXj/sitToy
	r1RiHqjmT8Y6oEfTlB0tmHqb/8c5RuY26It3w738taZ6v4FX+o635GQ==
X-Received: by 2002:adf:f989:0:b0:354:f90c:63dd with SMTP id ffacd0b85a97d-35dc00369c3mr1370854f8f.0.1717071456020;
        Thu, 30 May 2024 05:17:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCeaFufh+CD65vlqUrpverwcUO7ViCXf3RbM0I0lK+Q3pHJBTo8PrCVYwi3ANZO5WJqWE20A==
X-Received: by 2002:adf:f989:0:b0:354:f90c:63dd with SMTP id ffacd0b85a97d-35dc00369c3mr1370836f8f.0.1717071455558;
        Thu, 30 May 2024 05:17:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dca3dbee6sm1356852f8f.53.2024.05.30.05.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 May 2024 05:17:35 -0700 (PDT)
Message-ID: <897ea2fa-838a-4b33-8434-dba5dddaf9ca@redhat.com>
Date: Thu, 30 May 2024 14:17:33 +0200
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
 <2dcfc174-9384-4746-833d-1442bcfb6d11@redhat.com>
 <a0295969-eff9-5330-cd1f-1e41b8f43eee@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <a0295969-eff9-5330-cd1f-1e41b8f43eee@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/30/24 13:24, Sebastian Ott wrote:
> On Wed, 29 May 2024, Eric Auger wrote:
>> On 5/29/24 17:51, Sebastian Ott wrote:
>>> On Wed, 29 May 2024, Eric Auger wrote:
>>>>> @@ -3557,6 +3557,13 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>>>>>      struct kvm *kvm = vcpu->kvm;
>>>>>      unsigned long i;
>>>>>
>>>>> +    if (!kvm_vcpu_initialized(vcpu))
>>>> at this stage of the reading, why is the above check needed?
>>>
>>> To make sure that a later call to this function doesn't overwrite
>>> the value provided by userspace. (See e016333745c "KVM: arm64: Only
>>> reset vCPU-scoped feature ID regs once").
>> but isn't it overwritten through the .reset=reset_ctr() that is
>> populated in next patch?
> 
> No, this is done via reset_vcpu_ftr_id_reg() and also guarded by
> kvm_vcpu_initialized().

OK thanks.

Eric
> 
> Sebastian

