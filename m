Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48103C17
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 12:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB76C4339E;
	Wed, 19 Apr 2023 12:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681906866;
	bh=8UBdKctWOEG6f4Vj4U+yQPxgCC3umzI+ZqDBvla3HOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzlyZEyNHFBnmtx4fVtLbGdkoiGOyEj/OuWAi2MHz/1grB/UtpEq+hPL6irfLpoJ0
	 J7PLRYuNfjft+fmKB1Y1XcbCD8fx2ic9bb6T1YKDPwMznApPrGj1vbQdZqgF+1T1Ko
	 GpYmgsCEdxlk1DVcZuyqoi5AmV0NuA4UaLzoT3GXRv6DTtQrAz5aoz5aoYq6mPImnj
	 bO73CIEFNAyNIsf9g7Ef5f3RaqL/5Qru9VU3cCgS/czoscNYBzYolTNyqhcYecZYuM
	 Dgak6zqUCxMn9QeHPAAppzGeDuu8oYdsqYB7lpuR8iAHfHmB521slQXfJ2QummArT4
	 d9/I9pyDEqIfA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	Andrew Walbran <qwandor@google.com>
Subject: [PATCH v2 03/10] KVM: arm64: Allocate pages for hypervisor FF-A mailboxes
Date: Wed, 19 Apr 2023 13:20:44 +0100
Message-Id: <20230419122051.1341-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230419122051.1341-1-will@kernel.org>
References: <20230419122051.1341-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The FF-A proxy code needs to allocate its own buffer pair for
communication with EL3 and for forwarding calls from the host at EL1.

Reserve a couple of pages for this purpose and use them to initialise
the hypervisor's FF-A buffer structure.

Co-developed-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h     |  8 ++++++++
 arch/arm64/kvm/hyp/include/nvhe/ffa.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 24 +++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  8 +++++++-
 arch/arm64/kvm/pkvm.c                 |  1 +
 5 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 01129b0d4c68..2b495ec59deb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -106,4 +106,12 @@ static inline unsigned long host_s2_pgtable_pages(void)
 	return res;
 }
 
+#define KVM_FFA_MBOX_NR_PAGES	1
+
+static inline unsigned long hyp_ffa_proxy_pages(void)
+{
+	/* A page each for the hypervisor's RX and TX mailboxes. */
+	return 2 * KVM_FFA_MBOX_NR_PAGES;
+}
+
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
index 5c9b92430ff3..1becb10ecd80 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/ffa.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -11,7 +11,7 @@
 #define FFA_MIN_FUNC_NUM 0x60
 #define FFA_MAX_FUNC_NUM 0x7F
 
-int hyp_ffa_init(void);
+int hyp_ffa_init(void *pages);
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt);
 
 #endif /* __KVM_HYP_FFA_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index b387e433f15e..de0fba79b195 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -28,8 +28,11 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/arm_ffa.h>
+#include <asm/kvm_pkvm.h>
+
 #include <nvhe/ffa.h>
 #include <nvhe/trap_handler.h>
+#include <nvhe/spinlock.h>
 
 /*
  * "ID value 0 must be returned at the Non-secure physical FF-A instance"
@@ -37,6 +40,19 @@
  */
 #define HOST_FFA_ID	0
 
+struct kvm_ffa_buffers {
+	hyp_spinlock_t lock;
+	void *tx;
+	void *rx;
+};
+
+/*
+ * Note that we don't currently lock these buffers explicitly, instead
+ * relying on the locking of the host FFA buffers as we only have one
+ * client.
+ */
+static struct kvm_ffa_buffers hyp_buffers;
+
 static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
 {
 	*res = (struct arm_smccc_res) {
@@ -111,7 +127,7 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt)
 	return true;
 }
 
-int hyp_ffa_init(void)
+int hyp_ffa_init(void *pages)
 {
 	struct arm_smccc_res res;
 
@@ -132,5 +148,11 @@ int hyp_ffa_init(void)
 	if (res.a2 != HOST_FFA_ID)
 		return -EINVAL;
 
+	hyp_buffers = (struct kvm_ffa_buffers) {
+		.lock	= __HYP_SPIN_LOCK_UNLOCKED,
+		.tx	= pages,
+		.rx	= pages + (KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE),
+	};
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c4ca174a0592..bb98630dfeaf 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -29,6 +29,7 @@ static void *vmemmap_base;
 static void *vm_table_base;
 static void *hyp_pgt_base;
 static void *host_s2_pgt_base;
+static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
 
@@ -58,6 +59,11 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!host_s2_pgt_base)
 		return -ENOMEM;
 
+	nr_pages = hyp_ffa_proxy_pages();
+	ffa_proxy_pages = hyp_early_alloc_contig(nr_pages);
+	if (!ffa_proxy_pages)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -315,7 +321,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = hyp_ffa_init();
+	ret = hyp_ffa_init(ffa_proxy_pages);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf56958b1492..bb405e274df6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -74,6 +74,7 @@ void __init kvm_hyp_reserve(void)
 	hyp_mem_pages += host_s2_pgtable_pages();
 	hyp_mem_pages += hyp_vm_table_pages();
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
+	hyp_mem_pages += hyp_ffa_proxy_pages();
 
 	/*
 	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
-- 
2.40.0.634.g4ca3ef3211-goog

