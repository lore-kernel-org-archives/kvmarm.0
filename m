Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF16FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 00:56:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E6E54B099;
	Mon, 22 Nov 2021 19:56:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vU+j9LlURLTc; Mon, 22 Nov 2021 19:56:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB084B0D0;
	Mon, 22 Nov 2021 19:56:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2B04B093
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 19:56:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SJDVvo-K056i for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 19:56:51 -0500 (EST)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A67F4A19A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 19:56:51 -0500 (EST)
Received: by mail-pj1-f51.google.com with SMTP id
 cq22-20020a17090af99600b001a9550a17a5so690473pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 16:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ZXvoEcLrIGAYAoxovKlZgNb0DwtzZO0ytuqE+a5WWL0=;
 b=ogIpIsg3sg06ztfxFAMnN7UHnHDsDlSDO6ts+2BlChHtSHaNZKXPTxxu5vXTx0LnCn
 YSdAsYxJTSvXNwhD/09DLEwIJVkcoh6fdk5gOmtzdVVLDo2QlPlaiIHrr5rmO0hdtEP+
 VOp0wmzqH8Av2MYELfhNJRzPloGL2gBz8KzAh8eupjuXi/XU7roRauyh5XYKxtglMPRg
 IivlxRLUJC/HgKxKQnBti03sV6oF37yQky4ofR3y+NZSU2wHRIxVE4KxhBpeXrH4mMUt
 wGhSOVhAvLvl4HM1LQS8ud/nG0b4Poir5J+WitnyeLN4urGhIUw9vwjzPFyn7p5IC/di
 vxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZXvoEcLrIGAYAoxovKlZgNb0DwtzZO0ytuqE+a5WWL0=;
 b=lK76XbnTaMf1kM0+lyI+JGDx+sgvJ2Iw99aiV/R1Rj6y2XvZs8tf8ovZ4YD0bINEP5
 TzWbkNC9Ya/CmGTcF7cy/XwXVqob0UWK9iLvrognqJFvJjxONwXMa7GcdC/+OcCuLuam
 qGfCzRNM+4gKRgM1oyKuwj3Lb8vBBZLhzpYm8TZgTvFJonKyEi8TZpQPwqXekxQxafh1
 I+QdvPXgBwo/cZElAIta6okYxkwAT3Zfo4BsraR941qmSFFP49jxi2ULgVEr6JzLE54s
 yYWdsR1m+ZMLKAp5Hs5M22YNOYSF8DrNXlirQOXJcdibkT4ynFRxj67+1Uu1JTxIyXv7
 tGkA==
X-Gm-Message-State: AOAM530JYxDy0/85GauP+QMokjzeB9kz6ZJxnouCnSXlYvriDaoK+pES
 UPPcouDrBHvzumoXtVRCfZpJ3oWfFb0gwKrGtv1MRw==
X-Google-Smtp-Source: ABdhPJxiNkaElnGL+/0qOxDZz3IwVrLy5Ntwdx8UmLE6q9RCwWPsBv7dFYR/iNcZsdp8VxNtYX3ZSl2LbBW7cQX7klU=
X-Received: by 2002:a17:90b:380d:: with SMTP id
 mq13mr1521017pjb.110.1637629010508; 
 Mon, 22 Nov 2021 16:56:50 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-4-reijiw@google.com>
 <d3fd9d6c-c96c-d7a0-b78d-af36430dbf3f@redhat.com>
 <CAAeT=FyzvGaksi+-WidHObrGYcqs4vR73ChCGpo8AFuin6UbYw@mail.gmail.com>
 <87ilwlsn0e.wl-maz@kernel.org>
In-Reply-To: <87ilwlsn0e.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 22 Nov 2021 16:56:34 -0800
Message-ID: <CAAeT=FyXc8WrSur5_c9d9Giq0=zJPQLm81g2AAAzs=4GAPe7Xw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Eric Auger <eauger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 19 Nov 2021 04:47:53 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > I am going to add the following comment. Does it look clear enough for you ?
> >
> >         /*
> >          * This is an optional ID register specific validation function.
> >          * When userspace tries to set the ID register, arm64_check_features()
> >          * will check if the requested value indicates any features that cannot
> >          * be supported by KVM on the host.  But, some ID register fields need
> >          * a special checking and this function can be used for such fields.
> >          * e.g. KVM_CREATE_DEVICE must be used to configure GICv3 for a guest.
> >          * ID_AA64PFR0_EL1.GIC shouldn't be set to 1 unless GICv3 is configured.
>
> There is no such requirement. GICv3 has a compatibility interface, and
> although KVM doesn't make use of it, there is no reason not to expose
> that GICv3 exists on the CPU even if not using it. Even more, this has
> been the case forever, and making this change now would probably break
> migration.

Shockingly, I somehow misunderstood what read_id_reg() did for GICv3...
I will use a different example for it.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
