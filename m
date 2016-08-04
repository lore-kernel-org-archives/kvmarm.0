From: Robert Richter <robert.richter@cavium.com>
Subject: [PATCH] arm64: Add workaround for Cavium erratum 26026
Date: Thu, 4 Aug 2016 22:57:07 +0200
Message-ID: <20160804205707.GJ2151@rric.localdomain>
References: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com
Cc: mark.rutland@arm.com, Matthias Brugger <mbrugger@suse.com>, kvm@vger.kernel.org, suzuki.poulose@arm.com, zlim.lnx@gmail.com, rkrcmar@redhat.com, david.daney@cavium.com, agraf@suse.de, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, lorenzo.pieralisi@arm.com, james.morse@arm.com, dave.long@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The patch below is on top of Matthias' patch series:

 arm64: Implement IPI based TLB invalidation

The series is used to enable a workaround for Cavium ThunderX pass 1.x
systems.

-Robert



>From abb99ee83473d9ecffb4fdaae9c69435ca670bc8 Mon Sep 17 00:00:00 2001
From: Robert Richter <rrichter@cavium.com>
Date: Fri, 29 Jul 2016 09:40:04 +0200
Subject: [PATCH] arm64: Add workaround for Cavium erratum 26026

STX may return a wrong status value if the store was successful.

This may happen on ThunderX T88 pass 1.x cpus if a broadcast TLBI is
executed on another cpu in parallel to an STX. As a result atomic or
non-blocking implementations can behave incorrectly. Use IPIs that
call local TLBIs on other cpus to avoid this.

Applies to ThunderX T88 pass 1.x cpus.

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 Documentation/arm64/silicon-errata.txt |  1 +
 arch/arm64/Kconfig                     | 14 ++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  8 ++++++++
 3 files changed, 23 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 4da60b463995..0d870d934528 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -58,5 +58,6 @@ stable kernels.
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375    |
 | Cavium         | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144    |
 | Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154    |
+| Cavium         | ThunderX Core   | #26026          | CAVIUM_ERRATUM_26026    |
 | Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456    |
 | Cavium         | ThunderX SMMUv2 | #27704          | N/A		       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5a0a691d4220..8cbd9043ec6f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -457,6 +457,20 @@ config CAVIUM_ERRATUM_23154
 
 	  If unsure, say Y.
 
+config CAVIUM_ERRATUM_26026
+	bool "Cavium erratum 26026: STX may return wrong status value"
+	default y
+	help
+	  STX may return a wrong status value if the store was
+	  successful. This may happen on ThunderX T88 pass 1.x cpus if
+	  a broadcast TLBI is executed on another cpu in parallel to
+	  an STX. As a result atomic or non-blocking implementations
+	  can behave incorrectly. Use IPIs that call local TLBIs on
+	  other cpus to avoid this.
+	  Applies to ThunderX T88 pass 1.x cpus.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_27456
 	bool "Cavium erratum 27456: Broadcast TLBI instructions may cause icache corruption"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index af716b65110d..1e1753a6408e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -90,6 +90,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_RANGE(MIDR_THUNDERX, 0x00, 0x01),
 	},
 #endif
+#ifdef CONFIG_CAVIUM_ERRATUM_26026
+	{
+	/* Cavium ThunderX, pass 1.x */
+		.desc = "Cavium erratum 26026",
+		.capability = ARM64_HAS_NO_BCAST_TLBI,
+		MIDR_RANGE(MIDR_THUNDERX, 0x00, 0x01),
+	},
+#endif
 #ifdef CONFIG_CAVIUM_ERRATUM_27456
 	{
 	/* Cavium ThunderX, T88 pass 1.x - 2.1 */
-- 
2.7.0.rc3
