Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8E719D071
	for <kvmarm@lists.linux.dev>; Thu,  6 Mar 2025 09:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741251675; cv=none; b=MjydgwZpJCRehmzUQdSjTbWEpmLm85sQTSXfezF1nDDqiPrzDzqH3AW3F7lUPYO4r11y+PLUTCmKXv3WYQeT/dTPBxmlG1OJvEodi0SgxsBYoTFPu16lVqM1OoJ66dWbSTx4FDYbQEbzgcXkViGVThezvoCC1Ox2k5AZdfVDHbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741251675; c=relaxed/simple;
	bh=kpr2G1t2lYW/A7fi2Y1YgX1tpsvekdQ0DJ4km8eVkJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UejmoZ+vJqoLWmUJs50tuBgH3LxdAeyWpP4QpCC84Iid2drsGJg/g5+1aGDqRT+j9O8bZ+OyL9ut7/efx7lsEUGfApbzerhWFguurM0nVfPwZPwJFpCz8EwFxfldztuv7mv4PIdOtX6WpmSsxt+6v1KbmXzpAcvTVTUG5hKbGd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvdPVNq3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvdPVNq3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741251672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pY2indv9DvyBZQJoUjIBXHffPxVcc0dm+eOOwrLDR6k=;
	b=IvdPVNq3rRNiDO+DYqdAku6Q2w+tDLYtaev5EeFmZZtelIGjkegGXCVO1b0CszQM3Om75n
	1HS0UVUWlCMwcXA8uFlN3mky0vQl4W9ZwG5oVyT3IKeXhuvRMM/rb0PUgvAIgpfSZKeLHY
	WpRGEnnurRC6Q4+jT4+69cCxIzFN4yI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-qCry34HvNQur2L6wRR9yOg-1; Thu, 06 Mar 2025 04:01:00 -0500
X-MC-Unique: qCry34HvNQur2L6wRR9yOg-1
X-Mimecast-MFC-AGG-ID: qCry34HvNQur2L6wRR9yOg_1741251659
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43bcd9a46feso1499035e9.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Mar 2025 01:01:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741251659; x=1741856459;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pY2indv9DvyBZQJoUjIBXHffPxVcc0dm+eOOwrLDR6k=;
        b=Tgk5oVSjnPSXoyg52ArO3gtSBEoHh4Ds/QaVEFigS13Lt5NQEmYgFzKJJK8Yh81YwA
         EVn+cclPb+wbEtlwt6dfauiF3BKTQNW9W7DWIGrsWVuQNPGuLAda1c5zDvI/I32aXBBM
         cXMvd1wQTb45YwxdVYMPGnENCd1+uYWxKzf41Lbw5/4VabYhMPHtu4nP3Q8++mlfXGjO
         YDulk30cmPxGInVmY7MfGsDZ9sSEtYkDHkHbbPtG8EnvNtNSV0bxAo/fYuIvqS/aOBSu
         Hw0H+buWGTpge8yQprMHDEx/RcNJglXJwrEAs3zZK2A2S+Hpzp6dZE46Jb569lNWRX0a
         1VVA==
X-Gm-Message-State: AOJu0YwrRPcQ0Cak6ZC7xlxhOiZ8Dy4UtQSf3c4ryNi16x/x9H78ftZC
	WgD+1MSLipPbdYL6azwOpBHj7z5n4uQSXJtRNi206hvYTLFsodZ6ULoW3o61XFBcvv+tKfEqptg
	8HJe921g+KhB0IG3ctNuORZT93Zq9Wy1ZPwaaoe07xMi4JCdYUtCSgA==
X-Gm-Gg: ASbGncsCHc6volegJ8tEjFul4DK7pcf2xJUFr2rux9LWze/rlFUVkrRTdwq986dJL/9
	GA5UDtUTOzkZxb99i7GqDPQwPAOtZWfF7M/phgc47Iz66F4be2oRb0WxhICzG5vOqyLDYjyt1Dj
	c4QeULSTw1ZP9f0TLGsTqnn+xtd9V/woB4Xka9uaavFz0BEY2s/mDlt3Hhz6Lw6/4JFMcByznLf
	Oj1pOx5Al895AMkQKoqMl+JuOvk07O3dvcmJBey189CqwU3npyL31yzgaCr8VdaRuOViT7NIZOM
	FI3psJhaK8IGFEumR8+SVZKugjGeZDybF+uitIIz7stNzig=
X-Received: by 2002:a05:600c:35d4:b0:439:9f42:c137 with SMTP id 5b1f17b1804b1-43bd298f9fbmr59118345e9.11.1741251659394;
        Thu, 06 Mar 2025 01:00:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2NgeNdUnGXbD+op2sXJsB/SN3xlXNlbIFOWQaCFoi1UgYgSk1r/tZKHyzVnT9tI/XhwhMWA==
X-Received: by 2002:a05:600c:35d4:b0:439:9f42:c137 with SMTP id 5b1f17b1804b1-43bd298f9fbmr59118055e9.11.1741251659046;
        Thu, 06 Mar 2025 01:00:59 -0800 (PST)
Received: from [192.168.0.7] (ip-109-42-51-231.web.vodafone.de. [109.42.51.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd948cd0sm12787105e9.38.2025.03.06.01.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 01:00:58 -0800 (PST)
Message-ID: <a10378eb-4bff-488c-86f7-b4fec20feb6a@redhat.com>
Date: Thu, 6 Mar 2025 10:00:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC kvm-unit-tests PATCH] lib: Use __ASSEMBLER__ instead of
 __ASSEMBLY__
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Laurent Vivier <lvivier@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org
References: <20250222014526.2302653-1-seanjc@google.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250222014526.2302653-1-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -RlMNej8MqebzjKcxLFbtOj8oIGO2S2nqxgaRIlNBfo_1741251659
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/02/2025 02.45, Sean Christopherson wrote:
> Convert all non-x86 #ifdefs from __ASSEMBLY__ to __ASSEMBLER__, and remove
> all manual __ASSEMBLY__ #defines.  __ASSEMBLY_ was inherited blindly from
> the Linux kernel, and must be manually defined, e.g. through build rules
> or with the aforementioned explicit #defines in assembly code.
> 
> __ASSEMBLER__ on the other hand is automatically defined by the compiler
> when preprocessing assembly, i.e. doesn't require manually #defines for
> the code to function correctly.
> 
> Ignore x86, as x86 doesn't actually rely on __ASSEMBLY__ at the moment,
> and is undergoing a parallel cleanup.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Completely untested.  This is essentially a "rage" patch after spending
> way, way too much time trying to understand why I couldn't include some
> __ASSEMBLY__ protected headers in x86 assembly files.

Thanks, applied (after fixing the spot that Andrew mentioned and another one 
that has been merged in between)!

BTW, do you happen to know why the kernel uses __ASSEMBLY__ and not 
__ASSEMBLER__? Just grown historically, or is there a real reason?

  Thomas

