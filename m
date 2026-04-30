Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D3541C31C;
	Thu, 30 Apr 2026 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777547767; cv=none; b=Bp+IpbljJhYsjUnD2Y2892tUktmEuPCWh0w6e4HniEZk5LDTaFVpRV0uXuOELaytJ+hrCiqrslHLmtY9X4mxejsHdfeFjBTFbyhWyTgekyeu5fPeNkGyBIJap3Ez3WictXwLInfVWUSUmmNrwtcGUs9CVHldfX/+sEspyWaqhkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777547767; c=relaxed/simple;
	bh=q/NKBboAJbYod0gf/Ix7PhIBx5sQObfz8OK5XkSm43U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiiiIGjo+RDfEKqriyHQGpfnqtQ/tGN+40nmaNJHJSm6BcNZ61mDpo5wiLDib5/ZEjVQaZcnJb1hy2Qz5XPxCNfcYe9vZjoh31vVIs5yo6p/RwXU7bGTp4vhgsdhEcyWM1iDvtVwyzrExUfb5LhY7RHjhlruuAfYJwFl0dRjE6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FSbrttDP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FSbrttDP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D258356D;
	Thu, 30 Apr 2026 04:16:00 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A74FE3F763;
	Thu, 30 Apr 2026 04:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777547766; bh=q/NKBboAJbYod0gf/Ix7PhIBx5sQObfz8OK5XkSm43U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSbrttDP37W00c2im+As8lbB9vFtmE6uJ9NzYPqQ3NMp6zj+bbLmMx0UJzC0mQFqd
	 6KAv8y+ZoToAfNeKB9S9rTApTp0aGj2Ho03zvSWm/l7x3CUSKbsHT2UXzw6nnhNhpZ
	 rxEKsVBwtyHdo0l3m397C4nOzNUMf1dqUCse7okI=
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
Subject: [PATCH v1 10/12] kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cleaning
Date: Thu, 30 Apr 2026 12:14:14 +0100
Message-ID: <20260430111424.3479613-12-leo.bras@arm.com>
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

Introduce kvm_arch_dirty_ring_clear() that allow implementation of
arch-specific hardware-accelerated dirty-ring routines.

A call to that is added on kvm_dirty_ring_reset() and will fall back to
software version if not implemented, or any error was detected in the
arch-specific routine.

For an arch to implement this function, it's required to provide it in a
asm/kvm_dirty_bit.h and have CONFIG_HAVE_KVM_HW_DIRTY_BIT=y on building.

If the arch does not implement it, and thus lack above config, the
introduced snippet is expected to be compiled-out and have zero impact at
runtime.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 include/linux/kvm_dirty_bit.h | 7 +++++++
 virt/kvm/dirty_ring.c         | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/kvm_dirty_bit.h b/include/linux/kvm_dirty_bit.h
index fa4f6b67b623..8492979d694e 100644
--- a/include/linux/kvm_dirty_bit.h
+++ b/include/linux/kvm_dirty_bit.h
@@ -11,17 +11,24 @@
 
 static inline int kvm_arch_dirty_log_clear(struct kvm *kvm,
 					   struct kvm_memory_slot *memslot,
 					   struct kvm_clear_dirty_log *log,
 					   unsigned long *bitmap,
 					   bool *flush)
 {
 	return -ENXIO;
 }
 
+static inline int kvm_arch_dirty_ring_clear(struct kvm *kvm,
+					    struct kvm_dirty_ring *ring,
+					    int *nr_entries_reset)
+{
+	return -ENXIO;
+}
+
 #else /* CONFIG_HAVE_KVM_HW_DIRTY_BIT */
 
 #include <asm/kvm_dirty_bit.h>
 
 #endif /* CONFIG_HAVE_KVM_HW_DIRTY_BIT */
 
 #endif /* __KVM_DIRTY_BIT_H__ */
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 83ac5ac907c1..a58c811dd461 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -1,20 +1,21 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * KVM dirty ring implementation
  *
  * Copyright 2019 Red Hat, Inc.
  */
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/vmalloc.h>
 #include <linux/kvm_dirty_ring.h>
+#include <linux/kvm_dirty_bit.h>
 #include <trace/events/kvm.h>
 #include "kvm_mm.h"
 
 int __weak kvm_cpu_dirty_log_size(struct kvm *kvm)
 {
 	return 0;
 }
 
 u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm)
 {
@@ -125,20 +126,23 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
 	struct kvm_dirty_gfn *entry;
 
 	/*
 	 * Ensure concurrent calls to KVM_RESET_DIRTY_RINGS are serialized,
 	 * e.g. so that KVM fully resets all entries processed by a given call
 	 * before returning to userspace.  Holding slots_lock also protects
 	 * the various memslot accesses.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
 
+	if (kvm_arch_dirty_ring_clear(kvm, ring, nr_entries_reset) >= 0)
+		return 0;
+
 	while (likely((*nr_entries_reset) < INT_MAX)) {
 		if (signal_pending(current))
 			return -EINTR;
 
 		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
 
 		if (!kvm_dirty_gfn_harvested(entry))
 			break;
 
 		next_slot = READ_ONCE(entry->slot);
-- 
2.54.0

