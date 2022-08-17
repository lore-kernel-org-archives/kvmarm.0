Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CB2C32772
	for <kvmarm@archiver.kernel.org>; Wed, 17 Aug 2022 10:51:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B94514D0BC;
	Wed, 17 Aug 2022 06:51:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cnOd8MLnEmBg; Wed, 17 Aug 2022 06:51:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8723D4D136;
	Wed, 17 Aug 2022 06:51:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F3A34D00F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 06:51:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QoI3QeCDZv2J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2022 06:51:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11F6F4D0BC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 06:51:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5241C113E;
 Wed, 17 Aug 2022 03:51:29 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FCB13F67D;
 Wed, 17 Aug 2022 03:51:26 -0700 (PDT)
Date: Wed, 17 Aug 2022 11:52:06 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on
 asymmetric systems
Message-ID: <YvzIVo5H21upnaPt@monolith.localdoman>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
 <87tu6bw5dd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87tu6bw5dd.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi,

On Wed, Aug 17, 2022 at 11:07:10AM +0100, Marc Zyngier wrote:
> On Tue, 16 Aug 2022 20:25:52 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Small series to fix a couple issues around when 64bit-only behavior is
> > applied. As KVM is more restrictive than the kernel in terms of 32bit
> > support (no asymmetry), we really needed our own predicate when the
> > meaning of system_supports_32bit_el0() changed in commit 2122a833316f
> > ("arm64: Allow mismatched 32-bit EL0 support").
> > 
> > Lightly tested as I do not have any asymmetric systems on hand at the
> > moment. Attention on patch 2 would be appreciated as it affects ABI.
> 
> I don't think this significantly affect the ABI, as it is pretty
> unlikely that you'd have been able to execute the result, at least on
> VM creation (set PSTATE.M=USR, start executing, get the page fault on
> the first instruction... bang).
> 
> You could have tricked it in other ways, but at the end of the day
> you're running a broken hypervisor on an even more broken system...

Just FYI, you can create such a system on models, by running two clusters
and setting clusterX.max_32bit_el=-1. Or you can have even crazier
configurations, where AArch32 support is present on only one cluster, and
only for EL0.

Thanks,
Alex

> 
> Anyway, I've applied this to fixes.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
