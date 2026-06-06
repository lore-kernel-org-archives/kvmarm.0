Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A0F27AC4C
	for <kvmarm@lists.linux.dev>; Sat,  6 Jun 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780768643; cv=none; b=o7+MwTJ0pWphLmRXBkVJjBZhGVs+Rwz1M0kZQfw4xW3HCmyic2rnqJSa8VdHu2HaD+NKk0pNiVBxdRNYF8fdt1tlcYMsj43gbja452f2g/LAavDgprtW0P/ogzEiCPfsK5eeUxQch96x2z7urxq7neIfexfaaiMYKwkS7+FZPKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780768643; c=relaxed/simple;
	bh=GMITEpPOTtrYf7ZhiUASmEirKqHeY2hDHERiaSomMK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrkSbxQolQI6RQDjK55ca4rGSeFikMiS5YF21ZDIrTrUM2g+7/dXklRWYjLvpPD2+mBE3AktZXo94AIvXutRo4RiFRTnWXZqfrY9O3VkF29eGWJnHmY1ZGaFcKmv3EAi62ejKQy00KE1UjQovitptDocjiAjlkaTu14kCRYRXAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+/UY0S+; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+/UY0S+"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c168baac83so13914375ad.2
        for <kvmarm@lists.linux.dev>; Sat, 06 Jun 2026 10:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780768641; x=1781373441; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmWKsP5LOKB/Z4KYBnWg/ptdbuVXbRt6wtHayHObrME=;
        b=D+/UY0S+OkFj66Ptu7FUctadS4/Z73AXsqpiQEEr8qz1xMqI9bt8nPnW91J5K4P0Lb
         KGn+1HcMnDrIUWXk3FuUDVvnlRNJQs3ratdUxoZNg7NFmFPotrG1Dl5WX7t47xSVqlft
         Lba5Pv1rvL1nXmfA8eRQJeUDrmuySwHkM9QJdZiqN8Rc+BYJn5A0s5UhgAvx+3TWDZOv
         7939dnK0gNwgIIa7VT0fMRg6G/E7dchZK47K73IdGsKnfXCjaukU9dRLcrAqRDNAG0d2
         tnR85dvkw0ScOeCjRVxID230kgPyUc9X7SKWayrYUJHfgPwBXrnuYyYzkw3Y+zlo/3yC
         IGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780768641; x=1781373441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KmWKsP5LOKB/Z4KYBnWg/ptdbuVXbRt6wtHayHObrME=;
        b=gY9h9We2rv7t/ZiWLFjJjL/kFNxRBXUGC3oMeO7txIC6YnxdFBySaCUqhoB/v2vWoq
         uFox8cgv2iFelpiuAh2P7GUu/BZ5dLH1fb022uXFsklpuOqE2tctJdFc7aiQiFSUwOqW
         GYMhriU+OZNwOxowOw2qXnXBp0ywJ4NsDPAZYTmXLmyhv+ynsHQa5R/xapBaXKjZUgTA
         8yaoH8VD46sEemMl4vKSqm2njE/E9stUhlabaOaFWoVFsGSsg+DgrOqpfurHhvMz82NE
         lhegNkpOqDEvFIQBRfund3oUiY7vhX2fp0MGUonsQ/macqrX6WNwtPGwYA9+8lgMyNri
         dxJg==
X-Forwarded-Encrypted: i=1; AFNElJ976LFCOGjg158CjGgSMA+gPNWNNmhX2v/sogH7qP6lRZG4k3ZcNxdcQ0qRl3sDHJRiHr+pYjs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaCdSf8jmPLJNp5FmhvtX7u03TjncgA4f7lY72OXtBFWJDv4VD
	eROANea8UErk55w78Hf933/cwxKDzCVHXmvGqmLvz276rXKrASswchgt
X-Gm-Gg: Acq92OF22FBHZsAAx7X7nGz7MCGsHJIAstetAeVO1szyi62kcKmh0z4Fv3FXNidbCJ+
	jcmZmX6P3gdV8mrpzZp1fo9HJEr8w8YtRBS0jXKpZAFrmGzgQuy/rgylhlZv9+P3JxGwCO79iUj
	tl0OSit9Yj1I7r+1WUkJIZkf86CoFShxWtIsUKTrzS3gphSnofesII+Q6gbvnIhAJ8rb9FdAU0P
	ZskKAyenojMdeR0sbsa0xovCcaJggArNlBdbRwBvV29BnmAVc6CW2UjLh9IUZ6uIazAKHP1EAYx
	WTFjp4SkYg+8gbOZbWq7XhWzjluAvGhbcADtBhGftIdNs5yRFGNJW56qlXWYO98Co9FIhM5TN+I
	JVwdkUrNRmo7B2hHfPbTd13DLGiS2CcrIbwj9QfEZ9Q7XkSuFpYLLoMCUcxrQ6c7U5RUF6tdDXB
	YK1BfOGRhpGSDktofaTviiGsOlfFwzOWS2azBcWg3/Ri2k2S1yCsSw/SNe
X-Received: by 2002:a17:902:e848:b0:2c0:b6c7:2273 with SMTP id d9443c01a7336-2c1e79e29ebmr105792125ad.3.1780768641180;
        Sat, 06 Jun 2026 10:57:21 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d69csm129196425ad.2.2026.06.06.10.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 10:57:19 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: tabba@google.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	stable@vger.kernel.org,
	imv4bel@gmail.com
Subject: [PATCH v3 2/2] KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU
Date: Sun,  7 Jun 2026 02:56:11 +0900
Message-ID: <20260606175614.83273-3-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260606175614.83273-1-imv4bel@gmail.com>
References: <20260606175614.83273-1-imv4bel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies the host vGIC state into the hyp's private vCPU
on every run. The vGIC list register save and restore use used_lrs as
their loop bound and expect it to stay within the number of implemented
list registers. While this is generally the case, flush_hyp_vcpu()
copies vgic_v3 verbatim and does not enforce this, so a value provided
by the host is used at EL2 to index vgic_lr[] and access ICH_LR<n>_EL2
(host -> EL2).

Fix by clamping used_lrs to the number of implemented list registers
after the copy, as the trusted path already does in
vgic_flush_lr_state(). The number of implemented list registers is
constant after init, so it is replicated once from
kvm_vgic_global_state.nr_lr into hyp_gicv3_nr_lr rather than read on
every entry.

Cc: stable@vger.kernel.org
Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 9 +++++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 8d06b62e7188..e9b2b0c40ec6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -157,5 +157,6 @@ extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
 extern unsigned long kvm_nvhe_sym(hyp_nr_cpus);
+extern unsigned int kvm_nvhe_sym(hyp_gicv3_nr_lr);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9453321ef8c6..9ffd5d4079e6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2426,6 +2426,8 @@ static int __init init_subsystems(void)
 	switch (err) {
 	case 0:
 		vgic_present = true;
+		if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+			kvm_nvhe_sym(hyp_gicv3_nr_lr) = kvm_vgic_global_state.nr_lr;
 		break;
 	case -ENODEV:
 	case -ENXIO:
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 02c5d6e5abcb..a0da08caa6c2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -24,6 +24,9 @@
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+/* Number of implemented GICv3 LRs. Used by flush_hyp_vcpu(). */
+unsigned int hyp_gicv3_nr_lr;
+
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
@@ -142,6 +145,12 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
 
+	/* Bound used_lrs by the number of implemented list registers. */
+	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
+		min_t(unsigned int,
+		      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
+		      hyp_gicv3_nr_lr);
+
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }
 
-- 
2.43.0

