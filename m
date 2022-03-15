Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BECC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 23:16:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE0F49E3A;
	Tue, 15 Mar 2022 19:16:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HyFhCPLmv7+F; Tue, 15 Mar 2022 19:16:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA8649EB1;
	Tue, 15 Mar 2022 19:16:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B0240472
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 19:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hbe3MxSbvSrK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 19:16:10 -0400 (EDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03D7049E3A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 19:16:09 -0400 (EDT)
Received: by mail-io1-f44.google.com with SMTP id h63so529149iof.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 16:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=OWQCIDU5jEufwl7Eenakcb0vQxFa1/UoqORJLjuuNhE=;
 b=QPne9aKrq0jSJxwKAvN2RfdcxxPofCtmfVt75fA8YVrNJPDiYxQXuHO4+3AfxM2Vwe
 Aucldu1FnNvysmOxcFjg7PvgDeuRU3+UgHKeLlu8bX2elW3Jo/2EnIdEtAZyKA7/rULi
 Lwqe9KvnjIqsZq28oCcivnx/lr9CAGyJS+bwxPlWEdTH1o3iA0HbdkiEUlxvg97t+qQj
 mXL6h7WNhIkr2vR8PybLX/e2W74SwkklhEipaLRGwNZ2jP4UOnH04rYpv68jqAKRG90W
 4/pxYM7C55nfMmVmWZRxsmA2Ib5aRJmjHdkWtPuX20QeFWJlutQkHrBBH2rzQTWsR8Nr
 vCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OWQCIDU5jEufwl7Eenakcb0vQxFa1/UoqORJLjuuNhE=;
 b=PcsY1AszjBl1G7ItX9X+quTuwYkq1JM5e7FLe7RRpSU3QHHxB5e05g9GBazhKMUYQx
 S8iE4pSe9XJJIzoFoxkV5VV+rkOKT4uQTe2AIMfDEm7CBh8df7nycux2ZKQXj9AwWzoH
 fOS/eQFxOlXg1DgGvWGIJuaXUGHpuLXAZX+7CcNYErzjD+vpgQdRBRzntNK2tS9ABP9l
 P1PRh62V1v9dPrAhAgLS5PzF64e1lriWdRI39eveO3Ghm155Vy8ZF6+SLE1JuQMG8K73
 Vyp5AXeV1afhEfU44fCTRJ5KTsgo4DA2qZeebDTVPb/fHpo4SfYbvGlLcpaXY2fv6Wo2
 pk0g==
X-Gm-Message-State: AOAM53258BhSHyThoAEeba77GPFmx48tfaM9bN5RAogjQh921ZvVwvzD
 CH/5nYZ1ashruJMIhqoqCZwlkg==
X-Google-Smtp-Source: ABdhPJz9YtpbRtn+pOoVIMY+c8V/BrQ1H9IrGkr7iACumNBQrKchs6uMxcvVd/awNz9d3c+1qeU+fQ==
X-Received: by 2002:a05:6638:388e:b0:317:7979:f5bf with SMTP id
 b14-20020a056638388e00b003177979f5bfmr23978652jav.53.1647386169148; 
 Tue, 15 Mar 2022 16:16:09 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 s185-20020a6b2cc2000000b00648d69f367asm157422ios.16.2022.03.15.16.16.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 16:16:08 -0700 (PDT)
Date: Tue, 15 Mar 2022 23:16:05 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/4] irqchip/gic-v3: Exposes bit values for
 GICR_CTLR.{IR, CES}
Message-ID: <YjEeNThfYFtTffWz@google.com>
References: <20220314164044.772709-1-maz@kernel.org>
 <20220314164044.772709-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220314164044.772709-2-maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Mon, Mar 14, 2022 at 04:40:41PM +0000, Marc Zyngier wrote:
> As we're about to expose GICR_CTLR.{IR,CES} to guests, populate
> the include file with the architectural values.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/irqchip/arm-gic-v3.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 12d91f0dedf9..aeb8ced53880 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -127,6 +127,8 @@
>  #define GICR_PIDR2			GICD_PIDR2
>  
>  #define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
> +#define GICR_CTLR_IR			(1UL << 1)
> +#define GICR_CTLR_CES			(1UL << 2)

I think these are backwards (IR is bit 2)

https://developer.arm.com/documentation/ddi0595/2021-12/External-Registers/GICR-CTLR--Redistributor-Control-Register?lang=en

--
Thanks,
Oliver

>  #define GICR_CTLR_RWP			(1UL << 3)
>  
>  #define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
> -- 
> 2.34.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
