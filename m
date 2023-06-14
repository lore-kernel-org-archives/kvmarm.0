Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3B9DDB6
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686755344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ij857rNE7UlsoT4a+p1OsxNn3WWx5lolIITLzhEvclQ=;
	b=CI0bMvMtpwTQKiOZ/6wt9BjU03tduLYVPBWXKkwuh/f11Gn1oN/sCfZZgjK/YmHOBojURH
	RbyVKjxEt2HPHlnsvyw2c1C7vTWZ1M04rDwlNcFTrSgh+/T8HBsHUTtbVrFuH+g4IbHlba
	lad8OpbOhQRh/XJ5Vs6a2ifR1NeV/5g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-8hP8fbCsPSy0hh8hYkEHYA-1; Wed, 14 Jun 2023 11:08:49 -0400
X-MC-Unique: 8hP8fbCsPSy0hh8hYkEHYA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f7e7a6981cso4292525e9.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 08:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686755327; x=1689347327;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ij857rNE7UlsoT4a+p1OsxNn3WWx5lolIITLzhEvclQ=;
        b=FfoK5fhur2xf8Gj/c5NsHjXARDMCmLLxoA/jyPK7YlUiQiCzCUuALZyEFqfZj1Id+M
         mc1F/NpFAEwYb3aOOnRZOJmnSJ+EWyCfqrUOQe/JDjJn8pyTtg3LX8YLkzW3K0qKiM8q
         sslOCX4f4Wu5K+uMv2TMKtHnDR/Z5KTqVFy/V1CIbdcxOuTXhFO7cGHf/rc4jD8/P2bJ
         1SJ9FDYzDQGRzHoSmKbej+FfJ4sPAYTHiZQtm1ISAChazhlLu1BH58ZJ2paux0+Sczcf
         kmRiwxGHmJwAI/CWqNcoagn7FevwABo2uNMiP7Nwfb4BYXUyN9SwPGMHbNjBpyP4xap6
         U4xg==
X-Gm-Message-State: AC+VfDwYVpVP4gph0S/P1W/d3hGFzKSmP5wnhJIAriB2Z2UhfwE/3Iif
	IBItoLQTd4rmdvu34DGqLM612bNFBhEz8PTCuuw18/zx7p/70NUaXMeVKqJNXsldG4yk4fObl7m
	IeehVKYZp/uMDCsbZOUsmDnH3
X-Received: by 2002:a05:600c:2190:b0:3f7:395a:c9fa with SMTP id e16-20020a05600c219000b003f7395ac9famr11759550wme.4.1686755327421;
        Wed, 14 Jun 2023 08:08:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ50Y8gb9C9uZgb6Ff1fqPb2W2Yf/POCAD8enM3+pHFHPYkIxo9RSGh+vk7TxFeOZpNysKHwOg==
X-Received: by 2002:a05:600c:2190:b0:3f7:395a:c9fa with SMTP id e16-20020a05600c219000b003f7395ac9famr11759530wme.4.1686755327093;
        Wed, 14 Jun 2023 08:08:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p11-20020a1c740b000000b003f733c1129fsm17728056wmc.33.2023.06.14.08.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 08:08:46 -0700 (PDT)
Message-ID: <c2f52cb0-aa0c-4344-e20d-64564cf597fb@redhat.com>
Date: Wed, 14 Jun 2023 17:08:44 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 07/59] arm64: Add AT operation encodings
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <20230515173103.1017669-8-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-8-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 5/15/23 19:30, Marc Zyngier wrote:
> Add the encodings for the AT operation that are usable from NS.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 2727e68dd65b..8be78a9b9b3b 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -568,6 +568,23 @@
>  
>  #define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
>  
> +/* AT instructions */
> +#define AT_Op0 1
> +#define AT_CRn 7
> +
> +#define OP_AT_S1E1R	sys_insn(AT_Op0, 0, AT_CRn, 8, 0)
> +#define OP_AT_S1E1W	sys_insn(AT_Op0, 0, AT_CRn, 8, 1)
> +#define OP_AT_S1E0R	sys_insn(AT_Op0, 0, AT_CRn, 8, 2)
> +#define OP_AT_S1E0W	sys_insn(AT_Op0, 0, AT_CRn, 8, 3)
> +#define OP_AT_S1E1RP	sys_insn(AT_Op0, 0, AT_CRn, 9, 0)
> +#define OP_AT_S1E1WP	sys_insn(AT_Op0, 0, AT_CRn, 9, 1)
> +#define OP_AT_S1E2R	sys_insn(AT_Op0, 4, AT_CRn, 8, 0)
> +#define OP_AT_S1E2W	sys_insn(AT_Op0, 4, AT_CRn, 8, 1)
> +#define OP_AT_S12E1R	sys_insn(AT_Op0, 4, AT_CRn, 8, 4)
> +#define OP_AT_S12E1W	sys_insn(AT_Op0, 4, AT_CRn, 8, 5)
> +#define OP_AT_S12E0R	sys_insn(AT_Op0, 4, AT_CRn, 8, 6)
> +#define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
> +
>  /* TLBI instructions */
>  #define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
>  #define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

