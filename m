Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690A74F390D
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660212; cv=none; b=SpKvrNi2LZqPlsBHq+aA3Hj2NLWmjRGezllzphtAI6udmIvfulVX8jPPynPFn+3TqFQ1xR/C2+597bEWj9kL5j9Mkl9VmjJqxSeHqE0w6JLwnah/HVdWxW4oH7YPeHKHscQG906xIF1kXccqzBOO73+7EUmWGL7ZUIxRwTaFyD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660212; c=relaxed/simple;
	bh=vaE6t0emmg2XojNh40fL+99idm9veof/NaeM0gAjD/Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H180kgcNLCIIj4GDPPL2a+mCIQQf8Gw9Q6mOc7HJS9KjYYMJ+JOkeLgrUaA7j+A9+ry7LXjmuI2YaHxTNS6WPZApReiGru9Cett74717QcMJrGKZGdrPRjAYFazqKgqFpbwy1n/WkIJen/FqPLBwibgsBzMVDxtzB6vRDH2zpc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dG4yH966; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dG4yH966"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5CC81F91;
	Thu, 17 Sep 2026 08:49:57 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ED123F7B4;
	Thu, 17 Sep 2026 08:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660201; bh=vaE6t0emmg2XojNh40fL+99idm9veof/NaeM0gAjD/Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dG4yH966rxZgXta6BbqygpDbMHrrI+XwQ7RTt6OukvQ/GT25CaFjDSkV05mKh4b19
	 vKBuBrpp/sdNYDq1bFGGTdN895QIeQ8Qk2GP9SE1xTJSA2dNEVpKG4iAHLA4G39Wjm
	 63whZxcc8MAJ53VFrW/1E5r8EU1lcNsxsqKtfWVA=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool 5/7] Correctly apply --vcpu-affinity to the VCPU threads
Date: Thu, 17 Sep 2026 16:49:30 +0100
Message-ID: <20260917154932.193943-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917154932.193943-1-alexandru.elisei@arm.com>
References: <20260917154932.193943-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 639b72f61a3 ("arm64: Add --vcpu-affinity command line argument")
added the --vcpu-affinity command line argument to run the VCPU threads on
the specified physical CPUs. The goal was to allow the rest of the threads
created by kvmtool to be scheduled freely by the operating system.

The affinity is set from kvm_cpu__init() -> kvm_cpu__reset_vcpu(), which is
called from the main thread, before the VCPU threads are created.  This
means that the main thread is pinned to the CPU list specified with
--vcpu-affinity, as well as all the other threads created after this point
(which includes the VCPUs), which defeats the purpose of the
--vcpu-affinity.

Make this right by setting the allowed CPUs only for the VCPU threads, when
they are created. Make --vcpu-affinity an arch-independent option, since
it's not something tied to a particular architecture, and this makes the
fix cleaner.

Also do proper cleanup by freeing the affinity cpuset when struct kvm is
freed.

Fixes: 639b72f61a3 ("arm64: Add --vcpu-affinity command line argument")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/include/kvm/kvm-arch.h        |  2 --
 arm64/include/kvm/kvm-config-arch.h |  5 ----
 arm64/kvm-cpu.c                     |  9 -------
 arm64/kvm.c                         | 34 ------------------------
 arm64/pmu.c                         |  6 ++---
 builtin-run.c                       | 41 +++++++++++++++++++++++++++--
 include/kvm/kvm-config.h            |  1 +
 include/kvm/kvm.h                   |  1 +
 include/kvm/util.h                  |  4 +++
 kvm.c                               |  3 +++
 util/util.c                         | 29 ++++++++++++++++++++
 11 files changed, 80 insertions(+), 55 deletions(-)

diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index e7dd52692935..f0223132e60c 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -112,8 +112,6 @@ struct kvm_arch {
 	u64	initrd_guest_start;
 	u64	initrd_size;
 	u64	dtb_guest_start;
-
-	cpu_set_t *vcpu_affinity_cpuset;
 };
 
 struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr);
diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index d8a8ef7fd490..adda6403401e 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -5,7 +5,6 @@
 
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
-	const char	*vcpu_affinity;
 	unsigned int	force_cntfrq;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
@@ -24,7 +23,6 @@ struct kvm_config_arch {
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
-int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 
 #define OPT_ARCH_RUN(pfx, cfg)							\
@@ -37,9 +35,6 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 			" main thread, unless --vcpu-affinity is set"),		\
 	OPT_BOOLEAN('\0', "disable-mte", &(cfg)->mte_disabled,			\
 			"Disable Memory Tagging Extension"),			\
