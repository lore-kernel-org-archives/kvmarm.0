Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E55264A63
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739545385; cv=none; b=RjN01361odUww6/Hx3a2glW/NfaIHVvzReGn0yUNt7cSRY1RJUAQrp9eyRLqdxaQqLrZjRoBIqqJOOfXTQ1/bF0yQbpSrcRWafdC5oupTCRnUTgZaAVacKVLWaI0wHaSWhjZ0VfnxeU+KH4mEgk3zCZEURzuI36wIQO0C1IJfwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739545385; c=relaxed/simple;
	bh=TPcD74ZppgZCJTNOYQ69WPGGQiuDlvZF1GVBrIWEISc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G/1+orvfImye94zTbEenNz/PJqGh2PacPtvYLfclz/aJCb1cp43yvTCBIsNvI0pS7x+77W2Pj9cq5q4kDlm0z4gFuouXE/noJoqSQ5+yVdUrUJxInHMdeuvMDWpENJY5CYHSIZ6X9W62fXu8fCtSzT4vJZ/NQtuZ0gLmIxFm7mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jJ0A8TbS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jJ0A8TbS"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43935bcec0aso17782765e9.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 07:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739545382; x=1740150182; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y42OaWjgB0rg7blG3Pk/mPM5kBIbWAmK/8gVhR7spnU=;
        b=jJ0A8TbSvfLHcltkAw7ZFbaFPCdQ7VNTLVZCNyICHZpZbj1dWB6a3+UYwRBBGKp3hB
         wjm7k5Go2CXp0PCBWOQIPkodERkPFN4nBkUUu76xFDaTRsJ65HqkKwZCFQPn4QB/ddw9
         U/qCF8y/UL/Q6F3Mb1oo6vFYO3v1VxzKQCAv9GdvFbxnqIlYbPOl0digMj3uaEEtC7lw
         FjIhw/U1yIF2yA3n8n1EjD57+f3icnI+ZMXnYWzMgaU1H2oUB1E1sKPBm4yKN0jLhHKd
         io60WjO4IUDzf4JxdP91Tcbw1Hyy87hOCTBxx9huo7dwYXj73Aa7+k66vS3DqZE6MsSe
         0Hqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739545382; x=1740150182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y42OaWjgB0rg7blG3Pk/mPM5kBIbWAmK/8gVhR7spnU=;
        b=ioEhlO9XIS+D/0kG1+Sq1K5AtOq8xda6kBsOGKL5CtiNQxaqanV50ggMX3EYEYFLhu
         4rVoOWUoVIqzDvopBsO48dpCfyzB9Pgrdriu8bwCjOUZjyYw9U01lu7RYFv9125nPUJl
         xXGr5U593SRBhXGOgCahGlgBxglgkwB1dFwOUGctyuKITHuLs4QLWKYbbk6JCeFPT1Dc
         8ObNEVoBu6kBC5Nb5++IAW8hLXtxfzF0Dvy5Hq4Bj78uRYdxHpKYC5TcoKdXIfYVdzzn
         Y+LMmT2gy6If+xgKm7EAgN2/8pXbQCekU5Kr6kQwOZtFO2b6jUhCSwCDMe3CvskLL8/M
         OGSA==
X-Gm-Message-State: AOJu0YwbV6tLvO+vqILm80pTCMdgrW9iJnOOnwOI3a18EEPliBa2ZUkr
	leeFNd4WYPUklZUh9SXCU2RGZako/VWQclDMN95UlZq+wZ9kiyIystFOCLOtKJ+tPEBamOrQNZN
	RsMBdPqENZSlF+Sw7gMdfYr+bgdTNZgHZ7INM4GaUOk7KNi7WOC5yJ2nKjEwi0rvr3dflf+j1vb
	Hf8BbKDbTRBJ/bugAPvscPxBMyXO8=
X-Google-Smtp-Source: AGHT+IF62UW0ZAUqxob5YZZPd/L0FZ9/3SweMzcmTIEF6W/RKtm+jgMe9LQ3g7afaCYpLDIDmocY+1lPOw==
X-Received: from wmqb9.prod.google.com ([2002:a05:600c:4e09:b0:439:6217:c147])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3d9b:b0:439:5aa1:1efb
 with SMTP id 5b1f17b1804b1-4396018a96bmr139269315e9.11.1739545382155; Fri, 14
 Feb 2025 07:03:02 -0800 (PST)
Date: Fri, 14 Feb 2025 15:02:56 +0000
In-Reply-To: <20250214150258.464798-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250214150258.464798-2-tabba@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Initialize and set the traps controlled by the HCRX_EL2 in pKVM
when the register is supported by the system.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3927fe52a3dd..668ebec27f1b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -58,6 +58,30 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_ATA;
 }
 
+static void pkvm_vcpu_reset_hcrx(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+
+	if (!cpus_have_final_cap(ARM64_HAS_HCX))
+		return;
+
+	/*
+	 * In general, all HCRX_EL2 bits are gated by a feature.
+	 * The only reason we can set SMPME without checking any
+	 * feature is that its effects are not directly observable
+	 * from the guest.
+	 */
+	vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
+
+	/*
+	 * For non-protected VMs, the host is responsible for the guest's
+	 * features, so use the remaining host HCRX_EL2 bits.
+	 */
+	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
+		vcpu->arch.hcrx_el2 |= host_vcpu->arch.hcrx_el2;
+}
+
 static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -92,6 +116,26 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 = val;
 }
 
+static void pvm_init_traps_hcrx(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 hcrx_set = 0;
+
+	if (!cpus_have_final_cap(ARM64_HAS_HCX))
+		return;
+
+	if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
+		hcrx_set |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
+
+	if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+		hcrx_set |= HCRX_EL2_TCR2En;
+
+	if (kvm_has_fpmr(kvm))
+		hcrx_set |= HCRX_EL2_EnFPM;
+
+	vcpu->arch.hcrx_el2 |= hcrx_set;
+}
+
 static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -165,6 +209,7 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 	vcpu->arch.mdcr_el2 = 0;
 
 	pkvm_vcpu_reset_hcr(vcpu);
+	pkvm_vcpu_reset_hcrx(hyp_vcpu);
 
 	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
 		return 0;
@@ -174,6 +219,7 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 		return ret;
 
 	pvm_init_traps_hcr(vcpu);
+	pvm_init_traps_hcrx(vcpu);
 	pvm_init_traps_mdcr(vcpu);
 
 	return 0;
-- 
2.48.1.601.g30ceb7b040-goog

