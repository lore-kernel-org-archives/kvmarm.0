From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 19/54] KVM: arm/arm64: vgic-new: Implement
Date: Tue, 3 May 2016 09:26:23 +0100
Message-ID: <572860AF.5000202@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-20-git-send-email-andre.przywara@arm.com>
 <57274715.8080801@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B151349B81
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 04:23:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id abLeRonSxTAx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2016 04:23:21 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DACF407A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 04:23:21 -0400 (EDT)
In-Reply-To: <57274715.8080801@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 02/05/16 13:24, Eric Auger wrote:
> Hi Andre,
> 
> minor comment: patch title has been altered since v1, should be
> 
> KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq

Indeed, that was line-broken accidentally when I added the Changelog.
Thanks for pointing out!

Cheers,
Andre.

> On 04/28/2016 06:45 PM, Andre Przywara wrote:
>> From: Eric Auger <eric.auger@linaro.org>
>>
>> Tell KVM whether a particular VCPU has an IRQ that needs handling
>> in the guest. This is used to decide whether a VCPU is runnable.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - return false if distributor is disabled
>> - add vgic_kick_vcpus() implementations
>>
>>  include/kvm/vgic/vgic.h  |  2 ++
>>  virt/kvm/arm/vgic/vgic.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h |  1 +
>>  3 files changed, 43 insertions(+)
>>
>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>> index 5fae4a9..2615205 100644
>> --- a/include/kvm/vgic/vgic.h
>> +++ b/include/kvm/vgic/vgic.h
>> @@ -184,6 +184,8 @@ struct vgic_cpu {
>>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  			bool level);
>>  
>> +int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>> +
>>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>>  #define vgic_initialized(k)	(false)
>>  #define vgic_ready(k)		((k)->arch.vgic.ready)
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index ae52928..eeb766e 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -519,3 +519,43 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>>  	vgic_flush_lr_state(vcpu);
>>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
>>  }
>> +
>> +int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_irq *irq;
>> +	bool pending = false;
>> +
>> +	if (!vcpu->kvm->arch.vgic.enabled)
>> +		return false;
>> +
>> +	spin_lock(&vgic_cpu->ap_list_lock);
>> +
>> +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
>> +		spin_lock(&irq->irq_lock);
>> +		pending = irq->pending && irq->enabled;
>> +		spin_unlock(&irq->irq_lock);
>> +
>> +		if (pending)
>> +			break;
>> +	}
>> +
>> +	spin_unlock(&vgic_cpu->ap_list_lock);
>> +
>> +	return pending;
>> +}
>> +
>> +void vgic_kick_vcpus(struct kvm *kvm)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	int c;
>> +
>> +	/*
>> +	 * We've injected an interrupt, time to find out who deserves
>> +	 * a good kick...
>> +	 */
>> +	kvm_for_each_vcpu(c, vcpu, kvm) {
>> +		if (kvm_vgic_vcpu_pending_irq(vcpu))
>> +			kvm_vcpu_kick(vcpu);
>> +	}
>> +}
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 81b1a20..0c92cda 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -21,6 +21,7 @@
>>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>  			      u32 intid);
>>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
>> +void vgic_kick_vcpus(struct kvm *kvm);
>>  
>>  void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
>>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>>
> 
