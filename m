Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10D1C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7168D23998
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7168D23998
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F19E4B3ED;
	Fri,  8 Jan 2021 07:16:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id if5fwbJMFyoO; Fri,  8 Jan 2021 07:16:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C98A4B3F4;
	Fri,  8 Jan 2021 07:16:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDBAC4B370
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJvKKBGes4Vo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:16:16 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E18E24B25F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:16 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id z43so8162583qtb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=pSI0R0y0LyZ0MvEgT/8TLG9r/LMGz98d06c78ikqYMM=;
 b=ncicFESs3ffoWFoGIrRaXV+UDl8OOBsRzdKG5EpyzwDsT0yV7/eDINZFH8YAYdLFQh
 Y9TheqAFWLGOdu5Ma12BYM5IyqUHQAiuEm03eYEc1djPhUHUt+GW5V+HRmWrfKSK6PFG
 OnQkRt6iTH4FfGnyGLVzO+Hhvsauj/Z1MiAePgkHI9jvmc0XEJ5bFXuE23HXRU5lNRY8
 /bH/4yf2JeHIynsSwkiZuJFYhDGSVNoub55OTznCHT6ga1UcI3TVJsV9yzVZ4EFAl5RS
 dUVWi7djxRQN8R6/wJHxV2dByH4KaC4+SmMuujY+2acUKwtQOZnmnJyoO2sgaxMrN5ms
 k35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pSI0R0y0LyZ0MvEgT/8TLG9r/LMGz98d06c78ikqYMM=;
 b=YrQic8pT68u+10H1ZkO/WjxB6rMwWm3ywL0ZzMXVyYnNXk8I/dzBRyYVnLw6OimtTK
 Rk4t24Cz3ag+VIgXDZzEsrpVW8kb56B6e0NjkIT4R1PEnnQq2TW0sqvBhBWbCJH4GPgw
 hyPOz6690a5xyESAkTDCYQi7w/cFZe7EJSCXxRYh7qkUGBYMYPj3VTVvQK6QyEeP93H4
 vKEmGoVQxmtOxbD+ufbMV5xWC9S3VTw+p5W2Kh1SAYLao5+S2eLAvOj4EiMBUDyGqZv5
 5TH9yoS67IbhMkY6HszJnAvL/FDUmNqC0srFHJ4ZzEtwWL4z5nO5ugmqtz0mOtOSoqon
 4rcA==
X-Gm-Message-State: AOAM530z3uTz+I+9/0Bve1UNuPWrKxHYKgw5KDlJ/VJLz0NHegknBZvY
 bdhzPsxKhc3do/SREa2ST/TJhauE304S
X-Google-Smtp-Source: ABdhPJznjaU0Yun87ow+H6KZ/LD9kUqsdbc9elNbI5loy7zUnacmNP+CBQyMkz84xwCbZHRBZ8tbgygT96wL
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:90ee:: with SMTP id
 p101mr3023584qvp.29.1610108176503; Fri, 08 Jan 2021 04:16:16 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:21 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-24-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 23/26] KVM: arm64: Refactor __populate_fault_info()
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
