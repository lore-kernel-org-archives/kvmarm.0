Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3C0748D
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 13:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734011982; cv=none; b=aPSVqJDnvGRup6FlPmqzP3/cMsbFw6KRgsaRlvGW1fKEuJsr8hGJsZL3UNJ0ZpNxt0hwM6qEjHeZ5Bg07824qbHoy0+IqEesgUpYP+c+9n6H3fTRMqwaioJEaQggX6kDEUWbrLKRxljgggp+NehTYOLXK75657D850qNLAM7pLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734011982; c=relaxed/simple;
	bh=f9DJQ5KNRMbkkamz8t4+VV/pgLnzTnnWTCtp0Vmyy5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bp9rb1e/FdbxCGgyRRgPaRSCAraLcbo1BIgaob9LZfqAZSEkD8fXPSn1gC1q7q3trt3O2DTP9jZ7uNwLp0vh6+pBVw6Dv02xeJP1uJlYknYSyXk1TDEerf50ymxkg+HWXfiE/fR1jPhWG9xgzriE8yHR31KD4U0hEGiT92c3J9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ToZTuTaQ; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ToZTuTaQ"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-71e2766994bso273080a34.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 05:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734011980; x=1734616780; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nz+Ev7LYG8CfqCq+2dhn+rzxKVPN0OVRSTVDNYX1Qbk=;
        b=ToZTuTaQsXgB7pkwrycpHADkAcfox5nH/4o+ibaGlS7WKJB7buQICZDPNza7CCypj0
         Yo4rzMZZl6HUH1BH+tduV0HJZ2dtSz+DOyg5ce/IpGYBOoNZAWpbmyRqNoGvHl7Ewprd
         n1S/0ec9m7P59Sy+pE3IFCi/y4XjEgCt3IhiQYmPYOP2YUg1rvgYaJyAsGDK7H5KLojP
         Y0lWHm0zE3Y8w3ZIolBUcKrazTcCYvMH1xk6xXRh7NN602ARg1gc1h/LKEAb1txjF/K/
         MFunQtthkCkV1XEFC5d6E5udzXC5oLasdlQ9FaZpKJBMLRRTzGNGq2R0FREMcXzmU5ME
         WNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734011980; x=1734616780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nz+Ev7LYG8CfqCq+2dhn+rzxKVPN0OVRSTVDNYX1Qbk=;
        b=KdzbjGoodhgtBoKYzdCU4oifkyPAWGMxyHsViHMdQFeqFKPyZpGGv6b808fXK2sR0I
         SctXjK01/oYHoOp1ePDz5DM9fc1wdyj8sOY3IkWJ2/SejhXocZJxqTgmOhjeV7gzaQVq
         BpF4Qs34X5rSlhZyMyc2YiaOw2BW1rYMpFP0JS/KxGz2256W00Dmhnu/PQVaY97Bb814
         ACKd3CBl880k5a2fdgwMrUTuweijSgp58p+T4YcxAg4aa+oOhrflc4mteRjPTYMwIsLO
         bwdj/Ao/K81XazSS0OnPJXS/mn2IFPSIP8UeZV+MOnXEbyU9R6t5DyT2p0TZvfyf2Bfl
         PGtw==
X-Forwarded-Encrypted: i=1; AJvYcCVexsEX9wV9dSbCc6coDW19blw/57bTJR7zTtnEyhWVIZeTC3kYQJDRkURzhRAiDoqASAd50NM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJI3YqRRmh9xxdclT3L8HljZSu/T3Ki24QeJ8lm0WPNAIql8do
	URlvx5cZEyHVDIm+VP0hMiKbirwLv6nxFqHknV3eCDqkHsRAaNVNnM4hGsjFy8Y=
X-Gm-Gg: ASbGncs80PoyoNNw6AKyn2qItn3nU6SZHfD1S0JGHWto5P64Ldc1I8gFr4fADmaosmY
	PZXWKkioyygL+B7AN2xjsU+pOx/8qEW4d1mqNrQq3SUBufCCNJ0qhrvDj7nUrpaSmKo57jUT04Q
	Nb/QOYIFQmfq5373K0/FjqS1PT68Pm+iOBqKxxs1Lk/BsznkBVpgNRrxLGnN08gMoEcC705Bv7V
	JJe3orQeqJowTISU73orKkg4nKbb7jBNkxlL7lGmGIDugLUO3r1/ndQnpxely9SlM94YLv99+/d
	DRrFaXZavAMqkrvPyLDIn9vKfbUqIT7j2Pw=
X-Google-Smtp-Source: AGHT+IH5eDYRi/vQn78qhwaOELL0IdjRh9Im2SLDv6UWdiI16v0PX3maXqZOmvheBWXSyL4zOa53rQ==
X-Received: by 2002:a05:6830:3509:b0:71d:f9f1:7f3a with SMTP id 46e09a7af769-71e370fd784mr187396a34.24.1734011980143;
        Thu, 12 Dec 2024 05:59:40 -0800 (PST)
Received: from [192.168.4.112] (fixed-187-189-51-143.totalplay.net. [187.189.51.143])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71e08cd4525sm1200291a34.3.2024.12.12.05.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 05:59:39 -0800 (PST)
Message-ID: <a1ad71d4-4148-42ee-b77a-fc4df1f5c2c0@linaro.org>
Date: Thu, 12 Dec 2024 07:59:37 -0600
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFCv2 01/20] kvm: kvm_get_writable_id_regs
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 eric.auger@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev
References: <20241206112213.88394-1-cohuck@redhat.com>
 <20241206112213.88394-2-cohuck@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20241206112213.88394-2-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/24 05:21, Cornelia Huck wrote:
> +#define NR_ID_REGS (3 * 8 * 8)
> +
> +typedef struct IdRegMap {
> +    uint64_t regs[NR_ID_REGS];
> +} IdRegMap;
> +

Where does the NR_ID_REGS come from?  In particular the * 3?
IIRC, all of the id registers are in op0=3, op1=0, crn=0, crm={0-7}, op2={0-7}.

Whatever the actual answer, some comments would be good.


r~
