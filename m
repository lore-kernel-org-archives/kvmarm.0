Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7EB410D13;
	Wed,  7 Oct 2026 07:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358567; cv=none; b=CP04c5PIXu1QuBOMmCtjAqml+9KMox2KsRl3VdJj7+x8MNX5tYdH0xNRhf/C8WVLA7zgLPEyI4iJ+/U7vnM4rW6XBXWW2Bg6mrzMuGZvraDXI4MJcaV0OS5ulWwFwO7pq6rSc/ldjCt0CYlVjz3hts8+0jSVFhYVheo1DAvsgpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358567; c=relaxed/simple;
	bh=1Ms5qLJVNPR5n23ejc1pMT4NfsrietEoM1o9II90Ows=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5gG3ybBEOGHPZMAxMbXfj8QFGkGXyxU0J99r4nKDLbn9aCdL8iti963rHElAJBGrgLO5ZjvYlZFFVfyJyClUUJnr2jGp+t9njnrwNWn7a5tDZiagdaUQOcBKXVcP3MnCA44b6SaRHbZaXbuzF5RgDUYnfgMIpwnhU1b0Kx4LRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=akIr9NTq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="akIr9NTq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88EEA1477;
	Wed,  7 Oct 2026 00:36:01 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3CAB63F763;
	Wed,  7 Oct 2026 00:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791358564; bh=1Ms5qLJVNPR5n23ejc1pMT4NfsrietEoM1o9II90Ows=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akIr9NTqk1NNVwMv6IRI4qv0jfZ+t0Sb7rCGQ+q7zGfjqr0gSFN0k0RqbnGhYXjfj
	 Fd6bqx2BE77puG677FmZim0rXghFnnlNMga6JtCqzX9og/9xE+uFyDs9qZJtgHKj5x
	 MTaTNuLR/zW35ngasZHt/yCSnRcyTGFkoOxdUyLg=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v23 04/14] KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
Date: Wed,  7 Oct 2026 08:35:27 +0100
Message-ID: <20261007073537.2454351-5-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007073537.2454351-1-suzuki.poulose@arm.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

To avoid future include cycles, drop the linux/kvm_host.h include in
kvm_pgtable.h and include the lightweight headers required for the types
and inline helpers used there. Additionally provide a forward
declaration for struct kvm_s2_mmu as it's only used as a pointer in this
file.

Both pgtable.c and kvm_pkvm.h relied on the indirect inclusion of
kvm_host.h, so make that explicit.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v19:
 - Include asm/memory.h, asm/page.h , linux/bitfield.h in asm/kvm_pgtable.h
   (Sashiko)
---
 arch/arm64/include/asm/kvm_pgtable.h | 10 +++++++++-
 arch/arm64/include/asm/kvm_pkvm.h    |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb6..a211a5d87bf96 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -7,10 +7,18 @@
 #ifndef __ARM64_KVM_PGTABLE_H__
 #define __ARM64_KVM_PGTABLE_H__
 
+#include <linux/bitfield.h>
 #include <linux/bits.h>
-#include <linux/kvm_host.h>
+#include <linux/kvm_types.h>
+#include <linux/rbtree_types.h>
+#include <linux/rcupdate.h>
 #include <linux/types.h>
 
+#include <asm/memory.h>
+#include <asm/page.h>
+
+struct kvm_s2_mmu;
+
 #define KVM_PGTABLE_FIRST_LEVEL		-1
 #define KVM_PGTABLE_LAST_LEVEL		3
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index beea00e693a0a..54a618d887fa4 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -7,9 +7,9 @@
 #define __ARM64_KVM_PKVM_H__
 
 #include <linux/arm_ffa.h>
+#include <linux/kvm_host.h>
 #include <linux/memblock.h>
 #include <linux/scatterlist.h>
-#include <asm/kvm_host.h>
 #include <asm/kvm_pgtable.h>
 
 /* Maximum number of VMs that can co-exist under pKVM. */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd3..f48253b9d88b5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/kvm_host.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-- 
2.43.0

