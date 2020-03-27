Return-Path: <SRS0=88wp=5M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF186C2D0ED
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 16:59:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 553C3206E6
	for <kvmarm@archiver.kernel.org>; Fri, 27 Mar 2020 16:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0W/GFfj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 553C3206E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF2CA4A578;
	Fri, 27 Mar 2020 12:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KVmmdqZ2qnPB; Fri, 27 Mar 2020 12:59:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C52534A5A0;
	Fri, 27 Mar 2020 12:59:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABCA74A578
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 12:59:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DmhNDHsznVb1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Mar 2020 12:59:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4B5B4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2020 12:59:42 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 88AE8206E6;
 Fri, 27 Mar 2020 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585328381;
 bh=MvORsB1dXvIVi4W8/BF44aEMuNPoatu951ma4R+Bhj4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Z0W/GFfjVghNGtgiyX/lazsrRNOG8cF7ZTfPdUa9Whbcb6+vCtT+MV7NU3NJGMMPS
 YS5wzuPN1pf0X4Le2OxCBz+OVqoBQWXP4l6++a732vJdT5WJKVUKgYNt1IMmiRiJ7K
 bVYUEumFyaZ7E+SvP9FdCNdDrAwCGbghojU7ipJU=
Date: Fri, 27 Mar 2020 16:59:36 +0000
From: Will Deacon <will@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH] arm64: unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
Message-ID: <20200327165935.GA8048@willie-the-truck>
References: <20200327143941.195626-1-ascull@google.com>
 <a8cc7a17-cb84-3e52-15f4-87b27a01876b@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a8cc7a17-cb84-3e52-15f4-87b27a01876b@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: qwandor@google.com, Marc Zyngier <maz@kernel.org>, tabba@google.com,
 Steven Price <steven.price@arm.com>, wedsonaf@google.com, dbrazdil@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Hi James,

On Fri, Mar 27, 2020 at 04:11:56PM +0000, James Morse wrote:
> On 3/27/20 2:39 PM, Andrew Scull wrote:
> > Errata 1165522, 1319367 and 1530923 each allow TLB entries to be
> > allocated as a result of a speculative AT instruction. In order to
> > avoid mandating VHE on certain affected CPUs, apply the workaround to
> > both the nVHE and the VHE case for all affected CPUs.
> 
> You're booting a VHE capable system without VHE, and need KVM?
> Do tell!

I'll stick my neck out for this part...

Basically, we're looking at enabling virtualisation on Android through
KVM and we're going to be upstreaming more of this as it gets going.
One of the goals of this work is to provide an environment where virtual
machines can run in isolation from the KVM host; in such a design, the
guest memory must not be accessible to the host, so this doesn't lend
itself at all to VHE. Our current work is focussing on extending the nVHE
__hyp_text so that things like stage-2 page table and vCPU state is all
handled there, with a stage-2 put over the host kernel to prevent access
to guest memory. The host is still responsible for scheduling vCPUs, so
a compromised host can cause a DoS but it's the data integrity that we
really care about. We're looking at implementing this on top of the SPCI
spec from Arm, where the VMs are a lot less dynamic than a traditional
KVM invocation but implement message passing and shared memory interfaces
so that we can still use things like virtio. We're also aiming to support
SPCI partitions alongside traditional VMs, although the stage-2 must still
be handled at EL2 for both types of guest.

It's a bit like a Type-1.5 hypervisor ;)

Anyway, there's plenty to do, but one of the exercises is removing some of
the artificial Kconfig dependencies we have on VHE. This erratum workaround
is one of them, but there are others such as SVE and Pointer Auth.

> Would enabling the nVHE workaround on a VHE capable part solve your problem?

Could do, but it seems a bit weird to enable the workarounds independently
once both VHE and nVHE are supported. We probably need to use has_vhe() to
distinguish the two paths, rather than rely on the presence of the
workaround as a proxy for that.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
