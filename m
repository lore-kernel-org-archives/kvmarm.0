Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE4712D20D
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419921; cv=none; b=fAy3uU0SzvQeUfFPL7ApcrDqvD02m6/F7OiGrjnijMdqWasrCj2TovOaFN95j3dovKbuAYXgcthd3wAxbKiIIVMqUMKVqrCne4hm3bgqjrqhRRXUIW69I/K1DKe6WzAwKhHpq9pNtFgdTaJaZwYY+qANKtxL1oUgguADj4e4/nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419921; c=relaxed/simple;
	bh=8SPmrbCgB8ffhbpcTosp/2w3lrXnHnex8/YXpXM64iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgnE3pLByvbYzQ52KoXM0UhFS+2QVBfXxiwFAuQMdoMzHgXLWKEiao4OkzeyOtffzmTEwDN3cHn/H1qk2+PFsxAgjLsKvY6BzPRAEK0yjr1s9yZwdgFg6zoasmAzRdAut3Gl0Pr9C+djw+L5AyW+WJcDcAUai6XAWp9s7o1tYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dtDyjbt1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dtDyjbt1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzuFjVFAR3AFumTLFNlRVUsdOEKIeucLZ/6oKz87YtI=;
	b=dtDyjbt11W2OClvrXjDhSFfEYwzB1iOzD1mrz+z/M58TMZ3xYe48NZZ6jNJtV4ksHb6yP6
	XyjNI0t2YQp+dkAVEIjbz0HEvO3RwWN47gXsbTVLcJPf666wEofAXneEgfjespiJOyA3Kr
	3gqctGnrE36bs8DIzQKIuazBa7JQy9g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-ROJfUxbOOpGcxKdnprDaSg-1; Mon, 03 Jun 2024 09:05:17 -0400
X-MC-Unique: ROJfUxbOOpGcxKdnprDaSg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6aed5dcc5fdso37323536d6.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 06:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419917; x=1718024717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzuFjVFAR3AFumTLFNlRVUsdOEKIeucLZ/6oKz87YtI=;
        b=TJKqKmX1EfnEUF57MpFS+hdFABu5HhzylLG1rfkh62sfPonSYgXrwFwEVODakkjE9t
         FmYnrCY8HZpRaaks6fFRuf/VJA29J9JM9NHGP7XIOyLnYPfuy/iaHSqqjScbwtHDh+zX
         ND9My6LgAGjX4q3mOGlvjg5Is7UqbZj3v4kLmBbEVdjB0hn7aGXfQ7sWvprn4algE+kE
         45ACn8wOqNbDWZRW/MFEKoWLRmBLbBDLyknEN3kBF+0Jftq6r14c5Ky/lwRpl8DHL2E0
         NrI3pzEj8T586dDkUlRm5/i2aciL9EWN38mbBp8Jf4cZEAAKpXFNEhgyRf+vHzJWgnGF
         A88Q==
X-Forwarded-Encrypted: i=1; AJvYcCUgTAvNtGDP6SsK+L/f2QAayFI+4P5sgLdPAQizD1YHSC4SkA/ANyf2wxc0I2W8oyhRFrzjV3WLH8BpfX8UbAii1ZAK/WEP
X-Gm-Message-State: AOJu0YxofQNyLIWjtJehPBYcRwZkjDA5A+YoA9S1Ry7hV96pLeRn2GaE
	UuvI3qTbNPE9CGg4BoGCdA79rWNHmbxQyDuNkGr8Um8Grdu1xVDaCyVCvuTeZ7BXJ5GnMCjtd9Q
	2Od37rO3FcdQ/SCdCh9tdN7MnQ2cEFvEFvbO8HHWVI87Bkr8z3IvOvA==
X-Received: by 2002:a05:6214:33c1:b0:6ae:33db:60f2 with SMTP id 6a1803df08f44-6aecd6f015bmr103753376d6.60.1717419916069;
        Mon, 03 Jun 2024 06:05:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiLf1N29Uz9zD+BrBPZa+eNtVqOIBAZXmAmNXOxr343MDnKfcRlKB8TqTcwvt5BPAjR6KaVw==
X-Received: by 2002:a05:6214:33c1:b0:6ae:33db:60f2 with SMTP id 6a1803df08f44-6aecd6f015bmr103752936d6.60.1717419915596;
        Mon, 03 Jun 2024 06:05:15 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179f4sm30558826d6.113.2024.06.03.06.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 06:05:15 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 1/6] KVM: arm64: unify code to prepare traps
