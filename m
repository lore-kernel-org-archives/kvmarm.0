Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D5259A
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 00:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hOiF1vkw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699836318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIBcuinF5ss2DgGVnkjihkWjegSjrF5pOFgfBoAd6NQ=;
	b=hOiF1vkwr0HixjP9RY8YlJsV9+vuJkAigh2aBLO+jXq0BHjwPNlHDXtgKI03hIRNyygDSb
	7+KVTwsgAJCzLwmMJglZjOMLR4pCWT0Hcx1r3WdXwI5UxXG5ipKAfBM0OG7fJaJiFabr8E
	DlzHP1joMuAiQY1Wu0lNb/YdkjGbzYA=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-Rhwrj3dePrCLdrAsV7vAew-1; Sun, 12 Nov 2023 19:45:15 -0500
X-MC-Unique: Rhwrj3dePrCLdrAsV7vAew-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1e9e17b3269so3645226fac.3
        for <kvmarm@lists.linux.dev>; Sun, 12 Nov 2023 16:45:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699836315; x=1700441115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AIBcuinF5ss2DgGVnkjihkWjegSjrF5pOFgfBoAd6NQ=;
        b=LYNwLeNhssW1pmzDRCPRx8ol2P9BYgesKFrClXY3XSEQye+i1Xm7ciUnhGT0BHR5rh
         N6rOE+IoJXE6lXiiefg1z9SRkAQKzA7YDxWKGtQrct4RCL+QQqZL/UWkA6B52pKUlTmM
         pjn5RHHw2sdtfvZ0+dh4T0PQ570apWXHIc1Rdeh2fSv8mhpyU7a7FlrpEkEYVE0tydpJ
         fpYk+FJJyUm9eZNAg+A2ntr8XFZhyWsu6grSUBldx4YY0Tue0CAa0MOLiopKomkGSQJ5
         4R9b2uAiCeuN4Hivzmub+B2W7/zgmsimlIc11/7FxIjEl6NLflxnB/HeD+o481tY0UoS
         EPZQ==
X-Gm-Message-State: AOJu0Yx6QtMYFJOW0OY3JBi6z8fkHierLPy5ForAUIFw91lKsddIldTV
	B43v4TnvWKNtWUt+TIkeHV5/RoIqU+kejcBSkb7SrsNqAe/kI0G2COm5Q7RCNoIXPD/o5/DL+Jn
	jWxSbtcFt49TzlaaE
X-Received: by 2002:a05:6870:f14d:b0:1d5:b2ba:bc93 with SMTP id l13-20020a056870f14d00b001d5b2babc93mr7060134oac.13.1699836315191;
        Sun, 12 Nov 2023 16:45:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH9rLDeDKmdt9jI4rfj9b9OvZLsFOMuiJgoFwWcjW46CaFvA839DNqkdgqlkT2G64l2xzZLdg==
X-Received: by 2002:a05:6870:f14d:b0:1d5:b2ba:bc93 with SMTP id l13-20020a056870f14d00b001d5b2babc93mr7060111oac.13.1699836314952;
        Sun, 12 Nov 2023 16:45:14 -0800 (PST)
Received: from ?IPV6:2001:8003:e5b0:9f00:b890:3e54:96bb:2a15? ([2001:8003:e5b0:9f00:b890:3e54:96bb:2a15])
        by smtp.gmail.com with ESMTPSA id hq18-20020a056a00681200b006933822e7a6sm2957854pfb.66.2023.11.12.16.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Nov 2023 16:45:14 -0800 (PST)
Message-ID: <df5fb117-96e0-4231-85c6-70c960fbb6c4@redhat.com>
Date: Mon, 13 Nov 2023 10:45:05 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 08/22] drivers: base: Implement weak
 arch_unregister_cpu()
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
References: <ZUoRY33AAHMc5ThW@shell.armlinux.org.uk>
 <E1r0JLL-00CTxD-Gc@rmk-PC.armlinux.org.uk>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <E1r0JLL-00CTxD-Gc@rmk-PC.armlinux.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/7/23 20:29, Russell King (Oracle) wrote:
> From: James Morse <james.morse@arm.com>
> 
> Add arch_unregister_cpu() to allow the ACPI machinery to call
> unregister_cpu(). This is enough for arm64, riscv and loongarch, but
> needs to be overridden by x86 and ia64 who need to do more work.
> 
> CC: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> Changes since v1:
>   * Added CONFIG_HOTPLUG_CPU ifdeffery around unregister_cpu
> Changes since RFC v2:
>   * Move earlier in the series
> ---
>   drivers/base/cpu.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

