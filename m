Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E16E337108
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763135927; cv=none; b=B116Eq4EuYFuPOjXhMsz5OARWh0npo+7x4CJgEShX8apO+bD3/cJdljVJZ81kncEKfQ2gfWZ8/Udlawu8lZWnrqZIzKecg9p4Q9xzJWZ8lCoalMWtosGf+Q50121X6MS8wc+3pw8s48Q3JeCqly+PlICtJE9vDzxW1HJI59bjyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763135927; c=relaxed/simple;
	bh=C7Fjr8Xto2frMhhgVW189R2RvwowbHZfW5FHZo0pYvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyX8uahYHxSWQSQ9uKKhFmiNS2QgpeyTopGX+JG13/7rBPelqbypm4TmQiMqUqZiDHhBI3vdZZ9LcYdBxMRusViH6oD0GTuqJvkkJ17xIWABkM+7qTXAtmj8DrC8Jz580pwJwlN9afmLySJWvzz3RCJqvdLCCA+ATjb2j1Z/+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=wEEI1G54; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="wEEI1G54"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8804ca2a730so27097806d6.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 07:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763135925; x=1763740725; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hWRzwP7yaYI/iz3QDVFwP7hE6cNynh4rlrUlmbjDl1A=;
        b=wEEI1G54pAlN2ASCvDf0fPQSYMrhLdj4QLNJ8CK65pt8wD/HjrYCRG9tvua98Syx3e
         ctKNLekP5v6A9u+xcMWZ/uC8TvQMk/CaC6TEO3miTe020OTeb9VQWv7prL4lRVzXqZjq
         /Ykmi+fCdrY3GWPabI4CGBXTSfNrxoZ7QrIlDrOGm+UKplCNOVn4fnAvoUdniH4tlvRS
         B+k8CzY2RcFnXNxPGPTd3tNbwhfrxEz97niZZ97BMcbm/BWkaBApFlPGNH7QkGbX9APP
         veRUITXM0LWIOXXkVmHhemGsfbO+4JEBtaytKQv7I6MgI4xZmHmxg8kg/8gmIJC0TZX+
         G9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135925; x=1763740725;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hWRzwP7yaYI/iz3QDVFwP7hE6cNynh4rlrUlmbjDl1A=;
        b=FStAi5J0tW5KG9fYcT7isZt3fDXybtBVRXQ7i/WpHxoU5V8vLiSEDAhTWzahzgthtU
         aQU2/3ahmwuMEBSKR8Az89t3XRjxm9RiPwQRObV0TnK7zvEbhkPvgrXKp8s9VWyYz8G3
         9D7KfBjEP5oUTbqL3sZPeCjjgp+XeyDm5uHpyzf4/L2n91FeuSECfjLxfiSBi3r0u76E
         N6V2ENkKzBJW3VtLen+yt1pHNxwUh9Z5k3Cnxxs5NxQuqHXSEDR5/14GGhgalOMWKBUT
         pIm7kJBdVoT24AtDSSc8QrurINSfnMP1vuM2kKLIyZDweZtACL/18J0IFolIQnj8SgWb
         qGzw==
X-Forwarded-Encrypted: i=1; AJvYcCVAu9GZMoI6NGkDi2zewC+SsVamLjVpfP7Go5A6jtbV/eIBQFEoEAGzMM51vwEoe0dxsFY+oBA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOCBeRMTkP5ompFRlb5CkGPsJIBUubeURwVlfpc//x/VUcEt4e
	L5RxDtpQDwWa8+Syph459YWutaBPVlslGllL8rkCyoTLAjd1kbWdSJ8QLrPeAKIpXLI=
X-Gm-Gg: ASbGncukLUVOLFVJFDyJ+joDrmSIlyF2mx1NCn9e46yAtID/so5iyfAoAdPR5jQpE+w
	tInc2V14slsAiWsLjgeCDwZ1rkWBYUedQX580oKarzpoTebbNWtgBtZrxgf95p0wBZW8PRvxgsl
	W5ayPPL93JM9fqBxSGN+5L5kIxse0nK90mrTodiQRXw8p9y6zXUxB8zr0XV4tV6w7uu8BiFg3Kx
	GoMd/pnKtwDLfSJCn+ilEJZRuyazGQYvOcEV+NfkJDmZ19xXlO4ENZQ++tE03jYHKRD0cJNxrkX
	NEODqzncM0/CqPdf1TsrjbGIJXBBwGhDjv0pwHjRg5flAeu2WuPKWR6k1u+4ZOklTeIRtvz76LI
	2GQZYoZnKr2R24ExpTzCtFcREuRDJ3S3rNKDGT6E0DSFUBqThBD7xUbhYBEZ2kmM4+XwfSAxTIF
	GjUjHrtr9RBKE1o+/TEuWAcRDVp+nrDK8AtZH7ahac0Nr1Gh2W8opIiZoTYNK8m01a4nf/YjmIM
	LWmv7kc0kPyV0uEGYPyIbrUkO4XBu3hA5FRrMD4lQW2VTEEk9SPlJ3Q
X-Google-Smtp-Source: AGHT+IE7eiGd3vEuNVBCnEAo9tQkcil+B3Q6M+8Td3zOqsuTZ0gqLQ+T0rf73N9UcDNXrhI66caTiA==
X-Received: by 2002:a05:6214:1256:b0:880:46a7:b1c3 with SMTP id 6a1803df08f44-882925dfb0emr43805336d6.28.1763135924857;
        Fri, 14 Nov 2025 07:58:44 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8828652d941sm33112566d6.30.2025.11.14.07.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 07:58:43 -0800 (PST)
Message-ID: <9b2d7e48-a847-4c84-89cc-b8d3962f4498@grsecurity.net>
Date: Fri, 14 Nov 2025 16:58:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Eric Auger <eric.auger@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Thomas Huth <thuth@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

+Sean

Sean, while you're currently in KUT maintainer mode, can you please take
a look at this? The ARM bits have already been ack'ed by Andrew and
Paolo, apparently, has little time for KUT as well. But as you currently
seem to be looking through the pending KUT patches, maybe this one can
get some attention as well?

Thanks,
Mathias

On 15.09.25 23:54, Mathias Krause wrote:
> This is v2 of [1], trying to enhance backtraces involving leaf
> functions.
> 
> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
> fails hard for leaf functions lacking a proper stack frame setup, making
> it dereference invalid pointers. ARM64 just skips frames, much like x86
> does.
> 
> v2 fixes this by introducing the concept of "late CFLAGS" that get
> evaluated in the top-level Makefile once all other optional flags have
> been added to $(CFLAGS), which is needed for x86's version at least.
> 
> Please apply!
> 
> Thanks,
> Mathias
> 
> [1] https://lore.kernel.org/kvm/20250724181759.1974692-1-minipli@grsecurity.net/
> 
> Mathias Krause (4):
>   Makefile: Provide a concept of late CFLAGS
>   x86: Better backtraces for leaf functions
>   arm64: Better backtraces for leaf functions
>   arm: Fix backtraces involving leaf functions
> 
>  Makefile            |  4 ++++
>  arm/Makefile.arm    |  8 ++++++++
>  arm/Makefile.arm64  |  6 ++++++
>  x86/Makefile.common | 11 +++++++++++
>  lib/arm/stack.c     | 18 ++++++++++++++++--
>  5 files changed, 45 insertions(+), 2 deletions(-)
> 

