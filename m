Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECC819CC34
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099988; cv=none; b=dQ51fkPpbLphDHK6SVEnm94Emi0Qdxq2H9WYoMLjC0VHBML4Mk9ecF+0GB77XHcKaOhytCSxqn18eZzPRVkZzhSN83CXV3pUVYFd5qLq8L/3cWkntxPPmIfm6Hp8PhfkGbVRVYCmSh9LyXtBYLI6mXupYPEv4km+Gjqr2DShaCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099988; c=relaxed/simple;
	bh=mG+gwuYoMb3Vo7Zit6R5pMWMaEHd4Biv/wMBaXe4gGo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GEUTyAQu1e/v73PdOb1GSUIRaqKjRpp6WcO43rtpsJcJlyKlA1H2Yrj12B7z+x0zN6mlscJBQ+nHVasUBIN1iSdqNmTbkupv1jBPAzJRuryDvooY8tfkwclpY70CP/6881aHvN4dOX2y+CfVYy+1OKTZAAhYH1fKiPNusUIWf8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jtvHKZpX; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jtvHKZpX"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38256b20f5fso242567f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732099984; x=1732704784; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPI+uRMl4bq1O2uoMReaWsKRsX33Uxa7dW6AA7WPtds=;
        b=jtvHKZpXNoFPV7d02y7oMOwFXygjRhAmkehj4IWhS6DxJ/ozvEVRxHrbiIGXrBlCY5
         rhExYcQOZ58l0d9wznCSB6EERIvL0EXg+7OmqpScp2fgIQXJ//nnaEYCucFk+3IbF9gj
         FybTuOXDH+UDLKOJ7zrwPIJ7WpeCh14lbuhERPSYqpjEMackPKopPRIHtsrQU0qg0q9O
         X0LWutKcXT7LaGxzPMOA/BK5Dv/GIYTjCy4k5dJ3921P00Mm2iwRRzlLLTguR1sO8VfD
         h5raoAjqMxlkYQSR64EZEw6jMya8ucA6J0JtqchVyrml9yiPVlzdWAF/9PlXEA2DtrXz
         4kUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099984; x=1732704784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPI+uRMl4bq1O2uoMReaWsKRsX33Uxa7dW6AA7WPtds=;
        b=Q98npNgo3P5hb4IJ77a6JiLVDZ0jQB7JRWsJlhN9c/VSPXXfnM+N+RWtRx6a4H+mq0
         VMM/pjAXIY2n2PR52zmpQ/mgE99W1oJJZ4ahJpXULySR8S/XHb75+FoB1L+PN3b2CIir
         SbEpEILAEsegCfIqZBZxcEar2dvskdl9B5NV4RVB7e/HhUnuEtATXpe9NkTU4wLcPmSk
         A0vqf1+G4TcytF6GJbBsYLWyzvqxqjlFi42UUzPYd61oISRr3sKXsm78OzeXLcYMT9gb
         SZGakiZhgMLNnDHBQLsJxFvWkGv1UHCbuQ0bjOpRA6TeB+Dmz88FLXLJz5yE8O6keVK+
         JcIA==
X-Gm-Message-State: AOJu0Yzw6u65YUzUO4ZD3M9mil4VYBMhCjLh8U4yRgsc3IYkiGvivtde
	GsZWHusKLA/fpaGPhrSSCrHulyPQseKFmxwD/T+TKQEWbbm0V+cJ/tEzz9LmMX1LsMXSaBU7KlZ
	RiACuAruUwP+Ph+63E27ELfpIOG6v3TGodt9nt32d61EuPYdAoiunaNMMCau8x1uUcF0y/lso/X
	PXp+WRuv2fR5RScUpvta4VtcghZXM=
X-Google-Smtp-Source: AGHT+IFi0faN+HYWfuzsVdJslCptQyBCIQ/zbUCCFshMYtb0EBDBR9kVLdsYAblLclntUA35rcQB9IEGUQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:614f:0:b0:382:360a:777d with SMTP id
 ffacd0b85a97d-38254a864f5mr764f8f.0.1732099983563; Wed, 20 Nov 2024 02:53:03
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:45 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-4-tabba@google.com>
Subject: [PATCH v1 03/12] KVM: arm64: Move checking protected vcpu features to
 a separate function
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
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

