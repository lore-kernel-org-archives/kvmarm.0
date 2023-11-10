Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD65A1852
	for <kvmarm@lists.linux.dev>; Fri, 10 Nov 2023 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5345Xd4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699587444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pROeszy9ePncz4nZyjZpb065/8N1ucMk0OODbP+hams=;
	b=b5345Xd4CfAHxovucD90DpRX2u+HjGodmOo2tM1PmGl9pbs2YS6YMFg3bqB0yoWOn1BbbP
	kSRaQ7GbD/VFxoBBbMZmqlPSaliyNc6mf939PPMsN/5At0ps8De3tzo/lvpMo0Zeyv3N1Z
	QtstkZ2hLbue4IfyLhwRBcqnee8hqNw=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-uufLiVeaOC2Sw6MjyKflKQ-1; Thu, 09 Nov 2023 22:37:23 -0500
X-MC-Unique: uufLiVeaOC2Sw6MjyKflKQ-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3b2ec6de4e4so63832b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 19:37:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699587442; x=1700192242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pROeszy9ePncz4nZyjZpb065/8N1ucMk0OODbP+hams=;
        b=lwkYbRYq5aGo7e1yWZoBFa06yWl8jyKcXEVBcAQ9mOaSO/J/Kst+5NmD6aOOywlii7
         fPU78duagzIW+i2TzjPEaztA4N5I2uKieO7GuqSTr2SpHKkCfNsUtNUEcJXnKwjcfh8T
         JzdlIyigyzATmyf88HdzNCtLyWu7hFstM2qLR+SLDc7Gp75+lSzidDHxeX6fBdOsHe15
         df8hOz+hNI7aEu0OwTUEz0RlMJ902oYkP0eqznWJFGDmvnwztbLGEsIOtGmVNKd/tQ5P
         bEAeX/F88TG8qlW30QPFAdgQycUc4KLH8WiXKSkZkECBVCYcXvi1Uc5JbnkyC34VkxAn
         8u0g==
X-Gm-Message-State: AOJu0Yz/bZ2CZiGHX2gC3UHrWfDHXC7lKFeQek6vr0oWo1bBBJFW8NPU
	Ob1F1TH2xjDGh0alTg8oY66nqJPANqsHEhvXS8lfUM17FdZCKjpziM8WIAQU+1QkkVg+UQBDT1s
	6tXkdCddi6XanlqGK
X-Received: by 2002:a05:6808:199c:b0:3a9:e8e2:579d with SMTP id bj28-20020a056808199c00b003a9e8e2579dmr8276250oib.2.1699587442424;
        Thu, 09 Nov 2023 19:37:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPdXOyaUAzV6aldemEymWFIQu5uK8SS6EoZEeBtta4Ue7SEB3JH44cFaCIyyqf1iZkLKsTPg==
X-Received: by 2002:a05:6808:199c:b0:3a9:e8e2:579d with SMTP id bj28-20020a056808199c00b003a9e8e2579dmr8276228oib.2.1699587442206;
        Thu, 09 Nov 2023 19:37:22 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e8-20020a63d948000000b005a9b20408a7sm5370547pgj.23.2023.11.09.19.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 19:37:21 -0800 (PST)
Message-ID: <fd78bb81-1f83-13a4-ec37-3fe0cd040ec0@redhat.com>
Date: Fri, 10 Nov 2023 11:37:16 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 14/22] arm64: convert to arch_cpu_is_hotpluggable()
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
 linux-pm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.linux.dev, x86@kernel.org,
 linux-csky@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org
Cc: Salil Mehta <salil.mehta@huawei.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, jianyong.wu@arm.com,
 justin.he@arm.com, James Morse <james.morse@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <ZUoRY33AAHMc5ThW@shell.armlinux.org.uk>
 <E1r0JLq-00CTxq-CF@rmk-PC.armlinux.org.uk>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <E1r0JLq-00CTxq-CF@rmk-PC.armlinux.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/23 18:30, Russell King (Oracle) wrote:
> Convert arm64 to use the arch_cpu_is_hotpluggable() helper rather than
> arch_register_cpu().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kernel/setup.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 165bd2c0dd5a..42c690bb2d60 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -402,13 +402,9 @@ static inline bool cpu_can_disable(unsigned int cpu)
>   	return false;
>   }
>   
> -int arch_register_cpu(int num)
> +bool arch_cpu_is_hotpluggable(int num)
>   {
> -	struct cpu *cpu = &per_cpu(cpu_devices, num);
> -
> -	cpu->hotpluggable = cpu_can_disable(num);
> -
> -	return register_cpu(cpu, num);
> +	return cpu_can_disable(num);
>   }
>   
>   static void dump_kernel_offset(void)

-- 
Shaoqin

