Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEEC3D0926
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682539; cv=none; b=Yj4cNVh9HERGxSUD4VnxKYN8xc50MZ3v2RHK1pr5/ItlWOMovTEcHG0Gudap8QJN5Cru9YYAJo75PxtGWbp69YCI95PSgKg5jf3jwqdc6OCCUZ3d7gzRUJ5hNKfYuQeZEqB254j9uy+jqk1bTw16n+7WfgAEMzpo6Nf+iAL9Es8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682539; c=relaxed/simple;
	bh=iChkBxKJtcFVZgyq0ui0SMkPSn7JUQJQi+VMec4bY8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nWHsKoAep3t8D7YrE5YqqDGk0S7Rv40w+MGOQJRv+OzMW6WAPpSOBqKDT4nhvbou0hy56YJvU2Fj9SGAzNJjCH6QHOAG93pkJ/HleOX/uCkFOZ1VwqqQ023RfVJV4/EB+tETzZYDSCrfdKJj//sfLdddSTB2SnOxkArD76F4QaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GCJ9/qbe; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GCJ9/qbe"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b42cd4becso1005668f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682536; x=1774287336; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2aVMNYqgbLtglfFJK2IfbXVz92dSXKpE2nwANbOIprc=;
        b=GCJ9/qbeQ9HDaFxqCQkD6EIu4ELwgUsqQOFpM3yBBT3LwjyLrc3b+iTT/B1oIiPzHt
         /kxFqIyE/UO1118IqiPL21bELoRRzG0jhrF9MZ442MLwjfjS2AxVFSKbevNsm7Xpg6OM
         s3hX48vEefCgrrxnRYeROJCHqfJ4H+lxcxHqpJJds7bEQkE6i88Cj+dqlVBr0pqfhCqg
         ecfNz+seGIeGamCnSC2ZfDZIZd0X2u0AE5D2Yt1saaXMHT5BcQGJRW247u/OI75bKXG+
         gW9nLbDlQ5SvrWFEsIW7Dw0oM/T35nBKhVeiVtHECFPD1VyIKNOsl1QO5ucceEHcIfSN
         bIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682536; x=1774287336;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2aVMNYqgbLtglfFJK2IfbXVz92dSXKpE2nwANbOIprc=;
        b=h8pEJkgqZ8mXVz2uOkZ+QmKMnB7FF/46BDIkbT52jlCEazq0ha4szSOCUzIAkVS3he
         NOH6tyQIR/ggUbpulklSeMyZ9RSqz/HjVqvlhVTlnC6woazAX/xJ9XIKq9cWGBo19dc8
         mJdmSxoMoc/PH3VyS5keJeDtr6FphbZvbzgL9sE4fmkoPMrRKhxFPzv5WhJ2yGCo20Ka
         By5LodubaJ8TI/IkXtbZXCnne4kvpX5J9w+/QXw1Yav9UhqHhbBftyLS/I6GQe74E2S+
         vd4Q6apZxAST+MAwBKVGlAQ49oo198+8FAQqyWaKsgEJAfrd37p7ekG+tui9KOvj3LVc
         +c4A==
X-Forwarded-Encrypted: i=1; AJvYcCXhwNciEOlG1qgF9hQLSZoNXnhcK4bsqwjFpjYN7Uvdh059O2XhrYOg54LQ15MXEMkmN/bXGsQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRvbClULVsz/ex3VzsGcUisHgIOhahXahOlPf/QEgtlM0SRF42
	a5ObNFd/8AmIEyovCLpHUh71LXbeLx0vy4wmXglqhSD20N+SMot+Y2/Acn/K+7Kq2mvP+vSKh1e
	SlQ==
X-Received: from wrbfu19.prod.google.com ([2002:a05:6000:25f3:b0:43b:458d:a311])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d09:0:b0:439:c153:ae3d
 with SMTP id ffacd0b85a97d-43b498127f3mr1058497f8f.6.1773682536058; Mon, 16
 Mar 2026 10:35:36 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:28 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-7-456875a2c6db@google.com>
Subject: [PATCH 07/10] KVM: arm64: Use scoped resource management in arm.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual spin_lock() calls managing mp_state_lock and manual
mutex_lock() calls managing kvm->arch.config_lock to use the
guard(spinlock) and guard(mutex) macros.

