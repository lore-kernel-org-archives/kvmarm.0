Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4613C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jan 2022 17:39:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7133A49EAC;
	Thu, 20 Jan 2022 12:39:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 96uU2-ON088A; Thu, 20 Jan 2022 12:39:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2249849E57;
	Thu, 20 Jan 2022 12:39:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73DEF49E46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 12:39:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LljR3+ksYxg2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Jan 2022 12:39:13 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4381E49EAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 12:39:13 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 q3-20020a638c43000000b0034c9c0fb2d2so4033305pgn.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 09:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CTLiJ+83lYrDlIHsDATdvmKA2ZyAMqENkPuhv/61vCM=;
 b=e6mOfDZvTSolwbDSuNOJVSL+TxIsiCr+Gp2jFNaM8e8yk1g1GCGEv7o4hvFyEz49UP
 Jn8Bfz+oe9O6ba1+4JT+l786ax9I6MIGgQe3bqdMg0WCF8L3aZ6qVTSQYw0rNLOS+aY4
 O0nrHAwuCh6zKGOO6t6322kpF7Y3IhDNA51uDF6iCbxlwSp/tT1VRHAmUDFOJrN9Lsx8
 McF/zbTOJqCSPdIGZEFp8CF9gkuFAknybIn7/v8hxbHqb2uunxffVPTW+fJVpxfGzz8G
 KBOvGS/z8I1vTSaD59GHp5W9GoeSUhfG8vvdPfDO3ITmunu3qjfGQ5voPlj+sUbNlj7G
 xNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CTLiJ+83lYrDlIHsDATdvmKA2ZyAMqENkPuhv/61vCM=;
 b=VSASLPOgbt4ffbjaMpQfbPTaj5kIdSAv8TTPgRb/c7MtRswDS+Nxf38IpLomQykF9Z
 gbtEpVEgCkdfMKlWPL3Dk8n2+FAgs/fVqiu8oo4t6foBtYFnFPKszTxXJMVe5/q+EWYl
 6ZJ0PmQCvXXg9HpzKN+SAvDJUpnbom2G6Krr4eoSlDOj0quqk+BjgUtF8wm48YsRQ+4U
 0o5MR9b0vjxQO3JXzQ1wnvuNLNunqDCjmXhcdxuRwaO3WfCY0Oj9NQJOmGhh/cBMyfPC
 uBfLW6fHcMqhxOIzslnl6uPJRWU3+smNN6MXPmVH9xbdXNBziO8kbaqhziQSd8Gr/AfX
 bGhQ==
X-Gm-Message-State: AOAM533Fxv5DdukhIrsiaRfSQ3DswRuzIihe8FWUVIW45jVHP0PIuzsQ
 PtrI4iN0/QiqTGVvaEuXTlL8evnC74zNPA==
X-Google-Smtp-Source: ABdhPJwjGcqXz/hYyuZbzxhUVMqRBrunnyekQcvGwkFdAnKhWY+rEeikvVJe5wKvJxCWz2VfZFrZMAAri7QrcQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:3546:: with SMTP id
 lt6mr6968371pjb.68.1642700352448; Thu, 20 Jan 2022 09:39:12 -0800 (PST)
Date: Thu, 20 Jan 2022 09:39:05 -0800
In-Reply-To: <20220120173905.1047015-1-ricarkol@google.com>
Message-Id: <20220120173905.1047015-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220120173905.1047015-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 2/2] kvm: selftests: aarch64: fix some vgic related comments
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

Fix the formatting of some comments and the wording of one of them (in
gicv3_access_reg).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 11 +++++++----
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index e6c7d7f8fbd1..258bb5150a07 100644
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
@@ -503,7 +505,8 @@ static void guest_code(struct test_args args)
 		test_injection_failure(&args, f);
 	}
 
-	/* Restore the active state of IRQs. This would happen when live
+	/*
+	 * Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
 	for_each_supported_activate_fn(&args, set_active_fns, f)
@@ -837,7 +840,8 @@ int main(int argc, char **argv)
 		}
 	}
 
-	/* If the user just specified nr_irqs and/or gic_version, then run all
+	/*
+	 * If the user just specified nr_irqs and/or gic_version, then run all
 	 * combinations.
 	 */
 	if (default_args) {
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index e4945fe66620..93fc35b88410 100644
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
@@ -160,8 +161,10 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
 	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
-	/* Some registers like IROUTER are 64 bit long. Those are currently not
-	 * supported by readl nor writel, so just asserting here until then.
+	/*
+	 * This function does not support 64 bit accesses as those are
+	 * currently not supported by readl nor writel, so just asserting here
+	 * until then.
 	 */
 	GUEST_ASSERT(reg_bits == 32);
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index b3a0fca0d780..79864b941617 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 		attr += SZ_64K;
 	}
 
-	/* All calls will succeed, even with invalid intid's, as long as the
+	/*
+	 * All calls will succeed, even with invalid intid's, as long as the
 	 * addr part of the attr is within 32 bits (checked above). An invalid
 	 * intid will just make the read/writes point to above the intended
 	 * register space (i.e., ICPENDR after ISPENDR).
-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
