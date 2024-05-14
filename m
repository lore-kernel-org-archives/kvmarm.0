Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D00410949
	for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 07:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715672349; cv=none; b=u7WToi1AgheEzalwyfNToeZMJaqkQnKTjYJ/AAweIi6zbKYYgm3ZCKza5Jyql5CJXlQ4QrfJDEXSyKTGDdy9Xo257my+elXKoEdJYGZZbATSJ09Dwu5TvoX6wq55OqJ5ap6gFCVa7wD0GdJ95Unhp/ytznlVFM8XehjQtTYmLac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715672349; c=relaxed/simple;
	bh=SplUyiceO33acZVUSNIv+R1LEcFl7TGSw9aJpGoYgm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nOidheX3003hmC/73ZFMuf43qDlRE3ruWMfuJ8zWUiA+CwDzhJT7T5VtUEUAc27PANGKNQD7n6tzTQCNCgHPGaw/a4aqt3irQzn39snH929JL1E0yyjhtrccXCbvCGcnmL2bBHe4ghV2m6BxXweNLi7K4W2TteW0cpZjBG1IzUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0JAU0Lm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0JAU0Lm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715672347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rb7KafJV7I3Bq8cEiRTMNitbrzaJJX9E0+TIJqM8O5c=;
	b=K0JAU0LmygDYLeLlSlNwd63Jr6APX/bYiCJMDs4JBdkd6IR6RAy1F9glmx+fdJNxmJ10H4
	TMy+fBDRwkDWpneytIwKasupTbcrBBLg1Gp1GPgTPLvH4UpTc2kJ1WcJPMTgut2F8W2xUr
	sTZTDZWYroMxm7jw+rIyW8pdQ28ufk8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-uriD1FPrP42Y-MJmLKbLcg-1; Tue, 14 May 2024 03:23:00 -0400
X-MC-Unique: uriD1FPrP42Y-MJmLKbLcg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6a0e10bddd6so64299146d6.3
        for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 00:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715671380; x=1716276180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rb7KafJV7I3Bq8cEiRTMNitbrzaJJX9E0+TIJqM8O5c=;
        b=EYxOnwnLI71HujNkOS47fuE8h/4jVRw57DQ8akBn+QkSPQgwF8Qi2Zxh4XRJGtRHWX
         QXtEhQtOjZ7+RpIDRk/00WPD2QcJwz6fltJRarY3qyV2G6ouQICeVlS97an+lpHKsdJ+
         hnyXlIqjjjZ7XixjblwWH0uz9GSs/DyHLhVchONgMN/pBa53D78He2eLXrkLyToxkUp2
         nlxysTiwoEDvvJ3sMxRwRduSieR+HiZ4Fp52+8cWuCXBUB66OwaB4k35cUHDBn+Rn3Mg
         Hj+4BuFS4xKhSzEauamvPFUK/3cMeNpw7r2ABzuzUeU8E0oVzXJitgi1go4xwG93eF+5
         /ghQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzyACO5PoT6HJRU2kBle8CTkYWXrUyRXAeDnXuL6lknc0Jyb6XzbVftDQME99hB5/Od91pZucQQQ5Xp2OkQCFilu1kfVVo
X-Gm-Message-State: AOJu0YynqVG7RESCbCcDphws2L4BgQ7JjA8J3l3BJ0y1KKKJ1d1i8XIX
	EDZD2FYItFKYYN3FD59psCJwiZjMwquV/BLaSsdPX8CM27ffPz7xqMo1iOMd4VnoNVdOBdV1xQ9
	tWxJstLFfnFW0GjhIxS7WRCXokb9U0/ewq62OtNm0jRI46ovRMBt1Iw==
X-Received: by 2002:a05:6214:5b81:b0:6a0:c151:6283 with SMTP id 6a1803df08f44-6a16838986fmr165997576d6.56.1715671379873;
        Tue, 14 May 2024 00:22:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdX4p3qfLGGnIV/WfSKOJPR1Byzbb/+g2h6nrg91L5/ZNPPFTPTSZHsAztlmX12uE60Uj70Q==
X-Received: by 2002:a05:6214:5b81:b0:6a0:c151:6283 with SMTP id 6a1803df08f44-6a16838986fmr165997406d6.56.1715671379502;
        Tue, 14 May 2024 00:22:59 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f1ccd4esm50917516d6.97.2024.05.14.00.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 00:22:58 -0700 (PDT)
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
Subject: [PATCH v3 1/6] KVM: arm64: unify code to prepare traps
Date: Tue, 14 May 2024 09:22:47 +0200
Message-ID: <20240514072252.5657-2-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514072252.5657-1-sebott@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com>
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

