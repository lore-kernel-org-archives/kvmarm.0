Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8401FC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jan 2022 08:44:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E776B412AF;
	Fri, 21 Jan 2022 03:44:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WYN2aP0BTcTj; Fri, 21 Jan 2022 03:44:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6C840D2E;
	Fri, 21 Jan 2022 03:44:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9FE040D2E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jan 2022 03:44:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUqOBJtanRq5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jan 2022 03:44:38 -0500 (EST)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E21F740BD9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jan 2022 03:44:37 -0500 (EST)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.201])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JgCbl4Kz9z67mwQ;
 Fri, 21 Jan 2022 16:44:19 +0800 (CST)
Received: from lhreml715-chm.china.huawei.com (10.201.108.66) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 09:44:35 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 08:44:35 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Fri, 21 Jan 2022 08:44:35 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: RE: [PATCH v4 1/4] KVM: arm64: Introduce a new VMID allocator for KVM
Thread-Topic: [PATCH v4 1/4] KVM: arm64: Introduce a new VMID allocator for KVM
Thread-Index: AQHX35su0U0y9O5EHEKbE33+2AyGfqxtc72AgAANKrA=
Date: Fri, 21 Jan 2022 08:44:35 +0000
Message-ID: <1bca6f5f13424601b431f72a1b1f2319@huawei.com>
References: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
 <20211122121844.867-2-shameerali.kolothum.thodi@huawei.com>
 <CAAeT=FwWNZ7O=oxGB5d0Pp2jVZVs71nCAGJTp9_+6fhuOK+dKw@mail.gmail.com>
In-Reply-To: <CAAeT=FwWNZ7O=oxGB5d0Pp2jVZVs71nCAGJTp9_+6fhuOK+dKw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.84.166]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Linuxarm <linuxarm@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jonathan Cameron <jonathan.cameron@huawei.com>, Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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



