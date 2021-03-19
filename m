Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76076C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FFA164F53
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FFA164F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF6514B682;
	Fri, 19 Mar 2021 06:02:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YHGtLn8I4GVC; Fri, 19 Mar 2021 06:02:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 981544B722;
	Fri, 19 Mar 2021 06:02:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96EE04B6E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KW7Fh5oGf0PY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:22 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95D734B6D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:22 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id n16so20512037wro.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lQIT7boSH7VaErqDHVKDpxnX/gbqPaNn5BvEtRgavP4=;
 b=R1/pDoZJyieTAINWUHqJoxtobG4lEwFQR3LiF39XqzeO2APFzvrm447dISZFMa5jN7
 ralzLICmmDoKTbqiXrdoIhH3YbSQfHVyHM7gyVJXnMeiXw4sVkkOvXLy5DiPTO4FJjlr
 jluGERC+t2g6RW11lAmE1IcXrWoIXzwtaUaebUn0887cdfteVkcof7S7fA8ddF5RjJP4
 4a5lvx2Sh1FoITa/6m/lBQxTdh/ixJnn1kcXkU0r0/VXeMbhuQ2xZNT8yXrBaZ+8F9QG
 4RlDO8lK+Rih1F9KEBbIiEspgKm/W414x3ejf9UHiT42ojTLirs1UKNSsx2FJ84umEh3
 YNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lQIT7boSH7VaErqDHVKDpxnX/gbqPaNn5BvEtRgavP4=;
 b=ntkSdWmASZXCSyGXcX4kN47d7Uu+NCSBpERwSuPLm90d8ywzAUFdUmBbuFmbrYZKrd
 djmVIaOaGqh+zPVel8Qyq6kkaj0t4VlQhcIa2Slnx76BpWIL6a9olffCSfRsiDCY9Khq
 ClBX85zP5ABf0uGM6fhO4ceEV12xMEJEb1q+QscGZ8zVQm/hSRhMhZ5sG6e4EP/12Q80
 ROB34XSg1tjwp1eD2GPGRIWCW7n6pUgNvWzpCRT8g3jui8MUBGltDqhTzKMnHxGyv+O6
 fy1C3cZiiSSl6JlLN6GlrW5ZdWK7kIyDCRJXVZns+HvzwUi6IRg6z7+Hew6Fi4BhfIXZ
 YGYA==
X-Gm-Message-State: AOAM530iuhhfDhErmSAB2y6rkz/9nRicLXRtwLFRTsjAArNFIdnAxaVg
 XDfc6g7svRFhGDR9jAGRDJbPmmRcm5Qx
X-Google-Smtp-Source: ABdhPJyQMa86XBPHTBxCw2e2CfDITisuclXMKQ6iyrl3usqkGpaB9PrWjBHq73sQDPJD4lcQRuD2rBE8WJiW
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:7210:: with SMTP id
 n16mr2895100wmc.13.1616148141857; Fri, 19 Mar 2021 03:02:21 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:23 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-16-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 15/38] KVM: arm64: Factor out vector address calculation
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

In order to re-map the guest vectors at EL2 when pKVM is enabled,
refactor __kvm_vector_slot2idx() and kvm_init_vector_slot() to move all
the address calculation logic in a static inline function.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 8 ++++++++
 arch/arm64/kvm/arm.c             | 9 +--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 90873851f677..5c42ec023cc7 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -168,6 +168,14 @@ phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 
+static inline void *__kvm_vector_slot2addr(void *base,
+					   enum arm64_hyp_spectre_vector slot)
+{
+	int idx = slot - (slot != HYP_VECTOR_DIRECT);
+
+	return base + (idx * SZ_2K);
+}
+
 struct kvm;
 
 #define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 22d6df525254..e2c471117bff 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1350,16 +1350,9 @@ static unsigned long nvhe_percpu_order(void)
 /* A lookup table holding the hypervisor VA for each vector slot */
 static void *hyp_spectre_vector_selector[BP_HARDEN_EL2_SLOTS];
 
-static int __kvm_vector_slot2idx(enum arm64_hyp_spectre_vector slot)
-{
-	return slot - (slot != HYP_VECTOR_DIRECT);
-}
-
 static void kvm_init_vector_slot(void *base, enum arm64_hyp_spectre_vector slot)
 {
-	int idx = __kvm_vector_slot2idx(slot);
-
-	hyp_spectre_vector_selector[slot] = base + (idx * SZ_2K);
+	hyp_spectre_vector_selector[slot] = __kvm_vector_slot2addr(base, slot);
 }
 
 static int kvm_init_vector_slots(void)
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
