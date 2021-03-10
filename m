Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC236C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6629B64FB5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6629B64FB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6344B635;
	Wed, 10 Mar 2021 12:58:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yb-KwdJEcDCU; Wed, 10 Mar 2021 12:58:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D2774B5F7;
	Wed, 10 Mar 2021 12:58:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A52E4B531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qYI1QcltLTlN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:48 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79BAC4B60D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:46 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id n1so13259913qvi.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mOohSeaIfwaEz8hEwSDUNnz+PysLBU9WmW/RUHzGWms=;
 b=UpCuP2JVMuI2+hVj+HMC9GepoPsIZM85HpFVq86MfaLWQfpLNX0CKray2/cYIx3hap
 FulboVVX/ZHpVWShTcu4rkz5liv323G1IaAkq/Q7XxYW+eVy3QOYbeogjkUE553M3PKX
 biChA2Ckr+PQ2tq4vQH2hsa+yxoCKi4mutHQoucMaEC1c1zTEb4ltW/vBP3L7OdS8mx1
 Z+aDeD8BxzSyaR4xMCs8dlEBcK/zLbGW9ng687rwEBkWedmJU5x5I8x5pTDkDJfsOGr3
 gh9NFs7XMGoW4QhnPBTufa45Fj4aVoY9kvDtdX6Mm9AoCMnRhBRJtiXHkfmQanMbjAOo
 Fiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mOohSeaIfwaEz8hEwSDUNnz+PysLBU9WmW/RUHzGWms=;
 b=lVsnFJVIxF03h8RHKSg1XvZvWX+bFgEj4ymTDP6NxdJQQfMHjYT3usWVMLqKofLvD8
 seLVSZVY8cJRUUjcOOGDG90z6W94V1Pz4Zt6KY15WB/I0Hgik/83ZY2P7OQlzwfsU8d6
 QCHkgyCICApCS3a+e7nKflUV3JgJ1kxmhLBr0Q0qCeEIBFR6mIKDiF146gBa4KfjpFZx
 l/d6QAE4mhCLIdrJbw6zG+WXp0QJa5EZfpi2m/Gc1tf2GT6HefiC/a/ut5eAdzjo2oXP
 o9ABM2D1yO9Irk5/YARy6Y7PEMapGRhLxGSzA8MBGYodJhB0fPpQNdWRsSPjxM6dMmLy
 12Fg==
X-Gm-Message-State: AOAM532DVmN2vmbfzj4bVcGttXIxOGJC/58UihwXQmMjLUeuCa7qP8Q2
 yycu3GCY3qo0yznDH4a/myLMR5LZyIHA
X-Google-Smtp-Source: ABdhPJwx7QrSBh2ptN4PQ7VNEdb7G5Onq4cJuMCN82nqpZk0yWXTQDUEtyuol5HOBBtLBr8L8iuseENS5Fk+
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:b894:: with SMTP id
 y20mr4097294qvf.43.1615399125954; Wed, 10 Mar 2021 09:58:45 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:40 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-24-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 23/34] KVM: arm64: Refactor __populate_fault_info()
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

Refactor __populate_fault_info() to introduce __get_fault_info() which
will be used once the host is wrapped in a stage 2.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 34 +++++++++++++------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6c1f51f25eb3..40c274da5a7c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -160,19 +160,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
-static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
+static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
 {
-	u8 ec;
-	u64 esr;
-	u64 hpfar, far;
-
-	esr = vcpu->arch.fault.esr_el2;
-	ec = ESR_ELx_EC(esr);
-
-	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
-		return true;
-
-	far = read_sysreg_el2(SYS_FAR);
+	fault->far_el2 = read_sysreg_el2(SYS_FAR);
 
 	/*
 	 * The HPFAR can be invalid if the stage 2 fault did not
@@ -188,17 +178,29 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 	if (!(esr & ESR_ELx_S1PTW) &&
 	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
 	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
-		if (!__translate_far_to_hpfar(far, &hpfar))
+		if (!__translate_far_to_hpfar(fault->far_el2, &fault->hpfar_el2))
 			return false;
 	} else {
-		hpfar = read_sysreg(hpfar_el2);
+		fault->hpfar_el2 = read_sysreg(hpfar_el2);
 	}
 
-	vcpu->arch.fault.far_el2 = far;
-	vcpu->arch.fault.hpfar_el2 = hpfar;
 	return true;
 }
 
+static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
+{
+	u8 ec;
+	u64 esr;
+
+	esr = vcpu->arch.fault.esr_el2;
+	ec = ESR_ELx_EC(esr);
+
+	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
+		return true;
+
+	return __get_fault_info(esr, &vcpu->arch.fault);
+}
+
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
 static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
