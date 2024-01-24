Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A813118AED
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 09:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706090322; cv=none; b=q6uNRFDNUA6HTLdkuXNudoHXa8omCpgqyGGr6GolGgnFii6brzw5K79qibLnjusEv5NKEuY6UJaZ7XrYdnYDp+hp2w0yaPqfTMOW7kyYA9XSQol5FrbN5yrNNq92Rhwk/yaEpI2Rqvm7sFyDgJMxu990f1v0fT/C83UbFS7f4Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706090322; c=relaxed/simple;
	bh=bkjO83ib1M9eZUG4pgKQCIucEcIhujihnVXwfWPVEdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjZXl/kkWsgozkUfae0GgeXSt0eSzHi0YRBC7uwiuBlV3nYSQXk2FJjWNt+XwhozzeuIbCLwkw1rydDxxPVs4cZPjAD1xq5DgISkU9+nBwhrLMzdqh+LQ2vaIJbLMl29sqqZIjmYMjn8aswEEXrSppRGDy0eWzLSTDd26Dl3JKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPmyQyhY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPmyQyhY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706090319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yfq210ULOE/BqFwEQD11cQ/YT9iyvMnRT2vGiFHcUJM=;
	b=VPmyQyhYajdRBh4dQOY136ZCxh6aLgHZlxtzjPBlh5jFSPK2exXW8lklU++shvFBLSk32I
	uz9emJF5kotd5EfZKZGCcaIaxTHZbhSwhzHaDuLvtjHn2hGv4d7GeOMbsuua+bP+ySeZSw
	EqxkwG7lZ3nMaVQ/xWw4w5TD0Zl7lmc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-t5KO_xFXMkKbBS4U_yffLg-1; Wed, 24 Jan 2024 04:58:38 -0500
X-MC-Unique: t5KO_xFXMkKbBS4U_yffLg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-42a4660fae8so46177261cf.1
        for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 01:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706090318; x=1706695118;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yfq210ULOE/BqFwEQD11cQ/YT9iyvMnRT2vGiFHcUJM=;
        b=g66xQrocpahvXFyRYf3/+ZRwyOinrfzf04DVETuI1LqJJc/rQZ2sR7Elb7kZIB5GiT
         0RbsRJIQgfOKKqSecU4t780dywc4fIpySGSyofyZ2HAhuEHHiA9tKEA11/k+BbkHPfsc
         5uh2IT0MZI4PABlxj83UtnJxhczky0e54ugkPj88piNTeo5AULBXfTAM45DD3BJrsn3L
         jZRDEvM5MxyPnpPa7QaHrs0FXGMEVG4gYtzktiYV+HsIC+GYXB5xQpTgXnS/yCMHnmHt
         ZyATsbTkM9dEhd/I7N64FkWHUjApalS+5LOmGiUzdujOfnkmG73JFEnv0tIkk12e8Y4Z
         Zlbg==
X-Gm-Message-State: AOJu0YyoW0iADxxvOSO2OZHxAeTNbaw+q2QUWcM4NWO2neTFK2h6ARXH
	aXY7j8WRYxkN5M8g1tA7/lcZ+D0JRyrTsVV5zJwVYShStetfFiTlEo5P97jhgpCjwdorCnk7nsC
	9E+f+XdbCLx/Bjou7NzIhJH4xFYR83E/8FoHuWUlcbuYPfMAQrM9HxQ==
X-Received: by 2002:ac8:5f81:0:b0:42a:3aca:3715 with SMTP id j1-20020ac85f81000000b0042a3aca3715mr1450604qta.39.1706090317887;
        Wed, 24 Jan 2024 01:58:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKQVZrvUmul3dbpKl5GFlQj49CP/5V+rS5rM8g76PTxlM0YEFyIhqvZqrMU0stMjOYim0ELw==
X-Received: by 2002:ac8:5f81:0:b0:42a:3aca:3715 with SMTP id j1-20020ac85f81000000b0042a3aca3715mr1450597qta.39.1706090317662;
        Wed, 24 Jan 2024 01:58:37 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-177-121.web.vodafone.de. [109.43.177.121])
        by smtp.gmail.com with ESMTPSA id dq2-20020a05622a520200b00428346b88bfsm4231931qtb.65.2024.01.24.01.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 01:58:37 -0800 (PST)
Message-ID: <5f8a77b9-1b6b-4319-b4b8-ea11ede43cb9@redhat.com>
Date: Wed, 24 Jan 2024 10:58:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 00/24] Introduce RISC-V
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com
References: <20240124071815.6898-26-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/01/2024 08.18, Andrew Jones wrote:
> This series adds another architecture to kvm-unit-tests (RISC-V, both
> 32-bit and 64-bit). Much of the code is borrowed from arm/arm64 by
> mimicking its patterns or by first making the arm code more generic
> and moving it to the common lib.
> 
> This series brings UART, SMP, MMU, and exception handling support.
> One should be able to start writing CPU validation tests in a mix
> of C and asm as well as write SBI tests, as is the plan for the SBI
> verification framework. kvm-unit-tests provides backtraces on asserts
> and input can be given to the tests through command line arguments,
> environment variables, and the DT (there's already an ISA string
> parser for extension detection).
> 
> This series only targets QEMU TCG and KVM, but OpenSBI may be replaced
> with other SBI implementations, such as RustSBI. It's a goal to target
> bare-metal as soon as possible, so EFI support is already in progress
> and will be posted soon. More follow on series will come as well,
> bringing interrupt controller support for timer and PMU testing,
> support to run tests in usermode, and whatever else people need for
> their tests.

I can't say much about the riscv details, but I very quickly skimmed through 
the series and I'm fine if we add that to the k-u-t, so FWIW:

Series
Acked-by: Thomas Huth <thuth@redhat.com>

