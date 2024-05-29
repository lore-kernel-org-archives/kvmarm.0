Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E14F1C6A0
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716991137; cv=none; b=NRIiKorCVDwt6mnQ9GDxyDb3QhT2wsgd+FnVZiUKzvYtaS1r4xYn/fgTATRM+LWHpLWUZSKqcObp+mgx2KG+GlUKwu1J0k8OTOzyu6n0ejC5H3HTkaOKtMVsD5fsD01k+d2r7e2oa80ffs6mQg4zy5zzPXYvlWaqVU/jgaPDzhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716991137; c=relaxed/simple;
	bh=NhfLFKimMloJeZdUmF9DWPA/k6EIfjaMNnrCLXzufHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MXa0pehCQNUsbpyjr3rLeLujYEBveiFg3nzeRXvasNjMDW97zi9isKHy8CxTYnOl8Mzf6yKQGhs/veFg/B2uqdc43z/jJidm/3E8iZGcfQFBOwQuuGJWSFXHYcNPZZkNynesOrxBeAXLsSk7wmIjQsDZh9IRgIZJ2RSj+/uVSfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XNaZYGpc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XNaZYGpc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716991135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kBUt+81N76m8JjLowWjPyJ/0ry15liDoYiHfRlVMY7c=;
	b=XNaZYGpcwZF1vGDdqOd1dwmpvEbWapRBeX1aFMkdpyxnidyN5spaMdLLMASqgM82luBQse
	ASuXXFAZMKv8viexUskViIo81UzmvcB6TOwgHHCsOY/z6P5GY3RS1bFBx9Oriadil7/5+d
	WaqjD5RDxfiC9+ztMr8aWwSatHqLQ+8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-z6Wf-jidP5iUBQznomUENQ-1; Wed, 29 May 2024 09:58:50 -0400
X-MC-Unique: z6Wf-jidP5iUBQznomUENQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-794b5cd9468so267121185a.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 06:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716991130; x=1717595930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBUt+81N76m8JjLowWjPyJ/0ry15liDoYiHfRlVMY7c=;
        b=evCI/SjxoNQm7gQPo4xvfP6ihPKMFKcy8Z2R3WZBsnc9q/Sphj3KgMTEYObrnwihEW
         lVzsh67M6AP0OdnPG0wpNPrU8Z3svmH0tVqwX0B3EJu1dQ/nDvoGrBNfGO1YOb9b8kiD
         t88yaZ1IIOVshswR4b28Oz+k3QAMzLPjR1OaIAMJ+iF8rrXaylz3sR/173GMe8nepgXv
         8PRwrvHeqOFtruGKdhWDdbVGI/vjCGJ9betXPolz6e4K6TTu+wUDpjSYtRqVpVAV1cQy
         Vp764xcS6AlAGDOw+006p4hANnDteihyjE93ayS5iaVdMTuJNAIGv+K6oI8j4bvfTnnq
         jnOA==
X-Forwarded-Encrypted: i=1; AJvYcCVzFHOjf0q9bN28yhSCxWbrrDnWnGZ/buDoFe4GnzGHwYLDAdZlQmQApTqCzbXbpkeXnnc6mjfDlfoyKQBkXL+uRnK20fzq
X-Gm-Message-State: AOJu0YxU0YKHGpfSI9PYDQZi1m+3bZm58FKI8TjZtmJvZtTwLiavFw+p
	5znE+KXHrflllkobftaW0cF4xezlPc2odDB7NE3hd6wfaRVI8uzy9qigJuL3Yhabs9KCvnhpyoC
	oH7Ly8HyvS7ut+fcKbc2802V2rL2Y9YeEgVFZLGLtt7q+5i4n7CVcOA==
X-Received: by 2002:a05:6214:4805:b0:6ad:8f41:3ca6 with SMTP id 6a1803df08f44-6ad8f413d86mr70083196d6.12.1716991129977;
        Wed, 29 May 2024 06:58:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhaIWfEuFup0idzv7CTp9i0M0x4ZOM7kMRhbkvTSCSPbnBelYKtRYZKNIDRnw7041mRgi0jg==
X-Received: by 2002:a05:6214:4805:b0:6ad:8f41:3ca6 with SMTP id 6a1803df08f44-6ad8f413d86mr70082816d6.12.1716991129499;
        Wed, 29 May 2024 06:58:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ad5b5da00csm51979476d6.92.2024.05.29.06.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 06:58:49 -0700 (PDT)
Message-ID: <b045f810-eb79-4de6-b149-0d64834d53d4@redhat.com>
Date: Wed, 29 May 2024 15:58:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] KVM: arm64: rename functions for invariant sys
 regs
To: Sebastian Ott <sebott@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-6-sebott@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240514072252.5657-6-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 5/14/24 09:22, Sebastian Ott wrote:
> Invariant system id registers are populated with host values
> at initialization time using their .reset function cb.
get_##reg call read_sysreg(). I don't really understand the above
sentence. Please could you elaborate?

Thanks

Eric
> 
> These are currently called get_* which is usually used by
> the functions implementing the .get_user callback.
> 
> Change their function names to reset_* to reflect what they
> are used for.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1b6ab483e21e..bae72a4ce72b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3795,8 +3795,8 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
>   */
>  
>  #define FUNCTION_INVARIANT(reg)						\
> -	static u64 get_##reg(struct kvm_vcpu *v,			\
> -			      const struct sys_reg_desc *r)		\
> +	static u64 reset_##reg(struct kvm_vcpu *v,			\
> +			       const struct sys_reg_desc *r)		\
>  	{								\
>  		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
>  		return ((struct sys_reg_desc *)r)->val;			\
> @@ -3808,9 +3808,9 @@ FUNCTION_INVARIANT(aidr_el1)
>  
>  /* ->val is filled in by kvm_sys_reg_table_init() */
>  static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
> -	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
> -	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
> -	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
> +	{ SYS_DESC(SYS_MIDR_EL1), NULL, reset_midr_el1 },
> +	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
> +	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
>  };
>  
>  static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)

