From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/4] kvm: arm/arm64: vgic-v2: Add GICH_APR accessors for
 GICv2
Date: Thu, 6 Jul 2017 17:13:52 +0100
Message-ID: <33bd7cd2-b49e-187b-b2fc-d020ff35aeb6@arm.com>
References: <1499253809-17584-1-git-send-email-wanghaibin.wang@huawei.com>
 <1499253809-17584-2-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16DB140D55
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jul 2017 12:13:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TTWQGB3izHGH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jul 2017 12:13:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2503940D4A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jul 2017 12:13:29 -0400 (EDT)
In-Reply-To: <1499253809-17584-2-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>, cdall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 05/07/17 12:23, wanghaibin wrote:
> For GICv2, there are at most 5 priority bits are implemented in
> GICH_LR<n>.Priority, so we only need to be concerned with GICH_APR0.
> The other GICH_APRn access can be treated as raz/wi.

What is this "other" GICH_APRn?

> 
> Attention: This patch is untest!
> 
> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 21 +++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h    |  2 ++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index e4187e5..11d3b73 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -172,6 +172,27 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = 0;
>  }
>  
> +void vgic_v2_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
> +{
> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> +
> +	if (idx == 0)
> +		cpu_if->vgic_apr = val;
> +	else
> +		WARN_ON(val);

If treated as WI, why do you WARN here? Also, given that there is only
one register for the active priorities, I don't really see the point in
having this "idx" parameter.

> +}
> +
> +u32 vgic_v2_get_apr(struct kvm_vcpu *vcpu, u32 idx)
> +{
> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> +
> +	if (idx == 0)
> +		return cpu_if->vgic_apr;
> +	else
> +		return 0;
> +}
> +
> +

Extra whitespace.

>  void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  {
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index bba7fa2..8791b9a 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -155,6 +155,8 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
>  int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			  int offset, u32 *val);
> +void vgic_v2_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val);
> +u32 vgic_v2_get_apr(struct kvm_vcpu *vcpu, u32 idx);
>  void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v2_enable(struct kvm_vcpu *vcpu);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
