Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7D41FA85F
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 10:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407937; cv=none; b=Tlyk/RtX2eN6O5AnzfbG3+iwYFacCp+w6kgVYxbMv/XP7u+cRP6IKeKFjClASDGEvcSTPZ+AK7EBEvo6Sci+Qcz0fRBrBdLAl0QbMjaBQ/R6s6fnnxqGiiQXr66laeCOz1t7IaYOjmSevFHHFNEKJmU5MmAh5x6SKxN4r9/Sn9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407937; c=relaxed/simple;
	bh=gJX4fpAnmRlIzwVuBDoaMY8pi4WArGBc4Po0d2y33so=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EEYHOe72PZJYW1fNOGCDs4gjhI2e4rCMnTASquPPOg33gFsTy7Z+mUeLgx9Ekc+Mm0AyMpNjGmvsQiCzpoT37rOxWsGzqbBdkSS/opBq3gVl5Si6dn8ZrLYN08h6UPql2cbBYnHZqb/ueCASzj1vkqyaaIIPiUbrAbTRcqmvvOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vqIk2C6N; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vqIk2C6N"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37d4821e6b4so3887443f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 02:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731407934; x=1732012734; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4Y12830R+W7ydXEFfviSLc+JWTSWnSDcOvb7pMp1YA=;
        b=vqIk2C6NnsxUHc6rjZPKbrq/qzPQkPOlbSHX2xfG7XZ2DQxVsfzdwzgGue5mwTDjx7
         4h/8gTBgqOD1+zolYDnsiMBVMWT6TUzGCegqfI/HkWbtpsnLAf0/mXWlhtUTvXKZHFKm
         c3SGjc9FqZVMwRsk21w+v0XvpP6QX0gJ0q7S/QV1uLco5q4RZBEODFupSyAPT76XakBp
         SagluZAf9KL1eOOdrT+EmTGq7VUEW8PFxfq1FZAvKQgZw22XYQo1mC/rgRVA5GwiGnsI
         kLfKd/Uc8Y3RU/zMr2pEKQnJ0/HtMU/p+418QrffFswazPWJy7fSAIQIKxfN512rBxeR
         WJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407934; x=1732012734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w4Y12830R+W7ydXEFfviSLc+JWTSWnSDcOvb7pMp1YA=;
        b=QC/QD57rFuxM4JEImU8BxifJWgT13rpiVqdN+TPiZvVxkroxi6PhD85fBJlUgnL35Q
         XGwB+q8kyizHdf+zWN2BDWSrlsOIXZZ6fwS82g1D3zhPDdZ40vQdPRBjju2gq2G4iVwz
         plKnN4ig8MR75wAGutHnOvOMhy/fzHgaIaR7e1oIdYyhI4siZukJsUXifc0ipiJvFEpF
         OjRib+F9Lgnore7O4214GTXCb4Lrtx0+BF7ifZM3P0DgkdGqO23ua932TEFjTyExggaf
         EHI3pahoUqt7Jjlc36HilHZNsHcAhyNMjUUD++kM89+8qHAY4E6chxXg6i3vUTOHDb2R
         oC/w==
X-Forwarded-Encrypted: i=1; AJvYcCUUF/scF8bw1HPcy+YlshJC821f6c/usMecl2gUwXxRiDhzFagxwISK1JwpdKDvdnggkdook+A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwoYpkm4JL7MQt0J6gJo28991UXP7Bf8ckqsgbFpSPDcn4UIy0h
	JkS05EFNyHslGpCLHCpc+OV+HdPrnmcfSXAhK8wglVLr3aU86He9pzydX3HDZqI=
X-Google-Smtp-Source: AGHT+IFFrkKNgQSMLjx9o9fyzR37XC2Gr6CvPJDOYVlojhp8ArNiU1b7bN0q0qpEMeG5HrMUFygnww==
X-Received: by 2002:a5d:6c64:0:b0:37d:4a82:6412 with SMTP id ffacd0b85a97d-381f1885db0mr12627127f8f.46.1731407933761;
        Tue, 12 Nov 2024 02:38:53 -0800 (PST)
