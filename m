Return-Path: <SRS0=r+CV=5K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43371C1975A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 07:47:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5A2E20409
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 07:46:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5A2E20409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DAE34A551;
	Wed, 25 Mar 2020 03:46:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C0gmqo4aSTh3; Wed, 25 Mar 2020 03:46:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B36D4A578;
	Wed, 25 Mar 2020 03:46:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEFD84A531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 03:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RvhPgecbdWht for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2020 03:46:55 -0400 (EDT)
Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com
 [209.85.208.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 651434A500
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 03:46:55 -0400 (EDT)
Received: by mail-ed1-f65.google.com with SMTP id u59so1183369edc.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 00:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=UaBcRiu0jhd+aZ3qoAfM9Jyg226NuZ7pG6QSrBAUzKE=;
 b=ThSUhNnrnlJX/GdCSY78rdYSwUU4rnnuKYDe7uSkxEUm2LdceMFJPZV6mEQ8EdlpW6
 T+KtX825uyudMmoNsbKPnab7aDa4WlZZkkb1nN/IcZZUoxZrZjxnXcwGNg6g1qdR66Mi
 g6zW9djT8gVtxuL9dKDEQxLnUEipMpYfwc6DWBTrhBdlv91zLfdyyN2qz0ONwqAvQHOM
 5W/0MvOVj9OFJCUjryS3Lo/mRTFs8X9ndtonitZjVa53la4yPieEL+fqHt3ru0dMJwgT
 ulpIAr555D/+Utns3PYF+yN3HBLgLZIU6boJ5Me6yJ6/4tK1LP+ey2YN5GAWF+GeDBGc
 WEXg==
X-Gm-Message-State: ANhLgQ2ezAlmMmTuZoqpGeilINqGOi6ygCM6kVPgy/F2erBBXmMct01J
 ArmrDZHsS5M9Pq/OS2jBjis=
X-Google-Smtp-Source: ADFU+vtMcCFFhN/9DmhxAFJzYhIdK+iRP4YL5ukwhPlffOfTndxsoNgCwnBl7CzNaMJbVvRaQUDS1w==
X-Received: by 2002:a17:906:c4f:: with SMTP id
 t15mr2040012ejf.193.1585122414316; 
 Wed, 25 Mar 2020 00:46:54 -0700 (PDT)
Received: from kozik-lap ([194.230.155.125])
 by smtp.googlemail.com with ESMTPSA id b5sm1497332edk.72.2020.03.25.00.46.51
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Wed, 25 Mar 2020 00:46:53 -0700 (PDT)
Date: Wed, 25 Mar 2020 08:46:49 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/7] arm: Unplug KVM from the build system
Message-ID: <20200325074649.GA4640@kozik-lap>
References: <20200324103350.138077-1-maz@kernel.org>
 <20200324103350.138077-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200324103350.138077-2-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Takashi Yoshi <takashi@yoshi.email>,
 Daniel Golle <daniel@makrotopia.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marek Szyprowski <m.szyprowski@samsung.com>,
 Russell King <linux@arm.linux.org.uk>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 Jan Kiszka <jan.kiszka@siemens.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
 Paolo Bonzini <pbonzini@redhat.com>
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

On Tue, Mar 24, 2020 at 10:33:44AM +0000, Marc Zyngier wrote:
> As we're about to drop KVM/arm on the floor, carefully unplug
> it from the build system.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Olof Johansson <olof@lixom.net>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Will Deacon <will@kernel.org>
> Acked-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm/Kconfig             | 2 --
>  arch/arm/Makefile            | 1 -
>  arch/arm/mach-exynos/Kconfig | 2 +-

For Exynos:
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
