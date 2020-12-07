Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B2BC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC17D21D81
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:47:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC17D21D81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE1B4B138;
	Mon,  7 Dec 2020 12:47:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qFs5SqFqCK6R; Mon,  7 Dec 2020 12:47:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823474B150;
	Mon,  7 Dec 2020 12:47:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EF4C4B13A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:47:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9uN+O4evsUo0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 12:47:20 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F9D34B138
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:47:20 -0500 (EST)
X-Gm-Message-State: AOAM530cyoEIij5TcFC22doxw7W6OI9IY7mfh56K5mkgatvRjBlaMtTZ
 M4tj9eU53zDD9mNSuBhb24DSai84gf/G5qdF1to=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607363239;
 bh=BnXrIBpD+2Kp8vGwZxxZfz3sOyKOF+avcXarUbmMG8M=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=tdKQCkvMgDqAbgJ3o9shifdUfnWw5bzFlYvmH/98Dl3SZtuwcFReZPNa3sjj4ulPw
 2lbxzZGvn5xpQjBi/IXoS9W7lyNQYqZZT0OlM0J5uYNU2feq/JrBWHJFvZzDNBi25P
 OICsRqV+xHMr0bHWOMGwiPjHi7JnucXFa+DHHgl4eLDf0fTyLeUlLWnJlbhwGxbPde
 nPP9tYTFlIk1lhrxOKDJqGfTy9m6Qwhd0ecJnYHirbTm7nrKNcdeU1CWjehVS6GWYn
 rjXTw1I2Bo9h8cVZGhA2s0XCwOasmuOPvW32D7gyXcabTLliwVkFPBYbJd92/7XBOy
 SM2yybMITqfHA==
X-Google-Smtp-Source: ABdhPJyxJLGCa72jYV/zBDCZUmbQxSAEYe5mSF6xGBgAI8G8UhTL9uWKrdV6prKA6FmzaoXFWfK0SXhJNiWt+7zsphI=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr13607058otk.108.1607363238536; 
 Mon, 07 Dec 2020 09:47:18 -0800 (PST)
MIME-Version: 1.0
References: <20201207154341.1004276-1-maz@kernel.org>
 <CAMj1kXHb9=KPkCAwYWDFH1ddy_p3sDTZ7QemtvWV8nC_14rN+g@mail.gmail.com>
 <CAMj1kXG9mmC8wY9Gvo-oJat0bZTNk495x1Hmmi-_FXbu-gDzDw@mail.gmail.com>
 <87316821c90a13a912a624250055f50f@kernel.org>
In-Reply-To: <87316821c90a13a912a624250055f50f@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 7 Dec 2020 18:47:07 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG0DRX22SuoXC9VypKfwaUWTUJPAJ6mOZ=ra7+c9UCMXg@mail.gmail.com>
Message-ID: <CAMj1kXG0DRX22SuoXC9VypKfwaUWTUJPAJ6mOZ=ra7+c9UCMXg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Work around broken GCC handling of "S" constraint
To: Marc Zyngier <maz@kernel.org>
Cc: Android Kernel Team <kernel-team@android.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, 7 Dec 2020 at 18:41, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-12-07 17:19, Ard Biesheuvel wrote:
> > (resend with David's email address fixed)
>
> Irk. Thanks for that.
>
> >> > +#ifdef CONFIG_CC_HAS_BROKEN_S_CONSTRAINT
> >> > +#define SYM_CONSTRAINT "i"
> >> > +#else
> >> > +#define SYM_CONSTRAINT "S"
> >> > +#endif
> >> > +
> >>
> >> Could we just check GCC_VERSION here?
>
> I guess we could. But I haven't investigated which exact range of
> compiler is broken (GCC 6.3 seems fixed, but that's the oldest
> I have apart from the offending 4.9).
>

I tried 5.4 on godbolt, and it seems happy. And the failure will be
obvious, so we can afford to get it slightly wrong and refine it
later.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