Received: from pop-os.. ([145.224.90.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bbf436ffsm142270955e9.44.2024.11.12.02.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 02:38:53 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	coresight@lists.linaro.org,
	kvmarm@lists.linux.dev
Cc: James Clark <james.clark@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 10/12] KVM: arm64: Don't hit sysregs to see if TRBE is enabled or not
Date: Tue, 12 Nov 2024 10:37:09 +0000
Message-Id: <20241112103717.589952-11-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112103717.589952-1-james.clark@linaro.org>
References: <20241112103717.589952-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the driver tells us whether TRBE was used or not we can use
that. Except in pKVM where the host isn't trusted we keep the existing
feature + sysreg check.

Now in the normal nVHE case, TRBE save and restore are gated by flag
checks on kvm_host_data.

Instead of using a magic value of host_debug_state.trfcr_el1 to
determine whether to restore, add a flag. This will also simplify the
logic in the next commit where restoration but no disabling is required.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h  |  2 ++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 51 +++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b1dccac996a6..a8846689512b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -947,6 +947,8 @@ struct kvm_vcpu_arch {
 #define HOST_STATE_SPE_EN	__kvm_single_flag(state, BIT(0))
 /* TRBLIMITR_EL1_E is set (TRBE trace buffer enabled) */
 #define HOST_STATE_TRBE_EN	__kvm_single_flag(state, BIT(1))
+/* Hyp modified TRFCR */
+#define HOST_STATE_RESTORE_TRFCR __kvm_single_flag(state, BIT(2))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 578c549af3c6..17c23e52f5f4 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -63,32 +63,55 @@ static void __debug_restore_spe(void)
 	*host_data_ptr(host_debug_state.pmscr_el1) = 0;
 }
 
-static void __debug_save_trace(u64 *trfcr_el1)
+static bool __debug_should_save_trace(void)
 {
-	*trfcr_el1 = 0;
+	/* pKVM reads the state for itself rather than trusting the host */
+	if (unlikely(is_protected_kvm_enabled())) {
+		/* Always disable any trace regardless of TRBE */
+		if (read_sysreg_el1(SYS_TRFCR) &
+		    (TRFCR_ELx_E0TRE | TRFCR_ELx_ExTRE))
+			return true;
+
+		/*
+		 * Trace could already be disabled but TRBE buffer
+		 * might still need to be drained if it was in use.
+		 */
+		if (host_data_get_flag(HOST_FEAT_HAS_TRBE))
+			return read_sysreg_s(SYS_TRBLIMITR_EL1) &
+			       TRBLIMITR_EL1_E;
+	}
+
+	return host_data_get_flag(HOST_STATE_TRBE_EN);
+}
 
-	/* Check if the TRBE is enabled */
-	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
-		return;
+static void __debug_save_trace(void)
+{
 	/*
 	 * Prohibit trace generation while we are in guest.
 	 * Since access to TRFCR_EL1 is trapped, the guest can't
 	 * modify the filtering set by the host.
 	 */
-	*trfcr_el1 = read_sysreg_el1(SYS_TRFCR);
+	*host_data_ptr(host_debug_state.trfcr_el1) = read_sysreg_el1(SYS_TRFCR);
 	write_sysreg_el1(0, SYS_TRFCR);
 	isb();
 	/* Drain the trace buffer to memory */
 	tsb_csync();
+
+	host_data_set_flag(HOST_STATE_RESTORE_TRFCR);
 }
 
-static void __debug_restore_trace(u64 trfcr_el1)
+static void __debug_restore_trace(void)
 {
-	if (!trfcr_el1)
+	u64 trfcr_el1;
+
+	if (!host_data_get_flag(HOST_STATE_RESTORE_TRFCR))
 		return;
 
 	/* Restore trace filter controls */
+	trfcr_el1 = *host_data_ptr(host_debug_state.trfcr_el1);
+	*host_data_ptr(host_debug_state.trfcr_el1) = read_sysreg_el1(SYS_TRFCR);
 	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
+	host_data_clear_flag(HOST_STATE_RESTORE_TRFCR);
 }
 
 void __debug_save_host_buffers_nvhe(void)
@@ -97,9 +120,14 @@ void __debug_save_host_buffers_nvhe(void)
 	if (__debug_spe_enabled())
 		__debug_save_spe();
 
+	/* Any trace filtering requires TRFCR register */
+	if (!host_data_get_flag(HOST_FEAT_HAS_TRF))
+		return;
+
 	/* Disable and flush Self-Hosted Trace generation */
-	if (host_data_get_flag(HOST_FEAT_HAS_TRBE))
-		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
+	if (__debug_should_save_trace())
+		__debug_save_trace();
+
 }
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -110,8 +138,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	__debug_restore_spe();
-	if (host_data_get_flag(HOST_FEAT_HAS_TRBE))
-		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
+	__debug_restore_trace();
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
-- 
2.34.1

