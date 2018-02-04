From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 12/18] arm64: KVM: Add SMCCC_ARCH_WORKAROUND_1 fast
 handling
Date: Sun, 4 Feb 2018 19:39:07 +0100
Message-ID: <20180204183907.GP21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-13-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 11:46:51AM +0000, Marc Zyngier wrote:
> We want SMCCC_ARCH_WORKAROUND_1 to be fast. As fast as possible.
> So let's intercept it as early as we can by testing for the
> function call number as soon as we've identified a HVC call
> coming from the guest.

Hmmm.  How often is this expected to happen and what is the expected
extra cost of doing the early-exit handling in the C code vs. here?

I think we'd be better off if we only had a single early-exit path (and
we should move the FP/SIMD trap to that path as well), but if there's a
measurable benefit of having this logic in assembly as opposed to in the
C code, then I'm ok with this as well.

The code in this patch looks fine otherwise.

Thanks,
-Christoffer

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/hyp-entry.S | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index e4f37b9dd47c..f36464bd57c5 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -15,6 +15,7 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> +#include <linux/arm-smccc.h>
>  #include <linux/linkage.h>
>  
>  #include <asm/alternative.h>
> @@ -64,10 +65,11 @@ alternative_endif
>  	lsr	x0, x1, #ESR_ELx_EC_SHIFT
>  
>  	cmp	x0, #ESR_ELx_EC_HVC64
> +	ccmp	x0, #ESR_ELx_EC_HVC32, #4, ne
>  	b.ne	el1_trap
>  
> -	mrs	x1, vttbr_el2		// If vttbr is valid, the 64bit guest
> -	cbnz	x1, el1_trap		// called HVC
> +	mrs	x1, vttbr_el2		// If vttbr is valid, the guest
> +	cbnz	x1, el1_hvc_guest	// called HVC
>  
>  	/* Here, we're pretty sure the host called HVC. */
>  	ldp	x0, x1, [sp], #16
> @@ -100,6 +102,20 @@ alternative_endif
>  
>  	eret
>  
> +el1_hvc_guest:
> +	/*
> +	 * Fastest possible path for ARM_SMCCC_ARCH_WORKAROUND_1.
> +	 * The workaround has already been applied on the host,
> +	 * so let's quickly get back to the guest. We don't bother
> +	 * restoring x1, as it can be clobbered anyway.
> +	 */
> +	ldr	x1, [sp]				// Guest's x0
> +	eor	w1, w1, #ARM_SMCCC_ARCH_WORKAROUND_1
> +	cbnz	w1, el1_trap
> +	mov	x0, x1
> +	add	sp, sp, #16
> +	eret
> +
>  el1_trap:
>  	/*
>  	 * x0: ESR_EC
> -- 
> 2.14.2
> 
