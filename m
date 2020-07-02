Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BCCC433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 14:56:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 728B720737
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 14:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xXspved8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 728B720737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5204B12D;
	Thu,  2 Jul 2020 10:56:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Oy7QuESAhYlA; Thu,  2 Jul 2020 10:56:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB0AC4B171;
	Thu,  2 Jul 2020 10:56:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 323D44B185
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 10:56:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2weoiDT8wffJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 10:56:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 274DE4B171
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 10:56:18 -0400 (EDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 108C82075D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 14:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593701777;
 bh=i0Vn5MasdXNR84TL/Sh8ZbT2NVPScluOa+ye3RR8J34=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=xXspved8Vz8cP0InqLmn9V95McTrLm6SbWuzmeUQ7C8FhTSGJZixOtOWJB1q9A4lH
 W1SY/ln9IFNdjJGGUz65Ho5iGiXgwhYrdnjqHG3K1mKWZJIoCjql1+xbaK0jpFz0/g
 uzkYAw9iJJ8xhAAsJ6PSG4c1jvDT9YIelbYgJPEk=
Received: by mail-ot1-f50.google.com with SMTP id 18so24330246otv.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2020 07:56:17 -0700 (PDT)
X-Gm-Message-State: AOAM530y0H6dCkhSxqBTTmYTm4leFAv3IEfX2cyAZ+ehLRmU3kS3YHjf
 HWadwgD5vXPckjaHwoBNcoxwYSab7D+fLIP53g==
X-Google-Smtp-Source: ABdhPJxlYIskXTLTm4h9BXm+KFrD17qplHo/3UWWDKXQmi4DJLsDi+GvjJHu8yd1p3A59SHdSwgY0mjJ6CgOx2cnotg=
X-Received: by 2002:a9d:2646:: with SMTP id a64mr25538440otb.107.1593701776454; 
 Thu, 02 Jul 2020 07:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200701215308.3715856-1-robh@kernel.org>
 <20200701215308.3715856-4-robh@kernel.org>
 <20200702114218.GA16499@willie-the-truck>
In-Reply-To: <20200702114218.GA16499@willie-the-truck>
From: Rob Herring <robh@kernel.org>
Date: Thu, 2 Jul 2020 08:56:05 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJRMvmx3pOgoQ0eiaTCcDCC1fbxJDv81uAXrUWpAaF2Tg@mail.gmail.com>
Message-ID: <CAL_JsqJRMvmx3pOgoQ0eiaTCcDCC1fbxJDv81uAXrUWpAaF2Tg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
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

On Thu, Jul 2, 2020 at 5:42 AM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Jul 01, 2020 at 03:53:08PM -0600, Rob Herring wrote:
> > On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device load
> > and a store exclusive or PAR_EL1 read can cause a deadlock.
> >
> > The workaround requires a DMB SY before and after a PAR_EL1 register read
> > and the disabling of KVM. KVM must be disabled to prevent the problematic
> > sequence in guests' EL1. This workaround also depends on a firmware
> > counterpart to enable the h/w to insert DMB SY after load and store
> > exclusive instructions. See the errata document SDEN-1152370 v10 [1] for
> > more information.
>
> This ^^ is out of date not that we're not disabling KVM.

Indeed, I fixed the kconfig text, but missed this.

> > All the other PAR_EL1 reads besides the one in
> > is_spurious_el1_translation_fault() are in KVM code, so the work-around is
> > not needed for them.
>
> And I think this now needs some extra work.

Ugg, that was too easy...

The KVM code in __translate_far_to_hpfar() has:

read PAR
read PAR
write PAR

I'm wondering if we need 2 dmbs or 4 here. I'm checking on that.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
