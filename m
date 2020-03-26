Return-Path: <SRS0=5LXa=5L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEBDC2D0E8
	for <kvmarm@archiver.kernel.org>; Thu, 26 Mar 2020 10:17:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C03582077D
	for <kvmarm@archiver.kernel.org>; Thu, 26 Mar 2020 10:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="JliWM1wR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C03582077D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1366D4B089;
	Thu, 26 Mar 2020 06:17:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jSjjbvqFjr98; Thu, 26 Mar 2020 06:17:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B61F4B087;
	Thu, 26 Mar 2020 06:17:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 870B24A51D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2020 06:17:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2KXE-cJGn5t8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2020 06:17:53 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75CF74A3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2020 06:17:53 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id m11so1108858wrx.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2020 03:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=UfJd8ZmzjrF5pKc68uc6PImNDV9eCz7+cwylT0iK8ts=;
 b=JliWM1wRQBiU1WaxBOnbX9r9308kU10VLlDFX+c6Vs25LyF0yKjG7goxEoufVMmakc
 Mj9RKrbTLuEH9Y1EledRjVwlPdhc9hUtkacV8R/wdQwQ0J8Syb6gDlyBi/x6KSaXYfCb
 N7GvunUb7+SYEOy24EIclq9R/1WN4fab+iN6rM1ab/qlMgXCZKhdN7uyoJUbinhVchK0
 TniWliY4kjeDAqmGViGAuy3rR5oA6hINMq2QTT+1cCYQC4rURY7HiWgpWEKGEmQrkaNS
 z8+QW1f74x2aeFMaFfZL4MB2PRCxS5LUbB1w/d5JrvI/bkPvHOk3FCEyoHuWwax1WvYW
 YdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=UfJd8ZmzjrF5pKc68uc6PImNDV9eCz7+cwylT0iK8ts=;
 b=f2UzEcm0g0x3i9r8N6XTuFRlHYMltmLRdVd+oRBgeM5KYeculgsbbgZMzmYOtyKuXI
 FRk2OUYEuttcuK8b4DTkc5L3E4ccQXFWH1xYP0ygnvxId+Wtfnm7n5Ysqnemu7OYHetm
 oTV3QLuQ9T20MQukD/zHHTISc/ahpqru6hg67mjWLdgEw4PnJgnH2rDejHQDwuqM7g2/
 SFSs0poiwaVZE7oMFEqfphMmj6ed7GKIX6ryHnjRQLx40hgdVcQX1xrp6AC2KbFSi/lJ
 oPNjk2tUYJC+AeZd1Dlc2U4/fNFSmbedXN1HGyIpOzI0p3dJzgI/slq7yaqOam2y4RjW
 qDAw==
X-Gm-Message-State: ANhLgQ0S5ksn9VyBvfInzp7MsjL6ioheC0o2nWsHn8OVN9EPO4aVXW7J
 1DFw4UzjKra27MnuFhiJ8ndvXg==
X-Google-Smtp-Source: ADFU+vtYgdqu1iFA3EFU13wqSJRUhSE1RdRkdpnCijLZr09pmk1V43wx1G/9puarDu1bz5EjTdYlbQ==
X-Received: by 2002:adf:fac7:: with SMTP id a7mr8803665wrs.191.1585217872055; 
 Thu, 26 Mar 2020 03:17:52 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:d6cc:2030:37c1:9964])
 by smtp.gmail.com with ESMTPSA id g7sm2997217wrq.21.2020.03.26.03.17.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 26 Mar 2020 03:17:51 -0700 (PDT)
Date: Thu, 26 Mar 2020 10:17:48 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/7] Removing support for 32bit KVM/arm host
Message-ID: <20200326101748.GA126150@google.com>
References: <20200324103350.138077-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200324103350.138077-1-maz@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Takashi Yoshi <takashi@yoshi.email>,
 Daniel Golle <daniel@makrotopia.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marek Szyprowski <m.szyprowski@samsung.com>,
 Russell King <linux@arm.linux.org.uk>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
 Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
 Olof Johansson <olof@lixom.net>, Paolo Bonzini <pbonzini@redhat.com>
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

On Tuesday 24 Mar 2020 at 10:33:43 (+0000), Marc Zyngier wrote:
> Marc Zyngier (7):
>   arm: Unplug KVM from the build system
>   arm: Remove KVM from config files
>   arm: Remove 32bit KVM host support
>   arm: Remove HYP/Stage-2 page-table support
>   arm: Remove GICv3 vgic compatibility macros
>   arm: Remove the ability to set HYP vectors outside of the decompressor
>   MAINTAINERS: RIP KVM/arm

I've been staring at these patches for some time now and all looks good
to me. So, for the entire series:

Reviewed-by: Quentin Perret <qperret@google.com>

FWIW, as mentioned in a previous thread, I'm currently working with Will
on an extension of KVM to support guest isolation, and the arm32 port
was unfortunately making it really hard to do intrusive changes, so this
is much appreciated!

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
