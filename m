Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3555116E887
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901172; cv=none; b=H8M0VzMhMply7TEfv37fZDjA9+9AUWHd83wjScpJ7kRJPGExGYyQjc5bEALOWXz06kH5fiw9Jmk2mkv6/dJJJ44QguAnomys7R5FP2+8VCo2NcS9E8xHgiq24y6VdAs6YLdFIx5hO8F6hQZTbNyKThjIA2awjtlwLoeiDdbFBvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901172; c=relaxed/simple;
	bh=XV45IB2kgzVgcTEpQvbJ9wdJviIV+3jlfgYHR7h0J/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QIw4bh0Q/XEn7ec/0uqm4Pjnhn6OG6U0DbQbkM1OoW0p48wLFOFgz2BS85YIZ4wd2iKipdlPEJQwee32f1wiKgJ3LJy/RCFD/MHj+6d94eS7YCMTG/NN063Wio+bC8sTB0KCfNDjNG2OnnEEYln+THrfHOslfuNnXjHx7v7qkN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x2Iou4x5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x2Iou4x5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-42108822a8eso17421545e9.0
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901168; x=1717505968; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5sc8KUFKfboQi4h1WzkkHS0ylfTVYxfw83Z1i3NTag=;
        b=x2Iou4x5LVah0wq+vkjuCrxPmPEwhuxCZyQ80w6w9nyh2Nvg08FBH/1LmcfCs1bcJX
         tLJMGmEO/B+D8hfGLJnYurfms5e+BfGrubv/WWEGGsyLLmy1Uw+DoL/dBDmAQThGXrb1
         XUPaBjJnuc5ghiQ1hrOhIscbiW2wzVJItMqjibToSrGKm1stuAdPxZH1nwFor8OB4BHK
         m0tlZ//o5lBo+FUV7NfZWJIc64RyZwsoUP09ASrLzrhpF7Up4iRb/TtdRdks/Q1EWFCw
         FfBlmz79PWknDG/LS97YYJShqzQEC4FxsrOPyQNQTfP69Y6ip2IN/TrYzp3QrJWICyWN
         rDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901168; x=1717505968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P5sc8KUFKfboQi4h1WzkkHS0ylfTVYxfw83Z1i3NTag=;
        b=YHze1PpFj6GSFDZpuhQtqI7VJ9wMTvrO6carU2UczlkWqOn4CXYUlFQ467cyfgP3aC
         ISNnnbeJf+qpREC80p04GRNgq28x9ibuYzkjaLzOCwPQW5ujuteiWA+Am7SxZzOa+tMx
         BiOlrMw1bPA0WTmhedTChK2HW+iuB1ZKkbl2jO2B/QP3av3Pfv+QcwJitad+lVNo+8sz
         YenR+R9OOynid52Afr2cmEa/KEHGN0QVt9hm+tGMEB9rEvx4qpoIEovcA7QVLwV3LYUM
         PF85Ym1vCBO6jf6xA1ByfmhY84H/UQ/aW2zA1RGr/7CTXlFo4JvRRuVAbVroXUDL9QXh
         AHkA==
X-Gm-Message-State: AOJu0YwJLbh/MQFmn4H1Nmx8ja02z9OmbAiPixa/oKRpdeBTiKyXF8UM
	zy2h2OW5UXRQFv6n7pUTNUjXtdZ5uLeGSgEu7goFTafG5/GJzQGDGFpVTUMwaeDA8SbSKWMMLZO
	QAdbXLkDvoBDuc4BaWqYTIZW55kHMqPMrg4Q7EBb7tWF6Yid95xNnD+HB2rBj/VziXRQquvzSH6
	75uXcM2RfrmmlmeCXMH6/JiqKta7Y=
X-Google-Smtp-Source: AGHT+IFiwfSOYOPKUhpIMADgtckNl7QyiNv7yek943SC81Qp1wNAapp+xVORVv/TO9Ox6Jp1ed4+3UuuXg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1390:b0:41f:acbd:d10 with SMTP id
 5b1f17b1804b1-421081a2580mr2540845e9.1.1716901168549; Tue, 28 May 2024
 05:59:28 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:08 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-6-tabba@google.com>
