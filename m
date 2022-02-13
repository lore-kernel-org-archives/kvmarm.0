Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1409C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 13 Feb 2022 10:46:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59FF149F35;
	Sun, 13 Feb 2022 05:46:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id En-y2mxycchW; Sun, 13 Feb 2022 05:46:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A01DC49F23;
	Sun, 13 Feb 2022 05:46:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1E9E40B59
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 05:46:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kWw0TrrDPdAV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Feb 2022 05:46:02 -0500 (EST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EC0D40AEA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 05:46:02 -0500 (EST)
Received: by mail-wr1-f47.google.com with SMTP id s10so8875877wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 02:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PQcF8Y+i7eV4kkrW2kf6trBLdlKoGxKPY/8Iaq1QQj4=;
 b=ecFXnrWY3adlMoX/kiqi9gvnmpbdmuDKmYvskGDXFo65y6coRh75wuFfZ0jVKJpeTo
 Xly8qDiRP2rzciOZEsD5CXU+3bYqfg3dXJBZT29arqtSrAXd0xyhT6b1d+DyW0/w5Njc
 1qsPzNoaYLqfVSkhCj7BVQFPJ0W9U0ug6rDn/VieJSBS2vCiihQpvqZeM7Kiw0a4ldhV
 VsK/3Po+9waC/y+qqk+Hp9zRT0u7s6d/kw0iSyDkF6oNwlwOMGOVI+IMNKRiJOUgudBK
 veLvX5PS0pxfMqVbFHpbDkb/oFhI+XWf8KOXMIut1esDuAoKOcGaNEz8J+Unb4zskHzP
 l0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PQcF8Y+i7eV4kkrW2kf6trBLdlKoGxKPY/8Iaq1QQj4=;
 b=gs17DFo8kC5cmAUyHspljFI8Hh4v5VklpsMCFZWQg7VAoIzK+amkGo9ZeICsMgKiMe
 Tmb06ERgM5s3PDdfm/IXqbW+6DobVsRT6z1sQeGQE8M+0FA4WV0IQFr9uDsasUdrTD+f
 iAWMuLo2aSM1RA6Tnx9Im6OjqfMb5wDxyzxQztKVSqvkr9oECv2f+kYt9XjlDWmoC8tc
 v/y8M8LAbi6bamf9quhqfCDP22mLWOU57gviwBQV9AxgF62mS6hEUao0HrEQeG+pN86y
 ISX3dR7xFANDly7HJR3xTt6ylg+SLbk+K9PTfDidy86lHtC1enh91Gg/CzdZx3JNct4j
 D+tg==
X-Gm-Message-State: AOAM533uDCD9hQfMIf84kLNtdrImAvwj6cRtkNWvxUsoyXUI49c+k5G4
 ZB7/ONVFGiBuue4CJCexfgHPf0w76tLxjx6g83Nc9g==
X-Google-Smtp-Source: ABdhPJyNontRdkRP4Jo3hktzFuN0UpoTAZKFoEiu6aBmNtZv1VP2RcJJIIDNzITalzofGnN/carqm1dtedUo76JYQgA=
X-Received: by 2002:a5d:62c4:: with SMTP id o4mr7463092wrv.319.1644749161346; 
 Sun, 13 Feb 2022 02:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org>
 <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
 <87iltjxdz6.wl-maz@kernel.org>
In-Reply-To: <87iltjxdz6.wl-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sun, 13 Feb 2022 10:45:50 +0000
Message-ID: <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Alexander Graf <agraf@csgraf.de>, Akihiko Odaki <akihiko.odaki@gmail.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Sun, 13 Feb 2022 at 10:22, Marc Zyngier <maz@kernel.org> wrote:
>
> [+ Alex for HVF]
>
> On Sun, 13 Feb 2022 05:05:33 +0000,
> Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
> > Hi,
> > This breaks in a case where highmem is disabled but can have more than
> > 4 GiB of RAM. M1 (Apple Silicon) actually can have 36-bit PA with HVF,
> > which is not enough for highmem MMIO but is enough to contain 32 GiB
> > of RAM.
>
> Funny. The whole point of this series is to make it all work correctly
> on M1.
>
> > Where the magic number of 4 GiB / 32-bit came from?
>
> Not exactly a magic number. From QEMU's docs/system/arm/virt.rst:
>
> <quote>
> highmem
>   Set ``on``/``off`` to enable/disable placing devices and RAM in physical
>   address space above 32 bits. The default is ``on`` for machine types
>   later than ``virt-2.12``.
> </quote>
>
> TL;DR: Removing the bogus 'highmem=off' option from your command-line
> should get you going with large memory spaces, up to the IPA limit.

Yep. I've tested this with hvf, and we now correctly:
 * refuse to put RAM above 32-bits if you asked for a 32-bit
   IPA space with highmem=off
 * use the full 36-bit address space if you don't say highmem=off
   on an M1

Note that there is a macos bug where if you don't say highmem=off
on an M1 Pro then you'll get a macos kernel panic. M1 non-Pro is fine.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
