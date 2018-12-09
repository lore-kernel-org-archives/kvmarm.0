From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 02/13] arm64: add pointer authentication register bits
Date: Sun, 9 Dec 2018 08:24:20 -0600
Message-ID: <ef051a9b-d58f-07af-a446-4b7326ff9311@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-3-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207183931.4285-3-kristina.martsenko@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/7/18 12:39 PM, Kristina Martsenko wrote:
>  #define SCTLR_ELx_DSSBS	(1UL << 44)
> +#define SCTLR_ELx_ENIA	(1 << 31)

1U or 1UL lest you produce signed -0x80000000.

Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
