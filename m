Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD41C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 22 Nov 2021 11:27:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A7E4B1AD;
	Mon, 22 Nov 2021 06:27:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uyM+U5KYZ625; Mon, 22 Nov 2021 06:27:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0508C4B175;
	Mon, 22 Nov 2021 06:27:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FCB4B16C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 06:27:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d85cEn7WL-zY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 06:27:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD8F4B13A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 06:27:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 751391042;
 Mon, 22 Nov 2021 03:27:46 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BCC03F73B;
 Mon, 22 Nov 2021 03:27:44 -0800 (PST)
Date: Mon, 22 Nov 2021 11:29:36 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
Message-ID: <YZt/IBwJvsIbmMpH@monolith.localdoman>
References: <20211115165041.194884-1-alexandru.elisei@arm.com>
 <20211115165041.194884-4-alexandru.elisei@arm.com>
 <87czmts4rh.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87czmts4rh.wl-maz@kernel.org>
Cc: will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

Thanks for having a look!

On Sun, Nov 21, 2021 at 07:11:30PM +0000, Marc Zyngier wrote:
> On Mon, 15 Nov 2021 16:50:40 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > When KVM creates an event and there are more than one PMUs present on the
> > system, perf_init_event() will go through the list of available PMUs and
> > will choose the first one that can create the event. The order of the PMUs
> > in the PMU list depends on the probe order, which can change under various
> > circumstances, for example if the order of the PMU nodes change in the DTB
> > or if asynchronous driver probing is enabled on the kernel command line
> > (with the driver_async_probe=armv8-pmu option).
> > 
> > Another consequence of this approach is that, on heteregeneous systems,
> > all virtual machines that KVM creates will use the same PMU. This might
> > cause unexpected behaviour for userspace: when a VCPU is executing on
> > the physical CPU that uses this PMU, PMU events in the guest work
> > correctly; but when the same VCPU executes on another CPU, PMU events in
> > the guest will suddenly stop counting.
> > 
> > Fortunately, perf core allows user to specify on which PMU to create an
> > event by using the perf_event_attr->type field, which is used by
> > perf_init_event() as an index in the radix tree of available PMUs.
> > 
> > Add the KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) VCPU
> > attribute to allow userspace to specify the arm_pmu that KVM will use when
> > creating events for that VCPU. KVM will make no attempt to run the VCPU on
> > the physical CPUs that share this PMU, leaving it up to userspace to
> > manage the VCPU threads' affinity accordingly.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  Documentation/virt/kvm/devices/vcpu.rst | 25 ++++++++++++++++++++
> >  arch/arm64/include/uapi/asm/kvm.h       |  1 +
> >  arch/arm64/kvm/pmu-emul.c               | 31 +++++++++++++++++++++++--
> >  include/kvm/arm_pmu.h                   |  1 +
> >  tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
> >  5 files changed, 57 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> > index 60a29972d3f1..59ac382af59a 100644
> > --- a/Documentation/virt/kvm/devices/vcpu.rst
> > +++ b/Documentation/virt/kvm/devices/vcpu.rst
> > @@ -104,6 +104,31 @@ hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
> >  isn't strictly speaking an event. Filtering the cycle counter is possible
> >  using event 0x11 (CPU_CYCLES).
> >  
> > +1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_SET_PMU
> > +------------------------------------------
> > +
> > +:Parameters: in kvm_device_attr.addr the address to an int representing the PMU
> > +             identifier.
> > +
> > +:Returns:
> > +
> > +	 =======  ===============================================
> > +	 -EBUSY   PMUv3 already initialized
> > +	 -EFAULT  Error accessing the PMU identifier
> > +	 -EINVAL  PMU not found or PMU name longer than PAGE_SIZE
> > +	 -ENODEV  PMUv3 not supported or GIC not initialized
> > +	 -ENOMEM  Could not allocate memory
> > +	 =======  ===============================================
> > +
> > +Request that the VCPU uses the specified hardware PMU when creating guest events
> > +for the purpose of PMU emulation. The PMU identifier can be read from the "type"
> > +file for the desired PMU instance under /sys/devices (or, equivalent,
> > +/sys/bus/even_source). This attribute is particularly useful on heterogeneous
> > +systems where there are at least two PMUs on the system.
> 
> nit: CPU PMUs. A number of systems have 'uncore' PMUs which KVM
> totally ignores.

Sure, will change.

> 
> > +
> > +Note that KVM will not make any attempts to run the VCPU on the physical CPUs
> > +associated with the PMU specified by this attribute. This is entirely left to
> > +userspace.
> >  
> >  2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
> >  =================================
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index b3edde68bc3e..1d0a0a2a9711 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -362,6 +362,7 @@ struct kvm_arm_copy_mte_tags {
> >  #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> >  #define   KVM_ARM_VCPU_PMU_V3_INIT	1
> >  #define   KVM_ARM_VCPU_PMU_V3_FILTER	2
> > +#define   KVM_ARM_VCPU_PMU_V3_SET_PMU	3
> >  #define KVM_ARM_VCPU_TIMER_CTRL		1
> >  #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
> >  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index dab335d17409..53cedeb5dbf6 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -602,6 +602,7 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> >  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> >  {
> >  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct arm_pmu *arm_pmu = pmu->arm_pmu;
> >  	struct kvm_pmc *pmc;
> >  	struct perf_event *event;
> >  	struct perf_event_attr attr;
> > @@ -637,8 +638,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> >  		return;
> >  
> >  	memset(&attr, 0, sizeof(struct perf_event_attr));
> > -	attr.type = PERF_TYPE_RAW;
> > -	attr.size = sizeof(attr);
> > +	attr.type = arm_pmu ? arm_pmu->pmu.type : PERF_TYPE_RAW;
> >  	attr.pinned = 1;
> >  	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
> >  	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
> > @@ -941,6 +941,23 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
> >  	return true;
> >  }
> >  
> > +static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
> > +{
> > +	struct kvm_pmu *kvm_pmu = &vcpu->arch.pmu;
> > +	struct arm_pmu_entry *entry;
> > +	struct arm_pmu *arm_pmu;
> > +
> > +	list_for_each_entry(entry, &arm_pmus, entry) {
> > +		arm_pmu = entry->arm_pmu;
> > +		if (arm_pmu->pmu.type == pmu_id) {
> > +			kvm_pmu->arm_pmu = arm_pmu;
> > +			return 0;
> > +		}
> > +	}
> 
> How does this work when a new CPU gets hotplugged on, bringing a new
> PMU type along? It doesn't seem safe to parse this list without any
> locking.

It wouldn't work at all. I missed the fact that hotplogging a CPU means
writing to the list of PMUs after the initial driver probing which happens
at boot. This needs to be protected against concurrent writes, I will fix
it.

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
