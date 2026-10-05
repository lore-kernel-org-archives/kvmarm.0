Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F97B42E41B;
	Mon,  5 Oct 2026 09:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191306; cv=none; b=Ey1P+VTxzCMEDAVglVuZEkS6uZBjFLXwHaPp5wtvLkZeFweKvxSGQ+m9Gchx0zCUZw2opc4UBP9Z/Zc2XXxjI93+THfpovpAYpMuRzLwt7sLJUW8Eie7sRwKjd7AbWB+b4RXKnIz0TvAGv4G9cgItvHjkiNNKw8ycOO4vlIh8K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191306; c=relaxed/simple;
	bh=1Ms5qLJVNPR5n23ejc1pMT4NfsrietEoM1o9II90Ows=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7hYRPTZlKgQnHH8A1OZn6Q4OkAux7vXa4+18+Lz9aSLvgTGgt21GkO5UxwVnC9cQWtFOq+V7bqldDiQdH1SiamvqsoUP2c3OawnbtUiTNR2nxKpI0BlOjr+e9UKpbgQ0T54P+X7R76/2F0sivC/5cJbpbIHqQyZA8oaNBkbpJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g5RtsZkf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g5RtsZkf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98E3E1576;
	Mon,  5 Oct 2026 02:08:16 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DD3C33F66F;
	Mon,  5 Oct 2026 02:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191300; bh=1Ms5qLJVNPR5n23ejc1pMT4NfsrietEoM1o9II90Ows=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5RtsZkfrpEXPNDPzJPaYuGo82Sv+QclA4NMUWmeBDNAUkudRfEQIn1S3NcL1KVBY
	 jlxPwPb6+9bIyKOs9MAGamR3Y2bFWv5mulbxUSUdHjjIxemETowfTaG7ns9xYvfl2B
	 CS9EUMUxBwhw7VJa4AAKGI423LYNYS6fKLMPJ+dU=
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
Subject: [PATCH v22 04/23] KVM: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
Date: Mon,  5 Oct 2026 10:07:35 +0100
Message-ID: <20261005090754.2140522-5-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
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

