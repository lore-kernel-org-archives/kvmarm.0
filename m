Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C674A840
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 11:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684841636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ehB1kA3QCKYDFVWvQAE46/PlE+fxP/22RPCQdy4evVc=;
	b=iqyg0mt1USxsHFBKDVrl+rJqFMzYMheYF8QBmEpvSwv2BbzBROHEHptFtfHbJNrbU7xKkl
	IDAJGxzFbWGWWUuVrAW6r+XxpHv00+SYcv9Qi0ViMZjdYcoMLHTD0BNq0dQ/CrfRlnzEvB
	xYeozQzl1u2Bsz40OEq1+twV1YJYPTk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-dLcVx3e8PN2WJ_ZTI5B_8g-1; Tue, 23 May 2023 07:33:55 -0400
X-MC-Unique: dLcVx3e8PN2WJ_ZTI5B_8g-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2537504f339so704646a91.1
        for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 04:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684841634; x=1687433634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehB1kA3QCKYDFVWvQAE46/PlE+fxP/22RPCQdy4evVc=;
        b=LH+wtdWxzJnBS8cZ0U87m49XgwzSKKWwmwvsKBM0IR3bpR7BuNKLaaQ6sOSV1YFajn
         Kaad9bNUY4CBIpsOPTUm3OyciLtpWfS8DAyTWj72TVCZ4tT0BeegqMLe9BHQl5kmiTQu
         ohSabl87QmfUlGvtcMIViRS8qskJ3MIjFg89K/76MmlNo1QW7GZa0PDS5jjxp0rZK3mK
         5mlUa7rzix60AtvUTUNO5LIS03b98QsOAgkHbbJaEHzRJXysaOfIu5fc6I8ppLv4sDDj
         S6WARcSAa5Y4xuylwKysbS05REKSS1Wilsqo/KDTWkEDuvb/D6G81YQd3yIMuk2atqCA
         AU2w==
X-Gm-Message-State: AC+VfDx7kwPInl8TS0OIdqIzCE8Tkh0qtNTrAilrVUm+71QR6BXVt3g/
	62orW6/o42pfitBP/qwfwZdMSg1oz+HZz5KEcuPBJKUaU4KYznDNa39w5WKjRnj0IpW3Eo0F/UO
	pPOCFIr4OQgvsAAWO
X-Received: by 2002:a17:90b:4b01:b0:252:a208:1fef with SMTP id lx1-20020a17090b4b0100b00252a2081fefmr15867107pjb.0.1684841634076;
        Tue, 23 May 2023 04:33:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ70EiJXkadtssWOOH57ohFJYqxPsHrWwT93SBF1z24r/VkGglOw5cF28YNW99xTD/Cv5+86Jw==
X-Received: by 2002:a17:90b:4b01:b0:252:a208:1fef with SMTP id lx1-20020a17090b4b0100b00252a2081fefmr15867093pjb.0.1684841633785;
        Tue, 23 May 2023 04:33:53 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bj19-20020a17090b089300b00246b7b8b43asm5578174pjb.49.2023.05.23.04.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 04:33:53 -0700 (PDT)
Message-ID: <93a7fa53-7a62-395a-ea92-392475ed2d48@redhat.com>
Date: Tue, 23 May 2023 19:33:48 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/5] arm64/sysreg: Convert MDCCINT_EL1 to automatic
 register generation
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-2-936cd769cb9e@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v1-2-936cd769cb9e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/23 00:22, Mark Brown wrote:
> Convert MDCCINT_EL1 to automatic register generation as per DDI0616
> 2023-03. No functional change.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/sysreg.h | 1 -
>   arch/arm64/tools/sysreg         | 7 +++++++
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 6505665624d4..4e48bb4dca6a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,7 +134,6 @@
>   #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>   #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>   
> -#define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
>   #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
>   #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
>   #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index dd5a9c7e310f..1699e87bc0b4 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -48,6 +48,13 @@
>   # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
>   # item ACCDATA) though it may be more taseful to do something else.
>   
> +Sysreg	MDCCINT_EL1	2	0	0	2	0
> +Res0	63:31
> +Field	30	RX
> +Field	29	TX
> +Res0	28:0
> +EndSysreg
> +
>   Sysreg ID_PFR0_EL1	3	0	0	1	0
>   Res0	63:32
>   UnsignedEnum	31:28	RAS
> 

-- 
Shaoqin

