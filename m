Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF70C3F68F
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 12:36:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 006542073B
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 12:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 006542073B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 823DA4AF66;
	Tue, 24 Dec 2019 07:36:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BFgSEEeQ6pgu; Tue, 24 Dec 2019 07:36:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D2294AF52;
	Tue, 24 Dec 2019 07:36:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03CAE4AF4A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 07:35:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jk8tXhG8ug3c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 07:35:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C01254AF45
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 07:35:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C6A51FB;
 Tue, 24 Dec 2019 04:35:57 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7BE13F534;
 Tue, 24 Dec 2019 04:35:56 -0800 (PST)
Date: Tue, 24 Dec 2019 12:35:55 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 13/18] perf: arm_spe: Add KVM structure for obtaining
 IRQ info
Message-ID: <20191224123554.GK42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-14-andrew.murray@arm.com>
 <868sn4iowy.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <868sn4iowy.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Sun, Dec 22, 2019 at 11:24:13AM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:20 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > KVM requires knowledge of the physical SPE IRQ number such that it can
> > associate it with any virtual IRQ for guests that require SPE emulation.
> 
> This is at best extremely odd. The only reason for KVM to obtain this
> IRQ number is if it has exclusive access to the device.  This
> obviously isn't the case, as this device is shared between host and
> guest.

This was an attempt to set the interrupt as active such that host SPE driver
doesn't get spurious interrupts due to guest SPE activity. Though let's save
the discussion to patch 14.


> 
> > Let's create a structure to hold this information and an accessor that
> > KVM can use to retrieve this information.
> > 
> > We expect that each SPE device will have the same physical PPI number
> > and thus will warn when this is not the case.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  drivers/perf/arm_spe_pmu.c | 23 +++++++++++++++++++++++
> >  include/kvm/arm_spe.h      |  6 ++++++
> >  2 files changed, 29 insertions(+)
> > 
> > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > index 4e4984a55cd1..2d24af4cfcab 100644
> > --- a/drivers/perf/arm_spe_pmu.c
> > +++ b/drivers/perf/arm_spe_pmu.c
> > @@ -34,6 +34,9 @@
> >  #include <linux/smp.h>
> >  #include <linux/vmalloc.h>
> >  
> > +#include <linux/kvm_host.h>
> > +#include <kvm/arm_spe.h>
> > +
> >  #include <asm/barrier.h>
> >  #include <asm/cpufeature.h>
> >  #include <asm/mmu.h>
> > @@ -1127,6 +1130,24 @@ static void arm_spe_pmu_dev_teardown(struct arm_spe_pmu *spe_pmu)
> >  	free_percpu_irq(spe_pmu->irq, spe_pmu->handle);
> >  }
> >  
> > +#ifdef CONFIG_KVM_ARM_SPE
> > +static struct arm_spe_kvm_info arm_spe_kvm_info;
> > +
> > +struct arm_spe_kvm_info *arm_spe_get_kvm_info(void)
> > +{
> > +	return &arm_spe_kvm_info;
> > +}
> 
> How does this work when SPE is built as a module?
> 
> > +
> > +static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu)
> > +{
> > +	WARN_ON_ONCE(arm_spe_kvm_info.physical_irq != 0 &&
> > +		     arm_spe_kvm_info.physical_irq != spe_pmu->irq);
> > +	arm_spe_kvm_info.physical_irq = spe_pmu->irq;
> 
> What does 'physical' means here? It's an IRQ in the Linux sense, so
> it's already some random number that bears no relation to anything
> 'physical'.

It's some random number relating to the SPE device as opposed to the virtual
SPE device.

Thanks,

Andrew Murray

> 
> > +}
> > +#else
> > +static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu) {}
> > +#endif
> > +
> >  /* Driver and device probing */
> >  static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
> >  {
> > @@ -1149,6 +1170,8 @@ static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
> >  	}
> >  
> >  	spe_pmu->irq = irq;
> > +	arm_spe_populate_kvm_info(spe_pmu);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> > index d1f3c564dfd0..9c65130d726d 100644
> > --- a/include/kvm/arm_spe.h
> > +++ b/include/kvm/arm_spe.h
> > @@ -17,6 +17,12 @@ struct kvm_spe {
> >  	bool irq_level;
> >  };
> >  
> > +struct arm_spe_kvm_info {
> > +	int physical_irq;
> > +};
> > +
> > +struct arm_spe_kvm_info *arm_spe_get_kvm_info(void);
> > +
> >  #ifdef CONFIG_KVM_ARM_SPE
> >  #define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
> >  #define kvm_arm_spe_irq_initialized(v)		\
> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
