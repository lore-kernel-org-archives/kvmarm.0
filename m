Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55FF19D064
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797326; cv=none; b=P+oIJBPrgApwxxQQ69K15td2OYd3lGeeYX2/MXIx3iQiRmNypmAqn2YmsoDDiy29Sk8A8ntxxdOaRfOIziUC9D0rPYCBOWrxo+LMwYWbOwB2BBCkDCBMPcp1t2+8XH+jUWTNjJGy0MwXYWPPxrX1VEiSotGmVBxbPZSvaM3tf2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797326; c=relaxed/simple;
	bh=mG+gwuYoMb3Vo7Zit6R5pMWMaEHd4Biv/wMBaXe4gGo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hsxmcB7s3dgOu/H/Zi52x+MRv+dktlpjdsjNXY251gpSObwrjMg4CO1lTc1guSohC5WrlICsK3Bflgg5OSfPbRvRQUXY6oh8Q5nysg9YjuR5y+6N6cNfpw7FJAXf1jQxJRC3k0oWtTY0IpseZA6tUXZE1ln7IRk40AJWtWvLcH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V/U0BMiT; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V/U0BMiT"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4349fd2965fso7301675e9.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797323; x=1733402123; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPI+uRMl4bq1O2uoMReaWsKRsX33Uxa7dW6AA7WPtds=;
        b=V/U0BMiTznhMyXacxvQqJt2TrY5UNL4uZTovU5BrlKsHfharXbHHq7iVKnSzwNLMW4
         n+B+0mdQ5ctGlyWPTS2hMjLsFkXQ9UIMS+53XPhrRRKqjhD0SmD+kQqGvQTlX4hb65aN
         FGkwchtcgOkITUI2xg3P+esDH7PBFURzABNKPV8vU0rFlcJkMe1gPLDzjBRggl8feWfU
         FSFnqfw2mREt+qJ4825S7R4fnVjU5H+0R7OKxAmtw0QFJO0M+X9wsx++PpYpofI7oDTG
         Cgqn0E5KKzuk37d4Hl+WXEdjKR/Cq6kfqwRanxz2vr4ks1u75cCmwREfzu3e+tDBt01q
         XBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797323; x=1733402123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPI+uRMl4bq1O2uoMReaWsKRsX33Uxa7dW6AA7WPtds=;
        b=sfDl3ySnWepwkP5gFrZ5eya7mhIvMiYu3uPm+VuRnUF6+D4yMn4YYOkLhzUBTs4Id1
         p6FkOatrEnu7aLTZ/YN4uyCmo0Zpy86upxwYOT6KjCqkcSnxAXmlgab6bSpXMxh27mZj
         3jInQwJufnvqHe6QNP3MWXxoSMqtjdd8ORt00gsiOPDGLaGJuXeQIAPdVPCbJ6wu+1RK
         JDoSPRvrwzwDlyWYQTlgdtOG3QpaYukacKrpfdSmpwaMmHgEfKL7XfO9gO3KR3UYWHv6
         eIN9/7T35CsK+q0+Q/faa4zuCdtxF0og4E2uz3cke/IOUGRZcj5aq4WofkAXPlUp7kdJ
         TykA==
X-Gm-Message-State: AOJu0YxcwnA+KxmcLWwhwoTHyfzWjRYJWGckfqZ4KJCLoy6b6xC3KJMd
	uIpkGybw6dr5rzBgE7iJMaHTfEH767YUqPo7lQgoirmwlqy3rJa/kM7PVFHf+4KkA7Yf02xrI/A
	n32YhBadPesdfjzHKkDEAmSk71aEazjoU4mOsPIs5xDqM/LIDSUEkOhLQRCLi/uoKcDZyKKRGQ7
	QrAvHLrxoxOtJpXMPywnOfu7p4Hp4=
X-Google-Smtp-Source: AGHT+IGDUIjMWG2C1D205pF0+TzoXyj8S3VTD3hZfnFv8RXrdOu6JZJXuSb32DY556yY3ixL7HhbnCYPlw==
X-Received: from wmjs15.prod.google.com ([2002:a7b:c38f:0:b0:434:a72c:1d0a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c93:b0:434:a852:ba77
 with SMTP id 5b1f17b1804b1-434a9dcec68mr75825275e9.15.1732797322990; Thu, 28
 Nov 2024 04:35:22 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:03 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-4-tabba@google.com>
Subject: [PATCH v3 03/15] KVM: arm64: Move checking protected vcpu features to
 a separate function
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

At the moment, checks for supported vcpu features for protected
VMs are build-time bugs. In the following patch, they will become
runtime checks based on the vcpu's features registers. Therefore,
consolidate them into one function that would return an error if
it encounters an unsupported feature.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 45 ++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 1744574e79b2..fb733b36c6c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -178,20 +178,11 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Initialize trap register values in protected mode.
+ * Check that cpu features that are neither trapped nor supported are not
+ * enabled for protected VMs.
  */
-static void pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
+static int pkvm_check_pvm_cpu_features(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
-
-	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
-	vcpu->arch.mdcr_el2 = 0;
-
-	pkvm_vcpu_reset_hcr(vcpu);
-
-	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
-		return;
-
 	/*
 	 * PAuth is allowed if supported by the system and the vcpu.
 	 * Properly checking for PAuth requires checking various fields in
@@ -218,9 +209,34 @@ static void pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD),
 				PVM_ID_AA64PFR0_ALLOW));
 
+	return 0;
+}
+
+/*
+ * Initialize trap register values in protected mode.
+ */
+static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	int ret;
+
+	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
+	vcpu->arch.mdcr_el2 = 0;
+
+	pkvm_vcpu_reset_hcr(vcpu);
+
+	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
+		return 0;
+
+	ret = pkvm_check_pvm_cpu_features(vcpu);
+	if (ret)
+		return ret;
+
 	pvm_init_traps_hcr(vcpu);
 	pvm_init_traps_cptr(vcpu);
 	pvm_init_traps_mdcr(vcpu);
+
+	return 0;
 }
 
 /*
@@ -417,9 +433,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
+	ret = pkvm_vcpu_init_traps(hyp_vcpu);
+	if (ret)
+		goto done;
+
 	pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
 	pkvm_vcpu_init_ptrauth(hyp_vcpu);
-	pkvm_vcpu_init_traps(hyp_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.47.0.338.g60cca15819-goog

