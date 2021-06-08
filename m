Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77527C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 13:05:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E230E6128D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 13:05:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E230E6128D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F75240821;
	Tue,  8 Jun 2021 09:05:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F+5TBgHPj21a; Tue,  8 Jun 2021 09:05:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79FC74019D;
	Tue,  8 Jun 2021 09:05:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DCD14081C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 04:24:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3KRFyAKsCX+B for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 04:24:41 -0400 (EDT)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B4FE407ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 04:24:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1623140682; x=1654676682;
 h=from:to:cc:date:message-id:references:in-reply-to:
 content-id:mime-version:content-transfer-encoding:subject;
 bh=0Y5gzEbn1hAeMJTVGWpCtXqdBYiMxoJcWc7kGY52UDw=;
 b=ROWT5sIt6/1qKWCslUl6K/Pk1WTUpAGfZx8iYsD97eIxHpVjDVBiNjiy
 YaWAOJL6Vw7BmjiSFt1NyQGR41ydPNeMYn+JN6uVOAd4Ar3OH+h9ZsaUy
 dR+mbiZcIdljsp4VpL9sf3yFScV3PqH9hrnBXsuAMBbOTzFFfzM7eX7D3 0=;
X-IronPort-AV: E=Sophos;i="5.83,257,1616457600"; d="scan'208";a="118713622"
Subject: Re: [PATCH] KVM: arm64: Properly restore PMU state during
 live-migration
Thread-Topic: [PATCH] KVM: arm64: Properly restore PMU state during
 live-migration
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.6])
 by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 08 Jun 2021 08:24:35 +0000
Received: from EX13MTAUWA001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
 by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS
 id 1604AA1F18; Tue,  8 Jun 2021 08:24:31 +0000 (UTC)
Received: from EX13D20UWA003.ant.amazon.com (10.43.160.97) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 08:24:31 +0000
Received: from EX13D19EUA001.ant.amazon.com (10.43.165.74) by
 EX13D20UWA003.ant.amazon.com (10.43.160.97) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 08:24:30 +0000
Received: from EX13D19EUA001.ant.amazon.com ([10.43.165.74]) by
 EX13D19EUA001.ant.amazon.com ([10.43.165.74]) with mapi id 15.00.1497.018;
 Tue, 8 Jun 2021 08:24:29 +0000
From: "Jain, Jinank" <jinankj@amazon.de>
To: "maz@kernel.org" <maz@kernel.org>
Thread-Index: AQHXWGiDwgcuw84aU0uAgEUSGDYWHasCc0sAgAZJnQCAAAh2gIAAITgAgADmZgCAAAGZgA==
Date: Tue, 8 Jun 2021 08:24:29 +0000
Message-ID: <b53dfcf9bbc4db7f96154b1cd5188d72b9766358.camel@amazon.de>
References: <20210603110554.13643-1-jinankj@amazon.de>
 <87wnrbylxv.wl-maz@kernel.org>
 <0a694ea93303bfa04530cd940f692244e1ccd1e7.camel@amazon.de>
 <87lf7lzl8c.wl-maz@kernel.org>
 <b4392eae86311425a0c1f2b2072e41dbb437a4e2.camel@amazon.de>
 <87eedczs49.wl-maz@kernel.org>
In-Reply-To: <87eedczs49.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.82]
Content-ID: <52137560E1E4624F94DAC99ABDCDDB3A@amazon.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 08 Jun 2021 09:05:46 -0400
Cc: "Graf \(AWS\), Alexander" <graf@amazon.de>,
 "will@kernel.org" <will@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
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

