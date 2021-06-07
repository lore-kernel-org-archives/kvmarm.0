Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60CDAC47095
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 17:17:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2A316102A
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 17:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2A316102A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21BE44A4E1;
	Mon,  7 Jun 2021 13:17:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FB3VYn-rN2r0; Mon,  7 Jun 2021 13:17:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61CD74AED4;
	Mon,  7 Jun 2021 13:17:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A717B4AC78
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 12:05:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zy8+eZlJa5CZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 12:05:15 -0400 (EDT)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B60DF4A173
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 12:05:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1623081916; x=1654617916;
 h=from:to:cc:date:message-id:references:in-reply-to:
 content-id:mime-version:content-transfer-encoding:subject;
 bh=Gm+1HoiO2hCI9xcdJsrs/UAeeMTFj7ruUIE1rSGlkoE=;
 b=U8d643yMwCyxRFFlRLYP+y1IEtdosrxgHXA2EapTT5ebAB86wmO7Kal6
 zNW5LpK5UsDHNVHsewIZLWzcdTMVcA4kcsLpJvdu1ELFTL5SSDRZ+NQ1q
 h6+b0qzGXRSHzdlR8TMgSEYoEyhWE4BJvBhNvs5WKeCYIj9QaMtWXgdQe 4=;
X-IronPort-AV: E=Sophos;i="5.83,255,1616457600"; d="scan'208";a="117098644"
Subject: Re: [PATCH] KVM: arm64: Properly restore PMU state during
 live-migration
Thread-Topic: [PATCH] KVM: arm64: Properly restore PMU state during
 live-migration
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO
 email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.2])
 by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 07 Jun 2021 16:05:08 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
 by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS
 id 50255140A77; Mon,  7 Jun 2021 16:05:04 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 7 Jun 2021 16:05:03 +0000
Received: from EX13D19EUA001.ant.amazon.com (10.43.165.74) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 7 Jun 2021 16:05:02 +0000
Received: from EX13D19EUA001.ant.amazon.com ([10.43.165.74]) by
 EX13D19EUA001.ant.amazon.com ([10.43.165.74]) with mapi id 15.00.1497.018;
 Mon, 7 Jun 2021 16:05:01 +0000
From: "Jain, Jinank" <jinankj@amazon.de>
To: "maz@kernel.org" <maz@kernel.org>
Thread-Index: AQHXWGiDwgcuw84aU0uAgEUSGDYWHasCc0sAgAZJnQA=
Date: Mon, 7 Jun 2021 16:05:01 +0000
Message-ID: <0a694ea93303bfa04530cd940f692244e1ccd1e7.camel@amazon.de>
References: <20210603110554.13643-1-jinankj@amazon.de>
 <87wnrbylxv.wl-maz@kernel.org>
In-Reply-To: <87wnrbylxv.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.49]
Content-ID: <D764C132FF194942A2E6944525E0C0C8@amazon.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 07 Jun 2021 13:17:14 -0400
Cc: "Graf \(AWS\), Alexander" <graf@amazon.de>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Thu, 2021-06-03 at 17:03 +0100, Marc Zyngier wrote:
> CAUTION: This email originated from outside of the organization. Do
> not click links or open attachments unless you can confirm the sender
> and know the content is safe.
> 
> 
> 
> Hi Jinank,
> 
> On Thu, 03 Jun 2021 12:05:54 +0100,
> Jinank Jain <jinankj@amazon.de> wrote:
> > Currently if a guest is live-migrated while it is actively using
> > perf
> > counters, then after live-migrate it will notice that all counters
> > would
> > suddenly start reporting 0s. This is due to the fact we are not
> > re-creating the relevant perf events inside the kernel.
> > 
> > Usually on live-migration guest state is restored using
> > KVM_SET_ONE_REG
> > ioctl interface, which simply restores the value of PMU registers
> > values but does not re-program the perf events so that the guest
> > can seamlessly
> > use these counters even after live-migration like it was doing
> > before
> > live-migration.
> > 
> > Instead there are two completely different code path between guest
> > accessing PMU registers and VMM restoring counters on
> > live-migration.
> > 
> > In case of KVM_SET_ONE_REG:
> > 
> > kvm_arm_set_reg()
> > ...... kvm_arm_sys_reg_set_reg()
> > ........... reg_from_user()
> > 
> > but in case when guest tries to access these counters:
> > 
> > handle_exit()
> > ..... kvm_handle_sys_reg()
> > ..........perform_access()
> > ...............access_pmu_evcntr()
> > ...................kvm_pmu_set_counter_value()
> > .......................kvm_pmu_create_perf_event()
> > 
> > The drawback of using the KVM_SET_ONE_REG interface is that the
> > host pmu
> > events which were registered for the source instance and not
> > present for
> > the destination instance.
> 
> I can't parse this sentence. Do you mean "are not present"?
> 
> > Thus passively restoring PMCR_EL0 using
> > KVM_SET_ONE_REG interface would not create the necessary host pmu
> > events
> > which are crucial for seamless guest experience across live
> > migration.
> > 
> > In ordet to fix the situation, on first vcpu load we should restore
> > PMCR_EL0 in the same exact way like the guest was trying to access
> > these counters. And then we will also recreate the relevant host
> > pmu
> > events.
> > 
> > Signed-off-by: Jinank Jain <jinankj@amazon.de>
> > Cc: Alexander Graf (AWS) <graf@amazon.de>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/pmu-emul.c         | 10 ++++++++--
> >  arch/arm64/kvm/pmu.c              | 15 +++++++++++++++
> >  include/kvm/arm_pmu.h             |  3 +++
> >  5 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> > b/arch/arm64/include/asm/kvm_host.h
> > index 7cd7d5c8c4bc..2376ad3c2fc2 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -745,6 +745,7 @@ static inline int
> > kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> >  void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
> >  void kvm_clr_pmu_events(u32 clr);
> > 
> > +void kvm_vcpu_pmu_restore(struct kvm_vcpu *vcpu);
> >  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
> >  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  #else
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e720148232a0..c66f6d16ec06 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -408,6 +408,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu,
> > int cpu)
> >       if (has_vhe())
> >               kvm_vcpu_load_sysregs_vhe(vcpu);
> >       kvm_arch_vcpu_load_fp(vcpu);
> > +     kvm_vcpu_pmu_restore(vcpu);
> 
> If this only needs to be run once per vcpu, why not trigger it from
> kvm_arm_pmu_v3_enable(), which is also called once per vcpu?
> 
> This can done on the back of a request, saving most of the overhead
> and not requiring any extra field. Essentially, something like the
> (untested) patch below.
> 
> >       kvm_vcpu_pmu_restore_guest(vcpu);
> >       if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> >               kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index fd167d4f4215..12a40f4b5f0d 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -574,10 +574,16 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu
> > *vcpu, u64 val)
> >               kvm_pmu_disable_counter_mask(vcpu, mask);
> >       }
> > 
> > -     if (val & ARMV8_PMU_PMCR_C)
> > +     /*
> > +      * Cycle counter needs to reset in case of first vcpu load.
> > +      */
> > +     if (val & ARMV8_PMU_PMCR_C || !kvm_arm_pmu_v3_restored(vcpu))
> 
> Why? There is no architectural guarantee that a counter resets to 0
> without writing PMCR_EL0.C. And if you want the guest to continue
> counting where it left off, resetting the counter is at best
> counter-productive.

