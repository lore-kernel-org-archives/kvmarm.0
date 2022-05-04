Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CEDC4332F
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:33:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F7249EC3;
	Tue,  3 May 2022 23:33:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6qdxwTVeWtUA; Tue,  3 May 2022 23:33:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF1BB4A19A;
	Tue,  3 May 2022 23:33:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCBBA4A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:33:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id urbB2eVae5e0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:33:01 -0400 (EDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7240E49EC3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:33:01 -0400 (EDT)
Received: by mail-io1-f50.google.com with SMTP id c125so300626iof.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MD7nPH76Zo4gzIjG6XroEYb+307Sv2T97DW30QPZNvQ=;
 b=GCl3tUY0CxUSs2045e7bW3K3OMlsoVKLkDorqwMDkmosI+DarqkAsVZ4JutaruMtaq
 VqOHlcJ06uzrO/wmARYsqy4RSsfaqwdhzD3Op9C9DJ5u3WeNoYMrxGWQJqnxWPKqFL+m
 QRzSecp35sYjpDFlnSHnjh/mzL55frzR8ayJsgdjMS8lI8QEEt6j4UwSDAa+YE+WH32M
 rV3TlIsrbFgDRyNTLm2bHTDSK86J1SDHWbQss+MyAldJlcz7OomuzVdYQ23f3ar+122V
 j7OlhJvOkCtMEdVkoOKHFBAlv4QIa6gkZRCnrkWY8IjFhbXMImgVlCcrzHCLhXwUXHth
 NoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MD7nPH76Zo4gzIjG6XroEYb+307Sv2T97DW30QPZNvQ=;
 b=oknuAoFyZZKBgluLOok0fxy/cltn4aewE3w4BQ7jLTNeMDwoSEk6pvOj4PlcnITrfs
 kOjoOcp20pKZd5zbs9J1/IbKqYeTcnFm1A9ACRLZJSYAZyu0VeWC3Q05F/5qmuTodDjc
 22P+gSr6tSzwbK7c8sglsQjYdp7AK+sKReCjNgKyP1JrrB8iaPyzjOuos9qtK/u29UYb
 AORZnVVYetEq5NqKen6XvSrnHgbqr5k//7L6id8r2Smq744aB33CBB0m4PM5OmhCK4uO
 COwKijW+ZKVinZtsIKIgQJFdaZ4gUBy3/qg7ftjxC8ddJcYws+PD/lyGOqajFaqUvApd
 WOdQ==
X-Gm-Message-State: AOAM530VeGDEx3r0wJcnhoE0xV0W+Xfo4IIyQ3GopIo0uYIZy2iEFiIK
 0g0c0T8mQKR9qZFH0IuKL4Aafw==
X-Google-Smtp-Source: ABdhPJy7vKJ/E6XbgDQRiEIsUnMlj/99SQ3gJhSHQZ0B1pirVzABIhS85iAuFB/rJZ2xJyY7/WLvCg==
X-Received: by 2002:a6b:2b0b:0:b0:65a:4c08:7063 with SMTP id
 r11-20020a6b2b0b000000b0065a4c087063mr6885026ior.92.1651635180562; 
 Tue, 03 May 2022 20:33:00 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 v18-20020a056e0213d200b002cbed258dcfsm3913760ilj.0.2022.05.03.20.32.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 May 2022 20:32:59 -0700 (PDT)
Date: Wed, 4 May 2022 03:32:56 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Consistently populate
 ID_AA64PFR0_EL1.GIC
Message-ID: <YnHz6Cw5ONR2e+KA@google.com>
References: <20220503211424.3375263-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220503211424.3375263-1-maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel@android.com
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

On Tue, May 03, 2022 at 10:14:24PM +0100, Marc Zyngier wrote:
> When adding support for the slightly wonky Apple M1, we had to
> populate ID_AA64PFR0_EL1.GIC==1 to present something to the guest,
> as the HW itself doesn't advertise the feature.
> 
> However, we gated this on the in-kernel irqchip being created.
> This causes some trouble for QEMU, which snapshots the state of
> the registers before creating a virtual GIC, and then tries to
> restore these registers once the GIC has been created.  Obviously,
> between the two stages, ID_AA64PFR0_EL1.GIC has changed value,
> and the write fails.
> 
> The fix is to actually emulate the HW, and always populate the
> field if the HW is capable of it.
> 
> Fixes: 562e530fd770 ("KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reported-by: Peter Maydell <peter.maydell@linaro.org>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
