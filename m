Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA7F1E9919
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782335; cv=none; b=X4BlO5arx722vGf20gAXXGBmQZ0VaTWvZqgcxRroFkQLMsZbk1Qz3Ad00P43ls2dA2kTIAob8v+o1e4XpS2BDN2W8BUzRLG8LyFivgr3giYktWr8tRI/tTr+9/bFYgLpH2j8laU/SoEVTByuDOH+L33QhpEFgIaMgSnwLI+WnIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782335; c=relaxed/simple;
	bh=175eMniaoZH9OwYm9KXAc5H9VVXTaJRCSTXfCs6BIJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sP/L7l1pnzCo48tdGv54WtfhaR+Ww6NisjLA69oGRYbkTzBY2PV12BLFCD0ekCy2l93hf8PYk6OPxxmaRkLo0JCYN0DkCAqqA5owc2ahSR/ERW/PLVhwebJvvBSjnaifNzJT7Xbnx5OSa0rb0TihoX2Ukpmqw4VHHYrqpSiMzR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KJIMxrod; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KJIMxrod"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cceeeb96so1518684f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782331; x=1763387131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JB5qwwMZxO407X97+Vf/KcwBIUQMngdzvKz1itKcTdc=;
        b=KJIMxrodycHYAsQ2UKm2vvmmzpYAlrx/+DkD4mZTIjFOcxqagKqlZzVFYPTF0cr2jO
         csdFsIBzIDKHy9XFEoq6ymd3fuTX1gMYiETLlu6CvuRM9QmA0fUjxe9327Oq+Hl4rqec
         ZkwufwOevQPUnSp889TLHDlY0oy1v9oBkSPosa8SB9GfmqkxQLnitCgAO5KJoSEYcQFe
         TDrxh6HGs8USW2l6EhMlIjwrVFCI3mWbCGliVRlCWTCiQLRxWPNo+MtAXi4eGgJ9Fl6i
         6qrcqoLZ8JvxgieZQdZhgazwovsYw6xV+CLCFADx5ZzspbpNy/1KXMusPYhtTVHhSf4y
         1ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782331; x=1763387131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JB5qwwMZxO407X97+Vf/KcwBIUQMngdzvKz1itKcTdc=;
        b=sh6mVWQQdzDsgjR91GQsWYnTq2tmPtBYQ9ahWb2okk7U3j3TQ01OXXVw30H89G4ffY
         vhXDCJEPB80MVRD2IPJHJiJdcaH1vG0DmpnBwt1cWnHBQbQVY+F8LRJGpYSDk7Hz9vkt
         jGB+TkKSOtQNYtKTqgkapBPH8oF7tD4k7N2PxIFoH/trDcd6ddrnV1QNIQEo9sj2jyRs
         m4RAiaQDsgYCxqvilFujqtA1wDi4ffzo7JeYLFLF281uKpTWWgrWDYsu3fTHPm/OVxer
         0kHD8h8+7amtnI48bz3YCNf1xVA9qRZJjclQY6OSvEpHuW7manTsLbZdChxURMCSI99x
         4NdA==
X-Gm-Message-State: AOJu0YzsJTylxw0ZsNozsxJfLZzaH5yYx+ORNasNe0i5K+lyYN8SzkKY
	J3IjInM54KOENfkMIq7VmGyfu6Z3PbjyVxJhRBEUZkqEaTmGyryrLk2GjffLG3E8KEq1RZQipmo
	CN2/8A1VYcXyqI1usNMLFA24MjlIKBlyLxHFh4xkX9plwBq3cCCQXO3CzS4NrYQeHMWtNzkaAzP
	O2Cj7d0oDQ/SBZXlqO3WOKVxPiZ35/fts=
X-Google-Smtp-Source: AGHT+IEz2iBL2qKm5t7JV1HboE0FBN8eENcDqbMVwHtPM4RwpFQ0TU+Dbwo3BB7GseTu/jEADGZ85DZurw==
X-Received: from wrur5.prod.google.com ([2002:a05:6000:1b85:b0:429:c8a6:4f61])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d07:0:b0:429:cce9:9b76
 with SMTP id ffacd0b85a97d-42b2dc4aaccmr6293392f8f.50.1762782330778; Mon, 10
 Nov 2025 05:45:30 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:21 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-5-tabba@google.com>
Subject: [PATCH v3 4/8] KVM: arm64: Introduce helper to calculate fault IPA offset
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

