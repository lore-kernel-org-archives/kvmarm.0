Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7B1C43460
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 18:04:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 306936142F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 18:04:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 306936142F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D49074B380;
	Wed, 21 Apr 2021 14:04:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MZQC04uJVwDb; Wed, 21 Apr 2021 14:04:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3D94B4C2;
	Wed, 21 Apr 2021 14:04:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B32214B43D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 10:28:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id My7kCrmR9WYR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 10:28:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D18C94B43B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 10:28:33 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5F1E61456
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619015312;
 bh=8bQZFFWHUwobJjK+so56OmD7hgBTOgc9MoS2JZ0x8yU=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=G7MBN5Yuy342nLi2Ul34DREJ2F0a+OqXTOpQmsl2EZHdHkG0kYWtN62+ixf7CgWK5
 GBq/DOyl4Cj1hVO/6+7IWAsHnn2DQmAnE/ovHpH7mgC4tQEbr0W33OgzNWNKr6IPRV
 U0EpbHW8ZrkSxs8W24cg+PbusicY0WEGyoqaEuWPwJzzcPH7/0Gt661LSESoJnY1Zw
 HL+neLbtwNJjaqasnYlM/bx849EQscziOu+6Ad03LlG+4xBrHpVvuL+IFaSu7IT6XN
 VccB0yRt65axnsB7peoXGgpr2QR8i5+KfaZfr4wOvfrh9q8LcV2vSF9U2hGecjb7bY
 osTWvrc8p72Ww==
Received: by mail-wm1-f49.google.com with SMTP id w186so17792254wmg.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 07:28:32 -0700 (PDT)
X-Gm-Message-State: AOAM530SUBoMuShgyop0URIXADEu7yi2wavD0x6/uZ1eAYwj7CjLslxC
 rZ1QFDrcsR4Jg25CSg8rC/C7RXbC8d4MzdRvWcI=
X-Google-Smtp-Source: ABdhPJxIUQLYorkc2Y1TA/JMYa5A/I82k7QTNNMLQMbkob1EklUV0bxK+vJ5SHvdTIJNRQJxYHSe6I0FlbiIp6XQswE=
X-Received: by 2002:a05:600c:2282:: with SMTP id
 2mr10374790wmf.84.1619015311239; 
 Wed, 21 Apr 2021 07:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210421134922.3309033-1-arnd@kernel.org>
 <87y2dbpwqn.wl-maz@kernel.org>
In-Reply-To: <87y2dbpwqn.wl-maz@kernel.org>
From: Arnd Bergmann <arnd@kernel.org>
Date: Wed, 21 Apr 2021 16:28:12 +0200
X-Gmail-Original-Message-ID: <CAK8P3a26F1+9XJqHtqO5S0dwTjBhV8Z+0J1r_D69y9h84qyY7g@mail.gmail.com>
Message-ID: <CAK8P3a26F1+9XJqHtqO5S0dwTjBhV8Z+0J1r_D69y9h84qyY7g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: build perf support only when enabled
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 21 Apr 2021 14:04:15 -0400
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Wed, Apr 21, 2021 at 3:56 PM Marc Zyngier <maz@kernel.org> wrote:
> On Wed, 21 Apr 2021 14:49:01 +0100, Arnd Bergmann <arnd@kernel.org> wrote:
>
> I think a better way is to get rid of perf_num_counters() entirely,
> see [1]. If someone acks the second and last patches, I'll even take
> the whole series in (nudge nudge...).

Makes sense. I like your diffstat, too.

       Arnd
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
