From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH v6 03/13] arm64/kvm: consistently handle host HCR_EL2
 flags
Date: Sun, 9 Dec 2018 08:35:18 -0600
Message-ID: <78a88508-7145-d58e-6275-937e1b23baa5@linaro.org>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
 <20181207183931.4285-4-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181207183931.4285-4-kristina.martsenko@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <amit.kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave P Martin <dave.martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/7/18 12:39 PM, Kristina Martsenko wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> In KVM we define the configuration of HCR_EL2 for a VHE HOST in
> HCR_HOST_VHE_FLAGS, but we don't have a similar definition for the
> non-VHE host flags, and open-code HCR_RW. Further, in head.S we
> open-code the flags for VHE and non-VHE configurations.
> 
> In future, we're going to want to configure more flags for the host, so
> lets add a HCR_HOST_NVHE_FLAGS defintion, and consistently use both
> HCR_HOST_VHE_FLAGS and HCR_HOST_NVHE_FLAGS in the kvm code and head.S.
> 
> We now use mov_q to generate the HCR_EL2 value, as we use when
> configuring other registers in head.S.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_arm.h | 1 +
>  arch/arm64/kernel/head.S         | 5 ++---
>  arch/arm64/kvm/hyp/switch.c      | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
