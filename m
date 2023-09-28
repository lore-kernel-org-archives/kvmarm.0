Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061531A83
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 09:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695893971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Anogelpb6h+UmmPhFBLKjKjv5aWf5PDgUgDUDdH3vlA=;
	b=LTadL7zdrkOKBX+JcURT1JdONf8J1Ah61l4LGSs594v8lGUKkrQMnsUKyf9j5d2MTNEtm9
	t/Ew8smZbTIEP8UcBWg3nDx1irxSnw4Yxafuc6UdxYAXYFUt3KKRGyZWt3FfgXbsfoq0FB
	sq3cM/4AoRP9kqGRv/duLCfW8N4Wdeg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561--7qA6QyFOd6EV6i7h4Ns0Q-1; Thu, 28 Sep 2023 05:39:30 -0400
X-MC-Unique: -7qA6QyFOd6EV6i7h4Ns0Q-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-419624b11c1so38025211cf.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 02:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695893969; x=1696498769;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Anogelpb6h+UmmPhFBLKjKjv5aWf5PDgUgDUDdH3vlA=;
        b=gF6qqmp1bQAmqqAyMsL28sA6GWrHK2opUbtGw83bRTizxuO0sQAj6+R0A2aonfFVHv
         hS8eIUZMlHPyAC0I1wyL39ZCwcCrQUJGNXXUb80kE+loSUfOTGpnATn0AxQjBXdTH6s/
         ZUz9E1YBN85WuoYvqtJ2RJcK72NrzsA3pfjw7VRvM5yVwko51z8sqVHak1H7tjZA8Ug7
         KFOiR+fbFWNP/gpgLQWyftzSKFuWm6DzgbzWUmk2mY4JDco6nHhLj0h+6mFZ/JuLrTNG
         +CkyBhmd1w01Zp7HSQGCVVLY8Q9v1HcKAa3g7ztr6Ow9DMKqJyF/Q6OZ5OlpEYw04LZ5
         +RJw==
X-Gm-Message-State: AOJu0Ywo3shGhUpFMaKeepvvB1DlOWFU+Qey9wGjw7LsHvTzzSNXyse1
	5KczKJBJ15hPbjnC4jsscpyVmVObv8wBkRx7/kaN0PqcrK3nD+9Wa8OOEhDkiLDatxB836AmcRR
	mV8bj7dM/r6KGBbOc
X-Received: by 2002:a05:622a:13ce:b0:418:14ee:ac55 with SMTP id p14-20020a05622a13ce00b0041814eeac55mr764240qtk.25.1695893969664;
        Thu, 28 Sep 2023 02:39:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdWWxVcXbNbn+HgbQsUoYBrNHNPHxvQrzvItXYSki4Ld2HbeRJumvkdOsWecilyPT0AOtxoA==
X-Received: by 2002:a05:622a:13ce:b0:418:14ee:ac55 with SMTP id p14-20020a05622a13ce00b0041814eeac55mr764221qtk.25.1695893969332;
        Thu, 28 Sep 2023 02:39:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id jz3-20020a05622a81c300b0041811e71890sm3572492qtb.33.2023.09.28.02.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Sep 2023 02:39:28 -0700 (PDT)
Message-ID: <ec8ffc8f-1f53-61ca-8268-f13616a658d7@redhat.com>
Date: Thu, 28 Sep 2023 11:39:24 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 1/2] arm64: Add missing _EL12 encodings
To: Miguel Luis <miguel.luis@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230925162057.27548-1-miguel.luis@oracle.com>
 <20230925162057.27548-2-miguel.luis@oracle.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230925162057.27548-2-miguel.luis@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Miguel,
On 9/25/23 18:20, Miguel Luis wrote:
> Some _EL12 encodings are missing. Add them.
> 
> Signed-off-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 38296579a4fd..6e167bbf44ff 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -568,18 +568,29 @@
>  
>  /* VHE encodings for architectural EL0/1 system registers */
>  #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
> +#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
> +#define SYS_SCTLR2_EL12			sys_reg(3, 5, 1, 0, 3)
> +#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
> +#define SYS_TRFCR_EL12			sys_reg(3, 5, 1, 2, 1)
> +#define SYS_SMCR_EL12			sys_reg(3, 5, 1, 2, 6)
>  #define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
>  #define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
>  #define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
> +#define SYS_TCR2_EL12			sys_reg(3, 5, 2, 0, 3)
>  #define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
>  #define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
>  #define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
>  #define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
>  #define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
>  #define SYS_TFSR_EL12			sys_reg(3, 5, 5, 6, 0)
> +#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
> +#define SYS_BRBCR_EL12			sys_reg(3, 5, 9, 0, 0)
isn't it sys_reg(2, 5, 9, 0, 0)?

> +#define SYS_PMSCR_EL12			sys_reg(3, 5, 9, 9, 0)

>  #define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
>  #define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
>  #define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
> +#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
> +#define SYS_SCXTNUM_EL12		sys_reg(3, 5, 13, 0, 7)
>  #define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
>  #define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
>  #define SYS_CNTP_CTL_EL02		sys_reg(3, 5, 14, 2, 1)
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

