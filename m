Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845CAC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 11:54:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4D3B4B1D0;
	Thu,  6 Jan 2022 06:54:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CjjKHMatqadw; Thu,  6 Jan 2022 06:54:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5E44B162;
	Thu,  6 Jan 2022 06:54:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E3EB4B132
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 06:54:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vpT+bc9V0TEd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jan 2022 06:54:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD9B4B126
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 06:54:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 023F012FC;
 Thu,  6 Jan 2022 03:54:06 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E42E13F774;
 Thu,  6 Jan 2022 03:54:03 -0800 (PST)
Date: Thu, 6 Jan 2022 11:54:11 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU
 attribute
Message-ID: <YdbYY/EZrTTPKOCp@monolith.localdoman>
References: <20211213152309.158462-1-alexandru.elisei@arm.com>
 <20211213152309.158462-4-alexandru.elisei@arm.com>
 <8735mvjrq8.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735mvjrq8.wl-maz@kernel.org>
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

On Tue, Dec 14, 2021 at 12:28:15PM +0000, Marc Zyngier wrote:
> On Mon, 13 Dec 2021 15:23:08 +0000,
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
> > Setting the PMU for a VCPU is an all of nothing affair to avoid exposing an
> > asymmetric system to the guest: either all VCPUs have the same PMU, either
> > none of the VCPUs have a PMU set. Attempting to do something in between
> > will result in an error being returned when doing KVM_ARM_VCPU_PMU_V3_INIT.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> > 
> > Checking that all VCPUs have the same PMU is done when the PMU is
> > initialized because setting the VCPU PMU is optional, and KVM cannot know
> > what the user intends until the KVM_ARM_VCPU_PMU_V3_INIT ioctl, which
> > prevents further changes to the VCPU PMU. vcpu->arch.pmu.created has been
> > changed to an atomic variable because changes to the VCPU PMU state now
> > need to be observable by all physical CPUs.
> > 
> >  Documentation/virt/kvm/devices/vcpu.rst | 30 ++++++++-
> >  arch/arm64/include/uapi/asm/kvm.h       |  1 +
> >  arch/arm64/kvm/pmu-emul.c               | 88 ++++++++++++++++++++-----
> >  include/kvm/arm_pmu.h                   |  4 +-
> >  tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
> >  5 files changed, 104 insertions(+), 20 deletions(-)
> > 
> > [..]
> > -static u32 kvm_pmu_event_mask(struct kvm *kvm)
> > +static u32 kvm_pmu_event_mask(struct kvm_vcpu *vcpu)
> >  {
> > -	switch (kvm->arch.pmuver) {
> > +	unsigned int pmuver;
> > +
> > +	if (vcpu->arch.pmu.arm_pmu)
> > +		pmuver = vcpu->arch.pmu.arm_pmu->pmuver;
> > +	else
> > +		pmuver = vcpu->kvm->arch.pmuver;
> 
> This puzzles me throughout the whole patch. Why is the arm_pmu pointer
> a per-CPU thing? I would absolutely expect it to be stored in the kvm
> structure, making the whole thing much simpler.

Reply below.

> 
> > [..]
> > @@ -637,8 +645,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> >  		return;
> >  
> >  	memset(&attr, 0, sizeof(struct perf_event_attr));
> > -	attr.type = PERF_TYPE_RAW;
> > -	attr.size = sizeof(attr);
> 
> Why is this line removed?

Typo on my part, thank you for spotting it.

> 
> > [..]
> > @@ -910,7 +922,16 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
> >  	init_irq_work(&vcpu->arch.pmu.overflow_work,
> >  		      kvm_pmu_perf_overflow_notify_vcpu);
> >  
> > -	vcpu->arch.pmu.created = true;
> > +	atomic_set(&vcpu->arch.pmu.created, 1);
> > +
> > +	kvm_for_each_vcpu(i, v, kvm) {
> > +		if (!atomic_read(&v->arch.pmu.created))
> > +			continue;
> > +
> > +		if (v->arch.pmu.arm_pmu != arm_pmu)
> > +			return -ENXIO;
> > +	}
> 
> If you did store the arm_pmu at the VM level, you wouldn't need this.
> You could detect the discrepancy in the set_pmu ioctl.

I chose to set at the VCPU level to be consistent with how KVM treats the
PMU interrupt ID when the interrupt is a PPI, where the interrupt ID must
be the same for all VCPUs and it is stored at the VCPU. However, looking at
the code again, it occurs to me that it is stored at the VCPU when it's a
PPI because it's simpler to do it that way, as the code remains the same
when the interrupt ID is a SPI, which must be *different* between VCPUs. So
in the end, having the PMU stored at the VM level does match how KVM uses
it, which looks to be better than my approach.

This is the change you proposed in your branch [1]:

+static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
+{
+       struct kvm *kvm = vcpu->kvm;
+       struct arm_pmu_entry *entry;
+       struct arm_pmu *arm_pmu;
+       int ret = -ENXIO;
+
+       mutex_lock(&kvm->lock);
+       mutex_lock(&arm_pmus_lock);
+
+       list_for_each_entry(entry, &arm_pmus, entry) {
+               arm_pmu = entry->arm_pmu;
+               if (arm_pmu->pmu.type == pmu_id) {
+                       /* Can't change PMU if filters are already in place */
+                       if (kvm->arch.arm_pmu != arm_pmu &&
+                           kvm->arch.pmu_filter) {
+                               ret = -EBUSY;
+                               break;
+                       }
+
+                       kvm->arch.arm_pmu = arm_pmu;
+                       ret = 0;
+                       break;
+               }
+       }
+
+       mutex_unlock(&arm_pmus_lock);
+       mutex_unlock(&kvm->lock);
+       return ret;
+}

As I understand the code, userspace only needs to call
KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) *once* (on one VCPU
fd) to set the PMU for all the VCPUs; subsequent calls (on the same VCPU or
on another VCPU) with a different PMU id will change the PMU for all VCPUs.

Two remarks:

1. The documentation for the VCPU ioctls states this (from
Documentation/virt/kvm/devices/vcpu.rst):

"
======================
Generic vcpu interface
======================

The virtual cpu "device" also accepts the ioctls KVM_SET_DEVICE_ATTR,
KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
kvm_device_attr as other devices, but **targets VCPU-wide settings and
controls**" (emphasis added).

But I guess having VCPU ioctls affect *only* the VCPU hasn't really been
true ever since PMU event filtering has been added. I'll send a patch to
change that part of the documentation for arm64.

I was thinking maybe a VM capability would be better suited for changing a
VM-wide setting, what do you think? I don't have a strong preference either
way.

2. What's to stop userspace to change the PMU after at least one VCPU has
run? That can be easily observed by the guest when reading PMCEIDx_EL0.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-bl

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
