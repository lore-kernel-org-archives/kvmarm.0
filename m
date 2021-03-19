Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEA8C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3CF464F1F
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3CF464F1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D8DF4B5C4;
	Fri, 19 Mar 2021 06:02:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EgrGmNG+ZhkO; Fri, 19 Mar 2021 06:02:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B72A94B686;
	Fri, 19 Mar 2021 06:02:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AD984B4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6EA+JSNYhdNo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:41 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71D7B4B705
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:41 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id t14so4199381wrx.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MQQAWJNa/5+Ws/h1+nY46N9BdXPhpiMcbi0Tji1hFEY=;
 b=D4UmlRHS0y4x+R9rKJqUcRUzfcgDZJEm3qtCzw6xhI0q7wC9Z7ZlLB/qrYqG4YjQbj
 LLjGnLuPstfxeC5mRqOGKbiOWj6KSx8M5AIAW4uZNi+KmEBgwUJxk653Rrlyazc/ZVee
 THBUJw7yM949Cz+/CTmypmYNwcJyh2H3r0ybsBVkS8JDAb2SeKfUpmXnpwXiYahix9Vp
 FdC7sa4/Hj5scSqO6gQpP6uEQmlYad8Z8v/C3BC2ya6MgXmN64ZZy48jeQ9uR/6qEnAH
 gQ508Zw9N04VeMwuwyWc1shMDrLmKNe35wUDeQ9AFfFQK/SYBDaXjX2U7OsnlI6lU3VD
 TQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MQQAWJNa/5+Ws/h1+nY46N9BdXPhpiMcbi0Tji1hFEY=;
 b=Z7gyZZrll/kmfliUsQyM37PMYqGiARO5bL5H33MsLeOHubLkgoxZ9RUBhL/JKJCUy7
 +2SxHTw2v7bUlgkZ6V4KWged+4cs7AhY/O1eBvP9piV92RCzORj9Ieu1Brv/QyVwGE4B
 47GKQ8wY/1P9uWDi9l6M+4Hfs6u3GtD53ysohyIphH19t1A0Ov5X9yTaNCY+nNAWbxjk
 SWjoBeV9MAopCaTa1Bzca3EaYh/hvQxnHdcQPIRVL4CCDhvxRrgyR6/Zez0SV4LJ7Myg
 Ea/dDuVkIuE4DYvvHFPpXEQJBi1/4PUp8s9jQaqA1wkxqmXy6cY2hW89/bpJFtJFjAnf
 fLKg==
X-Gm-Message-State: AOAM533LsZREsMBTx7LEAVKax+aJNQI+TR9UQLX2LHh4C/3ZPZs3sbmb
 tBKofg5NN17HNqDAU1h3pK+o0yT+ik54
X-Google-Smtp-Source: ABdhPJxs8VE2EFnokM//O4a9DsMPKRIdgL2WWK/gF84Ol6Mqq3fJTR7ia0eRJFFqL9NbHweQLLfrGvevkHwP
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:400b:: with SMTP id
 n11mr2883266wma.167.1616148160645; Fri, 19 Mar 2021 03:02:40 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:32 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-25-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 24/38] KVM: arm64: Refactor __populate_fault_info()
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

Refactor __populate_fault_info() to introduce __get_fault_info() which
will be used once the host is wrapped in a stage 2.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 28 +++++++++++++++----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1073f176e92c..cdf42e347d3f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -160,18 +160,10 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
-static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
+static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
 {
-	u8 ec;
-	u64 esr;
 	u64 hpfar, far;
 
-	esr = vcpu->arch.fault.esr_el2;
-	ec = ESR_ELx_EC(esr);
-
-	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
-		return true;
-
 	far = read_sysreg_el2(SYS_FAR);
 
 	/*
@@ -194,11 +186,25 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 		hpfar = read_sysreg(hpfar_el2);
 	}
 
-	vcpu->arch.fault.far_el2 = far;
-	vcpu->arch.fault.hpfar_el2 = hpfar;
+	fault->far_el2 = far;
+	fault->hpfar_el2 = hpfar;
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
 static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
 {
 	struct thread_struct *thread;
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
