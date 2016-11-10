From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/2] arm64: perf: Move ARMv8 PMU perf event definitions to
 asm/perf_event.h
Date: Thu, 10 Nov 2016 09:10:19 +0000
Message-ID: <aa5b2275-374f-4d74-d9d9-0959d90454ca@arm.com>
References: <1478721480-24852-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF492403F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 04:10:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LNPGKLHZ3boW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2016 04:10:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 255FA404D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 04:10:00 -0500 (EST)
In-Reply-To: <1478721480-24852-1-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wei,

On 09/11/16 19:57, Wei Huang wrote:
> This patch moves ARMv8-related perf event definitions from perf_event.c
> to asm/perf_event.h; so KVM code can use them directly. This also help
> remove a duplicated definition of SW_INCR in perf_event.h.
> 
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  arch/arm64/include/asm/perf_event.h | 161 +++++++++++++++++++++++++++++++++++-
>  arch/arm64/kernel/perf_event.c      | 161 ------------------------------------
>  2 files changed, 160 insertions(+), 162 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
> index 2065f46..6c7b18b 100644
> --- a/arch/arm64/include/asm/perf_event.h
> +++ b/arch/arm64/include/asm/perf_event.h
> @@ -46,7 +46,166 @@
>  #define	ARMV8_PMU_EVTYPE_MASK	0xc800ffff	/* Mask for writable bits */
>  #define	ARMV8_PMU_EVTYPE_EVENT	0xffff		/* Mask for EVENT bits */
>  
> -#define ARMV8_PMU_EVTYPE_EVENT_SW_INCR	0	/* Software increment event */
> +/*
> + * ARMv8 PMUv3 Performance Events handling code.
> + * Common event types.
> + */
> +
> +/* Required events. */
> +#define ARMV8_PMUV3_PERFCTR_SW_INCR				0x00
> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_REFILL			0x03
> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE				0x04
> +#define ARMV8_PMUV3_PERFCTR_BR_MIS_PRED				0x10
> +#define ARMV8_PMUV3_PERFCTR_CPU_CYCLES				0x11
> +#define ARMV8_PMUV3_PERFCTR_BR_PRED				0x12

In my initial review, I asked for the "required" events to be moved to a
shared location. What's the rational for moving absolutely everything?
KVM only needs to know about ARMV8_PMUV3_PERFCTR_SW_INCR and
ARMV8_PMUV3_PERFCTR_CPU_CYCLES, so I thought that moving the above six
events (and maybe the following two) would be enough.

Also, you've now broken the build by dropping
ARMV8_PMU_EVTYPE_EVENT_SW_INCR without amending it use in the KVM PMU
code (see the kbuild report).

