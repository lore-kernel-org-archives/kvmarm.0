From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: kvm: Prevent restoring stale PMSCR_EL1 for vcpu
Date: Thu, 7 Dec 2017 10:35:31 +0100
Message-ID: <20171207093531.GO32397@cbox>
References: <1512580189-5921-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512580189-5921-1-git-send-email-julien.thierry@arm.com>
Sender: stable-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 06, 2017 at 05:09:49PM +0000, Julien Thierry wrote:
> When VHE is not present, KVM needs to save and restores PMSCR_EL1 when
> possible. If SPE is used by the host, value of PMSCR_EL1 cannot be saved
> for the guest.
> If the host starts using SPE between two save+restore on the same vcpu,
> restore will write the value of PMSCR_EL1 read during the first save.
> 
> Make sure __debug_save_spe_nvhe clears the value of the saved PMSCR_EL1
> when the guest cannot use SPE.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index 321c9c0..f4363d4 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -74,6 +74,9 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
>  {
>  	u64 reg;
> 
> +	/* Clear pmscr in case of early return */
> +	*pmscr_el1 = 0;
> +
>  	/* SPE present on this CPU? */
>  	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
>  						  ID_AA64DFR0_PMSVER_SHIFT))
> --
> 1.9.1

Applied, thanks.
-Christoffer
