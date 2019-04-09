Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CD0C10F0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 658462084F
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 658462084F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A944E4A482;
	Tue,  9 Apr 2019 15:13:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aqY0RRaHuGjo; Tue,  9 Apr 2019 15:13:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 378BB4A44E;
	Tue,  9 Apr 2019 15:13:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF24D4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 15:13:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M9og5+yT-WJQ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 15:13:54 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA474A380
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 15:13:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7797BA78;
 Tue,  9 Apr 2019 12:13:53 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BE893F59C;
 Tue,  9 Apr 2019 12:13:52 -0700 (PDT)
Date: Tue, 9 Apr 2019 20:13:51 +0100
From: Andrew Murray <andrew.murray@arm.com>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v12 6/8] arm64: KVM: Enable VHE support for :G/:H perf
 event modifiers
Message-ID: <20190409191350.GC25919@e119886-lin.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-7-andrew.murray@arm.com>
 <20190409175227.GD9255@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190409175227.GD9255@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409191351.wyGVx6gkfdyUlXVloc8wwHov5ODFeVQHVwYSpTIyp_Q@z>

On Tue, Apr 09, 2019 at 06:52:27PM +0100, Will Deacon wrote:
> On Thu, Mar 28, 2019 at 10:37:29AM +0000, Andrew Murray wrote:
> > With VHE different exception levels are used between the host (EL2) and
> > guest (EL1) with a shared exception level for userpace (EL0). We can take
> > advantage of this and use the PMU's exception level filtering to avoid
> > enabling/disabling counters in the world-switch code. Instead we just
> > modify the counter type to include or exclude EL0 at vcpu_{load,put} time.
> > 
> > We also ensure that trapped PMU system register writes do not re-enable
> > EL0 when reconfiguring the backing perf events.
> > 
> > This approach completely avoids blackout windows seen with !VHE.
> > 
> > Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  3 ++
> >  arch/arm64/include/asm/kvm_host.h |  5 +-
> >  arch/arm64/kernel/perf_event.c    |  6 ++-
> >  arch/arm64/kvm/pmu.c              | 87 ++++++++++++++++++++++++++++++-
> >  arch/arm64/kvm/sys_regs.c         |  3 ++
> >  virt/kvm/arm/arm.c                |  2 +
> >  6 files changed, 102 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 427c28be6452..481411295b3b 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -365,6 +365,9 @@ static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
> >  
> > +static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
> > +static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> > +
> >  static inline void kvm_arm_vhe_guest_enter(void) {}
> >  static inline void kvm_arm_vhe_guest_exit(void) {}
> >  
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a3bfb75f0be9..4f290dad3a48 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -528,7 +528,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
> >  
> >  static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
> >  {
> > -	return attr->exclude_host;
> > +	return (!has_vhe() && attr->exclude_host);
> >  }
> >  
> >  #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
> > @@ -542,6 +542,9 @@ void kvm_clr_pmu_events(u32 clr);
> >  
> >  void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt);
> >  bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt);
> > +
> > +void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
> > +void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  #else
> >  static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
> >  static inline void kvm_clr_pmu_events(u32 clr) {}
> > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > index 6bb28aaf5aea..314b1adedf06 100644
> > --- a/arch/arm64/kernel/perf_event.c
> > +++ b/arch/arm64/kernel/perf_event.c
> > @@ -847,8 +847,12 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
> >  	 * with other architectures (x86 and Power).
> >  	 */
> >  	if (is_kernel_in_hyp_mode()) {
> > -		if (!attr->exclude_kernel)
> > +		if (!attr->exclude_kernel && !attr->exclude_host)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> > +		if (attr->exclude_guest)
> > +			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> > +		if (attr->exclude_host)
> > +			config_base |= ARMV8_PMU_EXCLUDE_EL0;
> >  	} else {
> >  		if (!attr->exclude_hv && !attr->exclude_host)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> 
> I still don't really like these semantics, but it's consistent and
> you're documenting it so:
> 
> Acked-by: Will Deacon <will.deacon@arm.com>

Much appreciated.

Thanks,

Andrew Murray

> 
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
