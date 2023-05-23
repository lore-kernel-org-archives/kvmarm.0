Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA3A4A840
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 11:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684841521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xqvkKPpeyvJC3LKAlZdrdd0G6ZskzvSyTK5XVg14pug=;
	b=YCXMbt8zPxQE1rUmQzl0VKgHIyXeGbTACby7kU98B5L5q8mllBww1XRyUiSRZXSum0X8ZM
	qi/fmIu0rFHkQkl6ZMgqQR+VI/+HNa9edxxhrEsf/rsiCBlSz02JfRlBfIBiCBHL3FBgX/
	IrJ1XrDKp7Fm19KC/y99aRQWOyMcMF4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-RCPficNROV2xbYoaC7hNQA-1; Tue, 23 May 2023 07:31:58 -0400
X-MC-Unique: RCPficNROV2xbYoaC7hNQA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-64f383f88dfso224726b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 04:31:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684841517; x=1687433517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xqvkKPpeyvJC3LKAlZdrdd0G6ZskzvSyTK5XVg14pug=;
        b=lP+tGxXdLNMEd7lXqsmVCMTRKN7GRMBXI2lN7S0TaMDuNiASpoLna/nA2Qb3gIPq8y
         G75TRvrA8sSdWM7L41hHvANCrhrBc7P6I5VSG6kjpzWKN7eiDjfxZ8nPm72NPdRfuJlr
         XHUYYL0pXxZnLxTB9g076ah+F2o/G4Rm5YD9dhx2On3CPcuOq2vNq1475rk4NLx2rX/P
         2TiYcG7s9i9HZo3fSYGi4E9VSESvm8AdMgNnfCuVEb+9oiaD0ETE3rUILyYwL1BNZAJl
         egM942V8EHA9CH1xpQ0SLbNoaW9mgI9WsgIF10fBKQiCE57Rkwzusn0i5R+MImmW0GMV
         blIA==
X-Gm-Message-State: AC+VfDyMX/uoSxjLJcZUpOazmqaotjW2vTnn+Yw4mLx7nSjXdPIwX5ed
	xloh/EiWR620gmzuOe6l1IBYXBS6IhBUlTijv2Poe+bHODFB8Bj2HXXfQgkWIZsbkwZsSPKoiQ1
	wFDlAnG7LpIL8EWPV
X-Received: by 2002:a05:6a00:1c91:b0:63d:2d6a:47be with SMTP id y17-20020a056a001c9100b0063d2d6a47bemr13311109pfw.2.1684841517223;
        Tue, 23 May 2023 04:31:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7FgAilTzoSI89QW4N0Hm/4MD2G7X0a1vaxsB7MtNKFBw0Ak3fCBuMJI+YnvZGSlxGyzUBaug==
X-Received: by 2002:a05:6a00:1c91:b0:63d:2d6a:47be with SMTP id y17-20020a056a001c9100b0063d2d6a47bemr13311094pfw.2.1684841516938;
        Tue, 23 May 2023 04:31:56 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g17-20020aa78751000000b0063b89300347sm5768361pfo.142.2023.05.23.04.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 04:31:56 -0700 (PDT)
Message-ID: <e2660ce1-7ac1-8413-8ef7-284592cce708@redhat.com>
Date: Tue, 23 May 2023 19:31:51 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/5] arm64/sysreg: Remove some unused sysreg definitions
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-1-936cd769cb9e@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v1-1-936cd769cb9e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/23/23 00:22, Mark Brown wrote:
> Since there are no references to OSDTRRX_EL1 or OSECCR_EL1 in the code
> just remove the definitions rather than converting to automatic
> generation.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/sysreg.h | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9e3ecba3c4e6..6505665624d4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,11 +134,8 @@
>   #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>   #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>   
> -#define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
>   #define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
>   #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
> -#define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
> -#define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
>   #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
>   #define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
>   #define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
> 

-- 
Shaoqin

