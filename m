From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: vgic: Don't populate multiple LRs
 with the same vintid
Date: Wed, 7 Mar 2018 14:44:12 +0000
Message-ID: <ac9ecbfb-4641-b608-a992-76f7e0f57164@arm.com>
References: <20180307124055.13800-1-marc.zyngier@arm.com>
 <20180307124055.13800-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180307124055.13800-2-marc.zyngier@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 07/03/18 12:40, Marc Zyngier wrote:
> The vgic code is trying to be clever when injecting GICv2 SGIs,
> and will happily populate LRs with the same interrupt number if
> they come from multiple vcpus (after all, they are distinct
> interrupt sources).
> 
> Unfortunately, this is against the letter of the architecture,
> and the GICv2 architecture spec says "Each valid interrupt stored
> in the List registers must have a unique VirtualID for that
> virtual CPU interface.". GICv3 has similar (although slightly
> ambiguous) restrictions.

Ah, good catch. I was silently assuming that this "unique interrupt"
restriction was including the source ID, but fair enough.

> This results in guests locking up when using GICv2-on-GICv3, for
> example. The obvious fix is to stop trying so hard, and inject
> a single vcpu per SGI per guest entry. After all, pending SGIs
> with multiple source vcpus are pretty rare, and are mostly seen
> in scenario where the physical CPUs are severely overcomitted.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks!
Andre.

> ---
>  virt/kvm/arm/vgic/vgic.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index c7c5ef190afa..1f7ff175f47b 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -720,18 +720,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>  	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
>  		spin_lock(&irq->irq_lock);
>  
> -		if (unlikely(vgic_target_oracle(irq) != vcpu))
> -			goto next;
> -
> -		/*
> -		 * If we get an SGI with multiple sources, try to get
> -		 * them in all at once.
> -		 */
> -		do {
> +		if (likely(vgic_target_oracle(irq) == vcpu))
>  			vgic_populate_lr(vcpu, irq, count++);
> -		} while (irq->source && count < kvm_vgic_global_state.nr_lr);
>  
> -next:
>  		spin_unlock(&irq->irq_lock);
>  
>  		if (count == kvm_vgic_global_state.nr_lr) {
> 
