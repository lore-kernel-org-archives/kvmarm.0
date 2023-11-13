Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ABBE543
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 04:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LeeHkZhj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699849332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XF3NQ57kyjxk1hcvqu+Pq8JhkrYu8jIWva1UTHj4B8I=;
	b=LeeHkZhjOw9rGBkKeffpqGS938JOnOYzsnYlS/4gFJL8N9/YsUrDmWTZsTrVjCa5tSCazE
	O4xw6fWgbpeP/LB/wwIl3PQJO8ubE95q+2ZPYBemBctfen3v1fWLuWbIWScnEJwTbYZXnW
	0RQHY6emzjj0cQi2JfOo5uBUeacESxI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-GmF9QMQ3Oi6gNJa2PIV3kA-1; Sun, 12 Nov 2023 23:22:11 -0500
X-MC-Unique: GmF9QMQ3Oi6gNJa2PIV3kA-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3b2df828525so4607634b6e.3
        for <kvmarm@lists.linux.dev>; Sun, 12 Nov 2023 20:22:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699849330; x=1700454130;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XF3NQ57kyjxk1hcvqu+Pq8JhkrYu8jIWva1UTHj4B8I=;
        b=dTMG8rHQehYmBetzTEgcoyRJOXcWRqFtB/BfAfuPTZlG8he2vDhFtbfeNfa1xEOxPH
         nkdPofW4Ve7hLtT7MAEB5vVKYQFBBZSLxamMYgjO0ndsCcX8pxezHF3U68ou9ayho2zI
         sXAoKq26MV5qhZkmGsbARH3MGWklqEFsntiORudl+dDBrpcYqydwFQIau6+eFZAtMiZi
         lSivdrr7lF2wbGVC5cAWiNaJnlLLGXjdFJLEIRoz29LPvpPD6WyiRz7w5c7oWWpGHlBz
         qmpoxR2xW7pdobBOd/xJj63JxTTJuwglaOoTjec8s8d7tiTBs3BBQzMvSLB0wGuTWL95
         jCXA==
X-Gm-Message-State: AOJu0YxtqmdXVo6q9/7aCZdy8GgZaQDuV3sdKHoKAhGK6fFXb3kOkjBY
	yIIXHBnuVdw84uhxFP/QBIHYEZA0/dfb/s9a3XHpecyz6j2OSnHbguy6Cdlhi0OT65gwGCq8s9B
	vGEe7sB6NhJ98TcgZ
X-Received: by 2002:a05:6808:3c8a:b0:3af:e556:4602 with SMTP id gs10-20020a0568083c8a00b003afe5564602mr8733114oib.11.1699849330586;
        Sun, 12 Nov 2023 20:22:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGXY595uxruxGZ6Ui5zU3loMnBcIT42OgsioZr0yKGr5XKhKsixYTlwKjcTTf2f20K0od7lOA==
X-Received: by 2002:a05:6808:3c8a:b0:3af:e556:4602 with SMTP id gs10-20020a0568083c8a00b003afe5564602mr8733096oib.11.1699849330328;
        Sun, 12 Nov 2023 20:22:10 -0800 (PST)
Received: from ?IPV6:2001:8003:e5b0:9f00:b890:3e54:96bb:2a15? ([2001:8003:e5b0:9f00:b890:3e54:96bb:2a15])
        by smtp.gmail.com with ESMTPSA id fm6-20020a056a002f8600b006c4db182074sm3111661pfb.196.2023.11.12.20.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Nov 2023 20:22:09 -0800 (PST)
Message-ID: <191a356f-a9cd-4510-9676-dc28026088be@redhat.com>
Date: Mon, 13 Nov 2023 14:22:03 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 20/22] LoongArch: convert to use
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
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>
References: <ZUoRY33AAHMc5ThW@shell.armlinux.org.uk>
 <E1r0JML-00CTyV-9a@rmk-PC.armlinux.org.uk>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <E1r0JML-00CTyV-9a@rmk-PC.armlinux.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/23 20:31, Russell King (Oracle) wrote:
> Convert loongarch to use the arch_cpu_is_hotpluggable() helper rather
> than arch_register_cpu(). Also remove the export as nothing should be
> using arch_register_cpu() outside of the core kernel/acpi code.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>   arch/loongarch/kernel/topology.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

