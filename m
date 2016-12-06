From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: vgic-v2: Add the missing resetting
 LRs at boot time
Date: Tue, 6 Dec 2016 11:39:05 +0000
Message-ID: <7f920e65-a82c-e05d-1d19-8b71e06ac770@arm.com>
References: <1481006504-25460-1-git-send-email-zhaoshenglong@huawei.com>
 <1481006504-25460-3-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1551A40423
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:38:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a4dyE0SN9da6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 06:38:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D26740296
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:38:09 -0500 (EST)
In-Reply-To: <1481006504-25460-3-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/12/16 06:41, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> This is the corresponding part of commit d6400d7(KVM: arm/arm64:
> vgic-v2: Reset LRs at boot time) which is missed for new-vgic.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 9bab867..c636a19 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -300,6 +300,15 @@ int vgic_v2_map_resources(struct kvm *kvm)
>  
>  DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
>  
> +static void vgic_cpu_init_lrs(void *params)
> +{
> +	int i;
> +
> +	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++)
> +		writel_relaxed(0, kvm_vgic_global_state.vctrl_base +
> +				  GICH_LR0 + (i * 4));
> +}
> +
>  /**
>   * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
>   * @node:	pointer to the DT node
> @@ -368,6 +377,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
>  	kvm_vgic_global_state.type = VGIC_V2;
>  	kvm_vgic_global_state.max_gic_vcpus = VGIC_V2_MAX_CPUS;
>  
> +	on_each_cpu(vgic_cpu_init_lrs, NULL, 1);
> +
>  	kvm_info("vgic-v2@%llx\n", info->vctrl.start);
>  
>  	return 0;
> 

Same remark as the GICv3 version.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
