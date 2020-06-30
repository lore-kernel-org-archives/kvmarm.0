Return-Path: <SRS0=T474=AL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8153C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 08:36:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C058207D0
	for <kvmarm@archiver.kernel.org>; Tue, 30 Jun 2020 08:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tmid0dMc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C058207D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08ECE4B22A;
	Tue, 30 Jun 2020 04:36:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U+L+6v7POXQN; Tue, 30 Jun 2020 04:36:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4524B230;
	Tue, 30 Jun 2020 04:36:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DB3F4B228
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2020 04:36:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4-E7xb6Q9FHL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jun 2020 04:36:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DF0C4B22A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2020 04:36:25 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D1E7E206BE;
 Tue, 30 Jun 2020 08:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593506184;
 bh=qVv0jm35GqfwBo/fF/CPzQ3HSCMLWdEnYUNPHgaj5w4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Tmid0dMc6IQyRLotSKuO1ji7BOeVj3LyAfJeXTM7n9mWOBOGo/xxmSQxlyh7VRvdn
 KK5rSHoTxp4nwLMm5RGtUTj7Nm7XbL0MTZ+iZfd2o96+IQCgV+WzXdS+6NbfJTIGK8
 HiteLuALKItTrdgn1jHlxDFeWImMK+6L1M+Obqps=
Date: Tue, 30 Jun 2020 09:36:19 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Message-ID: <20200630083618.GA13574@willie-the-truck>
References: <20200629213321.2953022-1-robh@kernel.org>
 <20200629213321.2953022-2-robh@kernel.org>
 <bfe3f27495152e4888f2ab2c02dd13a4@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bfe3f27495152e4888f2ab2c02dd13a4@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Rob Herring <robh@kernel.org>, Jose.Marinho@arm.com,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

[+Jose]

On Tue, Jun 30, 2020 at 09:15:15AM +0100, Marc Zyngier wrote:
> On 2020-06-29 22:33, Rob Herring wrote:
> > On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device
> > load
> > and a store exclusive or PAR_EL1 read can cause a deadlock.
> > 
> > The workaround requires a DMB SY before and after a PAR_EL1 register
> > read
> > and the disabling of KVM. KVM must be disabled to prevent the
> > problematic
> > sequence in guests' EL1. This workaround also depends on a firmware
> > counterpart to enable the h/w to insert DMB SY after load and store
> > exclusive instructions. See the errata document SDEN-1152370 v10 [1] for
> > more information.

Jose -- having an SMC interface to see if the firmware is holding up its
side of the bargian would be really helpful here. There's been one in
development for _months_ now; any update?

> This seems a bit extreme. Given that this CPU is most likely
> used in big-little systems, there is still a bunch of CPUs
> on which we could reliably execute guests. It is also likely
> that people could run trusted guests.
> 
> I would suggest printing a big fat warning and taining the
> kernel with TAINT_CPU_OUT_OF_SPEC, together with the required
> DSBs in the KVM code.

Honestly, I think a TAINT is pointless here and we shouldn't be in the
business of trying to police what people do with their systems when there's
absolutely nothing we can do to help them. After all, they can always
disable KVM themselves if they want to. The only sensible action you can
take on seeing the taint is to disable the workaround to get rid of it,
which is also the worst thing you can do! As another example, imagine if
we had the ability to detect whether or not firmware was setting the patch
registers. If we knew that it wasn't applying the workaround, would we
TAINT on entering userspace? I don't think so. We'd probably just print a
message when trying to apply the workaround, indicating that it was
incomplete and the system may deadlock.

Finally, we have another erratum that allows guests to deadlock the system
(Cortex-A57 832075) so ultimately it's up to the person deploying the system
to decide whether or not they can tolerate the risk of deadlock. In many
cases, it won't be an issue, but if it is and they require KVM, then the
part is dead in the water and Linux can't help with that.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
