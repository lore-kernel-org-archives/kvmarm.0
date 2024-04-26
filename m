Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4A144D3C
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714128603; cv=none; b=GkQi+swqfs1+Onikv+xu+hMCBVuCiHvRdmR/UUgKPg5Xot7rX49cryUDar3YLSZ4DqiOxBXdCKNW2oGVIRmqctfz+l86821076nKIGgw0o9eW+wsrbQFoLXYAFSRUMJw6PsWtmWX1UdK8C5L2U0gGWmpDN4jh1LdLTSSaUOZFC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714128603; c=relaxed/simple;
	bh=utF6bK/ynDvKtFTtpZCiM6gnQeq7mtq++CnFbpesggk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/9vqkBE6jS5R7mr4LtU1t89tHx/BjfQP0bSgCKniuWzGV0RmnalN3EdqKMgaVw3XkqM2+jW5KlyZckbdvu0JgjeCUGiw59oLv7yG2oUB/Up/ji1umtUjfrDdFvruatz1U38+PtwQFyiWnCULBjLsL5x/DB1pgTXgooqQRww+es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C22WuZ/K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C22WuZ/K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714128600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGbSr+4fcHT2eAsfJezUbtC5iwN5BsiYgVJ4o5jDSLU=;
	b=C22WuZ/K7tnEmvQoK05b89c/HLnUfGKRvSyS3Uj32wRrZtVX+tW0OtIsmPKZxxQ3Vu8P5a
	73/uPd0seZzfPKrtRj84kZu7VK+LvOmOSRbzR+JwKay7Y7asoKGStnGftRvM7f+5ugW4CH
	ST+dlrW5xCVNOSWQrjvIHynW2UCqqtA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-dZ12mkPAOhaoiVrXVXq2bw-1; Fri, 26 Apr 2024 06:49:59 -0400
X-MC-Unique: dZ12mkPAOhaoiVrXVXq2bw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-78319f64126so265002585a.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 03:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714128599; x=1714733399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cGbSr+4fcHT2eAsfJezUbtC5iwN5BsiYgVJ4o5jDSLU=;
        b=oJ3QvHvySNP/KInKAR/AQkwt82Zn//ffPGcwwpqBl7ahvR+GDisO4VMe91waPKSmxx
         FqkZSXR8G8Xt2nwFm/rklnW2brEUYGZMlKbN3nvNYJ/8uY6j1g8fa6yqIDodbrHRly5f
         43dRiw8pDimH9R5tIcWuRuTKUpPtCNhbHYaJBuRocZjL1mKhUoerx+4LhpMeOeFkL+MP
         GC8Q2+LvUftVI3F0TqXpHJcCROLXQwUEpa9wKsyFNx0BM1TV3/GnDN6aMShGRgvO7Au4
         oRdKRNYhWe7SgQgXapvWcCmla4uV5Az644f4sF6Kte5Zmxypj+Pk4f28TFit4t8wG8U2
         MSXg==
X-Forwarded-Encrypted: i=1; AJvYcCWI0D55dDiUBL6Gu4syxPfnq06YoK3cbv7Y9cHnM/mcvlXf9NGmZgbGLyeqr2/R2MSobUoLQChTfCAYst3agnuWnXsS+Wpx
X-Gm-Message-State: AOJu0Yyz4gtTf8h3qNKFrAdyseuLwxmcRa0VPhLozxv+22MLrm7aQRnF
	x+7z7gv0MaUEWtmQWfpwjzl2k7HOhGnF4FeN9BC/rAIqu3XVhrk4t88yUc7fdCNdAXMP4s2rAKR
	VZ+Bjs2paJhoZvcC+SbYr1+xcIDY8g1HGNEB/QsWZr5yxDmtvddGdHw==
X-Received: by 2002:a05:620a:992:b0:78e:e479:3ddb with SMTP id x18-20020a05620a099200b0078ee4793ddbmr2394300qkx.23.1714128599081;
        Fri, 26 Apr 2024 03:49:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHh18C4THl4Xonjz0GTh9Qrl3LA0jHHF1NCbVJUxnZ8bmimP/NV7dkk5fFTYl157a5HGhORJQ==
