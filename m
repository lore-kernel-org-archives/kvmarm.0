Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E00EC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DED6365037
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DED6365037
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 946604B5CC;
	Mon, 15 Mar 2021 10:36:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LQ+wxwv7zIPS; Mon, 15 Mar 2021 10:36:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 906474B5D2;
	Mon, 15 Mar 2021 10:36:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3511F4B223
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7pTzo8pn6jU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:30 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 56DA74B5B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:30 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id u5so24574184qkj.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4Rx7gWcwKaPhXLY5lvXa6du15Qxy17H39RlntOQF/eE=;
 b=JtSiHC2TC4X/MGPjI48Y4GobrRWomFGcriDZR5/63bf/t4F9faT8FZfr//6DW2bCqE
 vFrQ3UF8RHabwi5h1YoRFY7n7t3sRGh5jsoMOeRAZOTld0V4I9tXFZLeV1n0EmHbt8Kb
 RJaPzGu5/a3hf3sPxQSFikbVhfHl+o+9mr4BIvN0aficfCWF3qeZU7/UQ9aeFDZktDAq
 uZIWaIDSFqM8dyvJAQnJIDGmp1gIm1sZkCyULLN1PQl7hmCNtGUWwFnz2nmJG25iGfTE
 WPCsobnVYUH3ALp6t8+NG+2cPnRt01bGC8tR03xb8jzGrpRIPpD70ypkrxqa11f85FB1
 55JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4Rx7gWcwKaPhXLY5lvXa6du15Qxy17H39RlntOQF/eE=;
 b=WHfZ+NAH83PlbYwVHU5ET+CwQd+TnTyFKaVion3UA/9Zw6vmmXrUtDpCD9m6a+G1zm
 N4Tnah9zovU6NlNDtrpMQW7DiJTuH5BTVmjRvfD3LyvcJSvOTYYfvYZdB0HDTaq9eKLo
 m6mo6wiZOJJw3/5gxueTParrj9KZZUb3JK8dUO39Jhwbb+HlI0Bs+NIMRckvSJdu9W7/
 gEXJAdvCCDOQFBMK6Zq1/dEf9trW0eXtb1n2Byt+9Cciweq5NoQrZbwPok/nFSW4xmb9
 tZvkgsCpwToTokWd3HUrPWJ7i8UJgFYxFXcGrZ00KU6wM9X+8sQf1vD7WnwrX6NKhptT
 9cXA==
X-Gm-Message-State: AOAM531jgDqT6HWU7DJHT2tM+hIiYE5HQJ0ftzbTyrNk9kWDLY14XtNx
 OGATWgGkiNt23YIWNNEhuRN+TWsgtSDN
X-Google-Smtp-Source: ABdhPJwDuWrOGL4ZNg/gQX5rsFfklI3IYwIn1ywA0KCJ73UhqJaMFBFoK5+FmaaLDaHwrFinuC9riTG6A1yy
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:262a:: with SMTP id
 gv10mr11184211qvb.50.1615818989939; Mon, 15 Mar 2021 07:36:29 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:24 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-25-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 24/36] KVM: arm64: Refactor __populate_fault_info()
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
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
