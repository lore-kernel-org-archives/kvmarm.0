From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP hardening
Date: Mon, 5 Mar 2018 09:52:19 -0600
Message-ID: <CAOZdJXV3QE2mKSf3GvTSdoVmfjJ1UEXPY8OJfW=-9E1dN1TeZA@mail.gmail.com>
References: <1520027418-10646-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520027418-10646-1-git-send-email-shankerd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, Thomas Speier <tspeier@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Christoffer Dall <christoffer.dall@linaro.org>, Sean Campbell <scampbel@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 2, 2018 at 3:50 PM, Shanker Donthineni
<shankerd@codeaurora.org> wrote:
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index bb26382..6ecc249 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -43,7 +43,7 @@
>  #define ARM64_SVE                              22
>  #define ARM64_UNMAP_KERNEL_AT_EL0              23
>  #define ARM64_HARDEN_BRANCH_PREDICTOR          24
> -#define ARM64_HARDEN_BP_POST_GUEST_EXIT                25
> +/* #define ARM64_UNALLOCATED_ENTRY                     25 */

Why not just delete the entry?  Is ARM64_NCAPS never supposed to get smaller?