X-Received: by 2002:a05:620a:992:b0:78e:e479:3ddb with SMTP id x18-20020a05620a099200b0078ee4793ddbmr2394272qkx.23.1714128598452;
        Fri, 26 Apr 2024 03:49:58 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id vv26-20020a05620a563a00b007907b57aa1fsm3888019qkn.12.2024.04.26.03.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 03:49:58 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 2/6] KVM: arm64: unify trap setup code
Date: Fri, 26 Apr 2024 12:49:46 +0200
Message-ID: <20240426104950.7382-3-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240426104950.7382-1-sebott@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com>
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

There are 2 functions to set up traps via HCR_EL2:
* kvm_init_sysreg() called via KVM_RUN (before the 1st run or when
  the pid changes)
* vcpu_reset_hcr() called via KVM_ARM_VCPU_INIT

To unify these 2 and to support traps that are dependent on the
ID register configuration, move vcpu_reset_hcr() to sys_regs.c
and call it via kvm_init_sysreg().

While at it rename kvm_init_sysreg() to kvm_setup_traps() to
better reflect what it's doing.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 37 -----------------------
 arch/arm64/include/asm/kvm_host.h    |  2 +-
 arch/arm64/kvm/arm.c                 |  3 +-
 arch/arm64/kvm/sys_regs.c            | 44 ++++++++++++++++++++++++++--
 4 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 975af30af31f..9e71fcbb033d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -67,43 +67,6 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 }
 #endif
 
-static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
-	if (has_vhe() || has_hvhe())
-		vcpu->arch.hcr_el2 |= HCR_E2H;
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
-		/* route synchronous external abort exceptions to EL2 */
-		vcpu->arch.hcr_el2 |= HCR_TEA;
-		/* trap error record accesses */
-		vcpu->arch.hcr_el2 |= HCR_TERR;
-	}
-
-	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
-		vcpu->arch.hcr_el2 |= HCR_FWB;
-	} else {
-		/*
-		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
-		 * get set in SCTLR_EL1 such that we can detect when the guest
-		 * MMU gets turned on and do the necessary cache maintenance
-		 * then.
-		 */
-		vcpu->arch.hcr_el2 |= HCR_TVM;
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
-}
-
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu->arch.hcr_el2;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8a496fb284..696acba883c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1115,7 +1115,7 @@ int __init populate_nv_trap_config(void);
 bool lock_all_vcpus(struct kvm *kvm);
 void unlock_all_vcpus(struct kvm *kvm);
 
-void kvm_init_sysreg(struct kvm_vcpu *);
+void kvm_setup_traps(struct kvm_vcpu *);
 
 /* MMIO helpers */
 void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c4a0a35e02c7..d6c27d8a8f2f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -683,7 +683,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	 * This needs to happen after NV has imposed its own restrictions on
 	 * the feature set
 	 */
-	kvm_init_sysreg(vcpu);
+	kvm_setup_traps(vcpu);
 
 	ret = kvm_timer_enable(vcpu);
 	if (ret)
@@ -1438,7 +1438,6 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 			icache_inval_all_pou();
 	}
 
-	vcpu_reset_hcr(vcpu);
 	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 131f5b0ca2b9..ac366d0b614a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4020,11 +4020,43 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
 	return 0;
 }
 
-void kvm_init_sysreg(struct kvm_vcpu *vcpu)
+static void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	mutex_lock(&kvm->arch.config_lock);
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+	if (has_vhe() || has_hvhe())
+		vcpu->arch.hcr_el2 |= HCR_E2H;
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
+		vcpu->arch.hcr_el2 |= HCR_FWB;
+	} else {
+		/*
+		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
+		 * get set in SCTLR_EL1 such that we can detect when the guest
+		 * MMU gets turned on and do the necessary cache maintenance
+		 * then.
+		 */
+		vcpu->arch.hcr_el2 |= HCR_TVM;
+	}
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
@@ -4033,6 +4065,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
+}
+
+void kvm_setup_traps(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->arch.config_lock);
+	vcpu_reset_hcr(vcpu);
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
 		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
-- 
2.42.0

