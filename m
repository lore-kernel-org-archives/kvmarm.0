Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B13B1F8720
	for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 09:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029986; cv=none; b=AxM1DnPmWqrua3N1xsU/1P3wkpNOkLpmq22b7YEv/5xHFkO/eNor5JBTwiGM/Zjyeh2M/ZueHBiPbN0UqEMVUXKYo/Wd/GFGhflarM/q5reNx3MtvL6sVTWCZmP8hjmuZh6hzKa7lRAnug6qIeAy/AAUfWYVTnobFkMMAX2wPk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029986; c=relaxed/simple;
	bh=cpCjePvPaysnhttxyP2q0T1A8fwc/2SmBzZwgVCNmyw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Lnc2hrjKrj1EwabZt4CjsEpK4xx6HuwqswIbbEkBTe3qlPWWQelZiNhH+Hp63Be1T1eYBfACZpq2AGxEFR/DbW8ME+rSsoGoX5UEW3bxQos7iXr7KkBNy0Iy91WgsCOCty0grgVqXTY1xmpQ2B+L94+7i7iuc/PBilHvuwBJLys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=U207RxSv; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="U207RxSv"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ff615a114bso639253a91.0
        for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 02:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742029984; x=1742634784; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b+bMpkAVOynda5P7ydoOSXioxAp6dNXrbOmJ322faHM=;
        b=U207RxSv84bjoP9CJnRxntlgWFw92quK1jRPFUxGY5fGbmOSXgOFJoiHGD8gUXsm6W
         IBse6d/mtX+QaOV4HL+PHWUpXMzEZh/7dPzVzIGikJqcou9CFMAz6deHQCdPhtBmGLdg
         jxtE4h/BCrDGyo1CtMdIzRqgwlDLvNk8sPMkr3POJnZdcOGBuBBhsoEo3GUlts/y3VQb
         GaM7XbTM4DFQObfkbVS3kzHJsEzzrbUb6urybR/7QfHMaqthco+BaetYlWYnS+fCPsh3
         oNSyjJBr2Ingxr9z3d2ferWLs/9vUROqUrLWS9LpQQCQrC0gS3cqvcMvYNvgJ8CN0mgr
         Rz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742029984; x=1742634784;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+bMpkAVOynda5P7ydoOSXioxAp6dNXrbOmJ322faHM=;
        b=dMvBUbwxJgjSiUtPwM2EAGh/LfYuyH5sws0holY1e483C6u57vgHoGbjuFQc0K2nSh
         aKUMWrsiP4KpQGJkaU0AuNQi+Y3WSo4DgnI265lAgnk9JxGqQBhwd5K+jHV3wQoquzt4
         /T2Led/4PFwMq1sj9HARR7e+vNsrWlqa4n8LdWfCTY9Q0D95SLn0n79Af4fC87E0V3h1
         rgnCqz9Z0UKWURZ3rfV5qQ4qd1d0r+bDAhe7zsaI5BUMgfJV/ThBZfEfvvS2VbogRnDj
         E0XWuwBBvrzlijIRwmD29SRGbQvwRNwz7lh6a4miJQ0WdIVK0QVaSCu5S2t9HTgi1Qtv
         7R4g==
X-Forwarded-Encrypted: i=1; AJvYcCVgyWPx1C1cKLaaBdJAXRV8E0tdybXEC9XrIqkcQtunBiAVSj80Mit4aifLnVd2sZUrtSVTGE8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf/BNe7wAqWp61Hra5dh1BNYq+mAhc+FRHP1WbISTvipWxeGsg
	jLDywIh+HOeQr/Vq2MjGIA1bcvFoiUw88fnTAow0xQLJRZWZ30EmE6QOM/fNa7k=
X-Gm-Gg: ASbGncsreeN85f92Vqxg3CUnaD3QvBaZx7tc99VSwluZVRZ45Wj3hx4CP9jEd8Ltbz1
	iwRnIVvn0UQLAaC+uTI5Bt3bc2bYrxPXvAQVsBXkr/CR+yrrNahcSFpfNXYZf8aWW6p/T7UMpl0
	vlZZ/MY6OMBfeRxydeCbdbBzdKwz9O+H8QtW9BuCFeP9LrS1U03ccm8hNTo+cTOev4dqMa8bGtT
	Ru/xzDD/bGEnyE6TZMmx/ASV/Lt8UyLi5ysAMD9tYJ9m+gD6saM2t8wEdto1fa6qZ3oj6NGNp1D
	KSllZQIyeruQ60t3SMs4SIMEbIv1A8PXIYM2czHCt3IeNwL0NgDUm73VxwI=
X-Google-Smtp-Source: AGHT+IF0dYo0boBR+9bl0vawDxMBgd8T0cqY/hF/tRnsNt/62E4WUY/Xos2ArXYf2sRSNXond0EV3Q==
X-Received: by 2002:a05:6a21:69b:b0:1e1:9e9f:ae4 with SMTP id adf61e73a8af0-1f5c2952640mr6319263637.13.1742029984462;
        Sat, 15 Mar 2025 02:13:04 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7371155aa8bsm4082744b3a.70.2025.03.15.02.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 02:13:04 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 15 Mar 2025 18:12:14 +0900
Subject: [PATCH v5 5/5] KVM: arm64: PMU: Reload when resetting
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250315-pmc-v5-5-ecee87dab216@daynix.com>
References: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
In-Reply-To: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

Replace kvm_pmu_vcpu_reset() with the generic PMU reloading mechanism to
ensure the consistency with system registers and to reduce code size.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/pmu-emul.c | 14 --------------
 arch/arm64/kvm/reset.c    |  3 ---
 arch/arm64/kvm/sys_regs.c |  3 +++
 include/kvm/arm_pmu.h     |  2 --
 4 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 8e10124a7420..aae5713d8993 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -254,20 +254,6 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 		pmu->pmc[i].idx = i;
 }
 
-/**
- * kvm_pmu_vcpu_reset - reset pmu state for cpu
- * @vcpu: The vcpu pointer
- *
- */
-void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
-{
-	unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
-	int i;
-
-	for_each_set_bit(i, &mask, 32)
-		kvm_pmu_stop_counter(kvm_vcpu_idx_to_pmc(vcpu, i));
-}
-
 /**
  * kvm_pmu_vcpu_destroy - free perf event of PMU for cpu
  * @vcpu: The vcpu pointer
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 803e11b0dc8f..f82fcc614e13 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -196,9 +196,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.reset_state.reset = false;
 	spin_unlock(&vcpu->arch.mp_state_lock);
 
-	/* Reset PMU outside of the non-preemptible section */
-	kvm_pmu_vcpu_reset(vcpu);
-
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);
 	if (loaded)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 727579acc7f6..14f66c7a4545 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4480,6 +4480,9 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	}
 
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+
+	if (kvm_vcpu_has_pmu(vcpu))
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 }
 
 /**
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b6d0a682505d..d6ad13925978 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -53,7 +53,6 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
@@ -126,7 +125,6 @@ static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 	return 0;
 }
 static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
-static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}

-- 
2.48.1

