From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 7/7] arm: KVM: Fix VTTBR_BADDR_MASK BUG_ON off-by-one
Date: Mon, 20 Nov 2017 14:29:07 +0100
Message-ID: <20171120132907.GI28855@cbox>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
 <20171116175821.26544-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171116175821.26544-8-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Kristina Martsenko <kristina.martsenko@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 16, 2017 at 05:58:21PM +0000, Marc Zyngier wrote:
> VTTBR_BADDR_MASK is used to sanity check the size and alignment of the
> VTTBR address. It seems to currently be off by one, thereby only
> allowing up to 39-bit addresses (instead of 40-bit) and also
> insufficiently checking the alignment. This patch fixes it.
> 
> This patch is the 32bit pendent of Kristina's arm64 fix, and
> she deserves the actual kudos for pinpointing that one.
> 
> Fixes: f7ed45be3ba52 ("KVM: ARM: World-switch implementation")
> Cc: <stable@vger.kernel.org> # 3.9
> Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm/include/asm/kvm_arm.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
> index c8781450905b..3ab8b3781bfe 100644
> --- a/arch/arm/include/asm/kvm_arm.h
> +++ b/arch/arm/include/asm/kvm_arm.h
> @@ -161,8 +161,7 @@
>  #else
>  #define VTTBR_X		(5 - KVM_T0SZ)
>  #endif
> -#define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
> -#define VTTBR_BADDR_MASK  (((_AC(1, ULL) << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
> +#define VTTBR_BADDR_MASK  (((_AC(1, ULL) << (40 - VTTBR_X)) - 1) << VTTBR_X)
>  #define VTTBR_VMID_SHIFT  _AC(48, ULL)
>  #define VTTBR_VMID_MASK(size)	(_AT(u64, (1 << size) - 1) << VTTBR_VMID_SHIFT)
>  
> -- 
> 2.14.2
> 
