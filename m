From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 45/50] ARM: gic-v3: Introduce 32-to-64-bit mappings for GICv3
 cpu registers
Date: Tue, 27 Sep 2016 20:05:53 +0200
Message-ID: <20160927180558.14699-46-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 895EA49C10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ayLqIvMgkfHh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:12 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A14E49B85
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:09 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id 197so30496267wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:32 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

vgic-v3 save/restore routines are written in such way that they map
arm64 system register naming nicely, but it does not fit to arm
world. To keep virt/kvm/arm/hyp/vgic-v3-sr.c untouched we create a
mapping with a function for each register mapping the 32-bit to the
64-bit accessors.

Please, note that 64-bit wide ICH_LR is split in two 32-bit halves
(ICH_LR and ICH_LRC) accessed independently.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/arch_gicv3.h | 64 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index af25c32..996848e 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -96,6 +96,70 @@
 #define ICH_AP1R2			__AP1Rx(2)
 #define ICH_AP1R3			__AP1Rx(3)
 
+/* A32-to-A64 mappings used by VGIC save/restore */
+
+#define CPUIF_MAP(a32, a64)			\
+static inline void write_ ## a64(u32 val)	\
+{						\
+	write_sysreg(val, a32);			\
+}						\
+static inline u32 read_ ## a64(void)		\
+{						\
+	return read_sysreg(a32); 		\
+}						\
+
+#define CPUIF_MAP_LO_HI(a32lo, a32hi, a64)	\
+static inline void write_ ## a64(u64 val)	\
+{						\
+	write_sysreg(lower_32_bits(val), a32lo);\
+	write_sysreg(upper_32_bits(val), a32hi);\
+}						\
+static inline u64 read_ ## a64(void)		\
+{						\
+	u64 val = read_sysreg(a32lo);		\
+						\
+	val |=	(u64)read_sysreg(a32hi) << 32;	\
+						\
+	return val; 				\
+}
+
+CPUIF_MAP(ICH_HCR, ICH_HCR_EL2)
+CPUIF_MAP(ICH_VTR, ICH_VTR_EL2)
+CPUIF_MAP(ICH_MISR, ICH_MISR_EL2)
+CPUIF_MAP(ICH_EISR, ICH_EISR_EL2)
+CPUIF_MAP(ICH_ELSR, ICH_ELSR_EL2)
+CPUIF_MAP(ICH_VMCR, ICH_VMCR_EL2)
+CPUIF_MAP(ICH_AP0R3, ICH_AP0R3_EL2)
+CPUIF_MAP(ICH_AP0R2, ICH_AP0R2_EL2)
+CPUIF_MAP(ICH_AP0R1, ICH_AP0R1_EL2)
+CPUIF_MAP(ICH_AP0R0, ICH_AP0R0_EL2)
+CPUIF_MAP(ICH_AP1R3, ICH_AP1R3_EL2)
+CPUIF_MAP(ICH_AP1R2, ICH_AP1R2_EL2)
+CPUIF_MAP(ICH_AP1R1, ICH_AP1R1_EL2)
+CPUIF_MAP(ICH_AP1R0, ICH_AP1R0_EL2)
+CPUIF_MAP(ICC_HSRE, ICC_SRE_EL2)
+CPUIF_MAP(ICC_SRE, ICC_SRE_EL1)
+
+CPUIF_MAP_LO_HI(ICH_LR15, ICH_LRC15, ICH_LR15_EL2)
+CPUIF_MAP_LO_HI(ICH_LR14, ICH_LRC14, ICH_LR14_EL2)
+CPUIF_MAP_LO_HI(ICH_LR13, ICH_LRC13, ICH_LR13_EL2)
+CPUIF_MAP_LO_HI(ICH_LR12, ICH_LRC12, ICH_LR12_EL2)
+CPUIF_MAP_LO_HI(ICH_LR11, ICH_LRC11, ICH_LR11_EL2)
+CPUIF_MAP_LO_HI(ICH_LR10, ICH_LRC10, ICH_LR10_EL2)
+CPUIF_MAP_LO_HI(ICH_LR9, ICH_LRC9, ICH_LR9_EL2)
+CPUIF_MAP_LO_HI(ICH_LR8, ICH_LRC8, ICH_LR8_EL2)
+CPUIF_MAP_LO_HI(ICH_LR7, ICH_LRC7, ICH_LR7_EL2)
+CPUIF_MAP_LO_HI(ICH_LR6, ICH_LRC6, ICH_LR6_EL2)
+CPUIF_MAP_LO_HI(ICH_LR5, ICH_LRC5, ICH_LR5_EL2)
+CPUIF_MAP_LO_HI(ICH_LR4, ICH_LRC4, ICH_LR4_EL2)
+CPUIF_MAP_LO_HI(ICH_LR3, ICH_LRC3, ICH_LR3_EL2)
+CPUIF_MAP_LO_HI(ICH_LR2, ICH_LRC2, ICH_LR2_EL2)
+CPUIF_MAP_LO_HI(ICH_LR1, ICH_LRC1, ICH_LR1_EL2)
+CPUIF_MAP_LO_HI(ICH_LR0, ICH_LRC0, ICH_LR0_EL2)
+
+#define read_gicreg(r)                 read_##r()
+#define write_gicreg(v, r)             write_##r(v)
+
 /* Low-level accessors */
 
 static inline void gic_write_eoir(u32 irq)
-- 
2.9.0
