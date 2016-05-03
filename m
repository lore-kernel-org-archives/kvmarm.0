From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 17/54] KVM: arm/arm64: vgic-new: Add GICv2 world switch
 backend
Date: Tue, 3 May 2016 09:26:40 +0100
Message-ID: <572860C0.2030407@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-18-git-send-email-andre.przywara@arm.com>
 <20160502131637.054b6b23@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C63BE49B8D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 04:23:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sIlCrVDSVBH1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2016 04:23:38 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C170B49B81
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 04:23:38 -0400 (EDT)
In-Reply-To: <20160502131637.054b6b23@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/05/16 13:16, Marc Zyngier wrote:
> On Thu, 28 Apr 2016 17:45:36 +0100
> Andre Przywara <andre.przywara@arm.com> wrote:
> 
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Processing maintenance interrupts and accessing the list registers
>> are dependent on the host's GIC version.
>> Introduce vgic-v2.c to contain GICv2 specific functions.
>> Implement the GICv2 specific code for syncing the emulation state
>> into the VGIC registers.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - remove explicit LR_STATE clearing on maintenance interrupt handling
>> - improve documentation for vgic_v2_populate_lr()
>> - remove WARN_ON on non-edge IRQs in maintenance interrupts
>> - simplify multi-CPU source SGI handling
>>
>> Changelog v1 .. v2:
>> - inject the IRQ priority into the list register
>>
>>  include/linux/irqchip/arm-gic.h |   1 +
>>  virt/kvm/arm/vgic/vgic-v2.c     | 178 ++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.c        |  19 ++---
>>  virt/kvm/arm/vgic/vgic.h        |   6 ++
>>  4 files changed, 194 insertions(+), 10 deletions(-)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-v2.c
>>
> 
> [...]
> 
>> @@ -441,14 +447,12 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
>>  static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> -	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> -	u32 model = dist->vgic_model;
>>  	struct vgic_irq *irq;
>>  	int count = 0;
>>  
>>  	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(vgic_cpu->ap_list_lock));
>>  
>> -	if (unlikely(!dist->enabled))
>> +	if (unlikely(!vcpu->kvm->arch.vgic.enabled))
>>  		goto out_clean;
>>  
>>  	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr) {
>> @@ -466,14 +470,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>>  		 * If we get an SGI with multiple sources, try to get
>>  		 * them in all at once.
>>  		 */
>> -		if (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
>> -		    vgic_irq_is_sgi(irq->intid)) {
>> -			while (irq->source &&
>> -			       count < kvm_vgic_global_state.nr_lr)
>> -				vgic_populate_lr(vcpu, irq, count++);
>> -		} else {
>> +		do {
>>  			vgic_populate_lr(vcpu, irq, count++);
>> -		}
>> +		} while (irq->source && count < kvm_vgic_global_state.nr_lr);
>>  
>>  next:
> 
> Most, if not all of the changes in this function should be folded in the
> previous patch, as we only have generic code in this file (this looks
> like a leftover from an earlier rework).

Oh dear, you are totally right. Sorry for the mess!

Will fix it!

Cheers,
Andre.
