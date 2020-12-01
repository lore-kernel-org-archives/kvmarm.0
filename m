Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77230C64E7A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 14:57:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 893A32076C
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 14:57:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 893A32076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC2794C246;
	Tue,  1 Dec 2020 09:57:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0HLceEdMZYli; Tue,  1 Dec 2020 09:57:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7FE4C24C;
	Tue,  1 Dec 2020 09:57:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3384C246
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 09:57:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gFDGS6KJI4UB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 09:57:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085B24C245
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 09:57:32 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72E9C30E;
 Tue,  1 Dec 2020 06:57:32 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.30.155])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 073823F575;
 Tue,  1 Dec 2020 06:57:23 -0800 (PST)
Date: Tue, 1 Dec 2020 14:57:20 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 20/23] kvm: arm64: Intercept host's CPU_SUSPEND PSCI
 SMCs
Message-ID: <20201201145720.GB86881@C02TD0UTHF1T.local>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-21-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201126155421.14901-21-dbrazdil@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
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

On Thu, Nov 26, 2020 at 03:54:18PM +0000, David Brazdil wrote:
> Add a handler of CPU_SUSPEND host PSCI SMCs. The SMC can either enter
> a sleep state indistinguishable from a WFI or a deeper sleep state that
> behaves like a CPU_OFF+CPU_ON except that the core is still considered
> online when asleep.
> 
> The handler saves r0,pc of the host and makes the same call to EL3 with
> the hyp CPU entry point. It either returns back to the handler and then
> back to the host, or wakes up into the entry point and initializes EL2
> state before dropping back to EL1.

For those CPU_SUSPEND calls which lose context, is there no EL2 state
that you need to save/restore, or is that all saved elsewhere already?

The usual suspects are PMU, debug, and timers, so maybe not. It'd be
nice to have a statement in the commit message if we're certain there's
no state that we need to save.

> A core can only suspend itself but other cores can concurrently invoke
> CPU_ON with this core as target. To avoid racing them for the same
> boot args struct, CPU_SUSPEND uses a different struct instance and entry
> point. Each entry point selects the corresponding struct to restore host
> boot args from. This avoids the need for locking in CPU_SUSPEND.

I found this a bit confusing since the first sentence can be read to
mean that CPU_ON is expected to compose with CPU_SUSPEND, whereas what
this is actually saying is the implementation ensures they don't
interact. How about:

| CPU_ON and CPU_SUSPEND are both implemented using struct cpu_boot_args
| to store the state upon powerup, with each CPU having separate structs
| for CPU_ON and CPU_SUSPEND so that CPU_SUSPEND can operate locklessly
| and so that a CPU_ON xall targetting a CPU cannot interfere with a
| concurrent CPU_SUSPEND call on that CPU.

The patch itself looks fine to me.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
