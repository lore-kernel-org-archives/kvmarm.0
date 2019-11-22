Return-Path: <SRS0=LttP=ZO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9594BC43215
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 14:16:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11B5A2071C
	for <kvmarm@archiver.kernel.org>; Fri, 22 Nov 2019 14:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ghh9HAwf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11B5A2071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A61D4AEC6;
	Fri, 22 Nov 2019 09:16:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S7MAkbMnVqNt; Fri, 22 Nov 2019 09:16:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8A24AEA4;
	Fri, 22 Nov 2019 09:16:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 622EF4AE9F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 09:16:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SwlFV+QFO33y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Nov 2019 09:16:29 -0500 (EST)
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com
 [209.85.210.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BF6C4AE89
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 09:16:29 -0500 (EST)
Received: by mail-ot1-f67.google.com with SMTP id 23so4500606otf.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Nov 2019 06:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hSDtyz6U5sp6XnbyBvxRlErxfq464IncjSnLonINQOo=;
 b=ghh9HAwfcrbjJ57AnLua6yovW2OH9d8vzL+r8uggsG5Qhy3z5DXIamPcCZ0ZbF+VWE
 dPqgPNu3g5yradl75Qvt86Be4lAh/FpECAbFRnaJvjtOtEnmTZVws25w5ehk1PI9PM5p
 n3GsyIwlYh7Y+McOPKT2EK1Rz7zzDV7pCGmvGGxiBVmzf0bARvjfAzpMpUGedeeb4Un5
 exF8ALqDzFYqbiYmT0d5HTehmMha3VYfe9bjwV4SVV+gUVmFWuAft5W8gl2R+pdTVoCz
 qGkOzQdl9s5wVq5dpMPLUHKhAd+ZTyZ1oi1q2+/Y8sgQbHcv5lQ92uquofY9IBWUynoY
 D0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hSDtyz6U5sp6XnbyBvxRlErxfq464IncjSnLonINQOo=;
 b=MNy0rfgebFIUIMr+hG2zu2a3OPr0HzHVoPi52r3gTWbOkMlYw/6xKUlobsV3RQl+oi
 9aA/HdHbFOXqOOhsd7UzaOGu8OGJLlDwGXOFO21IIdp12UjFEuMVUNsKTG3xn/VutCDM
 xOmrQ/wSx4fvbYsglgRYfRQn5w13oSeSYg5QK6Byfl9MJ+UINY9ssbPXKec9vUalxxte
 n5ZSX+RmAykACT/HO52Kx9tDr5D2WUNtaW9W9dx1EZLvjWm7Q0yEUyn3SAwD0K9w3xP7
 PH3SC227BQYq6B+r9KBPM30jOmGvh0JoRV5aOA2OCdwMucZvDnSinOgsiRAUOB+XvHPZ
 uNAw==
X-Gm-Message-State: APjAAAXnkVp1MAF+N+hWP/pKJe7sjLqbnyTe6GfkmM6SOFNdQaQGVFHH
 8926Jmj44p2D/j11SG/1fHknR2uDV0WjImN8Hs1lDg==
X-Google-Smtp-Source: APXvYqy6zwY6XaY6JDzb+P/uBIHKkFBqLazMlaiiQUPfnuu82nb8cWOMt/d6ZOiFPdTqN8Yx2kqDfuP2HUSJ4HjgCuU=
X-Received: by 2002:a9d:7f12:: with SMTP id j18mr10334795otq.221.1574432188957; 
 Fri, 22 Nov 2019 06:16:28 -0800 (PST)
MIME-Version: 1.0
References: <20191122135833.28953-1-maz@kernel.org>
In-Reply-To: <20191122135833.28953-1-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 22 Nov 2019 14:16:18 +0000
Message-ID: <CAFEAcA-aRwc9bogn-QbT-q5FzkqieYmQOZMr6H=kK5ixMGANMg@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Fix ISR_EL1 tracking when executing at EL2
To: Marc Zyngier <maz@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
 Will Deacon <will@kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 kvmarm@lists.cs.columbia.edu
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

On Fri, 22 Nov 2019 at 13:59, Marc Zyngier <maz@kernel.org> wrote:
>
> The ARMv8 ARM states when executing at EL2, EL3 or Secure EL1,
> ISR_EL1 shows the pending status of the physical IRQ, FIQ, or
> SError interrupts.
>
> Unfortunately, QEMU's implementation only considers the HCR_EL2
> bits, and ignores the current exception level. This means a hypervisor
> trying to look at its own interrupt state actually sees the guest
> state, which is unexpected and breaks KVM as of Linux 5.3.
>
> Instead, check for the running EL and return the physical bits
> if not running in a virtualized context.
>
> Fixes: 636540e9c40b
> Reported-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Congratulations on your first QEMU patch :-)

I've applied this to target-arm.next and will get it into
rc3 ("fixes running newer kernels" seems like an rc-ish
kind of bug).

RTH: vaguely wondering if this might be related to the
bug you ran into trying to test your VHE emulation
patchset...

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
