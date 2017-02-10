From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/4] arm: kvm: move kvm_vgic_global_state out of .text
 section
Date: Fri, 10 Feb 2017 17:26:52 +0000
Message-ID: <d578fb88-0af1-9161-fb6c-cc524a3ec7ea@arm.com>
References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486747005-15973-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBBE240A14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Feb 2017 12:26:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q3sBDdDgnViL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Feb 2017 12:26:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DBF440992
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Feb 2017 12:26:18 -0500 (EST)
In-Reply-To: <1486747005-15973-2-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kernel-hardening@lists.openwall.com
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/17 17:16, Ard Biesheuvel wrote:
> The kvm_vgic_global_state struct contains a static key which is
> written to by jump_label_init() at boot time. So in preparation of
> making .text regions truly (well, almost truly) read-only, mark
> kvm_vgic_global_state __ro_after_init so it moves to the .rodata
> section instead.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 6440b56ec90e..2f373455ed4e 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -29,7 +29,9 @@
>  #define DEBUG_SPINLOCK_BUG_ON(p)
>  #endif
>  
> -struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif = STATIC_KEY_FALSE_INIT,};
> +struct vgic_global kvm_vgic_global_state __ro_after_init = {
> +	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
> +};
>  
>  /*
>   * Locking order is always:
> 

I guess that's a nice way to find out if someone is playing with this
structure (which indeed shouldn't change once KVM has initialized).

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