This eliminates manual unlock calls on early return paths and
simplifies the vCPU suspend/resume control flow.

Change-Id: Ifcd8455d08afa5d00fc200daaa3fb13f6736e6ed
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 53 ++++++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..017f5bfabe19 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -274,17 +274,15 @@ static void kvm_destroy_mpidr_data(struct kvm *kvm)
 {
 	struct kvm_mpidr_data *data;
 
-	mutex_lock(&kvm->arch.config_lock);
-
-	data = rcu_dereference_protected(kvm->arch.mpidr_data,
-					 lockdep_is_held(&kvm->arch.config_lock));
-	if (data) {
-		rcu_assign_pointer(kvm->arch.mpidr_data, NULL);
-		synchronize_rcu();
-		kfree(data);
+	scoped_guard(mutex, &kvm->arch.config_lock) {
+		data = rcu_dereference_protected(kvm->arch.mpidr_data,
+						 lockdep_is_held(&kvm->arch.config_lock));
+		if (data) {
+			rcu_assign_pointer(kvm->arch.mpidr_data, NULL);
+			synchronize_rcu();
+			kfree(data);
+		}
 	}
-
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 /**
@@ -738,9 +736,8 @@ static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	spin_lock(&vcpu->arch.mp_state_lock);
+	guard(spinlock)(&vcpu->arch.mp_state_lock);
 	__kvm_arm_vcpu_power_off(vcpu);
-	spin_unlock(&vcpu->arch.mp_state_lock);
 }
 
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
@@ -773,7 +770,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 {
 	int ret = 0;
 
-	spin_lock(&vcpu->arch.mp_state_lock);
+	guard(spinlock)(&vcpu->arch.mp_state_lock);
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
@@ -789,8 +786,6 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		ret = -EINVAL;
 	}
 
-	spin_unlock(&vcpu->arch.mp_state_lock);
-
 	return ret;
 }
 
@@ -828,11 +823,11 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 	u64 aff_set = 0, aff_clr = ~0UL;
 	struct kvm_vcpu *vcpu;
 
-	mutex_lock(&kvm->arch.config_lock);
+	guard(mutex)(&kvm->arch.config_lock);
 
 	if (rcu_access_pointer(kvm->arch.mpidr_data) ||
 	    atomic_read(&kvm->online_vcpus) == 1)
-		goto out;
+		return;
 
 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
@@ -857,7 +852,7 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 				    GFP_KERNEL_ACCOUNT);
 
 	if (!data)
-		goto out;
+		return;
 
 	data->mpidr_mask = mask;
 
@@ -869,8 +864,6 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 	}
 
 	rcu_assign_pointer(kvm->arch.mpidr_data, data);
-out:
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 /*
@@ -944,9 +937,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	mutex_lock(&kvm->arch.config_lock);
+	guard(mutex)(&kvm->arch.config_lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
-	mutex_unlock(&kvm->arch.config_lock);
 
 	return ret;
 }
@@ -1585,29 +1577,26 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 {
 	unsigned long features = init->features[0];
 	struct kvm *kvm = vcpu->kvm;
-	int ret = -EINVAL;
+	int ret;
 
-	mutex_lock(&kvm->arch.config_lock);
+	guard(mutex)(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags) &&
 	    kvm_vcpu_init_changed(vcpu, init))
-		goto out_unlock;
+		return -EINVAL;
 
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
 	ret = kvm_setup_vcpu(vcpu);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);
 
 	set_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags);
 	vcpu_set_flag(vcpu, VCPU_INITIALIZED);
-	ret = 0;
-out_unlock:
-	mutex_unlock(&kvm->arch.config_lock);
-	return ret;
+	return 0;
 }
 
 static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
@@ -1674,15 +1663,13 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	/*
 	 * Handle the "start in power-off" case.
 	 */
-	spin_lock(&vcpu->arch.mp_state_lock);
+	guard(spinlock)(&vcpu->arch.mp_state_lock);
 
 	if (power_off)
 		__kvm_arm_vcpu_power_off(vcpu);
 	else
 		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 
-	spin_unlock(&vcpu->arch.mp_state_lock);
-
 	return 0;
 }
 

-- 
2.53.0.851.ga537e3e6e9-goog

