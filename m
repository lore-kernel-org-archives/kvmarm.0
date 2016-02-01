From: fu.wei@linaro.org
Subject: [PATCH v3 6/6] kvm: arm64: Add ACPI support for virt arch timer
Date: Tue,  2 Feb 2016 04:26:58 +0800
Message-ID: <1454358418-5157-7-git-send-email-fu.wei@linaro.org>
References: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, lenb@kernel.org, daniel.lezcano@linaro.org, tglx@linutronix.de, christoffer.dall@linaro.org, marc.zyngier@arm.com, gleb@kernel.org, pbonzini@redhat.com, hanjun.guo@linaro.org, wei@redhat.com, a.spyridakis@virtualopensystems.com
Cc: linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, al.stone@linaro.org, graeme.gregory@linaro.org, davem@davemloft.net, jeffrey.t.kirsher@intel.com, richardcochran@gmail.com, arnd@arndb.de, wim@iguana.be, jcm@redhat.com, leo.duran@amd.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Suravee.Suthikulpanit@amd.com, robherring2@gmail.com, Fu Wei <fu.wei@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Fu Wei <fu.wei@linaro.org>

This patch adds ACPI/GTDT support for virt arch timer
using the API in GTDT driver.

Signed-off-by: Fu Wei <fu.wei@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 0a279d3..4077347 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -385,6 +385,9 @@ static int kvm_timer_get_ppi(unsigned int *ppi)
 {
 	struct device_node *np;
 	int ret = -EINVAL;
+#ifdef CONFIG_ACPI_GTDT
+	struct arch_timer_data data;
+#endif
 
 	np = of_find_matching_node(NULL, arch_timer_of_match);
 	if (!np) {
@@ -397,6 +400,11 @@ static int kvm_timer_get_ppi(unsigned int *ppi)
 	of_node_put(np);
 
 skip_of:
+#ifdef CONFIG_ACPI_GTDT
+	if (!*ppi && !gtdt_arch_timer_data_init(NULL, &data))
+		*ppi = data.virt_ppi;
+#endif
+
 	if (*ppi)
 		return 0;
 
-- 
2.5.0
