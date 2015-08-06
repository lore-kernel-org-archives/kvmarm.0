From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 00/13] arm64: Virtualization Host Extension support
Date: Thu, 6 Aug 2015 18:43:24 +0100
Message-ID: <20150806174324.GD17691@e104818-lin.cambridge.arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 05:19:03PM +0100, Marc Zyngier wrote:
> Marc Zyngier (13):
>   arm/arm64: Add new is_kernel_in_hyp_mode predicate
>   arm64: Allow the arch timer to use the HYP timer
>   arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
>   arm64: KVM: skip HYP setup when already running in HYP
>   arm64: KVM: VHE: macroize VTCR_EL2 setup
>   arm64: KVM: VHE: Patch out kern_hyp_va
>   arm64: KVM: VHE: Patch out use of HVC
>   arm64: KVM: VHE: Preserve VHE config in world switch
>   arm64: KVM: VHE: Add alternatives for VHE-enabled world-switch
>   arm64: Add support for running Linux in EL2 mode
>   arm64: Panic when VHE and non VHE CPUs coexist
>   arm64: KVM: Split sysreg save/restore
>   arm64: KVM: VHE: Early interrupt handling

Do we need to do anything with the debug code? Do we have any
hardware breakpoints/watchpoints targeting kernel space (kgdb doesn't
seem to support this)?

If a breakpoint target is EL1, I don't think we trigger it when running
in the EL2/VHE mode, in which case we need a different
DBGBCR.{HMC,SSC,PMC} combination - {1,11,00}.

Another random untested patch below but we need to get Will to remember
the code he wrote (and the VHE implications):

diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index 52b484b6aa1a..197af39a5ffb 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -34,8 +34,12 @@ struct arch_hw_breakpoint {
 
 static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
 {
-	return (ctrl.len << 5) | (ctrl.type << 3) | (ctrl.privilege << 1) |
+	u32 reg = (ctrl.len << 5) | (ctrl.type << 3) | (ctrl.privilege << 1) |
 		ctrl.enabled;
+	/* set HMC and SSC when debug target is EL2 */
+	if (ctrl.privilege == AARCH64_BREAKPOINT_EL2)
+		reg |= (3 << 14) | (1 << 13);
+	return reg
 }
 
 static inline void decode_ctrl_reg(u32 reg,
@@ -59,6 +63,7 @@ static inline void decode_ctrl_reg(u32 reg,
 #define AARCH64_ESR_ACCESS_MASK	(1 << 6)
 
 /* Privilege Levels */
+#define AARCH64_BREAKPOINT_EL2	0
 #define AARCH64_BREAKPOINT_EL1	1
 #define AARCH64_BREAKPOINT_EL0	2
 
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 7a1a5da6c8c1..77866839d1e8 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -162,6 +162,7 @@ static enum debug_el debug_exception_level(int privilege)
 	case AARCH64_BREAKPOINT_EL0:
 		return DBG_ACTIVE_EL0;
 	case AARCH64_BREAKPOINT_EL1:
+	case AARCH64_BREAKPOINT_EL2:
 		return DBG_ACTIVE_EL1;
 	default:
 		pr_warning("invalid breakpoint privilege level %d\n", privilege);
@@ -456,7 +457,8 @@ static int arch_build_bp_info(struct perf_event *bp)
 	 * that would complicate the stepping code.
 	 */
 	if (arch_check_bp_in_kernelspace(bp))
-		info->ctrl.privilege = AARCH64_BREAKPOINT_EL1;
+		info->ctrl.privilege = is_kernel_in_hyp_mode() ?
+			AARCH64_BREAKPOINT_EL2 : AARCH64_BREAKPOINT_EL1;
 	else
 		info->ctrl.privilege = AARCH64_BREAKPOINT_EL0;
 
@@ -526,7 +528,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	 * Disallow per-task kernel breakpoints since these would
 	 * complicate the stepping code.
 	 */
-	if (info->ctrl.privilege == AARCH64_BREAKPOINT_EL1 && bp->hw.target)
+	if (info->ctrl.privilege != AARCH64_BREAKPOINT_EL0 && bp->hw.target)
 		return -EINVAL;
 
 	return 0;

-- 
Catalin
