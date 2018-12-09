From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 07/13] arm64: add basic pointer authentication support
Date: Sun, 9 Dec 2018 08:59:42 -0600
Message-ID: <0cd3ea5e-c705-7e14-bac0-900a4ca7782c@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-8-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207183931.4285-8-kristina.martsenko@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/7/18 12:39 PM, Kristina Martsenko wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> This patch adds basic support for pointer authentication, allowing
> userspace to make use of APIAKey, APIBKey, APDAKey, APDBKey, and
> APGAKey. The kernel maintains key values for each process (shared by all
> threads within), which are initialised to random values at exec() time.
> 
> The ID_AA64ISAR1_EL1.{APA,API,GPA,GPI} fields are exposed to userspace,
> to describe that pointer authentication instructions are available and
> that the kernel is managing the keys. Two new hwcaps are added for the
> same reason: PACA (for address authentication) and PACG (for generic
> authentication).
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Tested-by: Adam Wallis <awallis@codeaurora.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/pointer_auth.h | 75 +++++++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/thread_info.h  |  4 ++
>  arch/arm64/include/uapi/asm/hwcap.h   |  2 +
>  arch/arm64/kernel/cpufeature.c        | 13 ++++++
>  arch/arm64/kernel/cpuinfo.c           |  2 +
>  arch/arm64/kernel/process.c           |  4 ++
>  6 files changed, 100 insertions(+)
>  create mode 100644 arch/arm64/include/asm/pointer_auth.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
