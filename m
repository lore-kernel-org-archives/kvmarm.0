Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E1CB641
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 12:47:30 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-501eec0a373so1684623e87.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 05:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695300448; x=1695905248; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FlXVGGihr/Um8VppFFFoZThvd/Obt/HhaeL0kASOwJ8=;
        b=pyBE4ACc8AGyTH4mkvL/2cmIG2N4Afr/xAVjZRy+6DiQa7JSzGi9O+r5R6Vy7R/K1Q
         G0r/woZ3RRxWvvhaDKAKipHc0+VAGfTYn5hWdmrDRTbBlFxwDdeJvzg/wBJy5FH9QZii
         XBsb6MUyrVHVBs9yrir+PBHZcTO/aTPD5erEnN4aDdz5ZHVv6Opr17glvpBth46rNF5f
         qTsOKo+KD70c2SJdvXGhLTWMTjH7AXAo8e6sW/gq7HQvRJCRvkzJPycaJAZyp9Nk+015
         0bK154aaaOcqQkIXdFBd1uOQw13b/mjO5Qu8s/HmZ5V7Nm7SiXUHXMHt1NHib+nYoVsw
         QEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695300448; x=1695905248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlXVGGihr/Um8VppFFFoZThvd/Obt/HhaeL0kASOwJ8=;
        b=spY8WhurlERGkwFq5fr9N34EuVfPjq1lokOs4zN7nECBdlM/Q+/4koCp3jFj2clBhj
         dB7ngjAu+9lXSAnDJVinKyju6Tce9z4ftAlKy1ZWxSz+jjvw+w/5/9ck/9UWR6QzVucJ
         sAtzGI4Pjdr42/p3BH4TkLqEPu558BFPFy3dmFn7OvDGlwenjfHEaz4aPfiR/rWz13+8
         JAvAH8TMNNxg/HGAKxKeZ8+g/XlxlcjE1M9Ca1IC4NF73+ltZLyagHTmKgR3eoBJ6blq
         K/Zhuoxf/l5SkpQ15/3DiUmtPWlZMFlgoim2c0g85Bg/CorJC7TkrD+CjdaelKmibOkT
         69GQ==
X-Gm-Message-State: AOJu0YyaNKGibnK9KApgYt+lk/sqBzylkUIQlhMH44r3Qz/4Vlxi5XfZ
	0oLejCxNKJqmiVcdC+hopsrEnA==
X-Google-Smtp-Source: AGHT+IEVmLQq+UzBdZyDArNwFSahITnvkbWTPZjwKGfWuPXbnyC9+l1/YPqWIBds6xw1bDrv8ypH8g==
X-Received: by 2002:a05:6512:702:b0:503:183c:1223 with SMTP id b2-20020a056512070200b00503183c1223mr4473980lfs.7.1695300448633;
        Thu, 21 Sep 2023 05:47:28 -0700 (PDT)
Received: from [172.20.41.70] (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id c21-20020aa7df15000000b00532c5e2d375sm792923edy.1.2023.09.21.05.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 05:47:27 -0700 (PDT)
Message-ID: <c9b5e431-d2a2-de52-9235-36d4203a4d5d@linaro.org>
Date: Thu, 21 Sep 2023 14:47:24 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 1/8] KVM: arm64: Add generic check for system-supported
 vCPU features
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230920195036.1169791-1-oliver.upton@linux.dev>
 <20230920195036.1169791-2-oliver.upton@linux.dev>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230920195036.1169791-2-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/9/23 21:50, Oliver Upton wrote:
> To date KVM has relied on kvm_reset_vcpu() failing when the vCPU feature
> flags are unsupported by the system. This is a bit messy since
> kvm_reset_vcpu() is called at runtime outside of the KVM_ARM_VCPU_INIT
> ioctl when it is expected to succeed. Further complicating the matter is
> that kvm_reset_vcpu() must tolerate be idemptotent to the config_lock,
> as it isn't consistently called with the lock held.
> 
> Prepare to move feature compatibility checks out of kvm_reset_vcpu() with
> a 'generic' check that compares the user-provided flags with a computed
> maximum feature set for the system.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/arm.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

