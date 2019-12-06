Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B0CC43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 15:48:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C8602173E
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 15:48:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C8602173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E73C4AF09;
	Fri,  6 Dec 2019 10:48:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UqDHJ8v0VGFg; Fri,  6 Dec 2019 10:48:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4C64AF08;
	Fri,  6 Dec 2019 10:48:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 563614AF08
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 10:48:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RJcdxgXIXb2A for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 10:48:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA954AECC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 10:48:42 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29A7231B;
 Fri,  6 Dec 2019 07:48:42 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 956AF3F718;
 Fri,  6 Dec 2019 07:48:41 -0800 (PST)
Date: Fri, 6 Dec 2019 15:48:39 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC 2/3] KVM: arm64: pmu: Fix chained SW_INCR counters
Message-ID: <20191206154839.GO18399@e119886-lin.cambridge.arm.com>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-3-eric.auger@redhat.com>
 <561ac6df385e977cc51d51a8ab28ee49@www.loen.fr>
 <2b30c1ca-3bc0-9f73-4bea-ee42bb74cbac@redhat.com>
 <15507faca89a980056df7119e105e82a@www.loen.fr>
 <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <145cdd1c-266c-6252-9688-e9e4c6809dfd@redhat.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Dec 05, 2019 at 08:01:42PM +0100, Auger Eric wrote:
> Hi Marc,
> =

> On 12/5/19 3:52 PM, Marc Zyngier wrote:
> > On 2019-12-05 14:06, Auger Eric wrote:
> >> Hi Marc,
> >>
> >> On 12/5/19 10:43 AM, Marc Zyngier wrote:
> >>> Hi Eric,
> >>>
> >>> On 2019-12-04 20:44, Eric Auger wrote:
> >>>> At the moment a SW_INCR counter always overflows on 32-bit
> >>>> boundary, independently on whether the n+1th counter is
> >>>> programmed as CHAIN.
> >>>>
> >>>> Check whether the SW_INCR counter is a 64b counter and if so,
> >>>> implement the 64b logic.
> >>>>
> >>>> Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> >>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>>> ---
> >>>> =A0virt/kvm/arm/pmu.c | 16 +++++++++++++++-
> >>>> =A01 file changed, 15 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> >>>> index c3f8b059881e..7ab477db2f75 100644
> >>>> --- a/virt/kvm/arm/pmu.c
> >>>> +++ b/virt/kvm/arm/pmu.c
> >>>> @@ -491,6 +491,8 @@ void kvm_pmu_software_increment(struct kvm_vcpu
> >>>> *vcpu, u64 val)
> >>>>
> >>>> =A0=A0=A0=A0 enable =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> >>>> =A0=A0=A0=A0 for (i =3D 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
> >>>> +=A0=A0=A0=A0=A0=A0=A0 bool chained =3D test_bit(i >> 1, vcpu->arch.=
pmu.chained);
> >>>> +
> >>>
> >>> I'd rather you use kvm_pmu_pmc_is_chained() rather than open-coding
> >>> this. But see below:
> >>>
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0 if (!(val & BIT(i)))
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0 type =3D __vcpu_sys_reg(vcpu, PMEVTYPER0_EL=
0 + i)
> >>>> @@ -500,8 +502,20 @@ void kvm_pmu_software_increment(struct kvm_vcpu
> >>>> *vcpu, u64 val)
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reg =3D __vcpu_sys_reg(vcpu, PM=
EVCNTR0_EL0 + i) + 1;
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reg =3D lower_32_bits(reg);
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, PMEVCNTR0_=
EL0 + i) =3D reg;
> >>>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!reg)
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (reg) /* no overflow */
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (chained) {
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reg =3D __vcpu_sys_re=
g(vcpu, PMEVCNTR0_EL0 + i + 1) + 1;
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reg =3D lower_32_bits=
(reg);
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, =
PMEVCNTR0_EL0 + i + 1) =3D reg;
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (reg)
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* mark an overflow o=
n high counter */
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu, =
PMOVSSET_EL0) |=3D BIT(i + 1);
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* mark an overflow */
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 __vcpu_sys_reg(vcpu=
, PMOVSSET_EL0) |=3D BIT(i);
> >>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> >>>> =A0=A0=A0=A0=A0=A0=A0=A0 }
> >>>> =A0=A0=A0=A0 }
> >>>> =A0}
> >>>
> >>> I think the whole function is a bit of a mess, and could be better
> >>> structured to treat 64bit counters as a first class citizen.
> >>>
> >>> I'm suggesting something along those lines, which tries to
> >>> streamline things a bit and keep the flow uniform between the
> >>> two word sizes. IMHO, it helps reasonning about it and gives
> >>> scope to the ARMv8.5 full 64bit counters... It is of course
> >>> completely untested.
> >>
> >> Looks OK to me as well. One remark though, don't we need to test if the
> >> n+1th reg is enabled before incrementing it?
> > =

