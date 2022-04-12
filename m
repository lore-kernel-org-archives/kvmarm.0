Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F095C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:33:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB79E4B28D;
	Tue, 12 Apr 2022 09:33:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TJUWiQdkqyg8; Tue, 12 Apr 2022 09:33:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D5824B2E3;
	Tue, 12 Apr 2022 09:32:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C584F4B2F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m1WO9n-l3Vw0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:32:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E86714B2BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:32:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E412150C;
 Tue, 12 Apr 2022 06:32:55 -0700 (PDT)
Received: from e121798.arm.com (unknown [10.57.11.98])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 288353F70D;
 Tue, 12 Apr 2022 06:32:54 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 11/11] arm64: Add --vcpu-affinity command line
 argument
Date: Tue, 12 Apr 2022 14:32:31 +0100
Message-Id: <20220412133231.35355-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412133231.35355-1-alexandru.elisei@arm.com>
References: <20220412133231.35355-1-alexandru.elisei@arm.com>
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

Add a new command line argument, --vcpu-affinity, to set the CPU affinity
for the VCPUs. The affinity is expressed as a cpulist and will apply to all
VCPU threads.

This gives the user a second option for choosing the PMU on a heterogeneous
system. The PMU setup code, when --vcpu-affinity is specified, will search
for the PMU associated with the CPUs specified with this command line
argument instead of the PMU associated with the CPU on which the main
thread is executing.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  7 +-
 arm/aarch64/kvm-cpu.c                     |  9 +++
 arm/aarch64/kvm.c                         | 32 +++++++++
 arm/aarch64/pmu.c                         | 79 +++++++++++++++++------
 arm/include/arm-common/kvm-arch.h         |  7 ++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 include/linux/cpumask.h                   |  5 ++
 7 files changed, 118 insertions(+), 22 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index b08ee60ee1c4..eae8080d3fd9 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -1,15 +1,20 @@
 #ifndef KVM__KVM_CONFIG_ARCH_H
 #define KVM__KVM_CONFIG_ARCH_H
 
+int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
+
 #define ARM_OPT_ARCH_RUN(cfg)						\
 	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,		\
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device. The emulated PMU will be" \
 			" set to the PMU associated with the"		\
-			" main thread"),				\
+			" main thread, unless --vcpu-affinity is set"),	\
 	OPT_BOOLEAN('\0', "disable-mte", &(cfg)->mte_disabled,		\
 			"Disable Memory Tagging Extension"),		\
+	OPT_CALLBACK('\0', "vcpu-affinity", kvm, "cpulist",  		\
+			"Specify the CPU affinity that will apply to "	\
+			"all VCPUs", vcpu_affinity_parser, kvm),	\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),		\
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 3b6224a599c8..4ac0fafae06b 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -88,7 +88,16 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_one_reg reg;
+	cpu_set_t *affinity;
 	u64 data;
+	int ret;
+
+	affinity = kvm->arch.vcpu_affinity_cpuset;
+	if (affinity) {
+		ret = sched_setaffinity(0, sizeof(cpu_set_t), affinity);
+		if (ret == -1)
+			die_perror("sched_setaffinity");
+	}
 
 	reg.addr = (u64)&data;
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 28d608d98831..1b992dd592d4 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -3,8 +3,40 @@
 #include <asm/image.h>
 
 #include <linux/byteorder.h>
+#include <linux/cpumask.h>
+
 #include <kvm/util.h>
 
+int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm *kvm = opt->ptr;
+	const char *cpulist = arg;
+	cpumask_t *cpumask;
+	int cpu, ret;
+
+	kvm->cfg.arch.vcpu_affinity = cpulist;
+
+	cpumask = calloc(1, cpumask_size());
+	if (!cpumask)
+		die_perror("calloc");
+
+	ret = cpulist_parse(cpulist, cpumask);
+	if (ret) {
+		free(cpumask);
+		return ret;
+	}
+
+	kvm->arch.vcpu_affinity_cpuset = CPU_ALLOC(NR_CPUS);
+	if (!kvm->arch.vcpu_affinity_cpuset)
+		die_perror("CPU_ALLOC");
+	CPU_ZERO_S(CPU_ALLOC_SIZE(NR_CPUS), kvm->arch.vcpu_affinity_cpuset);
+
+	for_each_cpu(cpu, cpumask)
+		CPU_SET(cpu, kvm->arch.vcpu_affinity_cpuset);
+
+	return 0;
+}
+
 /*
  * Return the TEXT_OFFSET value that the guest kernel expects. Note
  * that pre-3.17 kernels expose this value using the native endianness
diff --git a/arm/aarch64/pmu.c b/arm/aarch64/pmu.c
index 869a150cd6d3..5f189b32b6d0 100644
--- a/arm/aarch64/pmu.c
+++ b/arm/aarch64/pmu.c
@@ -49,34 +49,19 @@ static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
  */
 #define PMU_ID_MAXLEN		12
 
