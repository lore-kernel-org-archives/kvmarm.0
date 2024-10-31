Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC1819F13B
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730397805; cv=none; b=i546Q0uddPU3CjpWtpsdr/5tzn5/6byn4S7B+vJfj9TZGSEyDNiL8dDPTlLoyP527our6sLgjk4QwxEViTNTDTY9bcCmldaF9apiaPaZAspNwfo2cn1ORLbnwRi0wR6hEKfkuvYpTio8rnFB29MHsVUTKybixtlelr667dZ/iO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730397805; c=relaxed/simple;
	bh=G8yAkXEkB7ESX+4dpwShN5jHc+uy2dh0rZ5h9auy8U8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JJnsFTkpZM2N4xyyyhNXqZrMCt3bShpR72DMDOLBm7ayCHJLE8W4qJPe/OiXtZ+djwGWWMvi9N+YdHemhl94ivuLx316/VdZ+kwzbl786tyJzdlF3hqKBa+55skIGLmegzpjeid9thTmjhMM1fGBQFBJ22g9GQKLgw4ZQmgyGY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7jUjfu+; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7jUjfu+"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-83a9cd37a11so45617639f.3
        for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 11:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730397802; x=1731002602; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AqFVHirLhrZ+YFiVZAcY6QE2WmjZdVsPtC7OHYHxAto=;
        b=N7jUjfu+6FdHEAKUW7FGq7DzX5n2UGjT72/H5MpcaBtpaVBAY9g0+lGsZXguuLs9Yy
         V8+ovJhs3V3tErC9XAWZjOS7tmYnpBqm4venVmim7FyEDarEwoYYOf7E5ww/mp0+4hUH
         LF6X5w6fbWH4grP5VcUMF18cT+jte113LtJI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730397802; x=1731002602;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AqFVHirLhrZ+YFiVZAcY6QE2WmjZdVsPtC7OHYHxAto=;
        b=Zg63Swx1hS0sOBZhcbhpKXqI1uOv0TP57CWiiaYRnG92ZXeHdIVlamoBDS2c76K1P+
         B+XmXu7D5WTh7XSuW06Wb9o5WGdiacQoJYeLRln8kqTrJuIPYpWUvMlCQkXc6CLDrWZ4
         gurAjJXjAdZbyc27bdk90LechK5ry2kisTCnXudbfiXg2LEOzFk2lOpDqE1DIJxoZ9G+
         Ey2yAGZRt1nAZPSOfbQ/JdJOz5UTFVW/4bfs2SXR77M85fVl3roM5xjo1xA2FmPdFnla
         YZo4RrC5ZMfn44GcXQmPVQkpbAZu6sZzAkqenPWcm/rVjY+My0Y2vgY0wpLzPgykhWgA
         vUWg==
X-Forwarded-Encrypted: i=1; AJvYcCXaRNOKhnXTrsZYJ4rzATTb0pcRICFVpm23maGjH2uPNxB42i0BEkk5A5YafGtH8QC6SziMCqg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxz+MYw/vbEm/OAGhYcLjO8ojgtj0ZgQw8mtVijgpHKizwzY2wI
	OgF0rlGz6dsic+JUiu2KOL/cwN4aNh6JYt9nrbchJzwgoOMt2ssv62leIDimgYE=
X-Google-Smtp-Source: AGHT+IE/2tMHtynRkwFoEe4g15eKesbze+UUZeNHxyrhBMlrKzOpbj1uiD8+ldwsn9EFl+/fSR/Tfw==
X-Received: by 2002:a05:6602:3fc5:b0:83a:db84:41a8 with SMTP id ca18e2360f4ac-83b1c4b4febmr2360267439f.10.1730397801962;
        Thu, 31 Oct 2024 11:03:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de0497785esm380041173.89.2024.10.31.11.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 11:03:21 -0700 (PDT)
Message-ID: <4703b646-3df4-43d3-ad75-92a38f5574c3@linuxfoundation.org>
Date: Thu, 31 Oct 2024 12:03:20 -0600
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] kselftest/arm64: Add 2024 dpISA extensions to
 hwcap test
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20241030-arm64-2024-dpisa-v2-0-b6601a15d2a5@kernel.org>
 <20241030-arm64-2024-dpisa-v2-9-b6601a15d2a5@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241030-arm64-2024-dpisa-v2-9-b6601a15d2a5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 09:34, Mark Brown wrote:
> We don't actually test SIGILL generation for CMPBR since the need to
> branch makes it a pain to generate and the SIGILL detection would be
> unreliable anyway. Since this should be very unusual we provide a stub
> function rather than supporting a missing function.
> 
> The sigill functions aren't well sorted in the file so the ordering is a
> bit random.
This is talking about the one that isn't implemented. Can you add
a sentence or two about the ones that this patch adds?

> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   tools/testing/selftests/arm64/abi/hwcap.c | 273 +++++++++++++++++++++++++++++-
>   1 file changed, 271 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/arm64/abi/hwcap.c b/tools/testing/selftests/arm64/abi/hwcap.c
> index f2d6007a2b983eba77a880ec7e614396a6cb1377..beb380bc09b0d07269a85a60e5d2977367740473 100644
> --- a/tools/testing/selftests/arm64/abi/hwcap.c
> +++ b/tools/testing/selftests/arm64/abi/hwcap.c
> @@ -46,6 +46,12 @@ static void atomics_sigill(void)
>   	asm volatile(".inst 0xb82003ff" : : : );
>   }
>   
> +static void cmpbr_sigill(void)
> +{
> +	/* Not implemented, too complicated and unreliable anyway */
> +}
> +

You anticpated "not used" messages looks like. I see that
this gets called - thanks.

Looks good to me. With the change to change log

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
