Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411C3C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 20:21:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 895F223B51
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 20:21:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 895F223B51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF6384B12A;
	Wed,  9 Dec 2020 15:21:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cQbKv1EOWD3z; Wed,  9 Dec 2020 15:21:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D454B192;
	Wed,  9 Dec 2020 15:21:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0004C4B192
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 15:20:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NTVlkogKYdMh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 15:20:58 -0500 (EST)
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com
 [209.85.218.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E04B94B12A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 15:20:57 -0500 (EST)
Received: by mail-ej1-f65.google.com with SMTP id f23so4040328ejk.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 12:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=aK0O6Cw1oeADRcE2fDIkx0Ub989jlKNAvqt9X/LiIpE=;
 b=wgbAK18+9b1vK3JJF81I/Nwg4DI8tjhX6atfMMbH8BQix9hS6qZbnian2u25s8isk5
 +WXu0Wuta9uxWc4RRnfqCNGrpEABKTAFbpX8Q31uxiO6QV7WyBuvZq8lJ9K5edstFVwh
 b0etdTgVT/PX9jX+1vCTzheRAC+qTqAbX1diA0FzmWWA8Byo2IviV0riMe0ojeZlaG+W
 wAeezKaYVTIftEyHbqIfSDbtJm4MzYMUiB9xT0mT5K9G2DponrIgjRZ0YuWWFI0A9HeI
 UvEWhcQ+pzgjsEBdROyZw88jZ3iMdzOV3xh32QqzySzSRHqQX9LUOpMKKy2jefUkTkDS
 S58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aK0O6Cw1oeADRcE2fDIkx0Ub989jlKNAvqt9X/LiIpE=;
 b=eq354tzokYkEblB7SqByM03CZn3QG+IxyfJrFyzCqwIlFqLU5IYVpFElJ7uch5LiGg
 akk9eNzCF6RWRFNgKDSGKM3skj1ny/zsVZJIWA1Q/8JElvTlgsMsn+lVXjqmpBac84v7
 usqiTJ5Q3LbJo+egE5FDoXSA0ikFMNV56h09fXANuEAUiM/1Sz6CsOyYBvjm/7vRfFbJ
 n8WBtvCWY7DQu75R7+DRKn8umcTeKuJcJAnosn6LCXPc6cb6tkuYXs6hxEgldZHtD9jC
 QKCaHuYb0MlSMKGLRZN5i/ofhyoXrGGSH5eLCk9/DHamsV56ptwr45pgJEuLqXBnReCg
 K7hA==
X-Gm-Message-State: AOAM532sphAemL4LK8sq+RU6uwaktzXbJgYjI9+El0luIefSF+giZ7LI
 455buzrp0/h0IuWMHWHOKtjuxDsideOrLuvpD5WQ5A==
X-Google-Smtp-Source: ABdhPJxFXWxOGOdhpDOrfVLjnnzWmt/2E9U/6arUwQ4eTGf6ajZviI+L9zmeo+Ab8rs9gcK2GwhjI2yGPdUc0D7xUh0=
X-Received: by 2002:a17:906:1542:: with SMTP id
 c2mr3471397ejd.382.1607545256827; 
 Wed, 09 Dec 2020 12:20:56 -0800 (PST)
MIME-Version: 1.0
References: <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com>
 <0d0eb6da6a11f76d10e532c157181985@kernel.org>
 <20201207163405.GD1526@gaia> <874kkx5thq.wl-maz@kernel.org>
 <20201208172143.GB13960@gaia> <7ff14490e253878d0735633b792e1ea9@kernel.org>
 <20201209124443.GB13566@gaia> <ef14a5158fc65c00f6c3c842cfa83b2c@kernel.org>
 <20201209152741.GC13566@gaia>
 <8c39b104-39c3-7cca-82b9-2e47d7cb9a9a@linaro.org>
 <20201209183920.GI13566@gaia>
 <6b9072fb-1232-e9fb-0b97-e69709980f99@linaro.org>
In-Reply-To: <6b9072fb-1232-e9fb-0b97-e69709980f99@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 9 Dec 2020 20:20:45 +0000
Message-ID: <CAFEAcA_K47jKSp46DFK-AKWv6MD1pkrEB6FNz=HNGdxmBDCSbw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Richard Henderson <richard.henderson@linaro.org>
Cc: Juan Quintela <quintela@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Steven Price <steven.price@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Dave Martin <Dave.Martin@arm.com>
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

On Wed, 9 Dec 2020 at 20:13, Richard Henderson
<richard.henderson@linaro.org> wrote:
>
> On 12/9/20 12:39 PM, Catalin Marinas wrote:
> >> I would have thought that the best way is to use TCO, so that we don't have to
> >> have dual mappings (and however many MB of extra page tables that might imply).
> >
> > The problem appears when the VMM wants to use MTE itself (e.g. linked
> > against an MTE-aware glibc), toggling TCO is no longer generic enough,
> > especially when it comes to device emulation.
>
> But we do know exactly when we're manipulating guest memory -- we have special
> routines for that.

Well, yes and no. It's not like every access to guest memory
is through a specific set of "load from guest"/"store from guest"
functions, and in some situations there's a "get a pointer to
guest RAM, keep using it over a long-ish sequence of QEMU code,
then be done with it" pattern. It's because it's not that trivial
to isolate when something is accessing guest RAM that I don't want
to just have it be mapped PROT_MTE into QEMU. I think we'd end
up spending a lot of time hunting down "whoops, turns out this
is accessing guest RAM and sometimes it trips over the tags in
a hard-to-debug way" bugs. I'd much rather the kernel just
provided us with an API for what we want, which is (1) the guest
RAM as just RAM with no tag checking and separately (2) some
mechanism yet-to-be-designed which lets us bulk copy a page's
worth of tags for migration.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
