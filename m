From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix vgic init race
Date: Mon, 9 Jul 2018 11:51:37 +0100
Message-ID: <edb65498-080b-f492-d841-024968ab4f8b@arm.com>
References: <1530653175-11999-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4CE349FAC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 06:39:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vJb2PkiRoSPM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jul 2018 06:38:59 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A6FC4086E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 06:38:59 -0400 (EDT)
In-Reply-To: <1530653175-11999-1-git-send-email-christoffer.dall@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/07/18 22:26, Christoffer Dall wrote:
> The vgic_init function can race with kvm_arch_vcpu_create() which does
> not hold kvm_lock() and we therefore have no synchronization primitives
> to ensure we're doing the right thing.
> 
> As the user is trying to initialize or run the VM while at the same time
> creating more VCPUs, we just have to refuse to initialize the VGIC in
> this case rather than silently failing with a broken VCPU.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 9406eaf..c0c0b88 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -286,6 +286,10 @@ int vgic_init(struct kvm *kvm)
>  	if (vgic_initialized(kvm))
>  		return 0;
>  
> +	/* Are we also in the middle of creating a VCPU? */
> +	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
> +		return -EBUSY;
> +
>  	/* freeze the number of spis */
>  	if (!dist->nr_spis)
>  		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
> 

Applied to queue.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
