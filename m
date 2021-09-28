Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5565FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 14:58:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B85BD61215
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 14:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B85BD61215
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F05A4B108;
	Tue, 28 Sep 2021 10:58:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lFH7y4SVkTN9; Tue, 28 Sep 2021 10:58:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3CB4A3A5;
	Tue, 28 Sep 2021 10:58:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9BCD40C88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 10:58:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VHaZO7F5SNzy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 10:58:14 -0400 (EDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9FCB4086C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 10:58:14 -0400 (EDT)
Received: by mail-wm1-f52.google.com with SMTP id j27so3754513wms.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 07:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QW/iGDRyZchN8Mm3Lgfi04v5R4JX67d3vWd6I5nvOfo=;
 b=FvlIwZje7r3p4KVXKgsdwTakffjTJxcd4A9dlfMHkXtKs7DHBGoAvR8MW+KJ9f/hw2
 6Tut5KjpHd2FMxSXkoZTVrsglrVf2C/S98s+ca3WF2S7w/Vbw6acGa2JMSDs5nchXV5A
 CLIW6COY/gSYlO4B5aNuaPAXuzOxcC3FpDwEXWm6bhC+nENuW1x2aP/+T6Y0qckbS2Q8
 H0ytpN5VGVN6urXXLIIyQ7RSljWlhjuBqld1d9qCOWzfsPALe4kQ0dT7dIvbQuIt4yBx
 d2fDN5qZ2+7fPl1KAPFf5tvR4TxyVTEqVt4UaZjSO1GeCVEzcawSYUle2SD8VJBxqW06
 uTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QW/iGDRyZchN8Mm3Lgfi04v5R4JX67d3vWd6I5nvOfo=;
 b=bSNzkQME54AVzhPozIzPuebnug9zaxehdyzyd+jq83Zsjb4jP7/hycwIwDRcRq2Zwv
 K4iKKFZMvMT53eiBeR/IqhCW64OVJeUYuOAUfjp0Y3JE1Cb68hGsslyLCU5b7EjQDbQH
 kGLpaSeBO/cscxcLntI7m0TIQissfqjWRKPybRnhGO4c03FeOgZ2DkaOortYzzD8d1tM
 zdLNjmAqI0KwEEcNp4ezQbktnEhy/V306/kvY2Q4glizIgeneTCHhpRA+Aw8D+mYyWsB
 3Z1PWb/w5UoYhx7YUWJHUWRYlvr9JhRTM/twooKgYfdFe7TeCmBKrbB5lJIkYt5bXAha
 woHg==
X-Gm-Message-State: AOAM531s2XCyPH540tDh2FLRK88cxe8nLvspuevyePr0PEbhXYPc4ji+
 jvMddhtOd/qB8G+WI/c1+TJ1Yw==
X-Google-Smtp-Source: ABdhPJyAA3f06QGMTVpZuEqToVOc8cuAiYcICGxkpGqBtD1I5r+gyQ+DGMhDjtEeRgVh9SnNFt+29w==
X-Received: by 2002:a7b:ca58:: with SMTP id m24mr1846215wml.0.1632841093668;
 Tue, 28 Sep 2021 07:58:13 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com.
 [34.76.131.216])
 by smtp.gmail.com with ESMTPSA id y18sm19438837wrq.6.2021.09.28.07.58.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 07:58:12 -0700 (PDT)
Date: Tue, 28 Sep 2021 14:58:08 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Allow KVM to be disabled from the command line
Message-ID: <YVMtgBw+qG713+4k@google.com>
References: <20210903091652.985836-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210903091652.985836-1-maz@kernel.org>
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

Hey Marc,
that all makes sense:

Reviewed-by: David Brazdil <dbrazdil@google.com>

> @@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
>  		return 0;
>  	}
>  
> -	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
> +	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
> +		kvm_mode = KVM_MODE_DEFAULT;
>  		return 0;
> +	}
> +
> +	if (strcmp(arg, "none") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
nit: I noticed we check is_kernel_in_hyp_mode here for nvhe/none but for
protected it is checked in is_kvm_protected_mode. May be worth unifying?

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
