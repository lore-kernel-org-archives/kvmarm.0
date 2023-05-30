Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F64046B4
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685444156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7r4Mnem7kmzwqmYPUjeTXwU41wAFR83DgbxuqCZJ8nM=;
	b=gEoHNZh5wtYideQk9Tk4SUa7TSyh60aClJ53kU0IiaH7aMIXKp2Tue3NgecXdlrou5YfSC
	yj5wPw4T6OwFevgW08m3cuDGxs8wCdaOTcQ1g1zIz97updELix/KVq0DTeitlON7hYZ5Pu
	0b9FHl420JTzeK8lv6p7as6+l3AinZk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-6th83VKQNk266jIczxOPSA-1; Tue, 30 May 2023 06:55:55 -0400
X-MC-Unique: 6th83VKQNk266jIczxOPSA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-517f0c08dfaso228742a12.0
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 03:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685444154; x=1688036154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7r4Mnem7kmzwqmYPUjeTXwU41wAFR83DgbxuqCZJ8nM=;
        b=QvQ4ISF2BXBq51PLpQQWP1339Q2n0aDg8UWi0lEc+GFBXC9GohdVh7l62FbNx+as17
         3YMiCohnJWm51PFPbO68sTcXAzhjEI8GsIaRRPxZ3p/klp6g7JNWlYNxE1NAl1NteP0W
         cAdaadmzc/fCwRJHGQBhlwXlLPRXhGpm3s9oGdAKubl9IpWen9wFQ83IC21vM8X66MGP
         JNCDhLGg4WtXGmu1RMZ5u8U0Evtl/2B+FYuCBLZzK8b9RlAoP5xg8BMOhEfB4ABN4E1T
         gd6knRXZCE79RnxYZatmHk2uN7wFvG2YZUL5j0ptsIIm4jW8az+wbC2GSdE7N1OGuk/A
         eRVQ==
X-Gm-Message-State: AC+VfDyaAbLjrel4IbDc6i88v3edA0K/UUqI/R/XGZu7dNV+ASQebgwF
	vYywdZ79atkYso3L6kyGF/nrc6FOW6C7kFQr4VncRfqJ3lkH3OOhcuWBdrX/qpysEJ5mBxrkjf/
	jA8dXbOyhFfatw72I
X-Received: by 2002:a17:902:d2cf:b0:1ad:eada:598b with SMTP id n15-20020a170902d2cf00b001adeada598bmr2094738plc.3.1685444154263;
        Tue, 30 May 2023 03:55:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7CUOUu5tniDT9Anx1jndbJZo9eoV8LSBuK+IXZEX8MBQk8TjG7H9ErpJBB2Mbo63Rdlv0pCg==
X-Received: by 2002:a17:902:d2cf:b0:1ad:eada:598b with SMTP id n15-20020a170902d2cf00b001adeada598bmr2094720plc.3.1685444153998;
        Tue, 30 May 2023 03:55:53 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h20-20020a170902f7d400b001aaed55aff3sm5579270plw.137.2023.05.30.03.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 03:55:53 -0700 (PDT)
Message-ID: <3772ec3f-cafa-6d90-77e4-d1594e4046dd@redhat.com>
Date: Tue, 30 May 2023 18:55:49 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 7/7] arm64/sysreg: Convert OSECCR_EL1 to automatic
 generation
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
 <20230419-arm64-syreg-gen-v2-7-4c6add1f6257@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v2-7-4c6add1f6257@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/24/23 02:37, Mark Brown wrote:
> Convert OSECCR_EL1 to automatic generation as per DDI0601 2023-03, no
> functional changes.
> 
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>   arch/arm64/include/asm/sysreg.h | 1 -
>   arch/arm64/tools/sysreg         | 5 +++++
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index d9711f1e47b2..23a17da500a4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,7 +134,6 @@
>   #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>   #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>   
> -#define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
>   #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
>   #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
>   #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index e18ae1df41f4..41462785020b 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -93,6 +93,11 @@ Res0	63:32
>   Field	31:0	DTRTX
>   EndSysreg
>   
> +Sysreg	OSECCR_EL1	2	0	0	6	2
> +Res0	63:32
> +Field	31:0	EDECCR
> +EndSysreg
> +
>   Sysreg	OSLAR_EL1	2	0	1	0	4
>   Res0	63:1
>   Field	0	OSLK
> 

-- 
Shaoqin

