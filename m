Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CD8C63777
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E2AF2222C
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ZN7TMzWc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E2AF2222C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 454F14B853;
	Tue, 17 Nov 2020 13:16:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7W1Fa-FTR19F; Tue, 17 Nov 2020 13:16:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D33F4B8B0;
	Tue, 17 Nov 2020 13:16:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDB764B89F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1I2eDxm7Zhng for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:52 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B95BC4B5F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:52 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id 3so2127168wms.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=F6/Ku+z/rldXTKyTjaRYVBv4lFiTA1v23xAOFYW1znk=;
 b=ZN7TMzWcg2kpOSqffDoVhtCt8uuThETRtG/2q52T5qCUyS9wVVeqC8DLp9GHUxjPzl
 aRJom2yDGA29gjrTZrqqST+sCuyxUep0AcG3zyv30IblaP/4C9KEnPFKrtG+ZDCaIltz
 G1DBpjrBArDifkZHj2qKeMp5ucykr8vNPn9d5SaiPvot0qDGmYdqV7hchxuHrIYBK3Yt
 zQezM/vBty6xeYGG3xPKCMDP12KKhXP5Pcw3ErAA+STpsQVaYQ62FE6TFa2w6PAZc4YJ
 a7cIVY5OSaYEJLpdXMS0djxudcoIzYtYFsaSPvip1YOmJbhIujEddKb27SQvDMsnNhfF
 PBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=F6/Ku+z/rldXTKyTjaRYVBv4lFiTA1v23xAOFYW1znk=;
 b=cS14KrZMQ/xqgd1HC+L0Sr2JkTud3Mr+90xxPLJGwc+YTyOXJBDbaahDtCmtZvOTH0
 NTKwxgIdBiJo79RUYOl0ufjJ+Srhd1kEcLD7Je59flvSDrd2TZeKZupHNF2BeR0mMJF7
 T3CGBQKMOj5wcBOz4TOimzoebx6fS238fh3iNHVFdq6uBtZLnQYzdmnoJb3ous7g9AQS
 uvaAx7rFglWZQk8earzjDck+BdMccXSJ5tI+VYYtYo9biIrZ9gzxgRnwloIloHXwVpRj
 GbYV9nfAhjJObva/eTxcyRmcSkoPOKwUZkocAwgRm1xBhomF1q0l7UTp5luRO8zS/kT4
 9/pg==
X-Gm-Message-State: AOAM532zwD1LQQmUIAH0e3jf1GpboEBVsZMa+sZY5s0ptvXEHDpDZOYo
 js9w6t0PWhSKOJ/7fUkn4sto7zP5Io91
X-Google-Smtp-Source: ABdhPJxPq5M30rdGbubfNCRpT9hqgInad/1CQDFyjy/L+083VvfB25t4bfYqH1wKxMY1b6mlTwrfv3eLZu9/
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:adf:82f5:: with SMTP id
 108mr804663wrc.269.1605637011993; Tue, 17 Nov 2020 10:16:51 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:54 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-15-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 14/27] KVM: arm64: Factor out vector address calculation
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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
index 5168a0c516ae..cb104443d8e4 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -171,6 +171,14 @@ phys_addr_t kvm_mmu_get_httbr(void);
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
index c7f8fca97202..b1e1747e4bbf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1318,16 +1318,9 @@ static unsigned long nvhe_percpu_order(void)
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
