Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF65E3A0E80
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 10:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776160975; cv=none; b=XjsY51NjLLxF4aTI0YTat1Nlrl31Zh+VfgPU8mCFOy6St4ayQ/sGAgmm1FJtZtU3ELDT86nu0McZdlo4j1KxPTl93KiB3OnRnejTFRkIrxqMnwxTlOHm9pfdJcYH+tmMX9MIoz4NpFK5r5GTL5L2Dk6V4FiNZM5S2058gMPU3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776160975; c=relaxed/simple;
	bh=Fipu4py3Lmo1LUhbj/6FFo4GYAPBgvoKv/dPWZj8JXA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ARjxHDkmbY/kAe+JZe8wrTAu3MaNrhaCSOqJoReygkMoiCtczwSZX2H3pcNAICLpZkENqW+Gvx9gohrXdMPN4eHgiGkq1N93ES90Tpvz2e6eFebo2HwrbbK4AAK2qRaO0JlcWB64zTl1cAe8paIoTL4KsAJpFjR1wbjgyHTv5tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OAhjmHLY; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OAhjmHLY"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso1237174f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 03:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776160972; x=1776765772; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=muj4NuOpuZ8hBEE3iFtHY9kZtKoXKHThzny53jznPvI=;
        b=OAhjmHLY6ZFSwDVkZgP0LLCXcmxSB4Vs01O05x2BeaPtA9haxtqVhmdkgt4KxsJ9Rl
         USY1IPlHChnUTWutO7pq3GZ3Oiq28ie6dDI0VH4AAS8eAqwl8ZLYRfeNbf2wiJCt/Rzc
         3jUFttYt55x0IY7P4fCDFLFlh+g5893mxSZMVmXjBKxUZwkNCerdkTUtX7faS1Z949Lc
         by85nUgBm2XGmg9y3J6JCWe+VoRRgK8h0p3AtHKIIvWOInmx7x+pK9Rqt29wx4Ci5BvY
         WdlMJ8LNDcdyiwg3nF7fvTYZJvtTZ76h90nuCcciqqtfWQGA0UHLXOlNzf3NbaI2nO77
         GOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776160972; x=1776765772;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=muj4NuOpuZ8hBEE3iFtHY9kZtKoXKHThzny53jznPvI=;
        b=nifrzLJIho406FcRaiheTxGSxtu40+uKp1wtoNWtTVMigBOF+KT2yGqo+b3NuDbi38
         BPuGNqgDg5zS8wh6BO7VrxdGjZx5FWpJB7FkxV1zGVGY7o15zFBMYZTh8iO6orHG1I5U
         MobEpyyMkhK4j55o04yv8FsFqUn3e60C/9IZCjTGQ27vkmVkEBOa8qdcsPc6qXv7d/33
         Fo0IV9OgXLdsIc47054DnvFQNv8ozvuhZdUFaeLV2RCrTk9TpHIS7+9D9D+RkYbAD1ft
         pwpq16NR6lKUeHuOyUtA+3qkMPqxwa9g9mXilT8IR0dG8BxeK+8JRewbG8Y9BcMQXU6K
         XSsg==
X-Forwarded-Encrypted: i=1; AFNElJ/lTew38kNu/xKx/qYU2UQlezus/UGrEqNQdzyOskqWPyuX3P/R569NUZqk02Yd5H/VN4M/8cQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwetquCxKmCmwOie1/gc1PMHmWaep2KVhrvBPHBvunwA236jHbw
	/JDaUH0KHTpjapmhbiM+83B6Ak3aS9XRBFJrulP/mPniZM7CEAbgYUbW1XQE1SjwHiYwXLjR/sc
	4UwfdrIDPvnPHrf2+Aw/DGg==
X-Received: from wmqy6.prod.google.com ([2002:a05:600c:3646:b0:488:7f5c:7693])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:674f:b0:488:a82f:bb9b with SMTP id 5b1f17b1804b1-488d68cb47amr244321275e9.30.1776160971924;
 Tue, 14 Apr 2026 03:02:51 -0700 (PDT)
Date: Tue, 14 Apr 2026 11:02:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260414100231.1859687-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Re-allow hyp tracing HVCs for [nh]VHE
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The introduction of __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM excluded hyp
tracing HVCs from the common [nh]VHE/pKVM list. Re-allow them.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 37414440cee7..11dcdf434971 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -72,6 +72,14 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
+	__KVM_HOST_SMCCC_FUNC___tracing_load,
+	__KVM_HOST_SMCCC_FUNC___tracing_unload,
+	__KVM_HOST_SMCCC_FUNC___tracing_enable,
+	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
+	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
+	__KVM_HOST_SMCCC_FUNC___tracing_reset,
+	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
+	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
@@ -100,14 +108,6 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
-	__KVM_HOST_SMCCC_FUNC___tracing_load,
-	__KVM_HOST_SMCCC_FUNC___tracing_unload,
-	__KVM_HOST_SMCCC_FUNC___tracing_enable,
-	__KVM_HOST_SMCCC_FUNC___tracing_swap_reader,
-	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
-	__KVM_HOST_SMCCC_FUNC___tracing_reset,
-	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
-	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 73f2e0221e70..8f7582d57ab5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -709,6 +709,14 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
+	HANDLE_FUNC(__tracing_load),
+	HANDLE_FUNC(__tracing_unload),
+	HANDLE_FUNC(__tracing_enable),
+	HANDLE_FUNC(__tracing_swap_reader),
+	HANDLE_FUNC(__tracing_update_clock),
+	HANDLE_FUNC(__tracing_reset),
+	HANDLE_FUNC(__tracing_enable_event),
+	HANDLE_FUNC(__tracing_write_event),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_save_apr),
@@ -735,14 +743,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
-	HANDLE_FUNC(__tracing_load),
-	HANDLE_FUNC(__tracing_unload),
-	HANDLE_FUNC(__tracing_enable),
-	HANDLE_FUNC(__tracing_swap_reader),
-	HANDLE_FUNC(__tracing_update_clock),
-	HANDLE_FUNC(__tracing_reset),
-	HANDLE_FUNC(__tracing_enable_event),
-	HANDLE_FUNC(__tracing_write_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)

base-commit: 94b4ae79ebb42a8a6f2124b4d4b033b15a98e4f9
-- 
2.54.0.rc0.605.g598a273b03-goog

