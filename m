Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2F51C10
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 08:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677745199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XoJEO/rrhsWrElsDeh33FRv7UGKPrM+4RlG9La9lfTc=;
	b=BKjth3dLh1BS288iPIR9SKu7NpJ3vjw3QJW5M4gORM5jU3YSYoTH56YjQ6oQg4YFNgcvTa
	JE9Lh/awKYdESEtdA2RBWuHXqn4+ZDOzEi5a9Ki/ZQTBvAlPTJdmOkcmgmOd1atxK5Omph
	FL4uq+orCxoUb36O/up+SEQaJ2as0Z4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-540-vCyzscRZMKuIUOF65oP2sw-1; Thu, 02 Mar 2023 03:19:57 -0500
X-MC-Unique: vCyzscRZMKuIUOF65oP2sw-1
Received: by mail-qk1-f199.google.com with SMTP id y1-20020a05620a09c100b0070630ecfd9bso9629239qky.20
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 00:19:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XoJEO/rrhsWrElsDeh33FRv7UGKPrM+4RlG9La9lfTc=;
        b=oSN0idfhoyuu4zHnv/PR3zk1mt1xvNdG1fGCiaYIK13rGDgMEY0AexLahuSUTiw9tL
         YjrbY/FzDiOPmJHyhutUmtlLE7bcGcnW3GzPiUi5CIkVulFgGery9lCyzNnEQc0hFDI1
         1Nmeq8lm4Z3Rq3zaBNDlJj1xWJKDzvh0IlmLmNDUA2yJC+QVRuZsYilcDbIWJQZ2Wv4F
         2FleEaZFZ+0R9rFGPme25+WeF0V3AmdOCVqgtl7H71ZjVG4tDj6MIZ4Yu0VnCX2fCfqV
         BKykPxDQ5yiogbleooSIm+80KxZLAhJh7JxK0VHLF2mvu7QKWc4XqmjGsUCWl1cPi+bI
         KvtQ==
X-Gm-Message-State: AO0yUKV6d6eMCEjZrUQBjKDcprNnqZ6BhLbzU5017yUGVax0Ij557zOQ
	56IheVTYyY2d6R/9KY90n1ZpQ/nqGxQ/M0IRw9yrBTT5YOWHdh0T6w5E7pHzOOOGTOulseYvqHz
	W8QpoJsoBXfzvXamp
X-Received: by 2002:a05:622a:1a84:b0:3bf:b6ba:1c1f with SMTP id s4-20020a05622a1a8400b003bfb6ba1c1fmr17689094qtc.10.1677745197469;
        Thu, 02 Mar 2023 00:19:57 -0800 (PST)
X-Google-Smtp-Source: AK7set/f8FUy6jS5OC2id5Rsy6kJpPekovC1uYs9hy0AcMyf273M0RdPVTwqpf0GUC63NUgSX9UIcQ==
X-Received: by 2002:a05:622a:1a84:b0:3bf:b6ba:1c1f with SMTP id s4-20020a05622a1a8400b003bfb6ba1c1fmr17689082qtc.10.1677745197262;
        Thu, 02 Mar 2023 00:19:57 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d5-20020ac86685000000b003bfaf01af24sm9894512qtp.46.2023.03.02.00.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 00:19:56 -0800 (PST)
Message-ID: <58de2175-62f1-a873-872b-dff79c53fec9@redhat.com>
Date: Thu, 2 Mar 2023 09:19:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RESEND kvm-unit-tests 3/3] arm64: microbench: Use
 gic_enable_irq() macro in microbench test
To: Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc: Andrew Jones <andrew.jones@linux.dev>, "open list:ARM"
 <kvm@vger.kernel.org>
References: <20230302030238.158796-1-shahuang@redhat.com>
 <20230302030238.158796-4-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230302030238.158796-4-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 3/2/23 04:02, Shaoqin Huang wrote:
> Use gic_enable_irq() to clean up code.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/micro-bench.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 8436612..090fda6 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -212,24 +212,11 @@ static void lpi_exec(void)
>  
>  static bool timer_prep(void)
>  {
> -	void *gic_isenabler;
> -
>  	gic_enable_defaults();
>  	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>  	local_irq_enable();
>  
> -	switch (gic_version()) {
> -	case 2:
> -		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
> -		break;
> -	case 3:
> -		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> -		break;
> -	default:
> -		assert_msg(0, "Unreachable");
> -	}
> -
> -	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
> +	gic_enable_irq(PPI(TIMER_VTIMER_IRQ));
>  	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>  	isb();
>  

