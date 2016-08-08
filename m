From: Stefan Agner <stefan@agner.ch>
Subject: [PATCH] kvmtool: ARM: madvise mergeable and hugepage separately
Date: Mon,  8 Aug 2016 00:01:44 -0700
Message-ID: <20160808070144.17712-1-stefan@agner.ch>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc.Zyngier@arm.com, will.deacon@arm.com, penberg@kernel.org, Stefan Agner <stefan@agner.ch>
List-Id: kvmarm@lists.cs.columbia.edu

The madvise behavior is not a bit field and hence can not be or'ed.
Also madvise_behavior_valid checks the flag using a case statement
hence only one behavior is supposed to be supplied. Call madvise
twice, once for MERGEABLE and once for HUGEPAGE.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arm/kvm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index ce40897..3cfa90a 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -80,7 +80,10 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 					SZ_2M);
 
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_MERGEABLE | MADV_HUGEPAGE);
+		MADV_MERGEABLE);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_HUGEPAGE);
 
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
-- 
2.9.0

