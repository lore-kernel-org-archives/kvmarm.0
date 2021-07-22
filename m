Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92153C63793
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 06:35:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0A7761279
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 06:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0A7761279
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 771004A51D;
	Thu, 22 Jul 2021 02:35:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AcQ2JLhtscBT; Thu, 22 Jul 2021 02:35:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F274B0B1;
	Thu, 22 Jul 2021 02:35:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A18B4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 02:35:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vvlyFMmTC7Nx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 02:35:05 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 710A44A51D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 02:35:04 -0400 (EDT)
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4GVjKW2N7Jzmhtb;
 Thu, 22 Jul 2021 14:31:59 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 14:34:59 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Thu, 22 Jul 2021 07:34:57 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v2 2/3] kvm/arm: Introduce a new vmid allocator for KVM
Thread-Topic: [PATCH v2 2/3] kvm/arm: Introduce a new vmid allocator for KVM
Thread-Index: AQHXYshW/nzyI5jyG0eXMHJ9tLJ26qtNvlQAgAEAsAA=
Date: Thu, 22 Jul 2021 06:34:57 +0000
Message-ID: <8c0345ae808140f79c2adc4e0fd2effc@huawei.com>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-3-shameerali.kolothum.thodi@huawei.com>
 <20210721160614.GC11003@willie-the-truck>
In-Reply-To: <20210721160614.GC11003@willie-the-truck>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.80.98]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>,
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



> -----Original Message-----
> From: Will Deacon [mailto:will@kernel.org]
> Sent: 21 July 2021 17:06
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; maz@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org;
> Alexandru.Elisei@arm.com; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH v2 2/3] kvm/arm: Introduce a new vmid allocator for KVM
> 
> On Wed, Jun 16, 2021 at 04:56:05PM +0100, Shameer Kolothum wrote:
> > A new VMID allocator for arm64 KVM use. This is based on
> > arm64 asid allocator algorithm.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   4 +
> >  arch/arm64/kvm/vmid.c             | 206
> ++++++++++++++++++++++++++++++
> >  2 files changed, 210 insertions(+)
> >  create mode 100644 arch/arm64/kvm/vmid.c
> 
> Generally, I prefer this to the alternative of creating a library. However,
> I'd probably remove all the duplicated comments in favour of a reference
> to the ASID allocator. That way, we can just comment any VMID-specific
> behaviour in here.

Agree. I retained the comments mainly for myself as its very difficult at times
to follow :)

> 
> Some comments below...
> 
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> > index 7cd7d5c8c4bc..75a7e8071012 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -680,6 +680,10 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu
> *vcpu,
> >  int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
> >  			    struct kvm_device_attr *attr);
> >
> > +int kvm_arm_vmid_alloc_init(void);
> > +void kvm_arm_vmid_alloc_free(void);
> > +void kvm_arm_update_vmid(atomic64_t *id);
> > +
> >  static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch
> *vcpu_arch)
> >  {
> >  	vcpu_arch->steal.base = GPA_INVALID;
> > diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> > new file mode 100644
> > index 000000000000..687e18d33130
> > --- /dev/null
> > +++ b/arch/arm64/kvm/vmid.c
> > @@ -0,0 +1,206 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * VMID allocator.
> > + *
> > + * Based on arch/arm64/mm/context.c
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
> > +static u32 vmid_bits;
> > +static DEFINE_RAW_SPINLOCK(cpu_vmid_lock);
> > +
> > +static atomic64_t vmid_generation;
> > +static unsigned long *vmid_map;
> > +
> > +static DEFINE_PER_CPU(atomic64_t, active_vmids);
> > +static DEFINE_PER_CPU(u64, reserved_vmids);
> > +static cpumask_t tlb_flush_pending;
> > +
> > +#define VMID_MASK		(~GENMASK(vmid_bits - 1, 0))
> > +#define VMID_FIRST_VERSION	(1UL << vmid_bits)
> > +
> > +#define NUM_USER_VMIDS		VMID_FIRST_VERSION
> > +#define vmid2idx(vmid)		((vmid) & ~VMID_MASK)
> > +#define idx2vmid(idx)		vmid2idx(idx)
> > +
> > +#define vmid_gen_match(vmid) \
> > +	(!(((vmid) ^ atomic64_read(&vmid_generation)) >> vmid_bits))
> > +
> > +static void flush_context(void)
> > +{
> > +	int cpu;
> > +	u64 vmid;
> > +
> > +	bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
> > +		/*
> > +		 * If this CPU has already been through a
> > +		 * rollover, but hasn't run another task in
> > +		 * the meantime, we must preserve its reserved
> > +		 * VMID, as this is the only trace we have of
> > +		 * the process it is still running.
> > +		 */
> > +		if (vmid == 0)
> > +			vmid = per_cpu(reserved_vmids, cpu);
> > +		__set_bit(vmid2idx(vmid), vmid_map);
> > +		per_cpu(reserved_vmids, cpu) = vmid;
> > +	}
> 
> Hmm, so here we're copying the active_vmids into the reserved_vmids on a
> rollover, but I wonder if that's overly pessismistic? For the ASID
> allocator, every CPU tends to have a current task so it makes sense, but
> I'm not sure it's necessarily the case that every CPU tends to have a
> vCPU as the current task. For example, imagine you have a nasty 128-CPU
> system with 8-bit VMIDs and each CPU has at some point run a vCPU. Then,
> on rollover, we'll immediately reserve half of the VMID space, even if
> those vCPUs don't even exist any more.
> 
> Not sure if it's worth worrying about, but I wanted to mention it.

Ok. I see your suggestion in patch #3 to avoid this.

> 
> > +void kvm_arm_update_vmid(atomic64_t *id)
> > +{
> 
> Take the kvm_vmid here? That would make:
> 
> > +	/* Check that our VMID belongs to the current generation. */
> > +	vmid = atomic64_read(id);
> > +	if (!vmid_gen_match(vmid)) {
> > +		vmid = new_vmid(id);
> > +		atomic64_set(id, vmid);
> > +	}
> 
> A bit more readable, as you could pass the pointer directly to new_vmid
> for initialisation.

Ok.

Thanks,
Shameer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
