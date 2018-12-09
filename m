From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 01/13] arm64: add comments about EC exception levels
Date: Sun, 9 Dec 2018 08:34:51 -0600
Message-ID: <73743377-b3d2-6f9f-654d-cbb00a7c70f9@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-2-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207183931.4285-2-kristina.martsenko@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/7/18 12:39 PM, Kristina Martsenko wrote:
> To make it clear which exceptions can't be taken to EL1 or EL2, add
> comments next to the ESR_ELx_EC_* macro definitions.
> 
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> ---
>  arch/arm64/include/asm/esr.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
