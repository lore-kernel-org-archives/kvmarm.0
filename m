From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix broken GICH_ELRSR big endian
 conversion
Date: Mon, 4 Dec 2017 10:05:51 +0000
Message-ID: <ac6b4719-1867-af63-5243-614bd5bd3465@arm.com>
References: <20171203230435.22021-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171203230435.22021-1-cdall@kernel.org>
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
To: Christoffer Dall <cdall@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/17 23:04, Christoffer Dall wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> We are incorrectly rearranging 32-bit words inside a 64-bit typed value
> for big endian systems, which would result in never marking a virtual
> interrupt as inactive on big endian systems (assuming 32 or fewer LRs on
> the hardware).  Fix this by not doing any word order manipulation for
> the typed values.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/hyp/vgic-v2-sr.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
> index a3f18d362366..d7fd46fe9efb 100644
> --- a/virt/kvm/arm/hyp/vgic-v2-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
> @@ -34,11 +34,7 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
>  	else
>  		elrsr1 = 0;
>  
> -#ifdef CONFIG_CPU_BIG_ENDIAN
> -	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
> -#else
>  	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
> -#endif
>  }
>  
>  static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
> 

Duh!

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
