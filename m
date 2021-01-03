Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35DCC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 10:16:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2596C22211
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 10:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2596C22211
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58EF44B22A;
	Mon,  4 Jan 2021 05:16:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U-wBnHSJsN3I; Mon,  4 Jan 2021 05:16:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A474B2E2;
	Mon,  4 Jan 2021 05:16:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A7FB4B259
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Jan 2021 13:39:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Vjv4h6ENTjw for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Jan 2021 13:39:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 450344B1DC
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Jan 2021 13:39:02 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F4320B1F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Jan 2021 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1609699141;
 bh=1gzdyXY4h/wwDwh9061JmyDJFt1tPnc1xrQ+kbmqN9g=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=ooQXhMGDeV+50gshBN5x10evzZwMNhiw4L7U20M3QdSpH4OV1vbD4RauOpXZ3nGDR
 Lz8LfPEcHFirnXTUtnnHluXFpaXFCMm+2ZB3Pg4k1xiT+Z2+ZlHkumVSYmjYCnbNGf
 O527+5TFGgHCgokM6GRmHMuqECr/4MIi0jO+dSRB4zBihfcJP4Y/R7edoDMn85hDkb
 6mqtQvlkDrGBMdBySgnQm1Hx8emLxzd3GBcOyPdbFJHFs+SKDdtzn/SEhszzuJZafv
 BaJ9iQX0EzrtvUA5JEkjk3fhV6Fcao/ktd6jhwF6NXQPBvvFiCBHB0NZlV1NUT7dy4
 wd1Z3LTvnR4kA==
Received: by mail-ot1-f49.google.com with SMTP id r9so24065243otk.11
 for <kvmarm@lists.cs.columbia.edu>; Sun, 03 Jan 2021 10:39:01 -0800 (PST)
X-Gm-Message-State: AOAM530b06ZukYfhkLQlhZPCgeqncTEfJNXfs/w8StHzQVG0btifui5Z
 46OirOSclcvKLqpU3grfIDcvPBwKt+3N5gxAME4=
X-Google-Smtp-Source: ABdhPJwFqfaF0KvE0DQuSO4pNB525Wq4bIJdHdLYh6etgqFgae//cMjDmYWmA6JbGIKQXNAR37XHmxWF3artosWU0rE=
X-Received: by 2002:a05:6830:1e14:: with SMTP id
 s20mr50467524otr.210.1609699140454; 
 Sun, 03 Jan 2021 10:39:00 -0800 (PST)
MIME-Version: 1.0
References: <20210103140104.3853922-1-arnd@kernel.org>
 <871rf2km2c.wl-maz@kernel.org>
In-Reply-To: <871rf2km2c.wl-maz@kernel.org>
From: Arnd Bergmann <arnd@kernel.org>
Date: Sun, 3 Jan 2021 19:38:44 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1W7O_qKO6QuddO462fzJ--x3JGpDk=YqPk7yQm16-Zcg@mail.gmail.com>
Message-ID: <CAK8P3a1W7O_qKO6QuddO462fzJ--x3JGpDk=YqPk7yQm16-Zcg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: remove incorrect __init annotation
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Mon, 04 Jan 2021 05:16:27 -0500
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Sun, Jan 3, 2021 at 5:43 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 03 Jan 2021 14:00:50 +0000,
> Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > When hyp_cpu_pm_exit() is not inlined, it causes a link time warning:
> >
> > WARNING: modpost: vmlinux.o(.text+0x39974): Section mismatch in reference from the function kvm_arch_init() to the function .init.text:hyp_cpu_pm_exit()
> > The function kvm_arch_init() references
> > the function __init hyp_cpu_pm_exit().
> > This is often because kvm_arch_init lacks a __init
> > annotation or the annotation of hyp_cpu_pm_exit is wrong.
> >
> > This is not only called at boot time, so remove the annotation
> > to prevent undefined behavior in case it gets called after being
> > freed.
>
> It *is* only called at boot time (despite these functions being called
> from module_init(), KVM cannot be built as a module on arm64).

Ah, I see where I went wrong: I looked at the callers of kvm_arch_init_vm()
instead of kvm_arch_init().

      Arnd
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
