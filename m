Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2593D1FCCF8
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849110; cv=none; b=tXsbpPW0HFBNJ1pLZKjpMWuFkx6yTfic7AfcSl/fiI2G3rHA16vxiFRXoEb1VDe7deSrUtTztA4rLbtxCnU4njARSUI8fvUhc7XTqHgVtlViGRclnuLzM+I1IskeNNJ7StDzmaivYkUmGzbCv1vSO6WmH6KPnYFfAdYUAR/heDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849110; c=relaxed/simple;
	bh=UG93/JN+C4uzEWrf1epKiCm9PjOLeEr0WUFlntrYe/o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=atghY3Aw1UBYs1T307HbNPXCxo0zfYcoh16IVV65padAyWyURXIpq+rB97yZsIOs2i6OLI6HGgMRSCenFxxAq0h1G5GvC9s5WlJzku2i/znBKOBM5IKMhGG8+x26WKbTBsp8CTiNgdCc4r0C3XuOumImmuRBbSAvH3gNJWelQ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=TdV4u0vb; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="TdV4u0vb"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22580c9ee0aso10638015ad.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849108; x=1742453908; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x7fhBUFv13S4cZKboUgbYf/t6ZbQKDXA1phxFoEaqP4=;
        b=TdV4u0vbFEHGVaDcE4YOe8xCa/MbX0ftaHs1Wm3DmWBENmnFVO1Yv49DgWr2OWQ6Pm
         ZTWNKn+TBGwJDuZmIWbDFixPUN+LzGOEK4VhIUlCqlpUYl6Ob2lMFplGjs/wcbxm8U4H
         AUBIpbUVr+v08vBzO4MUE5cUC334mlJ1oVWcZNju7hhCi9m+vSrAqPkk1m/8GrZrtvFx
         rlLp4IuCiZM7m49LOplsLNJqY1RwUhSl9HiHfhTa0tQs3dzThL5G3MWaIlhfoEI2+6y0
         o9loGBVOxFXH0ggbwwYFyLbzFr3um5meGAuP1fE7ntfnbx3JCLwLMyViIU/H09Nv1m5A
         A0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849108; x=1742453908;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x7fhBUFv13S4cZKboUgbYf/t6ZbQKDXA1phxFoEaqP4=;
        b=l90h8WuSTb56S2fXMQYKkt0DuAgaX7HSeygN/wNOjM0QxmzitAh/4NxyEeraW4oD0J
         GAnOvVVW0OUOnqRHnkhH5w4bW/Zpw1myHfLZpNH1/riMegrsD58AQ35h693ek6nBTPoS
         C61XVns1+tEZx932DBm5PmRzL6JGsE9dI00vOdBjGQzyCuVHEizlQ/+QImuY4Vl7M/uf
         YtMlcE0tQqW89a4r9FcuWomWthUArvP0p695TSz6cSQEC541RV/tMyH0GCUwi7lGaolH
         fCPiAA/KXAYch9o4AhQmSS2n/jgm7yGg0YNJx5sYI8gDwoFqINEBKO0Yq7nvMbdc+ebF
         gN2w==
X-Forwarded-Encrypted: i=1; AJvYcCVwBYsWxi8/C6vqX3aPUB3lR0rcUmWpOe8lDxk5n2kd/rbNB4xY2vBQXFmk/xJk+cc245Nsu3k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMl7ZSF90IbaBH+WCZpg6XSNoJDXTa5+CbndysK8HbCsRUlF2D
	hDsEMSyygX6gvBVeBtI9boZoC+hYMldlJ0ZNLRsr7cML5FgKmP1FMLO8fJ4tIuY=
X-Gm-Gg: ASbGncur1DEVi3fzr7DGy9iVGsSLL17fUo0ja4y20sahxFGpq0GObnal0/kI7QV9m/o
	pqFDXboYOg/VZdQH6nWNmqtDCPweDkuo4NFETygrs0V/xfO7Ialw+HTi8/T0C08O0hUDdCrl8Uy
	el4nlAaKkfiW3h7nWv+8sO8RtW82KzmcewKjhVwSK/8psMlQlqm3wwiMuJ5c7jFq/vnIis22NFD
	7AlF0UEukgNBsdvE3G/APVkL8zut0Hclem7zWTLBGRA1ChS7DaX/lSCW06CxnUmKTw9Jdxs7LwZ
	nkk7+PwwdE1vK+sOm4fb9oa2Fw0ou4QPziG28RoJCFbiTlRT
X-Google-Smtp-Source: AGHT+IF+TgNoMe5M/byYKEN+EBcKDv/E4YdTnk5/x7Qy9/IKHZJiaku/6SW8IuLAbysNFNl6dwBYew==
X-Received: by 2002:a17:902:ec91:b0:223:5e54:c521 with SMTP id d9443c01a7336-22428407e93mr350878545ad.0.1741849108400;
        Wed, 12 Mar 2025 23:58:28 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6bd4dabsm6447105ad.233.2025.03.12.23.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:58:28 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 15:57:48 +0900
Subject: [PATCH v4 7/7] KVM: arm64: PMU: Reload when resetting
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-pmc-v4-7-2c976827118c@daynix.com>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
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
index dfa7048a3e2a..62b1deba9856 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -248,20 +248,6 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 		pmu->pmc[i].idx = i;
 }
 
-/**
- * kvm_pmu_vcpu_reset - reset pmu state for cpu
- * @vcpu: The vcpu pointer
- *
- */
-void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
-{
-	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
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
index 0b0ae5ae7bc2..7f44539bc822 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -201,9 +201,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.reset_state.reset = false;
 	spin_unlock(&vcpu->arch.mp_state_lock);
 
-	/* Reset PMU outside of the non-preemptible section */
-	kvm_pmu_vcpu_reset(vcpu);
-
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);
 	if (loaded)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 11718c635e2f..307ce37d0434 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4262,6 +4262,9 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	}
 
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
+
+	if (kvm_vcpu_has_pmu(vcpu))
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 }
 
 /**
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 9c062756ebfa..8ec6296c5917 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -45,7 +45,6 @@ void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 v
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val);
@@ -108,7 +107,6 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 	return 0;
 }
 static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
-static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}

-- 
2.48.1

