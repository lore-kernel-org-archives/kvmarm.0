Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A795C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDBEC65025
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDBEC65025
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9174B4B6EC;
	Mon, 15 Mar 2021 10:36:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OqfKZWK72wOW; Mon, 15 Mar 2021 10:36:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B8F4B203;
	Mon, 15 Mar 2021 10:36:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 722B94B57B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iLf5f10v2iNB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:29 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E240E4B6ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:28 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id y5so15187143wrp.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GjgSG2oEX6Y5d63Q6T6vut7ZZTlqBxwi5efWbFs4G3E=;
 b=Aa8fUv21ijIEQhNQRFlfwR/ZR0ql0KDFcjJ2wWkBRKMMqZHPVWvEVhkPGuKSA25VmE
 IB3ju2RX15BiJq/PiF0wmfJ37jVOYGLAr2w7w7MrpAOVvSBID3xTJO2yLASU+Xutfl65
 yWDDZ/PPzZua3NRiptTTgpjqlmJgF8nVbFUFCm6QIWv9aUUjNyjFUQQYKv5FeFufo1fv
 EwZiUFJ60WQQfevwMGcHLKIDQzqK77UgnIbGPwyVsX65v3xp006rtl2UcTE67DymvaWJ
 J2xmcWsgDLnKDpC5CLUerUWv9iB4quj0WrhNx4vMoV1rWtAHo60X1w2vzNYZUB2FMgHk
 d2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GjgSG2oEX6Y5d63Q6T6vut7ZZTlqBxwi5efWbFs4G3E=;
 b=abVzUVaW+dsS0YBOhrT4mHddhuId5ltyyaD2xE5FjMbq26w7QX96cAKRmbuQDILRWg
 YvtJAl2nFnqCA0Tpi9656HBd0pA50+KjooFix+3w5R1wRoABkQe5nhFzpDPjYuGYk3T6
 kGSBTxsv/16nNTLrV8vWM6MMEeRRvIyJfDvq3V56sz4gNfwtIw1F52dr2uVTupCmDVxl
 ztYAPGJVXm0MJO52hHdt8HJboioVEUrfBT/kdO9cZSloH12u3v38VtII7BR3J2J56Nwr
 EksPiPFT1JoRqWWMVwHaY9VlxdSSUjxJKJh8AAJqyUOtFnfU/J6rfiwwFq7YOn32JMFk
 +owg==
X-Gm-Message-State: AOAM532lB1ssDsuboAE/BHc9m7TI8S8WBRmy3dpVLFXrAcyMKM9SLqkZ
 swzBiu4YIkoGhNdYaWaEFMk0do6pn33X
X-Google-Smtp-Source: ABdhPJxRVdeyBsJa/HlT/zZefSVJKkc7JEEzUjQpsvXHTeJJD8923jx01t3RtCKophvOBQkDzIaQSSKtF6NW
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:6243:: with SMTP id
 w64mr1121799wmb.0.1615818987813; Mon, 15 Mar 2021 07:36:27 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:23 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-24-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 23/36] KVM: arm64: Refactor __load_guest_stage2()
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