Without this we would not be resetting PMU which is required for
creating host perf events. With the patch that you suggested we are
restoring PMCR_EL0 properly but still missing recreation of host perf
events. And without host perf events, guest would still zeros after
live migration. In my opinion we have two ways to fix it. We can fix it
inside the kernel or let userspace/VMM set those bits before restarting
the guest on the destination machine. What do you think?

> 
> So I must be missing something...
> 
> >               kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX,
> > 0);
> > 
> > -     if (val & ARMV8_PMU_PMCR_P) {
> > +     /*
> > +      * All the counters needs to reset in case of first vcpu
> > load.
> > +      */
> > +     if (val & ARMV8_PMU_PMCR_P || !kvm_arm_pmu_v3_restored(vcpu))
> > {
> 
> Same thing here.
> 
> >               for_each_set_bit(i, &mask, 32)
> >                       kvm_pmu_set_counter_value(vcpu, i, 0);
> >       }
> 
> The rest of the changes should be unnecessary with the patch below.
> 
> Thanks,
> 
>         M.
> 
> From 1be188ab71867632a8c17384be6e55f47f42aa8b Mon Sep 17 00:00:00
> 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 3 Jun 2021 16:50:02 +0100
> Subject: [PATCH] KVM: arm64: Restore PMU configuration on first run
> 
> Restoring a guest with an active virtual PMU results in no perf
> counters being instanciated on the host side. Not quite what
> you'd expect from a restore.
> 
> In order to fix this, force a writeback of PMCR_EL0 on the first
> run of a vcpu (using a new request so that it happens once the
> vcpu has been loaded). This will in turn create all the host-side
> counters that were missing.
> 
> Reported-by: Jinank Jain <jinankj@amazon.de>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  arch/arm64/kvm/arm.c              | 4 ++++
>  arch/arm64/kvm/pmu-emul.c         | 3 +++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 7cd7d5c8c4bc..6336b4309114 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -46,6 +46,7 @@
>  #define KVM_REQ_VCPU_RESET     KVM_ARCH_REQ(2)
>  #define KVM_REQ_RECORD_STEAL   KVM_ARCH_REQ(3)
>  #define KVM_REQ_RELOAD_GICv4   KVM_ARCH_REQ(4)
> +#define KVM_REQ_RELOAD_PMU     KVM_ARCH_REQ(5)
> 
>  #define
> KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>                                      KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e720148232a0..facf4d41d32a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -689,6 +689,10 @@ static void check_vcpu_requests(struct kvm_vcpu
> *vcpu)
>                         vgic_v4_load(vcpu);
>                         preempt_enable();
>                 }
> +
> +               if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
> +                       kvm_pmu_handle_pmcr(vcpu,
> +                                           __vcpu_sys_reg(vcpu,
> PMCR_EL0));
>         }
>  }
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index fd167d4f4215..a0bbb7111f57 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -850,6 +850,9 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>                    return -EINVAL;
>         }
> 
> +       /* One-off reload of the PMU on first run */
> +       kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +
>         return 0;
>  }
> 
> --
> 2.30.2
> 
> 
> --
> Without deviation from the norm, progress is not possible.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