> > Hmmm. I'm not sure. I think we should make sure that we don't flag
> > a counter as being chained if the odd counter is disabled, rather
> > than checking it here. As long as the odd counter is not chained
> > *and* enabled, we shouldn't touch it.>
> > Again, untested:
> > =

> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index cf371f643ade..47366817cd2a 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -15,6 +15,7 @@
> > =A0#include <kvm/arm_vgic.h>
> > =

> > =A0static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64
> > select_idx);
> > +static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64
> > select_idx);
> > =

> > =A0#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
> > =

> > @@ -298,6 +299,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu
> > *vcpu, u64 val)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 * For high counters of chained events we mu=
st recreate the
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 * perf event with the long (64bit) attribut=
e set.
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0 kvm_pmu_update_pmc_chained(vcpu, i);
> > =A0=A0=A0=A0=A0=A0=A0=A0 if (kvm_pmu_pmc_is_chained(pmc) &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kvm_pmu_idx_is_high_counter(i)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 kvm_pmu_create_perf_event(vcpu, i);
> > @@ -645,7 +647,8 @@ static void kvm_pmu_update_pmc_chained(struct
> > kvm_vcpu *vcpu, u64 select_idx)
> > =A0=A0=A0=A0 struct kvm_pmu *pmu =3D &vcpu->arch.pmu;
> > =A0=A0=A0=A0 struct kvm_pmc *pmc =3D &pmu->pmc[select_idx];
> > =

> > -=A0=A0=A0 if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
> > +=A0=A0=A0 if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx) &&
> > +=A0=A0=A0=A0=A0=A0=A0 kvm_pmu_counter_is_enabled(vcpu, pmc->idx)) {
> =

> In create_perf_event(), has_chain_evtype() is used and a 64b sample
> period would be chosen even if the counters are disjoined (since the odd
> is disabled). We would need to use pmc_is_chained() instead.

So in this use-case, someone has configured a pair of chained counters
but only enabled the lower half. In this case we only create a 32bit backing
event (no PERF_ATTR_CFG1_KVM_PMU_CHAINED flag) - I guess this means the
perf event will trigger on 64bit period(?) despite the high counter being
disabled. The guest will see an interrupt in their disabled high counter.

This is a know limitation - see the comment "For
chained counters we only support overflow interrupts on the high counter"

Though upon looking at this it seems a little more broken. I guess where
both counters are enabled we want to overflow at 64bits and raise the
overflow to the high counter. When the high counter is disabled we want to
overflow on 32bits and raise the overflow to the low counter.

Perhaps something like the following would help:

--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -585,15 +585,16 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu=
 *vcpu, u64 select_idx)
 =

        counter =3D kvm_pmu_get_pair_counter_value(vcpu, pmc);
 =

-       if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
+       if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx) &&
+           kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
+
                /**
                 * The initial sample period (overflow count) of an event. =
For
                 * chained counters we only support overflow interrupts on =
the
                 * high counter.
                 */
                attr.sample_period =3D (-counter) & GENMASK(63, 0);
-               if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
-                       attr.config1 |=3D PERF_ATTR_CFG1_KVM_PMU_CHAINED;
+               attr.config1 |=3D PERF_ATTR_CFG1_KVM_PMU_CHAINED;
 =

                event =3D perf_event_create_kernel_counter(&attr, -1, curre=
nt,
                                                         kvm_pmu_perf_overf=
low,


It's not clear to me what is supposed to happen with overflow handling on t=
he
low counter on chained counters (where the high counter is disabled).


> =

> With perf_events, the check of whether the odd register is enabled is
> properly done (create_perf_event). Then I understand whenever there is a
> change in enable state or type we delete the previous perf event and
> re-create a new one. Enable state check just is missing for SW_INCR.
> =

> Some other questions:
> - do we need a perf event to be created even if the counter is not
> enabled? For instance on counter resets, create_perf_events get called.

That would suggest we create and destroy them each time the guest enables
and disables the counters - I would expect them to do that a lot (every
context switch) - my assumption would be that the current approach has
less overhead for a running guest.


> - also actions are made for counters which are not implemented. loop
> until ARMV8_PMU_MAX_COUNTERS. Do you think it is valuable to have a
> bitmask of supported counters stored before pmu readiness?
> I can propose such changes if you think they are valuable.

Are they? Many of the calls into this file come from
arch/arm64/kvm/sys_regs.c where we apply a mask (value from
kvm_pmu_valid_counter_mask) to ignore unsupported counters.

Thanks,

Andrew Murray


> =

> Thanks
> =

> Eric
> =

> > =A0=A0=A0=A0=A0=A0=A0=A0 /*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 * During promotion from !chained to chained=
 we must ensure
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 * the adjacent counter is stopped and its e=
vent destroyed
> > =

> > What do you think?
> > =

> > =A0=A0=A0=A0=A0=A0=A0 M.
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
