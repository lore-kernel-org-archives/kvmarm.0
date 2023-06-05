Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9698CDDC0
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685987247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLdXseVvogL1t+8Q/CY9+/t9PCx7FNGeBdzXRWCRuUA=;
	b=MLPkDn2bUAJzNpoD9IerUQqqUpWNVytCY+sgBhyZijkcTk2W+I97PU3pJlU91awMYtmxVF
	DXKhUnVr2CBPjxJDzfL2HyfZsWTeYa6lJV8KqGYjPRX6MuD+1qgOiXAJMW1BMq8tTmMDQn
	WzSv8BU38TtTtSwRMUTcaqwkl/RCBtE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-4HOrQx3ZNtSPhTAntvDltg-1; Mon, 05 Jun 2023 13:47:25 -0400
X-MC-Unique: 4HOrQx3ZNtSPhTAntvDltg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f6089a9689so30244815e9.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Jun 2023 10:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987244; x=1688579244;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WLdXseVvogL1t+8Q/CY9+/t9PCx7FNGeBdzXRWCRuUA=;
        b=jwLVBUoVdaw5JmmGH0WVYxmHXxHRV9dM8LHe4z7gDfhru8jDD18V6U/mdJnin20O4G
         obwUkuPlrhzATZJsyccAn6Li8TYMZxaKgB/a7lWmbtltkpNYlJqypfvQpDVeNEUR0nXS
         W19IR2MYS+gt/4j4lvqSLXja5K/FV5m5JB8Hn1wfVxYLAw6LkIoMMs0DT/fVhfHdi0gA
         iuPGAmF2HkUI1FoshsoENE8Y510Q2S+gzfzWTG02wSq/lnr53fQYcmlZgkSXwEcKUxg6
         eXD7rUuRk3ibb/a8Bvwp1Tg6Y+QW9r45+kwSn2WeDcjfrCRFzNu7gyQzH71WY9pygytO
         rRRg==
X-Gm-Message-State: AC+VfDxG0KoyQZVmYt5/4gy5a+IKMALCBiaPyTivMIEfUHcXq0gPmqbn
	XEtB5oZmS2uxroLv2at24LYdsFFLOrTOAvkXskS0fOVOL+oMwkMPOu4aCaY2x+92yz4r6M/wjwj
	OzbW3zvAAxIIDBuJe
X-Received: by 2002:a7b:cd94:0:b0:3f6:ea4:a667 with SMTP id y20-20020a7bcd94000000b003f60ea4a667mr7632971wmj.39.1685987244717;
        Mon, 05 Jun 2023 10:47:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5H56pUKlF8Pr1TrIFrMedoqttFVtZKKklavoHiUMEZfUjl0DxW7CAypMZGNy02Ep8+5arhtA==
X-Received: by 2002:a7b:cd94:0:b0:3f6:ea4:a667 with SMTP id y20-20020a7bcd94000000b003f60ea4a667mr7632967wmj.39.1685987244553;
        Mon, 05 Jun 2023 10:47:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d24-20020a1c7318000000b003f18b942338sm11544991wmb.3.2023.06.05.10.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 10:47:24 -0700 (PDT)
Message-ID: <372506ec-2717-7ed1-e5f1-617b42c73935@redhat.com>
Date: Mon, 5 Jun 2023 19:47:22 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 05/59] arm64: Add missing DC ZVA/GVA/GZVA encodings
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
 <20230515173103.1017669-6-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-6-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/15/23 19:30, Marc Zyngier wrote:
> Add the missing DC *VA encodings.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 71305f7425db..28ccc379a172 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -150,6 +150,11 @@
>  #define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
>  #define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
>  
> +/* Data cache zero operations */
> +#define SYS_DC_ZVA			sys_insn(1, 3, 7, 4, 1)
> +#define SYS_DC_GVA			sys_insn(1, 3, 7, 4, 3)
> +#define SYS_DC_GZVA			sys_insn(1, 3, 7, 4, 4)
> +
>  /*
>   * Automatically generated definitions for system registers, the
>   * manual encodings below are in the process of being converted to
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

