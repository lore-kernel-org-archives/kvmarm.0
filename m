Return-Path: <SRS0=nwVD=36=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C865C35254
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 17:37:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 010E42080C
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 17:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 010E42080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A0C4A800;
	Mon, 10 Feb 2020 12:37:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YIKVvk6j8QxU; Mon, 10 Feb 2020 12:37:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE454A7FE;
	Mon, 10 Feb 2020 12:37:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 524DA4A7FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 12:37:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TRo4tKue7Pzx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Feb 2020 12:37:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C424A50F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 12:37:53 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EF8B1FB;
 Mon, 10 Feb 2020 09:37:52 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 741C93F68F;
 Mon, 10 Feb 2020 09:37:51 -0800 (PST)
Date: Mon, 10 Feb 2020 17:37:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/2] arm64: cpufeature: add cpus_have_final_cap()
Message-ID: <20200210173744.GA20840@lakrids.cambridge.arm.com>
References: <20200210122708.38826-1-mark.rutland@arm.com>
 <20200210122708.38826-2-mark.rutland@arm.com>
 <047f1cd2-3537-6671-233c-69f1758684bf@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <047f1cd2-3537-6671-233c-69f1758684bf@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
 maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Feb 10, 2020 at 04:37:53PM +0000, Suzuki Kuruppassery Poulose wrote:
> On 10/02/2020 12:27, Mark Rutland wrote:
> > When cpus_have_const_cap() was originally introduced it was intended to
> > be safe in hyp context, where it is not safe to access the cpu_hwcaps
> > array as cpus_have_cap() did. For more details see commit:
> > 
> >    a4023f682739439b ("arm64: Add hypervisor safe helper for checking constant capabilities")
> > 
> > We then made use of cpus_have_const_cap() throughout the kernel.
> > 
> > Subsequently, we had to defer updating the static_key associated with
> > each capability in order to avoid lockdep complaints. To avoid breaking
> > kernel-wide usage of cpus_have_const_cap(), this was updated to fall
> > back to the cpu_hwcaps array if called before the static_keys were
> > updated. As the kvm hyp code was only called later than this, the
> > fallback is redundant but not functionally harmful. For more details,
> > see commit:
> > 
> >    63a1e1c95e60e798 ("arm64/cpufeature: don't use mutex in bringup path")
> > 
> > Today we have more users of cpus_have_const_cap() which are only called
> > once the relevant static keys are initialized, and it would be
> > beneficial to avoid the redundant code.
> > 
> > To that end, this patch adds a new cpus_have_final_cap(), helper which
> > is intend to be used in code which is only run once capabilities have
> > been finalized, and will never check the cpus_hwcap array. This helps
> > the compiler to generate better code as it no longer needs to generate
> > code to address and test the cpus_hwcap array. To help catch misuse,
> > cpus_have_final_cap() will BUG() if called before capabilities are
> > finalized.
> > 
> > In hyp context, BUG() will result in a hyp panic, but the specific BUG()
> > instance will not be identified in the usual way.
> > 
> > Comments are added to the various cpus_have_*_cap() helpers to describe
> > the constraints on when they can be used. For clarity cpus_have_cap() is
> > moved above the other helpers.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Suzuki Poulose <suzuki.poulose@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > ---
> 
> ...
> 
> > +/*
> > + * Test for a capability without a runtime check.
> > + *
> > + * Before capabilities are finalized, this will BUG().
> > + * After capabilities are finalized, this is patched to avoid a runtime check.
> > + *
> > + * @num must be a compile-time constant.
> > + */
> > +static __always_inline bool cpus_have_final_cap(int num)
> > +{
> > +	if (static_branch_likely(&arm64_const_caps_ready))
> 
> We have introduced system_capabilities_finalized() helper and may be
> it is a good idea to use it here, to make it more clear.

Sure thing. There are a few existing uses that could be moved over, so I
can move that up for v2.

> Either ways :
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks!

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
