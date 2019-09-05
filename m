Return-Path: <SRS0=E5f7=XA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2887AC3A5A5
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:57:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A347621848
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jMQkaaRR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A347621848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F0C4A5AF;
	Thu,  5 Sep 2019 04:57:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rQ9Slj7F3847; Thu,  5 Sep 2019 04:56:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C021A4A57A;
	Thu,  5 Sep 2019 04:56:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE514A525
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:56:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v5dF5Mt6xu0Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Sep 2019 04:56:57 -0400 (EDT)
Received: from mail-oi1-f193.google.com (mail-oi1-f193.google.com
 [209.85.167.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22E944A522
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:56:57 -0400 (EDT)
Received: by mail-oi1-f193.google.com with SMTP id w144so1166363oia.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Sep 2019 01:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=IaZJ01VOJ44Z6Y9Qs3oUQiygt2Sy6fVI1ZsDthTYEac=;
 b=jMQkaaRRxSCpAfa0GGbTxN8sdW3BCz1aSdR6b+EoXx/Ue0KZCOzdiDMjAbfR7+eunv
 kx6XBxSzt7twCIJybPMD0h4eaU9yCitmULNsKZtsM1dUaTLn0IRFZwSO/spnqaAIn/WK
 smp1BnN01ssm7CCtza47yOcSEOeIXZ1ZULlSTfRZOEsNqdrJ7B42GvgGl8dAkW5Gxttk
 u9esLSmQOOsONHcK/RUZ141vgbuInB0YtTAbMwB/kfkNXGOaqNn3qNIWIPfg6k2EvkkU
 XJaDvfUoQwhTXwEmZVrsd8airEaBOdhwLNIkte996VruPPflokhLzMWXcXhvYQ73j8Px
 FatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=IaZJ01VOJ44Z6Y9Qs3oUQiygt2Sy6fVI1ZsDthTYEac=;
 b=ASLRyvyWEJ/qFh1Gp4F5Fd3cLwaR031SwY29eRLCIlKXbN4TDAVQc5wf8T7C9Jd7dM
 pTy1EjQ9lpMDlKVx5qSzjZ4cE18211vqJhEiKXRbs4c4ctQldGjIkVcqkYZRoBMPZHFL
 /kFtFpXbDCF1z5F0lYSemkICB4PcethMDxkW2QmiavSSN2oXbvKrkxDmcVKNMSQXsBF7
 UEzRFCS15jYXKVG+fuKcYKWUsI7JgIcLWT+hpXQ8kEUcPNzxLuWn7GKahgz6Cx59GRDv
 6DHGB1WKol1uQmU5V4ucHiA7SnD01cvb38WllaI8RXf6KMN7XZAGIAfJSMCxTJzH+IQv
 7gmQ==
X-Gm-Message-State: APjAAAXpVPVcaqltkxOTaRhqtnXgHcnmgBBZtzdOpeGaBln/Mef17mQ5
 cMVX+kT3BmFhDaM2nztkO0QetMWKG3awKovn/xbemA==
X-Google-Smtp-Source: APXvYqwoy7MTqB4H3mDdtS3aRDNvVJhhOoQARzpS77k98EfHG9CbyovynxJ3OmaOX9n7dO2thM4lg6LAw11dh4CzMMw=
X-Received: by 2002:aca:f54d:: with SMTP id t74mr1740404oih.170.1567673816212; 
 Thu, 05 Sep 2019 01:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
 <86mufjrup7.wl-maz@kernel.org>
In-Reply-To: <86mufjrup7.wl-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 5 Sep 2019 09:56:44 +0100
Message-ID: <CAFEAcA9qkqkOTqSVrhTpt-NkZSNXomSBNiWo_D6Kr=QKYRRf=w@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Marc Zyngier <maz@kernel.org>
Cc: =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, 5 Sep 2019 at 09:52, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 05 Sep 2019 09:16:54 +0100,
> Peter Maydell <peter.maydell@linaro.org> wrote:
> > This is true, but the problem is that barfing out to userspace
> > makes it harder to debug the guest because it means that
> > the VM is immediately destroyed, whereas AIUI if we
> > inject some kind of exception then (assuming you're set up
> > to do kernel-debug via gdbstub) you can actually examine
> > the offending guest code with a debugger because at least
> > your VM is still around to inspect...
>
> To Christoffer's point, I find the benefit a bit dubious. Yes, you get
> an exception, but the instruction that caused it may be completely
> legal (store with post-increment, for example), leading to an even
> more puzzled developer (that exception should never have been
> delivered the first place).

Right, but the combination of "host kernel prints a message
about an unsupported load/store insn" and "within-guest debug
dump/stack trace/etc" is much more useful than just having
"host kernel prints message" and "QEMU exits"; and it requires
about 3 lines of code change...

> I'm far more in favour of dumping the state of the access in the run
> structure (much like we do for a MMIO access) and let userspace do
> something about it (such as dumping information on the console or
> breaking). It could even inject an exception *if* the user has asked
> for it.

...whereas this requires agreement on a kernel-userspace API,
larger changes in the kernel, somebody to implement the userspace
side of things, and the user to update both the kernel and QEMU.
It's hard for me to see that the benefit here over the 3-line
approach really outweighs the extra effort needed. In practice
saying "we should do this" is saying "we're going to do nothing",
based on the historical record.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
