From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm/arm64: KVM: VGIC: limit ITARGETSR bits to number
 of VCPUs
Date: Tue, 6 Dec 2016 11:21:13 +0000
Message-ID: <53aabca1-07bf-f18c-9a22-17d87e241f12@arm.com>
References: <20161116175716.31578-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8997B404BA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:20:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sAiNxLuCE-dn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 06:20:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 754C6402A3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:20:18 -0500 (EST)
In-Reply-To: <20161116175716.31578-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/11/16 17:57, Andre Przywara wrote:
> The GICv2 spec says in section 4.3.12 that a "CPU targets field bit that
> corresponds to an unimplemented CPU interface is RAZ/WI."
> Currently we allow the guest to write any value in there and it can
> read that back.
> Mask the written value with the proper CPU mask to be spec compliant.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changes v1 .. v2:
> - use GENMASK() instead of open-coding mask
> - drop explicit 0xff masking, since cpu_mask is stronger anyway
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index b44b359..78e34bc 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -129,6 +129,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>  				   unsigned long val)
>  {
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
> +	u8 cpu_mask = GENMASK(atomic_read(&vcpu->kvm->online_vcpus) - 1, 0);
>  	int i;
>  
>  	/* GICD_ITARGETSR[0-7] are read-only */
> @@ -141,7 +142,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
>  
>  		spin_lock(&irq->irq_lock);
>  
> -		irq->targets = (val >> (i * 8)) & 0xff;
> +		irq->targets = (val >> (i * 8)) & cpu_mask;
>  		target = irq->targets ? __ffs(irq->targets) : 0;
>  		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
>  
> 

Applied, thanks.

	M.
-- 
Jazz is not dead. It just smells funny...
