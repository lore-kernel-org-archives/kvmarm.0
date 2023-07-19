Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C81FB54
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689788770;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xc6omUiqM4jPVbPJYgpEaaN+HCGov9iJZcDyC06CGAU=;
	b=B8IVyPMe9mPXllomeUoqdA6CY3v2+II0QmDWpQSIqndqZfSKijDeKt8JC9Xpu6D9Wyyo3v
	r217ENs7vMJUKbdVozR1LnFK7wg9/wvNcDeHxDnwb4a2T0NlvzcOToU09b0QhAHjWwEHmX
	NiAlxCuUbLkb0zttNNt9En1d/HBwq1I=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-JfEmENJtNamEaXGc4bIPpw-1; Wed, 19 Jul 2023 13:46:08 -0400
X-MC-Unique: JfEmENJtNamEaXGc4bIPpw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-765a6bbdd17so828254185a.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 10:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689788768; x=1690393568;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xc6omUiqM4jPVbPJYgpEaaN+HCGov9iJZcDyC06CGAU=;
        b=dFSBOyziA2fs8W8jLGpfo7KXmtI6zf6DbModGq6HCFErx9IhxsOsZIAhqhJtcyoXQr
         oXDhAanEF1uYRc71AKRlR9ksRr8xRxcqLC+wshm8E2pmDOPm3Oz4UIW80v12c03fnjMB
         w6ylZ5Hy2ARtJ2sCPlk3gtgHravQ49NJ70kll5qZxUMdNxwsmjA/B17K7fmZrSdbzh+0
         OUL4Ia70Dpw23kVgKXsDKLCn8IEICQC3ky9KdTKqYa2JuOQL+qUQJi/pclENcMBkGW2p
         Fq87mKJzdCM8zhjnMV3KbDSVkGBi7mTb8QU9dwLylgzTnZyg4K/Rt+UeeyGohuO4Whut
         fjkQ==
X-Gm-Message-State: ABy/qLa5XLARs/lkvLu3YubYxo5yVl31heyc76qCKjD7zeKnZqxrkdP1
	9ohgrCHmH1EVySpmxQE84B76C7XMQW187c90c1xvbAaTdglWVkWw9K9Y4XmaYMefO9bVa4iTQkZ
	lJS+LmB1uu09bdL4j
X-Received: by 2002:a05:620a:2446:b0:767:7eb0:f238 with SMTP id h6-20020a05620a244600b007677eb0f238mr307130qkn.27.1689788768211;
        Wed, 19 Jul 2023 10:46:08 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHsKHJqlSDvr/KchOU2+gq87SCeLGOEPTcS1CFerZXsbrHa5+k5zVbCPPD6YHYI4/uDsfhv9A==
X-Received: by 2002:a05:620a:2446:b0:767:7eb0:f238 with SMTP id h6-20020a05620a244600b007677eb0f238mr307122qkn.27.1689788767987;
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
Received: from [192.168.43.95] ([37.169.27.8])
        by smtp.gmail.com with ESMTPSA id ou30-20020a05620a621e00b0075941df3365sm1412231qkn.52.2023.07.19.10.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 10:46:07 -0700 (PDT)
Message-ID: <4bf0d5e6-a879-c3ab-6538-a4e3bd762acc@redhat.com>
Date: Wed, 19 Jul 2023 19:46:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm64: Replace the SCTLR_EL1 filed
 definition by _BITUL()
To: Shaoqin Huang <shahuang@redhat.com>, andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-2-shahuang@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230719031926.752931-2-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 7/19/23 05:19, Shaoqin Huang wrote:
> Currently the SCTLR_EL1_* is defined by (1 << x), all of them can be
> replaced by the _BITUL() macro to make the format consistent with the
> SCTLR_EL1_RES1 definition.

I would rephrase the commit title into arm64: Use _BITUL() to define
SCTLR_EL1 bit fields

Besides, since SCTLR_EL1 is 64b shouldn't we have _BITULL() everywhere
instead?

Eric
>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  lib/arm64/asm/sysreg.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 18c4ed3..c7f529d 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -80,14 +80,14 @@ asm(
>  #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>  
>  /* System Control Register (SCTLR_EL1) bits */
> -#define SCTLR_EL1_EE	(1 << 25)
> -#define SCTLR_EL1_WXN	(1 << 19)
> -#define SCTLR_EL1_I	(1 << 12)
> -#define SCTLR_EL1_SA0	(1 << 4)
> -#define SCTLR_EL1_SA	(1 << 3)
> -#define SCTLR_EL1_C	(1 << 2)
> -#define SCTLR_EL1_A	(1 << 1)
> -#define SCTLR_EL1_M	(1 << 0)
> +#define SCTLR_EL1_EE		_BITUL(25)
> +#define SCTLR_EL1_WXN		_BITUL(19)
> +#define SCTLR_EL1_I		_BITUL(12)
> +#define SCTLR_EL1_SA0		_BITUL(4)
> +#define SCTLR_EL1_SA		_BITUL(3)
> +#define SCTLR_EL1_C		_BITUL(2)
> +#define SCTLR_EL1_A		_BITUL(1)
> +#define SCTLR_EL1_M		_BITUL(0)
>  
>  #define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>  			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))

