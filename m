From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Implement branch predictor hardening for Falkor
Date: Mon, 8 Jan 2018 17:09:33 +0000
Message-ID: <20180108170933.GU25869@arm.com>
References: <1515184139-23743-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515184139-23743-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 05, 2018 at 02:28:59PM -0600, Shanker Donthineni wrote:
> Falkor is susceptible to branch predictor aliasing and can
> theoretically be attacked by malicious code. This patch
> implements a mitigation for these attacks, preventing any
> malicious entries from affecting other victim contexts.

Thanks, Shanker. I'll pick this up (fixing the typo pointed out by Drew).
One comment below.

> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  This patch has been verified using tip of
>    https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=kpti
>         and
>    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64?h=v4.15-rc6&id=c622cc013cece073722592cff1ac6643a33b1622
> 
>  arch/arm64/include/asm/cpucaps.h |  3 ++-
>  arch/arm64/include/asm/kvm_asm.h |  2 ++
>  arch/arm64/kernel/bpi.S          |  8 +++++++
>  arch/arm64/kernel/cpu_errata.c   | 49 ++++++++++++++++++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/entry.S       | 12 ++++++++++
>  arch/arm64/kvm/hyp/switch.c      | 10 ++++++++
>  6 files changed, 81 insertions(+), 3 deletions(-)

[...]

> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 12ee62d..9c45c6a 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -196,3 +196,15 @@ alternative_endif
>  
>  	eret
>  ENDPROC(__fpsimd_guest_restore)
> +
> +ENTRY(__qcom_hyp_sanitize_btac_predictors)
> +	/**
> +	 * Call SMC64 with Silicon provider serviceID 23<<8 (0xc2001700)
> +	 * 0xC2000000-0xC200FFFF: assigned to SiP Service Calls
> +	 * b15-b0: contains SiP functionID
> +	 */
> +	movz    x0, #0x1700
> +	movk    x0, #0xc200, lsl #16
> +	smc     #0
> +	ret

As I mentioned to Jayachandran for the Cavium patches [1], using an
unallocated SMC number like this may cause a problem for some platforms,
such as qemu. Using the PSCI GET_VERSION call avoids this issue, so I'm
relying on you to handle any breakage reports that arise from this change
then.

FWIW: we're currently looking into extending PSCI/SMCCC so that a
standardised mechanism can be implemented without the overhead of the
current register stacking requirements.

Cheers,

Will

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/552511.html