-/*
- * In the case of homogeneous systems, there only one hardware PMU, and all
- * VCPUs will use the same PMU, regardless of where the attribute gets set.
- *
- * For heterogeneous systems, the assumption is that the user has pinned the VM
- * (via taskset or similar) to a set of CPUs that share the same hardware PMU.
- * This simplifies things for kvmtool, as correctness is not affected by setting
- * the PMU for each VCPU from the main thread, instead of setting it from each
- * individual VCPU thread.
- */
-static int find_pmu(void)
+static int find_pmu_cpumask(struct kvm *kvm, cpumask_t *cpumask)
 {
+	cpumask_t pmu_cpumask, tmp;
 	char buf[PMU_ID_MAXLEN];
 	struct dirent *dirent;
 	char *cpulist, *path;
 	int pmu_id = -ENXIO;
 	unsigned long val;
-	cpumask_t cpumask;
 	ssize_t fd_sz;
-	int this_cpu;
 	int fd, ret;
 	DIR *dir;
 
-	memset(buf, 0, PMU_ID_MAXLEN);
-
-	this_cpu = sched_getcpu();
-	if (this_cpu < 0)
-		return -errno;
+	memset(buf, 0, sizeof(buf));
 
 	cpulist = calloc(1, PAGE_SIZE);
 	if (!cpulist)
@@ -112,15 +97,27 @@ static int find_pmu(void)
 		}
 		close(fd);
 
-		ret = cpulist_parse(cpulist, &cpumask);
+		ret = cpulist_parse(cpulist, &pmu_cpumask);
 		if (ret) {
 			pmu_id = ret;
 			goto out_free;
 		}
 
-		if (!cpumask_test_cpu(this_cpu, &cpumask))
+		if (!cpumask_and(&tmp, cpumask, &pmu_cpumask))
 			goto next_dir;
 
+		/*
+		 * One CPU cannot more than one PMU, hence the set of CPUs which
+		 * share PMU A and the set of CPUs which share PMU B are
+		 * disjoint. If the target CPUs and the current PMU have at
+		 * least one CPU in common, but the target CPUs is not a subset
+		 * of the current PMU, then a PMU which is associated with all
+		 * the target CPUs does not exist. Stop searching for a PMU when
+		 * this happens.
+		 */
+		if (!cpumask_subset(cpumask, &pmu_cpumask))
+			goto out_free;
+
 		strcpy(&path[strlen(path) - 4], "type");
 		fd = open(path, O_RDONLY);
 		if (fd < 0)
@@ -154,6 +151,46 @@ out_free:
 	return pmu_id;
 }
 
+/*
+ * In the case of homogeneous systems, there only one hardware PMU, and all
+ * VCPUs will use the same PMU, regardless of the physical CPUs on which the
+ * VCPU threads will be executing.
+ *
+ * For heterogeneous systems, there are 2 ways for the user to ensure that the
+ * VM runs on CPUs that have the same PMU:
+ *
+ * 1. By pinning the entire VM to the desired CPUs, in which case kvmtool will
+ * choose the PMU associated with the CPU on which the main thread is executing
+ * (the thread that calls find_pmu()).
+ *
+ * 2. By setting the affinity mask for the VCPUs with the --vcpu-affinity
+ * command line argument. All CPUs in the affinity mask must have the same PMU,
+ * otherwise kvmtool will not be able to set a PMU.
+ */
+static int find_pmu(struct kvm *kvm)
+{
+	cpumask_t *cpumask;
+	int i, this_cpu;
+
+	cpumask = calloc(1, cpumask_size());
+	if (!cpumask)
+		die_perror("calloc");
+
+	if (!kvm->arch.vcpu_affinity_cpuset) {
+		this_cpu = sched_getcpu();
+		if (this_cpu < 0)
+			return -errno;
+		cpumask_set_cpu(this_cpu, cpumask);
+	} else {
+		for (i = 0; i < CPU_SETSIZE; i ++) {
+			if (CPU_ISSET(i, kvm->arch.vcpu_affinity_cpuset))
+				cpumask_set_cpu(i, cpumask);
+		}
+	}
+
+	return find_pmu_cpumask(kvm, cpumask);
+}
+
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-pmuv3";
@@ -174,7 +211,7 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		return;
 
 	if (pmu_has_attr(kvm->cpus[0], KVM_ARM_VCPU_PMU_V3_SET_PMU)) {
-		pmu_id = find_pmu();
+		pmu_id = find_pmu(kvm);
 		if (pmu_id < 0) {
 			pr_debug("Failed to find a PMU (errno: %d), "
 				 "PMU events might not work", -pmu_id);
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 43b1f77df394..fc55360d4d15 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -2,6 +2,11 @@
 #define ARM_COMMON__KVM_ARCH_H
 
 #include <stdbool.h>
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sched.h>
+
 #include <linux/const.h>
 #include <linux/types.h>
 
@@ -105,6 +110,8 @@ struct kvm_arch {
 	u64	initrd_guest_start;
 	u64	initrd_size;
 	u64	dtb_guest_start;
+
+	cpu_set_t *vcpu_affinity_cpuset;
 };
 
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index cdcbf235ac4e..9949bfe47ba8 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -5,6 +5,7 @@
 
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
+	const char	*vcpu_affinity;
 	unsigned int	force_cntfrq;
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c4be06621cf4..e6b764b5dd89 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -11,6 +11,11 @@ typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 
 #define cpumask_bits(maskp)	((maskp)->bits)
 
+static inline unsigned int cpumask_size(void)
+{
+	return BITS_TO_LONGS(NR_CPUS) * sizeof(long);
+}
+
 static inline void cpumask_set_cpu(int cpu, cpumask_t *dstp)
 {
 	set_bit(cpu, cpumask_bits(dstp));
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
