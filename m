Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD7E4204B
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154473; cv=none; b=cRvykNc4mub/8c8G4fFq1qyQa/1PqlHs3QlZAKaiAxZU7wceY/Deew26ISbf1+6bPdNuEajtYSuu3yODF0CSsn09jRNFWWOvTeSRJhxVnDokwW2kfmYrDjYkOg6sXLEADkUyvKMx/lm9ge9qxjWUzhX/nP/kx2k1ziJdiT5bj4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154473; c=relaxed/simple;
	bh=mG+gwuYoMb3Vo7Zit6R5pMWMaEHd4Biv/wMBaXe4gGo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iqsyv56NvO3NNxsTcfwrfqw/yCHKwpyGKZQ20i1WBr3pktMD44jxvrwBM4g5GUx1hnehk7RBCBmvm9HMcXHlzyEVxW9OxFY6mZ98auIKI8tUhZInnt/EZSnq+ldjpiABIoOkhiKXfhelRIY9PmEW+oxpBStvGJEFE3/kyxSJDWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LokPCPWz; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LokPCPWz"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4349e97bfc4so42138445e9.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154470; x=1733759270; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPI+uRMl4bq1O2uoMReaWsKRsX33Uxa7dW6AA7WPtds=;
        b=LokPCPWzoMh9ZsckdV1fkpeJILvaoYowvDnHgF2cUldcHbFRB/C1NjPhm+x9adC7kB
         H/Yx8546crRit3K/lrDic/Uvc5lf8Trua0oPsliURGn7ubS79qeRhXQkh2TjDzyZyVZt
         4m21FxzkDwb/t2jhY/IeMI5BXTwi/VLw4SUpXirjL/sg4bCxdBu3aQwBR6s6PrsUaIH/
         +dIbffFjd7K5I8ALrLUrj5H0JhyyW5VUs3+b3OES2p8EiudnDH2GvqomRAB5clk+ePgB
         uVRzj6r3a1TjHfBqGeq5Wg2MVg//xYr9iB2P09/PKJml4if5MJMmz7ZT57aoAQVJ3xez
         wjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154470; x=1733759270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPI+uRMl4bq1O2uoMReaWsKRsX33Uxa7dW6AA7WPtds=;
        b=SiZNMacxt/+px6wh3l3LBTCBJhztwDpbm+nQP8DQ8iPWQlgsbKFlYJGo0HN/57YsSR
         6HrDNH1yiHwW2l1e8D0cRZ58kBG3SetWH36oLLEYlLGjnbLSsuwDpAgA7S4CbIHw6ROa
         VL1rhdpOkS0Pyvn5SIpZ/2veM3pijg3MHs6kCaQrVwDy5Oc6/e34QE7RG11ALsyGB9vo
         d+G6+/A6U85aPLssNcHW2+JFjS01PU7YDFKpsS9uTsJ7g8eR3Hc/rm0xXr1YEJo56Z/o
         V1Ef6IQ1zbdDa6+0lOgpg9rgZPIqBF6YskJou6MllEwpMe9eiMdX740YGznsev8SBfth
         RdOQ==
X-Gm-Message-State: AOJu0YyujGY89Iv+kAZkzPlzjD9rtSGQc+s9CkWKVOJ8ZROfqdY3AVOq
	wXK/mVuuVgCbW1wZuf4N6KeVeQdP/xQ28VSR6rtgMsuKg2KREPsBvhn3UgZXIpfE+UuHxoG8/hf
	vdG3m99m/sXKro5QYHcDlMiCC0WnOSwAsl97umlWZeJ1/f7JCBcVBNahoLd6y2h4g8+Haa6XiIZ
	NEzUFVegRbay314K9ITIftoumYGoI=
X-Google-Smtp-Source: AGHT+IEp7X86inftmGsQ732cABCtsgiMxDhcYbTSYP08sh4XB67rpwq28/V7TmNj/VlEkuloUGb5UIFDxg==
X-Received: from wmlv12.prod.google.com ([2002:a05:600c:214c:b0:434:9de6:413a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d20:b0:434:a5c2:53c1
 with SMTP id 5b1f17b1804b1-434a9de8bd4mr219924615e9.23.1733154470020; Mon, 02
 Dec 2024 07:47:50 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:30 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-4-tabba@google.com>
Subject: [PATCH v4 03/14] KVM: arm64: Move checking protected vcpu features to
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

