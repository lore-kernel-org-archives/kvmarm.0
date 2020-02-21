Return-Path: <SRS0=c+b0=4J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A790BC35646
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 13:22:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25D0224650
	for <kvmarm@archiver.kernel.org>; Fri, 21 Feb 2020 13:22:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s67nz8XO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25D0224650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8167B4AEF0;
	Fri, 21 Feb 2020 08:22:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 63KZsHhpXwvN; Fri, 21 Feb 2020 08:22:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 867BB4AED7;
	Fri, 21 Feb 2020 08:22:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C114AECA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 08:22:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8gnFqqkRTZrT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Feb 2020 08:22:49 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E0B54A97D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 08:22:49 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id k11so2041646wrd.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Feb 2020 05:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=LupOIHAKWSc8bkPWCrjlMuaWyu078T4CP+r5z8z8lJw=;
 b=s67nz8XOQsK7dOajpOx9UkoHZkuXQx1Us5oc83pDz9jdM9eoGRMebWb3SjpoJxVDfP
 VaCqM4aocUt4fbTFy76Eu/uOFO7wxKsne/xSkWCKAjtG8/eJ5+hpKxXIXUovmrCd6FfB
 fgQ/JIfIvFVKPgF74lKEEuRfxaHLjBIlRHU+/Wzh+QhlRgs9bSFummuJqHdKHmNNRrFM
 O9gOsWE31FME6zdqe3C46J3SCeVXxc3Oesmth1taui2RytoEtHcD6Lgp0XxheKp3fKNU
 Z1j+mx2ClQDmgjuuEmHjr5Bgn0QMh2Mb08paY2Knp/mi1s+yzCth0jrmgj2WYmLqmwZd
 SU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=LupOIHAKWSc8bkPWCrjlMuaWyu078T4CP+r5z8z8lJw=;
 b=KIMdHpscqZaX49xqrJg7BW2cUFU8WCmvPs/MlozM+vKvJSn7axgLt7TnVkf4zS/5xs
 kMXM2/rptat/amWR4DAxTrJYUAV8HX94yC9J9S1QpBQSVv/1IwtIqioSwDMeJrOXdVB3
 5KmCRN4afrbOb6smF9SDDYNXMxr9T+yJeRdTQ741Mk4tW6pwv32EzwT+zYKg9BpIJA3v
 k15KH+k3HLpLnF5DhQaU96DKCEmAeFM/zFBOxYtkpqQmYJZ2EFneoXTzgcguZ07+F0/F
 0YDh+GuOjaVsuzvHAPuLzFqie/r6mcl8RHLr2nMGkKdH1fd+T6gBN/D080Ptb79SZm+7
 zGwg==
X-Gm-Message-State: APjAAAWGGvXIiFAd20MU1KXgacCUj0KOnDxqwyhtVyk5uRmP5yx8LJ/+
 Jo6m0cjma0k17EKF+Y7cn9mR9yjsbHyS/nDZDC3QfQ==
X-Google-Smtp-Source: APXvYqwtx0llCvX7Lk3O5i+7ghJ0cy4o35oIbItATSsMNzzvLQiIvd1i9jgdalyYHgt2MTpujEj8MOa63okIMZZ/F+I=
X-Received: by 2002:adf:8564:: with SMTP id 91mr50038536wrh.252.1582291367956; 
 Fri, 21 Feb 2020 05:22:47 -0800 (PST)
MIME-Version: 1.0
References: <20200220165839.256881-1-james.morse@arm.com>
 <20200220165839.256881-4-james.morse@arm.com>
 <20200221131328.GA13460@willie-the-truck>
In-Reply-To: <20200221131328.GA13460@willie-the-truck>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 21 Feb 2020 14:22:36 +0100
Message-ID: <CAKv+Gu_ORoUi046thZ4D7wUCzPa9YLpGcYvm+FLBpRPTHwrgmw@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: Ask the compiler to __always_inline functions
 used by KVM at HYP
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Fri, 21 Feb 2020 at 14:13, Will Deacon <will@kernel.org> wrote:
>
> On Thu, Feb 20, 2020 at 04:58:39PM +0000, James Morse wrote:
> > KVM uses some of the static-inline helpers like icache_is_vipt() from
> > its HYP code. This assumes the function is inlined so that the code is
> > mapped to EL2. The compiler may decide not to inline these, and the
> > out-of-line version may not be in the __hyp_text section.
> >
> > Add the additional __always_ hint to these static-inlines that are used
> > by KVM.
> >
> > Signed-off-by: James Morse <james.morse@arm.com>
> > ---
> >  arch/arm64/include/asm/cache.h      | 2 +-
> >  arch/arm64/include/asm/cacheflush.h | 2 +-
> >  arch/arm64/include/asm/cpufeature.h | 8 ++++----
> >  arch/arm64/include/asm/io.h         | 4 ++--
> >  4 files changed, 8 insertions(+), 8 deletions(-)
>
> Acked-by: Will Deacon <will@kernel.org>
>
> It's the right thing to do, but if this stuff keeps trickling in then
> we should make CONFIG_OPTIMIZE_INLINING depend on !ARM64 because seeing
> "__always_inline" tells you nothing about /why/ it needs to be there and
> it's hard to know if/when you can remove those annotations in future.
>

We might need to follow the same approach as we took for the EFI stub,
and create a special __kvm_hyp symbol namespace so that we can
carefully control which routines from the kernel proper it has access
to.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
