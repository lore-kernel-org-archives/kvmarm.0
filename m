From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 0/2] arm64: Support systems without FP/ASIMD
Date: Fri, 11 Nov 2016 13:41:37 +0000
Message-ID: <d9b41cca-9a9c-ab92-d3e5-ee1870bb70d4@arm.com>
References: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, will.deacon@arm.com, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 08/11/16 13:56, Suzuki K Poulose wrote:
> This series adds supports to the kernel and KVM hyp to handle
> systems without FP/ASIMD properly. At the moment the kernel
> doesn't check if the FP unit is available before accessing
> the registers (e.g during context switch). Also for KVM,
> we trap the FP/ASIMD accesses and handle it by injecting an
> undefined instruction into the VM on systems without FP.
> 
> Tested on a FVP_Base-AEM-v8A model by disabling VFP on at
> least one CPU ( -C clusterX.cpuY.vfp-present=0 ).
> 
> Changes since V2:
>  - Dropped cleanup patch for arm64/crypto/aes-ce-ccm-glue.c
>  - Removed static_key check from cpus_have_cap. All users with
>    constant caps should use the new API to make use of static_keys.
>  - Removed a dedicated static_key used in irqchip-gic-v3.c for
>    Cavium errata with the new API.
> 
> Applies on v4.9-rc4 + [1] (which is pushed for rc5)
> 
> [1] http://marc.info/?l=linux-arm-kernel&m=147819889813214&w=2
> 
> 
> Suzuki K Poulose (2):
>   arm64: Add hypervisor safe helper for checking constant capabilities
>   arm64: Support systems without FP/ASIMD
> 
>  arch/arm64/include/asm/cpucaps.h    |  3 ++-
>  arch/arm64/include/asm/cpufeature.h | 24 +++++++++++++++++-------
>  arch/arm64/include/asm/neon.h       |  3 ++-
>  arch/arm64/kernel/cpufeature.c      | 17 ++++++++++++++++-
>  arch/arm64/kernel/fpsimd.c          | 14 ++++++++++++++
>  arch/arm64/kernel/process.c         |  2 +-
>  arch/arm64/kvm/handle_exit.c        | 11 +++++++++++
>  arch/arm64/kvm/hyp/hyp-entry.S      |  9 ++++++++-
>  arch/arm64/kvm/hyp/switch.c         |  5 ++++-
>  drivers/irqchip/irq-gic-v3.c        | 13 +------------
>  10 files changed, 76 insertions(+), 25 deletions(-)
> 

For the series:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

How do we plan on merging this? Catalin, are you willing to take it all?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
