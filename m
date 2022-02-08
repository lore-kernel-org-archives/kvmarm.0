Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A0AC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:29:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E33B54B0EC;
	Tue,  8 Feb 2022 12:29:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id utWfiK5NS5MU; Tue,  8 Feb 2022 12:29:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3386F4B0ED;
	Tue,  8 Feb 2022 12:29:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A36434B0ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:29:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SN+sSA8XxPSA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:29:45 -0500 (EST)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C4574B0EC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:29:45 -0500 (EST)
Received: by mail-pf1-f171.google.com with SMTP id x65so5548594pfx.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Feb 2022 09:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fsUwRxSsX+G8xGWS1HEWow090yW+YYPFlcyEjg1XLVo=;
 b=m8OITRUF3qO3145j2yNxK1mPyFY2YT02Ur6jUYn+GKO1VRlHnMOaWUIL1sJdwvDojR
 oPEc6/htpJRKU8c7xf7vc/wn2V5Vqfmo7MwOGRi3FfJhVDi93iKYQNEc2sDs5ZZw9dCL
 qKk1P7cMBZz3TX6McC1uwcjvFdUosTNzGmXzJHiu62KBM6bTPU0SQEro9mvq0jmA5cfE
 9BHYodaXyLIa6oWQ81Q/yQzq39DQ6xivRV4aZO1F9I05hVxk78XB8o90BuTmvLE/wn7a
 5TO1oR931tzsXvUUr0AytwlFJfTGB/BKojykDfy07jLUMTPNp8PgyRJTz63JOWmSrp6I
 HnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fsUwRxSsX+G8xGWS1HEWow090yW+YYPFlcyEjg1XLVo=;
 b=3B1hUNLCIIvb8GPEi4nLAdDOYI8o/bJHhCThu7PEFCAN+9+d4hvD6CDcXg791/5Z6H
 CQByMo4Ybuuth92jXIuv+Ie9C5tr2u3aaqdeq6qMRyWnmwfqyzX1EDxYMoNoVw2tPvBJ
 +mNpS5s8VrGMhGDp0+mvNM4k7TGe95oWQKY4ms0KPh9qb+CGHCQEYQDzuGre/y9qYRI1
 1xbpz6nHW+Dox9YQliYJwZd3/XYSfLCDHKsmEBtIickiobz7U9JHck+C1QCKLK0qw+21
 SShgETMnbmPGONgA7ENkq9xYPdHD4DqaCkuQOH3Hfl2hoz2RP0yXhi0+SYDWi/Nkpx9h
 coiQ==
X-Gm-Message-State: AOAM530Yb/IEcGZfGSCHIyDW74vdUDUtpy99G8hUZuILaIzxTCvnic61
 ST1AoNsRB5dqCfnfwVqo/VSf1kZKVUbSvQ==
X-Google-Smtp-Source: ABdhPJz6zmIEKBOeOCKKdJ5NUffOHN3XDCXl133mR5D4ANHuh+PWBr7nuWITYY9fxOfb8fUgBYb/GQ==
X-Received: by 2002:a05:6a00:16d4:: with SMTP id
 l20mr5358471pfc.5.1644341384078; 
 Tue, 08 Feb 2022 09:29:44 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id y18sm11758088pgh.67.2022.02.08.09.29.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Feb 2022 09:29:43 -0800 (PST)
Date: Tue, 8 Feb 2022 09:29:39 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: vgic: Read HW interrupt pending state from
 the HW
Message-ID: <YgKogzsdCi9K4drb@google.com>
References: <20220208123726.3604198-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220208123726.3604198-1-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Feb 08, 2022 at 12:37:26PM +0000, Marc Zyngier wrote:
> It appears that a read access to GIC[DR]_I[CS]PENDRn doesn't always
> result in the pending interrupts being accurately reported if they are
> mapped to a HW interrupt. This is particularily visible when acking
> the timer interrupt and reading the GICR_ISPENDR1 register immediately
> after, for example (the interrupt appears as not-pending while it really
> is...).
> 
> This is because a HW interrupt has its 'active and pending state' kept
> in the *physical* distributor, and not in the virtual one, as mandated
> by the spec (this is what allows the direct deactivation). The virtual
> distributor only caries the pending and active *states* (note the
> plural, as these are two independent and non-overlapping states).
> 
> Fix it by reading the HW state back, either from the timer itself or
> from the distributor if necessary.
> 
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index 7068da080799..49837d3a3ef5 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -248,6 +248,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  						    IRQCHIP_STATE_PENDING,
>  						    &val);
>  			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> +		} else if (vgic_irq_is_mapped_level(irq)) {
> +			val = vgic_get_phys_line_level(irq);
>  		} else {
>  			val = irq_is_pending(irq);
>  		}
> -- 
> 2.34.1
> 

Thanks Marc!

Tested this fix with a selftest that we are planning to upstream soon.
It fires and handles arch timer IRQs while checking the pending state
along the way.

Tested-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
