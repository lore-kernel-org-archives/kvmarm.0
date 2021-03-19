Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BAEC43381
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F128F64DFB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F128F64DFB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AD794B705;
	Fri, 19 Mar 2021 06:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6dpFcNxW3GYM; Fri, 19 Mar 2021 06:02:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 994CE4B725;
	Fri, 19 Mar 2021 06:02:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D6C4B720
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5q1nzKA6wXl9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:39 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4643E4B71B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:39 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id k132so2619437wma.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GjgSG2oEX6Y5d63Q6T6vut7ZZTlqBxwi5efWbFs4G3E=;
 b=S5kKNL4tlI5dNGFANy/IKuIGybGzvQQU9/MM5a8BNQt6JXQzXKcanAZTG3b2U3Rg11
 p89/euA5ijDgm2QKH2zxFh7PKxAHgxRnzgvM0zHisClI7T7zyH2csKtmuiQZyMRbc95b
 tuYIhtSD2h8O1ocaqETwzOAnL5q7kEu/AQEXJSqUM3lmEbfL7/0ijhdQ+oU0KZ0pd1yc
 PiCVbcBPJqDwYpWqoHfzO3xahL1JQJNOnGBYhSAz+1yAfnfWHqoCPXn/jPBNEtMJ8EdA
 hmgHBrACLG/WZr4NArEaKqPZOs4d6LQAx3ETUgzruixnZL4gv7Irte5mIQ0Z0iMi0vra
 TzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GjgSG2oEX6Y5d63Q6T6vut7ZZTlqBxwi5efWbFs4G3E=;
 b=tgQbmvoYkTozR6JkQMskoJHRG6lxExn2wJGqQgU/pX81WBieE2C3WrKtJNHfjuXB1M
 BAGpvUAZnVam/9fuBgcetsVMFV34XpnJtQDumk6h/ddNkTbKWEbou0mgU5eFz/F8aZY8
 BASZxhGYDydwElCwsHJVxW7Pvz7bvGxsPPA40PcjMPeT7XafBA+WtJyiYRpsqy2ac2LH
 J75sq/Ctmd01O1kFZ7YYWMuS0zJK9HIrVmyv3RMZUgM14EXZR3UGhIxZOa+CxpSeWHwL
 C1m+Lll9iF1QHcU1PoCia4oBdfH2N909O6PxGBl769DcGR5iJc3kEhYdw40J3ay2D2fw
 MD3A==
X-Gm-Message-State: AOAM533+KvzbMcjdz8XYkrvl9WFhwIcTIIBLQDbRHnNAHl0ZDaZp0oEk
 UVJwGqwysGDzMW8o0s0UE3IyZ7Kxv6aF
X-Google-Smtp-Source: ABdhPJzVhIo8TziXOi/TrL7kQ6HeUWS2jzLLmQi9MnH0SGd7F0xBNRMVC4+tK89lWUsE4gqU/I6SxYi8CiF4
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:e388:: with SMTP id
 a130mr3009460wmh.187.1616148158391; Fri, 19 Mar 2021 03:02:38 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:31 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-24-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 23/38] KVM: arm64: Refactor __load_guest_stage2()
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

Refactor __load_guest_stage2() to introduce __load_stage2() which will
be re-used when loading the host stage 2.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6f743e20cb06..9d64fa73ee67 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -270,9 +270,9 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
  * Must be called from hyp code running at EL2 with an updated VTTBR
  * and interrupts disabled.
  */
-static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
+static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu, unsigned long vtcr)
 {
-	write_sysreg(kern_hyp_va(mmu->arch)->vtcr, vtcr_el2);
+	write_sysreg(vtcr, vtcr_el2);
 	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
 
 	/*
@@ -283,6 +283,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
+static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
+{
+	__load_stage2(mmu, kern_hyp_va(mmu->arch)->vtcr);
+}
+
 static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
