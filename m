Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B14B1DDC2B
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 06:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760076245; cv=none; b=W6e/9n0bn+W+zBZ14WxIqAQ2i5FB9rp4+xBUMGzXV8HZyrSwdYgzmWyQcoWzAGzDo5jr+7zPf/yqFVmrosiy8j38Gjk0E1qEzz1tmpH7HNg9XBbCDDGwS6myZfFRP9d3PhiPtACUZ8uOpraLsRTzy7mJVJkeo64GDjY6GPduE/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760076245; c=relaxed/simple;
	bh=Knw0Xm5x7sagdbZ2CjV09CXcu6GCzFXbWHzdPW7//lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o2UyV/vgSc/4uDVdNRCDU9q3pyB8WIy3PFzybKZ9K5htH9D9FhiueBBjVwPosAZ5LairTIRhbtzUhuuytKm4vkkIMNU6AL32zSCJcXj5K5N5VW+llorUzJ0VnjW9EdklilEIeEr7Vm4xteDXP2iPRdb1QZR6lsbt1NUz+q6ScA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=hK7Xad1j; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="hK7Xad1j"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ee12332f3dso373927f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 09 Oct 2025 23:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1760076241; x=1760681041; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0r1NWqbZEzbO/7uoD9Io08Y9S0vOpUmxWufTX689ooo=;
        b=hK7Xad1j7L3Svt0RCZhQ/OmObg7edGLGzYX6qJ/4/Ogb4yj8yvayr4RrkunUUJD3Bf
         3X13r7T17+izcb42hbFUWU09NepK2i/yNBjTPYKJeoYAJbutnzMFJ/Fd4D5SRVkShAo/
         PJVnBKzpwGAB3RieVxGRB53rqx2TIu0ib7O7W02/Neig+oMHoQ3HDDfG3IAE5+IlsaQi
         679vmX2I+oBT+FnMt53AoVU5d78Q/E+K+yvfcy9F8vYqqDamNTpriZAzs92//YFepX7V
         2woiLDu0aXFRPDG9vo4zyasYHOjIIXHI/ECGCSibLXrXdduM54CaXdsxgZvvGRmGcXEn
         yXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760076241; x=1760681041;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0r1NWqbZEzbO/7uoD9Io08Y9S0vOpUmxWufTX689ooo=;
        b=OKbNJYmGQiiCNIQbLv4tlr3D+cdEXHblqE1IqLdztB873JcGKzf6Luz/KedCvx+aay
         Bgeh4SXSMr0HCqb1WwCrjmIAE2E7r1+1m8Ci8vOjokAj0y/UEX8LvxVoGIxABjBG9HAb
         jyKttB+QY+CzsAE3VkrNrMf6Y+fNzWrTzWL4htiu1tylgpYB4GvSO49YQknvrxpCVww7
         p9i7Vhkfd5ktXvV1sBNSHqE0IHolo/36w0roKxW9hUHiUj03dlOQYwMBGvn36Dkpm6QW
         UvjJqBM0gpA/SfJB+tND36aBUwqHyGWQLasC15hQpCpJKXNv6ff6e7/C7CtgVUnrsIbr
         KBJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkOLfrhP3UhUmzHs//GdZ3l3lPMJhVtYGOVL0aaEmTw2McSdOzl4BFLFmo3s6RzFM0qbGDIas=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjUV3HJWedP5OsCJjA2iSj/0PKW/VTY4/9AfWMemPBkUop81DQ
	6u2eTSYfDFsY09NeWDubXAS4s99M7eYHNAUQNohN+roAV/2MQun9cCRLX4zkv6wxCFs=
X-Gm-Gg: ASbGnctoMW4P4Q0T8lBBoyJ4toTVR1vYrQsMd0DOf5QPD5d9949oCeZInY6pFU2OwmA
	IBiDjBbuiACA8U7D5d7uKurzXnOhmziw2LLXKAjDaG+M8uBiDYebgi63HBZwmSFuN9h398N1fzo
	oknSHv+0ftWhoKSFHs4azNIfDIVlw7fh4x6TmJFoX3YpyZueyVlHkdDm/Qj0s3jzlmtbqSlbSZz
	hVkujClF5SiTOpC6NpjpkBpoNKEaktLHBVUOrE/dbY6I2lRtLyl2/eXsgKZ0vmw6fhjKfxcxIzn
	oKRXD2bfuARsOEDCyvE1WonqYCxN3vksYK1/J1Ji3OFM/wpHWg5yzWcrGmfwY03NnuEfdhwQV2w
	FYv1nI8rv72LS/Ql4mS7dIyfIRvwqQ8N+qzChynOlkXQPTB+AbKCAZD/m/8NDs3PJMtPtyP/mMf
	SC3IS2HymLmfv1aRArOwl11AWRiq5xE/8IhVVUrFdQRTsvqKy6tIA6q9lqIawzF3RKiG1cNsg25
	yQ4Zdhx9FVpfGs=
