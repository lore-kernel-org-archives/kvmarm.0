From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 4/8] KVM: arm/arm64: vgic: restructure
 kvm_vgic_(un)map_phys_irq
Date: Tue, 22 Aug 2017 16:33:53 +0200
Message-ID: <95d92957-4a09-b833-8a5c-c653582bf0cd@redhat.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-5-git-send-email-eric.auger@redhat.com>
 <20170721114439.GE16350@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170721114439.GE16350@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 21/07/2017 13:44, Christoffer Dall wrote:
> On Thu, Jun 15, 2017 at 02:52:36PM +0200, Eric Auger wrote:
>> We want to reuse the core of the map/unmap functions for IRQ
>> forwarding. Let's move the computation of the hwirq in
>> kvm_vgic_map_phys_irq and pass the linux IRQ as parameter.
>> the host_irq is added to struct vgic_irq.
>>
>> We introduce kvm_vgic_map/unmap_irq which take a struct vgic_irq
>> handle as a parameter.
> 
> So this is to avoid the linux-to-hardware irq number translation in
> other callers?
Yes that's correct. Also forwarding code caller needs to hold the lock,
reason why I pass a vgic_irq as a param.
> 
> I am sort of guessing that we need to store the host_irq number so that
> we can probe into the physical GIC in later patches?  That may be good
> to note in this commit message if you respin.
done

Thanks

Eric
> 
> Thanks,
> -Christoffer
> 
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  include/kvm/arm_vgic.h    |  8 ++++---
>>  virt/kvm/arm/arch_timer.c | 24 +------------------
>>  virt/kvm/arm/vgic/vgic.c  | 60 +++++++++++++++++++++++++++++++++++------------
>>  3 files changed, 51 insertions(+), 41 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index ef71858..cceb31d 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -112,6 +112,7 @@ struct vgic_irq {
>>  	bool hw;			/* Tied to HW IRQ */
>>  	struct kref refcount;		/* Used for LPIs */
>>  	u32 hwintid;			/* HW INTID number */
>> +	unsigned int host_irq;		/* linux irq corresponding to hwintid */
>>  	union {
>>  		u8 targets;			/* GICv2 target VCPUs mask */
>>  		u32 mpidr;			/* GICv3 target VCPU */
>> @@ -301,9 +302,10 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  			bool level);
>>  int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  			       bool level);
>> -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
>> -int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>> -bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
>> +			  u32 vintid);
>> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
>> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
>>  
>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>>  
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index 5976609..57a30ab 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -617,9 +617,6 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>  {
>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> -	struct irq_desc *desc;
>> -	struct irq_data *data;
>> -	int phys_irq;
>>  	int ret;
>>  
>>  	if (timer->enabled)
>> @@ -632,26 +629,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>>  	if (!vgic_initialized(vcpu->kvm))
>>  		return -ENODEV;
>>  
>> -	/*
>> -	 * Find the physical IRQ number corresponding to the host_vtimer_irq
>> -	 */
>> -	desc = irq_to_desc(host_vtimer_irq);
>> -	if (!desc) {
>> -		kvm_err("%s: no interrupt descriptor\n", __func__);
>> -		return -EINVAL;
>> -	}
>> -
>> -	data = irq_desc_get_irq_data(desc);
>> -	while (data->parent_data)
>> -		data = data->parent_data;
>> -
>> -	phys_irq = data->hwirq;
>> -
>> -	/*
>> -	 * Tell the VGIC that the virtual interrupt is tied to a
>> -	 * physical interrupt. We do that once per VCPU.
>> -	 */
>> -	ret = kvm_vgic_map_phys_irq(vcpu, vtimer->irq.irq, phys_irq);
>> +	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq);
>>  	if (ret)
>>  		return ret;
>>  
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index 83b24d2..075f073 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -17,6 +17,8 @@
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  #include <linux/list_sort.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>>  
>>  #include "vgic.h"
>>  
>> @@ -392,38 +394,66 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  	return 0;
>>  }
>>  
>> -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
>> +/* @irq->irq_lock must be held */
>> +static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>> +			    unsigned int host_irq)
>>  {
>> -	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
>> +	struct irq_desc *desc;
>> +	struct irq_data *data;
>>  
>> -	BUG_ON(!irq);
>> -
>> -	spin_lock(&irq->irq_lock);
>> +	/*
>> +	 * Find the physical IRQ number corresponding to @host_irq
>> +	 */
>> +	desc = irq_to_desc(host_irq);
>> +	if (!desc) {
>> +		kvm_err("%s: no interrupt descriptor\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +	data = irq_desc_get_irq_data(desc);
>> +	while (data->parent_data)
>> +		data = data->parent_data;
>>  
>>  	irq->hw = true;
>> -	irq->hwintid = phys_irq;
>> +	irq->host_irq = host_irq;
>> +	irq->hwintid = data->hwirq;
>> +	return 0;
>> +}
>> +
>> +/* @irq->irq_lock must be held */
>> +static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
>> +{
>> +	irq->hw = false;
>> +	irq->hwintid = 0;
>> +}
>> +
>> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
>> +			  u32 vintid)
>> +{
>> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
>> +	int ret;
>>  
>> +	BUG_ON(!irq);
>> +
>> +	spin_lock(&irq->irq_lock);
>> +	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
>>  	spin_unlock(&irq->irq_lock);
>>  	vgic_put_irq(vcpu->kvm, irq);
>>  
>> -	return 0;
>> +	return ret;
>>  }
>>  
>> -int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
>>  {
>>  	struct vgic_irq *irq;
>>  
>>  	if (!vgic_initialized(vcpu->kvm))
>>  		return -EAGAIN;
>>  
>> -	irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
>> +	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
>>  	BUG_ON(!irq);
>>  
>>  	spin_lock(&irq->irq_lock);
>> -
>> -	irq->hw = false;
>> -	irq->hwintid = 0;
>> -
>> +	kvm_vgic_unmap_irq(irq);
>>  	spin_unlock(&irq->irq_lock);
>>  	vgic_put_irq(vcpu->kvm, irq);
>>  
>> @@ -726,9 +756,9 @@ void vgic_kick_vcpus(struct kvm *kvm)
>>  	}
>>  }
>>  
>> -bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
>>  {
>> -	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
>> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
>>  	bool map_is_active;
>>  
>>  	spin_lock(&irq->irq_lock);
>> -- 
>> 2.5.5
>>