Date: Mon,  3 Jun 2024 15:05:02 +0200
Message-ID: <20240603130507.17597-2-sebott@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603130507.17597-1-sebott@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

There are 2 functions to calculate traps via HCR_EL2:
* kvm_init_sysreg() called via KVM_RUN (before the 1st run or when
  the pid changes)
* vcpu_reset_hcr() called via KVM_ARM_VCPU_INIT

To unify these 2 and to support traps that are dependent on the
ID register configuration, move the code from vcpu_reset_hcr()
to sys_regs.c and call it via kvm_init_sysreg().

We still have to keep the non-FWB handling stuff in vcpu_reset_hcr().
Also the initialization with HCR_GUEST_FLAGS is kept there but guarded
by !vcpu_has_run_once() to ensure that previous calculated values
don't get overwritten.

While at it rename kvm_init_sysreg() to kvm_calculate_traps() to
better reflect what it's doing.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 40 +++++++---------------------
 arch/arm64/include/asm/kvm_host.h    |  2 +-
 arch/arm64/kvm/arm.c                 |  2 +-
 arch/arm64/kvm/sys_regs.c            | 34 +++++++++++++++++++++--
 4 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 501e3e019c93..84dc3fac9711 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -69,39 +69,17 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
-	if (has_vhe() || has_hvhe())
-		vcpu->arch.hcr_el2 |= HCR_E2H;
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
-		/* route synchronous external abort exceptions to EL2 */
-		vcpu->arch.hcr_el2 |= HCR_TEA;
-		/* trap error record accesses */
-		vcpu->arch.hcr_el2 |= HCR_TERR;
-	}
+	if (!vcpu_has_run_once(vcpu))
+		vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
 
-	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
-		vcpu->arch.hcr_el2 |= HCR_FWB;
-	} else {
-		/*
-		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
-		 * get set in SCTLR_EL1 such that we can detect when the guest
-		 * MMU gets turned on and do the necessary cache maintenance
-		 * then.
-		 */
+	/*
+	 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
+	 * get set in SCTLR_EL1 such that we can detect when the guest
+	 * MMU gets turned on and do the necessary cache maintenance
+	 * then.
+	 */
+	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 		vcpu->arch.hcr_el2 |= HCR_TVM;
-	}
-
-	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
-	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
-		vcpu->arch.hcr_el2 |= HCR_TID4;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TID2;
-
-	if (vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 &= ~HCR_RW;
-
-	if (kvm_has_mte(vcpu->kvm))
-		vcpu->arch.hcr_el2 |= HCR_ATA;
 }
 
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8170c04fde91..212ae77eefaf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1122,7 +1122,7 @@ int __init populate_nv_trap_config(void);
 bool lock_all_vcpus(struct kvm *kvm);
 void unlock_all_vcpus(struct kvm *kvm);
 
-void kvm_init_sysreg(struct kvm_vcpu *);
+void kvm_calculate_traps(struct kvm_vcpu *);
 
 /* MMIO helpers */
 void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9996a989b52e..6b217afb4e8e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -797,7 +797,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	 * This needs to happen after NV has imposed its own restrictions on
 	 * the feature set
 	 */
-	kvm_init_sysreg(vcpu);
+	kvm_calculate_traps(vcpu);
 
 	ret = kvm_timer_enable(vcpu);
 	if (ret)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..41741bf4d2b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4041,11 +4041,33 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
 	return 0;
 }
 
-void kvm_init_sysreg(struct kvm_vcpu *vcpu)
+static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	mutex_lock(&kvm->arch.config_lock);
+	if (has_vhe() || has_hvhe())
+		vcpu->arch.hcr_el2 |= HCR_E2H;
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		vcpu->arch.hcr_el2 |= HCR_FWB;
+
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID4;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TID2;
+
+	if (vcpu_el1_is_32bit(vcpu))
+		vcpu->arch.hcr_el2 &= ~HCR_RW;
+
+	if (kvm_has_mte(vcpu->kvm))
+		vcpu->arch.hcr_el2 |= HCR_ATA;
 
 	/*
 	 * In the absence of FGT, we cannot independently trap TLBI
@@ -4054,6 +4076,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
+}
+
+void kvm_calculate_traps(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->arch.config_lock);
+	vcpu_set_hcr(vcpu);
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
 		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
-- 
2.42.0

