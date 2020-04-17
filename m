Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A83C352BE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 16:27:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A987F2083E
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 16:27:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A987F2083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF2164B22B;
	Fri, 17 Apr 2020 12:27:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J27nV2j22IP5; Fri, 17 Apr 2020 12:27:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 386A64B21A;
	Fri, 17 Apr 2020 12:27:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 033584B210
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 12:27:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xM3X6m9fJRbn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 12:27:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6324B20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 12:27:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A159AC14;
 Fri, 17 Apr 2020 09:27:29 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B55C3F73D;
 Fri, 17 Apr 2020 09:27:28 -0700 (PDT)
Subject: Re: [PATCH v2 2/6] KVM: arm: vgic: Synchronize the whole guest on
 GIC{D,R}_I{S,C}ACTIVER read
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <20200417083319.3066217-1-maz@kernel.org>
 <20200417083319.3066217-3-maz@kernel.org>
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <321c946b-7ca1-e422-2c86-3ab121633549@arm.com>
Date: Fri, 17 Apr 2020 17:26:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200417083319.3066217-3-maz@kernel.org>
Content-Language: en-US
Cc: Julien Grall <julien@xen.org>
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

On 17/04/2020 09:33, Marc Zyngier wrote:
> When a guest tries to read the active state of its interrupts,
> we currently just return whatever state we have in memory. This
> means that if such an interrupt lives in a List Register on another
> CPU, we fail to obsertve the latest active state for this interrupt.
> 
> In order to remedy this, stop all the other vcpus so that they exit
> and we can observe the most recent value for the state. This is
> similar to what we are doing for the write side of the same
> registers, and results in new MMIO handlers for userspace (which
> do not need to stop the guest, as it is supposed to be stopped
> already).

Thanks for the changes! Checked for other users of VGIC_NR_PRIVATE_IRQS,
also for not missing other ACTIVE bit register handlers.
Looks good to me!

