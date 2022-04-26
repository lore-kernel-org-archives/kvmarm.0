Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E625FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 09:30:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4155E4B172;
	Tue, 26 Apr 2022 05:30:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0k65xEC3drgR; Tue, 26 Apr 2022 05:30:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA9264B187;
	Tue, 26 Apr 2022 05:30:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E71874B15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:30:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g4jrhq2esvAN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 05:30:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F4E14B12C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 05:30:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A103223A;
 Tue, 26 Apr 2022 02:30:22 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8125F3F73B;
 Tue, 26 Apr 2022 02:30:21 -0700 (PDT)
Date: Tue, 26 Apr 2022 10:30:18 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM/arm64: Don't emulate a PMU for 32-bit guests if
 feature not set
Message-ID: <Yme7h7xngl4l22bE@monolith.localdoman>
References: <20220425145530.723858-1-alexandru.elisei@arm.com>
 <875ymx9jbu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875ymx9jbu.wl-maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Apr 25, 2022 at 06:14:13PM +0100, Marc Zyngier wrote:
> [+ Oliver]
> 
> Hi Alex,
> 
> On Mon, 25 Apr 2022 15:55:30 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > kvm->arch.arm_pmu is set when userspace attempts to set the first PMU
> > attribute. As certain attributes are mandatory, arm_pmu ends up always
> > being set to a valid arm_pmu, otherwise KVM will refuse to run the VCPU.
> > However, this only happens if the VCPU has the PMU feature. If the VCPU
> > doesn't have the feature bit set, kvm->arch.arm_pmu will be left
> > uninitialized and equal to NULL.
> 
> Although I'm not opposed to this as an immediate workaround to avoid
> the ugly crash, I think sanitising the AArch32 regs is the way to go.

I agree. This patch is just a band-aid.

> Oliver had a stab at this a few weeks back[1], but this seem to have
> stalled.
> 
> Could you have a look and see if anything was missing (the patches
> needed some rework, but I haven't checked whether DFR0 was correctly
> handled or not).

I'll have a look.

Thanks,
Alex

> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20220401010832.3425787-1-oupton@google.com
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
