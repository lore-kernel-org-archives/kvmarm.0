Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3BBC2D0A3
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 12:45:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 888A120825
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 12:45:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TD73lpCo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 888A120825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9874B572;
	Thu, 29 Oct 2020 08:45:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ii9jCbuAH8f0; Thu, 29 Oct 2020 08:45:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 867894B57A;
	Thu, 29 Oct 2020 08:45:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA82D4B575
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 08:45:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w79j5yn00WSM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 08:45:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB8384B572
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 08:45:00 -0400 (EDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 59ABE2087E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 12:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603975499;
 bh=hsmiMxUX/p4MLLVGzNav0wYmSgQt4GZthudLcbTfCUY=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=TD73lpCo2G6LIiPUR4Ut/06KWTf0UlaetCtoUKoIGwQx/SHzjpQ0xqiymEjgNpsIT
 /kLrGwbGzqN0jsf/NguMpOtWPhJngjObtwdDntnTd+SaQnuaFEeQuX9zWCOI8ZoNge
 oZdVAIlbEnYTAemnOa5m5jo2DbJEflqkGgfMwOko=
Received: by mail-oi1-f170.google.com with SMTP id k27so3002864oij.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 05:44:59 -0700 (PDT)
X-Gm-Message-State: AOAM5304g8FpXOtysVQoPLBS3F9O+WyjM3qBiiM+NFcvrxgYdcfvyz8q
 7tsnnMlVja/QM72cNv5HTxDUvnL5ybWA+/XT2g==
X-Google-Smtp-Source: ABdhPJxX7xWW461B67C8oFKN5BLZ9B4qRQ7bNYT4AElqN6A1Q7thb8mQfUH8+ipKCj7SdfzExxkg1/ppoiEHziLTA8c=
X-Received: by 2002:a54:4588:: with SMTP id z8mr2883613oib.147.1603975498568; 
 Thu, 29 Oct 2020 05:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201028182839.166037-1-robh@kernel.org>
 <20201028182839.166037-2-robh@kernel.org>
 <20201029100450.GA10776@gaia>
In-Reply-To: <20201029100450.GA10776@gaia>
From: Rob Herring <robh@kernel.org>
Date: Thu, 29 Oct 2020 07:44:47 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+wC-cu6xAGEAxH7JwcuBXb207BH7vrQzkLG=gpgUdZMw@mail.gmail.com>
Message-ID: <CAL_Jsq+wC-cu6xAGEAxH7JwcuBXb207BH7vrQzkLG=gpgUdZMw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, Oct 29, 2020 at 5:04 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Wed, Oct 28, 2020 at 01:28:39PM -0500, Rob Herring wrote:
> > On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device load
> > and a store exclusive or PAR_EL1 read can cause a deadlock.
> >
> > The workaround requires a DMB SY before and after a PAR_EL1 register
> > read. In addition, it's possible an interrupt (doing a device read) or
> > KVM guest exit could be taken between the DMB and PAR read, so we
> > also need a DMB before returning from interrupt and before returning to
> > a guest.
> >
> > A deadlock is still possible with the workaround as KVM guests must also
> > have the workaround. IOW, a malicious guest can deadlock an affected
> > systems.
> >
> > This workaround also depends on a firmware counterpart to enable the h/w
> > to insert DMB SY after load and store exclusive instructions. See the
> > errata document SDEN-1152370 v10 [1] for more information.
> >
> > [1] https://static.docs.arm.com/101992/0010/Arm_Cortex_A77_MP074_Software_Developer_Errata_Notice_v10.pdf
> >
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> > Cc: kvmarm@lists.cs.columbia.edu
> > Acked-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Rob Herring <robh@kernel.org>
>
> I thought I reviewed the v6 already and that's just a rebase. Here it is
> again:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

You did. Sorry, I forgot to add it.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
