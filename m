Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A175316199
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779985438; cv=none; b=afZxRfqHEEq+iCfBHs8KVMxVBvR9aE6Kq0wMrp9sAEkTXtHFfUATIs02/VZ1KXvApXTCyAjQDoRSUgpZ/wj5TF6epMxnyDbU9oP87USrcCHgOnydIZzXDAicD/rY6xDI/ItJhsUH64m+rrDtzKsBIkwL1YsZyFbqLEbf9q7Clcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779985438; c=relaxed/simple;
	bh=Znz3SafD6WY/1QXyKAELH6Hj2CI/qjVkZBKD0Cb2krQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rtU7r1nirN2o+UwZcC8GT0vRyppy0kDJbPIkhcN9DiF6OUHGVpDJnpJWGfKThYcbjOrDHIMCUTtXQs9TgjTW/TU4riwuAv/jfHq3g2qJ7low5635T9gqKcnoPWAvPp2XrOQjkXG0og3MNUzyWLjX6ecWzJJqM4UgucP+w5D7H2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MxnFswy8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MxnFswy8"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36b7b7b7a80so510498a91.1
        for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 09:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1779985436; x=1780590236; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1CmlDw32A5+2Pto4vqUfWR06vY0nitO5ujz+6xcc8/0=;
        b=MxnFswy8M1LXO0CiB0xucqWgU0laD9ym4JLL1C/RQIAzBEgyBSnrhvUBHCXOCl6fhv
         PKlwIfbZ5caMeBxblqNbqI3fbzzVv0wZ497SO4cPpIz825xNFs1BEkC3Clyp3tWVWPIo
         cHN45MWEKLiYI9MM3p6JXvpAHAVpMgBO5Vvekfwe32GJPnmq8hBblUHwz803/ZusBxml
         C1wRx7M9siuVip9Mjsj42LeP1hhb7XUEyOAKDsT4fMR6nP1+51XS/C+lByqFqMLzaCjq
         KlTDKQLURIwndI8nMMC+jUsKXoX6vyyxlhFw5zSqPbCKv+9wyA67fUGrJZ423X2ovnpY
         s5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779985436; x=1780590236;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CmlDw32A5+2Pto4vqUfWR06vY0nitO5ujz+6xcc8/0=;
        b=CZUmDeNpS8/fwdB3a4j/AgjAXgNMFl+PfNA2he8+GC/Bfk8DewAxFUjsh9/dCnZ5oU
         Cmm8Qaoj0i5D4kQbhjpR6pOLEC8w+/HL9Ar6/bdy3mwQE0U+GGrngVM47ALMWOfevTwz
         er9W5XqT6QDrcKhF0A4lmjrG9MaCQmdYVQHnrVJAg5NhSRAiun2MmAp34GOf9zkrMo3W
         /M8bUMfH+/yyM5hZrWM/8wgczTSXHGdTajNfWJFimfBsqVIYeL+QiELVKrEY6X7L3DdL
         oVlTuoQ1ChR3uxCSAL5hVV1DjInivr+If/XL8ZRCP6F/uZdBZcPxXQcnJYHsipPg5LQe
         mQMQ==
X-Forwarded-Encrypted: i=1; AFNElJ8kM9kIT46WI8XQCKzZEfDOyZnd384NmzXzMo67uTJOKf0yQmh1yW3bxv6XYzSP4YZYjQh3S0M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmHyUx4BrQi5a2TnoVBppUnHeAbQ02aAhXO4rDW8AaJU8npDHS
	JWVhYJZvuogVOoCNXpwU8FxvkTKdqsbK6oIENivJM/DhNzKCVQmO0n3xN0s6Z6xG4AQ=
X-Gm-Gg: Acq92OGal07t6MFFEJsjKhRbGOvGn7mnJDJgXh3ezMaJO2FIFsLnT2WEU5WaPDdk/zN
	SigDVjltJdEYVqcRwSYXMiZHMe3i863W6lADVSomPJRyXRpeqR73Yrp3Ks0pB6Yw7tD5KaJcEdO
	lHp2pdQ+5fJEJY7PW9uuRjw5SJgoXVhejxDBxAMb1k3aErV2UAAO+gzkokQoV8jQ46P0W1gii1R
	5BDaO2iG0MwesjR2rqlGM32LofahSRd/VVlcF2lNEYcKZ4tpZUhGsvOq7TwS1cArc7BmUD5bso+
	5Z857wlKppbfNoNUmA/q2Ur7fkwo/BdcDG+aUhfIJduOH7GKssknOKjfRAGWkjDhLo5SbDo1Efw
	8yxHMSJMtXG52ctI4PCyd65JVx/8fxOJuAe1hCS3AXpaVEm4USrJFQbs0wsU+MRJX/qqwKbc1Pl
	w4jAXlfoQ7eKWTi7hPyVeEvvuooFpK1uWlZ3NwbdGd6gHL3p8=
X-Received: by 2002:a17:90a:f945:b0:369:9469:aeba with SMTP id 98e67ed59e1d1-36b9c6dcb75mr1635663a91.1.1779985436226;
        Thu, 28 May 2026 09:23:56 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.142.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36b90be1699sm2444666a91.12.2026.05.28.09.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 09:23:55 -0700 (PDT)
Message-ID: <376b8bc3-d377-4363-8a83-866a0c05c708@linaro.org>
Date: Thu, 28 May 2026 09:23:54 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2] arm: add wfx test case
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, "open list:ARM"
 <kvmarm@lists.linux.dev>,
 "open list:Default mailing list" <kvm@vger.kernel.org>
References: <20260527111822.1563679-1-alex.bennee@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <20260527111822.1563679-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/27/26 04:18, Alex Bennée wrote:
> This is based on a similar test case I wrote for QEMU's tcg tests although
> obviously able to take advantage of kvm-unit-tests additional plumbing for
> dealing with the GIC and IRQs.
> 
> Signed-off-by: Alex Bennée<alex.bennee@linaro.org>
> 
> ---
> v2
>    - drop TIMEOUT in favour of computed 10ms timeout
>    - add comments for each test
>    - use sevl for local clearing
>    - set gic irc depending on CurrentEL
>    - EOI the GIC
>    - display elapsed ns (no float to do ms ;-)
>    - fix some style issues
>    - make test TCG only
> ---
>   arm/Makefile.arm64        |   1 +
>   lib/arm64/asm/processor.h |   7 ++
>   lib/arm64/asm/sysreg.h    |   3 +
>   arm/wfx.c                 | 187 ++++++++++++++++++++++++++++++++++++++
>   arm/unittests.cfg         |   7 ++
>   5 files changed, 205 insertions(+)
>   create mode 100644 arm/wfx.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
