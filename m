From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 25/31] arm64: Add workaround for Cavium Thunder erratum
 30115
Date: Tue, 30 May 2017 11:56:22 +0200
Message-ID: <493f83d3-5206-e7b8-69a0-18da1f853c2f@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-26-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-26-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/05/2017 12:46, Marc Zyngier wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Some Cavium Thunder CPUs suffer a problem where a KVM guest may
> inadvertently cause the host kernel to quit receiving interrupts.
> 
> Use the Group-0/1 trapping in order to deal with it.
> 
> [maz]: Adapted patch to the Group-0/1 trapping, reworked commit log
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  Documentation/arm64/silicon-errata.txt |  1 +
>  arch/arm64/Kconfig                     | 11 +++++++++++
>  arch/arm64/include/asm/cpucaps.h       |  3 ++-
>  arch/arm64/kernel/cpu_errata.c         | 21 +++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c            |  7 +++++++
>  5 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
> index 10f2dddbf449..f5f93dca54b7 100644
> --- a/Documentation/arm64/silicon-errata.txt
> +++ b/Documentation/arm64/silicon-errata.txt
> @@ -62,6 +62,7 @@ stable kernels.
>  | Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154        |
>  | Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456        |
>  | Cavium         | ThunderX SMMUv2 | #27704          | N/A                         |
> +| Cavium         | ThunderX Core   | #30115          | CAVIUM_ERRATUM_30115        |
>  |                |                 |                 |                             |
>  | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
>  |                |                 |                 |                             |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 3dcd7ec69bca..0950b21e4d17 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -480,6 +480,17 @@ config CAVIUM_ERRATUM_27456
>  
>  	  If unsure, say Y.
>  
> +config CAVIUM_ERRATUM_30115
> +	bool "Cavium erratum 30115: Guest may disable interrupts in host"
> +	default y
> +	help
> +	  On ThunderX T88 pass 1.x through 2.2, T81 pass 1.0 through
> +	  1.2, and T83 Pass 1.0, KVM guest execution may disable
> +	  interrupts in host. Trapping GICv3 group-1 accesses sidesteps
> +	  the issue.
> +
> +	  If unsure, say Y.
> +
>  config QCOM_FALKOR_ERRATUM_1003
>  	bool "Falkor E1003: Incorrect translation due to ASID change"
>  	default y
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index b3aab8a17868..8d2272c6822c 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -38,7 +38,8 @@
>  #define ARM64_WORKAROUND_REPEAT_TLBI		17
>  #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
>  #define ARM64_WORKAROUND_858921			19
> +#define ARM64_WORKAROUND_CAVIUM_30115		20
>  
> -#define ARM64_NCAPS				20
> +#define ARM64_NCAPS				21
>  
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 2ed2a7657711..0e27f86ee709 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -133,6 +133,27 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		MIDR_RANGE(MIDR_THUNDERX_81XX, 0x00, 0x00),
>  	},
>  #endif
> +#ifdef CONFIG_CAVIUM_ERRATUM_30115
> +	{
> +	/* Cavium ThunderX, T88 pass 1.x - 2.2 */
> +		.desc = "Cavium erratum 30115",
> +		.capability = ARM64_WORKAROUND_CAVIUM_30115,
> +		MIDR_RANGE(MIDR_THUNDERX, 0x00,
> +			   (1 << MIDR_VARIANT_SHIFT) | 2),
> +	},
> +	{
> +	/* Cavium ThunderX, T81 pass 1.0 - 1.2 */
> +		.desc = "Cavium erratum 30115",
> +		.capability = ARM64_WORKAROUND_CAVIUM_30115,
> +		MIDR_RANGE(MIDR_THUNDERX_81XX, 0x00, 0x02),
> +	},
> +	{
> +	/* Cavium ThunderX, T83 pass 1.0 */
> +		.desc = "Cavium erratum 30115",
> +		.capability = ARM64_WORKAROUND_CAVIUM_30115,
> +		MIDR_RANGE(MIDR_THUNDERX_83XX, 0x00, 0x00),
> +	},
> +#endif
>  	{
>  		.desc = "Mismatched cache line size",
>  		.capability = ARM64_MISMATCHED_CACHE_LINE_SIZE,
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 7c82c586d44a..445e86c8b00c 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -390,6 +390,13 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (kvm_vgic_global_state.vcpu_base == 0)
>  		kvm_info("disabling GICv2 emulation\n");
>  
> +#ifdef CONFIG_ARM64
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_CAVIUM_30115)) {
> +		group0_trap = true;
> +		group1_trap = true;
> +	}
> +#endif
> +
>  	if (group0_trap || group1_trap) {
>  		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
>  		static_branch_enable(&vgic_v3_cpuif_trap);
> 
