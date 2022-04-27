Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEFFC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 07:58:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF6404B10A;
	Wed, 27 Apr 2022 03:58:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uow41CBW-4On; Wed, 27 Apr 2022 03:58:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CD924B0BA;
	Wed, 27 Apr 2022 03:58:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BD24A0FE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 03:58:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cc5TQ06VVgv5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 03:58:10 -0400 (EDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 614F849F5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 03:58:10 -0400 (EDT)
Received: by mail-lf1-f49.google.com with SMTP id w19so1672742lfu.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 00:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9PcZYugoosgvVnbdsZsc0xpKvyrWtHg79ZtXXeZRMbY=;
 b=WJtmISRCRmUGRqZ40V4ownvVDk+QVBiVcl5+tyj5WsSZG/OsqzOVlTZMlXd/ypwlDB
 YSeu2mYG+3+G+1zMSw42AxI98xIdYm7amNPjkdf5s5ttH3vUJ5JdJLww5DS9xO6IPh/h
 VEB37i8qKrAKezwBvUw3SNxevJZD2kgZsX9M79p4Tkd5etidXN27EJSnXOM20i+Jg0U8
 90rZWRbSqgqL5XpcW4cbTaY+kRYbua8cJS5kQEfFaaZWZc2nj6QVRnWajDGHMTS44EeW
 XV9I81dmnMVy7iZXE/w8oUZA/5KhY6drS85g27UbVtUJnoAN+yxXCDZREC4u2PzAmfGx
 GdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9PcZYugoosgvVnbdsZsc0xpKvyrWtHg79ZtXXeZRMbY=;
 b=B72HhK3QE4d0C0mTZ4uPLLp/9rHHM4zw8tpcDbyOUqk++wBTIqvzuyVXEbI2qIDKCq
 bbomiWBs0QXSFpFGVUAllrrPVpN0OHgrgKBjhFEe0QiDTShjGqhOSUrVbiNdiZrJE+xj
 tTXhi+C/z7i7VsQEXH0MsZhP6oM2y9KyWV0vaFpKNuFjDZQv21fIGUwtBn+G6QPRDiKI
 pelH+x2ClXMGdmRGBH5Jkk8xSd9BIRr/6o0Wr7Lk0E7kE29d7mp6bR75Npg5uBsbjLBH
 HVMUbB5UUyr2WJb1TlGst0FelE644hTx7b7DEf7risKucY5DrTB7LywW6oLaBAKSHQBf
 FE0g==
X-Gm-Message-State: AOAM533kp5VVhqb80KS2xyHL5Mob9Rt6Wd6Q56eHBXLUVz7i+Bnm/z5N
 8RPDqJbJ0VpMbSeRVZR7WKDFmJCP6voDS50fjO0VGg==
X-Google-Smtp-Source: ABdhPJz1hXVXX+ILBY0Tjus56mOuV1K/gPdovpJ3Niy+2DcRkhQqCpXhp2ln3z2sSEiPc9L6DmeMpRoF8GzoF3UXQyY=
X-Received: by 2002:a05:6512:b0e:b0:44a:a5a0:f60e with SMTP id
 w14-20020a0565120b0e00b0044aa5a0f60emr20128758lfu.669.1651046288291; Wed, 27
 Apr 2022 00:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220425145530.723858-1-alexandru.elisei@arm.com>
 <Yment8uGahyB+wgK@google.com> <Yme02Tw3WdbXBAR1@monolith.localdoman>
In-Reply-To: <Yme02Tw3WdbXBAR1@monolith.localdoman>
From: Oliver Upton <oupton@google.com>
Date: Wed, 27 Apr 2022 00:57:57 -0700
Message-ID: <CAOQ_Qsj47JkEn-sOhKCAKyZnetsKqpWvBALnfAzyMfMy=eqOHg@mail.gmail.com>
Subject: Re: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if
 feature not set
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Alex,

On Tue, Apr 26, 2022 at 2:01 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
> > > The odroid-c4 is somewhat of a special case, because Linux doesn't probe
> > > the PMU. But the above errors can easily be reproduced on any hardware,
> > > with or without a PMU driver, as long as userspace doesn't set the PMU
> > > feature.
> >
> > This note has me wondering if we could do more negative testing with
> > kvm-unit-tests just by selectively turning on/off features, with the
> > expectation that tests either skip or pass.
>
> I'm not sure that that can be accomplished right now. kvm-unit-tests
> supports only qemu as an automated test runner, and qemu enables the PMU by
> default. I don't know if it can be disabled, it would be nice if it could.
> I stumbled upon this by mistake, when I ran kvmtool without enabling the
> PMU (the default in kvmtool is to not have it enabled).
>
> If it is possible to disable PMU emulation from the qemu's command line,
> then it should be as simple as writing a test that expects all PMU register
> accesses to trigger an undefined exception (and adding a new test
> definition).

You can disable the PMU with QEMU by specifying pmu=off in the -cpu
argument, among other things.

> If it is not possible to do this with qemu, then we would have to wait
> until kvm-unit-tests can use kvmtool as the test runner. I have an RFC sent
> for that [1], I need to get back to it.
>
> Another option would be to have this as a kselftest, although I don't know
> how easy it is to register an exception handler in a kselftest. The test
> could be further expanded to other registers gated by a VCPU feature being
> set.

We definitely have the plumbing for exception handlers in selftests,
aarch64/debug-exceptions.c is an example. My thought was more general
+ rather lazy. For any combination of CPU features, expect that
kvm-unit-tests should either pass or skip. If they fail or blow up the
host then probably a good indicator of a KVM bug.

> [1] https://lore.kernel.org/kvmarm/20210702163122.96110-1-alexandru.elisei@arm.com/

Thanks for the link, I'll have a peek.

> >
> > > Work around the fact that KVM advertises a PMU even when the VCPU feature
> > > is not set by gating all PMU emulation on the feature. The guest can still
> > > access the registers without KVM injecting an undefined exception.
> >
> > We're going to need something similar even after KVM conditionally
> > advertises the PMU.
> >
> > WDYT about wiring up sys_reg_desc::visibility for the AArch32 PMU
> > registers? For now just treat them as REG_RAZ (probably extend this to
> > imply WI too) then promote to REG_HIDDEN in a later patch.
>
> I was thinking you can simply use .visibility = pmu_visibility, like it's
> done with the PMU_SYS_REG macro:

Right -- I completely agree this is where we should be when AArch32
feature registers are trapped.

Seems to me all the AArch32 feature register trap logic should come
later on as there's a nonzero chance I introduced a bug :) Shall we
stop the bleeding w/ your originally proposed patch? Doesn't seem any
more objectionable than what we're already doing.

[...]

> I've renamed AA32_ZEROHIGH -> AA32_DIRECT. Feel free to use the snippet as
> you see fit (or not at all).

To avoid shamelessly plagiarizing: may I package up what you have
below as a commit coming from you?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
