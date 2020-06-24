Return-Path: <SRS0=cLfN=AF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C8BC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 13:16:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6535220720
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 13:16:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SNkQbmm6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6535220720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE15C4B274;
	Wed, 24 Jun 2020 09:16:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rnqEMy8l54GC; Wed, 24 Jun 2020 09:16:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C46784B23B;
	Wed, 24 Jun 2020 09:16:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E50C94B26E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 09:16:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6dA8BJ9hV9aM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2020 09:16:52 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D89514B224
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 09:16:52 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id p82so1792995oif.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 06:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hrq4bU7gW/zMadgffXP6inYxHXZqoA5vMZOPEq8EPJg=;
 b=SNkQbmm6GBRU2KhBaTQKfcfmn3IqVyo1IEsawGEMXu1m/zaaJfewRLW+JgQxzyNplo
 PMxdiHAHUJj1jcLrCJu0EMigY/jpaqGRCjn9eKfBNn9ASxC662tvzS+E+WsmVKZ3s9t6
 NrRZIGxw9m88UnZv/NKxQWD5/cTP5KjXmezEvqgj+jMn3++GyHopD3hTboMCLUQVqj5/
 UMP41AzRmIsaMtAw6crTx5unAExkCuX3t+OXDZpMJKrjD9+bLYiMdGeEtS7Xq5lDB1sS
 xprDV5SPobMBnB9pS/vy+Vaf9C1Pruluatlv2PWS/VaTGPus5vwEvqkJyBc64kFKRbIy
 QHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hrq4bU7gW/zMadgffXP6inYxHXZqoA5vMZOPEq8EPJg=;
 b=T7GHPOLrcURYhFwz2sGOvDwgdGql7jxfb2i0ZgD9RVSHBAJZYDU8iv3WRCBdm2LPcA
 oERf/7fNandBS/U0yFTTLE3BQ1HygwrG4fqjyeWqqmrH5xzzmSdEnYAM1b3BnUxCVv/q
 5Yk2qGXHM03PpTuj9rGqYJlyXw1GxAz8RvHjtRrKQYagBtKFbIEQGA2hG6iMBrajH0PK
 qE4WxeoR4kNjkcItR7gw3sHWLJ3vcCU8ZGgJNEe1Y+YZlsdkr7d9Wc++7bVAW8Ok7yDM
 QVn883B9QL6lHjAgoXw86v5oalb+/qS5267aC/dyi4lYXqpbMBeksDJj6v5l+o58XLo1
 fbKA==
X-Gm-Message-State: AOAM532UpWkIRQDOqevb8GYRKMC8JnmsytlSYF9PK/leVqP1k+p8Jd9M
 h4WQ4Yv/TeCG92SWsQUoEPn39vqo6CxFG4KwnchqvA==
X-Google-Smtp-Source: ABdhPJx8qSm/SisU7nPLHdrxBsDzhY4RaZrh+8tIbppoxAScIc3iEG1s2KuYqRjROS5f3+6X1lPiJtMoj8EFpKdT+Q4=
X-Received: by 2002:a54:4694:: with SMTP id k20mr4411799oic.146.1593004612263; 
 Wed, 24 Jun 2020 06:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200617123844.29960-1-steven.price@arm.com>
 <CAFEAcA8Myn_QEjfk4Ka604PDAUAWXs6dLUY5bEQ98C__oMsmhA@mail.gmail.com>
 <20200624093846.GA11863@gaia> <20200624103412.GD25945@arm.com>
 <faa68f22-4d8e-0290-b52a-63ae7425b988@arm.com> <20200624110904.GB11863@gaia>
 <904edac0-3de7-35a6-a9bc-b983ccd3490c@arm.com>
In-Reply-To: <904edac0-3de7-35a6-a9bc-b983ccd3490c@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 24 Jun 2020 14:16:41 +0100
Message-ID: <CAFEAcA_LOVox4z=x8nH3S4=Oyc5_5zSkdxbsvnm=jiODaBTvsw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave P Martin <Dave.Martin@arm.com>, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Wed, 24 Jun 2020 at 12:18, Steven Price <steven.price@arm.com> wrote:
> Ah yes, similar to (1) but much lower overhead ;) That's probably the
> best option - it can be hidden in a memcpy_ignoring_tags() function.
> However it still means that the VMM can't directly touch the guest's
> memory which might cause issues for the VMM.

That's kind of awkward, since in general QEMU assumes it can
naturally just access guest RAM[*] (eg emulation of DMAing devices,
virtio, graphics display, gdb stub memory accesses). It would be
nicer to be able to do it the other way around, maybe, so that the
current APIs give you the "just the memory" and if you really want
to do tagged accesses to guest ram you can do it with tag-specific
APIs. I haven't thought about this very much though and haven't
read enough of the MTE spec recently enough to make much
sensible comment. So mostly what I'm trying to encourage here
is that the people implementing the KVM/kernel side of this API
also think about the userspace side of it, so we get one coherent
design rather than a half-a-product that turns out to be awkward
to use :-)

[*] "guest ram is encrypted" also breaks this assumption, of course;
I haven't looked at the efforts in that direction that are already in
QEMU to see how they work, though.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
