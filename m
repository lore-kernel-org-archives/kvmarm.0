Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01E5C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E4C1239FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E4C1239FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4094B431;
	Fri,  8 Jan 2021 07:16:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RXGFK1VMYeQ6; Fri,  8 Jan 2021 07:15:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6484B42B;
	Fri,  8 Jan 2021 07:15:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BF904B3DE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zf86wfiS+g9l for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:57 -0500 (EST)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF59F4B2F3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:56 -0500 (EST)
Received: by mail-qk1-f202.google.com with SMTP id u17so9091481qku.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Qr6fo9oQ1pXE+2ggRpUPc27A93CFNZ1q8V/bSIAa7vQ=;
 b=Lgsjd8FEXR/txZoyV8WuF4f0d4YJhY9e1uIwY2ZKBxuqtEnQJg33daGu1ILE6X1yVm
 3bmI+xMaWKSUxl2SagC/g4n5Md9L7G3vxikeo+mdAU7BfccT5W+kxzU5S7UG3feLKbme
 ERxijuVD+57qQr/KtwpIs8VkMV1mg6FWqyYzHjswMh2hCX94sLdVeK/2UtrPFh000pBo
 Wat+4kpdcMUp41zMURoOa/5m18zhBYzly85HHjcR5ZjnghiaHqmXLElzNX1WkR3dAuv3
 zJfl09gvrPAlyBaybMTEqu+Yz+UH5M+Wv3AdrSOkrKLW83DqbiuFH6Ipyx6juV7+q36G
 PnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Qr6fo9oQ1pXE+2ggRpUPc27A93CFNZ1q8V/bSIAa7vQ=;
 b=Rr5GsA2YcodbU9Hd8qjcYDETDU5UHbdI6KQJmCQX47pqtAQns+ID0AULoZA/48Cwer
 QF5s8KTs5kvqklD2fksWdQ/2hhJxlJj1A/EICZ2iChUEGrMH9FQP27uZrMiy0qLdwfXq
 0T0Vn/KpcLnS5MGIYfqo1qkzSrqonY6w2VsmxPpQwhoPvNCa6yptwGYco7uRTY1UupxT
 8Swk5R6BEP+WIiKX36XOVLjme0mr0gTFfGw0OHuiDMGnzbUjKo5cDMl6R3FdFUx2oVRX
 B8+Ri8e5d6ZBCfmcFi5XAQS3GdyyXk+AaVmwBe4pSCcA0JGt9AJZTDSivkrmLkT+MfRe
 R2Ew==
X-Gm-Message-State: AOAM533QQyuGoJHbF3oextuDJJN7NUw5kMSTc/nCt7A+TR5x4pY1zErD
 l3uotOVOhbX5Y+odQQ26zVNSdRTItHbP
X-Google-Smtp-Source: ABdhPJzRr7svgpB722+nCLZgCDSVanauE2weLVt/XbLAdLhD6Eu5KBqqXCwGoYrf6841yPmBUrW5blfOV65g
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:edab:: with SMTP id
 h11mr3057028qvr.23.1610108156221; Fri, 08 Jan 2021 04:15:56 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:12 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-15-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 14/26] KVM: arm64: Factor out vector address calculation
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 8 ++++++++
 arch/arm64/kvm/arm.c             | 9 +--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e52d82aeadca..d7ebd73ec86f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -195,6 +195,14 @@ phys_addr_t kvm_mmu_get_httbr(void);
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
index 9fd769349e9e..6af9204bcd5b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1346,16 +1346,9 @@ static unsigned long nvhe_percpu_order(void)
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
