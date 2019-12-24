Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3080DC2D0D2
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 12:01:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CA49F2071E
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 12:01:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA49F2071E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43A704AF4E;
	Tue, 24 Dec 2019 07:01:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ihQuZAZXQR5A; Tue, 24 Dec 2019 07:01:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DECCE4AF41;
	Tue, 24 Dec 2019 07:01:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D682E4AF28
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 07:01:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5aJigdtlcJqG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 07:01:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D4F4AF1F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 07:01:43 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A6A61FB;
 Tue, 24 Dec 2019 04:01:43 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92BDB3F534;
 Tue, 24 Dec 2019 04:01:42 -0800 (PST)
Date: Tue, 24 Dec 2019 12:01:40 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 03/18] arm64: KVM: define SPE data structure for each
 vcpu
Message-ID: <20191224120140.GH42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-4-andrew.murray@arm.com>
 <20191221131936.21fa2dfa@why>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191221131936.21fa2dfa@why>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Sat, Dec 21, 2019 at 01:19:36PM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:10 +0000
> Andrew Murray <andrew.murray@arm.com> wrote:
> 
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > 
> > In order to support virtual SPE for guest, so define some basic structs.
> > This features depends on host having hardware with SPE support.
> > 
> > Since we can support this only on ARM64, add a separate config symbol
> > for the same.
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > [ Add irq_level, rename irq to irq_num for kvm_spe ]
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/kvm/Kconfig            |  7 +++++++
> >  include/kvm/arm_spe.h             | 19 +++++++++++++++++++
> >  3 files changed, 28 insertions(+)
> >  create mode 100644 include/kvm/arm_spe.h
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index c61260cf63c5..f5dcff912645 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -35,6 +35,7 @@
> >  #include <kvm/arm_vgic.h>
> >  #include <kvm/arm_arch_timer.h>
> >  #include <kvm/arm_pmu.h>
> > +#include <kvm/arm_spe.h>
> >  
> >  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
> >  
> > @@ -302,6 +303,7 @@ struct kvm_vcpu_arch {
> >  	struct vgic_cpu vgic_cpu;
> >  	struct arch_timer_cpu timer_cpu;
> >  	struct kvm_pmu pmu;
> > +	struct kvm_spe spe;
> >  
> >  	/*
> >  	 * Anything that is not used directly from assembly code goes
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index a475c68cbfec..af5be2c57dcb 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -35,6 +35,7 @@ config KVM
> >  	select HAVE_KVM_EVENTFD
> >  	select HAVE_KVM_IRQFD
> >  	select KVM_ARM_PMU if HW_PERF_EVENTS
> > +	select KVM_ARM_SPE if (HW_PERF_EVENTS && ARM_SPE_PMU)
> >  	select HAVE_KVM_MSI
> >  	select HAVE_KVM_IRQCHIP
> >  	select HAVE_KVM_IRQ_ROUTING
> > @@ -61,6 +62,12 @@ config KVM_ARM_PMU
> >  	  Adds support for a virtual Performance Monitoring Unit (PMU) in
> >  	  virtual machines.
> >  
> > +config KVM_ARM_SPE
> > +	bool
> > +	---help---
> > +	  Adds support for a virtual Statistical Profiling Extension(SPE) in
> > +	  virtual machines.
> > +
> >  config KVM_INDIRECT_VECTORS
> >         def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
> >  
> > diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> > new file mode 100644
> > index 000000000000..48d118fdb174
> > --- /dev/null
> > +++ b/include/kvm/arm_spe.h
> > @@ -0,0 +1,19 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2019 ARM Ltd.
> > + */
> > +
> > +#ifndef __ASM_ARM_KVM_SPE_H
> > +#define __ASM_ARM_KVM_SPE_H
> > +
> > +#include <uapi/linux/kvm.h>
> > +#include <linux/kvm_host.h>
> 
> I don't believe these are required at this stage.
> 
> > +
> > +struct kvm_spe {
> > +	int irq_num;
> 
> 'irq' was the right name *if* this represents a Linux irq. If this
> instead represents a guest PPI, then it should be named 'intid'.
> 
> In either case, please document what this represents.
> 
> > +	bool ready; /* indicates that SPE KVM instance is ready for use */
> > +	bool created; /* SPE KVM instance is created, may not be ready yet */
> > +	bool irq_level;
> 
> What does this represent? The state of the interrupt on the host? The
> guest? Something else? Also, please consider grouping related fields
> together.

It should be the state of the interrupt on the guest.

> 
> > +};
> 
> If you've added a config option that controls the selection of the SPE
> feature, why doesn't this result in an empty structure when it isn't
> selected?

OK, all noted.

Andrew Murray

> 
> > +
> > +#endif /* __ASM_ARM_KVM_SPE_H */
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
