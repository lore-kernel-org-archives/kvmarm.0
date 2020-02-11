Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42444C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:42:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C304520656
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 15:42:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NgbxyWkY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C304520656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AC244AEBB;
	Tue, 11 Feb 2020 10:42:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id REAolZXtyWTw; Tue, 11 Feb 2020 10:42:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA024AEB3;
	Tue, 11 Feb 2020 10:42:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC4E64A578
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:42:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kTIjAHqLAeqr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 10:42:49 -0500 (EST)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B64B44AEC2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 10:42:49 -0500 (EST)
Received: by mail-oi1-f193.google.com with SMTP id d62so13145624oia.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pd5As4/L2oTjSBZjWpPOMKqBaFJ2ADt2yHhVgPMSRMg=;
 b=NgbxyWkY7QLXWCbElISLSiWcF/s7LTdVaFB+VXa8xsn1F/e7JfYIPCMIKBEQCXs5nW
 iXI+lGmftjS4OwXM1uikkl0qHoPcgl0A7DSAXpDV/lrluZA6CiSTEoUq92TyQaNVgo0s
 /OufFYqsDyXdkgxkQqXIZhR/gn2hKjRt+DQG8idlZbE7kgI2SFYEcROBNbcJLk6j3cEh
 /CqMY4GMl6dhkdmQzr7kTNo1+lrBjIxHTQtCRI7+McqZKg42LNfa1nLKL34X3jNcL9La
 xvhIiQEk9HnxRhb7Fy0CjnmAop0gorfnt2hoFTSxgquVxnuLd8s9nlZHgy7p6DjSKqr4
 E0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pd5As4/L2oTjSBZjWpPOMKqBaFJ2ADt2yHhVgPMSRMg=;
 b=BSjULjjyrF+DdR7wYe08fXZRndVD9jN0EFOppYWoVIOIRRsR+kXPYIvyskjYuLQFPT
 vHJZuOcHRiF3zymrz4FGKsyeuMbVOZC62Ox/vmdWyOtm1LQuBHv1zv09SQnbYesk+taV
 gkgoZAg37L4cvzHACewkh4X4rMtDsqT7np5vOJMFLStAPqpGsxcmhx6e5F3ixz4wVKzO
 ermgnKz0/S/vh4ywuwamSPhce326uw96iq4JAQGxaeAzh9maOUwZfo1yOcEEcHxYz45Y
 kJtr0e8LzM3anWmI3AmBbj0ptAvBVfbfzwpGUOgfzcTAt1w9MWCghNgjLMSumJmr41tG
 4LMQ==
X-Gm-Message-State: APjAAAUEwc5syTkmSEHjSpxHgKkzCdN23lhj2G2kCdqMj3mYVDx9kInh
 Bd63J9QUpHz+3OR+bF2trjYRnmO+YQUSWwYPd9HJCA==
X-Google-Smtp-Source: APXvYqzbKMnFsR97qzwElnPnwovDkYV7Zzu3AUttOV+j0mhUDouh3J3SUypPbNHSVUfPQ6WO115YGcX7PLsQ24pG4y8=
X-Received: by 2002:a05:6808:289:: with SMTP id
 z9mr3174520oic.48.1581435769182; 
 Tue, 11 Feb 2020 07:42:49 -0800 (PST)
MIME-Version: 1.0
References: <20200130112510.15154-1-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 11 Feb 2020 15:42:38 +0000
Message-ID: <CAFEAcA8iBvM2xguW2_6OFWDjPPEzEorief4F2aoh0Vitp466rQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/9] KVM: arm64: PMUv3 Event Counter
 Tests
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Andre Przywara <andre.przywara@arm.com>, Andrew Murray <andrew.murray@arm.com>,
 kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger.pro@gmail.com>
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

On Thu, 30 Jan 2020 at 11:25, Eric Auger <eric.auger@redhat.com> wrote:
>
> This series implements tests exercising the PMUv3 event counters.
> It tests both the 32-bit and 64-bit versions. Overflow interrupts
> also are checked. Those tests only are written for arm64.
>
> It allowed to reveal some issues related to SW_INCR implementation
> (esp. related to 64-bit implementation), some problems related to
> 32-bit <-> 64-bit transitions and consistency of enabled states
> of odd and event counters (See [1]).
>
> Overflow interrupt testing relies of one patch from Andre
> ("arm: gic: Provide per-IRQ helper functions") to enable the
> PPI 23, coming from "arm: gic: Test SPIs and interrupt groups"
> (https://patchwork.kernel.org/cover/11234975/). Drew kindly
> provided "arm64: Provide read/write_sysreg_s".
>
> All PMU tests can be launched with:
> ./run_tests.sh -g pmu
> Tests also can be launched individually. For example:
> ./arm-run arm/pmu.flat -append 'chained-sw-incr'
>
> With KVM:
> - chain-promotion and chained-sw-incr are known to be failing.
>   [1] proposed a fix.
> - On TX2, I have some random failures due to MEM_ACCESS event
>   measured with a great disparity. This is not observed on
>   other machines I have access to.
> With TCG:
> - all new tests are skipped

I'm having a go at using this patchset to test the support
I'm adding for TCG for the v8.1 and v8.4 PMU extensions...

Q1: how can I get run_tests.sh to pass extra arguments to
QEMU ? The PMU events check will fail unless QEMU gets
the '-icount 8' to enable cycle-counting, but although
the underlying ./arm/run lets you add arbitrary extra
arguments to QEMU, run_tests.sh doesn't seem to. Trying to
pass them in via "QEMU=/path/to/qemu -icount 8" doesn't
work either.

Q2: do you know why arm/pmu.c:check_pmcr() insists that
PMCR.IMP is non-zero? The comment says "simple sanity check",
but architecturally a zero IMP field is permitted (meaning
"go look at MIDR_EL1 instead"). This causes TCG to fail this
test on '-cpu max', because in that case we set PMCR.IMP
to the same thing as MIDR_EL1.Implementer which is 0
("software use", since QEMU is software...)

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
