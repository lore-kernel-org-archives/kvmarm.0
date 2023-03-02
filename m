Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76651C10
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 08:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677745191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIjaXDXp4WiF/PZhzlcAElDicG/m9VQA0incK69mGeo=;
	b=DlKKPiFvHmXpMEA1i04yqeUuVQFV+cBs+oyF4djGp6GbKsIZxOkcumfi0epNA3S3nL3oHB
	oTTXBBjjfM+uOHy2vupu8+8cLnAsU54eEl12SoEYQoqKUdYDYabEOHVheAP1IuWcLCYTBZ
	9qLePY5iXS0CCOQK8NvyAXnuGRkF7qs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-510-Rjj_4fkVOwaIZiiVXqE7oA-1; Thu, 02 Mar 2023 03:19:49 -0500
X-MC-Unique: Rjj_4fkVOwaIZiiVXqE7oA-1
Received: by mail-qk1-f198.google.com with SMTP id u28-20020a05620a085c00b0073b88cae2f5so9593686qku.8
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 00:19:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIjaXDXp4WiF/PZhzlcAElDicG/m9VQA0incK69mGeo=;
        b=5kJATC/Cvx9eaQuJYLxKyGRJpJ16HnEqjMKs35TJUB3SaifBSuERxFGbXDFKrzg4Id
         926NJ1+YnFyV/Ohah4liFF/WHEpDm12spGuBSNgJLY94fF6IMtP6aYd3LMOomcbe8x1N
         8DaS8RkFzZSb93v5cE3pimI/HBn7FOOz2a2l5OBshUTW417JMZNBY5O79dld/npp+tl1
         wTGQ/DgGkuP+lagIqQGmqTTzgasPjzQkIJwp4ZBX7vNvN5VjIvxxo5r5kdfVT9S3hfOg
         JiE1qPHMxP/RLxoemscBTPf1t0x7jxgohk/ShilWxGcCb+jm/I79o/lGggzbE1kFKS3u
         Xz1Q==
X-Gm-Message-State: AO0yUKUevdaOrnB4zc4ZwUPZVZoPxVbGe8SWfEi59I89i0T/3IEte/1w
	YNgjrA6UpHXy+JMQUp35kuTDNrlF36JOk9yTYQwLQKnE6SUCrcH8G5WbuxtbUPiiyNXzaPlg1gy
	cI0+APc0DE7CwvdQH
X-Received: by 2002:a05:6214:29e9:b0:56b:fa99:7866 with SMTP id jv9-20020a05621429e900b0056bfa997866mr15509752qvb.7.1677745189315;
        Thu, 02 Mar 2023 00:19:49 -0800 (PST)
X-Google-Smtp-Source: AK7set9DC0uf3w5/KZdo3iDCN05BT27ad4JPBOOjlaA8gZ1f4js38pJNLws5TY6JsybSloz9MoJvIQ==
X-Received: by 2002:a05:6214:29e9:b0:56b:fa99:7866 with SMTP id jv9-20020a05621429e900b0056bfa997866mr15509741qvb.7.1677745189084;
        Thu, 02 Mar 2023 00:19:49 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g1-20020a37b601000000b00743049c2b15sm1221359qkf.66.2023.03.02.00.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 00:19:48 -0800 (PST)
Message-ID: <830e41b7-2e78-caff-7115-81be321bdad9@redhat.com>
Date: Thu, 2 Mar 2023 09:19:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RESEND kvm-unit-tests 2/3] arm64: timer: Use
 gic_enable/disable_irq() macro in timer test
To: Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc: Andrew Jones <andrew.jones@linux.dev>, "open list:ARM"
 <kvm@vger.kernel.org>
References: <20230302030238.158796-1-shahuang@redhat.com>
 <20230302030238.158796-3-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230302030238.158796-3-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/2/23 04:02, Shaoqin Huang wrote:
> Use gic_enable/disable_irq() to clean up the code.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Thanks

Eric

> ---
>  arm/timer.c | 20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index c4e7b10..c0a8388 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -14,9 +14,6 @@
>  #include <asm/gic.h>
>  #include <asm/io.h>
>  
> -static void *gic_isenabler;
> -static void *gic_icenabler;
> -
>  static bool ptimer_unsupported;
>  
>  static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
> @@ -139,12 +136,12 @@ static struct timer_info ptimer_info = {
>  
>  static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
>  {
> -	u32 val = 1 << PPI(info->irq);
> +	u32 irq = PPI(info->irq);
>  
>  	if (enabled)
> -		writel(val, gic_isenabler);
> +		gic_enable_irq(irq);
>  	else
> -		writel(val, gic_icenabler);
> +		gic_disable_irq(irq);
>  }
>  
>  static void irq_handler(struct pt_regs *regs)
> @@ -366,17 +363,6 @@ static void test_init(void)
>  
>  	gic_enable_defaults();
>  
> -	switch (gic_version()) {
> -	case 2:
> -		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
> -		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
> -		break;
> -	case 3:
> -		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> -		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
> -		break;
> -	}
> -
>  	install_irq_handler(EL1H_IRQ, irq_handler);
>  	set_timer_irq_enabled(&ptimer_info, true);
>  	set_timer_irq_enabled(&vtimer_info, true);

