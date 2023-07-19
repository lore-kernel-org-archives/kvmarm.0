Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9B312B70
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689788771;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yNb73O2isjawz78K1ttGBkIfh5jJDHN2n3NGZYz0Juw=;
	b=b3GsBT1Dn/KV/2MMfhPbdPkGBeh6sqr488+HUX+hRsSd4uo3KYtGtTV9z7R+rxEqjv6oxF
	4FT5owl2iBTU9pe/tNlNDbu3+OSmrYSWW7PaC1gsUQZS2KjXZtQc3DDoxbsQmjfVYaJyRN
	YrPTBIRYeGCr0OlrLdmkDGuJk75cUYU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-kYNdnGFjP1CTY3log8HuIg-1; Wed, 19 Jul 2023 13:46:07 -0400
X-MC-Unique: kYNdnGFjP1CTY3log8HuIg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-5eee6742285so74382966d6.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689788767; x=1690393567;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yNb73O2isjawz78K1ttGBkIfh5jJDHN2n3NGZYz0Juw=;
        b=JrOitVBYFgOK8kGdTIytjFHyfTJLO78/Irt3M2u/fANvPp+JFBYOuLl8X3O2FBlr2x
         DG5cfAQg1V3j9MNwS2mTNcxtdYjH6gM7bGL5lkzgdUesq3JvMAh2o0AIxTjoCP3GrDx5
         daM45eFUH8CShTheoJKC1uyi5O7TByhf+QkfFYzExVwmKtue8+hFB4XBvOt4b3Fr6buq
         qf9/st3+p4UaGfh02VM91XHX0caCZkP3IY7Ee/3cgwtB8G8F5DO0T8WplpK2uNQfu4Yv
         JjMgFwPnxuQiDxk8jTt111+lygmqZs5nCKLJsbf7bsI3yy/AjZVVei/H+06M8ct3fTaw
         CHhg==
X-Gm-Message-State: ABy/qLbqwnsBUruVF/+M5hNJMWrhkYZZ7p3R16RWDwss5xDCwBLXPwbE
	YpeNLBm9uJLUf2XQc9+aMWzTgyswmF+x1OSuv3ezVfWDYUADH0hTXWLIDPU/ydzlz/qys9ma4Oe
	Fyl/FNlOQjlv+JFg/
X-Received: by 2002:a0c:cb8e:0:b0:62b:6f7e:f79 with SMTP id p14-20020a0ccb8e000000b0062b6f7e0f79mr16907439qvk.3.1689788767345;
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEnUajR8taSGV4qOTfBZ3sumucQDatH1V5L1nfJ8Q1FWmgmEHvG2nspsjdxon+K24j4YwkETA==
X-Received: by 2002:a0c:cb8e:0:b0:62b:6f7e:f79 with SMTP id p14-20020a0ccb8e000000b0062b6f7e0f79mr16907427qvk.3.1689788767088;
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
Received: from [192.168.43.95] ([37.169.27.8])
        by smtp.gmail.com with ESMTPSA id i17-20020a0cab51000000b0062df126ca11sm1626622qvb.21.2023.07.19.10.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 10:46:06 -0700 (PDT)
Message-ID: <433bb06d-5eaa-d21f-70c8-02311c06a650@redhat.com>
Date: Wed, 19 Jul 2023 19:46:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm64: Define name for the bits
 used in SCTLR_EL1_RES1
To: Shaoqin Huang <shahuang@redhat.com>, andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-3-shahuang@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230719031926.752931-3-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 7/19/23 05:19, Shaoqin Huang wrote:
> Currently some fields in SCTLR_EL1 don't define a name and directly used
> in the SCTLR_EL1_RES1, that's not good now since these fields have been
> functional and have a name.
>
> According to the ARM DDI 0487J.a, define the name related to these
> fields.
>
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  lib/arm64/asm/sysreg.h | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index c7f529d..9c68698 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -80,17 +80,26 @@ asm(
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>  
>  /* System Control Register (SCTLR_EL1) bits */
> +#define SCTLR_EL1_LSMAOE	_BITUL(29)
> +#define SCTLR_EL1_NTLSMD	_BITUL(28)
>  #define SCTLR_EL1_EE		_BITUL(25)
> +#define SCTLR_EL1_SPAN		_BITUL(23)
> +#define SCTLR_EL1_EIS		_BITUL(22)
> +#define SCTLR_EL1_TSCXT		_BITUL(20)
>  #define SCTLR_EL1_WXN		_BITUL(19)
>  #define SCTLR_EL1_I		_BITUL(12)
> +#define SCTLR_EL1_EOS		_BITUL(11)
> +#define SCTLR_EL1_SED		_BITUL(8)
> +#define SCTLR_EL1_ITD		_BITUL(7)
>  #define SCTLR_EL1_SA0		_BITUL(4)
>  #define SCTLR_EL1_SA		_BITUL(3)
>  #define SCTLR_EL1_C		_BITUL(2)
>  #define SCTLR_EL1_A		_BITUL(1)
>  #define SCTLR_EL1_M		_BITUL(0)
>  
> -#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
> -			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> +#define SCTLR_EL1_RES1	(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
> +			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
> +			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
>  #define INIT_SCTLR_EL1_MMU_OFF	\
>  			SCTLR_EL1_RES1
>  
The change looks good to me (although _BITULL remark still holds).

Independently on this patch the _RES1 terminology looks odd to me. For
example ESO bit is RES1 only if FEAT_ExS is not implemented. Maybe I
misunderstand why it was named that way but to me RES1 means another
thing. If confirmed we could simply drop SCTLR_EL1_RES1 which is not
used elsewhere and directly define INIT_SCTLR_EL1_MMU_OF.

Thanks

Eric

