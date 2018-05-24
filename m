From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 06/14] arm64: ssbd: Add global mitigation state accessor
Date: Thu, 24 May 2018 12:41:14 +0100
Message-ID: <20180524114113.omumrknbdmh72j7r@lakrids.cambridge.arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522150648.28297-7-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 04:06:40PM +0100, Marc Zyngier wrote:
> We're about to need the mitigation state in various parts of the
> kernel in order to do the right thing for userspace and guests.
> 
> Let's expose an accessor that will let other subsystems know
> about the state.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/cpufeature.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 9bc548e22784..1bacdf57f0af 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -543,6 +543,16 @@ static inline u64 read_zcr_features(void)
>  #define ARM64_SSBD_FORCE_ENABLE		2
>  #define ARM64_SSBD_MITIGATED		3
>  
> +static inline int arm64_get_ssbd_state(void)
> +{
> +#ifdef CONFIG_ARM64_SSBD
> +	extern int ssbd_state;
> +	return ssbd_state;
> +#else
> +	return ARM64_SSBD_UNKNOWN;
> +#endif
> +}
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif
> -- 
> 2.14.2
> 
