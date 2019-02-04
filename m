From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH v3 4/5] lib: arm: Implement PSCI SYSTEM_OFF in
 psci_system_off()
Date: Mon,  4 Feb 2019 13:44:11 +0000
Message-ID: <20190204134412.47877-5-alexandru.elisei@arm.com>
References: <20190204134412.47877-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BD7F4A3FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 08:44:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q3qtuVcBfIoT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 08:44:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79DF04A379
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 08:44:33 -0500 (EST)
In-Reply-To: <20190204134412.47877-1-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

A new function, psci_system_off(), is added which implements the PSCI
SYSTEM_OFF function. A call causes the hypervisor to terminate the virtual
machine.

We take this opportunity to rename psci_sys_reset() to psci_system_reset()
to match the name of the PSCI function SYSTEM_RESET that it implements.

Consumers for the function will be added in a later patch.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/psci.h | 3 ++-
 lib/arm/psci.c     | 8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
index ed51708fd265..7b956bf5987d 100644
--- a/lib/arm/asm/psci.h
+++ b/lib/arm/asm/psci.h
@@ -6,8 +6,9 @@
 extern int psci_invoke(unsigned long function_id, unsigned long arg0,
 		       unsigned long arg1, unsigned long arg2);
 extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
-extern void psci_sys_reset(void);
+extern void psci_system_reset(void);
 extern int cpu_psci_cpu_boot(unsigned int cpu);
 extern void cpu_psci_cpu_die(void);
+extern void psci_system_off(void);
 
 #endif /* _ASMARM_PSCI_H_ */
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 119f74e57e91..c3d399064ae3 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -48,7 +48,13 @@ void cpu_psci_cpu_die(void)
 	printf("CPU%d unable to power off (error = %d)\n", smp_processor_id(), err);
 }
 
-void psci_sys_reset(void)
+void psci_system_reset(void)
 {
 	psci_invoke(PSCI_0_2_FN_SYSTEM_RESET, 0, 0, 0);
 }
+
+void psci_system_off(void)
+{
+	int err = psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
+	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
+}
-- 
2.17.0
