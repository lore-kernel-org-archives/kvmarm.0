From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 50/54] KVM: arm/arm64: vgic-new: vgic_init: implement
 map_resources
Date: Tue, 3 May 2016 11:47:37 +0100
Message-ID: <572881C9.300@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-51-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-51-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/04/16 17:46, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> map_resources is the last initialization step. It is executed on
> 1st VCPU run. At that stage the code checks the userspace has provided
> the base addresses for the relevant VGIC regions, which depend on
> the type of VGIC that is exposed to the guest.
> 
> The function also forces the vgic_init if it has not been executed yet
> (only allowed for VGIC v2).
> 
> for GICv2, The VGIC CPU interface is mapped onto the GIC virtual CPU
> interface.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h       |  1 +
>  virt/kvm/arm/vgic/vgic-init.c | 27 +++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v2.c   | 47 +++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c   | 44 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h      | 16 +++++++++++++++
>  5 files changed, 135 insertions(+)

[...]

> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 444210f..f970e3e 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -43,6 +43,9 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v2_enable(struct kvm_vcpu *vcpu);
>  int vgic_v2_probe(struct device_node *vgic_node);
> +int vgic_v2_map_resources(struct kvm *kvm);
> +int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
> +			     enum vgic_type);
>  
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
> @@ -54,6 +57,8 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v3_enable(struct kvm_vcpu *vcpu);
>  int vgic_v3_probe(struct device_node *vgic_node);
> +int vgic_v3_map_resources(struct kvm *kvm);
> +int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> @@ -94,6 +99,17 @@ static inline int vgic_v3_probe(struct device_node *vgic_node)
>  {
>  	return -ENODEV;
>  }
> +
> +static inline int vgic_v3_map_resources(struct kvm *kvm)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int vgic_register_redist_iodevs(struct kvm *kvm,
> +					      gpa_t dist_base_address)
> +{
> +	return -ENODEV;
> +}

It would make sense to move this stub to patch 32, where the non-stub
implementation is.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
