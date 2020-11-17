Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C94C63697
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 68D832468F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="GrNemWJ5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68D832468F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10BF04B8CA;
	Tue, 17 Nov 2020 13:17:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AcZjKN3NYPlk; Tue, 17 Nov 2020 13:17:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFAB4B8A1;
	Tue, 17 Nov 2020 13:17:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A7BB4B8EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8G9EXapO6MKg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:17:13 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 984AC4B8E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:13 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id k128so2127614wme.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=e9MvRELompdcQ9+x82O89Ri9iXp7qNvrmx/wGARfLl4=;
 b=GrNemWJ571s3IP05lzCIf+o9mQWG20WSzj1XWIbqs4BH51p4FibpD+1iIudjxdsldY
 VTOoE+KKuVVeeDxGnJBQ6qpGvS4olzVpA4h2kHUJdYePK03MTWF1sVNn29wYr8jCqsP1
 zfnuBAtCdwfY4dVJuW13O2zHGn/wvP8TJd+7Gv88DeaAnl6Vr0lt8jupKQCVqBMY6LJu
 UuVkqgukfwDXxkwuFocX4twgxviyx3guAteMin0WGg+8TngA8wcruUWGUCFFyFlGLDAH
 GgrgZwJ5cpl+PeisJnHcFbNvplQ+JU+cK6fr/J2jY7HohI0LpW8XQQFBmZ0pMJ5mGWt9
 sFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=e9MvRELompdcQ9+x82O89Ri9iXp7qNvrmx/wGARfLl4=;
 b=GfZgfAiW03mNKNDTrT3Do/kYrLNuU5gtUHPIq0V3UazmkRkWzCf/8DfISiM/huMCPu
 vB2d1sMbZ7A4EKgBiFLESrbHLli6WFwas1X2AlYnn9mzHlg6OXkA+s3V3L57TDCTWnXA
 jgTXSu++E6YjEAXhPHo54/zHv0JV/sPL+X3XxiFRmqV0dcfdxRtCEit6toyTgVUHJ77T
 TDIfruJ6Ew90cbQNdfVlM3P6k34F1EdFw3ksjZu3mZ0wdgoSth8RnUxL5WyG6X4Q7y8i
 zDpqiJENAaBCISsMRSs7+LOhykOnLopiTK6b5fLchLpYeJr2N5InYbuDMU+yr1wyWzpE
 bGhw==
X-Gm-Message-State: AOAM5317A8j6OD6fp3Ww0dZeiXkFa9oHs+0hEbmvIYEmMpSRLBT2B0XB
 PknEbfHfMCjm+zsKHaGTehwPleFtqrqp
X-Google-Smtp-Source: ABdhPJz7BNpBZ+O3LELUcm62RbTCKz5SEYVRtuO5fjYtpJDAqHE3syxKSKHYJAgBXthIughVPk93YxkQXa72
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a1c:6405:: with SMTP id
 y5mr376392wmb.150.1605637032528; Tue, 17 Nov 2020 10:17:12 -0800 (PST)
Date: Tue, 17 Nov 2020 18:16:03 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-24-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 23/27] KVM: arm64: Refactor __populate_fault_info()
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

Refactor __populate_fault_info() to introduce __get_fault_info() which
will be used once the host is wrapped in a stage 2.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 36 +++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 84473574c2e7..e9005255d639 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -157,19 +157,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
-static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
+static inline bool __get_fault_info(u64 esr, u64 *far, u64 *hpfar)
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
+	*far = read_sysreg_el2(SYS_FAR);
 
 	/*
 	 * The HPFAR can be invalid if the stage 2 fault did not
@@ -185,12 +175,30 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 	if (!(esr & ESR_ELx_S1PTW) &&
 	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
 	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
-		if (!__translate_far_to_hpfar(far, &hpfar))
+		if (!__translate_far_to_hpfar(*far, hpfar))
 			return false;
 	} else {
-		hpfar = read_sysreg(hpfar_el2);
+		*hpfar = read_sysreg(hpfar_el2);
 	}
 
+	return true;
+}
+
+static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
+{
+	u8 ec;
+	u64 esr;
+	u64 hpfar, far;
+
+	esr = vcpu->arch.fault.esr_el2;
+	ec = ESR_ELx_EC(esr);
+
+	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
+		return true;
+
+	if (!__get_fault_info(esr, &far, &hpfar))
+		return false;
+
 	vcpu->arch.fault.far_el2 = far;
 	vcpu->arch.fault.hpfar_el2 = hpfar;
 	return true;
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
