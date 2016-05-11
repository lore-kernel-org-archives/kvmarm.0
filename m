From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3a] KVM: arm/arm64: pmu: abstract access to number of SPIs
Date: Wed, 11 May 2016 14:52:49 +0100
Message-ID: <57333931.6050206@arm.com>
References: <5731AF57.2040707@linaro.org>
 <1462890906-6134-1-git-send-email-andre.przywara@arm.com>
 <20160510145832.cv3ozila3kisije6@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B4848531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:49:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DmvyXG6fwbjQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:49:21 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C660F4113E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:49:21 -0400 (EDT)
In-Reply-To: <20160510145832.cv3ozila3kisije6@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On 10/05/16 15:58, Andrew Jones wrote:
> On Tue, May 10, 2016 at 03:35:06PM +0100, Andre Przywara wrote:
>> Currently the PMU uses a member of the struct vgic_dist directly,
>> which not only breaks abstraction, but will fail with the new VGIC.
>> Abstract this access in the VGIC header file.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Hi Eric, Marc,
>>
>> as this if-statement was quite confusing (it wasn't even the negation
>> that was wrong), I rewrote it a bit to be more readable.
>> This one works now with PPIs (after fixing kvmtool).
>>
>> Does that make sense?
>>
>> Cheers,
>> Andre.
>>
>>  include/kvm/arm_vgic.h |  2 ++
>>  virt/kvm/arm/pmu.c     | 19 +++++++++++--------
>>  2 files changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 6a98e05..d406f8e 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -351,6 +351,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
>>  #define vgic_ready(k)		((k)->arch.vgic.ready)
>> +#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
>> +				 ((i) < (k)->arch.vgic.nr_irqs))
>>  
>>  int vgic_v2_probe(struct device_node *vgic_node,
>>  		  const struct vgic_ops **ops,
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index 575c7aa..6ab9d6b 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -436,6 +436,11 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * For one VM the interrupt type must be same for each vcpu.
>> + * As a PPI, the interrupt number is the same for all vcpus,
>> + * while as an SPI it must be a separate number per vcpu.
>> + */
>>  static bool irq_is_valid(struct kvm *kvm, int irq, bool is_ppi)
> 
> While at it, I'd change this function name to have 'pmu' in it. It's
> just a static function, but without pmu in it it looks a bit confusing
> now to check the irq is [a valid] spi or ppi number, and then to call
> the generically named 'irq_is_valid' on it as well.

Yes, indeed. Did that in the new series.

Thanks!
Andre.
