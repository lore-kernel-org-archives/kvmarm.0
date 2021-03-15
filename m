Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308C8C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9D2364FA5
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9D2364FA5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA5F4B203;
	Mon, 15 Mar 2021 10:36:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M4AneAY0qX9n; Mon, 15 Mar 2021 10:36:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E75D4B665;
	Mon, 15 Mar 2021 10:36:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEA374B118
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id moFk+4vDj+at for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:13 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCD484B5DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:12 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id p12so12607466wrn.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3hA7tosEY4dPQwz7wIkxBpuvpX7Hy1acE9O5r7Hvk3A=;
 b=VPdm53sxCIyfLckE3eCIPGFnhmYvji9+FFRac0tP5RFkNTeQjU3PyWF73wMpp3qHuq
 MRq80VDnvyyJZtBXgaMd+6qwAuEqoVacMii3LnsVTDa6VXGxQd2FDcKgPXOQlfHbf2hr
 7jeLnfAWLaA5hmrMMDXGstV9vSBjjgFM2Iz2GsUR/MPprlCiITEsgWZZZvIbviMyi3ky
 4hUqbjDNdpbvNidGmiLsNlpyjlKOmgE7+fKcw7rBk8FUhXTO4oiZZPbiFgfRypFdEd6R
 Fe+FdmnVguWbs048n5yF43ce39d2OX9fdmx8TfQzKJJ5yZWFdUKFlB0NqvPvJOJOzcez
 BdaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3hA7tosEY4dPQwz7wIkxBpuvpX7Hy1acE9O5r7Hvk3A=;
 b=TQJWSLJawu0gtqYKF66yiybmbBuISDvbm/4UhIy5QtA9fJA2Ys86Th+yyMSc47qx9E
 WHOyfwADdTL/gFHDRgKL/pUBnr5XT50NQHMuwcojYmYGf7xNT/bgECe8sIQFLsLUO2e+
 zdZCuAfuzOgn9abgC4Va/O/wjh9Zjvzc6oPqCkflmHx6kyztCSm6spXB0kKa2mI8FesT
 Nvs3buF4+uIxXx0JKlPRZW6ROSVvxnBrQSGB3pX3lZ1X97ap6WSAosExr7TOCVwCA9yD
 MbsWblokSYC8N63FDtyh4uN6DjVgLTsYdMqQgz2yy5PMfu432cxBz1LwlOP6JF8z1qp+
 6r4w==
X-Gm-Message-State: AOAM530ivpUXjFYIr5ZPc3ampIEn7b6VXZjEaRK7yulxGG3YCQAo5mj+
 +GHUDsYQMuDy7CDCWvS43dS55azf+4Ie
X-Google-Smtp-Source: ABdhPJzYhRfdIlEKb6klF7NPABZ+u2gjQiVHViCdjX1yjgBMKmlXOcLm5BOWaFgW0byaeWgbp83VIVYMf99n
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c18e:: with SMTP id
 y14mr1121168wmi.1.1615818971570; Mon, 15 Mar 2021 07:36:11 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:15 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-16-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 15/36] KVM: arm64: Factor out vector address calculation
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
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
