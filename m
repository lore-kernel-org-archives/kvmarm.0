Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C38140F8E0;
	Thu, 30 Apr 2026 11:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777547754; cv=none; b=OPNknyO+MUCIZhSTyEnPn0OG/MedXsZSQ9Ek4GIsgxJWXIv/QIbNiGrWpxIzm1NldYEvbXOk6Mh90F62HWAem+ZqfwuSbAwodhkYQefZwRJbBoQYZ0w4qSmAPoXcI8jj1Osb6WryBEya+niNVo098M4SPhfX/h5MjYe2UXcK2uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777547754; c=relaxed/simple;
	bh=ZkdGKyLMclIRLyhqJWVYz05PFVKmF2W5SXHOKUVIcOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRkCHfwgFl8LohGLKMMGROhcNu0bPCfR3I1pEo3cU14rHtUIMADgvQnd4u4WDFDzOr0PuRDdfL0TMEynBIaENg65ol9xsooTxz+Yo6soe0X1w8tfP5/heSDGOV7aKtqBvaa2DbU1V8DyCfanHF9KZUl4Uh5DBJskTMn5fUssWpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DTy0btji; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DTy0btji"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 802A13560;
	Thu, 30 Apr 2026 04:15:46 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A8073F763;
	Thu, 30 Apr 2026 04:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777547751; bh=ZkdGKyLMclIRLyhqJWVYz05PFVKmF2W5SXHOKUVIcOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTy0btjiqfmFNn4qxNqdiFWNbIgLEI7bpRci9Kvb2fZY44VLTAaUKOwe0pOTWa793
	 P8WHa0X0PMRXQhJswIXFKvgT75GatY47ZfDzy2oKchbItvbABKfxae2ssSB8YjOcyM
	 FpawrYNUnaFmYrHZaEa/eOsaHxdw20L1bnVSQaic=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v1 07/12] kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning
Date: Thu, 30 Apr 2026 12:14:11 +0100
Message-ID: <20260430111424.3479613-9-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430111424.3479613-2-leo.bras@arm.com>
References: <20260430111424.3479613-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce kvm_arch_dirty_log_clear() that allow implementation of
arch-specific hardware-accelerated dirty-log routines.

A call to that is added on both kvm_get_dirty_log_protect() and
kvm_clear_dirty_log_protect() and will fall back to software version if
not implemented, or any error was detected in the arch-specific routine.

For an arch to implement this function, it's required to provide an
asm/kvm_dirty_bit.h and have CONFIG_HAVE_KVM_HW_DIRTY_BIT=y on building.

If the arch does not implement it, and thus lack above config, the
introduced snippet is expected to be compiled-out and have zero impact at
runtime.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 include/linux/kvm_dirty_bit.h | 27 +++++++++++++++++++++++++++
 virt/kvm/kvm_main.c           | 13 ++++++++++++-
 virt/kvm/Kconfig              |  3 +++
 3 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kvm_dirty_bit.h

diff --git a/include/linux/kvm_dirty_bit.h b/include/linux/kvm_dirty_bit.h
new file mode 100644
index 000000000000..fa4f6b67b623
--- /dev/null
+++ b/include/linux/kvm_dirty_bit.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ * Author: Leonardo Bras <leo.bras@arm.com>
+ */
+
+#ifndef __KVM_DIRTY_BIT_H__
+#define __KVM_DIRTY_BIT_H__
+
+#ifndef CONFIG_HAVE_KVM_HW_DIRTY_BIT
+
+static inline int kvm_arch_dirty_log_clear(struct kvm *kvm,
+					   struct kvm_memory_slot *memslot,
+					   struct kvm_clear_dirty_log *log,
+					   unsigned long *bitmap,
+					   bool *flush)
+{
+	return -ENXIO;
+}
+
+#else /* CONFIG_HAVE_KVM_HW_DIRTY_BIT */
+
+#include <asm/kvm_dirty_bit.h>
+
+#endif /* CONFIG_HAVE_KVM_HW_DIRTY_BIT */
+
+#endif /* __KVM_DIRTY_BIT_H__ */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 89489996fbc1..7f5048ca9a25 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -58,20 +58,21 @@
 #include "async_pf.h"
 #include "kvm_mm.h"
 #include "vfio.h"
 
 #include <trace/events/ipi.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
 
 #include <linux/kvm_dirty_ring.h>
