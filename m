Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEE417FF
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 02:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709779160; cv=none; b=b+/55eb+TIwPOyfprpikbHCrhNR78wl6xJFczD3hJOwEuDjo2a1FVPqqw3gMGz0SEfyXefFvNpU3HxUZjYWFQZQ5i2LlhARYBZjMV1UjVmk6bFLl7i+iuqgVj9FKe3OI/rlMQLP0DsAMowyVo0FKx+YC0ffY7+IYuiK0J6+c7Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709779160; c=relaxed/simple;
	bh=ZoPyxcOT0+8ZByT6br7pG2XGpoOYWHZWzr4sILHr5a8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aI+NM4+KG+zk6ggbMGeydYxWPum3gnzmwIxZgnuZIVie965bsWVFQzkgej3Xhyp2JY4pAHvO9ugZR9Q1Ztruc480dGYt84R29/6CLPqSc6/FSi4t7KX9yAKiPDJwke0BZy7CZb6Aee7K9xgKY/jh913glTOKHGxiheeMnhP4aZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YQ8kCEYk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YQ8kCEYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709779156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pXsc1bKFWtbHuFyWBXyzFWmEgl+KeYAh4ptHDJM4aFc=;
	b=YQ8kCEYk+j1c4A2diExAgIXcgSjMJFTlmlXs5jPJCrBRLEVsdqQxsH+6Td3/zmg0wMn+Bu
	4/c7ZQmHgB/biFGrqEKkrqrflI25wjXUyosIlERuVsngKDJmubMorssp7qNvfMQOHZFxij
	bdBd4HqMdi6dLhGZzTzgwHgMGM4wypk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-X4-aFHSLPqeXmspsvo7DPw-1; Wed, 06 Mar 2024 21:39:15 -0500
X-MC-Unique: X4-aFHSLPqeXmspsvo7DPw-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5dc97ac2facso149657a12.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Mar 2024 18:39:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709779154; x=1710383954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pXsc1bKFWtbHuFyWBXyzFWmEgl+KeYAh4ptHDJM4aFc=;
        b=HAbRIQVVaDl6rGJCFJYrj+gIv9qkYs/f3V1i2DK6ckWbOaMLoSJiP0/PlIL9o74ur+
         hX8OWGmlalYaKhyWjl0+aGsPN/dxN4Au1HyW7MRHCYNe+M9p6NxGREyM4ycJI0GwRlJa
         pO3dCTt1OpsptPuiWo68HlpC7p6MvNPDC+nrhu/XYekY2EneTsNyAvyM9LsHYRCZBqBR
         S5FtUgMgR4MzKcwa6M2aIUphC0hQAne7jbA/ATmQN8YSxmI9UhKRbaiGJzS2/wC0HySC
         sEOL3lS2XDOUvaB/9TyY8D4BsoSHYxUYuM9Jle9D8GMIIKeZ8xgas9VlvEQdDbozbS3S
         QtOA==
X-Forwarded-Encrypted: i=1; AJvYcCX9/DTUwwwef6w4eJnOaEmuXYzcwNqQELI04Mu/ncMhnMipaCg1pS/uPG6RUxcp0yoyyjKyt/lgvck6luV9dEyYygXKY3wE
X-Gm-Message-State: AOJu0Yyw8fTRVe3GlDIeXNnwc31gzrSOkiB0Q9rncNh0a6+rFXf2sD9A
	uITr4lMiI2SUdS0hm+BlOQ15x7zUpdf+FGSTOxJjPhSUtKZMZdkNCsvt+jCILoZEhaR9jmS2EeH
	zQ5YHmYA0UKm8Koq4OZPZ3p5Rc5dJ7umBzb7znxD3gKZa4zd8sr0CaQELnSTAFQ6C
X-Received: by 2002:a05:6a00:1888:b0:6e6:4578:e309 with SMTP id x8-20020a056a00188800b006e64578e309mr1028141pfh.0.1709779153860;
        Wed, 06 Mar 2024 18:39:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiF6tBcOzSAvvkZL2vc2u/gS+WpXHPhEPgJibtc0/SwQQV2GfVWmNSjpQIAS5yzJgyN5a3VQ==
X-Received: by 2002:a05:6a00:1888:b0:6e6:4578:e309 with SMTP id x8-20020a056a00188800b006e64578e309mr1028126pfh.0.1709779153532;
        Wed, 06 Mar 2024 18:39:13 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p8-20020a63e648000000b005d68962e1a7sm11750397pgj.24.2024.03.06.18.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 18:39:13 -0800 (PST)
Message-ID: <c678ec42-b6a6-4ec5-b7e4-f5e5bc9542e0@redhat.com>
Date: Thu, 7 Mar 2024 10:39:09 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 02/18] runtime: Add yet another 'no
 kernel' error message
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, nikos.nikoleris@arm.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-22-andrew.jones@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240305164623.379149-22-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/24 00:46, Andrew Jones wrote:
> When booting an Arm machine with the -bios command line option we
> get yet another error message from QEMU when using _NO_FILE_4Uhere_
> to probe command line support. Add it to the check in
> premature_failure()
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   scripts/runtime.bash | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f2e43bb1ed60..255e756f2cb2 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -18,7 +18,7 @@ premature_failure()
>       local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>   
>       echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> +        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
>           return 1
>   
>       RUNTIME_log_stderr <<< "$log"

-- 
Shaoqin

