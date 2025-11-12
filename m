Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681FF2C0296
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939259; cv=none; b=iDMoNcJNI612SP5th0UAXMIRSpaxf8rN54r73/Okw8j/WULsWSlIWAVJFeZafQ4J8zO/tC4YOY5Uzh8hVkSJfDzA0Uq9+ITl1degUdI9I2xGemikFGIhgc9jGczeKR3UTVJEiddidpdMAMGZcp4woBajsVlxVR2q91nJGrmrEmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939259; c=relaxed/simple;
	bh=175eMniaoZH9OwYm9KXAc5H9VVXTaJRCSTXfCs6BIJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dzGQ2x96C3LotdX0O1V742fLeFsKaWTOmvXPzlyaQTt+B5BhKdGA5wGxCUTcFmrXzUnhYPwR0/PVjiqkojgaIlUxtQpA09SWE+47tdI+8PAZDs3fPDS/kQzV6c2y1obHBV6oUv9w4QNvQbJD5SjII0HAnZaYGKoqpVMwLC8ZMEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L47EybJF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L47EybJF"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47777158a85so6006045e9.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939256; x=1763544056; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JB5qwwMZxO407X97+Vf/KcwBIUQMngdzvKz1itKcTdc=;
        b=L47EybJFFPkJROzqClRtNbSFZxRNzBv2b1CHZlunxJlGbOFxYYgA10AjqQltO1t7cg
         Vop0bevg8d1WcElj5Esmq+YoqX7EwEhpXKed796iG5/I/PJUTPv3Wie5i1XtAgUKHC3+
         Sq+S6Yd1hwG3ZRJWDRqLt7HLBdQe65I/3n3oggDs8/Qf78OYPkDIgenpcTmaRH5GWEbS
         8FiC+OzDlGGMgAXT05LazfJQOtdVYXg6wUo821gUlyZhw6wCxmMOq2eBvB2vW1DVNYks
         Pn1lhiJF9z6WIuQTTwUMdlVypo1fvErH8edshF6u9d9qUcMc8if/zq04G4o4jxm540h5
         nmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939256; x=1763544056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JB5qwwMZxO407X97+Vf/KcwBIUQMngdzvKz1itKcTdc=;
        b=turFFotlCszRFSXBIxsNhxHok7AVQlUR+Kia8XQy9mIkfvoKg63/DIRFl0afT4+4NO
         TR/IwKxQIjUHpDWP0t43/HIlvAe1iG6ypHi0AWiVQALLwTEoZzxkeViVKW32BHsv5xEg
         T6Vs7QFy0LGw2XwKhR4McIC2R4z7n0byhV+SPgox7ivLtCJioAIsDmRoquBMD6ppMae8
         r5RPsERMvVXcKNG2BueXShdDsmcqGgcKBQygZBfFq7FaF3R583kiKy5A372NYjbwD7GT
         9pplL44vf7bG5QRQt0Fu85HYYkFWXUGeCFg4a/r2k/UKcQ9p2CBB/WC3hhBQ2yKiLNgY
         DmnQ==
X-Gm-Message-State: AOJu0YzaN+btrYiZ/x9qhRHZkiuw8LefQN2QuZJJrLbpQpl94ZnGzIMe
	4BkzgE9X0Jn0Li2GHvag77zLucWjiqNBG2y6LQP/YGUE5scuTKpyWW1h/m8aifnyhFZUXvBSK5l
	pITBgRHgjpOS8CB1fw5vuGw1SAYJhM32YAMKvaKczf1QEGuCNFPbiFTkhHAu8sma7vMD438vGJE
	S3EIrMd3rCIYBP8hSQXMvx4IZ4Z5USuwk=
X-Google-Smtp-Source: AGHT+IGSzKv9Qpoz2yI1N6uU2pBwYKoPNwxfrgPxGJ57M4rsQcHsKYhNgr+gdljJbqvoaektBGzCN8Huow==
X-Received: from wmcq24.prod.google.com ([2002:a05:600c:c118:b0:477:74f4:31c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1f0d:b0:45d:f83b:96aa
 with SMTP id 5b1f17b1804b1-47787045016mr18090705e9.7.1762939255548; Wed, 12
 Nov 2025 01:20:55 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:47 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-5-tabba@google.com>
Subject: [PATCH v4 4/8] KVM: arm64: Introduce helper to calculate fault IPA offset
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
2.51.2.1041.gc1ab5b90ca-goog