-	OPT_CALLBACK('\0', "vcpu-affinity", kvm, "cpulist",  			\
-			"Specify the CPU affinity that will apply to "		\
-			"all VCPUs", vcpu_affinity_parser, kvm),		\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,				\
 			"Specify random seed for Kernel Address Space "		\
 			"Layout Randomization (KASLR)"),			\
diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index 3aa76843fda2..9063fbcdcb64 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -376,15 +376,6 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset)
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	cpu_set_t *affinity;
-	int ret;
-
-	affinity = kvm->arch.vcpu_affinity_cpuset;
-	if (affinity) {
-		ret = sched_setaffinity(0, sizeof(cpu_set_t), affinity);
-		if (ret == -1)
-			die_perror("sched_setaffinity");
-	}
 
 	if (kvm->cfg.arch.aarch32_guest)
 		return reset_vcpu_aarch32(vcpu);
diff --git a/arm64/kvm.c b/arm64/kvm.c
index 88b3622766bf..23c630f33aa5 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -11,7 +11,6 @@
 #include "asm/smccc.h"
 
 #include <linux/byteorder.h>
-#include <linux/cpumask.h>
 #include <linux/kernel.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
@@ -445,39 +444,6 @@ int kvm__arch_setup_firmware(struct kvm *kvm)
 	return 0;
 }
 
-int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
-{
-	struct kvm *kvm = opt->ptr;
-	const char *cpulist = arg;
-	cpumask_t *cpumask;
-	size_t setsize;
-	int ret = 0;
-	int cpu;
-
-	kvm->cfg.arch.vcpu_affinity = cpulist;
-
-	cpumask = calloc(cpumask_size(), 1);
-	if (!cpumask)
-		die_perror("calloc");
-
-	ret = cpulist_parse(cpulist, cpumask);
-	if (ret)
-		goto out_free;
-
-	kvm->arch.vcpu_affinity_cpuset = CPU_ALLOC(NR_CPUS);
-	if (!kvm->arch.vcpu_affinity_cpuset)
-		die_perror("CPU_ALLOC");
-
-	setsize = CPU_ALLOC_SIZE(NR_CPUS);
-	CPU_ZERO_S(setsize, kvm->arch.vcpu_affinity_cpuset);
-	for_each_cpu(cpu, cpumask)
-		CPU_SET_S(cpu, setsize, kvm->arch.vcpu_affinity_cpuset);
-
-out_free:
-	free(cpumask);
-	return ret;
-}
-
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
 
diff --git a/arm64/pmu.c b/arm64/pmu.c
index d3761689c907..bd3f225842be 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -200,8 +200,8 @@ static int find_pmu(struct kvm *kvm)
 
 	setsize = CPU_ALLOC_SIZE(NR_CPUS);
 
-	if (kvm->arch.vcpu_affinity_cpuset) {
-		affinity = kvm->arch.vcpu_affinity_cpuset;
+	if (kvm->vcpu_affinity) {
+		affinity = kvm->vcpu_affinity;
 	} else {
 		affinity = CPU_ALLOC(NR_CPUS);
 		if (!affinity)
@@ -224,7 +224,7 @@ static int find_pmu(struct kvm *kvm)
 
 out_free:
 	free(cpumask);
-	if (!kvm->arch.vcpu_affinity_cpuset)
+	if (!kvm->vcpu_affinity)
 		CPU_FREE(affinity);
 	return ret;
 }
diff --git a/builtin-run.c b/builtin-run.c
index 81f255f911b3..127245f9a6b8 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -34,6 +34,7 @@
 #include "kvm/kvm-ipc.h"
 #include "kvm/builtin-debug.h"
 
+#include <linux/cpumask.h>
 #include <linux/types.h>
 #include <linux/err.h>
 #include <linux/sizes.h>
@@ -166,6 +167,39 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+static int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm *kvm = opt->ptr;
+	const char *cpulist = arg;
+	cpumask_t *cpumask;
+	size_t setsize;
+	int ret = 0;
+	int cpu;
+
+	kvm->cfg.vcpu_affinity = cpulist;
+
+	cpumask = calloc(cpumask_size(), 1);
+	if (!cpumask)
+		die_perror("calloc");
+
+	ret = cpulist_parse(cpulist, cpumask);
+	if (ret)
+		goto out_free;
+
+	kvm->vcpu_affinity = CPU_ALLOC(NR_CPUS);
+	if (!kvm->vcpu_affinity)
+		die_perror("CPU_ALLOC");
+
+	setsize = CPU_ALLOC_SIZE(NR_CPUS);
+	CPU_ZERO_S(setsize, kvm->vcpu_affinity);
+	for_each_cpu(cpu, cpumask)
+		CPU_SET_S(cpu, setsize, kvm->vcpu_affinity);
+
+out_free:
+	free(cpumask);
+	return 0;
+}
+
 #ifndef OPT_ARCH_RUN
 #define OPT_ARCH_RUN(...)
 #endif
