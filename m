From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm: use GIC support unconditionally
Date: Thu, 15 Oct 2015 14:34:27 +0200
Message-ID: <20151015123427.GE21930@cbox>
References: <6276915.O3N4ZN0iPv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10B2441338
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 08:31:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CqZRMb1yD3cu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 08:31:46 -0400 (EDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D04754053F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 08:31:45 -0400 (EDT)
Received: by lbbpp2 with SMTP id pp2so38602746lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 05:34:03 -0700 (PDT)
Content-Disposition: inline
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 12, 2015 at 03:22:31PM +0200, Arnd Bergmann wrote:
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

Applied.

Thanks,
-Christoffer
