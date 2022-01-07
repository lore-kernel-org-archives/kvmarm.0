Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6AEC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 11:08:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2154B25A;
	Fri,  7 Jan 2022 06:08:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id amGiJBrIXW9v; Fri,  7 Jan 2022 06:08:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F8744B24F;
	Fri,  7 Jan 2022 06:08:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C244B1DB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 06:08:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QYLZxeinpx88 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 06:08:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C2A24B1D8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 06:07:59 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 587D413D5;
 Fri,  7 Jan 2022 03:07:59 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46AAC3F66F;
 Fri,  7 Jan 2022 03:07:57 -0800 (PST)
Date: Fri, 7 Jan 2022 11:08:05 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU
 attribute
Message-ID: <YdgfFa9y1CUkVC5k@monolith.localdoman>
References: <20211213152309.158462-1-alexandru.elisei@arm.com>
 <20211213152309.158462-4-alexandru.elisei@arm.com>
 <8735mvjrq8.wl-maz@kernel.org>
 <YdbYY/EZrTTPKOCp@monolith.localdoman>
 <8735m0vifv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735m0vifv.wl-maz@kernel.org>
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

On Thu, Jan 06, 2022 at 06:16:04PM +0000, Marc Zyngier wrote:
> On Thu, 06 Jan 2022 11:54:11 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Tue, Dec 14, 2021 at 12:28:15PM +0000, Marc Zyngier wrote:
> > > On Mon, 13 Dec 2021 15:23:08 +0000,
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > > >
> > > > [..]
> > > >
> > > > @@ -910,7 +922,16 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
> > > >  	init_irq_work(&vcpu->arch.pmu.overflow_work,
> > > >  		      kvm_pmu_perf_overflow_notify_vcpu);
> > > >  
> > > > -	vcpu->arch.pmu.created = true;
> > > > +	atomic_set(&vcpu->arch.pmu.created, 1);
> > > > +
> > > > +	kvm_for_each_vcpu(i, v, kvm) {
> > > > +		if (!atomic_read(&v->arch.pmu.created))
> > > > +			continue;
> > > > +
> > > > +		if (v->arch.pmu.arm_pmu != arm_pmu)
> > > > +			return -ENXIO;
> > > > +	}
> > > 
> > > If you did store the arm_pmu at the VM level, you wouldn't need this.
> > > You could detect the discrepancy in the set_pmu ioctl.
> > 
> > I chose to set at the VCPU level to be consistent with how KVM treats the
> > PMU interrupt ID when the interrupt is a PPI, where the interrupt ID must
> > be the same for all VCPUs and it is stored at the VCPU. However, looking at
> > the code again, it occurs to me that it is stored at the VCPU when it's a
> > PPI because it's simpler to do it that way, as the code remains the same
> > when the interrupt ID is a SPI, which must be *different* between VCPUs. So
> > in the end, having the PMU stored at the VM level does match how KVM uses
> > it, which looks to be better than my approach.
> > 
> > This is the change you proposed in your branch [1]:
> > 
> > +static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
> > +{
> > +       struct kvm *kvm = vcpu->kvm;
> > +       struct arm_pmu_entry *entry;
> > +       struct arm_pmu *arm_pmu;
> > +       int ret = -ENXIO;
> > +
> > +       mutex_lock(&kvm->lock);
> > +       mutex_lock(&arm_pmus_lock);
> > +
> > +       list_for_each_entry(entry, &arm_pmus, entry) {
> > +               arm_pmu = entry->arm_pmu;
> > +               if (arm_pmu->pmu.type == pmu_id) {
> > +                       /* Can't change PMU if filters are already in place */
> > +                       if (kvm->arch.arm_pmu != arm_pmu &&
> > +                           kvm->arch.pmu_filter) {
> > +                               ret = -EBUSY;
> > +                               break;
> > +                       }
> > +
> > +                       kvm->arch.arm_pmu = arm_pmu;
> > +                       ret = 0;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       mutex_unlock(&arm_pmus_lock);
> > +       mutex_unlock(&kvm->lock);
> > +       return ret;
> > +}
> > 
> > As I understand the code, userspace only needs to call
> > KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) *once* (on one VCPU
> > fd) to set the PMU for all the VCPUs; subsequent calls (on the same VCPU or
> > on another VCPU) with a different PMU id will change the PMU for all VCPUs.
> > 
> > Two remarks:
> > 
> > 1. The documentation for the VCPU ioctls states this (from
> > Documentation/virt/kvm/devices/vcpu.rst):
> > 
> > "
> > ======================
> > Generic vcpu interface
> > ======================
> > 
> > The virtual cpu "device" also accepts the ioctls KVM_SET_DEVICE_ATTR,
> > KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
> > kvm_device_attr as other devices, but **targets VCPU-wide settings and
> > controls**" (emphasis added).
> > 
> > But I guess having VCPU ioctls affect *only* the VCPU hasn't really been
> > true ever since PMU event filtering has been added. I'll send a patch to
> > change that part of the documentation for arm64.
> > 
> > I was thinking maybe a VM capability would be better suited for changing a
> > VM-wide setting, what do you think? I don't have a strong preference either
> > way.
> 
> I'm not sure it is worth the hassle of changing the API, as we'll have
> to keep the current one forever.

I was suggesting to use a capability for setting the PMU, it's too late to
change how the events filter is set.

> 
> > 
> > 2. What's to stop userspace to change the PMU after at least one VCPU has
> > run? That can be easily observed by the guest when reading PMCEIDx_EL0.
> 
> That's a good point. We need something here. It is a bit odd as to do
> that, you need to fully enable a PMU on one CPU, but not on the other,
> then run the first while changing stuff on the other. Something along
> those lines (untested):
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4bf28905d438..4f53520e84fd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -139,6 +139,7 @@ struct kvm_arch {
>  
>  	/* Memory Tagging Extension enabled for the guest */
>  	bool mte_enabled;
> +	bool ran_once;
>  };
>  
>  struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 83297fa97243..3045d7f609df 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -606,6 +606,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.has_run_once = true;
>  
> +	mutex_lock(&kvm->lock);
> +	kvm->arch.ran_once = true;
> +	mutex_unlock(&kvm->lock);
> +
>  	kvm_arm_vcpu_init_debug(vcpu);
>  
>  	if (likely(irqchip_in_kernel(kvm))) {
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index dfc0430d6418..95100c541244 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -959,8 +959,9 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  		arm_pmu = entry->arm_pmu;
>  		if (arm_pmu->pmu.type == pmu_id) {
>  			/* Can't change PMU if filters are already in place */
> -			if (kvm->arch.arm_pmu != arm_pmu &&
> -			    kvm->arch.pmu_filter) {
> +			if ((kvm->arch.arm_pmu != arm_pmu &&
> +			     kvm->arch.pmu_filter) ||
> +			    kvm->arch.ran_once) {
>  				ret = -EBUSY;
>  				break;
>  			}
> @@ -1040,6 +1041,11 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  
>  		mutex_lock(&vcpu->kvm->lock);
>  
> +		if (vcpu->kvm->arch.ran_once) {
> +			mutex_unlock(&vcpu->kvm->lock);
> +			return -EBUSY;
> +		}
> +
>  		if (!vcpu->kvm->arch.pmu_filter) {
>  			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
>  			if (!vcpu->kvm->arch.pmu_filter) {
> 
> which should prevent both PMU or filters to be changed once a single
> vcpu as run.
> 
> Thoughts?

Haven't tested it either, but it looks good to me. If you agree, I can pick
the diff, turn it into a patch and send it for the next iteration of this
series as a fix for the PMU events filter, while keeping your authorship.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
