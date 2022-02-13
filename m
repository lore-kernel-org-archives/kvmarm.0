Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B873C433F5
	for <kvmarm@archiver.kernel.org>; Sun, 13 Feb 2022 12:57:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B21D74291D;
	Sun, 13 Feb 2022 07:57:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PM-WMgPhmTzj; Sun, 13 Feb 2022 07:57:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E967411C7;
	Sun, 13 Feb 2022 07:57:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7415D411C7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 07:57:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0TRtPt1NXiYx for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Feb 2022 07:57:22 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55131411BD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 07:57:22 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id q7so22625069wrc.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 04:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2c0SI7m7ZB+m4RaXReFLA6+iDUdiDg4G2NOqfn4wgmQ=;
 b=aIWlNEwWaI2UJKNAmkRKc6aBrQm3cGtJHiz2aA0Z7odhnA3B1av2838F3V38ouojFQ
 rQJIUHmH7pK3pIlfJvyojEXJ/jrxYmrHkcXH9+jHkcspcl8lzYfAjGhisTB91qaFWZ1W
 2BwwhmEX4y9/G17HyrYXTsfnFrYzQ1J6IZAyF2541fRZOA9GOZ0fP0FRfSDDIae9Bklr
 yXZadDm4hD8lk3qwt2ny3UlFloyTzA5v1upVlSIMM2Hl9jvykTVNK31f6Nh473mTdALw
 bVLtsY5lBiBenxv4FUbogTTfxRPiTSKH1Kmx0i8KUAHWT51UFIXTHJ6GjoLWC/WgDprv
 /C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2c0SI7m7ZB+m4RaXReFLA6+iDUdiDg4G2NOqfn4wgmQ=;
 b=K6dmw3Z0WNfeJtvIMTjkq4YOj+6if6SVj6Xm7g6H21FZroF0rSF1KUh2o6BBeq1/4k
 YQZJcKV0RbGZ/9LItqoBX1wjixIkrXrpZhCDdniVaazXw+48MchDgYzixeJcgRpbmyUC
 05dQkRw+fHnpQxh4V0cvIZlhJQqq0hgYvdZ4wbmmjEBDsrQIoA8qRUSlXWhWYWeFhA+R
 axs+7EQh9U2/956gwcBED09FeZmKkkZXt04JxxvRdquAGd8pmG0Ma6vcvoHuYa+J4ZZn
 4W1lk/3qhC7ADKu8fVUctJS/OI0XWHBUZ5oOITi4ZxFNHb6hrtKHy3lMagM0ByCVxF8u
 oUXQ==
X-Gm-Message-State: AOAM533BPNHaZvTsjfvOQ36KyQY18qpzlmwQqNsjSAsTnMeXVG4g+M5Y
 2B8Y4de+xa9LXRKK9dc4iugZdXwZ331m5Dmhoy/O2g==
X-Google-Smtp-Source: ABdhPJyhWkmqOt5Qv5V8sVaUI/z6NPBi3j81Oxw8fxbdgicbVi/hBwNisw0rORYtSXJDU+bZsM9nUw4+Wq9rLZHPZF4=
X-Received: by 2002:a5d:62c4:: with SMTP id o4mr7776005wrv.319.1644757041279; 
 Sun, 13 Feb 2022 04:57:21 -0800 (PST)
MIME-Version: 1.0
References: <20220120123630.267975-1-peter.maydell@linaro.org>
 <20220120123630.267975-19-peter.maydell@linaro.org>
 <3f4f5e98-fcb8-bf4d-e464-6ad365af92f8@gmail.com>
 <87iltjxdz6.wl-maz@kernel.org>
 <CAFEAcA9yR4=PNCGJk6iMEq0EHejwwt-gQJfvByEk-EN6ER5o_g@mail.gmail.com>
 <CAMVc7JWUm7v6gt48TP+ugzEeHwo6FA66TeE3h3fqyHmHsShoig@mail.gmail.com>
In-Reply-To: <CAMVc7JWUm7v6gt48TP+ugzEeHwo6FA66TeE3h3fqyHmHsShoig@mail.gmail.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sun, 13 Feb 2022 12:57:10 +0000
Message-ID: <CAFEAcA817oN+UNJC=o-GTAXo0UypgsTkm7MvcLKDSR-9amkPXA@mail.gmail.com>
Subject: Re: [PULL 18/38] hw/arm/virt: Honor highmem setting when computing
 the memory map
To: Akihiko Odaki <akihiko.odaki@gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 qemu Developers <qemu-devel@nongnu.org>, Alexander Graf <agraf@csgraf.de>,
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

On Sun, 13 Feb 2022 at 11:38, Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
> I found that it actually gets the available PA bit of the emulated CPU
> when highmem=on. I used "cortex-a72", which can have more than 36
> bits. I just simply switched to "host"; hvf didn't support "host" when
> I set up my VM but now it does.

It's a bug that we accept 'cortex-a72' there. What should happen
is something like:
 * we want to use the ID register values of a cortex-a72
 * QEMU's hvf layer should say "no, that doesn't match the actual
   CPU we're running on", and give an error

This works correctly with KVM because there the kernel refuses
attempts to set ID registers to values that don't match the host;
for hvf the hvf APIs do permit lying to the guest about ID register
values so we need to do the check ourselves.

(The other approach would be to check the ID register values
and allow them to the extent that the host CPU actually has
the support for the features they imply, so you could "downgrade"
to a less capable CPU but not tell the guest it has feature X
if it isn't really there. But this is (a) a lot more complicated
and (b) gets into the swamp of trying to figure out how to tell
the guest about CPU errata -- the guest needs to apply errata
workarounds for the real host CPU, not for whatever the emulated
CPU is. So "just reject anything that's not an exact match" is
the easy approach.)

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