On Tue, 2021-06-08 at 09:18 +0100, Marc Zyngier wrote:
> CAUTION: This email originated from outside of the organization. Do
> not click links or open attachments unless you can confirm the sender
> and know the content is safe.
> 
> 
> 
> On Mon, 07 Jun 2021 19:34:08 +0100,
> "Jain, Jinank" <jinankj@amazon.de> wrote:
> > Hi Marc.
> > 
> > On Mon, 2021-06-07 at 17:35 +0100, Marc Zyngier wrote:
> > > CAUTION: This email originated from outside of the organization.
> > > Do
> > > not click links or open attachments unless you can confirm the
> > > sender
> > > and know the content is safe.
> > > 
> > > 
> > > 
> > > On Mon, 07 Jun 2021 17:05:01 +0100,
> > > "Jain, Jinank" <jinankj@amazon.de> wrote:
> > > > On Thu, 2021-06-03 at 17:03 +0100, Marc Zyngier wrote:
> > > > > Hi Jinank,
> > > > > 
> > > > > On Thu, 03 Jun 2021 12:05:54 +0100,
> > > > > Jinank Jain <jinankj@amazon.de> wrote:
> > > > > > Currently if a guest is live-migrated while it is actively
> > > > > > using
> > > > > > perf
> > > > > > counters, then after live-migrate it will notice that all
> > > > > > counters
> > > > > > would
> > > > > > suddenly start reporting 0s. This is due to the fact we are
> > > > > > not
> > > > > > re-creating the relevant perf events inside the kernel.
> > > > > > 
> > > > > > Usually on live-migration guest state is restored using
> > > > > > KVM_SET_ONE_REG
> > > > > > ioctl interface, which simply restores the value of PMU
> > > > > > registers
> > > > > > values but does not re-program the perf events so that the
> > > > > > guest
> > > > > > can seamlessly
> > > > > > use these counters even after live-migration like it was
> > > > > > doing
> > > > > > before
> > > > > > live-migration.
> > > > > > 
> > > > > > Instead there are two completely different code path
> > > > > > between
> > > > > > guest
> > > > > > accessing PMU registers and VMM restoring counters on
> > > > > > live-migration.
> > > > > > 
> > > > > > In case of KVM_SET_ONE_REG:
> > > > > > 
> > > > > > kvm_arm_set_reg()
> > > > > > ...... kvm_arm_sys_reg_set_reg()
> > > > > > ........... reg_from_user()
> > > > > > 
> > > > > > but in case when guest tries to access these counters:
> > > > > > 
> > > > > > handle_exit()
> > > > > > ..... kvm_handle_sys_reg()
> > > > > > ..........perform_access()
> > > > > > ...............access_pmu_evcntr()
> > > > > > ...................kvm_pmu_set_counter_value()
> > > > > > .......................kvm_pmu_create_perf_event()
> > > > > > 
> > > > > > The drawback of using the KVM_SET_ONE_REG interface is that
> > > > > > the
> > > > > > host pmu
> > > > > > events which were registered for the source instance and
> > > > > > not
> > > > > > present for
> > > > > > the destination instance.
> > > > > 
> > > > > I can't parse this sentence. Do you mean "are not present"?
> > > > > 
> > > > > > Thus passively restoring PMCR_EL0 using
> > > > > > KVM_SET_ONE_REG interface would not create the necessary
> > > > > > host
> > > > > > pmu
> > > > > > events
> > > > > > which are crucial for seamless guest experience across live
> > > > > > migration.
> > > > > > 
> > > > > > In ordet to fix the situation, on first vcpu load we should
> > > > > > restore
> > > > > > PMCR_EL0 in the same exact way like the guest was trying to
> > > > > > access
> > > > > > these counters. And then we will also recreate the relevant
> > > > > > host
> > > > > > pmu
> > > > > > events.
> > > > > > 
> > > > > > Signed-off-by: Jinank Jain <jinankj@amazon.de>
> > > > > > Cc: Alexander Graf (AWS) <graf@amazon.de>
> > > > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > > > Cc: James Morse <james.morse@arm.com>
> > > > > > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > > > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > Cc: Will Deacon <will@kernel.org>
> > > > > > ---
> > > > > >  arch/arm64/include/asm/kvm_host.h |  1 +
> > > > > >  arch/arm64/kvm/arm.c              |  1 +
> > > > > >  arch/arm64/kvm/pmu-emul.c         | 10 ++++++++--
> > > > > >  arch/arm64/kvm/pmu.c              | 15 +++++++++++++++
> > > > > >  include/kvm/arm_pmu.h             |  3 +++
> > > > > >  5 files changed, 28 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/arch/arm64/include/asm/kvm_host.h
> > > > > > b/arch/arm64/include/asm/kvm_host.h
> > > > > > index 7cd7d5c8c4bc..2376ad3c2fc2 100644
> > > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > > @@ -745,6 +745,7 @@ static inline int
> > > > > > kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> > > > > >  void kvm_set_pmu_events(u32 set, struct perf_event_attr
> > > > > > *attr);
> > > > > >  void kvm_clr_pmu_events(u32 clr);
> > > > > > 
> > > > > > +void kvm_vcpu_pmu_restore(struct kvm_vcpu *vcpu);
> > > > > >  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
> > > > > >  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> > > > > >  #else
> > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > index e720148232a0..c66f6d16ec06 100644
> > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > @@ -408,6 +408,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
> > > > > > *vcpu,
> > > > > > int cpu)
> > > > > >       if (has_vhe())
> > > > > >               kvm_vcpu_load_sysregs_vhe(vcpu);
> > > > > >       kvm_arch_vcpu_load_fp(vcpu);
> > > > > > +     kvm_vcpu_pmu_restore(vcpu);
> > > > > 
> > > > > If this only needs to be run once per vcpu, why not trigger
> > > > > it
> > > > > from
> > > > > kvm_arm_pmu_v3_enable(), which is also called once per vcpu?
> > > > > 
> > > > > This can done on the back of a request, saving most of the
> > > > > overhead
> > > > > and not requiring any extra field. Essentially, something
> > > > > like
> > > > > the
> > > > > (untested) patch below.
> > > > > 
> > > > > >       kvm_vcpu_pmu_restore_guest(vcpu);
> > > > > >       if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> > > > > >               kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> > > > > > diff --git a/arch/arm64/kvm/pmu-emul.c
> > > > > > b/arch/arm64/kvm/pmu-
> > > > > > emul.c
> > > > > > index fd167d4f4215..12a40f4b5f0d 100644
> > > > > > --- a/arch/arm64/kvm/pmu-emul.c
> > > > > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > > > > @@ -574,10 +574,16 @@ void kvm_pmu_handle_pmcr(struct
> > > > > > kvm_vcpu
> > > > > > *vcpu, u64 val)
> > > > > >               kvm_pmu_disable_counter_mask(vcpu, mask);
> > > > > >       }
> > > > > > 
> > > > > > -     if (val & ARMV8_PMU_PMCR_C)
> > > > > > +     /*
> > > > > > +      * Cycle counter needs to reset in case of first vcpu
> > > > > > load.
> > > > > > +      */
> > > > > > +     if (val & ARMV8_PMU_PMCR_C ||
> > > > > > !kvm_arm_pmu_v3_restored(vcpu))
> > > > > 
> > > > > Why? There is no architectural guarantee that a counter
> > > > > resets to
> > > > > 0
> > > > > without writing PMCR_EL0.C. And if you want the guest to
> > > > > continue
> > > > > counting where it left off, resetting the counter is at best
> > > > > counter-productive.
> > > > 
> > > > Without this we would not be resetting PMU which is required
> > > > for
> > > > creating host perf events. With the patch that you suggested we
> > > > are
> > > > restoring PMCR_EL0 properly but still missing recreation of
> > > > host
> > > > perf
> > > > events.
> > > 
> > > How? The request that gets set on the first vcpu run will call
> > > kvm_pmu_handle_pmcr() -> kvm_pmu_enable_counter_mask() ->
> > > kvm_pmu_create_perf_event(). What are we missing?
> > > 
> > 
> > I found out what I was missing. I was working with an older kernel
> > which was missing this upstream patch:
> > 
> > https://lore.kernel.org/lkml/20200124142535.29386-3-eric.auger@redhat.com/
> 
> :-(
> 
> Please test whatever you send with an upstream kernel. Actually,
> please *develop* on an upstream kernel. This will avoid this kind of
> discussion where we talk past each other, and make it plain that your
> production kernel is lacking all sorts of fixes.
> 
> Now, can you please state whether or not this patch fixes it for you
> *on an upstream kernel*? I have no interest in results from a
> production kernel.
> 
>         M.
> 

Really sorry for the noise and I can confirm that your suggested patch
fixes the problem for the upstream kernel i.e., if I live migrate a
guest which is actively using perf events then the guest can continue
using them even after live migration without interruption.

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