Subject: [PATCH v3 05/11] KVM: arm64: Eagerly restore host fpsimd/sve state in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

When running in protected mode we don't want to leak protected
guest state to the host, including whether a guest has used
fpsimd/sve. Therefore, eagerly restore the host state on guest
exit when running in protected mode, which happens only if the
guest has used fpsimd/sve.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 67 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +
 arch/arm64/kvm/hyp/nvhe/switch.c        | 16 +++++-
 4 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d3a3f1cee668..89c52b59d2a9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -320,6 +320,17 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
+static inline void __hyp_sve_save_host(void)
+{
+	struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
+
+	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	isb();
+	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+			 &sve_state->fpsr);
+}
+
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
 
 /*
@@ -354,7 +365,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Valid trap.  Switch the context: */
 
 	/* First disable enough traps to allow us to update the registers */
-	if (sve_guest)
+	if (sve_guest || (is_protected_kvm_enabled() && system_supports_sve()))
 		cpacr_clear_set(0, CPACR_ELx_FPEN|CPACR_ELx_ZEN);
 	else
 		cpacr_clear_set(0, CPACR_ELx_FPEN);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f71394d0e32a..1088b0bd3cc5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -23,20 +23,80 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
+{
+	__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+	/*
+	 * On saving/restoring guest sve state, always use the maximum VL for
+	 * the guest. The layout of the data when saving the sve state depends
+	 * on the VL, so use a consistent (i.e., the maximum) guest VL.
+	 */
+	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	isb();
+	__sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fpsr);
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+}
+
+static void __hyp_sve_restore_host(void)
+{
+	struct cpu_sve_state *sve_state = *host_data_ptr(sve_state);
+
+	/*
+	 * On saving/restoring host sve state, always use the maximum VL for
+	 * the host. The layout of the data when saving the sve state depends
+	 * on the VL, so use a consistent (i.e., the maximum) host VL.
+	 *
+	 * Setting ZCR_EL2 to ZCR_ELx_LEN_MASK sets the effective length
+	 * supported by the system (or limited at EL3).
+	 */
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+	isb();
+	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+			    &sve_state->fpsr);
+	write_sysreg_el1(sve_state->zcr_el1, SYS_ZCR);
+}
+
+static void fpsimd_sve_flush(void)
+{
+	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+}
+
+static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
+{
+	if (!guest_owns_fp_regs())
+		return;
+
+	cpacr_clear_set(0, CPACR_ELx_FPEN|CPACR_ELx_ZEN);
+	isb();
+
+	if (vcpu_has_sve(vcpu))
+		__hyp_sve_save_guest(vcpu);
+	else
+		__fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
+
+	if (system_supports_sve())
+		__hyp_sve_restore_host();
+	else
+		__fpsimd_restore_state(*host_data_ptr(fpsimd_state));
+
+	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
+}
+
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 
+	fpsimd_sve_flush();
+
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
 	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
-	hyp_vcpu->vcpu.arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;
+	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
 	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
-	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 
@@ -54,10 +114,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
 	unsigned int i;
 
+	fpsimd_sve_sync(&hyp_vcpu->vcpu);
+
 	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
 
 	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
-	host_vcpu->arch.cptr_el2	= hyp_vcpu->vcpu.arch.cptr_el2;
 
 	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 25e9a94f6d76..feb27b4ce459 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -588,6 +588,8 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	if (ret)
 		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
 
+	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 019f863922fa..bef74de7065b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -184,7 +184,21 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
-	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+	/*
+	 * Non-protected kvm relies on the host restoring its sve state.
+	 * Protected kvm restores the host's sve state as not to reveal that
+	 * fpsimd was used by a guest nor leak upper sve bits.
+	 */
+	if (unlikely(is_protected_kvm_enabled() && system_supports_sve())) {
+		__hyp_sve_save_host();
+
+		/* Re-enable SVE traps if not supported for the guest vcpu. */
+		if (!vcpu_has_sve(vcpu))
+			cpacr_clear_set(CPACR_ELx_ZEN, 0);
+
+	} else {
+		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+	}
 }
 
 static const exit_handler_fn hyp_exit_handlers[] = {
-- 
2.45.1.288.g0e0cd299f1-goog

