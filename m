Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4BBC433DF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:49:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20F402067B
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 08:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="IdUUOc4Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20F402067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87EEF4B0E3;
	Mon, 15 Jun 2020 04:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wf+Aw4EfJSJx; Mon, 15 Jun 2020 04:49:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E9844B0D9;
	Mon, 15 Jun 2020 04:49:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB66B4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:49:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z1s9icchIuZ5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 04:49:03 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4BDB4B093
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 04:49:03 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id r7so16212400wro.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 01:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xnddRkOdnpKmvgw1VTZ4tNEZP6mx+SwnzvEeJGa4n2I=;
 b=IdUUOc4QN2EUtr5PjBCK2Zqf0CL6mqEqyLIucODDtyyBluNXy7IPgKlGEsAn4RWzGs
 nW+xad357QPkJ4LjoK5MQHOBV/MxHoOxh4h+EMlehW3h749KHSVV+PHzbCMuh8DGiokx
 E5Sli76y1wzpiiggmJR1PCDk6ELgjg7ThLmIVxvuUDK+ZU76cOKgH/gJfp5F96Z/yLEd
 gKBPXOCkEIRjruMkus8iaygwDb7aOzrKjxqOZIIg+zYdgi/F90nRXjaaD2JBvYExE15i
 QLnl0/KSxESnJO5XZelyiSuMnO4PAbEWms4jfB7clTSzFR8IwXtO699TeR/xrKsD1TGv
 W+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xnddRkOdnpKmvgw1VTZ4tNEZP6mx+SwnzvEeJGa4n2I=;
 b=m6ZawOqUw0KuTeaaBP3nQk8N4KivxvkkxFpCjFNpyLE6PjWRE7zPla6c4p7QguXAj/
 sfyYjzX+lLDUX75KFV1aTkF8Xnamv3k/+Aj7HJ24JSsmW0rnhdXOclpsQcWUAmMCh8oq
 KCQ4SCzkdT/S7g7ehGaV7DUaIyHKOCzq8d3F96I7F/y8QNYEe4i3DIFJ00ezdL96m9xn
 uiVaN1rfeAxCyp4Hla4wKUtD7Y/8NesNecCYnWf+YliT3fxsr/yHjtICv4VvwnipJQYS
 lCL7nObtvlqcNkXYiF+O78/70QbCPMn/+YcmzKLXWtqY94WFUAVCfEUcyGDT/5TkJ7gb
 dBlQ==
X-Gm-Message-State: AOAM533ZxzJUA451RZ/+CMWYcvkiFH429UjEAVtdLC51/gsCaVU5yDR3
 ebT2mnubx7nKkEucJ3Tvssc7yA==
X-Google-Smtp-Source: ABdhPJy6wOoCwROS2ko/uRFMhnKwrDbOnQ2R/qDxpfmtGlLbagTzm9WybMrfNKEgpZoPG5/t5RdqWQ==
X-Received: by 2002:adf:f847:: with SMTP id d7mr26976924wrq.261.1592210942617; 
 Mon, 15 Jun 2020 01:49:02 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id c5sm10250109wmb.24.2020.06.15.01.49.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 15 Jun 2020 01:49:02 -0700 (PDT)
Date: Mon, 15 Jun 2020 09:48:57 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/4] KVM: arm64: Enable Pointer Authentication at EL2 if
 available
Message-ID: <20200615084857.GD177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-2-maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 15, 2020 at 09:19:51AM +0100, Marc Zyngier wrote:
> While initializing EL2, switch Pointer Authentication if detected

                                ^ nit: on?

> from EL1. We use the EL1-provided keys though.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp-init.S | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 6e6ed5581eed..81732177507d 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -104,6 +104,17 @@ alternative_else_nop_endif
>  	 */
>  	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
>  CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
> +alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
> +	b	1f
> +alternative_else_nop_endif
> +alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
> +	b	2f
> +alternative_else_nop_endif
> +1:
> +	orr	x4, x4, #(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB)
> +	orr	x4, x4, #SCTLR_ELx_ENDA
> +	orr	x4, x4, #SCTLR_ELx_ENDB

mm/proc.S builds the mask with ldr and ors it in one go, would be nice
to use the same pattern.

> +2:
>  	msr	sctlr_el2, x4
>  	isb

Acked-by: Andrew Scull <ascull@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
