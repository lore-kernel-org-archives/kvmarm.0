Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC28C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Mar 2022 18:44:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC80849673;
	Tue,  8 Mar 2022 13:44:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uuLfcy+f89xe; Tue,  8 Mar 2022 13:44:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC1349EBD;
	Tue,  8 Mar 2022 13:44:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B9D49EBD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 13:44:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GGuWGzrSFkTl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2022 13:44:27 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF95B49E39
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 13:44:27 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 47E3961593;
 Tue,  8 Mar 2022 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CE7C340EB;
 Tue,  8 Mar 2022 18:44:25 +0000 (UTC)
Date: Tue, 8 Mar 2022 18:44:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Enable Cortex-A510 erratum 2077057 by default
Message-ID: <YiekBfx2Dj8xU78/@arm.com>
References: <20220225184658.172527-1-broonie@kernel.org>
 <YiejnUtIRCu9fMtk@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YiejnUtIRCu9fMtk@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 08, 2022 at 06:42:45PM +0000, Catalin Marinas wrote:
> On Fri, Feb 25, 2022 at 06:46:58PM +0000, Mark Brown wrote:
> > The recently added configuration option for Cortex A510 erratum 2077057 does
> > not have a "default y" unlike other errata fixes. This appears to simply be
> > an oversight since the help text suggests enabling the option if unsure and
> > there's nothing in the commit log to suggest it is intentional.
> > 
> > Fixes: 1dd498e5e26ad ("KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata")
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> I don't think Will picked this up, so:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Ah, I should call it a day. I already acked this patch and Marc queued
it.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
