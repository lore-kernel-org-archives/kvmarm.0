Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC052EC57B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 12:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762261154; cv=none; b=s7+PPA0HTjAbDvlVCwypHRIMpy9N84eYCa0UP5POuhzIgerVnXPaZ5np1jtEO5mhUTu6M4BfuEOb+y0eST/7ONMhRs1ENmSzm93CpzA3cawRg9TPshyMYLnjOkVmV338sfTLyrj8t1Ji2n501Y0kDB5wFb88Tsvpo32t/vWIvrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762261154; c=relaxed/simple;
	bh=EVDjTIto09NGjwaBXpW4SVJMN2o1PzDDr7NazX6Lpm0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RnAlkIO0GZlL+SxP9g5nqMI44HcfGErJ4jBwBpxjZpATD+VJoWGhZqk0R2mBkyA+S8q/QoyyHYaqI46BR0CEM0uuUpO+5vhwwERjiQF1mdph5OcPTgb8YOqp1/GZsHJJFqtzjIy9Pc1olxIRNq9R/19lwGspCr8VPT6FJdkioR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HxXDglk2; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HxXDglk2"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-475ddd57999so55844105e9.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 04:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762261151; x=1762865951; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DFNa8Q+6QowOPJl++ePGanSGMFsq1Ca84tP7hBZzTlI=;
        b=HxXDglk21HIioC/AmPVBAl3QS7EqwEltIy5Oxk6KhlpR6qURc/JT0KDcbi3MtWHn6x
         1oxZH9V+wB8NLsZR7rnEZs4fB4AKGZL3wRXGVOBkG3blb4CYPisXvtNLOU825kIP95yQ
         H3l/B5UyKJQh/lwh19EA7qlY941cgrMZ3hjDHoLzQ4lFk76tqxBmX1tUsVVnGMgKooak
         Ff36an3PnoXvHKDgD03q2AOTjKdbgzoJxFKFGOKrVAtDxdJgnqV88QnfeaOLXTtDXeND
         x26zsSTkIAMjly9iT9bQzaxDhKjCBMXW8SDfR+no0RAOXV6FetXIAI0kC5ehp3OAm7YS
         yXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762261151; x=1762865951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFNa8Q+6QowOPJl++ePGanSGMFsq1Ca84tP7hBZzTlI=;
        b=pinR335JFG7/v0hVT7mP3n5hpoV8SmLlyFgxYG/Uju8lxuh2nE1HEjCrOX8NscF4LR
         y9m0zGc3GLVOcKbBb3rW72uuUlBEJKMh75BG6GuT1xmWGj+bjOPT5V3snsPnAX8ompFZ
         16RGHNW4uVbrE9c+giCCSfmFvMBwnIZJOFFTpnzNCXzRA2ZrzxCuHczXxh/Xfo+8OOTT
         fzS0hQyFiMlUWw0ck1Xx6F7ROPiyN2JqzG6i4/w8u14P8jDgiQlQ0U7L9Aj5DlCOnenl
         A/5Ekyg3hyxj1CQroFhmBaeU5EkFg6CVkzD65ekuy8VJhfUBnFTsADMkBrngk+0Rajp1
         u9fg==
X-Gm-Message-State: AOJu0YzlApdJvRqiXyqoXd9OVb4LCHhpUFz5pX+cw9vRgs1KZZsxdUOo
	ZhZKwOmp7x0gxodxP3ymp3mMkhCuYa8AS9JPMzNqTyV7H2gXawOoSAakcQym9b58Mg8urqHo2Dc
	JZxvBQunfNoyDeClPesEHn9GXepXmVjOuWcSovzWN74AeakDVqf42mAuPkl1uCOa+cJcdmYz1QM
	S/A+YGDVN9nyEIynYSyzasY8G5uf2RVaw=
X-Google-Smtp-Source: AGHT+IGTc02+16G7D3Eoo2FaQw/VYtwtLC1xToRD8P5tjdCEwwml9nC0y9kN+6d1sQAh8I5L6ersq2lLgg==
X-Received: from wmbje18.prod.google.com ([2002:a05:600c:1f92:b0:475:de83:8f42])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b8b:b0:471:989:9d7b
 with SMTP id 5b1f17b1804b1-4773086d53amr155827455e9.21.1762261150630; Tue, 04
 Nov 2025 04:59:10 -0800 (PST)
Date: Tue,  4 Nov 2025 12:59:02 +0000
In-Reply-To: <20251104125906.1919426-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.997.g839fc31de9-goog
Message-ID: <20251104125906.1919426-5-tabba@google.com>
Subject: [PATCH v1 4/8] KVM: arm64: Refactor vcpu_set_hcrx() to reduce indentation
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Invert the main conditional check in vcpu_set_hcrx() to return
immediately if the CPU does not support FEAT_HCX
(ARM64_HAS_HCX).

This refactoring pattern avoids wrapping the entire function body in
an 'if' block, reducing indentation and improving readability as the
function continues to grow.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 54 ++++++++++++++--------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7880e8290a20..034e1b39de6c 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -674,40 +674,40 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
-		/*
-		 * In general, all HCRX_EL2 bits are gated by a feature.
-		 * The only reason we can set SMPME without checking any
-		 * feature is that its effects are not directly observable
-		 * from the guest.
-		 */
-		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
+	if (!cpus_have_final_cap(ARM64_HAS_HCX))
+		return;
 
-		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_MSCEn;
-		else
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
+	/*
+	 * In general, all HCRX_EL2 bits are gated by a feature.
+	 * The only reason we can set SMPME without checking any feature is that
+	 * its effects are not directly observable from the guest.
+	 */
+	vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
 
-		if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_TALLINT;
+	if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_MSCEn;
+	else
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_MCE2;
 
-		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, NMI, IMP))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_TALLINT;
 
-		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnALS;
+	if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
 
-		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnAS0;
+	if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_EnALS;
 
-		if (kvm_has_tcr2(kvm))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
+	if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_EnAS0;
 
-		if (kvm_has_fpmr(kvm))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
+	if (kvm_has_tcr2(kvm))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 
-		if (kvm_has_sctlr2(kvm))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_SCTLR2En;
-	}
+	if (kvm_has_fpmr(kvm))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
+
+	if (kvm_has_sctlr2(kvm))
+		vcpu->arch.hcrx_el2 |= HCRX_EL2_SCTLR2En;
 }
 #endif /* __ARM64_KVM_EMULATE_H__ */
-- 
2.51.2.997.g839fc31de9-goog

