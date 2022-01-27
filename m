Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA076C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:20:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C9B94B11E;
	Thu, 27 Jan 2022 11:20:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MAgUJcikbm7B; Thu, 27 Jan 2022 11:20:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D67374B116;
	Thu, 27 Jan 2022 11:20:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE7014B0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GKKxEzYsevzm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:20:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B75149F24
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:46 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED8A3113E;
 Thu, 27 Jan 2022 08:20:45 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A35383F766;
 Thu, 27 Jan 2022 08:20:43 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v2 kvmtool 09/10] arm64: Add support for
 KVM_ARM_VCPU_PMU_V3_SET_PMU
Date: Thu, 27 Jan 2022 16:20:32 +0000
Message-Id: <20220127162033.54290-10-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127162033.54290-1-alexandru.elisei@arm.com>
References: <20220127162033.54290-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) VCPU ioctl is
used to assign a physical PMU to the events that KVM creates when emulating
the PMU for that VCPU. This is useful on heterogeneous systems, when there
is more than one hardware PMU present.

The assumption that is made in the implementation is that the user will
pin the kvmtool process on a set of CPUs that share the same PMU. This
allows kvmtool to set the same PMU for all VCPUs from the main thread,
instead of in the individual VCPU threads.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/pmu.c | 148 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/pmu.c b/arm/aarch64/pmu.c
index ac5b7bcd6ca9..c0fc95ca01c4 100644
--- a/arm/aarch64/pmu.c
+++ b/arm/aarch64/pmu.c
@@ -1,3 +1,9 @@
+#include <dirent.h>
+#include <sched.h>
+
+#include "linux/cpumask.h"
+#include "linux/err.h"
+
 #include "kvm/fdt.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
@@ -7,6 +13,18 @@
 
 #include "asm/pmu.h"
 
+static bool pmu_has_attr(struct kvm_cpu *vcpu, u64 attr)
+{
+	struct kvm_device_attr pmu_attr = {
+		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr	= attr,
+	};
+	int ret;
+
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pmu_attr);
+	return ret == 0;
+}
+
 static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
 {
 	struct kvm_device_attr pmu_attr = {
@@ -16,8 +34,7 @@ static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
 	};
 	int ret;
 
-	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pmu_attr);
-	if (!ret) {
+	if (pmu_has_attr(vcpu, attr)) {
 		ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
 		if (ret)
 			die_perror("PMU KVM_SET_DEVICE_ATTR");
@@ -26,11 +43,126 @@ static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
 	}
 }
 
+#define SYS_EVENT_SOURCE	"/sys/bus/event_source/devices/"
+/*
+ * int is 32 bits and INT_MAX translates in decimal to 2 * 10^9.
+ * Make room for newline and NUL.
+ */
+#define PMU_ID_MAXLEN		12
+
+/*
+ * In the case of homogeneous systems, there only one hardware PMU, and all
+ * VCPUs will use the same PMU, regardless of where the attribute gets set.
+ *
+ * For heterogeneous systems, the assumption is that the user has pinned the VM
+ * (via taskset or similar) to a set of CPUs that share the same hardware PMU.
+ * This simplifies things for kvmtool, as correctness is not affected by setting
+ * the PMU for each VCPU from the main thread, instead of setting it from each
+ * individual VCPU thread.
+ */
+static int find_pmu(void)
+{
+	char buf[PMU_ID_MAXLEN];
+	struct dirent *dirent;
+	char *cpulist, *path;
+	int pmu_id = -ENXIO;
+	unsigned long val;
+	cpumask_t cpumask;
+	ssize_t fd_sz;
+	int this_cpu;
+	int fd, ret;
+	DIR *dir;
+
+	memset(buf, 0, PMU_ID_MAXLEN);
+
+	this_cpu = sched_getcpu();
+	if (this_cpu < 0)
+		return -errno;
+
+	cpulist = calloc(1, PAGE_SIZE);
+	if (!cpulist)
+		return -ENOMEM;
+
+	path = calloc(1, PAGE_SIZE);
+	if (!path) {
+		pmu_id = -ENOMEM;
+		goto out_free_cpulist;
+	}
+	/* Make the compiler happy by copying the NULL terminating byte. */
+	strncpy(path, SYS_EVENT_SOURCE, strlen(SYS_EVENT_SOURCE) + 1);
+
+	dir = opendir(SYS_EVENT_SOURCE);
+	if (!dir) {
+		pmu_id = -errno;
+		goto out_free;
+	}
+
+	while ((dirent = readdir(dir))) {
+		if (dirent->d_type != DT_LNK)
+			continue;
+
+		strcat(path, dirent->d_name);
+		strcat(path, "/cpus");
+		fd = open(path, O_RDONLY);
+		if (fd < 0)
+			goto next_dir;
+
+		fd_sz = read_file(fd, cpulist, PAGE_SIZE);
+		if (fd_sz < 0) {
+			pmu_id = -errno;
+			goto out_free;
+		}
+		close(fd);
+
+		ret = cpulist_parse(cpulist, &cpumask);
+		if (ret) {
+			pmu_id = ret;
+			goto out_free;
+		}
+
+		if (!cpumask_test_cpu(this_cpu, &cpumask))
+			goto next_dir;
+
+		strcpy(&path[strlen(path) - 4], "type");
+		fd = open(path, O_RDONLY);
+		if (fd < 0)
+			goto next_dir;
+
+		fd_sz = read_file(fd, buf, PMU_ID_MAXLEN - 1);
+		if (fd_sz < 0) {
+			pmu_id = -errno;
+			goto out_free;
+		}
+		close(fd);
+
+		val = strtoul(buf, NULL, 10);
+		if (val > INT_MAX) {
+			pmu_id = -EOVERFLOW;
+			goto out_free;
+		}
+		pmu_id = (int)val;
+		pr_debug("Using PMU: %s (id: %d)", dirent->d_name, pmu_id);
+		break;
+
+next_dir:
+		/* Reset path. */
+		memset(&path[strlen(SYS_EVENT_SOURCE)], '\0',
+		       strlen(path) - strlen(SYS_EVENT_SOURCE));
+	}
+
+out_free:
+	free(path);
+out_free_cpulist:
+	free(cpulist);
+	return pmu_id;
+}
+
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-pmuv3";
 	int irq = KVM_ARM_PMUv3_PPI;
 	struct kvm_cpu *vcpu;
+	int pmu_id = -ENXIO;
 	int i;
 
 	u32 cpu_mask = (((1 << kvm->nrcpus) - 1) << GIC_FDT_IRQ_PPI_CPU_SHIFT) \
@@ -44,9 +176,21 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
 
+	if (pmu_has_attr(kvm->cpus[0], KVM_ARM_VCPU_PMU_V3_SET_PMU)) {
+		pmu_id = find_pmu();
+		if (pmu_id < 0)
+			pr_debug("Failed to find a PMU (errno = %d)", -pmu_id);
+	}
+
 	for (i = 0; i < kvm->nrcpus; i++) {
 		vcpu = kvm->cpus[i];
 		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
+		/*
+		 * PMU IDs 0-5 are reserved; a positive value means a PMU was
+		 * found.
+		 */
+		if (pmu_id > 0)
+			set_pmu_attr(vcpu, &pmu_id, KVM_ARM_VCPU_PMU_V3_SET_PMU);
 		set_pmu_attr(vcpu, NULL, KVM_ARM_VCPU_PMU_V3_INIT);
 	}
 
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
