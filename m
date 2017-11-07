From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 08/26] KVM: arm/arm64: GICv4: Add property field and
 per-VM predicate
Date: Tue, 7 Nov 2017 21:30:47 +0100
Message-ID: <390426aa-7c73-641c-3ba7-937882e085df@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 332E849D20
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 15:28:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QMIHET371P8n for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 15:28:57 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37C2C49D14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 15:28:57 -0500 (EST)
In-Reply-To: <20171027142855.21584-9-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 27/10/2017 16:28, Marc Zyngier wrote:
> Add a new has_gicv4 field in the global VGIC state that indicates
> whether the HW is GICv4 capable, as a per-VM predicate indicating
> if there is a possibility for a VM to support direct injection
> (the above being true and the VM having an ITS).
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  include/kvm/arm_vgic.h           | 3 +++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 5 +++++
>  virt/kvm/arm/vgic/vgic.h         | 2 ++
>  3 files changed, 10 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 53f631bdec75..ba9fb450aa1b 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -73,6 +73,9 @@ struct vgic_global {
>  	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
>  	bool			can_emulate_gicv2;
>  
> +	/* Hardware has GICv4? */
> +	bool			has_gicv4;
> +
>  	/* GIC system register CPU interface */
>  	struct static_key_false gicv3_cpuif;
>  
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 408ef06638fc..f87fd17b2eb9 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -54,6 +54,11 @@ bool vgic_has_its(struct kvm *kvm)
>  	return dist->has_its;
>  }
>  
> +bool vgic_supports_direct_msis(struct kvm *kvm)
> +{
> +	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> +}
> +
>  static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>  					    gpa_t addr, unsigned int len)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 31b70326b966..e67ccb6a6250 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -240,4 +240,6 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
>  
> +bool vgic_supports_direct_msis(struct kvm *kvm);
> +
>  #endif
> 
