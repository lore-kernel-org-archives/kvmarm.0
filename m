Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DACC4A858
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 11:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684842811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROm0i8OIcBpsUm6qOdteipghI/KOlxqOcgEQ3FtDKqI=;
	b=AHSA5JZQn9y4wEWjkdvTF+ecWG4GEKJPIRNIltF28td/QhAUCbF6I5kc0L7IqpS6TEe1Dq
	BT69ExVxlVLk90YEwt1DX33HvGMjfeHhtQSgA41wY2bVF/nLwL42HNYbX89d2Ukc1wYJ4w
	L46GtunvYzwTUDnCc2J+FtuLN2ihLqI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-IoKnd2dDNRuIKFHIS6L7Dg-1; Tue, 23 May 2023 07:53:29 -0400
X-MC-Unique: IoKnd2dDNRuIKFHIS6L7Dg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2537504f339so707196a91.1
        for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 04:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684842808; x=1687434808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ROm0i8OIcBpsUm6qOdteipghI/KOlxqOcgEQ3FtDKqI=;
        b=UrbaQgLVGPAX9sJDJ7t/KJ6dWB/XzAdFBmLrCOzhF40ozP56Typ68MOenkBWAJHIzr
         hJBGCfVi4SUQ2dh9x7s6RTiZe0dBD0K+AVw+MauxpvB1mJ6iVROkcwSpHnHW3R82pHEC
         lWEK5ifb2X2X/yp+Hkga8IpW5HOUZqB5bkofxwsNURc4h2H5uiHeDCcskx1E8Pu/LgXl
         GewBycPsU7GYrhWWUr88D3UoOFd8iW15Mbi76JTY+lCU6oGr2puoKbjblHbVUyj1Vwsc
         kviC1omjve7bmlQraKOOV0Aa/J+Ecmze+qq1xYMKBmSAz4cQg3c5VP3BydUgrtRg1DoK
         qu5g==
X-Gm-Message-State: AC+VfDxN55XAox+BnF5svKl/WqU09Cio6lehezX5RididS9WUattW7D5
	djrZZiHGyHFr0Vq+3cnNLweH0sVhHdmGf6ot+4Eq5iA0P9Yz7slWajYXcX14dorSFIjeaRHN+P4
	SGaP4oLkh1hZMCy1R
X-Received: by 2002:a17:90b:1e05:b0:252:85ab:41d1 with SMTP id pg5-20020a17090b1e0500b0025285ab41d1mr15823550pjb.3.1684842808764;
        Tue, 23 May 2023 04:53:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Xh572ELBBAss+xy1d9j7LvZ8GvJTq8PGwVJVNPQN31WNZCw74ZcAGfsj3OdreT/7FehNg3Q==
X-Received: by 2002:a17:90b:1e05:b0:252:85ab:41d1 with SMTP id pg5-20020a17090b1e0500b0025285ab41d1mr15823535pjb.3.1684842808494;
        Tue, 23 May 2023 04:53:28 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a0f8500b0024bcad691d4sm8021303pjz.14.2023.05.23.04.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 04:53:28 -0700 (PDT)
Message-ID: <43c10c60-3384-5578-c1f3-8ef6fa556545@redhat.com>
Date: Tue, 23 May 2023 19:53:23 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5/5] arm64/sysreg: Convert OSLAR_EL1 to automatic
 generation
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-5-936cd769cb9e@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v1-5-936cd769cb9e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/23 00:22, Mark Brown wrote:
> Convert OSLAR_EL1 to automatic generation as per DDI0601 2023-03. No
> functional change.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/sysreg.h | 3 ---
>   arch/arm64/tools/sysreg         | 5 +++++
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 09de958e79ed..3b51e532caa9 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -140,9 +140,6 @@
>   #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
>   #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
>   
> -#define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
> -#define OSLAR_EL1_OSLK			BIT(0)
> -
>   #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
>   #define OSLSR_EL1_OSLM_MASK		(BIT(3) | BIT(0))
>   #define OSLSR_EL1_OSLM_NI		0
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a5ae0e19fc9f..84df0b7feb45 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -83,6 +83,11 @@ Res0	5:1
>   Field	0	SS
>   EndSysreg
>   
> +Sysreg	OSLAR_EL1	2	0	1	0	4
> +Res0	63:1
> +Field	0	OSLK
> +EndSysreg
> +
>   Sysreg ID_PFR0_EL1	3	0	0	1	0
>   Res0	63:32
>   UnsignedEnum	31:28	RAS
> 

-- 
Shaoqin

