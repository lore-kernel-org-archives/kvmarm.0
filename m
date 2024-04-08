Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21ED81D558
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 06:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712557875; cv=none; b=p3P435AevVprC5bO7fDW2SYULjyLZv8vyzk19gftwdHUOsNm7zp3i6A0vrLFf6Z57xgld+gvfHHxiluZ7EdZi+pGNsQAKtsIyCBxablqXTUhO2xT/LcnDwq4UTrVNWX7sy+FETnVNt0WwGZzzVYveUnbJaZfzlWSAivKUSRABQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712557875; c=relaxed/simple;
	bh=QIczQJye6ulVbsUFMRnntvy0HYTn7yr5hZTeptv1VQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWYBHb4yvRYBf+dkVJySiOO4Zc2HnoH4ziiqmZbR2YvNGAL/yxIdfHztgPPCN9X50ZDfIC5PuCbPDTIh6OZK4Ic433JZp9lQqO5hpd314BW8Qx6cDJdGEz74BB63SHu6gPOoAe0b6Q8j+U/Jd2LAgaXAQvGw2xf088s1ZloVzW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ccW0TvmB; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ccW0TvmB"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-516c403cc46so7203771e87.3
        for <kvmarm@lists.linux.dev>; Sun, 07 Apr 2024 23:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712557871; x=1713162671; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9FiTVZTYX0KeQgSiuUnwPMRri9NFK7ss97QqAH2vahM=;
        b=ccW0TvmBe8Dn4ofCCkPcWXJ91gO6NxEGOJdKr6Q9q+sPrYX0gxR4gH3GrAlUKBCZ5Z
         8PAHZ71ap5gWMWH9/TVtrvOJ1yX+H3rtqI575oFwsQKHU1+VpVz/AmXvLcJAlejFRL6F
         9l31GPRwba/bvlkAd5t5kmf4no7U7GbuoGBcDuHrHZ/MuQJq+xQkUKd8BJHUPEiObFQW
         NIL+N3PBut0WWzbXGHSvx91inAPgne/p9vi+ZE2RjrH++dh1nnUenPGuWBdtGHNeSxuB
         0IzMjdpj4WCjlUyG4KzYskrX99oA7E/5vA4RMjiriPRvTvXUpDKiS896I6qFluG+ea9x
         qwSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712557871; x=1713162671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9FiTVZTYX0KeQgSiuUnwPMRri9NFK7ss97QqAH2vahM=;
        b=qz8+jpr9adpZfz9lK14mMLimigFcR4dMDoXK4z12piCcDsyBNQL1YDl7ucI/gMMIvx
         7gNiLWdO4NJQIpu4TaG7ep2WZ1n8fttTJ5+TTPOLCkDIj2z1hH3wfaSn880RRdFL3pAX
         tCk2F2cmkqTeXSS4LqyLX7PQWQs3HVd2qIiMy0EkAQTAXYCyuTHJ91nNLARRQnZVGeR5
         SluqZ5E+0ONRb6P/ND+SsI7G6tK3Nm9F7KEC0wOtyUJcxSZp4YkZVAikS1k1KBsWokNN
         kBeGiF3fHe8J4YFktFVEOB83HCiQFmgl+3SCA7GaLlPGFVDyBn5diVVQVpbDk49mwIqO
         DZ5A==
X-Forwarded-Encrypted: i=1; AJvYcCWDGd2vd8WvWy2yFLp7PueDRlvL+yVEJ2hr53tOc76fgTu8BkagswzVRJI5NTKs73bYyl64uTzXByJlIoISKfBVun9+FjR/
X-Gm-Message-State: AOJu0YzjR6jsOFGRYqzaVMECYbateUDAFFmbGSmawTzNa9cYszEVFi1w
	odDGGS1VfE8coZ3o0RR+3NSGr3C/SD0i2v/vwsmLLaBOiVZUcqs2z5JaHjX3kMM=
X-Google-Smtp-Source: AGHT+IEA6kG/jLzxIs8qEGxEX4HFyMOSTK+qrw+cqbwmL3oOUtFSjPH+UfGHY26kn1STJDpLm0t9kA==
X-Received: by 2002:a05:6512:2387:b0:515:d176:dfd1 with SMTP id c7-20020a056512238700b00515d176dfd1mr8022020lfv.56.1712557871271;
        Sun, 07 Apr 2024 23:31:11 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.144.67])
        by smtp.gmail.com with ESMTPSA id gs44-20020a1709072d2c00b00a46a27794f6sm3975527ejc.123.2024.04.07.23.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Apr 2024 23:31:10 -0700 (PDT)
Message-ID: <d1ad8803-16a9-4fd8-bc9c-8d38171a2554@linaro.org>
Date: Mon, 8 Apr 2024 08:31:07 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] KVM: remove unused argument of kvm_handle_hva_range()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Sean Christopherson
 <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-3-pbonzini@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240405115815.3226315-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/4/24 13:58, Paolo Bonzini wrote:
> The only user was kvm_mmu_notifier_change_pte(), which is now gone.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   virt/kvm/kvm_main.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