X-Google-Smtp-Source: AGHT+IGdlF1jJjO4YieAmsTi+1sflzPmBHkkN/w6hIawqy3/GnHDDQIxkQU107FHhfo85ITKsyPITg==
X-Received: by 2002:a05:6000:18a6:b0:40f:5eb7:f234 with SMTP id ffacd0b85a97d-4266e7cea15mr6381158f8f.5.1760076240292;
        Thu, 09 Oct 2025 23:04:00 -0700 (PDT)
Received: from ?IPV6:2003:fa:af00:da00:8e63:e663:d61a:1504? (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e8309sm2387739f8f.50.2025.10.09.23.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 23:03:59 -0700 (PDT)
Message-ID: <47d87ba2-83c1-4a0d-ba8a-cc7adc2b105c@grsecurity.net>
Date: Fri, 10 Oct 2025 08:03:58 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86: Better backtraces for leaf
 functions
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Thomas Huth <thuth@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <20250915215432.362444-3-minipli@grsecurity.net>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250915215432.362444-3-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/15/25 23:54, Mathias Krause wrote:
> Leaf functions are problematic for backtraces as they lack the frame
> pointer setup epilogue. If such a function causes a fault, the original
> caller won't be part of the backtrace. That's problematic if, for
> example, memcpy() is failing because it got passed a bad pointer. The
> generated backtrace will look like this, providing no clue what the
> issue may be:
> 
> 	STACK: @401b31 4001ad
>   0x0000000000401b31: memcpy at lib/string.c:136 (discriminator 3)
>         	for (i = 0; i < n; ++i)
>       > 		a[i] = b[i];
> 
>   0x00000000004001ac: gdt32_end at x86/cstart64.S:127
>         	lea __environ(%rip), %rdx
>       > 	call main
>         	mov %eax, %edi
> 
> By abusing profiling, we can force the compiler to emit a frame pointer
> setup epilogue even for leaf functions, making the above backtrace
> change like this:
> 
> 	STACK: @401c21 400512 4001ad
>   0x0000000000401c21: memcpy at lib/string.c:136 (discriminator 3)
>         	for (i = 0; i < n; ++i)
>       > 		a[i] = b[i];
> 
>   0x0000000000400511: main at x86/hypercall.c:91 (discriminator 24)
> 
>       > 	memcpy((void *)~0xbadc0de, (void *)0xdeadbeef, 42);
> 
>   0x00000000004001ac: gdt32_end at x86/cstart64.S:127
>         	lea __environ(%rip), %rdx
>       > 	call main
>         	mov %eax, %edi
> 
> Above backtrace includes the failing memcpy() call, making it much
> easier to spot the bug.
> 
> Enable "fake profiling" if supported by the compiler to get better
> backtraces. The runtime overhead should be negligible for the gained
> debugability as the profiling call is actually a NOP.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
> One may argure that the "ifneq ($(KEEP_FRAME_POINTER),) ... endif"
> wrapping isn't needed, and that's true. However, it simplifies toggling
> that variable, if there'll ever be a need for it.
> 
>  x86/Makefile.common | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 5663a65d3df4..be18a77a779e 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -43,6 +43,17 @@ COMMON_CFLAGS += -O1
>  # stack.o relies on frame pointers.
>  KEEP_FRAME_POINTER := y
>  
> +ifneq ($(KEEP_FRAME_POINTER),)
> +# Fake profiling to force the compiler to emit a frame pointer setup also in
> +# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
> +#
> +# Note:
> +# We need to defer the cc-option test until -fno-pic or -no-pie have been
> +# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
> +# during compilation makes this do "The Right Thing."
> +LATE_CFLAGS += $(call cc-option, -pg -mnop-mcount, "")
> +endif
> +
>  FLATLIBS = lib/libcflat.a
>  
>  ifeq ($(CONFIG_EFI),y)

Paolo, can you please comment on this one, so the fixes for ARM and
AArch64 are no longer blocked and, ideally, this series can be merged?

Thanks,
Mathias
