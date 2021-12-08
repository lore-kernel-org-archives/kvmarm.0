Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0A3C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:20:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 115FA4B0CC;
	Wed,  8 Dec 2021 10:20:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rhWoHY+CvnGd; Wed,  8 Dec 2021 10:20:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A821D4B15E;
	Wed,  8 Dec 2021 10:20:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0520D4B0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:20:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TD9iH0Z4OQka for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:20:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4FA4B092
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:20:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 067E411FB;
 Wed,  8 Dec 2021 07:20:37 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 466683F73B;
 Wed,  8 Dec 2021 07:20:35 -0800 (PST)
Date: Wed, 8 Dec 2021 15:20:30 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU
 attribute
Message-ID: <YbDNPrDOriI5FjfS@monolith.localdoman>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <20211206170223.309789-4-alexandru.elisei@arm.com>
 <CAAeT=Fxeu7vRHyt1P8c1YKZ2sKyUjo6W9tqXeUAGHKn=y09AEg@mail.gmail.com>
 <YbCj0IrjZoBR9dwQ@monolith.localdoman>
 <87czm718cp.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87czm718cp.wl-maz@kernel.org>
Cc: mingo@redhat.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Wed, Dec 08, 2021 at 02:25:58PM +0000, Marc Zyngier wrote:
> On Wed, 08 Dec 2021 12:23:44 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > This makes me wonder. Should KVM enforce having userspace either not
> > setting the PMU for any VCPU, either setting it for all VCPUs? I think this
> > would be a good idea and will reduce complexity in the long run. I also
> > don't see a use case for userspace choosing to set the PMU for a subset of
> > VCPUs, leaving the other VCPUs with the default behaviour.
> 
> Indeed. As much as I'm happy to expose a PMU to a guest on an
> asymmetric system, I really do not want the asymmetry in the guest
> itself. So this should be an all or nothing behaviour.

From what I can tell, the only asymmetry that can be exposed to a guest as
a result of the series is the number of events supported on a VCPU.

I don't like the idea of forcing userspace to set the *same* PMU for all
VCPUs, as that would severely limit running VMs with PMU on asymmetric
systems.

Even if KVM forces to set a PMU (does not have to be the same PMU) for all
VCPUs, that still does not look like the correct solution for me, because
userspace can set PMUs with different number of events.

What I can try is to make kvm->arch.pmuver the minimum version of all the
VCPU PMUs and the implict PMU. I'll give that a go in the next iteration.

Thanks,
Alex

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
