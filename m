Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F78CC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:01:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E40C464F3C
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E40C464F3C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89BE84B654;
	Tue,  2 Mar 2021 10:00:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X7IeMS0s9iJi; Tue,  2 Mar 2021 10:00:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 819644B681;
	Tue,  2 Mar 2021 10:00:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD654B658
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SNTjUPZCmicO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:56 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 478E24B67E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:56 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id a41so13353959qtk.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=VoWvRhVqzXHkQ0OsvxSGeS/VJPiNA3/g3FAmYYygOdw=;
 b=AjUn7I37yjHmuqeaXLfgA7dtYSSQwwN/4mcAzk8HpWqk8XmE81BG8HC75qZhUGfls/
 M0UchiZU+6VwuNndrGxdk2BjIPU+8enIfuinKdzPQa6PWDKoVD3qVJDHHGjdE6lUFUFm
 xROrWqmqeI6LH01tc3+3KqZwIQDZDeWu20eRjLkzQT7gxd/alLd29IAr46KfDHDLfQcB
 r0h8AcNcvuZw2QoF5e09oSwkTD8PSMKtQa5NUUlkyhGhG24SVC+dv1fuFYkLXn2SaIp8
 jRsY6UXZUSmEu2kqopQE9vx8d5HAX6OtZIq9auAHd5qMkR6/zmg55RGtssFV8WLZh1QH
 eXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VoWvRhVqzXHkQ0OsvxSGeS/VJPiNA3/g3FAmYYygOdw=;
 b=d7tvyHCYU0N7D2roSxcpG3mHxM9VgHjwWxJBfRrrmWQNiN2tGTdqWVdBUcNt2m0L/5
 ICHCNwWbgz84y8UAiXCBVBHNPpOnWxEqfPNm6s+1/WKKRurNRv6JTpQaPHxAw/s3EZNv
 JDyDIo7y1Su6TuGAVh5Inc0UxXM8PAiAdr21uI7Uu3uaUa7A8hYjgheh+4s9ANb3mEWA
 DnVEb2AL4hJim97MfwXink8zUXZW0P34bQ9nXyuIYr6/gt7TDJD1na+Lsw3RyWc7i1NK
 R8MRE/bHqz3Tgp/A9KXNIJxVLR2KLSoT26JLAAnr9Z8VIZeH/U8Qz6c7P7jW1OV2aeyA
 SqSA==
X-Gm-Message-State: AOAM531FEUsPoVfWbFRrPHeMEUPMtLQ1kwdQ59jb9BDDKUo8wWMcGLPJ
 HKCLkCdG99HhnROb7Wy/va/QIzt735nq
X-Google-Smtp-Source: ABdhPJx8y0kZKpPj1sFhkhggFZKcZCCqwCconUOz/jXAArtDcupPU7deynqeh0MVM45/MhZGwK2ChR5h6DCc
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:5901:: with SMTP id
 ez1mr3999273qvb.38.1614697255713; Tue, 02 Mar 2021 07:00:55 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:52 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-23-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 22/32] KVM: arm64: Refactor __populate_fault_info()
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 ++++++++++++++-----------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6c1f51f25eb3..1f017c9851bb 100644
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
@@ -188,14 +178,29 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
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
+	return true;
+}
+
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
+	if (!__get_fault_info(esr, &vcpu->arch.fault))
+		return false;
+
 	return true;
 }
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