> 
> Reported-by: Julien Grall <julien@xen.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c |  12 ++--
>  virt/kvm/arm/vgic/vgic-mmio.c    | 100 ++++++++++++++++++++-----------
>  virt/kvm/arm/vgic/vgic-mmio.h    |   3 +
>  4 files changed, 75 insertions(+), 44 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index 5945f062d749..d63881f60e1a 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -422,11 +422,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
>  		vgic_mmio_read_active, vgic_mmio_write_cactive,
> -		NULL, vgic_mmio_uaccess_write_cactive, 1,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
>  		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index e72dcc454247..f2b37a081f26 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -553,11 +553,11 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> -		NULL, vgic_mmio_uaccess_write_sactive, 1,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
>  		vgic_mmio_read_active, vgic_mmio_write_cactive,
> -		NULL, vgic_mmio_uaccess_write_cactive,
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive,
>  		1, VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
>  		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> @@ -625,12 +625,12 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISACTIVER0,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> -		NULL, vgic_mmio_uaccess_write_sactive,
> -		4, VGIC_ACCESS_32bit),
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 4,
> +		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICACTIVER0,
>  		vgic_mmio_read_active, vgic_mmio_write_cactive,
> -		NULL, vgic_mmio_uaccess_write_cactive,
> -		4, VGIC_ACCESS_32bit),
> +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 4,
> +		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_IPRIORITYR0,
>  		vgic_mmio_read_priority, vgic_mmio_write_priority, 32,
>  		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index d085e047953f..b38e94e8f74a 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -348,8 +348,39 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> -unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> -				    gpa_t addr, unsigned int len)
> +
> +/*
> + * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
> + * is not queued on some running VCPU's LRs, because then the change to the
> + * active state can be overwritten when the VCPU's state is synced coming back
> + * from the guest.
> + *
> + * For shared interrupts as well as GICv3 private interrupts, we have to
> + * stop all the VCPUs because interrupts can be migrated while we don't hold
> + * the IRQ locks and we don't want to be chasing moving targets.
> + *
> + * For GICv2 private interrupts we don't have to do anything because
> + * userspace accesses to the VGIC state already require all VCPUs to be
> + * stopped, and only the VCPU itself can modify its private interrupts
> + * active state, which guarantees that the VCPU is not running.
> + */
> +static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> +	    intid >= VGIC_NR_PRIVATE_IRQS)
> +		kvm_arm_halt_guest(vcpu->kvm);
> +}
> +
> +/* See vgic_access_active_prepare */
> +static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
> +{
> +	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> +	    intid >= VGIC_NR_PRIVATE_IRQS)
> +		kvm_arm_resume_guest(vcpu->kvm);
> +}
> +
> +static unsigned long __vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> +					     gpa_t addr, unsigned int len)
>  {
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	u32 value = 0;
> @@ -359,6 +390,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < len * 8; i++) {
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
> +		/*
> +		 * Even for HW interrupts, don't evaluate the HW state as
> +		 * all the guest is interested in is the virtual state.
> +		 */
>  		if (irq->active)
>  			value |= (1U << i);
>  
> @@ -368,6 +403,29 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	u32 val;
> +
> +	mutex_lock(&vcpu->kvm->lock);
> +	vgic_access_active_prepare(vcpu, intid);
> +
> +	val = __vgic_mmio_read_active(vcpu, addr, len);
> +
> +	vgic_access_active_finish(vcpu, intid);
> +	mutex_unlock(&vcpu->kvm->lock);
> +
> +	return val;
> +}
> +
> +unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len)
> +{
> +	return __vgic_mmio_read_active(vcpu, addr, len);
> +}
> +
>  /* Must be called with irq->irq_lock held */
>  static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  				      bool active, bool is_uaccess)
> @@ -426,36 +484,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  }
>  
> -/*
> - * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
> - * is not queued on some running VCPU's LRs, because then the change to the
> - * active state can be overwritten when the VCPU's state is synced coming back
> - * from the guest.
> - *
> - * For shared interrupts, we have to stop all the VCPUs because interrupts can
> - * be migrated while we don't hold the IRQ locks and we don't want to be
> - * chasing moving targets.
> - *
> - * For private interrupts we don't have to do anything because userspace
> - * accesses to the VGIC state already require all VCPUs to be stopped, and
> - * only the VCPU itself can modify its private interrupts active state, which
> - * guarantees that the VCPU is not running.
> - */
> -static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
> -{
> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> -	    intid >= VGIC_NR_PRIVATE_IRQS)
> -		kvm_arm_halt_guest(vcpu->kvm);
> -}
> -
> -/* See vgic_change_active_prepare */
> -static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
> -{
> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> -	    intid >= VGIC_NR_PRIVATE_IRQS)
> -		kvm_arm_resume_guest(vcpu->kvm);
> -}
> -
>  static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>  				      gpa_t addr, unsigned int len,
>  				      unsigned long val)
> @@ -477,11 +505,11 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  
>  	mutex_lock(&vcpu->kvm->lock);
> -	vgic_change_active_prepare(vcpu, intid);
> +	vgic_access_active_prepare(vcpu, intid);
>  
>  	__vgic_mmio_write_cactive(vcpu, addr, len, val);
>  
> -	vgic_change_active_finish(vcpu, intid);
> +	vgic_access_active_finish(vcpu, intid);
>  	mutex_unlock(&vcpu->kvm->lock);
>  }
>  
> @@ -514,11 +542,11 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  
>  	mutex_lock(&vcpu->kvm->lock);
> -	vgic_change_active_prepare(vcpu, intid);
> +	vgic_access_active_prepare(vcpu, intid);
>  
>  	__vgic_mmio_write_sactive(vcpu, addr, len, val);
>  
> -	vgic_change_active_finish(vcpu, intid);
> +	vgic_access_active_finish(vcpu, intid);
>  	mutex_unlock(&vcpu->kvm->lock);
>  }
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 5af2aefad435..30713a44e3fa 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -152,6 +152,9 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  				    gpa_t addr, unsigned int len);
>  
> +unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len);
> +
>  void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
>  			     gpa_t addr, unsigned int len,
>  			     unsigned long val);
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
