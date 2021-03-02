Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9178CC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BC9264F3A
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BC9264F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA6E34B647;
	Tue,  2 Mar 2021 10:00:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C4P92j2lKPzd; Tue,  2 Mar 2021 10:00:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 710B24B65A;
	Tue,  2 Mar 2021 10:00:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF4AE4B279
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hCGImzROXwsI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:39 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA2944B645
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:38 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id u15so11106862wrn.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=84bkslXA7Qi7zlX0xHNbjR4XGFTrfSQqHB0l+SkjRTk=;
 b=aEyIjsz9Q39OmQlGKhPsdWMeCxwA+8gfzAIcUr3vtuH7vJkQ/TC8zCkBwOeeBT65tq
 UvSouJ8Birgm8kdd91FSgiyZCYROychF8+9Sg1dSYXCER9zOEopyAV4P/kgm4Ysxeidy
 7ft7SR+/KlrHCJgsZMEZ51u1Cmk9vBYllJNwbmgZ1ompvmxQEqTIg6O0Ypw4YW+TiLNY
 Bdfy60xclmeqbqcp8GDWtDDVvsqYWew2CdzBsipN3fqfz7oI3broHa+hdFZwgg01rnPc
 IAtkChQhjHl8hf9R0x8GkU6smUb+gwabjgaL22vSTdg2PoB4sWRTIVOgQBrjdOfDE6Mh
 olZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=84bkslXA7Qi7zlX0xHNbjR4XGFTrfSQqHB0l+SkjRTk=;
 b=eA2c0NjJ+LIRHcvTD4VRDTthUUpbi7+eddCCZMxosa+m46ksNMPQsrwp4X8gWXxqiD
 XO26R6fLm+3GkoA5L4YvezcaJhusipBHy7pDzOXuIvqGE00MqP/nAy1xEtUXXwbLdXSP
 3l4RvzMviyImqakHtEZl9F4BQa61lNDcsYFcB6fbmBYyVFFFkzYOX+PKuDyWlvd1dsmW
 SH4fhBJUEraQih4j636tdrBflCfhetq5C4sgkW4KYsgQzvqVGRyT3oPXvtL8hWB4Uost
 eRUWHpGsiHzDBqTQHcXo57ph7gN/xZHoyq43V9LCvpoPWlxdEcbNNGuVuIHOoYMtQdIJ
 D+iA==
X-Gm-Message-State: AOAM530B3Dy/n7WSCrOCIO42JhD5N+2ebHERaUbchCUjfZGnTLX2tSGd
 W4uArF4Zw6wdymyENFbz8OpDWgyCDnt9
X-Google-Smtp-Source: ABdhPJwFUzBVYVUNUz65kgYHvUCXtvq4NXrt8gCrlNsOFSMTng7gs+AjbNDT7VknGe5P7PaLfd9Y7549RF9U
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:2e90:: with SMTP id
 u138mr496527wmu.0.1614697237854; Tue, 02 Mar 2021 07:00:37 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:44 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-15-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 14/32] KVM: arm64: Factor out vector address calculation
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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
index 3f8bcf8db036..26e573cdede3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1345,16 +1345,9 @@ static unsigned long nvhe_percpu_order(void)
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
