Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547BE17A305
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773072305; cv=none; b=RcpeUjJNu9rXUqLyftMLoGR8TUR/SYr6OJkVDG1Ap8T7vufg95PUD5eD3BxQzYkbuHpRHQubESuBzR01BbAKIg+tSQEGKEm4Y5LvUlk1Kp9XFOpFf87DTRnrIvFTXxjZjtg1KNqM3rWjFu3wFEN15CJ3VYKPYLF+NVyPJ/yXPUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773072305; c=relaxed/simple;
	bh=zKpyrCKYb8dfzZOOa8ORuY8XKJwxLIfZ7nFkwfIUU60=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AWotpn4bUhlwdbHwmE//d11Jz/8Bsmrhn0hrGheZoit66dWj579JIseLgBzchD3qUrL89hLt1xp4rF9d3B3TgS8J9V+Pvb60zHE8Y8BYAsQR1ldkpWNRn1gQB3b0l2Djxz8RcpiwLim3RxYKBTUpFiAHfARCUR4CO0K80m8PhWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CDV5BWzR; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CDV5BWzR"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6614741a740so4682892a12.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 09:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773072302; x=1773677102; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NkHqaF0Voln2FOHGSJG+Xa2sIZ5mFTGWevzJaf7mGg4=;
        b=CDV5BWzRKGBB9TFiq5FZyNL7SLsxigwF1OUXojblidRPc1tvy9x+IgaIWmv7HnIjde
         KPrPMm0PKds9TeKfY5cqTJbOIo0IFLcD7uUIHfkgaMGvnG8lPrPylzVqOZESc1FHsR24
         JgRzzt47pujx3q18chx3vqiNJtzF36G2k/q9nsXBN9MDeE32QB7HmJQd6S39B3lCFTzf
         MRaFdKUUUZLLWjx0dn2dHVMuPja6itJel33nPFrNo0Ji6Gi3bapQF29JgbOrDkNjSoVN
         EA2jCqsiQA3rMaqNCRC1lgeZEutK0KVQjrLIOupt83Xfc/tIwE7dRFA3iQotKvfy970Z
         cPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773072302; x=1773677102;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NkHqaF0Voln2FOHGSJG+Xa2sIZ5mFTGWevzJaf7mGg4=;
        b=L+y+RSC+J83bQJV7j4XrI1L4cJwIBWlTUotR6jJ+XtiWJtWh6Ly3XFkPteSKvPrP+5
         EIC1GTEy/roI7Tlvx1ps2mcJL/YkTkEZTjZE4vt7cNz6Zk65dDdnufcx9J4QJ7zDgKiJ
         SYXOeXIT9gmKZh5uiepVf0PTSaSI99ccvmk5v2KvjGsRL9m0wrWakVvR7lAfJKldTeEQ
         Ep5iuFhMR0gxC9q9DAHQhFj8l6b61kSGGilWOBGwKGRTPs0DGBwUojjV6oOR39ykeXMD
         G3KK+PeRhskNJ/t9QQjwx7hiCdODxGMyqjRVBj3KM2nqiu4fKv4qIKt9EpZnbVknuYSO
         iNGQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1ACbF3Hj8QiOKqf9rxmxwycvnuecwIFzOXX8T2XjFSkHBxt5Dqc4zMc8l5PhL/Jdp7qfD1UA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxMjUrnGTavab20eydaeCNtZTskCSyXt8ZFIxHY565q4+8gg1q
	yw/YKHn8CDESeeafYiEwHxcvzF1Mogkf+OfIYT6oHU1GEw/F2K4WG1xL8dOHX93oChBeYSJ6YUI
	XXy+I0wWKPUaU1Um/OfbNvQ==
X-Received: from ejcgj34.prod.google.com ([2002:a17:907:7422:b0:b93:5286:36e5])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:6a0c:b0:b8a:f7ec:d995 with SMTP id a640c23a62f3a-b942da27c31mr679712466b.9.1773072302063;
 Mon, 09 Mar 2026 09:05:02 -0700 (PDT)
Date: Mon,  9 Mar 2026 16:04:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260309160450.2610295-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Fix ICV_DIR_EL1 trapping detection for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, tabba@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

For non-VHE KVM, can_trap_icv_dir_el1() relies on a hyp-stub HVC to
read the ICH_VTR_EL2 register. This isn't compatible with pKVM enabled
devices which are failing late calls to verify_local_cpu_caps() when
hotplugging a CPU.

In verify_local_cpu_caps(), system_has_cap initialised before pKVM kills
the hyp-stub is most likely set, while cpu_has_cap fails to probe the
feature creates a capability conflict and prevents the CPU from going
online.

Add an HVC to get the ICH_VTR_EL2 register and use it in for ICV_DIR_EL1
trapping detection.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a1ad12c72ebf..81bac8faec44 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_ich_vtr_el2,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c31f8e17732a..0bca57c1cbe0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2345,13 +2345,17 @@ static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
 	    !is_midr_in_range_list(has_vgic_v3))
 		return false;
 
-	if (is_kernel_in_hyp_mode())
+	if (is_kernel_in_hyp_mode()) {
 		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
-	else
+	} else if (system_capabilities_finalized() && is_protected_kvm_enabled()) {
+		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(__vgic_v3_get_ich_vtr_el2), &res);
+		if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
+			return false;
+	} else {
 		arm_smccc_1_1_hvc(HVC_GET_ICH_VTR_EL2, &res);
-
-	if (res.a0 == HVC_STUB_ERR)
-		return false;
+		if (res.a0 == HVC_STUB_ERR)
+			return false;
+	}
 
 	return res.a1 & ICH_VTR_EL2_TDS;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..0432852228f9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -463,6 +463,11 @@ static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __vgic_v3_get_gic_config();
 }
 
+static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = read_sysreg_s(SYS_ICH_VTR_EL2);
+}
+
 static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 {
 	__vgic_v3_init_lrs();
@@ -622,6 +627,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v3_get_ich_vtr_el2),
 	HANDLE_FUNC(__pkvm_reserve_vm),
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),

base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
-- 
2.53.0.473.g4a7958ca14-goog

