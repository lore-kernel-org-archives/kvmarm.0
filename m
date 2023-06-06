Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FC0294D3
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 09:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686044022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kL+DqJUm5U6TFHuhQj83O46KkLfEwvC4DLSR18DYPSM=;
	b=NVHQ+D8MS8EWoz0xO4T53AgSgT2zAhUMOOQ50JflMz7knUvmOxManeT4tS5QsRKCWt9j8p
	rop/iodpJ+MIqAzF0Atc2n7uyX9eFBlxT27mymQQy/al2iqJU2kVlADilqyt2hK/wVuP4r
	oPZB67HTgG62P9a71mrGpGn/Dktsr14=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-ZOEA_HH9NSe2xDiLee0ZAw-1; Tue, 06 Jun 2023 05:33:40 -0400
X-MC-Unique: ZOEA_HH9NSe2xDiLee0ZAw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-75e8f34a6fcso255263785a.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 02:33:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686044020; x=1688636020;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kL+DqJUm5U6TFHuhQj83O46KkLfEwvC4DLSR18DYPSM=;
        b=fBkzS6JlSw991uM3YBa01zafJYBGrDPKhDVAexpGJYhMF1yIZujk3d/6ppp1kLe6A9
         htfze7efwbga8+mhc5R5WekZnHZRJrcb8M07No5K4gVFEHTas8067aFiJ3nZ33Qxre05
         c8newwhLnQ0RvwsI2vcH2ns+oLghheF3q/4mcuaq7vK4A4fMDaw8N0ou59SmKza7PtMq
         iwKvY2Q8IDGczmEMNXdFY9gl0Z5icoCTiwwF9z1qCsmJzP9Q6xVIhGBXqko4EbxyaKJT
         KOhJAgWW8xnX8PLyDmE66exI5RUL1GVZuTWpJ/ndDnYZblGx6gNVw1t0cfZfO8qRC9fg
         20Gw==
X-Gm-Message-State: AC+VfDzpHlqQjCSXoPmK1YNVDXXjw7h//MXmaZM4oAxBhWfOiwbug4gh
	A7sIZ2N97Fa5PWW3nZ2rwYhdUGtNpECqUT+3Jd8TAqndzhdgptJjBNiVxzi/EiEi9Pledm11sbB
	S2y+3kxVgT4b5Gw8T
X-Received: by 2002:ac8:5f83:0:b0:3f6:ac1b:47b3 with SMTP id j3-20020ac85f83000000b003f6ac1b47b3mr1420836qta.34.1686044020446;
        Tue, 06 Jun 2023 02:33:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5IHSNH2kXYClfPF7+eeeWzQy0YgraKLLPOiKH8WekEnx/oDm1lUrlT+4XRcDVYDiENLu6dww==
X-Received: by 2002:ac8:5f83:0:b0:3f6:ac1b:47b3 with SMTP id j3-20020ac85f83000000b003f6ac1b47b3mr1420820qta.34.1686044020204;
        Tue, 06 Jun 2023 02:33:40 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i6-20020ac87646000000b003f6b0562ad7sm5423861qtr.16.2023.06.06.02.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:33:39 -0700 (PDT)
Message-ID: <0cb4ac7a-6dcf-db68-69e9-dd6a01678aed@redhat.com>
Date: Tue, 6 Jun 2023 11:33:33 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 06/59] arm64: Add TLBI operation encodings
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
 <20230515173103.1017669-7-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-7-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 5/15/23 19:30, Marc Zyngier wrote:
> Add all the TLBI encodings that are usable from Non-Secure.
> 

> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/include/asm/sysreg.h | 128 ++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 28ccc379a172..2727e68dd65b 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -568,6 +568,134 @@
>  
>  #define SYS_SP_EL2			sys_reg(3, 6,  4, 1, 0)
>  
> +/* TLBI instructions */
> +#define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
> +#define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)
> +#define OP_TLBI_ASIDE1OS		sys_insn(1, 0, 8, 1, 2)
> +#define OP_TLBI_VAAE1OS			sys_insn(1, 0, 8, 1, 3)
> +#define OP_TLBI_VALE1OS			sys_insn(1, 0, 8, 1, 5)
> +#define OP_TLBI_VAALE1OS		sys_insn(1, 0, 8, 1, 7)
> +#define OP_TLBI_RVAE1IS			sys_insn(1, 0, 8, 2, 1)
> +#define OP_TLBI_RVAAE1IS		sys_insn(1, 0, 8, 2, 3)
> +#define OP_TLBI_RVALE1IS		sys_insn(1, 0, 8, 2, 5)
> +#define OP_TLBI_RVAALE1IS		sys_insn(1, 0, 8, 2, 7)
> +#define OP_TLBI_VMALLE1IS		sys_insn(1, 0, 8, 3, 0)
> +#define OP_TLBI_VAE1IS			sys_insn(1, 0, 8, 3, 1)
> +#define OP_TLBI_ASIDE1IS		sys_insn(1, 0, 8, 3, 2)
> +#define OP_TLBI_VAAE1IS			sys_insn(1, 0, 8, 3, 3)
> +#define OP_TLBI_VALE1IS			sys_insn(1, 0, 8, 3, 5)
> +#define OP_TLBI_VAALE1IS		sys_insn(1, 0, 8, 3, 7)
> +#define OP_TLBI_RVAE1OS			sys_insn(1, 0, 8, 5, 1)
> +#define OP_TLBI_RVAAE1OS		sys_insn(1, 0, 8, 5, 3)
> +#define OP_TLBI_RVALE1OS		sys_insn(1, 0, 8, 5, 5)
> +#define OP_TLBI_RVAALE1OS		sys_insn(1, 0, 8, 5, 7)
> +#define OP_TLBI_RVAE1			sys_insn(1, 0, 8, 6, 1)
> +#define OP_TLBI_RVAAE1			sys_insn(1, 0, 8, 6, 3)
> +#define OP_TLBI_RVALE1			sys_insn(1, 0, 8, 6, 5)
> +#define OP_TLBI_RVAALE1			sys_insn(1, 0, 8, 6, 7)
> +#define OP_TLBI_VMALLE1			sys_insn(1, 0, 8, 7, 0)
> +#define OP_TLBI_VAE1			sys_insn(1, 0, 8, 7, 1)
> +#define OP_TLBI_ASIDE1			sys_insn(1, 0, 8, 7, 2)
> +#define OP_TLBI_VAAE1			sys_insn(1, 0, 8, 7, 3)
> +#define OP_TLBI_VALE1			sys_insn(1, 0, 8, 7, 5)
> +#define OP_TLBI_VAALE1			sys_insn(1, 0, 8, 7, 7)
> +#define OP_TLBI_VMALLE1OSNXS		sys_insn(1, 0, 9, 1, 0)
> +#define OP_TLBI_VAE1OSNXS		sys_insn(1, 0, 9, 1, 1)
> +#define OP_TLBI_ASIDE1OSNXS		sys_insn(1, 0, 9, 1, 2)
> +#define OP_TLBI_VAAE1OSNXS		sys_insn(1, 0, 9, 1, 3)
> +#define OP_TLBI_VALE1OSNXS		sys_insn(1, 0, 9, 1, 5)
> +#define OP_TLBI_VAALE1OSNXS		sys_insn(1, 0, 9, 1, 7)
> +#define OP_TLBI_RVAE1ISNXS		sys_insn(1, 0, 9, 2, 1)
> +#define OP_TLBI_RVAAE1ISNXS		sys_insn(1, 0, 9, 2, 3)
> +#define OP_TLBI_RVALE1ISNXS		sys_insn(1, 0, 9, 2, 5)
> +#define OP_TLBI_RVAALE1ISNXS		sys_insn(1, 0, 9, 2, 7)
> +#define OP_TLBI_VMALLE1ISNXS		sys_insn(1, 0, 9, 3, 0)
> +#define OP_TLBI_VAE1ISNXS		sys_insn(1, 0, 9, 3, 1)
> +#define OP_TLBI_ASIDE1ISNXS		sys_insn(1, 0, 9, 3, 2)
> +#define OP_TLBI_VAAE1ISNXS		sys_insn(1, 0, 9, 3, 3)
> +#define OP_TLBI_VALE1ISNXS		sys_insn(1, 0, 9, 3, 5)
> +#define OP_TLBI_VAALE1ISNXS		sys_insn(1, 0, 9, 3, 7)
> +#define OP_TLBI_RVAE1OSNXS		sys_insn(1, 0, 9, 5, 1)
> +#define OP_TLBI_RVAAE1OSNXS		sys_insn(1, 0, 9, 5, 3)
> +#define OP_TLBI_RVALE1OSNXS		sys_insn(1, 0, 9, 5, 5)
> +#define OP_TLBI_RVAALE1OSNXS		sys_insn(1, 0, 9, 5, 7)
> +#define OP_TLBI_RVAE1NXS		sys_insn(1, 0, 9, 6, 1)
> +#define OP_TLBI_RVAAE1NXS		sys_insn(1, 0, 9, 6, 3)
> +#define OP_TLBI_RVALE1NXS		sys_insn(1, 0, 9, 6, 5)
> +#define OP_TLBI_RVAALE1NXS		sys_insn(1, 0, 9, 6, 7)
> +#define OP_TLBI_VMALLE1NXS		sys_insn(1, 0, 9, 7, 0)
> +#define OP_TLBI_VAE1NXS			sys_insn(1, 0, 9, 7, 1)
> +#define OP_TLBI_ASIDE1NXS		sys_insn(1, 0, 9, 7, 2)
> +#define OP_TLBI_VAAE1NXS		sys_insn(1, 0, 9, 7, 3)
> +#define OP_TLBI_VALE1NXS		sys_insn(1, 0, 9, 7, 5)
> +#define OP_TLBI_VAALE1NXS		sys_insn(1, 0, 9, 7, 7)
> +#define OP_TLBI_IPAS2E1IS		sys_insn(1, 4, 8, 0, 1)
> +#define OP_TLBI_RIPAS2E1IS		sys_insn(1, 4, 8, 0, 2)
> +#define OP_TLBI_IPAS2LE1IS		sys_insn(1, 4, 8, 0, 5)
> +#define OP_TLBI_RIPAS2LE1IS		sys_insn(1, 4, 8, 0, 6)
> +#define OP_TLBI_ALLE2OS			sys_insn(1, 4, 8, 1, 0)
> +#define OP_TLBI_VAE2OS			sys_insn(1, 4, 8, 1, 1)
> +#define OP_TLBI_ALLE1OS			sys_insn(1, 4, 8, 1, 4)
> +#define OP_TLBI_VALE2OS			sys_insn(1, 4, 8, 1, 5)
> +#define OP_TLBI_VMALLS12E1OS		sys_insn(1, 4, 8, 1, 6)
> +#define OP_TLBI_RVAE2IS			sys_insn(1, 4, 8, 2, 1)
> +#define OP_TLBI_RVALE2IS		sys_insn(1, 4, 8, 2, 5)
> +#define OP_TLBI_ALLE2IS			sys_insn(1, 4, 8, 3, 0)
> +#define OP_TLBI_VAE2IS			sys_insn(1, 4, 8, 3, 1)
> +#define OP_TLBI_ALLE1IS			sys_insn(1, 4, 8, 3, 4)
> +#define OP_TLBI_VALE2IS			sys_insn(1, 4, 8, 3, 5)
> +#define OP_TLBI_VMALLS12E1IS		sys_insn(1, 4, 8, 3, 6)
> +#define OP_TLBI_IPAS2E1OS		sys_insn(1, 4, 8, 4, 0)
> +#define OP_TLBI_IPAS2E1			sys_insn(1, 4, 8, 4, 1)
> +#define OP_TLBI_RIPAS2E1		sys_insn(1, 4, 8, 4, 2)
> +#define OP_TLBI_RIPAS2E1OS		sys_insn(1, 4, 8, 4, 3)
> +#define OP_TLBI_IPAS2LE1OS		sys_insn(1, 4, 8, 4, 4)
> +#define OP_TLBI_IPAS2LE1		sys_insn(1, 4, 8, 4, 5)
> +#define OP_TLBI_RIPAS2LE1		sys_insn(1, 4, 8, 4, 6)
> +#define OP_TLBI_RIPAS2LE1OS		sys_insn(1, 4, 8, 4, 7)
> +#define OP_TLBI_RVAE2OS			sys_insn(1, 4, 8, 5, 1)
> +#define OP_TLBI_RVALE2OS		sys_insn(1, 4, 8, 5, 5)
> +#define OP_TLBI_RVAE2			sys_insn(1, 4, 8, 6, 1)
> +#define OP_TLBI_RVALE2			sys_insn(1, 4, 8, 6, 5)
> +#define OP_TLBI_ALLE2			sys_insn(1, 4, 8, 7, 0)
> +#define OP_TLBI_VAE2			sys_insn(1, 4, 8, 7, 1)
> +#define OP_TLBI_ALLE1			sys_insn(1, 4, 8, 7, 4)
> +#define OP_TLBI_VALE2			sys_insn(1, 4, 8, 7, 5)
> +#define OP_TLBI_VMALLS12E1		sys_insn(1, 4, 8, 7, 6)
> +#define OP_TLBI_IPAS2E1ISNXS		sys_insn(1, 4, 9, 0, 1)
> +#define OP_TLBI_RIPAS2E1ISNXS		sys_insn(1, 4, 9, 0, 2)
> +#define OP_TLBI_IPAS2LE1ISNXS		sys_insn(1, 4, 9, 0, 5)
> +#define OP_TLBI_RIPAS2LE1ISNXS		sys_insn(1, 4, 9, 0, 6)
> +#define OP_TLBI_ALLE2OSNXS		sys_insn(1, 4, 9, 1, 0)
> +#define OP_TLBI_VAE2OSNXS		sys_insn(1, 4, 9, 1, 1)
> +#define OP_TLBI_ALLE1OSNXS		sys_insn(1, 4, 9, 1, 4)
> +#define OP_TLBI_VALE2OSNXS		sys_insn(1, 4, 9, 1, 5)
> +#define OP_TLBI_VMALLS12E1OSNXS		sys_insn(1, 4, 9, 1, 6)
> +#define OP_TLBI_RVAE2ISNXS		sys_insn(1, 4, 9, 2, 1)
> +#define OP_TLBI_RVALE2ISNXS		sys_insn(1, 4, 9, 2, 5)
> +#define OP_TLBI_ALLE2ISNXS		sys_insn(1, 4, 9, 3, 0)
> +#define OP_TLBI_VAE2ISNXS		sys_insn(1, 4, 9, 3, 1)
> +#define OP_TLBI_ALLE1ISNXS		sys_insn(1, 4, 9, 3, 4)
> +#define OP_TLBI_VALE2ISNXS		sys_insn(1, 4, 9, 3, 5)
> +#define OP_TLBI_VMALLS12E1ISNXS		sys_insn(1, 4, 9, 3, 6)
> +#define OP_TLBI_IPAS2E1OSNXS		sys_insn(1, 4, 9, 4, 0)
> +#define OP_TLBI_IPAS2E1NXS		sys_insn(1, 4, 9, 4, 1)
> +#define OP_TLBI_RIPAS2E1NXS		sys_insn(1, 4, 9, 4, 2)
> +#define OP_TLBI_RIPAS2E1OSNXS		sys_insn(1, 4, 9, 4, 3)
> +#define OP_TLBI_IPAS2LE1OSNXS		sys_insn(1, 4, 9, 4, 4)
> +#define OP_TLBI_IPAS2LE1NXS		sys_insn(1, 4, 9, 4, 5)
> +#define OP_TLBI_RIPAS2LE1NXS		sys_insn(1, 4, 9, 4, 6)
> +#define OP_TLBI_RIPAS2LE1OSNXS		sys_insn(1, 4, 9, 4, 7)
> +#define OP_TLBI_RVAE2OSNXS		sys_insn(1, 4, 9, 5, 1)
> +#define OP_TLBI_RVALE2OSNXS		sys_insn(1, 4, 9, 5, 5)
> +#define OP_TLBI_RVAE2NXS		sys_insn(1, 4, 9, 6, 1)
> +#define OP_TLBI_RVALE2NXS		sys_insn(1, 4, 9, 6, 5)
> +#define OP_TLBI_ALLE2NXS		sys_insn(1, 4, 9, 7, 0)
> +#define OP_TLBI_VAE2NXS			sys_insn(1, 4, 9, 7, 1)
> +#define OP_TLBI_ALLE1NXS		sys_insn(1, 4, 9, 7, 4)
> +#define OP_TLBI_VALE2NXS		sys_insn(1, 4, 9, 7, 5)
> +#define OP_TLBI_VMALLS12E1NXS		sys_insn(1, 4, 9, 7, 6)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_ENTP2	(BIT(60))
>  #define SCTLR_ELx_DSSBS	(BIT(44))

