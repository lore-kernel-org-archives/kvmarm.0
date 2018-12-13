From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6 00/13] ARMv8.3 pointer authentication userspace support
Date: Thu, 13 Dec 2018 18:01:40 +0000
Message-ID: <20181213180140.GA18185@edgewater-inn.cambridge.arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181212193544.GB22013@edgewater-inn.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181212193544.GB22013@edgewater-inn.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Richard Henderson <richard.henderson@linaro.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 12, 2018 at 07:35:44PM +0000, Will Deacon wrote:
> On Fri, Dec 07, 2018 at 06:39:18PM +0000, Kristina Martsenko wrote:
> > This series adds support for the ARMv8.3 pointer authentication extension,
> > enabling userspace return address protection with GCC 7 and above.
> 
> I've pushed this out to for-next/ptr-auth with the following changes:
> 
>   * Rebased onto for-next/core
>   * Dropped the GET/SET ptrace requests for now, due to fragile regset usage
>   * Moved the user key state from thread_info to thread_struct
>   * Removed use of VA_BITS for the PAC mask (doesn't work with 52-bit user VAs)
>   * Added a patch to use _BITUL for the bit definitions in sysreg.h
>   * Tidied up the HWCAP generation [need to run this past Suzuki]
>   * Reduced the number of CPU caps from 6 to 4 [also need to run past Suzuki]
>   * Added Reviewed-by tags
> 
> I've not merged it into for-next/core yet, because it could use some testing
> and review first.

This is now in for-next/core, so I've removed the for-next/ptr-auth staging
branch.

Will
