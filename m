From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 05/13] arm64: Don't trap host pointer auth use to EL2
Date: Sun, 9 Dec 2018 08:54:44 -0600
Message-ID: <f2518d44-3435-394a-02d4-278a6907b96d@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-6-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521334A2F8
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 09:54:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gr0MWfb2ba49 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 Dec 2018 09:54:48 -0500 (EST)
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com
 [209.85.167.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7083C4A211
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 Dec 2018 09:54:48 -0500 (EST)
Received: by mail-oi1-f194.google.com with SMTP id j21so7036983oii.8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Dec 2018 06:54:48 -0800 (PST)
In-Reply-To: <20181207183931.4285-6-kristina.martsenko@arm.com>
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
> To allow EL0 (and/or EL1) to use pointer authentication functionality,
> we must ensure that pointer authentication instructions and accesses to
> pointer authentication keys are not trapped to EL2.
> 
> This patch ensures that HCR_EL2 is configured appropriately when the
> kernel is booted at EL2. For non-VHE kernels we set HCR_EL2.{API,APK},
> ensuring that EL1 can access keys and permit EL0 use of instructions.
> For VHE kernels host EL0 (TGE && E2H) is unaffected by these settings,
> and it doesn't matter how we configure HCR_EL2.{API,APK}, so we don't
> bother setting them.
> 
> This does not enable support for KVM guests, since KVM manages HCR_EL2
> itself when running VMs.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_arm.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
