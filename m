Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32912AF03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346268; cv=none; b=ZJil55fg9czDUgrzOjrI4G5vzvBu4U+tIFRdOa2I7fw5YwN6WxBEhLFTdFdwDTv/kgHklsbimaDKGY29r/FVx+MR3x0VWLeuhDKguCNjGsFMubDB+kcsmKKXMqMHJNP4kCdqg//VDdE5b/0BKPV9QCAl4mpUQCjiIW25z1l1ZT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346268; c=relaxed/simple;
	bh=bVoUyvNaN1oBn6b2VJ/BRoPOjFbYQCKkG2gDf45LX7M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BNC1fPV9dinvwXeTXx+kzhUrG2y10FTzzQlaLLhE4mopLdpfH45iyh8xcYvZMSh/KGJvI6dC/VUTKPQglj840ZXdn7X8dAHB5Tn4lnzzzVu3xxtt0NFhFMLDyqVhwpv/kc4EynTzibvzEHMePwV7p20gDeNWTyyEXgKVSpBwyRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4q3oatW9; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4q3oatW9"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43610eba55bso2941425e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346265; x=1734951065; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xINd9m1enPF0BMWAgJgrGlweRAoQYidCOTnyfqcrJ34=;
        b=4q3oatW9NPYBPmStF+MkiCn1yq344xFo2cgAji5ljsjEuQazyIz29ucSoDzpO1KMCa
         44GECQLFx2l5wA7ShY444jM7bEkdM92pGXyeuM8U/+LQQIENEkKG9BkNHa2hTpcVtFwj
         hXhhefF5ERqFuFW1SYARrmEENwgKzj3xY+rWNgOKljPnitUzZnl0/1yD/nl8OCZ82IQM
         /RswfS0Pd/wer1v/XiTvA+2jB1m9R5xceZPeMdgv2hVdZb4q+StopbHqhae3L/GDXcHV
         HSa0d0jB6U7sde8a54BtCFVD+OF5z8esBdJ7Bb3v+IoD9c7OHbXU/Xu1RdvZy4sKEWmP
         uJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346265; x=1734951065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xINd9m1enPF0BMWAgJgrGlweRAoQYidCOTnyfqcrJ34=;
        b=BbsU/ggL9eRXeEDVYVjasSF1LmlhXLHAuS4+tS6HW1YUfDY6YWJfFa8u1uZDgz+ohH
         xgfpcXFAVyq+MdHg4A/i4UlXX8v+HO/ZXz5w0E4rbpCM97ztCRPTFrxBslp2ZUzM3SYO
         iuD+vDbUvWA/U7A4gtqdohx8wuv4QEj4Rph2ceK1nHrKsmS/wqR3CvopalEfPXbf0ErS
         I7UbNY+EkN+FTbpKyPmmL5dFKebu0yROR/sgHnMW6LV+p8EAmfaHDacJy04dNZ5Q3PIK
         C9tAOyAEW15tRx5Io/aW+5SxFsNDHKgj6JOaDl7JuK0gWh/RhxqoR61/KkRmE5RLbxGC
         TITg==
X-Gm-Message-State: AOJu0YydF20uMp7NvsS5j86+g0PP5ZX9AE6hJh4LABK/iNeE4rkLZDlX
	JzJbemk6IA2nK0SwyhzvgC49slP/k2Kr9/1+BQtjJgjSPqT1WCTY4FPNiQxTqccJEpg6szY+lHs
	jmZXGM3hw9VkSvtIwImlnQ1IDbLJDtLufyBKP+pqjJ33KMTsJzKZCNwXGFWGCZv1xymId2VQG8A
	43zU5SiwEc4A27OqCfW/fY+htCbe8=
X-Google-Smtp-Source: AGHT+IEkppS2FfLAL9KMtR1A3yTWzMg2ideEuEAUEGrL411aDfJOIT/6mrKwmt3iUJ4BEP1l0XAETHjHOw==
X-Received: from wmfo9.prod.google.com ([2002:a05:600c:2e09:b0:436:17fc:a902])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3503:b0:434:ff25:19a0
 with SMTP id 5b1f17b1804b1-4362aa94379mr101994565e9.21.1734346265316; Mon, 16
 Dec 2024 02:51:05 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:43 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-4-tabba@google.com>
Subject: [PATCH v5 03/17] KVM: arm64: Move checking protected vcpu features to
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
2.47.1.613.gc27f4b7a9f-goog

