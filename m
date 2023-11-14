Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1061FC6
	for <kvmarm@lists.linux.dev>; Tue, 14 Nov 2023 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dy/XsO4c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699931325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e7x45WdPmpvw0PcEuc4+yK1/4uClaBNHsZQ2i2OvfpE=;
	b=Dy/XsO4cpH4paeNjbqt8zx79yKLeB4znKpm0h11SeXARcQvFZScWnMm4gmZDnKkQwRyGMx
	hVfzUZMUcaEkg9h0SQ9EtH5iDAXlj0pI7xu3qNZweRzwZpDJW+aeNGr41qoKAcrdUO1cff
	cc41cmUwU5AC38Hvrezt70pihmVT7OQ=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-7AbbmpZeNT-nIf1RJhHBXw-1; Mon, 13 Nov 2023 22:08:42 -0500
X-MC-Unique: 7AbbmpZeNT-nIf1RJhHBXw-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3b40deadcb7so921305b6e.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 19:08:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699931321; x=1700536121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e7x45WdPmpvw0PcEuc4+yK1/4uClaBNHsZQ2i2OvfpE=;
        b=EHqg2Z7uu0Pu9CkKrVnxH5YuSP8JI+qS6UVNr6MFPkboft4BM0ECa0cdsnDsCKUyE9
         7dOqM/jix97RaNbfKqA4/KZ83Fpx9QMvsxrjiwD+23FhtMiyltOAgfkt2/Wqlr855Brj
         locT+pRq9tyVx+dwsR3FTjsKSldadh0zqYv+ul1VeQkV0AKrOGvEn8PbAc5EKu5AhQYj
         0xcSKG+y2LS0rE1c8jaOh2cAak0j7sszFB543M2M8mADH9uqR1O+LVeii8pfiNZ8FHaf
         3hS/DVr7F5Ii0J76m3iMh4Z3p6TZcLqdv6+OOqPLVdTYLa7hoHrgyaieVYGK9afB9Axk
         a8Bw==
X-Gm-Message-State: AOJu0YzCn44S9d5+OtsRkJLpxcbv4EPbunmKPsyYUsfC+Rox7SCC697p
	YU+dm+gOMD/oqW6NfWHC7ro8VZCoCfiFu5fUe9eUDqR36RNtan7M0GXsJvGyQtgTx83II/5n3Ce
	0T/Ms8zlg5Lky/ET1
X-Received: by 2002:a05:6808:f8f:b0:3b2:db33:e301 with SMTP id o15-20020a0568080f8f00b003b2db33e301mr1241670oiw.0.1699931321369;
        Mon, 13 Nov 2023 19:08:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFulG7DjXfxFgcPpwgR1kQryaWW1aceQmnP+c2sLz9WmLZsKs+hXebP6+Ez09n0PX8uTNnW4g==
X-Received: by 2002:a05:6808:f8f:b0:3b2:db33:e301 with SMTP id o15-20020a0568080f8f00b003b2db33e301mr1241657oiw.0.1699931321114;
        Mon, 13 Nov 2023 19:08:41 -0800 (PST)
Received: from [10.66.60.14] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y64-20020a638a43000000b005bd980cca56sm4751815pgd.29.2023.11.13.19.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 19:08:40 -0800 (PST)
Message-ID: <00f7b062-e967-f1ed-bf2e-f0b86be60287@redhat.com>
Date: Tue, 14 Nov 2023 11:08:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v2 1/2] arm: pmu: Declare pmu_stats as
 volatile
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
 maz@kernel.org, oliver.upton@linux.dev, alexandru.elisei@arm.com
Cc: jarichte@redhat.com
References: <20231113174316.341630-1-eric.auger@redhat.com>
 <20231113174316.341630-2-eric.auger@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231113174316.341630-2-eric.auger@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/14/23 01:42, Eric Auger wrote:
> Declare pmu_stats as volatile in order to prevent the compiler
> from caching previously read values. This actually fixes
> pmu-overflow-interrupt failures on some HW.
> 
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arm/pmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index a91a7b1f..86199577 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -328,7 +328,7 @@ asm volatile(
>   	: "x9", "x10", "cc");
>   }
>   
> -static struct pmu_stats pmu_stats;
> +static volatile struct pmu_stats pmu_stats;
>   
>   static void irq_handler(struct pt_regs *regs)
>   {

-- 
Shaoqin

