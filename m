Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBC3C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 14:28:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFB874B25D;
	Fri,  1 Apr 2022 10:28:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IEIpdggWv+Pr; Fri,  1 Apr 2022 10:28:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 773D64B229;
	Fri,  1 Apr 2022 10:28:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EC6C4B120
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id It+7lkL4Q4kU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 10:28:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B763B4B282
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:28:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 490A861CBA;
 Fri,  1 Apr 2022 14:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86548C34114;
 Fri,  1 Apr 2022 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1648823318;
 bh=qjxQ+TuJJClyKJGiJyDQnjheZO2HcHaN/3KsyeKu5cY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hGAzgIKSkvZi5K292zCw0hRaxrHSzBc/IyoXcMvSLWPrSCcu1F87ueVE/f7Obrj/H
 j1mjy4vOI5QShCks9Maf7NGs2FOcXW2n0ZCpeiQGyXiPumqB6P+dN/OrtEBRyREckW
 JokuByKkfghKwpDwk3ZryDlPx/0YM+2rZgJs0zEkmkwCAjME3PldGLYJBycvrJxqrA
 EpUIvMdIic8N/qOkc0TwSUbJhlQyJEUBVPGieeOsiYgHaz3/og0JqMFMyjgoY5NH1Z
 oGlpBZIC97hVgVwhU0thbj9/ynhTTpIsK+kEwnDnbBLb8RKvQ5308/OSg2gQxZ541t
 XDp7rsaNgMsHQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 055/149] kvm: selftests: aarch64: fix some vgic
 related comments
Date: Fri,  1 Apr 2022 10:24:02 -0400
Message-Id: <20220401142536.1948161-55-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit a5cd38fd9c47b23abc6df08d6ee6a71b39038185 ]

Fix the formatting of some comments and the wording of one of them (in
gicv3_access_reg).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-5-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 10 ++++++----
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 48e43e24d240..554ca649d470 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
 	uint32_t prio, intid, ap1r;
 	int i;
 
-	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
+	/*
+	 * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
 	 * in descending order, so intid+1 can preempt intid.
 	 */
 	for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
@@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
 		gic_set_priority(intid, prio);
 	}
 
-	/* In a real migration, KVM would restore all GIC state before running
+	/*
+	 * In a real migration, KVM would restore all GIC state before running
 	 * guest code.
 	 */
 	for (i = 0; i < num; i++) {
@@ -503,7 +505,8 @@ static void guest_code(struct test_args *args)
 		test_injection_failure(args, f);
 	}
 
-	/* Restore the active state of IRQs. This would happen when live
+	/*
+	 * Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
 	for_each_supported_activate_fn(args, set_active_fns, f)
@@ -844,7 +847,8 @@ int main(int argc, char **argv)
 		}
 	}
 
-	/* If the user just specified nr_irqs and/or gic_version, then run all
+	/*
+	 * If the user just specified nr_irqs and/or gic_version, then run all
 	 * combinations.
 	 */
 	if (default_args) {
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index e4945fe66620..263bf3ed8fd5 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -19,7 +19,7 @@ struct gicv3_data {
 	unsigned int nr_spis;
 };
 
-#define sgi_base_from_redist(redist_base) 	(redist_base + SZ_64K)
+#define sgi_base_from_redist(redist_base)	(redist_base + SZ_64K)
 #define DIST_BIT				(1U << 31)
 
 enum gicv3_intid_range {
@@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
 {
 	uint32_t val;
 
-	/* All other fields are read-only, so no need to read CTLR first. In
+	/*
+	 * All other fields are read-only, so no need to read CTLR first. In
 	 * fact, the kernel does the same.
 	 */
 	val = split ? (1U << 1) : 0;
@@ -160,8 +161,9 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
 	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
-	/* Some registers like IROUTER are 64 bit long. Those are currently not
-	 * supported by readl nor writel, so just asserting here until then.
+	/*
+	 * This function does not support 64 bit accesses. Just asserting here
+	 * until we implement readq/writeq.
 	 */
 	GUEST_ASSERT(reg_bits == 32);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index f5cd0c536d85..7c876ccf9294 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -152,7 +152,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
-	/* All calls will succeed, even with invalid intid's, as long as the
+	/*
+	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
 	 * intid will just make the read/writes point to above the intended
 	 * register space (i.e., ICPENDR after ISPENDR).
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
