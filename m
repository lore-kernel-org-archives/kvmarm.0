Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488FB1866
	for <kvmarm@lists.linux.dev>; Thu,  2 Mar 2023 08:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677745182;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3QJC7xrknqCUo3QneAi3gtan/QiuwSf0HXodYL5voFQ=;
	b=aPmyZbwLCW7pAtAxAOs0YXKXxtqCOYcky8vM0S10zFDKSJzgMhPjZuvHQ7A3+XJSTd6aAO
	85Tx9oAjVNJUnDC1H2DeNqCuhM4z9hUk27mEpCRkoHiYjt/CqTsiZP0Zt6UAF1u3BBNPjk
	bj2upZwNyrqmXh+scT07dc4i622ZvNs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-221-99FP1O7YMsabf8Ls0Y-3Gw-1; Thu, 02 Mar 2023 03:19:41 -0500
X-MC-Unique: 99FP1O7YMsabf8Ls0Y-3Gw-1
Received: by mail-qt1-f197.google.com with SMTP id p7-20020ac84607000000b003b9b6101f65so8039823qtn.11
        for <kvmarm@lists.linux.dev>; Thu, 02 Mar 2023 00:19:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3QJC7xrknqCUo3QneAi3gtan/QiuwSf0HXodYL5voFQ=;
        b=g4PFKHMhvUVfUzSgLWt/R1bA1iVSje57x6yv2uGcQ3D9P8oH4BEeZ//UVdS361KoQH
         0uZIMc3pUJRzKnr+zEavQXukg1lcKv7WBEaS5dV0pKQPQFr4h+VsQErRV3I1XTSbmztH
         ULCrSgKSQy12f+PXfeokqK3yVwhfxTlj7mO9+eNTRFq6/LOZ62UTkCzE6yKYzeS0fdlv
         nvCnauweHgbeF8s9kT1zR29TQbCVDqtrB8w2ayl+YbMim5ue/wtqP4884YV53TVmIWHR
         JovQxgkHfY3M5RZfGSOm/CMIa5g4pMMyBNM7/oWgmF7gONfO0S0dm0ZxB8e5z88ugyOP
         PjGQ==
X-Gm-Message-State: AO0yUKXjL+cn9c32ELkM2/bCRRdoR9AMUULNGLZddS9IpQ9xHUtDUhAa
	+vrE0gwK4q9Q66T7hyprUAIh6bLU3h5z2fMjGBddIT9l4bpEumz9Uwsk+QM8p3qtQbLqaCG96P5
	IYFvNhasjpB/IRM+C
X-Received: by 2002:a05:622a:1306:b0:3bd:1835:b001 with SMTP id v6-20020a05622a130600b003bd1835b001mr17100249qtk.20.1677745180484;
        Thu, 02 Mar 2023 00:19:40 -0800 (PST)
X-Google-Smtp-Source: AK7set9aLD2f3rBaPdQofL9Ou9Zba6yEy0mtfG4HkKo550DSwBneHUAn/2VtsAVxHAqpjBANLxb/Kg==
X-Received: by 2002:a05:622a:1306:b0:3bd:1835:b001 with SMTP id v6-20020a05622a130600b003bd1835b001mr17100237qtk.20.1677745180263;
        Thu, 02 Mar 2023 00:19:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f7-20020ac80147000000b003b2957fb45bsm9910169qtg.8.2023.03.02.00.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 00:19:39 -0800 (PST)
Message-ID: <a9799d3b-e7c5-89fd-a910-b574cff67913@redhat.com>
Date: Thu, 2 Mar 2023 09:19:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [RESEND kvm-unit-tests 1/3] arm: gic: Write one bit per time in
 gic_irq_set_clr_enable()
To: Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc: Andrew Jones <andrew.jones@linux.dev>, "open list:ARM"
 <kvm@vger.kernel.org>
References: <20230302030238.158796-1-shahuang@redhat.com>
 <20230302030238.158796-2-shahuang@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230302030238.158796-2-shahuang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 3/2/23 04:02, Shaoqin Huang wrote:
> When use gic_irq_set_clr_enable() to disable an interrupt, it will
> disable all interrupt since it first read from Interrupt Clear-Enable
> Registers and then write this value with a mask back.

nit: it first read from Interrupt Clear-Enable Registers where '1' indicates that forwarding of the corresponding interrupt is enabled

>
> So diretly write one bit per time to enable or disable interrupt.
directly
> Fixes: cb573c2 ("arm: gic: Introduce gic_irq_set_clr_enable() helper")
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eirc
> ---
>  lib/arm/gic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 1bfcfcf..89a15fe 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -176,7 +176,6 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
>  void gic_irq_set_clr_enable(int irq, bool enable)
>  {
>  	u32 offset, split = 32, shift = (irq % 32);
> -	u32 reg, mask = BIT(shift);
>  	void *base;
>  
>  	assert(irq < 1020);
> @@ -199,8 +198,7 @@ void gic_irq_set_clr_enable(int irq, bool enable)
>  		assert(0);
>  	}
>  	base += offset + (irq / split) * 4;
> -	reg = readl(base);
> -	writel(reg | mask, base);
> +	writel(BIT(shift), base);
>  }
>  
>  enum gic_irq_state gic_irq_state(int irq)

