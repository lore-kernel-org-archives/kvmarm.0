Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED1F2B9B9
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 07:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744700591; cv=none; b=F+N5eHzZrZQX00dSbLjspIBy6/EkzfxZUEvKgCsn/5jx7xpIaBQ/UR7sYdVEPdyqjQ/c2GBVYmrNhWwTRM53vRuHLnQXWJStZki6ak0Om1RrV/Q+CUIy/dhJx7d71e2cYOgyVQHHlk5C587GlAik0X2wREW3k2dr4As1rhIE/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744700591; c=relaxed/simple;
	bh=71phUSG+VBzdAtW3jTx7CrGNdH7ZAf05nMpXNyHHalI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jk1FKOkoSbGqTaCUSa1VUoqeXOsHTK5sq6cYbokpptrRqkxSbCA46yVYQq63vilVBgM6gQxyhIcbtrqiDyWG+8+wjdRKY6Wet2rej1/nKTwb8T7kLVKWJfuJNPiYTnJf1Cx7pLrI/r1RUcY0UIh/tlX9PrGW6a4d8V6mPnAj8Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wOz561zE; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wOz561zE"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39c1ee0fd43so4987909f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 00:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744700588; x=1745305388; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQIZTL9G2c/6upLFkGLhEBR0xC+hQ/0nufe0kTqCXv8=;
        b=wOz561zEXJae9y2IJ5hyph3Q+P1uG5loXTfBd34c6gYhMORtDI/pBf+TfTeoJzSWHK
         H2Qe1Kbhu0TpvA1yIs6AYhXvboJF6sbOyugilHhxf0J7ntqAom2YV8mtQ42KT+aglo/g
         sJr2trtV4Ou6c/90zuXywIHUIbllWaB69SDpoNrHESkx81/iQ40FndShxIuWZccMH0DR
         m7mO/oNVLL1pEZmoJdssfhw8dUZ36oW/jLhn1TCv/ArROsc+1LVu6s4HCebHdSNAQxKp
         vwlxkrZoghNsimI8PbofzMKnYd3S0JkPnaaAaC+oZPsNw/Nzd8Kjex55X+jituPmUZHj
         s9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744700588; x=1745305388;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gQIZTL9G2c/6upLFkGLhEBR0xC+hQ/0nufe0kTqCXv8=;
        b=CG2QYB7ppH2x6Sguf8b9yn7x4di5qntEoPjHSLezYulgpg1WfOnv4MORHa5Y9x8yHi
         WSgXdOmf35vuCK9tB79d6jckYudV1+EzyIq7hVbg5iV1WBLTaW5I7mzuxIsKYRsRf3a7
         t5e9FVHn7xsv1hEBAOxbIPbIhgBH5aNoc8OZiJT9HSVbeqvsfD48Ahmn3qWdODJ8hwGl
         SsLRjPj50CUEOaKLtNt2hf9EhD6NKe0K3F91VWs4LYZklMsmwRBL3O8Mrdl+pj2ZHlxX
         uimImayAmzVhfPDONg2V23DqwSQ18HDSAmnkb2lqwbtd9Rghdya6wgUzzH4miOALrmxw
         tDBA==
X-Forwarded-Encrypted: i=1; AJvYcCUNaHqxGdqbCN/zivLq3TlobKGhI+5Da53Kdrr+xlEaZXvk/j+tGoWC27RRqBd69fas/PjcE/k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIIpXiSk9xuLTFuAweYnQGhyVG12LZLliMzhPZmMUKUB2nOQG7
	zu2TNmgPkrcHv/rMF7aJ/JQn3gz4j7RQQGnhYZcssmHAZswQrQDRriTFtjMAmb4=
X-Gm-Gg: ASbGncvwAWyTJErir2wK6jvhhuOQYhqgdiqd/n+OP75TWO5+3Vyo8x0zcAarWXmPNRS
	IP2Ot3NPfYVmVxdSiTfCk4kxu0ePsEnseJq+wZ4X8Sk8A0eMaAD8W5HDIuVYF2pJoN8tpCYLkgC
	wyJV5HAZ+aeRdMmGaTbw4VS9kg62c417QrPRYZ6R62eZ5+Xcp0EoNSMQfSWVigr27H60Iw3l8ct
	sPnFYDTF1dmKZMc1SoBQdAHvDhN7R4WGyBDpFBPVxRsF81fQp4NvJkHiBTMKBe74YcEGwjzf8Ul
	jHWxDyejmZ6B3bLyABZDCjXZNgLcVwbjIfGxdewn3VadGA/Lxr/QKbM7yuOjnd3o2g5GfaYCJGx
	X2/+bQ7xl
X-Google-Smtp-Source: AGHT+IFdPTJ8LHSnf9kexPXg9Yw57XSpwMyM9HqLdnmKOqq/iid4dTW/LxIaw775eBPO7mzIdnTsQQ==
X-Received: by 2002:a5d:588a:0:b0:39a:c9b3:e1d7 with SMTP id ffacd0b85a97d-39ea634bf9amr10517202f8f.29.1744700587920;
        Tue, 15 Apr 2025 00:03:07 -0700 (PDT)
Received: from [192.168.69.238] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eaf445315sm13165936f8f.82.2025.04.15.00.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 00:03:07 -0700 (PDT)
Message-ID: <5f9a4bc5-5569-437f-8e8d-f386dd51e33a@linaro.org>
Date: Tue, 15 Apr 2025 09:03:05 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] arm/kvm: write back modified ID regs to KVM
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
 pbonzini@redhat.com
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-8-cohuck@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250414163849.321857-8-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/4/25 18:38, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> We want to give a chance to override the value of host ID regs.
> In a previous patch we made sure all their values could be fetched
> through kvm_get_one_reg() calls before their modification. After
> their potential modification we need to make sure we write back
> the values through kvm_set_one_reg() calls.
> 
> Make sure the cpreg_list is modified with updated values and
> transfer those values back to kvm.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   target/arm/kvm.c        | 44 ++++++++++++++++++++++++++++++++++++++++-
>   target/arm/trace-events |  1 +
>   2 files changed, 44 insertions(+), 1 deletion(-)


>   void kvm_arm_reset_vcpu(ARMCPU *cpu)
>   {
>       int ret;
> @@ -2050,7 +2083,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       }
>       cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
>   
> -    return kvm_arm_init_cpreg_list(cpu);
> +    ret = kvm_arm_init_cpreg_list(cpu);
> +    if (ret) {
> +        return ret;
> +    }
> +    /* overwrite writable ID regs with their updated property values */
> +    kvm_arm_writable_idregs_to_cpreg_list(cpu);
> +
> +    write_list_to_kvmstate(cpu, 3);

s/3/KVM_PUT_FULL_STATE/?

> +
> +    return 0;
>   }