> -----Original Message-----
> From: Reiji Watanabe [mailto:reijiw@google.com]
> Sent: 21 January 2022 07:36
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>;
> kvmarm@lists.cs.columbia.edu; linux-kernel@vger.kernel.org;
> jean-philippe@linaro.org; Marc Zyngier <maz@kernel.org>; Linuxarm
> <linuxarm@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Catalin Marinas
> <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>
> Subject: Re: [PATCH v4 1/4] KVM: arm64: Introduce a new VMID allocator for
> KVM
> 
> On Mon, Nov 22, 2021 at 4:19 AM Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com> wrote:
> >
> > A new VMID allocator for arm64 KVM use. This is based on
> > arm64 ASID allocator algorithm.
> >
> > One major deviation from the ASID allocator is the way we
> > flush the context. Unlike ASID allocator, we expect less
> > frequent rollover in the case of VMIDs. Hence, instead of
> > marking the CPU as flush_pending and issuing a local context
> > invalidation on the next context switch, we  broadcast TLB
> > flush + I-cache invalidation over the inner shareable domain
> > on rollover.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   4 +
> >  arch/arm64/kvm/vmid.c             | 177
> ++++++++++++++++++++++++++++++
> >  2 files changed, 181 insertions(+)
> >  create mode 100644 arch/arm64/kvm/vmid.c
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> > index 2a5f7f38006f..f4a86a79ea4a 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -690,6 +690,10 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu
> *vcpu,
> >  int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
> >                             struct kvm_device_attr *attr);
> >
> > +int kvm_arm_vmid_alloc_init(void);
> > +void kvm_arm_vmid_alloc_free(void);
> > +void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
> > +
> >  static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch
> *vcpu_arch)
> >  {
> >         vcpu_arch->steal.base = GPA_INVALID;
> > diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> > new file mode 100644
> > index 000000000000..aa01c97f7df0
> > --- /dev/null
> > +++ b/arch/arm64/kvm/vmid.c
> > @@ -0,0 +1,177 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * VMID allocator.
> > + *
> > + * Based on Arm64 ASID allocator algorithm.
> > + * Please refer arch/arm64/mm/context.c for detailed
> > + * comments on algorithm.
> > + *
> > + * Copyright (C) 2002-2003 Deep Blue Solutions Ltd, all rights reserved.
> > + * Copyright (C) 2012 ARM Ltd.
> > + */
> > +
> > +#include <linux/bitfield.h>
> > +#include <linux/bitops.h>
> > +
> > +#include <asm/kvm_asm.h>
> > +#include <asm/kvm_mmu.h>
> > +
> > +static unsigned int kvm_arm_vmid_bits;
> > +static DEFINE_RAW_SPINLOCK(cpu_vmid_lock);
> > +
> > +static atomic64_t vmid_generation;
> > +static unsigned long *vmid_map;
> > +
> > +static DEFINE_PER_CPU(atomic64_t, active_vmids);
> > +static DEFINE_PER_CPU(u64, reserved_vmids);
> > +
> > +#define VMID_MASK              (~GENMASK(kvm_arm_vmid_bits - 1,
> 0))
> > +#define VMID_FIRST_VERSION     (1UL << kvm_arm_vmid_bits)
> > +
> > +#define NUM_USER_VMIDS         VMID_FIRST_VERSION
> > +#define vmid2idx(vmid)         ((vmid) & ~VMID_MASK)
> > +#define idx2vmid(idx)          vmid2idx(idx)
> > +
> > +#define vmid_gen_match(vmid) \
> > +       (!(((vmid) ^ atomic64_read(&vmid_generation)) >>
> kvm_arm_vmid_bits))
> > +
> > +static void flush_context(void)
> > +{
> > +       int cpu;
> > +       u64 vmid;
> > +
> > +       bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
> > +
> > +       for_each_possible_cpu(cpu) {
> > +               vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids,
> cpu), 0);
> > +
> > +               /* Preserve reserved VMID */
> > +               if (vmid == 0)
> > +                       vmid = per_cpu(reserved_vmids, cpu);
> > +               __set_bit(vmid2idx(vmid), vmid_map);
> > +               per_cpu(reserved_vmids, cpu) = vmid;
> > +       }
> > +
> > +       /*
> > +        * Unlike ASID allocator, we expect less frequent rollover in
> > +        * case of VMIDs. Hence, instead of marking the CPU as
> > +        * flush_pending and issuing a local context invalidation on
> > +        * the next context-switch, we broadcast TLB flush + I-cache
> > +        * invalidation over the inner shareable domain on rollover.
> > +        */
> > +        kvm_call_hyp(__kvm_flush_vm_context);
> > +}
> > +
> > +static bool check_update_reserved_vmid(u64 vmid, u64 newvmid)
> > +{
> > +       int cpu;
> > +       bool hit = false;
> > +
> > +       /*
> > +        * Iterate over the set of reserved VMIDs looking for a match
> > +        * and update to use newvmid (i.e. the same VMID in the current
> > +        * generation).
> > +        */
> > +       for_each_possible_cpu(cpu) {
> > +               if (per_cpu(reserved_vmids, cpu) == vmid) {
> > +                       hit = true;
> > +                       per_cpu(reserved_vmids, cpu) = newvmid;
> > +               }
> > +       }
> 
> Once updating reserved_vmids gets done for the all CPUs, it appears
> that the function doesn't need to iterate over the set of reserved
> VMIDs (correct ?). So, I'm wondering if KVM can manage the number of
> CPUs for which reserved_vmids need to get updated so that the function
> can skip the loop when the number is zero.  I'm not sure how likely
> that would help though.

Ok. I think that is possible to do. In the flush_context() we can update the
number of CPUs with valid reserved_vmid and add a check here. Not sure on
the probability of that being zero though.

> (Since every vmid allocation for non-new guest needs to iterate over
>  reserved_vmids holding cpu_vmid_lock, I'm a bit concerned about the
>  performance impact on systems with a large number of CPUs.)

But the non-new guest VMID allocation will normally go through the fast path
unless there is a rollover. And for 16bit VMID space, the frequency of rollover
is very rare I guess.

Thanks,
Shameer

> 
> Thanks,
> Reiji
> 
> > +
> > +       return hit;
> > +}
> > +
> > +static u64 new_vmid(struct kvm_vmid *kvm_vmid)
> > +{
> > +       static u32 cur_idx = 1;
> > +       u64 vmid = atomic64_read(&kvm_vmid->id);
> > +       u64 generation = atomic64_read(&vmid_generation);
> > +
> > +       if (vmid != 0) {
> > +               u64 newvmid = generation | (vmid & ~VMID_MASK);
> > +
> > +               if (check_update_reserved_vmid(vmid, newvmid)) {
> > +                       atomic64_set(&kvm_vmid->id, newvmid);
> > +                       return newvmid;
> > +               }
> > +
> > +               if (!__test_and_set_bit(vmid2idx(vmid), vmid_map)) {
> > +                       atomic64_set(&kvm_vmid->id, newvmid);
> > +                       return newvmid;
> > +               }
> > +       }
> > +
> > +       vmid = find_next_zero_bit(vmid_map, NUM_USER_VMIDS,
> cur_idx);
> > +       if (vmid != NUM_USER_VMIDS)
> > +               goto set_vmid;
> > +
> > +       /* We're out of VMIDs, so increment the global generation count */
> > +       generation = atomic64_add_return_relaxed(VMID_FIRST_VERSION,
> > +
> &vmid_generation);
> > +       flush_context();
> > +
> > +       /* We have more VMIDs than CPUs, so this will always succeed */
> > +       vmid = find_next_zero_bit(vmid_map, NUM_USER_VMIDS, 1);
> > +
> > +set_vmid:
> > +       __set_bit(vmid, vmid_map);
> > +       cur_idx = vmid;
> > +       vmid = idx2vmid(vmid) | generation;
> > +       atomic64_set(&kvm_vmid->id, vmid);
> > +       return vmid;
> > +}
> > +
> > +void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
> > +{
> > +       unsigned long flags;
> > +       u64 vmid, old_active_vmid;
> > +
> > +       vmid = atomic64_read(&kvm_vmid->id);
> > +
> > +       /*
> > +        * Please refer comments in check_and_switch_context() in
> > +        * arch/arm64/mm/context.c.
> > +        */
> > +       old_active_vmid = atomic64_read(this_cpu_ptr(&active_vmids));
> > +       if (old_active_vmid && vmid_gen_match(vmid) &&
> > +           atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
> > +                                    old_active_vmid, vmid))
> > +               return;
> > +
> > +       raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> > +
> > +       /* Check that our VMID belongs to the current generation. */
> > +       vmid = atomic64_read(&kvm_vmid->id);
> > +       if (!vmid_gen_match(vmid))
> > +               vmid = new_vmid(kvm_vmid);
> > +
> > +       atomic64_set(this_cpu_ptr(&active_vmids), vmid);
> > +       raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
> > +}
> > +
> > +/*
> > + * Initialize the VMID allocator
> > + */
> > +int kvm_arm_vmid_alloc_init(void)
> > +{
> > +       kvm_arm_vmid_bits = kvm_get_vmid_bits();
> > +
> > +       /*
> > +        * Expect allocation after rollover to fail if we don't have
> > +        * at least one more VMID than CPUs. VMID #0 is always reserved.
> > +        */
> > +       WARN_ON(NUM_USER_VMIDS - 1 <= num_possible_cpus());
> > +       atomic64_set(&vmid_generation, VMID_FIRST_VERSION);
> > +       vmid_map = kcalloc(BITS_TO_LONGS(NUM_USER_VMIDS),
> > +                          sizeof(*vmid_map), GFP_KERNEL);
> > +       if (!vmid_map)
> > +               return -ENOMEM;
> > +
> > +       return 0;
> > +}
> > +
> > +void kvm_arm_vmid_alloc_free(void)
> > +{
> > +       kfree(vmid_map);
> > +}
> > --
> > 2.17.1
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
