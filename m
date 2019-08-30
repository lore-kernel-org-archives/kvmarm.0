Return-Path: <SRS0=3tuy=W2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519B2C3A5A7
	for <kvmarm@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 121B3239CC
	for <kvmarm@archiver.kernel.org>; Fri, 30 Aug 2019 08:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 121B3239CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C30874A58B;
	Fri, 30 Aug 2019 04:43:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o1Vzc8BLTP51; Fri, 30 Aug 2019 04:43:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7745C4A561;
	Fri, 30 Aug 2019 04:43:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E544A58B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Aug 2019 04:43:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMjwObME815v for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Aug 2019 04:43:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6B134A562
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Aug 2019 04:43:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96FE7344;
 Fri, 30 Aug 2019 01:43:28 -0700 (PDT)
Received: from e112269-lin.arm.com (e112269-lin.cambridge.arm.com
 [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F8BD3F718;
 Fri, 30 Aug 2019 01:43:26 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 10/10] arm64: Retrieve stolen time as paravirtualized guest
Date: Fri, 30 Aug 2019 09:42:55 +0100
Message-Id: <20190830084255.55113-11-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190830084255.55113-1-steven.price@arm.com>
References: <20190830084255.55113-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Steven Price <steven.price@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Enable paravirtualization features when running under a hypervisor
supporting the PV_TIME_ST hypercall.

For each (v)CPU, we ask the hypervisor for the location of a shared
page which the hypervisor will use to report stolen time to us. We set
pv_time_ops to the stolen time function which simply reads the stolen
value from the shared page for a VCPU. We guarantee single-copy
atomicity using READ_ONCE which means we can also read the stolen
time for another VCPU than the currently running one while it is
potentially being updated by the hypervisor.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/paravirt.h |   9 +-
 arch/arm64/kernel/paravirt.c      | 148 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/time.c          |   3 +
 include/linux/cpuhotplug.h        |   1 +
 4 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
index 799d9dd6f7cc..125c26c42902 100644
--- a/arch/arm64/include/asm/paravirt.h
+++ b/arch/arm64/include/asm/paravirt.h
@@ -21,6 +21,13 @@ static inline u64 paravirt_steal_clock(int cpu)
 {
 	return pv_ops.time.steal_clock(cpu);
 }
-#endif
+
+int __init kvm_guest_init(void);
+
+#else
+
+#define kvm_guest_init()
+
+#endif // CONFIG_PARAVIRT
 
 #endif
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index 4cfed91fe256..5bf3be7ccf7e 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -6,13 +6,161 @@
  * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
  */
 
+#define pr_fmt(fmt) "kvmarm-pv: " fmt
+
+#include <linux/arm-smccc.h>
+#include <linux/cpuhotplug.h>
 #include <linux/export.h>
+#include <linux/io.h>
 #include <linux/jump_label.h>
+#include <linux/printk.h>
+#include <linux/psci.h>
+#include <linux/reboot.h>
+#include <linux/slab.h>
 #include <linux/types.h>
+
 #include <asm/paravirt.h>
+#include <asm/pvclock-abi.h>
+#include <asm/smp_plat.h>
 
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 
 struct paravirt_patch_template pv_ops;
 EXPORT_SYMBOL_GPL(pv_ops);
+
+struct kvmarm_stolen_time_region {
+	struct pvclock_vcpu_stolen_time *kaddr;
+};
+
+static DEFINE_PER_CPU(struct kvmarm_stolen_time_region, stolen_time_region);
+
+static bool steal_acc = true;
+static int __init parse_no_stealacc(char *arg)
+{
+	steal_acc = false;
+	return 0;
+}
+
+early_param("no-steal-acc", parse_no_stealacc);
+
+/* return stolen time in ns by asking the hypervisor */
+static u64 kvm_steal_clock(int cpu)
+{
+	struct kvmarm_stolen_time_region *reg;
+
+	reg = per_cpu_ptr(&stolen_time_region, cpu);
+	if (!reg->kaddr) {
+		pr_warn_once("stolen time enabled but not configured for cpu %d\n",
+			     cpu);
+		return 0;
+	}
+
+	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
+}
+
+static int disable_stolen_time_current_cpu(void)
+{
+	struct kvmarm_stolen_time_region *reg;
+
+	reg = this_cpu_ptr(&stolen_time_region);
+	if (!reg->kaddr)
+		return 0;
+
+	memunmap(reg->kaddr);
+	memset(reg, 0, sizeof(*reg));
+
+	return 0;
+}
+
+static int stolen_time_dying_cpu(unsigned int cpu)
+{
+	return disable_stolen_time_current_cpu();
+}
+
+static int init_stolen_time_cpu(unsigned int cpu)
+{
+	struct kvmarm_stolen_time_region *reg;
+	struct arm_smccc_res res;
+
+	reg = this_cpu_ptr(&stolen_time_region);
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_TIME_ST, &res);
+
+	if ((long)res.a0 < 0)
+		return -EINVAL;
+
+	reg->kaddr = memremap(res.a0,
+			      sizeof(struct pvclock_vcpu_stolen_time),
+			      MEMREMAP_WB);
+
+	if (!reg->kaddr) {
+		pr_warn("Failed to map stolen time data structure\n");
+		return -ENOMEM;
+	}
+
+	if (le32_to_cpu(reg->kaddr->revision) != 0 ||
+	    le32_to_cpu(reg->kaddr->attributes) != 0) {
+		pr_warn("Unexpected revision or attributes in stolen time data\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_init_stolen_time(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
+				"hypervisor/kvmarm/pv:starting",
+				init_stolen_time_cpu, stolen_time_dying_cpu);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static bool has_kvm_steal_clock(void)
+{
+	struct arm_smccc_res res;
+
+	/* To detect the presence of PV time support we require SMCCC 1.1+ */
+	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
+		return false;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_HV_PV_FEATURES, &res);
+
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return false;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_FEATURES,
+			     ARM_SMCCC_HV_PV_TIME_ST, &res);
+
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return false;
+
+	return true;
+}
+
+int __init kvm_guest_init(void)
+{
+	int ret;
+
+	if (!has_kvm_steal_clock())
+		return 0;
+
+	ret = kvm_arm_init_stolen_time();
+	if (ret)
+		return ret;
+
+	pv_ops.time.steal_clock = kvm_steal_clock;
+
+	static_key_slow_inc(&paravirt_steal_enabled);
+	if (steal_acc)
+		static_key_slow_inc(&paravirt_steal_rq_enabled);
+
+	pr_info("using stolen time PV\n");
+
+	return 0;
+}
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 0b2946414dc9..a52aea14c6ec 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -30,6 +30,7 @@
 
 #include <asm/thread_info.h>
 #include <asm/stacktrace.h>
+#include <asm/paravirt.h>
 
 unsigned long profile_pc(struct pt_regs *regs)
 {
@@ -65,4 +66,6 @@ void __init time_init(void)
 
 	/* Calibrate the delay loop directly */
 	lpj_fine = arch_timer_rate / HZ;
+
+	kvm_guest_init();
 }
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 068793a619ca..89d75edb5750 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -136,6 +136,7 @@ enum cpuhp_state {
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
+	CPUHP_AP_ARM_KVMPV_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_STARTING,
 	CPUHP_AP_ARM64_ISNDEP_STARTING,
 	CPUHP_AP_SMPCFD_DYING,
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
