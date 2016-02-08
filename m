From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 21/23] arm64: hw_breakpoint: Allow EL2 breakpoints if
 running in HYP
Date: Mon, 8 Feb 2016 16:45:44 +0000
Message-ID: <56B8C638.2010402@arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
 <1454522416-6874-22-git-send-email-marc.zyngier@arm.com>
 <20160208155625.GQ6076@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160208155625.GQ6076@e104818-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/02/16 15:56, Catalin Marinas wrote:
> On Wed, Feb 03, 2016 at 06:00:14PM +0000, Marc Zyngier wrote:
>> @@ -76,6 +59,36 @@ static inline void decode_ctrl_reg(u32 reg,
>>  #define ARM_KERNEL_STEP_ACTIVE	1
>>  #define ARM_KERNEL_STEP_SUSPEND	2
>>  
>> +#define DBG_HMC_HYP		(1 << 13)
>> +#define DBG_SSC_HYP		(3 << 14)
>> +
>> +static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
>> +{
>> +	u32 val = (ctrl.len << 5) | (ctrl.type << 3) | ctrl.enabled;
>> +
>> +	if (is_kernel_in_hyp_mode() && ctrl.privilege == AARCH64_BREAKPOINT_EL1)
>> +		val |= DBG_HMC_HYP | DBG_SSC_HYP;
>> +	else
>> +		val |= ctrl.privilege << 1;
>> +
>> +	return val;
>> +}
>> +
>> +static inline void decode_ctrl_reg(u32 reg,
>> +				   struct arch_hw_breakpoint_ctrl *ctrl)
>> +{
>> +	ctrl->enabled	= reg & 0x1;
>> +	reg >>= 1;
>> +	if (is_kernel_in_hyp_mode())
>> +		ctrl->privilege = !!(reg & (DBG_HMC_HYP >> 1));
> 
> I don't particularly like this part as it's not clear just by looking at
> the code that it, in fact, generates AARCH64_BREAKPOINT_EL1. I would
> make this clearer:
> 
> 	if (is_kernel_in_hyp_mode() && (reg & (DBG_HMC_HYP >> 1)))
> 		ctrl->privilege = AARCH64_BREAKPOINT_EL1;
> 
> Alternatively, you could define the PMC field value as:
> 
> #define AARCH64_BREAKPOINT_EL2	0
> 
> and change the privilege to EL1 after masking, something like:
> 
> 	ctrl->privilege = reg & 0x3;
> 	if (ctrl->privilege == AARCH64_BREAKPOINT_EL2)
> 		ctrl->privilege = AARCH64_BREAKPOINT_EL1;
> 
> BTW, do we need to check is_kernel_in_hyp_mode() when decoding? Is there
> anything else that could have set this SSC/HMC/PMC fields other than
> encode_ctrl_reg()?

I was being overzealous, and your solution is clearly better. I ended up with the following:

diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index 9732908..c872b2f 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -18,6 +18,7 @@
 
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/virt.h>
 
 #ifdef __KERNEL__
 
@@ -35,24 +36,6 @@ struct arch_hw_breakpoint {
 	struct arch_hw_breakpoint_ctrl ctrl;
 };
 
-static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
-{
-	return (ctrl.len << 5) | (ctrl.type << 3) | (ctrl.privilege << 1) |
-		ctrl.enabled;
-}
-
-static inline void decode_ctrl_reg(u32 reg,
-				   struct arch_hw_breakpoint_ctrl *ctrl)
-{
-	ctrl->enabled	= reg & 0x1;
-	reg >>= 1;
-	ctrl->privilege	= reg & 0x3;
-	reg >>= 2;
-	ctrl->type	= reg & 0x3;
-	reg >>= 2;
-	ctrl->len	= reg & 0xff;
-}
-
 /* Breakpoint */
 #define ARM_BREAKPOINT_EXECUTE	0
 
@@ -62,6 +45,7 @@ static inline void decode_ctrl_reg(u32 reg,
 #define AARCH64_ESR_ACCESS_MASK	(1 << 6)
 
 /* Privilege Levels */
+#define AARCH64_BREAKPOINT_EL2	0
 #define AARCH64_BREAKPOINT_EL1	1
 #define AARCH64_BREAKPOINT_EL0	2
 
@@ -76,6 +60,35 @@ static inline void decode_ctrl_reg(u32 reg,
 #define ARM_KERNEL_STEP_ACTIVE	1
 #define ARM_KERNEL_STEP_SUSPEND	2
 
+#define DBG_HMC_HYP		(1 << 13)
+#define DBG_SSC_HYP		(3 << 14)
+
+static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
+{
+	u32 val = (ctrl.len << 5) | (ctrl.type << 3) | ctrl.enabled;
+
+	if (is_kernel_in_hyp_mode() && ctrl.privilege == AARCH64_BREAKPOINT_EL1)
+		val |= DBG_HMC_HYP | DBG_SSC_HYP;
+	else
+		val |= ctrl.privilege << 1;
+
+	return val;
+}
+
+static inline void decode_ctrl_reg(u32 reg,
+				   struct arch_hw_breakpoint_ctrl *ctrl)
+{
+	ctrl->enabled	= reg & 0x1;
+	reg >>= 1;
+	ctrl->privilege	= reg & 0x3;
+	if (ctrl->privilege == AARCH64_BREAKPOINT_EL2)
+		ctrl->privilege	= AARCH64_BREAKPOINT_EL1;
+	reg >>= 2;
+	ctrl->type	= reg & 0x3;
+	reg >>= 2;
+	ctrl->len	= reg & 0xff;
+}
+
 /*
  * Limits.
  * Changing these will require modifications to the register accessors.

Was that what you had in mind?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
