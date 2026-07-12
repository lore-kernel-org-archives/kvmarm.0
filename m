Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C839223909C
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 14:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866348; cv=none; b=WlOWyk3RYFLeHMKmIK8nBL+iZN5T12hw7IpdaFSme+C70eupMigDkSTNh+sFu1xeWz686c0v9N72Z6LErjARb8+aIQV2+VI2cgmfd0itwo0aTGFOKRT0YXaIEUmOkbnR9PwcW4q3zg+/l6Rdh1gvATSL0G7ArK/75OteIuhK9S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866348; c=relaxed/simple;
	bh=zDee0O5bUccRL0ytn5PGHBNbXYzS/C5+Qfc/9gT652o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZAdgxfx7+by04Ggdd2rxJaD1pws1V81JWMFHh09EwLPQdHDI7So/dXzMIRxMBJK7fKEWj9R2GgikyEND4bTYv6Q+bw65Y1b9x9AK71lTS6d+0X5A+/lRikWgZAprr3HDYvYuHRjGbSCWDpzJ+lI2t7ycCEGCNFUMQ2ByX33KLLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MBTLM7Zq; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MBTLM7Zq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783866345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IJTxnwkxV4oNUQwN7nAwkMtaydKsovFwm+AG4cw9+SA=;
	b=MBTLM7ZqbfCctRrdeNiUjpwyv2Xr/dAM8+UPmht2niOw3zyaYcy6RCze7QVaSKcjcgkgLW
	fHCiQwW4uJbkoDIpybaRKiYV7UGDv4gYkSyk6QSycEUP2vt+8eTDT+5NtVozjXRw2uLeKS
	p0VCIDkpDyEoA/lrN8yhURRsCEx9pLY=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool v3 4/4] arm64: Add --guest-memfd option to back guest RAM with guest_memfd
Date: Sun, 12 Jul 2026 15:25:36 +0100
Message-Id: <20260712142536.1391557-5-fuad.tabba@linux.dev>
In-Reply-To: <20260712142536.1391557-1-fuad.tabba@linux.dev>
References: <20260712142536.1391557-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Back guest RAM with a guest_memfd created with GUEST_MEMFD_FLAG_MMAP
and GUEST_MEMFD_FLAG_INIT_SHARED, mmapped MAP_SHARED to provide the
userspace mapping. The guest_memfd file descriptor is closed at
teardown, after the mapping is removed.

MTE is disabled when --guest-memfd is used: guest_memfd VMAs do not
have VM_MTE_ALLOWED, so KVM rejects the memslot if MTE is enabled.

Protected VMs need in-place shared/private conversion of guest_memfd,
which the kernel does not support yet, so reject the combination of
--protected and --guest-memfd.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arm64/include/kvm/kvm-config-arch.h |  5 +++-
 arm64/kvm.c                         | 44 +++++++++++++++++++++++++----
 include/kvm/kvm.h                   |  1 +
 include/kvm/util.h                  |  1 +
 kvm.c                               |  1 +
 util/util.c                         | 37 ++++++++++++++++++++++++
 6 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
index c2702d5..d8a8ef7 100644
--- a/arm64/include/kvm/kvm-config-arch.h
+++ b/arm64/include/kvm/kvm-config-arch.h
@@ -20,6 +20,7 @@ struct kvm_config_arch {
 	bool		no_pvtime;
 	bool		psci;
 	bool		protected;
+	bool		guest_memfd;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
@@ -73,6 +74,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
 	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
 		    "Create guest without VHE support"),			\
 	OPT_BOOLEAN('\0', "protected", &(cfg)->protected,			\
-			"Create a protected VM when pKVM is enabled"),
+			"Create a protected VM when pKVM is enabled"),		\
+	OPT_BOOLEAN('\0', "guest-memfd", &(cfg)->guest_memfd,			\
+			"Use guest_memfd to back guest RAM"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm64/kvm.c b/arm64/kvm.c
index fb0b98d..36b3284 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -49,7 +49,12 @@ void kvm__init_ram(struct kvm *kvm)
 	kvm->arch.ram_alloc_size = kvm->ram_size;
 	if (!kvm->cfg.hugetlbfs_path)
 		kvm->arch.ram_alloc_size += SZ_2M;
-	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
+
+	if (kvm->cfg.arch.guest_memfd)
+		kvm->arch.ram_alloc_start = mmap_guest_memfd(kvm,
+						kvm->arch.ram_alloc_size);
+	else
+		kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
 						kvm->cfg.hugetlbfs_path,
 						kvm->arch.ram_alloc_size);
 
@@ -60,17 +65,25 @@ void kvm__init_ram(struct kvm *kvm)
 	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
 					SZ_2M);
 
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_MERGEABLE);
+	if (!kvm->cfg.arch.guest_memfd) {
+		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+			MADV_MERGEABLE);
 
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_HUGEPAGE);
+		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+			MADV_HUGEPAGE);
+	}
 
 	phys_start	= kvm->cfg.ram_addr;
 	phys_size	= kvm->ram_size;
 	host_mem	= kvm->ram_start;
 
