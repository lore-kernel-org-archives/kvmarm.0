Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A43DC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 15:56:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B114B4B26D;
	Thu, 28 Apr 2022 11:56:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sxExJu9AJvE2; Thu, 28 Apr 2022 11:56:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E02A4B2B6;
	Thu, 28 Apr 2022 11:56:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE31E4B27F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c9kPBIAWa-e2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 11:56:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D74734B279
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A55921474;
 Thu, 28 Apr 2022 08:56:23 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EF623F774;
 Thu, 28 Apr 2022 08:56:21 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: julien.thierry.kdev@gmail.com, will@kernel.org, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH kvmtool 10/15] arm/arm64: Consolidate RAM initialization in
 kvm__init_ram()
Date: Thu, 28 Apr 2022 16:55:57 +0100
Message-Id: <20220428155602.29445-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428155602.29445-1-alexandru.elisei@arm.com>
References: <20220428155602.29445-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: Julien Grall <julien.grall@arm.com>
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

From: Julien Grall <julien.grall@arm.com>

RAM initialization is unnecessarily split between kvm__init_ram() and
kvm__arch_init(). Move all code related to RAM initialization to
kvm__init_ram(), making the code easier to follow and to modify.

One thing to note is that the initialization order is slightly altered:
kvm__arch_enable_mte() and gic__create() are now called before mmap'ing the
guest RAM. That is perfectly fine, as they don't use the host's mapping of
the guest memory.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index bd44aa350796..abcccfabf59e 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -26,9 +26,34 @@ bool kvm__arch_cpu_supports_vm(void)
 
 void kvm__init_ram(struct kvm *kvm)
 {
-	int err;
 	u64 phys_start, phys_size;
 	void *host_mem;
+	int err;
+
+	/*
+	 * Allocate guest memory. We must align our buffer to 64K to
+	 * correlate with the maximum guest page size for virtio-mmio.
+	 * If using THP, then our minimal alignment becomes 2M.
+	 * 2M trumps 64K, so let's go with that.
+	 */
+	kvm->ram_size = kvm->cfg.ram_size;
+	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
+	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
+						kvm->cfg.hugetlbfs_path,
+						kvm->arch.ram_alloc_size);
+
+	if (kvm->arch.ram_alloc_start == MAP_FAILED)
+		die("Failed to map %lld bytes for guest memory (%d)",
+		    kvm->arch.ram_alloc_size, errno);
+
+	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
+					SZ_2M);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_MERGEABLE);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_HUGEPAGE);
 
 	phys_start	= ARM_MEMORY_AREA;
 	phys_size	= kvm->ram_size;
@@ -59,31 +84,6 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_init(struct kvm *kvm)
 {
-	/*
-	 * Allocate guest memory. We must align our buffer to 64K to
-	 * correlate with the maximum guest page size for virtio-mmio.
-	 * If using THP, then our minimal alignment becomes 2M.
-	 * 2M trumps 64K, so let's go with that.
-	 */
-	kvm->ram_size = kvm->cfg.ram_size;
-	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
-	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
-						kvm->cfg.hugetlbfs_path,
-						kvm->arch.ram_alloc_size);
-
-	if (kvm->arch.ram_alloc_start == MAP_FAILED)
-		die("Failed to map %lld bytes for guest memory (%d)",
-		    kvm->arch.ram_alloc_size, errno);
-
-	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
-					SZ_2M);
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_MERGEABLE);
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_HUGEPAGE);
-
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
