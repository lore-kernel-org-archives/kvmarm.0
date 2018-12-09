From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 08/13] arm64: expose user PAC bit positions via ptrace
Date: Sun, 9 Dec 2018 09:03:55 -0600
Message-ID: <2957cf52-498d-ba62-3be7-33c2e9a2f518@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-9-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3977B4A2F8
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 10:04:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xwQt-FC5A-0z for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Dec 2018 10:04:00 -0500 (EST)
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com
 [209.85.167.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 452584A1FA
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 10:04:00 -0500 (EST)
Received: by mail-oi1-f194.google.com with SMTP id i6so7054174oia.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Dec 2018 07:04:00 -0800 (PST)
In-Reply-To: <20181207183931.4285-9-kristina.martsenko@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/7/18 12:39 PM, Kristina Martsenko wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When pointer authentication is in use, data/instruction pointers have a
> number of PAC bits inserted into them. The number and position of these
> bits depends on the configured TCR_ELx.TxSZ and whether tagging is
> enabled. ARMv8.3 allows tagging to differ for instruction and data
> pointers.
> 
> For userspace debuggers to unwind the stack and/or to follow pointer
> chains, they need to be able to remove the PAC bits before attempting to
> use a pointer.
> 
> This patch adds a new structure with masks describing the location of
> the PAC bits in userspace instruction and data pointers (i.e. those
> addressable via TTBR0), which userspace can query via PTRACE_GETREGSET.
> By clearing these bits from pointers (and replacing them with the value
> of bit 55), userspace can acquire the PAC-less versions.
> 
> This new regset is exposed when the kernel is built with (user) pointer
> authentication support, and the address authentication feature is
> enabled. Otherwise, the regset is hidden.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/pointer_auth.h |  8 ++++++++
>  arch/arm64/include/uapi/asm/ptrace.h  |  7 +++++++
>  arch/arm64/kernel/ptrace.c            | 38 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/elf.h              |  1 +
>  4 files changed, 54 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