> +
> +/* At least one of the following is required. */
> +#define ARMV8_PMUV3_PERFCTR_INST_RETIRED			0x08
> +#define ARMV8_PMUV3_PERFCTR_INST_SPEC				0x1B
> +
> +/* Common architectural events. */
> +#define ARMV8_PMUV3_PERFCTR_LD_RETIRED				0x06
> +#define ARMV8_PMUV3_PERFCTR_ST_RETIRED				0x07
> +#define ARMV8_PMUV3_PERFCTR_EXC_TAKEN				0x09
> +#define ARMV8_PMUV3_PERFCTR_EXC_RETURN				0x0A
> +#define ARMV8_PMUV3_PERFCTR_CID_WRITE_RETIRED			0x0B
> +#define ARMV8_PMUV3_PERFCTR_PC_WRITE_RETIRED			0x0C
> +#define ARMV8_PMUV3_PERFCTR_BR_IMMED_RETIRED			0x0D
> +#define ARMV8_PMUV3_PERFCTR_BR_RETURN_RETIRED			0x0E
> +#define ARMV8_PMUV3_PERFCTR_UNALIGNED_LDST_RETIRED		0x0F
> +#define ARMV8_PMUV3_PERFCTR_TTBR_WRITE_RETIRED			0x1C
> +#define ARMV8_PMUV3_PERFCTR_CHAIN				0x1E
> +#define ARMV8_PMUV3_PERFCTR_BR_RETIRED				0x21
> +
> +/* Common microarchitectural events. */
> +#define ARMV8_PMUV3_PERFCTR_L1I_CACHE_REFILL			0x01
> +#define ARMV8_PMUV3_PERFCTR_L1I_TLB_REFILL			0x02
> +#define ARMV8_PMUV3_PERFCTR_L1D_TLB_REFILL			0x05
> +#define ARMV8_PMUV3_PERFCTR_MEM_ACCESS				0x13
> +#define ARMV8_PMUV3_PERFCTR_L1I_CACHE				0x14
> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_WB			0x15
> +#define ARMV8_PMUV3_PERFCTR_L2D_CACHE				0x16
> +#define ARMV8_PMUV3_PERFCTR_L2D_CACHE_REFILL			0x17
> +#define ARMV8_PMUV3_PERFCTR_L2D_CACHE_WB			0x18
> +#define ARMV8_PMUV3_PERFCTR_BUS_ACCESS				0x19
> +#define ARMV8_PMUV3_PERFCTR_MEMORY_ERROR			0x1A
> +#define ARMV8_PMUV3_PERFCTR_BUS_CYCLES				0x1D
> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_ALLOCATE			0x1F
> +#define ARMV8_PMUV3_PERFCTR_L2D_CACHE_ALLOCATE			0x20
> +#define ARMV8_PMUV3_PERFCTR_BR_MIS_PRED_RETIRED			0x22
> +#define ARMV8_PMUV3_PERFCTR_STALL_FRONTEND			0x23
> +#define ARMV8_PMUV3_PERFCTR_STALL_BACKEND			0x24
> +#define ARMV8_PMUV3_PERFCTR_L1D_TLB				0x25
> +#define ARMV8_PMUV3_PERFCTR_L1I_TLB				0x26
> +#define ARMV8_PMUV3_PERFCTR_L2I_CACHE				0x27
> +#define ARMV8_PMUV3_PERFCTR_L2I_CACHE_REFILL			0x28
> +#define ARMV8_PMUV3_PERFCTR_L3D_CACHE_ALLOCATE			0x29
> +#define ARMV8_PMUV3_PERFCTR_L3D_CACHE_REFILL			0x2A
> +#define ARMV8_PMUV3_PERFCTR_L3D_CACHE				0x2B
> +#define ARMV8_PMUV3_PERFCTR_L3D_CACHE_WB			0x2C
> +#define ARMV8_PMUV3_PERFCTR_L2D_TLB_REFILL			0x2D
> +#define ARMV8_PMUV3_PERFCTR_L2I_TLB_REFILL			0x2E
> +#define ARMV8_PMUV3_PERFCTR_L2D_TLB				0x2F
> +#define ARMV8_PMUV3_PERFCTR_L2I_TLB				0x30
> +
> +/* ARMv8 recommended implementation defined event types */
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_RD			0x40
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WR			0x41
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_RD		0x42
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_WR		0x43
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_INNER		0x44
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_OUTER		0x45
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WB_VICTIM		0x46
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WB_CLEAN			0x47
> +#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_INVAL			0x48
> +
> +#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD			0x4C
> +#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR			0x4D
> +#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD				0x4E
> +#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR				0x4F
> +#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_RD			0x50
> +#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_WR			0x51
> +#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_REFILL_RD		0x52
> +#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_REFILL_WR		0x53
> +
> +#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_WB_VICTIM		0x56
> +#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_WB_CLEAN			0x57
> +#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_INVAL			0x58
> +
> +#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_REFILL_RD			0x5C
> +#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_REFILL_WR			0x5D
> +#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_RD				0x5E
> +#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_WR				0x5F
> +
> +#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD			0x60
> +#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR			0x61
> +#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_SHARED			0x62
> +#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_NOT_SHARED		0x63
> +#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_NORMAL			0x64
> +#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_PERIPH			0x65
> +
> +#define ARMV8_IMPDEF_PERFCTR_MEM_ACCESS_RD			0x66
> +#define ARMV8_IMPDEF_PERFCTR_MEM_ACCESS_WR			0x67
> +#define ARMV8_IMPDEF_PERFCTR_UNALIGNED_LD_SPEC			0x68
> +#define ARMV8_IMPDEF_PERFCTR_UNALIGNED_ST_SPEC			0x69
> +#define ARMV8_IMPDEF_PERFCTR_UNALIGNED_LDST_SPEC		0x6A
> +
> +#define ARMV8_IMPDEF_PERFCTR_LDREX_SPEC				0x6C
> +#define ARMV8_IMPDEF_PERFCTR_STREX_PASS_SPEC			0x6D
> +#define ARMV8_IMPDEF_PERFCTR_STREX_FAIL_SPEC			0x6E
> +#define ARMV8_IMPDEF_PERFCTR_STREX_SPEC				0x6F
> +#define ARMV8_IMPDEF_PERFCTR_LD_SPEC				0x70
> +#define ARMV8_IMPDEF_PERFCTR_ST_SPEC				0x71
> +#define ARMV8_IMPDEF_PERFCTR_LDST_SPEC				0x72
> +#define ARMV8_IMPDEF_PERFCTR_DP_SPEC				0x73
> +#define ARMV8_IMPDEF_PERFCTR_ASE_SPEC				0x74
> +#define ARMV8_IMPDEF_PERFCTR_VFP_SPEC				0x75
> +#define ARMV8_IMPDEF_PERFCTR_PC_WRITE_SPEC			0x76
> +#define ARMV8_IMPDEF_PERFCTR_CRYPTO_SPEC			0x77
> +#define ARMV8_IMPDEF_PERFCTR_BR_IMMED_SPEC			0x78
> +#define ARMV8_IMPDEF_PERFCTR_BR_RETURN_SPEC			0x79
> +#define ARMV8_IMPDEF_PERFCTR_BR_INDIRECT_SPEC			0x7A
> +
> +#define ARMV8_IMPDEF_PERFCTR_ISB_SPEC				0x7C
> +#define ARMV8_IMPDEF_PERFCTR_DSB_SPEC				0x7D
> +#define ARMV8_IMPDEF_PERFCTR_DMB_SPEC				0x7E
> +
> +#define ARMV8_IMPDEF_PERFCTR_EXC_UNDEF				0x81
> +#define ARMV8_IMPDEF_PERFCTR_EXC_SVC				0x82
> +#define ARMV8_IMPDEF_PERFCTR_EXC_PABORT				0x83
> +#define ARMV8_IMPDEF_PERFCTR_EXC_DABORT				0x84
> +
> +#define ARMV8_IMPDEF_PERFCTR_EXC_IRQ				0x86
> +#define ARMV8_IMPDEF_PERFCTR_EXC_FIQ				0x87
> +#define ARMV8_IMPDEF_PERFCTR_EXC_SMC				0x88
> +
> +#define ARMV8_IMPDEF_PERFCTR_EXC_HVC				0x8A
> +#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_PABORT			0x8B
> +#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_DABORT			0x8C
> +#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_OTHER			0x8D
> +#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_IRQ			0x8E
> +#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_FIQ			0x8F
> +#define ARMV8_IMPDEF_PERFCTR_RC_LD_SPEC				0x90
> +#define ARMV8_IMPDEF_PERFCTR_RC_ST_SPEC				0x91
> +
> +#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_RD			0xA0
> +#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_WR			0xA1
> +#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_REFILL_RD		0xA2
> +#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_REFILL_WR		0xA3
> +
> +#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_WB_VICTIM		0xA6
> +#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_WB_CLEAN			0xA7
> +#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_INVAL			0xA8
> +
> +/* ARMv8 Cortex-A53 specific event types. */
> +#define ARMV8_A53_PERFCTR_PREF_LINEFILL				0xC2
> +
> +/* ARMv8 Cavium ThunderX specific event types. */
> +#define ARMV8_THUNDER_PERFCTR_L1D_CACHE_MISS_ST			0xE9
> +#define ARMV8_THUNDER_PERFCTR_L1D_CACHE_PREF_ACCESS		0xEA
> +#define ARMV8_THUNDER_PERFCTR_L1D_CACHE_PREF_MISS		0xEB
> +#define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_ACCESS		0xEC
> +#define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_MISS		0xED
>  
>  /*
>   * Event filters for PMUv3
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index a9310a6..108ba40 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -29,167 +29,6 @@
>  #include <linux/perf/arm_pmu.h>
>  #include <linux/platform_device.h>
>  
> -/*
> - * ARMv8 PMUv3 Performance Events handling code.
> - * Common event types.
> - */
> -
> -/* Required events. */
> -#define ARMV8_PMUV3_PERFCTR_SW_INCR				0x00
> -#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_REFILL			0x03
> -#define ARMV8_PMUV3_PERFCTR_L1D_CACHE				0x04
> -#define ARMV8_PMUV3_PERFCTR_BR_MIS_PRED				0x10
> -#define ARMV8_PMUV3_PERFCTR_CPU_CYCLES				0x11
> -#define ARMV8_PMUV3_PERFCTR_BR_PRED				0x12
> -
> -/* At least one of the following is required. */
> -#define ARMV8_PMUV3_PERFCTR_INST_RETIRED			0x08
> -#define ARMV8_PMUV3_PERFCTR_INST_SPEC				0x1B
> -
> -/* Common architectural events. */
> -#define ARMV8_PMUV3_PERFCTR_LD_RETIRED				0x06
> -#define ARMV8_PMUV3_PERFCTR_ST_RETIRED				0x07
> -#define ARMV8_PMUV3_PERFCTR_EXC_TAKEN				0x09
> -#define ARMV8_PMUV3_PERFCTR_EXC_RETURN				0x0A
> -#define ARMV8_PMUV3_PERFCTR_CID_WRITE_RETIRED			0x0B
> -#define ARMV8_PMUV3_PERFCTR_PC_WRITE_RETIRED			0x0C
> -#define ARMV8_PMUV3_PERFCTR_BR_IMMED_RETIRED			0x0D
> -#define ARMV8_PMUV3_PERFCTR_BR_RETURN_RETIRED			0x0E
> -#define ARMV8_PMUV3_PERFCTR_UNALIGNED_LDST_RETIRED		0x0F
> -#define ARMV8_PMUV3_PERFCTR_TTBR_WRITE_RETIRED			0x1C
> -#define ARMV8_PMUV3_PERFCTR_CHAIN				0x1E
> -#define ARMV8_PMUV3_PERFCTR_BR_RETIRED				0x21
> -
> -/* Common microarchitectural events. */
> -#define ARMV8_PMUV3_PERFCTR_L1I_CACHE_REFILL			0x01
> -#define ARMV8_PMUV3_PERFCTR_L1I_TLB_REFILL			0x02
> -#define ARMV8_PMUV3_PERFCTR_L1D_TLB_REFILL			0x05
> -#define ARMV8_PMUV3_PERFCTR_MEM_ACCESS				0x13
> -#define ARMV8_PMUV3_PERFCTR_L1I_CACHE				0x14
> -#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_WB			0x15
> -#define ARMV8_PMUV3_PERFCTR_L2D_CACHE				0x16
> -#define ARMV8_PMUV3_PERFCTR_L2D_CACHE_REFILL			0x17
> -#define ARMV8_PMUV3_PERFCTR_L2D_CACHE_WB			0x18
> -#define ARMV8_PMUV3_PERFCTR_BUS_ACCESS				0x19
> -#define ARMV8_PMUV3_PERFCTR_MEMORY_ERROR			0x1A
> -#define ARMV8_PMUV3_PERFCTR_BUS_CYCLES				0x1D
> -#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_ALLOCATE			0x1F
> -#define ARMV8_PMUV3_PERFCTR_L2D_CACHE_ALLOCATE			0x20
> -#define ARMV8_PMUV3_PERFCTR_BR_MIS_PRED_RETIRED			0x22
> -#define ARMV8_PMUV3_PERFCTR_STALL_FRONTEND			0x23
> -#define ARMV8_PMUV3_PERFCTR_STALL_BACKEND			0x24
> -#define ARMV8_PMUV3_PERFCTR_L1D_TLB				0x25
> -#define ARMV8_PMUV3_PERFCTR_L1I_TLB				0x26
> -#define ARMV8_PMUV3_PERFCTR_L2I_CACHE				0x27
> -#define ARMV8_PMUV3_PERFCTR_L2I_CACHE_REFILL			0x28
> -#define ARMV8_PMUV3_PERFCTR_L3D_CACHE_ALLOCATE			0x29
> -#define ARMV8_PMUV3_PERFCTR_L3D_CACHE_REFILL			0x2A
> -#define ARMV8_PMUV3_PERFCTR_L3D_CACHE				0x2B
> -#define ARMV8_PMUV3_PERFCTR_L3D_CACHE_WB			0x2C
> -#define ARMV8_PMUV3_PERFCTR_L2D_TLB_REFILL			0x2D
> -#define ARMV8_PMUV3_PERFCTR_L2I_TLB_REFILL			0x2E
> -#define ARMV8_PMUV3_PERFCTR_L2D_TLB				0x2F
> -#define ARMV8_PMUV3_PERFCTR_L2I_TLB				0x30
> -
> -/* ARMv8 recommended implementation defined event types */
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_RD			0x40
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WR			0x41
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_RD		0x42
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_WR		0x43
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_INNER		0x44
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_REFILL_OUTER		0x45
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WB_VICTIM		0x46
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WB_CLEAN			0x47
> -#define ARMV8_IMPDEF_PERFCTR_L1D_CACHE_INVAL			0x48
> -
> -#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD			0x4C
> -#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR			0x4D
> -#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD				0x4E
> -#define ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR				0x4F
> -#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_RD			0x50
> -#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_WR			0x51
> -#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_REFILL_RD		0x52
> -#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_REFILL_WR		0x53
> -
> -#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_WB_VICTIM		0x56
> -#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_WB_CLEAN			0x57
> -#define ARMV8_IMPDEF_PERFCTR_L2D_CACHE_INVAL			0x58
> -
> -#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_REFILL_RD			0x5C
> -#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_REFILL_WR			0x5D
> -#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_RD				0x5E
> -#define ARMV8_IMPDEF_PERFCTR_L2D_TLB_WR				0x5F
> -
> -#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD			0x60
> -#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR			0x61
> -#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_SHARED			0x62
> -#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_NOT_SHARED		0x63
> -#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_NORMAL			0x64
> -#define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_PERIPH			0x65
> -
> -#define ARMV8_IMPDEF_PERFCTR_MEM_ACCESS_RD			0x66
> -#define ARMV8_IMPDEF_PERFCTR_MEM_ACCESS_WR			0x67
> -#define ARMV8_IMPDEF_PERFCTR_UNALIGNED_LD_SPEC			0x68
> -#define ARMV8_IMPDEF_PERFCTR_UNALIGNED_ST_SPEC			0x69
> -#define ARMV8_IMPDEF_PERFCTR_UNALIGNED_LDST_SPEC		0x6A
> -
> -#define ARMV8_IMPDEF_PERFCTR_LDREX_SPEC				0x6C
> -#define ARMV8_IMPDEF_PERFCTR_STREX_PASS_SPEC			0x6D
> -#define ARMV8_IMPDEF_PERFCTR_STREX_FAIL_SPEC			0x6E
> -#define ARMV8_IMPDEF_PERFCTR_STREX_SPEC				0x6F
> -#define ARMV8_IMPDEF_PERFCTR_LD_SPEC				0x70
> -#define ARMV8_IMPDEF_PERFCTR_ST_SPEC				0x71
> -#define ARMV8_IMPDEF_PERFCTR_LDST_SPEC				0x72
> -#define ARMV8_IMPDEF_PERFCTR_DP_SPEC				0x73
> -#define ARMV8_IMPDEF_PERFCTR_ASE_SPEC				0x74
> -#define ARMV8_IMPDEF_PERFCTR_VFP_SPEC				0x75
> -#define ARMV8_IMPDEF_PERFCTR_PC_WRITE_SPEC			0x76
> -#define ARMV8_IMPDEF_PERFCTR_CRYPTO_SPEC			0x77
> -#define ARMV8_IMPDEF_PERFCTR_BR_IMMED_SPEC			0x78
> -#define ARMV8_IMPDEF_PERFCTR_BR_RETURN_SPEC			0x79
> -#define ARMV8_IMPDEF_PERFCTR_BR_INDIRECT_SPEC			0x7A
> -
> -#define ARMV8_IMPDEF_PERFCTR_ISB_SPEC				0x7C
> -#define ARMV8_IMPDEF_PERFCTR_DSB_SPEC				0x7D
> -#define ARMV8_IMPDEF_PERFCTR_DMB_SPEC				0x7E
> -
> -#define ARMV8_IMPDEF_PERFCTR_EXC_UNDEF				0x81
> -#define ARMV8_IMPDEF_PERFCTR_EXC_SVC				0x82
> -#define ARMV8_IMPDEF_PERFCTR_EXC_PABORT				0x83
> -#define ARMV8_IMPDEF_PERFCTR_EXC_DABORT				0x84
> -
> -#define ARMV8_IMPDEF_PERFCTR_EXC_IRQ				0x86
> -#define ARMV8_IMPDEF_PERFCTR_EXC_FIQ				0x87
> -#define ARMV8_IMPDEF_PERFCTR_EXC_SMC				0x88
> -
> -#define ARMV8_IMPDEF_PERFCTR_EXC_HVC				0x8A
> -#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_PABORT			0x8B
> -#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_DABORT			0x8C
> -#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_OTHER			0x8D
> -#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_IRQ			0x8E
> -#define ARMV8_IMPDEF_PERFCTR_EXC_TRAP_FIQ			0x8F
> -#define ARMV8_IMPDEF_PERFCTR_RC_LD_SPEC				0x90
> -#define ARMV8_IMPDEF_PERFCTR_RC_ST_SPEC				0x91
> -
> -#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_RD			0xA0
> -#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_WR			0xA1
> -#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_REFILL_RD		0xA2
> -#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_REFILL_WR		0xA3
> -
> -#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_WB_VICTIM		0xA6
> -#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_WB_CLEAN			0xA7
> -#define ARMV8_IMPDEF_PERFCTR_L3D_CACHE_INVAL			0xA8
> -
> -/* ARMv8 Cortex-A53 specific event types. */
> -#define ARMV8_A53_PERFCTR_PREF_LINEFILL				0xC2
> -
> -/* ARMv8 Cavium ThunderX specific event types. */
> -#define ARMV8_THUNDER_PERFCTR_L1D_CACHE_MISS_ST			0xE9
> -#define ARMV8_THUNDER_PERFCTR_L1D_CACHE_PREF_ACCESS		0xEA
> -#define ARMV8_THUNDER_PERFCTR_L1D_CACHE_PREF_MISS		0xEB
> -#define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_ACCESS		0xEC
> -#define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_MISS		0xED
> -
>  /* PMUv3 HW events mapping. */
>  
>  /*
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
