Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003BD303C96
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450037; cv=none; b=OPrX0hx5Re6CQpJSZItVBHy0NAP73RcKhQapc2uIBfzEHFlDXKDvrNiLDp1NM/KUqHfF4gpHKAAmTr2eVpue7xgqPcVivA0b6b/nV1pVYxWdgeE19II28s786yBrVTC+CjRux1j8Nc4pA5wLo2curXsmq10+vxY22L+Jp1T1xvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450037; c=relaxed/simple;
	bh=NG+QVddPMdYZBZEXgqmGKvO03mXoEAEDC38FCChHDPA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BoBYkkZDvZFitzmx7grAtwkhTez8AGAvR4DpgUpmmqIE2y6htAr1JijesIxiQPpfwdbxejUNbbdYSbDFKZas2IVSA3u6ZMW/N5B/4x7SjQtrijGNlZLhKmbPGOVBmMP6Eyrrn9nYUJOjeiKw+K785jgjlL5axLc59NxtTJ6NYTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i0tBBylA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i0tBBylA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779981523fso5943815e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450034; x=1766054834; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CTVWHQr8QqD4O3yE8paC6Rmoy43hLsT5yuKJw7dLA9k=;
        b=i0tBBylAkHbPwDTUBxRWVjosbkSh5UFelK35qjvTGx+kW+PKrhp0njjiTWoeLrhHaA
         k0cSOVOwO71MQBgVAj0VNP1DulBrG03jSXuGIRfk7MavoG1pHwy+MDz/TuTRI1PCcoCQ
         dg+mhp+O2xvwEz1v7lEoOG4h5eJu5DZTCp+7lgDucnKP/SVcm5TBdhEfEQ+0y/WrcKnF
         Mv/44xKcqRZWjMayJmwqE/rTbs+uaUU106sYr5bb+x6typhNVVxDWyldauqm/WnDRzo1
         CmbM/WaJUddmSFsOnGzlI/fGDm2kjJkNUxwhudDqthRA7rlvqyFUIn2zOR/BuDVSq8Ok
         JPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450034; x=1766054834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTVWHQr8QqD4O3yE8paC6Rmoy43hLsT5yuKJw7dLA9k=;
        b=uMg+CFZT2tP6T8PstgUcQQA0dNgS3/1boF3CpZEiUiXLtlvFzDcIVCUY+nGWCqj2hu
         vCtxidDF9kw+aNmWPVUHKAntQN6C7nyDwKejtrevJcmPeomVsVJDSH4hkgM1kPDOp2ul
         tih2zJArDpwW1fPPef86JTq1Ebe2frWGxj5D6vyyAbQnn6fctPSZPpD3JKvCFJXPkHwJ
         Zo2B7OExVoFjpYWg8ofDkGbN5d1HVFVaqQuAeAhuYRUpDY7rCa8RCXshOTSvXJFpOWsO
         iBlcWgPiwDg3LyLL5WF93/eWB0mamhgdnxIq5tlObDmaG/2GbVu0aHm1sVJ3QuJe3lFb
         HZBg==
X-Gm-Message-State: AOJu0YznGpIUmRUIvDsBtMx2H2ikBx6yLPA8gh5AaOQ7Od3T+Svm8mIA
	LVS+mDVMSAf4KwIF4Bp12FLJng14Z3rDVxwIRMHH06v4I8nLY+7z8xbKyTbckY0dVRW+i2Xc7jN
	K+yB2V+142LHkQ2VT5XJyKn4bGcaidhwyAfhwA5pMRhjyuGa1D1jZNIWxx7B4F5x7vX8YMOwG0V
	iN0TOkrbfUcKBmfIYvLNC9R3ir9E05+Ng=
X-Google-Smtp-Source: AGHT+IG9Wdc6xtUTDC6bCCBmVcC2gl7D2XJ0tfkZf2BkoPOzH02VeYq7F+cCcJyhuhK4THfPpeXXBJVa7Q==
X-Received: from wmjl2.prod.google.com ([2002:a7b:c342:0:b0:477:1022:3342])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b22:b0:47a:819f:3acf
 with SMTP id 5b1f17b1804b1-47a8375a9d0mr61731505e9.10.1765450034355; Thu, 11
 Dec 2025 02:47:14 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:04 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-5-tabba@google.com>
Subject: [PATCH v6 4/9] KVM: arm64: Introduce helper to calculate fault IPA offset
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This 12-bit FAR fault IPA offset mask is hard-coded as 'GENMASK(11, 0)'
in several places to reconstruct the full fault IPA.

Introduce FAR_TO_FIPA_OFFSET() to calculate this value in a shared
header and replace all open-coded instances to improve readability.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h         | 2 ++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 2 +-
 arch/arm64/kvm/inject_fault.c            | 2 +-
 arch/arm64/kvm/mmu.c                     | 4 ++--
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..73abe697bc2d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -343,6 +343,8 @@
 #define PAR_TO_HPFAR(par)		\
 	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
 
+#define FAR_TO_FIPA_OFFSET(far) ((far) & GENMASK_ULL(11, 0))
+
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
 #define kvm_arm_exception_class \
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 78579b31a420..43d7dfa2c517 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -44,7 +44,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	/* Build the full address */
 	fault_ipa  = kvm_vcpu_get_fault_ipa(vcpu);
-	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+	fault_ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 
 	/* If not for GICV, move on */
 	if (fault_ipa <  vgic->vgic_cpu_base ||
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index dfcd66c65517..c9bbce017dee 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -258,7 +258,7 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	unsigned long addr, esr;
 
 	addr  = kvm_vcpu_get_fault_ipa(vcpu);
-	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+	addr |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 
 	__kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu), addr);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..5b159cf0d203 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1959,7 +1959,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 		/* Falls between the IPA range and the PARange? */
 		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
-			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+			fault_ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 
 			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
 		}
@@ -2059,7 +2059,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * faulting VA. This is always 12 bits, irrespective
 		 * of the page size.
 		 */
-		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+		ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
 		ret = io_mem_abort(vcpu, ipa);
 		goto out_unlock;
 	}
-- 
2.52.0.223.gf5cc29aaa4-goog

