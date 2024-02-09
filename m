Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67313664A3
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 08:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467313; cv=none; b=gefqrKmJCZTW8IRa1g4iG89qjhr0t0zOrUR3WRk0hJEgRUccVKzRdbHJnDHoCgbqx/1Q3JlOk4wq5e5Y+R4GGroeIiyloYF3QTjSUcbY0wM9035Y8RutF9hB5xpoAj4h9HDGZgdwn4DI8BQUab/7CcAD+V0x81hkgszwBXiVKeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467313; c=relaxed/simple;
	bh=3HreAf3C7WSTTW6o9UNHFC8JLdzrORRUrztXIvGrHdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrHYYl7zT4dglNdqM7E2SEODYFaQ2rpagGhpr56QLMtl3lVjqQA/FmangXd4n+kCUHwe6SAY36vZDMsfZZJ+64KJiFlPlojmme2x99plOkMEzghV/N4rUwSYnA31Lm4TQ+oJS3P6MZJU/dRab0goR/fi5pHpSRtO+5B6zfsMXlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PF5b3RTY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PF5b3RTY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707467309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lSIosa7H9Vqr6g6wkjLttbFme+deNKcmttLyp+MsKjU=;
	b=PF5b3RTY3bX/FYGj9Afd7GyBC+9oh4L8A9MeeDut3RY8MQzc1FNjZLgYoXIqD7kt2MCbhK
	6tCWxSX8lkErbp7wasCs+8qIqwljIt40UWktV51uQL9UScWExDeAOxNZG55zsPPbCBhwSp
	UbcZMZXglhyfz6BplHvvioudQOTtgFQ=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-7YDKdM-8NWGcql5IvUgagw-1; Fri, 09 Feb 2024 03:28:25 -0500
X-MC-Unique: 7YDKdM-8NWGcql5IvUgagw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-51147e15397so639214e87.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 00:28:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707467304; x=1708072104;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSIosa7H9Vqr6g6wkjLttbFme+deNKcmttLyp+MsKjU=;
        b=vNujnTSihTeMWs9wmFWYW6CqRlHRUFD+f+FDwtURwhu2FA/+qiCxavCiUIUv3X7k7r
         P22X02b2LKLTkvOZww/YXJqEz33vQrsZp1FNgQR/1XVQwR9e8KWtj8G4bVzi4M3zcBNu
         +yBjDfZeClq62tCEbbA0YtwUTcAIDMB0TgTRg+rErdycBkRqr2Rjx/ztaG8eqGpHB8c6
         pKVVCKvynKTF2dXzgofafngOJksCRCYyC+Gtx88XYeOOZoXeHveheqB/EsZJDGjjonKK
         xNhmBSP7n8oEuahpZU+nh66SbNVd6GCjkGklxBs/a0uBEzBSrjqpH0fZzqrrb6LYYJCN
         u85w==
X-Gm-Message-State: AOJu0YwCZkPUbojlK+stxyj0krJkH+PL1SldKnVxZQsctHwM3RF4eV1P
	UXtIwAMZ/C6rZ1pZIvBD+GAeLti4DXgk0oZwehwFDcpfXOy3P/T6AU+0NZUonU/3f0sMZwcPEz1
	AtjaeSIrqdHwRYzEQZ/KN/+stqt0oMsiuzy9IG3aS8AdXBRl2JDvYsA==
X-Received: by 2002:a19:8c50:0:b0:511:5361:20df with SMTP id i16-20020a198c50000000b00511536120dfmr532247lfj.13.1707467304490;
        Fri, 09 Feb 2024 00:28:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4iC+FRipMyVJYsUFGfBqVSr7OvTucmAa52sfLjON5ya4vVilp+U93Cecd2K9MevakvwHq5Q==
X-Received: by 2002:a19:8c50:0:b0:511:5361:20df with SMTP id i16-20020a198c50000000b00511536120dfmr532225lfj.13.1707467304116;
        Fri, 09 Feb 2024 00:28:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVltiJ29BtpoUYrPf1SZB45utAeCwTbqwI56ds2Aa8EuZgPms0LwddB+C5/ltorHPajgsPjWHznwdj56pQ6nu24/cSU0eXH1BGFKlLpjR6rvBc3CaDz7fawO3HG0y/7Gj1kRsXQceUY8H9DTHj7+R44o5x/+wAiDlcMMgMVxyLdLPEAfjjAlfUUxE++n5R8EJIaBBcUd/sybg4tB7HpCx0xfR7A3QZtmcA4CGK+PO2aZ3a4C3MTk7GaNjIS70jqUB8QQi/QEZtTvXyQPH2SeBlVAk3amng9fA+1lWXwUoI8AxAXRBESY/XUYLDZ8hU2RQuaRJyEuWMq21JPhPOlKlAvy0qf8iePnq2dDkTWjkRgl9+vU2u0DhldVHMj2B3GnDXN84fFK6s9RaZwI3YbGQeghRctNDpy3xzctkbPneerKo1h0eN4mdodAM7NkNUCmR5Z9nBofp5yuUCaQgVQg4gzECnx0ypTC+kVRzZq9/hWL3AcB68IavYtB4tow7DLo1gLXWRDd9TcE1hYecDqA1g4uLor
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id x21-20020ac24895000000b00511749fec62sm90472lfc.72.2024.02.09.00.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:28:23 -0800 (PST)
Message-ID: <cf01bf0c-ad31-4bb8-918f-98de47d40d7d@redhat.com>
Date: Fri, 9 Feb 2024 09:28:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 5/8] arch-run: rename migration
 variables
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-6-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240209070141.421569-6-npiggin@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 08.01, Nicholas Piggin wrote:
> Using 1 and 2 for source and destination is confusing, particularly
> now with multiple migrations that flip between them. Do a rename
> pass to tidy things up.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   scripts/arch-run.bash | 115 +++++++++++++++++++++---------------------
>   1 file changed, 58 insertions(+), 57 deletions(-)


Acked-by: Thomas Huth <thuth@redhat.com>