-	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	if (kvm->cfg.arch.guest_memfd)
+		err = kvm__register_ram_guest_memfd(kvm, phys_start,
+						    phys_size, host_mem,
+						    kvm->ram_guest_memfd,
+						    host_mem - kvm->arch.ram_alloc_start);
+	else
+		err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
 	if (err)
 		die("Failed to register %lld bytes of memory at physical "
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
@@ -84,6 +97,11 @@ void kvm__init_ram(struct kvm *kvm)
 void kvm__arch_delete_ram(struct kvm *kvm)
 {
 	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+
+	if (kvm->ram_guest_memfd >= 0) {
+		close(kvm->ram_guest_memfd);
+		kvm->ram_guest_memfd = -1;
+	}
 }
 
 void kvm__arch_read_term(struct kvm *kvm)
@@ -107,6 +125,11 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
 		return;
 	}
 
+	if (kvm->cfg.arch.guest_memfd) {
+		pr_debug("MTE is incompatible with guest_memfd");
+		return;
+	}
+
 	if (kvm->cfg.arch.mte_disabled) {
 		pr_debug("MTE disabled by user");
 		return;
@@ -468,6 +491,15 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
 	if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
 		pr_warning("--e2h0 requires --nested, ignoring");
 
+	if (kvm->cfg.arch.guest_memfd) {
+		/* Requires in-place shared/private conversion of guest_memfd. */
+		if (kvm->cfg.arch.protected)
+			die("Protected VMs do not yet support guest_memfd");
+
+		if (kvm->cfg.hugetlbfs_path)
+			die("guest_memfd cannot be backed by hugetlbfs");
+	}
+
 	if (kvm->cfg.arch.protected) {
 		if (kvm->cfg.ram_size &&
 		    kvm->cfg.ram_size < DMA_MEM_REGION_SIZE) {
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 077aaee..a9376b6 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -90,6 +90,7 @@ struct kvm {
 	u64			ram_size;	/* Guest memory size, in bytes */
 	void			*ram_start;
 	u64			ram_pagesize;
+	int			ram_guest_memfd; /* guest_memfd backing RAM, -1 if none */
 	struct mutex		mem_banks_lock;
 	struct list_head	mem_banks;
 
diff --git a/include/kvm/util.h b/include/kvm/util.h
index a6dba11..9e23431 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -148,5 +148,6 @@ static inline int pow2_size(unsigned long x)
 struct kvm;
 void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
+void *mmap_guest_memfd(struct kvm *kvm, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/kvm.c b/kvm.c
index 947721b..96583f9 100644
--- a/kvm.c
+++ b/kvm.c
@@ -162,6 +162,7 @@ struct kvm *kvm__new(void)
 	mutex_init(&kvm->mem_banks_lock);
 	kvm->sys_fd = -1;
 	kvm->vm_fd = -1;
+	kvm->ram_guest_memfd = -1;
 
 #ifdef KVM_BRLOCK_DEBUG
 	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
diff --git a/util/util.c b/util/util.c
index 05d49c4..51a4591 100644
--- a/util/util.c
+++ b/util/util.c
@@ -6,7 +6,9 @@
 #include "kvm/util.h"
 
 #include <kvm/kvm.h>
+#include <linux/kvm.h>
 #include <linux/magic.h>	/* For HUGETLBFS_MAGIC */
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
@@ -169,3 +171,38 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 si
 		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	}
 }
+
+/*
+ * Map guest RAM backed by a guest_memfd. The file descriptor is kept open
+ * until teardown (kvm__arch_delete_ram), after the mapping is removed.
+ */
+void *mmap_guest_memfd(struct kvm *kvm, u64 size)
+{
+	u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	struct kvm_create_guest_memfd gmem = {
+		.size	= size,
+		.flags	= flags,
+	};
+	void *addr;
+	int ret;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_GUEST_MEMFD))
+		die("kernel does not support guest_memfd");
+
+	ret = ioctl(kvm->vm_fd, KVM_CHECK_EXTENSION, KVM_CAP_GUEST_MEMFD_FLAGS);
+	if (ret < 0 || ((u64)ret & flags) != flags)
+		die("VM type does not support guest_memfd with mmap");
+
+	ret = ioctl(kvm->vm_fd, KVM_CREATE_GUEST_MEMFD, &gmem);
+	if (ret < 0)
+		die_perror("KVM_CREATE_GUEST_MEMFD");
+
+	addr = mmap(NULL, size, PROT_RW, MAP_SHARED, ret, 0);
+	if (addr == MAP_FAILED)
+		die_perror("guest_memfd mmap");
+
+	kvm->ram_guest_memfd = ret;
+	kvm->ram_pagesize = getpagesize();
+
+	return addr;
+}
-- 
2.39.5

