From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 24/31] arm64: Add MIDR values for Cavium cn83XX SoCs
Date: Tue, 30 May 2017 11:56:24 +0200
Message-ID: <cd679ebf-4d34-9e4b-c53d-d583e73310f2@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-25-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-25-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/05/2017 12:45, Marc Zyngier wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/include/asm/cputype.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 0984d1b3a8f2..235e77d98261 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -86,6 +86,7 @@
>  
>  #define CAVIUM_CPU_PART_THUNDERX	0x0A1
>  #define CAVIUM_CPU_PART_THUNDERX_81XX	0x0A2
> +#define CAVIUM_CPU_PART_THUNDERX_83XX	0x0A3
>  
>  #define BRCM_CPU_PART_VULCAN		0x516
>  
> @@ -96,6 +97,7 @@
>  #define MIDR_CORTEX_A73 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A73)
>  #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
>  #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
> +#define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
>  #define MIDR_QCOM_FALKOR_V1 MIDR_CPU_MODEL(ARM_CPU_IMP_QCOM, QCOM_CPU_PART_FALKOR_V1)
>  
>  #ifndef __ASSEMBLY__
> 
