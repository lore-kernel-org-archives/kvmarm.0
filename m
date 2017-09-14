From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 15/28] arm64: cpufeature: Move sys_caps_initialised
 declarations
Date: Thu, 14 Sep 2017 10:35:28 +0100
Message-ID: <b963c108-ed26-3459-0ce1-ccf885050aff@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-16-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1504198860-12951-16-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 31/08/17 18:00, Dave Martin wrote:
> update_cpu_features() currently cannot tell whether it is being
> called during early or late secondary boot.  This doesn't
> desperately matter for anything it currently does.
>
> However, SVE will need to know here whether the set of available
> vector lengths is fixed of still to be determined when booting a
> CPU so that it can be updated appropriately.
>
> This patch simply moves the sys_caps_initialised stuff to the top
> of the file so that it can be more widely.  There doesn't seem to
> be a more obvious place to put it.
>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index cd52d36..43ba8df 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -51,6 +51,21 @@ unsigned int compat_elf_hwcap2 __read_mostly;
>  DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
>  EXPORT_SYMBOL(cpu_hwcaps);
>
> +/*
> + * Flag to indicate if we have computed the system wide
> + * capabilities based on the boot time active CPUs. This
> + * will be used to determine if a new booting CPU should
> + * go through the verification process to make sure that it
> + * supports the system capabilities, without using a hotplug
> + * notifier.
> + */
> +static bool sys_caps_initialised;
> +
> +static inline void set_sys_caps_initialised(void)
> +{
> +	sys_caps_initialised = true;
> +}
> +
>  static int dump_cpu_hwcaps(struct notifier_block *self, unsigned long v, void *p)
>  {
>  	/* file-wide pr_fmt adds "CPU features: " prefix */
> @@ -1041,21 +1056,6 @@ void __init enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
>  }
>
>  /*
> - * Flag to indicate if we have computed the system wide
> - * capabilities based on the boot time active CPUs. This
> - * will be used to determine if a new booting CPU should
> - * go through the verification process to make sure that it
> - * supports the system capabilities, without using a hotplug
> - * notifier.
> - */
> -static bool sys_caps_initialised;
> -
> -static inline void set_sys_caps_initialised(void)
> -{
> -	sys_caps_initialised = true;
> -}

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