@@ -237,6 +271,9 @@ static int loglevel_parser(const struct option *opt, const char *arg, int unset)
 		     virtio_transport_parser, NULL),			\
 	OPT_CALLBACK('\0', "loglevel", NULL, "[error|warning|info|debug]",\
 			"Set the verbosity level", loglevel_parser, NULL),\
+	OPT_CALLBACK('\0', "vcpu-affinity", kvm, "cpulist",  		\
+			"Specify the CPU affinity that will apply to "	\
+			"all VCPUs", vcpu_affinity_parser, kvm),	\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
@@ -834,8 +871,8 @@ static int kvm_cmd_run_work(struct kvm *kvm)
 	int i;
 
 	for (i = 0; i < kvm->nrcpus; i++) {
-		if (pthread_create(&kvm->cpus[i]->thread, NULL, kvm_cpu_thread, kvm->cpus[i]) != 0)
-			die("unable to create KVM VCPU thread");
+		if (kvm_create_vcpu_thread(kvm, &kvm->cpus[i]->thread, kvm_cpu_thread, kvm->cpus[i]))
+			die_perror("unable to create KVM VCPU thread");
 	}
 
 	/* Only VCPU #0 is going to exit by itself when shutting down */
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 592b035785c9..3f636cb2ea0f 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -52,6 +52,7 @@ struct kvm_config {
 	const char *hugetlbfs_path;
 	const char *custom_rootfs_name;
 	const char *real_cmdline;
+	const char *vcpu_affinity;
 	struct virtio_net_params *net_params;
 	bool single_step;
 	bool vnc;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index a9376b6dd67e..01c4f5fa952d 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -102,6 +102,7 @@ struct kvm {
 	int                     nr_disks;
 
 	int			vm_state;
+	cpu_set_t		*vcpu_affinity;
 
 #ifdef KVM_BRLOCK_DEBUG
 	pthread_rwlock_t	brlock_sem;
diff --git a/include/kvm/util.h b/include/kvm/util.h
index 9e23431ecfe2..0f5a4bba5714 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -19,6 +19,7 @@
 #include <signal.h>
 #include <errno.h>
 #include <limits.h>
+#include <pthread.h>
 #include <sys/param.h>
 #include <sys/types.h>
 #include <linux/types.h>
@@ -150,4 +151,7 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
 void *mmap_guest_memfd(struct kvm *kvm, u64 size);
 
+int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
+			   void *(*start_routine)(void *), void *arg);
+
 #endif /* KVM__UTIL_H */
diff --git a/kvm.c b/kvm.c
index 96583f916442..e29b73d27f33 100644
--- a/kvm.c
+++ b/kvm.c
@@ -182,6 +182,9 @@ int kvm__exit(struct kvm *kvm)
 		free(bank);
 	}
 
+	if (kvm->vcpu_affinity)
+		CPU_FREE(kvm->vcpu_affinity);
+
 	free(kvm);
 	return 0;
 }
diff --git a/util/util.c b/util/util.c
index 51a45916fd94..ff888bf9e061 100644
--- a/util/util.c
+++ b/util/util.c
@@ -206,3 +206,32 @@ void *mmap_guest_memfd(struct kvm *kvm, u64 size)
 
 	return addr;
 }
+
+int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
+			   void *(*start_routine)(void *), void *arg)
+{
+	pthread_attr_t attr;
+	cpu_set_t *affinity;
+	int ret;
+
+	pthread_attr_init(&attr);
+
+	affinity = kvm->vcpu_affinity;
+	if (affinity) {
+		ret = pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), affinity);
+		if (ret) {
+			/* Set errno so the caller can call die_perror(). */
+			errno = ret;
+			/* kvmtool treats a negative return value as an error. */
+			return -ret;
+		}
+	}
+
+	ret = pthread_create(thread, &attr, start_routine, arg);
+	if (ret)
+		errno = ret;
+
+	pthread_attr_destroy(&attr);
+
+	return -ret;
+}
-- 
2.55.0

