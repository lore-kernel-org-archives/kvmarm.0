Return-Path: <SRS0=E5f7=XA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3A1C3A5A5
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:32:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 058C020870
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SuUO2rWq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 058C020870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FCE94A554;
	Thu,  5 Sep 2019 04:32:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mt8q5pUf5fZb; Thu,  5 Sep 2019 04:32:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A39B4A531;
	Thu,  5 Sep 2019 04:32:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC074A531
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQsLn+qBMc1u for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Sep 2019 04:32:36 -0400 (EDT)
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
 [209.85.210.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19A444A522
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:32:36 -0400 (EDT)
Received: by mail-ot1-f68.google.com with SMTP id 21so1319616otj.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Sep 2019 01:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cUJk2VTTKC0wN6jcWEhzpQ/cQIMP1HgLM9BleCNY2Mw=;
 b=SuUO2rWqXxXye2UAWa4boZ3MzkhHr1kMRk7hmUEtE/4bTQV09kjQ2Gt0bFfY7jy6Lt
 c/CjUw2y9YZz9PjKOs6ZgbSgAXpr3lfgbrZhxp8su0NVKaaOMe7fOQf9SZi2zc8BBVTM
 vjAL1pS5Xu1dHCg9bPgZfdi6mFDx1NCGTK+hXYe3E1ZoqqhGTi0uwK3Eh55yEdKRDMrB
 +j8i+7EukUgFy0S0lYE0Ohx3Lbh0CpKcUd0dpxx4Ipz7+Vswg0Yj+axiv9QclP7v7FjA
 amXguy+dq916U5xwXOBLDwDqSA0gCjgbyzNwIXY+K6fJFuk0FIByxBUQ0PKhskTuw7/p
 1rnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cUJk2VTTKC0wN6jcWEhzpQ/cQIMP1HgLM9BleCNY2Mw=;
 b=ge59fIWE8+zxonh1PgI25zdUnuQTxHsDhHZzPg9cbjEPhKPI9/6gb/MluM1qjH3+O1
 Nw7cx0Y1VmyPdkxzbfPMf9J3nkzNdyMAVb1tV5Y05scd4277kFi6+r9oSfY9axNjfcHa
 rBVp1tSgOZSdTn6Nl+dWyWADCu9r/puIMxSk1M3sw11Y+/+e9NHsycLFCaqAttcS+8rU
 okpC2mqqJRkVHJD+/4PQ/F939yb41DQKvlTrqpgkUnYv6qkBBQPlcDk2R8d9ZjgY+eUr
 bzljdvOf2g8EWa/kiPv458t7M8/bshFXiLZCQmGd7cqsK00LImT8DYRb3U4mxOI2vKJa
 rYdg==
X-Gm-Message-State: APjAAAWNlnw3u5fUVAmj8RoZFjkJG+xR6RQ2IROl/loYUcYjoff682mM
 1x4MQkhmDndXNXlgh8OYxqeHFptVR+nPLBI9NnbhJQ==
X-Google-Smtp-Source: APXvYqxC/UAKb7Op1KmsNyTq+/IpTxOo5OnutBYZc/cmcRUJsuSxQX8Ry7sggo5iBT79J9DEW/77PHzMJ2XoCR/yJsY=
X-Received: by 2002:a9d:65cb:: with SMTP id z11mr714847oth.232.1567672355504; 
 Thu, 05 Sep 2019 01:32:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
 <20190905082503.GB4320@e113682-lin.lund.arm.com>
In-Reply-To: <20190905082503.GB4320@e113682-lin.lund.arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 5 Sep 2019 09:32:23 +0100
Message-ID: <CAFEAcA-3ne3Z0dwz9C9kJmk36_AdNJRuqgB1jzFJ0WUB2NT_iQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, kvmarm@lists.cs.columbia.edu,
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

On Thu, 5 Sep 2019 at 09:25, Christoffer Dall <christoffer.dall@arm.com> wrote:
>
> On Thu, Sep 05, 2019 at 09:16:54AM +0100, Peter Maydell wrote:
> > This is true, but the problem is that barfing out to userspace
> > makes it harder to debug the guest because it means that
> > the VM is immediately destroyed, whereas AIUI if we
> > inject some kind of exception then (assuming you're set up
> > to do kernel-debug via gdbstub) you can actually examine
> > the offending guest code with a debugger because at least
> > your VM is still around to inspect...
> >
>
> Is it really going to be easier to debug a guest that sees behavior
> which may not be architecturally correct?  For example, seeing a data
> abort on an access to an MMIO region because the guest used a strange
> instruction?

Yeah, a data abort is not ideal. You could UNDEF the insn, which
probably is more likely to result in getting control in the
debugger I suppose.

As for whether it's going to be easier to debug, for the
user who reported this in the first place it certainly was.
(Consider even a simple Linux guest not under a debugger --
if we UNDEF the insn the guest kernel will print a helpful
backtrace so you can tell where the problem is; at the moment
we just print a register dump from the host kernel, which is a
lot less informative.)

> I appreaciate that the current way we handle this is confusing and has
> led many people down a rabbit hole, so we should do better.
>
> Would a better approach not be to return to userspace saying, "we can't
> handle this in the kernel, you decide", without printing the dubious
> kernel error message.

Printing the message in the kernel is the best clue we give
the user at the moment that they've run into this problem;
I would be wary of removing it (even if we decide to also
do something else).

> Then user space could suspend the VM and print a
> lenghty explanation of all the possible problems there could be, or
> re-inject something back into the guest, or whatever, for a particular
> environment.

In theory I guess so. In practice that's not what userspace
currently in the wild does, and injecting an exception from
userspace is a bit awkward (I dunno if kvmtool does it,
QEMU only needs to in really obscure circumstances and
was buggy in how it tried to do it until very recently)...

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
