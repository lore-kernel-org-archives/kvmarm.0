Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB08C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:20:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BA6849ED0;
	Thu, 27 Jan 2022 11:20:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DVlqfUjqQEU9; Thu, 27 Jan 2022 11:20:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F12C54B0BE;
	Thu, 27 Jan 2022 11:20:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84BC549F56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HX76M2h-X-rR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:20:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9C8749F24
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:20:48 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE08F12FC;
 Thu, 27 Jan 2022 08:20:48 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B4BE3F766;
 Thu, 27 Jan 2022 08:20:46 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: [PATCH v2 kvmtool 10/10] arm64: Add --vcpu-affinity command line
 argument
Date: Thu, 27 Jan 2022 16:20:33 +0000
Message-Id: <20220127162033.54290-11-alexandru.elisei@arm.com>
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
 arm/aarch64/include/kvm/kvm-config-arch.h |  5 ++
 arm/aarch64/kvm-cpu.c                     |  9 +++
 arm/aarch64/kvm.c                         | 32 +++++++++++
 arm/aarch64/pmu.c                         | 70 ++++++++++++++++-------
 arm/include/arm-common/kvm-arch.h         |  7 +++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 include/linux/cpumask.h                   |  5 ++
 7 files changed, 109 insertions(+), 20 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43dfa9b2..04c04a8865c9 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -1,11 +1,16 @@
 #ifndef KVM__KVM_CONFIG_ARCH_H
 #define KVM__KVM_CONFIG_ARCH_H
 
+int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
+
 #define ARM_OPT_ARCH_RUN(cfg)						\
 	OPT_BOOLEAN('\0', "aarch32", &(cfg)->aarch32_guest,		\
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device"),				\
+	OPT_CALLBACK('\0', "vcpu-affinity", kvm, "cpulist",  		\
+			"Specify the CPU affinity that will apply to "	\
+			"all VCPUs", vcpu_affinity_parser, kvm),	\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 3b6224a599c8..27ec8c1d4070 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -90,6 +90,15 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
 	struct kvm_one_reg reg;
 	u64 data;
 
+	cpu_set_t *affinity = kvm->arch.vcpu_affinity_cpuset;
+	int ret;
+
+	if (affinity) {
+		ret = sched_setaffinity(0, sizeof(cpu_set_t), affinity);
+		if (ret == -1)
+			die_perror("sched_setaffinity");
+	}
+
 	reg.addr = (u64)&data;
 
 	/* pstate = all interrupts masked */
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 56a0aedc263d..764f1091ec87 100644
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
index c0fc95ca01c4..3cf36d79414c 100644
--- a/arm/aarch64/pmu.c
+++ b/arm/aarch64/pmu.c
@@ -50,35 +50,20 @@ static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
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
 
 	memset(buf, 0, PMU_ID_MAXLEN);
 
-	this_cpu = sched_getcpu();
-	if (this_cpu < 0)
-		return -errno;
-
 	cpulist = calloc(1, PAGE_SIZE);
 	if (!cpulist)
 		return -ENOMEM;
@@ -114,15 +99,20 @@ static int find_pmu(void)
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
 
+		if (!cpumask_subset(cpumask, &pmu_cpumask)) {
+			die("Unable to find a PMU associated with CPUs %s",
+			    kvm->cfg.arch.vcpu_affinity);
+		}
+
 		strcpy(&path[strlen(path) - 4], "type");
 		fd = open(path, O_RDONLY);
 		if (fd < 0)
@@ -157,6 +147,46 @@ out_free_cpulist:
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
@@ -177,7 +207,7 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		return;
 
 	if (pmu_has_attr(kvm->cpus[0], KVM_ARM_VCPU_PMU_V3_SET_PMU)) {
-		pmu_id = find_pmu();
+		pmu_id = find_pmu(kvm);
 		if (pmu_id < 0)
 			pr_debug("Failed to find a PMU (errno = %d)", -pmu_id);
 	}
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index c645ac001bca..b28beb0b06cf 100644
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
 
@@ -101,6 +106,8 @@ struct kvm_arch {
 	u64	initrd_guest_start;
 	u64	initrd_size;
 	u64	dtb_guest_start;
+
+	cpu_set_t *vcpu_affinity_cpuset;
 };
 
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46ab9e6..d2de3b0892f2 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -12,6 +12,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	const char	*vcpu_affinity;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 19aff92bdb5b..f53d453c3e7d 100644
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
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
