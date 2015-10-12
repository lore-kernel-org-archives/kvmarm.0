From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm: use GIC support unconditionally
Date: Mon, 12 Oct 2015 14:58:55 +0100
Message-ID: <20151012145855.7830bb46@arm.com>
References: <6276915.O3N4ZN0iPv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C2534126B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 09:56:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iqwgTV2pM6Jq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Oct 2015 09:56:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 091DC410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Oct 2015 09:56:50 -0400 (EDT)
In-Reply-To: <6276915.O3N4ZN0iPv@wuerfel>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 12 Oct 2015 15:22:31 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> The vgic code on ARM is built for all configurations that enable KVM,
> but the parent_data field that it references is only present when
> CONFIG_IRQ_DOMAIN_HIERARCHY is set:
> 
> virt/kvm/arm/vgic.c: In function 'kvm_vgic_map_phys_irq':
> virt/kvm/arm/vgic.c:1781:13: error: 'struct irq_data' has no member named 'parent_data'
> 
> This flag is implied by the GIC driver, and indeed the VGIC code only
> makes sense if a GIC is present. This changes the CONFIG_KVM symbol
> to always select GIC, which avoids the issue.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 662d9715840 ("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}")
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 210eccadb69a..356970f3b25e 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -21,6 +21,7 @@ config KVM
>  	depends on MMU && OF
>  	select PREEMPT_NOTIFIERS
>  	select ANON_INODES
> +	select ARM_GIC
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
>  	select KVM_MMIO
> 

Looks good to me.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
