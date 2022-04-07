Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652BBC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 20:13:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEB8449F55;
	Thu,  7 Apr 2022 16:13:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KlnsQuWkI+Qv; Thu,  7 Apr 2022 16:13:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D419549F38;
	Thu,  7 Apr 2022 16:13:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0325549E2C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 16:13:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MhJdceUB-z7Q for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 16:13:27 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10EC940B80
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 16:13:27 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id k25so8190903iok.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 13:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kPv+ZIqzYvRek0cRdeMz/lWApF7cflqzGAwQSPk+D1g=;
 b=Vwbqolr+6WT9PZrvXSXV5eov3RfxCF9Upd51VWIyqZ1pqFcKZHmhRT9XnGsCkAHh05
 77l+zhWDpahLE5pUMG2B9j/nHIow4aw7XhZE+CsSD6z70hacoC3z1u+YNAcvKOfmrl3z
 fozVlMJs5iyRJSBg08fuwghJvWzY560AYZL5ZuaFcEn1PyVflPyG6JqaZHWqg2VH9Dfm
 OsUOi04iKG8rhuloDFnUSFpDocTzzSV6TJdRNMR01P/OfGl0U+E/ZBMTWX3uW0CSCFhQ
 si22K91rT3Z2Gb69hvZGq6tifarLk26cRL26z+WGWPuJmDLabL4zz9Fz0utJth5ajpZ/
 o2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kPv+ZIqzYvRek0cRdeMz/lWApF7cflqzGAwQSPk+D1g=;
 b=EVbfEmUQ4OUvh9joZJlzuIREbhtcPR9tvBgDOrL8CLanFcWBKanX/R3JsbUnS5Inxy
 2swuAO+Zj6hxRQAEsMcUwHbQ0AxzJW6WnfrgHDEh2qGhtL3rZ5wN7fQf97J94lpLu+LO
 FCKMbJmpAkcU6CL/+HW4PL6VbO04J8KxHhPM2EzzThmjKILAi6kWv/dWY4aFz3zjQlYO
 QomtrfZwKUN0UN3sloN2znjbjfwcu3xq04nXy0GQ+8KkKVJNelpyORi4u5CKK6ok05ue
 q6UtKjmNFIhCc4u0OLUhfoArxtwW13weW/UePZgBfv5sGW65hoHDkANGGG4pHmIgJI/y
 pfOw==
X-Gm-Message-State: AOAM531IbWCZbSjLw7gPPGoZUhQt2VWb3jeR3lp0VsLzHCRkP/i0Lt1u
 YpwdOlFH4iZ+N9hGn2FrDiwVmQ==
X-Google-Smtp-Source: ABdhPJx5V2vUqUS2eTOHLtK7IH0eyx7bh5pFcMTMmAj8gSnHQ2ix1EFqPmZe47max8+jfJKS65ClQQ==
X-Received: by 2002:a05:6638:d47:b0:321:460a:88c8 with SMTP id
 d7-20020a0566380d4700b00321460a88c8mr7430290jak.175.1649362406410; 
 Thu, 07 Apr 2022 13:13:26 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 m9-20020a0566022ac900b0064cf3d9f35fsm8889296iov.35.2022.04.07.13.13.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Apr 2022 13:13:25 -0700 (PDT)
Date: Thu, 7 Apr 2022 20:13:22 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/4] irqchip/gic-v3: Exposes bit values for
 GICR_CTLR.{IR,CES}
Message-ID: <Yk9F4jkfmYKdvUHz@google.com>
References: <20220405182327.205520-1-maz@kernel.org>
 <20220405182327.205520-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220405182327.205520-2-maz@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Apr 05, 2022 at 07:23:24PM +0100, Marc Zyngier wrote:
> As we're about to expose GICR_CTLR.{IR,CES} to guests, populate
> the include file with the architectural values.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  include/linux/irqchip/arm-gic-v3.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 12d91f0dedf9..728691365464 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -127,6 +127,8 @@
>  #define GICR_PIDR2			GICD_PIDR2
>  
>  #define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
> +#define GICR_CTLR_CES			(1UL << 1)
> +#define GICR_CTLR_IR			(1UL << 2)
>  #define GICR_CTLR_RWP			(1UL << 3)
>  
>  #define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
