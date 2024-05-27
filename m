Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB8916F28D
	for <kvmarm@lists.linux.dev>; Mon, 27 May 2024 14:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716819830; cv=none; b=l0q/TCcPzycZlqLmhjf+kQXp1DnJ2Sa1k/T17U5l9QHPYRc9gdBW3q1uXS/lVL1RggzXKXfPsJtabtCH7sRvr/gu/AdsVt1BAIyBt+oRC0/DV/wFZmGPASWo7nFQ422i9h8j3Lj0IC252rqelgN6+p7oKdVq3Fw5B9ijMiOHF+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716819830; c=relaxed/simple;
	bh=U/8+cNT/6r/cPMQxaKHzz9tqRw3+vgHMhlaxgqt/NIY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KOOA61KjcCH5UXZ6/yBKui+H10jc16hui0pRA4s0Lyu3hB4ehSKpHr5TXRYisvHDImJjUflnJkrHSNxQcQnWN31NXIZzZgEPgjku52GtToCa2UDPkcm2dwSTtTmAtEEwGBcTgLPVhw6YN3ixSdtWt3YFmsKTqb02Pg85P7lm4RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zpo3QcK3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zpo3QcK3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716819828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uDkfQTZ2OD4EHqIyUHZnwKqde9p/2Gl7tlIUwS9iQSE=;
	b=Zpo3QcK3FIC1cgPF1L7YNaK6xzcZgxPAyd98bGkaO+KWiX30t8RPve54ufvrYM73p2Kq9L
	0y/IcOG3FafwOrGS6aXPQluex2gdX+ONj2Qh9jUM3EoPXB+gP8AtU2/n705haV4MtcNFZ+
	TuYTj6sAfpwkrGbVI5/AOvXOfjVnnLg=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-CQZ0QvBgOQaANMvKTFiUyQ-1; Mon, 27 May 2024 10:23:45 -0400
X-MC-Unique: CQZ0QvBgOQaANMvKTFiUyQ-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3d1c692f67cso747974b6e.3
        for <kvmarm@lists.linux.dev>; Mon, 27 May 2024 07:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716819825; x=1717424625;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uDkfQTZ2OD4EHqIyUHZnwKqde9p/2Gl7tlIUwS9iQSE=;
        b=w3dpsd7p/Yo0diEQ9fFhPc+h8fbHYDkEJJ8DVNgKZAiwnsOCnviFfNzwOgWUsFgRuO
         QK4p7D8FTjHTBTenXpYDvxqyifOpSrnpQDgMjmPe+f9ogBLHnBAGEypkQnnk+DX9VyHO
         ol/pKgQB5WcK65bjFst48bJv7XQ6/vsnG7hxNmP7d5uAoJAsNvX1Z2QKZl0vVow/1xFO
         BQQxr1HH49uV7GYAqPTI71nRBDw8lNvpH6WGtYBMHjHeCreDdOeZQGhHH+3C71lZ9S/Z
         NzcolbbShEtFD+UpZXE0zC+lxUB4SbEX/39oaX+TULp5fm6qgpd5EjdyKCLh4Er3txWz
         wFFw==
X-Forwarded-Encrypted: i=1; AJvYcCVd9tiZNRZaVVt2/wUS8DMnC+h//7dEWTh9Ah8RqsGP8aTk7ezSuxvCClwUhYpWVnL5/HLxDprr8FPuErDAZ7OiVEO5nV0V
X-Gm-Message-State: AOJu0Yy0pJ5NmYFVQI3ai0RYw1F4ELSI3LC9ILqOgKqeDE4T85zWUKbg
	p8r7sbKiuGZ0ACdEhRQhCnVYGX+xNwa9ohA/D5BSYY0ppoH4EGeWim+lb/1PDkeGnbyUSqGJ/Ap
	ya6i1aB2O8PzcxiNB01kmrYD76eL0bYJpx/fuqwEXjvMi7JFyEn252g==
X-Received: by 2002:a05:6808:2895:b0:3c9:6f32:48ae with SMTP id 5614622812f47-3d1a7646b36mr10077205b6e.47.1716819824794;
        Mon, 27 May 2024 07:23:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd337yra6VNYY4/lCnAw6wP0WY3esjyq2b6ysnQazhhPyLwvvBYzmWw4XghHqjVOjt15jOCg==
X-Received: by 2002:a05:6808:2895:b0:3c9:6f32:48ae with SMTP id 5614622812f47-3d1a7646b36mr10077185b6e.47.1716819824441;
        Mon, 27 May 2024 07:23:44 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ad77430c57sm17299476d6.38.2024.05.27.07.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 07:23:44 -0700 (PDT)
Date: Mon, 27 May 2024 16:23:39 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Shaoqin Huang <shahuang@redhat.com>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 1/6] KVM: arm64: unify code to prepare traps
In-Reply-To: <080b8820-d665-40d6-9cf2-35e47086d01e@redhat.com>
Message-ID: <ab00cdd6-7b93-05a0-896b-24e68e9413a2@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com> <20240514072252.5657-2-sebott@redhat.com> <080b8820-d665-40d6-9cf2-35e47086d01e@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Shaoqin,

On Mon, 27 May 2024, Shaoqin Huang wrote:
> On 5/14/24 15:22, Sebastian Ott wrote:
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>     static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>>   {
>> -	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>> -	if (has_vhe() || has_hvhe())
>> -		vcpu->arch.hcr_el2 |= HCR_E2H;
>> -	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
>> -		/* route synchronous external abort exceptions to EL2 */
>> -		vcpu->arch.hcr_el2 |= HCR_TEA;
>> -		/* trap error record accesses */
>> -		vcpu->arch.hcr_el2 |= HCR_TERR;
>> -	}
>> +	if (!vcpu_has_run_once(vcpu))
>> +		vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
>
> Could you give more explaination in your comments about why we still keep the 
> non-FWB handling in vcpu_reset_hcr()? That would be better for understanding 
> the special case.
>

VM ops trapping needs to be toggled via KVM_ARM_VCPU_INIT for this case to
catch when the guest activates its MMU. This is different to the other
traps that are setup once before the guest runs for the first time.

Sebastian

