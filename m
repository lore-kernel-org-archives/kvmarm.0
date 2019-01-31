From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 1/5] arm64: Add utilities to save restore pointer
 authentication keys
Date: Thu, 31 Jan 2019 16:20:03 +0000
Message-ID: <88ccd568-f027-6cdf-b4f1-6709d76102c1@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-2-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548658727-14271-2-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
> The keys can be switched either inside an assembly or such
> functions which do not have pointer authentication checks, so a GCC
> attribute is added to enable it.
> 
> A function ptrauth_keys_store is added which is similar to existing
> function ptrauth_keys_switch but saves the key values in memory.
> This may be useful for save/restore scenarios when CPU changes
> privilege levels, suspend/resume etc.


> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> index 15d4951..98441ce 100644
> --- a/arch/arm64/include/asm/pointer_auth.h
> +++ b/arch/arm64/include/asm/pointer_auth.h
> @@ -11,6 +11,13 @@
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  /*
> + * Compile the function without pointer authentication instructions. This
> + * allows pointer authentication to be enabled/disabled within the function
> + * (but leaves the function unprotected by pointer authentication).
> + */
> +#define __no_ptrauth	__attribute__((target("sign-return-address=none")))

The documentation[0] for this says 'none' is the default. Will this only
take-effect once the kernel supports pointer-auth for the host? (Is this just
documentation until then?)

('noptrauth' would fit with 'notrace' slightly better)


Thanks,

James

[0]
https://gcc.gnu.org/onlinedocs/gcc/AArch64-Function-Attributes.html#AArch64-Function-Attributes
