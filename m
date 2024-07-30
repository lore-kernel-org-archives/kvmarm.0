Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C7918A929
	for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 10:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722336099; cv=none; b=INaATyMYr0tm6yljNFKtbNUwp9t/RP57uBbRnuebjIWZFoDuqplO6ceFyjKUAZSNbf1M3lt16JE9mn1s/1BxrsI0fg7Pb7909HToSHy9252ewdRGOCiQrmFVghrDjDs8wnMM1vR5y9qHhcw59bX7EUomqPtYCfrR7xrKviRu9zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722336099; c=relaxed/simple;
	bh=DhzCAI2qKRiMRe5MUI4Qm796RQ6OVVSx+lGb39s7xlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RgL36jkNpOOm9D+cTeblEMoSiJzEYqZX+HCp8PRTXx2Ks9sfRaY07ppE4naemUGBirD1Y51qrNHPGSiIlmyzR4nQhIBeE2Wsr5fiRpbpOcbkOEQml6/Du8gs4MUp4m7kQWezaE6+xtVdQykC5JADU1NEkIzbuKGBL3SPMErpHDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B7w4uLEw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7w4uLEw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722336096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8g9eu69hY+tFcVns2hzHdTrw7hODbFfcDdVx3JGaNxs=;
	b=B7w4uLEw7TtOLa2Hj39vW+sRgDu0gFuDb1pI4B+a87Up4gu9YzLiy6RVMLcm2EzWYRx8Xa
	l+Wge+1pfBCyZdLX09WbyYsY+ScnWVXRGldMJFQSR16lz/9QAZxwdMD5sKTeI8hU17oGiD
	FN7yQ6a2ckcYiF5T13D5DKqKwM0Exr4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-3jCxZos1OrqqUiGKzeT28Q-1; Tue, 30 Jul 2024 06:41:35 -0400
X-MC-Unique: 3jCxZos1OrqqUiGKzeT28Q-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5a7661b251aso4624149a12.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Jul 2024 03:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722336094; x=1722940894;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8g9eu69hY+tFcVns2hzHdTrw7hODbFfcDdVx3JGaNxs=;
        b=rzCJaR+PPuh3l6huZ36Gkw4gh7vQyOjVViwoK4kjgvCOUs2nX/YYG+YwE0zYYS86sO
         1H3YtDXYiAs/0A/7ZnBALHbnHj3mlLGr0otJq9yBprfmndPh9Qocl6yvxdNSXS8XNn8Q
         bqi0HvXRhoayN9k+W9nTpfdJqhPSQWaRbKx6FVVaF+hslKITkOuUzPglvOJOu7l+GR/r
         7XAHzT1qrDNJb8zJB7WJo6WkjVVGEhD7G28pwqwwLDOLfnexEI3XLJJYJs3k7dVO3CAF
         2p+SBfPAVJ537LSjOs+eOSFM6MvvGcijlAro+RfxTpUHsMnYmgzdjocPnBAfa/0l2xEy
         eMpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAHYbQVpPIGHZ5scClGkd+nCLD28fPrkm+LhyVlmuo33SDWIH/f3aKCMXvlLDiXNIkVxWt0GU2v62wDc05CJC3d4c0tkTR
X-Gm-Message-State: AOJu0YwKFTgiPBdN1quwinJov89QUf181Gm2hoB3caJ4feRBhR5xxi12
	yxGTaUYfgWi0Zwukgtupd/+Aa+btpHIFSYnQgRCPD8esxPzoiFr8fVbVKkTBrWvp9GMDgob2Pjy
	HuGeCq5WNFcnEG9+FxXWZH611k0vhiO/htYfJ4ERbyqmtmvk3wrS8ig==
X-Received: by 2002:a50:a411:0:b0:5a1:7d68:62d8 with SMTP id 4fb4d7f45d1cf-5b022c81f43mr6159508a12.38.1722336094338;
        Tue, 30 Jul 2024 03:41:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDPyYZQ8rptYaeG/QLRVtJLyqTXdGIvl8oYe7Os3i41TwtBzRWbRKhmb66UoorwOaLwZdqjQ==
X-Received: by 2002:a50:a411:0:b0:5a1:7d68:62d8 with SMTP id 4fb4d7f45d1cf-5b022c81f43mr6159475a12.38.1722336093853;
        Tue, 30 Jul 2024 03:41:33 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5ac6377e06fsm7118734a12.28.2024.07.30.03.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 03:41:33 -0700 (PDT)
Message-ID: <63c41e25-2523-4397-96b4-557394281443@redhat.com>
Date: Tue, 30 Jul 2024 12:41:31 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 34/84] KVM: Add a helper to lookup a pfn without
 grabbing a reference
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
 David Stevens <stevensd@chromium.org>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-35-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240726235234.228822-35-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/27/24 01:51, Sean Christopherson wrote:
> Add a kvm_follow_pfn() wrapper, kvm_lookup_pfn(), to allow looking up a
> gfn=>pfn mapping without the caller getting a reference to any underlying
> page.  The API will be used in flows that want to know if a gfn points at
> a valid pfn, but don't actually need to do anything with the pfn.

Can you rename the function kvm_gfn_has_pfn(), or 
kvm_gfn_can_be_mapped(), and make it return a bool?

(As an aside, I wonder if reexecute_instruction() could just use 
kvm_is_error_hva(kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa)) instead of 
going all the way to a pfn.  But it's ok to be more restrictive).

Paolo

