Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4054C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 15:01:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 557E420737
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 15:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+W7cyXF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 557E420737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E30274B180;
	Thu,  2 Jul 2020 11:01:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VV0Vchgh40ws; Thu,  2 Jul 2020 11:01:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A0E84B18C;
	Thu,  2 Jul 2020 11:01:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F106F4B187
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 11:01:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LzFg8AdFM-1M for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 11:01:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDAF64B180
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 11:01:15 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7E30020737;
 Thu,  2 Jul 2020 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593702074;
 bh=4sv2dQgqyYig8KEiDtrD0QJQ9XAoBFK3b1nNESU1sM0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=p+W7cyXFKklL/6ArCuykXMxQi1DuEPPLfOMpcIeboZNg2xmBF5dm58hF6OqF/xPBG
 6Qy11miRMTKiagJtodgRrO9qtEiwdMyCaFJ2ONl3EJKQMwiDcGFIphC/SUKoF2JjpC
 4U6HJAcaHA3EzMifo8seMhLWdbOLPYcdwfuZ1GmA=
Date: Thu, 2 Jul 2020 16:01:10 +0100
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Message-ID: <20200702150109.GC16999@willie-the-truck>
References: <20200701215308.3715856-1-robh@kernel.org>
 <20200701215308.3715856-4-robh@kernel.org>
 <20200702114218.GA16499@willie-the-truck>
 <CAL_JsqJRMvmx3pOgoQ0eiaTCcDCC1fbxJDv81uAXrUWpAaF2Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_JsqJRMvmx3pOgoQ0eiaTCcDCC1fbxJDv81uAXrUWpAaF2Tg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Thu, Jul 02, 2020 at 08:56:05AM -0600, Rob Herring wrote:
> On Thu, Jul 2, 2020 at 5:42 AM Will Deacon <will@kernel.org> wrote:
> >
> > On Wed, Jul 01, 2020 at 03:53:08PM -0600, Rob Herring wrote:
> > > On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device load
> > > and a store exclusive or PAR_EL1 read can cause a deadlock.
> > >
> > > The workaround requires a DMB SY before and after a PAR_EL1 register read
> > > and the disabling of KVM. KVM must be disabled to prevent the problematic
> > > sequence in guests' EL1. This workaround also depends on a firmware
> > > counterpart to enable the h/w to insert DMB SY after load and store
> > > exclusive instructions. See the errata document SDEN-1152370 v10 [1] for
> > > more information.
> >
> > This ^^ is out of date not that we're not disabling KVM.
> 
> Indeed, I fixed the kconfig text, but missed this.
> 
> > > All the other PAR_EL1 reads besides the one in
> > > is_spurious_el1_translation_fault() are in KVM code, so the work-around is
> > > not needed for them.
> >
> > And I think this now needs some extra work.
> 
> Ugg, that was too easy...
> 
> The KVM code in __translate_far_to_hpfar() has:
> 
> read PAR
> read PAR
> write PAR
> 
> I'm wondering if we need 2 dmbs or 4 here. I'm checking on that.

Also worth checking what happens if the PAR access is executed
speculatively, as in that case we probably can't guarantee that the DMB
instructions are executed at all...

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
