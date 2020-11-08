Return-Path: <SRS0=aa7G=EO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211DCC388F2
	for <kvmarm@archiver.kernel.org>; Sun,  8 Nov 2020 09:16:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C2C3206E3
	for <kvmarm@archiver.kernel.org>; Sun,  8 Nov 2020 09:16:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fF9uVxXH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C2C3206E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D04BA4B503;
	Sun,  8 Nov 2020 04:16:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VTZnYYN5MTDz; Sun,  8 Nov 2020 04:16:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C331B4B475;
	Sun,  8 Nov 2020 04:16:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F27B14B475
 for <kvmarm@lists.cs.columbia.edu>; Sun,  8 Nov 2020 04:16:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s0m2hRFT42Yt for <kvmarm@lists.cs.columbia.edu>;
 Sun,  8 Nov 2020 04:16:08 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25D7D4B461
 for <kvmarm@lists.cs.columbia.edu>; Sun,  8 Nov 2020 04:16:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604826967;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SS3cBUczOiZ0kxVvdSs3nbCa4DdNThWqGly4Rc/m4Ac=;
 b=fF9uVxXHnLok2txoMh62BHCnElvg1cOCbisWgTZPEheCWZKa+CqBhTtYKEcseLpktLGoRj
 IdiDPImpX/+9gjtToZ632PwiLEbIu3VU2Gg1GR+vY56JFBYXP/MetaXm6caJLpXYvL0IIy
 R97E5l8ornQOlntdpJUoAO81Y0P9Xqw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-u1Kp5G2UM22p9Lp_95GBSA-1; Sun, 08 Nov 2020 04:16:05 -0500
X-MC-Unique: u1Kp5G2UM22p9Lp_95GBSA-1
Received: by mail-wr1-f69.google.com with SMTP id e18so2749693wrs.23
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Nov 2020 01:16:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=SS3cBUczOiZ0kxVvdSs3nbCa4DdNThWqGly4Rc/m4Ac=;
 b=XGHYeqj635FP4bOMqo0R6MopChwdiCQ43e2TtyagGTiB0anZQ5+aXkDohRVbUyf8QD
 Eo1T9CJ1bY3ZRnnqVRWaQDBh6rQHDJ8Lb0g1jywpYB7QedaEYloa2Y9ehclKJ43730Sb
 i5PCWXyRseoEUk2lX8DjSS5ewZTj9I95w2boTKxGam4Y826WRXu4am31kkXaRt0hbwEz
 G7u0XUGfAbmNSq2w3Oi9P9JlfcIGkA0Pd3J17w6Zmqk1pX8k4/3hr6rRC2a8cAyfOrAL
 Gz69jnLMrmpZAdP6QZ5Y+IKM3t/KiCcWjVyzvjxg87ozMHSQINmJWipcAAZ4ZB5Q9dxf
 4wrw==
X-Gm-Message-State: AOAM533f3WXFA2/VNx//djXNuc4Ua91RIyM9O5ILllDmJvtRCA7uovUN
 9NEjSnGD7J1zxWL6UFkw+A/lTCyC348EXbV7A34yMFTateBn+Ci/1kJom0AazICCJMwNH9+2fCH
 YcyUH6NMiaytc8NErJrJgFO30
X-Received: by 2002:a1c:46c5:: with SMTP id t188mr1930925wma.68.1604826964674; 
 Sun, 08 Nov 2020 01:16:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJtVpw0lItyk5nAqwy53PgMbIuyxbDRi61GlvxwAVi7fIQ1ppjWqQ19XUasxBrInYsiNjlCA==
X-Received: by 2002:a1c:46c5:: with SMTP id t188mr1930905wma.68.1604826964432; 
 Sun, 08 Nov 2020 01:16:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id x81sm9483907wmg.5.2020.11.08.01.16.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 08 Nov 2020 01:16:03 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.10, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20201106164416.326787-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b4771aac-7ef6-06b9-0d2d-19927c787ed3@redhat.com>
Date: Sun, 8 Nov 2020 10:15:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 =?UTF-8?B?5byg5Lic5pet?= <xu910121@sina.com>,
 linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 06/11/20 17:44, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-2

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
