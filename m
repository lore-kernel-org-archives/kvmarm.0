Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0AC46B4
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 10:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685444142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eiBtAh/D0PsnpjLnM52N86s5X6wpcHIAyqVS4sikzak=;
	b=fxJ3YjZfHA6TNbiAEw3zphK9JLnAd9CNbG9KNeLsxgIZ0sS2Fp8MKCI9o7gM87nvXJ0BhT
	e+Gj9HSvkRGvt5xBMU2yEJ8ZDwJ9WLuh0qCMCvkoV7JlufAWAZYBHmzSQb2+MWzVLSbPVu
	LQWyr1L0XFHJTCCnVGpU0ydWr3iDYZg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3--qG4H5P-O8anLc3js7-aEQ-1; Tue, 30 May 2023 06:55:21 -0400
X-MC-Unique: -qG4H5P-O8anLc3js7-aEQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1b01d3c6fe9so4288495ad.0
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 03:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685444116; x=1688036116;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eiBtAh/D0PsnpjLnM52N86s5X6wpcHIAyqVS4sikzak=;
        b=IREPyvsD8f7cx4KP120FmdwzS29CN20rluu9/3FbRLV9Hi8CBdQ32eF4vmRGOU93Rs
         tcIms2dl7WW+YJDquU+m61AhJEBoQaacqa/DV3CF3Se4IWuAFmUWrxdEynLFE8j0Tl5b
         sG/oxQqvcIP02Gcr0eOQbw3fxTV9YkXxDHK7sfEgQr+93GVWcpxT2pXNoxfnetTSu+jy
         HOuPzYn4MMkKzwH44tWvyJfi8ECClPjQ/Q5XJCZDZ8avkTz2E9k7/DWzjMZMyqqG546k
         1dz3JBWiy62xadDt5IZNhDBJXFftDQ6xHSnDafxSQJ+RlCzgePtZZzo4Bg2xe7dO+9lL
         JGMA==
X-Gm-Message-State: AC+VfDxg8u+B1IU6MMbfFxl/k9pcMeQj9Q5LW79HDTT7YqnP2E9M2uXY
	y6Uqd460PZs9TlEKLk7vT32hQjRMwa179WrUooRNGkqrz/COmP4nLY5hXLiYVeoHyIy7r1gwa0z
	FBGdO4JvBmJCOPAUB
X-Received: by 2002:a17:902:e841:b0:1ae:1364:6086 with SMTP id t1-20020a170902e84100b001ae13646086mr2163551plg.2.1685444115849;
        Tue, 30 May 2023 03:55:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ63i9bPDIDLHsXNbID88iB0tQfOX/vDYe4JH76mNdjCwq1KXrg2EyLU27+UhIx9c9bfl/N1Ig==
X-Received: by 2002:a17:902:e841:b0:1ae:1364:6086 with SMTP id t1-20020a170902e84100b001ae13646086mr2163540plg.2.1685444115587;
        Tue, 30 May 2023 03:55:15 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ce8c00b0019aaab3f9d7sm9978616plg.113.2023.05.30.03.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 03:55:15 -0700 (PDT)
Message-ID: <07664387-ad45-02ec-8d67-b42f38b86191@redhat.com>
Date: Tue, 30 May 2023 18:55:10 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 5/7] arm64/sysreg: Convert OSDTRRX_EL1 to automatic
 generation
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v2-0-4c6add1f6257@kernel.org>
 <20230419-arm64-syreg-gen-v2-5-4c6add1f6257@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230419-arm64-syreg-gen-v2-5-4c6add1f6257@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/24/23 02:37, Mark Brown wrote:
> Convert OSDTRRX_EL1 to automatic generation as per DDI0601 2023-03, no
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
> index 1901b676d7c6..da954a6eba24 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -134,7 +134,6 @@
>   #define SYS_SVCR_SMSTART_SM_EL0		sys_reg(0, 3, 4, 3, 3)
>   #define SYS_SVCR_SMSTOP_SMZA_EL0	sys_reg(0, 3, 4, 6, 3)
>   
> -#define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
>   #define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
>   #define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
>   #define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index b0aefdf9ed34..e4653248dcac 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -48,6 +48,11 @@
>   # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
>   # item ACCDATA) though it may be more taseful to do something else.
>   
> +Sysreg	OSDTRRX_EL1	2	0	0	0	2
> +Res0	63:32
> +Field	31:0	DTRRX
> +EndSysreg
> +
>   Sysreg	MDCCINT_EL1	2	0	0	2	0
>   Res0	63:31
>   Field	30	RX
> 

-- 
Shaoqin

