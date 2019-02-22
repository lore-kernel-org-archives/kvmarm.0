From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/27] clocksource/arm_arch_timer: Store physical timer IRQ
 number for KVM on VHE
Date: Fri, 22 Feb 2019 16:25:39 +0000
Message-ID: <20190222162605.5054-2-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B5C4A37D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:26:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bDis7hYYpkPV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:26:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 160A04A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:26:57 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

A host running in VHE mode gets the EL2 physical timer as its time
source (accessed using the EL1 sysreg accessors, which get re-directed
to the EL2 sysregs by VHE).

The EL1 physical timer remains unused by the host kernel, allowing us to
pass that on directly to a KVM guest and saves us from emulating this
timer for the guest on VHE systems.

Store the EL1 Physical Timer's IRQ number in
struct arch_timer_kvm_info on VHE systems to allow KVM to use it.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 11 +++++++++--
 include/clocksource/arm_arch_timer.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 9a7d4dc00b6e..b9243e2328b4 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1206,6 +1206,13 @@ static enum arch_timer_ppi_nr __init arch_timer_select_ppi(void)
 	return ARCH_TIMER_PHYS_SECURE_PPI;
 }
 
+static void __init arch_timer_populate_kvm_info(void)
+{
+	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[ARCH_TIMER_VIRT_PPI];
+	if (is_kernel_in_hyp_mode())
+		arch_timer_kvm_info.physical_irq = arch_timer_ppi[ARCH_TIMER_PHYS_NONSECURE_PPI];
+}
+
 static int __init arch_timer_of_init(struct device_node *np)
 {
 	int i, ret;
@@ -1220,7 +1227,7 @@ static int __init arch_timer_of_init(struct device_node *np)
 	for (i = ARCH_TIMER_PHYS_SECURE_PPI; i < ARCH_TIMER_MAX_TIMER_PPI; i++)
 		arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
 
-	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[ARCH_TIMER_VIRT_PPI];
+	arch_timer_populate_kvm_info();
 
 	rate = arch_timer_get_cntfrq();
 	arch_timer_of_configure_rate(rate, np);
@@ -1550,7 +1557,7 @@ static int __init arch_timer_acpi_init(struct acpi_table_header *table)
 	arch_timer_ppi[ARCH_TIMER_HYP_PPI] =
 		acpi_gtdt_map_ppi(ARCH_TIMER_HYP_PPI);
 
-	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[ARCH_TIMER_VIRT_PPI];
+	arch_timer_populate_kvm_info();
 
 	/*
 	 * When probing via ACPI, we have no mechanism to override the sysreg
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 349e5957c949..702967d996bb 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -74,6 +74,7 @@ enum arch_timer_spi_nr {
 struct arch_timer_kvm_info {
 	struct timecounter timecounter;
 	int virtual_irq;
+	int physical_irq;
 };
 
 struct arch_timer_mem_frame {
-- 
2.20.1
