Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85262C32771
	for <kvmarm@archiver.kernel.org>; Wed, 17 Aug 2022 15:14:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D43054CF71;
	Wed, 17 Aug 2022 11:14:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oo3csl-E4lXJ; Wed, 17 Aug 2022 11:14:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 890654CF70;
	Wed, 17 Aug 2022 11:14:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DB7B4CF70
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 11:14:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c4vbiUdJ-FKm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2022 11:14:04 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A86384CF6A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 11:14:04 -0400 (EDT)
Date: Wed, 17 Aug 2022 10:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660749243;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=0KoI88G6WAT+dF0R8d2w0z0ihjudvGquq4fyy5BlDxA=;
 b=bC7pAGwUhbwJREU6OOPWUXVPcGn4K1p31sgeWCKmiRFXP/z/Kke3Uz9btvJQ3pdSG4NgID
 b9CDN9fVg71X61ZML1rPm7X052YgxwC5xl3hT8Ybd312An8Z/KOad3BQurFBiiO5yN7t6R
 KYe+W7X7Lquo479RaPgZUy9zGdrNlRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on
 asymmetric systems
Message-ID: <Yv0Ft0yGVr5H4NVE@google.com>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
 <87tu6bw5dd.wl-maz@kernel.org>
 <YvzIVo5H21upnaPt@monolith.localdoman>
 <87sflvw32l.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sflvw32l.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
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

On Wed, Aug 17, 2022 at 11:56:50AM +0100, Marc Zyngier wrote:
> On Wed, 17 Aug 2022 11:52:06 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > On Wed, Aug 17, 2022 at 11:07:10AM +0100, Marc Zyngier wrote:
> > > On Tue, 16 Aug 2022 20:25:52 +0100,
> > > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > > 
> > > > Small series to fix a couple issues around when 64bit-only behavior is
> > > > applied. As KVM is more restrictive than the kernel in terms of 32bit
> > > > support (no asymmetry), we really needed our own predicate when the
> > > > meaning of system_supports_32bit_el0() changed in commit 2122a833316f
> > > > ("arm64: Allow mismatched 32-bit EL0 support").
> > > > 
> > > > Lightly tested as I do not have any asymmetric systems on hand at the
> > > > moment. Attention on patch 2 would be appreciated as it affects ABI.
> > > 
> > > I don't think this significantly affect the ABI, as it is pretty
> > > unlikely that you'd have been able to execute the result, at least on
> > > VM creation (set PSTATE.M=USR, start executing, get the page fault on
> > > the first instruction... bang).
> > > 
> > > You could have tricked it in other ways, but at the end of the day
> > > you're running a broken hypervisor on an even more broken system...

Lol, fair enough. Just wanted to make sure we're all happy with how we
turn the guest into rubble on the other end :)

> > Just FYI, you can create such a system on models, by running two clusters
> > and setting clusterX.max_32bit_el=-1. Or you can have even crazier
> > configurations, where AArch32 support is present on only one cluster, and
> > only for EL0.

Doh! Forgot about the fast model.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
