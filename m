Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9562F9FB
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 04:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CqiSUF2O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699849478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+XpkXMncYpwBWWz5YM4lExGVyIZbJdd8k4LtapRIRSU=;
	b=CqiSUF2OOoz7FDL8zJB1fpVBOFcXzYHcqyThP9jZgY4tu7iXzvwbC8ZhMoGYldCriGk3uF
	aRzYE69HUo44bFM8lx7cmgMcaXmnaKS4dWO6j5qm9HYPwlZMzJpU3LQVpCboPJppZMQ9g5
	VWTmZTRlDhmu6IH28mpkhmgqsUuhzEw=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-4K8_8yRbPESxPyh3Fm9DGw-1; Sun, 12 Nov 2023 23:24:36 -0500
X-MC-Unique: 4K8_8yRbPESxPyh3Fm9DGw-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3b2f3015ce6so4667050b6e.3
        for <kvmarm@lists.linux.dev>; Sun, 12 Nov 2023 20:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699849475; x=1700454275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+XpkXMncYpwBWWz5YM4lExGVyIZbJdd8k4LtapRIRSU=;
        b=Zq/p35n36K58VCj22qrwQdwgq/f/br9zf5bhxdsVgkS768U1Sw2UwOzUOvtngYdLZZ
         fr22ERFAwlepb3bGS92jSjEp+UYAi43wyEuc5JLeohWI6mtymlg6izeUJejfGK3sseFR
         BocO5UvDPKnZtRYlG1KrN5Tt/wb2InGDNFL4VJW3RqXx8sRP7z9wu35zvRWJQyG8cCzA
         oaJPS2wpL4Zs/okubB0yqvEDj6ooYBM4jTqHr88XBGlHq46MvOiJZBTHyr2GoG93WjMc
         VExjxxM/jp+RuWjk8hf8jEFFm5X8ral9r2fF1z/+sCThie4JbvvV0BV196kAKq/lsB/v
         WHsQ==
X-Gm-Message-State: AOJu0YyJlepM8KY2nO0N3PKRZzpxF0Hgh6jttUPhNTwKHZhghk9av6S1
	X8l4f1NiDBXkM7MvTgcBk6hzBk6sLeoI6493HJYzeAJLvwJqNhUeIpbb2KNgOTJF/H8yzN0FcaU
	LDepgwVxsETBXMDkK
X-Received: by 2002:a05:6808:1907:b0:3b2:a9bd:c38f with SMTP id bf7-20020a056808190700b003b2a9bdc38fmr8909952oib.37.1699849475402;
        Sun, 12 Nov 2023 20:24:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGpLquY73YkMUU9Mlaw3xcZEgmE+1wMz9SoOzUS3eERBYDajACgA3kg4BM9OvwoIC+iQZINQ==
X-Received: by 2002:a05:6808:1907:b0:3b2:a9bd:c38f with SMTP id bf7-20020a056808190700b003b2a9bdc38fmr8909944oib.37.1699849475200;
        Sun, 12 Nov 2023 20:24:35 -0800 (PST)
Received: from ?IPV6:2001:8003:e5b0:9f00:b890:3e54:96bb:2a15? ([2001:8003:e5b0:9f00:b890:3e54:96bb:2a15])
        by smtp.gmail.com with ESMTPSA id fm6-20020a056a002f8600b006c4db182074sm3111661pfb.196.2023.11.12.20.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Nov 2023 20:24:34 -0800 (PST)
Message-ID: <d07a9e11-9752-4155-bbaf-b759ec4f99ac@redhat.com>
Date: Mon, 13 Nov 2023 14:24:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 22/22] riscv: convert to use
 arch_cpu_is_hotpluggable()
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
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
References: <ZUoRY33AAHMc5ThW@shell.armlinux.org.uk>
 <E1r0JMV-00CTyh-It@rmk-PC.armlinux.org.uk>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <E1r0JMV-00CTyh-It@rmk-PC.armlinux.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/23 20:31, Russell King (Oracle) wrote:
> Convert riscv to use the arch_cpu_is_hotpluggable() helper rather than
> arch_register_cpu().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>   arch/riscv/kernel/setup.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