+#include <linux/kvm_dirty_bit.h>
 
 
 /* Worst case buffer size needed for holding an integer. */
 #define ITOA_MAX_LEN 12
 
 MODULE_AUTHOR("Qumranet");
 MODULE_DESCRIPTION("Kernel-based Virtual Machine (KVM) Hypervisor");
 MODULE_LICENSE("GPL");
 
 /* Architectures should define their poll value according to the halt latency */
@@ -2255,39 +2256,44 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 		 * is some code duplication between this function and
 		 * kvm_get_dirty_log, but hopefully all architecture
 		 * transition to kvm_get_dirty_log_protect and kvm_get_dirty_log
 		 * can be eliminated.
 		 */
 		dirty_bitmap_buffer = dirty_bitmap;
 	} else {
 		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 		memset(dirty_bitmap_buffer, 0, n);
 
+		if (kvm_arch_dirty_log_clear(kvm, memslot, NULL,
+					     dirty_bitmap_buffer, &flush) >= 0)
+			goto out;
+
 		KVM_MMU_LOCK(kvm);
 		for (i = 0; i < n / sizeof(long); i++) {
 			unsigned long mask;
 			gfn_t offset;
 
 			if (!dirty_bitmap[i])
 				continue;
 
 			flush = true;
 			mask = xchg(&dirty_bitmap[i], 0);
 			dirty_bitmap_buffer[i] = mask;
 
 			offset = i * BITS_PER_LONG;
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
 		KVM_MMU_UNLOCK(kvm);
 	}
 
+out:
 	if (flush)
 		kvm_flush_remote_tlbs_memslot(kvm, memslot);
 
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
 		return -EFAULT;
 	return 0;
 }
 
 
 /**
@@ -2366,45 +2372,50 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
 	    return -EINVAL;
 
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
 	flush = false;
 	dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
+	if (kvm_arch_dirty_log_clear(kvm, memslot, log, dirty_bitmap_buffer,
+				     &flush) >= 0)
+		goto out;
+
 	KVM_MMU_LOCK(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
 		unsigned long mask = *dirty_bitmap_buffer++;
 		atomic_long_t *p = (atomic_long_t *) &dirty_bitmap[i];
 		if (!mask)
 			continue;
 
 		mask &= atomic_long_fetch_andnot(mask, p);
 
 		/*
 		 * mask contains the bits that really have been cleared.  This
 		 * never includes any bits beyond the length of the memslot (if
 		 * the length is not aligned to 64 pages), therefore it is not
 		 * a problem if userspace sets them in log->dirty_bitmap.
 		*/
 		if (mask) {
 			flush = true;
+
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
 		}
 	}
 	KVM_MMU_UNLOCK(kvm);
-
+out:
 	if (flush)
 		kvm_flush_remote_tlbs_memslot(kvm, memslot);
 
 	return 0;
 }
 
 static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 					struct kvm_clear_dirty_log *log)
 {
 	int r;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 794976b88c6f..f8757b5b84b3 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -13,20 +13,23 @@ config HAVE_KVM_PFNCACHE
 
 config HAVE_KVM_IRQCHIP
        bool
 
 config HAVE_KVM_IRQ_ROUTING
        bool
 
 config HAVE_KVM_DIRTY_RING
        bool
 
+config HAVE_KVM_HW_DIRTY_BIT
+       bool
+
 # Only strongly ordered architectures can select this, as it doesn't
 # put any explicit constraint on userspace ordering. They can also
 # select the _ACQ_REL version.
 config HAVE_KVM_DIRTY_RING_TSO
        bool
        select HAVE_KVM_DIRTY_RING
        depends on X86
 
 # Weakly ordered architectures can only select this, advertising
 # to userspace the additional ordering requirements.
-- 
2.54.0

