From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 0/2] arm64: Support systems without FP/ASIMD
Date: Wed, 16 Nov 2016 18:11:34 +0000
Message-ID: <20161116181133.GC3224@e104818-lin.cambridge.arm.com>
References: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478613381-5718-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 08, 2016 at 01:56:19PM +0000, Suzuki K. Poulose wrote:
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

I queued the patches for 4.10 with a slight modification as I haven't
cherry-picked the patch above. I'll push the for-next/core branch out
once I've done some testing.

Thanks.

-- 
Catalin
