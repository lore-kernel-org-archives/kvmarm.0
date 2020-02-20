Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1B8C11D04
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 13:17:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC11920722
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 13:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eP6k8puQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC11920722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E2EA4AEF0;
	Thu, 20 Feb 2020 08:17:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id trc0OtOXCeCw; Thu, 20 Feb 2020 08:17:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 402FA4AE9F;
	Thu, 20 Feb 2020 08:17:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B22D64AE96
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 08:17:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DUOI-tvhrN2z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Feb 2020 08:17:32 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C004ACF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 08:17:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1582204652;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XvMmChK6SbgG0/2Lm5qNdD29/GRoTprQuuIJ6y74DbY=;
 b=eP6k8puQytQFnBKSOcfaxV9ikvtjxjHqqsWjzNiSPw7PXC5/m2RBpC38hD8MLJnaPU8jAj
 965tUNf6G475YX7MQZh3oumHSs9WTmJZtnMeYD3SPu2yoSG9JzeRrJFEXeLhwOwq3e0VVO
 BJHE5Pw0zxZrOq9pJkxZn2qfisk3qtQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-P73ODCmnOpWhTWqRqQuffA-1; Thu, 20 Feb 2020 08:17:28 -0500
X-MC-Unique: P73ODCmnOpWhTWqRqQuffA-1
Received: by mail-wr1-f72.google.com with SMTP id w6so1717321wrm.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 05:17:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=XvMmChK6SbgG0/2Lm5qNdD29/GRoTprQuuIJ6y74DbY=;
 b=p6F45riV3oGLsbymE+tUozDGqnQqLZc1saChI/4q/TjChJ0aAM5JG+WzWM2/Ql1lYu
 Kr6Z0oMJ8fUN3dsXylIKBfQVIXXIwgzm8ZZ2v3ZyoVsfdAmyb/FXBpkCgUxd2BX0LeNm
 uT2d6/pmMXgcJMaPcVel5Hh2uiUHJmrVlwCTOit0V5bi78tJcfLH+LinhC8TFAL11bG2
 98tNbh4o8j+49Wzdve+/TAMmuR1xvMGj+8itzLPT0tTXSzh+NGOU3DQrGd7SGuoTIvJJ
 AgOL0G0pEYEhr4gEX+XfcZZNVirYAuqoDggbw1tND5+1X+hL7aeWpkGwZxO+IVsl0byE
 qCNw==
X-Gm-Message-State: APjAAAUnXo16eVVbSWggQc9fLzEk+78CxM/pJ551MXWI3F94wKvnzTtm
 h9l5B7BySp+VMtINWMhpfrrWR83FFUrhjoh1RvlOnjQ1Xzxnuf1havRA5JatNWMFJahDC2SGY3U
 NxMIPJ1V5kJ7AQ45cqrrSLpPH
X-Received: by 2002:a05:6000:1012:: with SMTP id
 a18mr41811264wrx.113.1582204647567; 
 Thu, 20 Feb 2020 05:17:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqz+bMIwb/40ta9G1MJyGw7FTeqK0evbAksgNT4fuWxaQqt0K6KuCAj18GyDem3xjd7ozBfutw==
X-Received: by 2002:a05:6000:1012:: with SMTP id
 a18mr41811244wrx.113.1582204647347; 
 Thu, 20 Feb 2020 05:17:27 -0800 (PST)
Received: from [10.201.49.12] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
 by smtp.gmail.com with ESMTPSA id x10sm4168085wrv.60.2020.02.20.05.17.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 20 Feb 2020 05:17:26 -0800 (PST)
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To: Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
References: <CGME20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3@eucas1p2.samsung.com>
 <20200210141324.21090-1-maz@kernel.org>
 <621a0a92-6432-6c3e-cb69-0b601764fa69@samsung.com>
 <43446bd5e884ae92f243799cbe748871@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <250c6908-266f-0306-9d09-5ecf8dd6b736@redhat.com>
Date: Thu, 20 Feb 2020 14:17:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <43446bd5e884ae92f243799cbe748871@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>, Krzysztof Kozlowski <krzk@kernel.org>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On 20/02/20 14:15, Marc Zyngier wrote:
>> That is a bit sad information. Mainline Exynos finally got everything
>> that was needed to run it on the quite popular Samsung Exynos5422-based
>> Odroid XU4/HC1/MC1 boards. According to the Odroid related forums it is
>> being used. We also use it internally at Samsung.
> 
> Something like "too little, too late" springs to mind, but let's be
> constructive. Is anyone using it in a production environment, where
> they rely on the latest mainline kernel having KVM support?

Depends if you consider "production environment" somebody playing at
home with a SBC.  But it's true that, these days, most of those that
support EL2 do support ARM64, even if they are used with a 32-bit userland.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
