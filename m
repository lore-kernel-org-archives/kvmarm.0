From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 06/13] arm64/cpufeature: detect pointer authentication
Date: Sun, 9 Dec 2018 08:58:06 -0600
Message-ID: <12e20237-a6a7-bb4c-ad34-7b645a50e680@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-7-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 892674A2F8
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 09:58:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ADtZFZCBHwH for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Dec 2018 09:58:11 -0500 (EST)
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
 [209.85.210.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C107D4A211
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 09:58:11 -0500 (EST)
Received: by mail-ot1-f68.google.com with SMTP id 81so8120044otj.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Dec 2018 06:58:11 -0800 (PST)
In-Reply-To: <20181207183931.4285-7-kristina.martsenko@arm.com>
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
> So that we can dynamically handle the presence of pointer authentication
> functionality, wire up probing code in cpufeature.c.
> 
> From ARMv8.3 onwards, ID_AA64ISAR1 is no longer entirely RES0, and now
> has four fields describing the presence of pointer authentication
> functionality:
> 
> * APA - address authentication present, using an architected algorithm
> * API - address authentication present, using an IMP DEF algorithm
> * GPA - generic authentication present, using an architected algorithm
> * GPI - generic authentication present, using an IMP DEF algorithm
> 
> This patch checks for both address and generic authentication,
> separately. It is assumed that if all CPUs support an IMP DEF algorithm,
> the same algorithm is used across all CPUs.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/cpucaps.h    |  8 +++-
>  arch/arm64/include/asm/cpufeature.h | 12 +++++
>  arch/arm64/kernel/cpufeature.c      | 90 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 109 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
