Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F46A339705;
	Wed, 13 May 2026 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678312; cv=none; b=ogJSBqV90aVvvTu3n/+9oH62OzVgn3+yaKSrKYsUAm0nIhgaASGnlAoBPV0D4JNF3dbbHG74yaEwQhqBouPHqDflTGmf/VEMubQ9aYGMlYQMs0NMV8d3uoFLp4kEdZzJ0we7soWCWAZ3te1zwbrbCQ+7vTCf/M4IMAa/6MkMxiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678312; c=relaxed/simple;
	bh=L2CeU8vxIxbtmaEZc3t55CUNGK5e4FMZDRDaVix4sq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stfVcaevPffDoyR/a/jmCIRv6eSkPfJvGznJdahdfgRmEXjyX09GRfz14uqK0US+nwmHCqIU1eFqR6bdaY0wVHLAUee8ajwJ+cJNpBJyoA5bIWJWtEVxpChXGYLazaNmpAYZ75SH9pFmlB977wAxVH+m5ObX/f96vERMGydklGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tnCIj/2x; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tnCIj/2x"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C79FC1E2F;
	Wed, 13 May 2026 06:18:24 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68CCF3F836;
	Wed, 13 May 2026 06:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678310; bh=L2CeU8vxIxbtmaEZc3t55CUNGK5e4FMZDRDaVix4sq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnCIj/2xwLblTM/Ij6JP9/NL7go962aQhxYY1e8MYBkOeaWsKN3edKqiQ2c8pzj2e
	 oxVyFhNXWDFF+VKeq4hZhchmXM3W/yQQqDYQOjEcjVq/t4OQT8r9AAI3bnfb3RuC2x
	 etf55nU10Xtsi0yOxBtPxbV65yPId1IykH57WaQc=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 02/44] kvm: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
Date: Wed, 13 May 2026 14:17:10 +0100
Message-ID: <20260513131757.116630-3-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To avoid future include cycles, drop the linux/kvm_host.h include in
kvm_pgtable.h and include two _types.h headers for the types that are
actually used. Additionally provide a forward declaration for struct
kvm_s2_mmu as it's only used as a pointer in this file.

Both pgtable.c and kvm_pkvm.h relied on the indirect inclusion of
kvm_host.h, so make that explicit.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch in v13
---
 arch/arm64/include/asm/kvm_pgtable.h | 5 ++++-
 arch/arm64/include/asm/kvm_pkvm.h    | 2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..e4770ce2ccf6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -8,9 +8,12 @@
 #define __ARM64_KVM_PGTABLE_H__
 
 #include <linux/bits.h>
-#include <linux/kvm_host.h>
+#include <linux/kvm_types.h>
+#include <linux/rbtree_types.h>
 #include <linux/types.h>
 
+struct kvm_s2_mmu;
+
 #define KVM_PGTABLE_FIRST_LEVEL		-1
 #define KVM_PGTABLE_LAST_LEVEL		3
 
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 2954b311128c..1bc6a6a34ec9 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -9,7 +9,7 @@
 #include <linux/arm_ffa.h>
 #include <linux/memblock.h>
 #include <linux/scatterlist.h>
-#include <asm/kvm_host.h>
+#include <linux/kvm_host.h>
 #include <asm/kvm_pgtable.h>
 
 /* Maximum number of VMs that can co-exist under pKVM. */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0c1defa5fb0f..0bcd6f06aafb 100644
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

