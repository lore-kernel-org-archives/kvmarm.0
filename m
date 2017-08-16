From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 15/27] arm64/sve: Probe SVE capabilities and usable vector
 lengths
Date: Wed, 16 Aug 2017 18:48:01 +0100
Message-ID: <07268b07-c5f4-38d6-257d-5864cb6752c1@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-16-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-16-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 09/08/17 13:05, Dave Martin wrote:
> [This sender failed our fraud detection checks and may not be who they appear to be. Learn about spoofing at http://aka.ms/LearnAboutSpoofing]
>
> This patch uses the cpufeatures framework to determine common SVE
> capabilities and vector lengths, and configures the runtime SVE
> support code appropriately.
>
> ZCR_ELx is not really a feature register, but it is convenient to
> use it as a template for recording the maximum vector length
> supported by a CPU, using the LEN field.  This field is similar to
> a feature field in that it is a contiguous bitfield for which we
> want to determine the minimum system-wide value.  This patch adds
> ZCR as a pseudo-register in cpuinfo/cpufeatures, with appropriate
> custom code to populate it.  Finding the minimum supported value of
> the LEN field is left to the cpufeatures framework in the usual
> way.
>
> The meaning of ID_AA64ZFR0_EL1 is not architecturally defined yet,
> so for now we just require it to be zero.
>
> Note that much of this code is dormant and SVE still won't be used
> yet, since system_supports_sve() remains hardwired to false.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Dave,

The cpufeature bits look good to me, with one minor comment.


> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index bce95de..955c873 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c

...

> +void __init sve_setup(void)
> +{
> +       u64 zcr;
> +       unsigned int max_vl;
> +
> +       if (!system_supports_sve())
> +               return;
> +
> +       /*
> +        * The architecture mandates 128-bit vectors be supported, and
> +        * the code assumes elsewhere that sve_vq_map is non-empty:
> +        */
> +       BUG_ON(!test_bit(vq_to_bit(1), sve_vq_map));
> +
> +       sve_vq_map_finalised = true;

We have something local in cpufeature.c, sys_caps_initialised. May be we could
reuse it here ? With or without that change, FWIW.

Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
