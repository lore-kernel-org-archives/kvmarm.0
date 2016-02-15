From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 05/23] arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
Date: Mon, 15 Feb 2016 16:10:46 +0000
Message-ID: <20160215161045.GH6298@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
 <1455216004-19499-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455216004-19499-6-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 11, 2016 at 06:39:46PM +0000, Marc Zyngier wrote:
> Add a new ARM64_HAS_VIRT_HOST_EXTN features to indicate that the
> CPU has the ARMv8.1 VHE capability.
> 
> This will be used to trigger kernel patching in KVM.
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  3 ++-
>  arch/arm64/kernel/cpufeature.c      | 11 +++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 8f271b8..c705d6a 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -30,8 +30,9 @@
>  #define ARM64_HAS_LSE_ATOMICS			5
>  #define ARM64_WORKAROUND_CAVIUM_23154		6
>  #define ARM64_WORKAROUND_834220			7
> +#define ARM64_HAS_VIRT_HOST_EXTN		8
>  
> -#define ARM64_NCAPS				8
> +#define ARM64_NCAPS				9

Just a heads up, but this conflicts with the for-next/core branch, where
I used cap 8 to identify the absence of a h/w prefetcher.

Will
