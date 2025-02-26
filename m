Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADCE1E1E01
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606935; cv=none; b=F80T4u/fpgad7vMvt2/LnwraAwUrLu/toP92ctlVGclm4cRET+O4S+mYpwPIf0NMNLgKM27RKwYmzT5JJ1OHKLrLoMb5ylqltEEsS7nTn2md36jUZMdddQUM7rpTU/VdvBfeLDg1yKw2TC1qaEBMKjGmqgzGnn54irU3zGHYJt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606935; c=relaxed/simple;
	bh=+v+UKmruVJopmXHsRdWAv+2lJS78pZrfKWNfVLo9QLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OQhmUL+WpMeQ9B+AKUNxOSmCaOODJrdc89WVXQ10BuXqmD3TgKsD6j7J6mkf9fRbqTxmreQ3qWVOoVr+EeHL7D59YxewhseHALiOWhfdc78UtzZF7wMOm9vNm6LYJLnZn4bgcCpMiKTnQ2KpBckEiw7LpsqiZIv3jqCVZrYN+h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T+PYYv/J; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T+PYYv/J"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-390df5962e1so334710f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606931; x=1741211731; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ7+KQbuHqWRSfbyGJAvgvQY/mr7Mv4w5E1Ef9PUYYI=;
        b=T+PYYv/Jgau13Bzz7f8H7zR3EPh2BRo7jsfCL6HWp8/O1oAj8hgprmA7mBhiZGSubw
         b2etGgneSw3SBbA0CHO+pUHZHbm8q73qR1lnjjb3Xuyualv9LViyfEqpQXGugtqYK4Zp
         fk+HO4n9XoolK+b4lsn8PyziT44pTbALSHK8OzDdWS3CdhXqV+Sp2hq1RatxQBF0odKC
         2HxFj7MmJTE7MC2FBU1F1fcu+HyyeQfldVIbl2B8nF6sHG8YruEVryKQc3i+KNMVB9oV
         ZKLs4myl3A06QHpvxnRv9WsEbEFoE3eoGHZOKRP//IvpPCvFARzLGFwM5fA7qGlkK1A8
         8cvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606931; x=1741211731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ7+KQbuHqWRSfbyGJAvgvQY/mr7Mv4w5E1Ef9PUYYI=;
        b=ejS2lo2BYF/GBg+QMc3a3GsI2Ti5hf5Hzg+jnN7sm66/MqHvTKWQ0Uih4uKNjBI75z
         dwhQeqr0CF4b1QbmCV16E/JScbJMzd8JzYAnsrguG5gXTUGiO6J4ENDP+qMR2rb2LX+k
         8pzZbK5dGhJg6Ue0pj+TyzPyUKeFK/bwcBt2l/oTnv3hb5FeNeSBp6GRt/C0ufkppqfw
         nx49/A4I8J1NjIACqRza69kzJAqmjNAyMGGLoNzq3o37EKMAS2t4TmuGN7ecsQX7D0mo
         P9MLhhHcAzT1eDVoiLSNHFf1GXNkn/7udWzhszPUX871EakgPNIREpTMMjwymVLsiCOa
         klWA==
X-Gm-Message-State: AOJu0YynrRwFT4UPua409BxCpaip6lglwR0DkICzDnbt/HYjm8OiiElp
	FW5jjr5bw/UfvGYp3WhBxFq8FcMQf7upuN+KBAqWOWMyRcAXkljHcAjB8/EaryswbEQ9FlGlrql
	N5CFtcj16syb5cstGBvRHoGOI+qOkU+9fcvYQYblUZiy9OgP+t9OAqvnrbZoypdHBx0D37MzPpi
	EEZcQ4WE+i/YBAllwSnHqeiSKZTmY=
X-Google-Smtp-Source: AGHT+IHDhAsp1nno//nPl2At9qgA+VgSPYHGXDoZbiK+SFBzzHnFyl/e7ZT+ADtfrG0th/kkfg/+o6ZYfA==
X-Received: from wrzd5.prod.google.com ([2002:a5d:6dc5:0:b0:38f:3ee0:73f5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2ac:b0:38d:ae4e:2267
 with SMTP id ffacd0b85a97d-390e166dcd7mr846883f8f.11.1740606931386; Wed, 26
 Feb 2025 13:55:31 -0800 (PST)
Date: Wed, 26 Feb 2025 21:55:20 +0000
In-Reply-To: <20250226215520.1759218-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250226215520.1759218-5-tabba@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Create each pKVM hyp vcpu after its
 corresponding host vcpu
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Instead of creating and initializing _all_ hyp vcpus in pKVM when
the first host vcpu runs for the first time, initialize _each_
hyp vcpu in conjunction with its corresponding host vcpu.

Some of the host vcpu state (e.g., system registers and traps
values) is not initialized until the first time the host vcpu is
run. Therefore, initializing a hyp vcpu before its corresponding
host vcpu has run for the first time might not view the complete
host state of these vcpus.

Additionally, this behavior is inline with non-protected modes.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h      |  2 +
 arch/arm64/include/asm/kvm_pkvm.h      |  1 +
 arch/arm64/kvm/arm.c                   |  4 ++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 54 +++++++++++++++-----------
 arch/arm64/kvm/pkvm.c                  | 28 ++++++-------
 6 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3a7ec98ef123..4a0e522f6001 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -869,6 +869,8 @@ struct kvm_vcpu_arch {
 #define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
 /* SVE config completed */
 #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
+/* pKVM VCPU setup completed */
+#define VCPU_PKVM_FINALIZED	__vcpu_single_flag(cflags, BIT(2))
 
 /* Exception pending */
 #define PENDING_EXCEPTION	__vcpu_single_flag(iflags, BIT(0))
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index eb65f12e81d9..abd693ce5b93 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -19,6 +19,7 @@
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
+int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
 
 /*
  * This functions as an allow-list of protected VM capabilities.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b8e55a441282..cd7a808eeb64 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -833,6 +833,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		ret = pkvm_create_hyp_vm(kvm);
 		if (ret)
 			return ret;
+
+		ret = pkvm_create_hyp_vcpu(vcpu);
+		if (ret)
+			return ret;
 	}
 
 	mutex_lock(&kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index e42bf68c8848..ce31d3b73603 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -43,12 +43,6 @@ struct pkvm_hyp_vm {
 	struct hyp_pool pool;
 	hyp_spinlock_t lock;
 
-	/*
-	 * The number of vcpus initialized and ready to run.
-	 * Modifying this is protected by 'vm_table_lock'.
-	 */
-	unsigned int nr_vcpus;
-
 	/* Array of the hyp vCPU structures for this VM. */
 	struct pkvm_hyp_vcpu *vcpus[];
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 6efb9bf56180..4ef3748dc660 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -245,10 +245,12 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm || hyp_vm->nr_vcpus <= vcpu_idx)
+	if (!hyp_vm || hyp_vm->kvm.created_vcpus <= vcpu_idx)
 		goto unlock;
 
 	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
+	if (!hyp_vcpu)
+		goto unlock;
 
 	/* Ensure vcpu isn't loaded on more than one cpu simultaneously. */
 	if (unlikely(hyp_vcpu->loaded_hyp_vcpu)) {
@@ -367,8 +369,14 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 {
 	int i;
 
-	for (i = 0; i < nr_vcpus; i++)
-		unpin_host_vcpu(hyp_vcpus[i]->host_vcpu);
+	for (i = 0; i < nr_vcpus; i++) {
+		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vcpus[i];
+
+		if (!hyp_vcpu)
+			continue;
+
+		unpin_host_vcpu(hyp_vcpu->host_vcpu);
+	}
 }
 
 static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
@@ -392,24 +400,18 @@ static void pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *
 
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 			      struct pkvm_hyp_vm *hyp_vm,
-			      struct kvm_vcpu *host_vcpu,
-			      unsigned int vcpu_idx)
+			      struct kvm_vcpu *host_vcpu)
 {
 	int ret = 0;
 
 	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
 		return -EBUSY;
 
-	if (host_vcpu->vcpu_idx != vcpu_idx) {
-		ret = -EINVAL;
-		goto done;
-	}
-
 	hyp_vcpu->host_vcpu = host_vcpu;
 
 	hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
 	hyp_vcpu->vcpu.vcpu_id = READ_ONCE(host_vcpu->vcpu_id);
-	hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
+	hyp_vcpu->vcpu.vcpu_idx = READ_ONCE(host_vcpu->vcpu_idx);
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
@@ -647,27 +649,28 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		goto unlock;
 	}
 
-	idx = hyp_vm->nr_vcpus;
+	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
+	if (ret)
+		goto unlock;
+
+	idx = hyp_vcpu->vcpu.vcpu_idx;
 	if (idx >= hyp_vm->kvm.created_vcpus) {
 		ret = -EINVAL;
 		goto unlock;
 	}
 
-	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu, idx);
-	if (ret)
+	if (hyp_vm->vcpus[idx]) {
+		ret = -EINVAL;
 		goto unlock;
+	}
 
 	hyp_vm->vcpus[idx] = hyp_vcpu;
-	hyp_vm->nr_vcpus++;
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
-	if (ret) {
+	if (ret)
 		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 static void
@@ -713,12 +716,17 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	/* Reclaim guest pages (including page-table pages) */
 	mc = &host_kvm->arch.pkvm.teardown_mc;
 	reclaim_guest_pages(hyp_vm, mc);
-	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->nr_vcpus);
+	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
 
 	/* Push the metadata pages to the teardown memcache */
-	for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
+	for (idx = 0; idx < hyp_vm->kvm.created_vcpus; ++idx) {
 		struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
-		struct kvm_hyp_memcache *vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
+		struct kvm_hyp_memcache *vcpu_mc;
+
+		if (!hyp_vcpu)
+			continue;
+
+		vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
 
 		while (vcpu_mc->nr_pages) {
 			void *addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 06665cf221bf..f2a09dc50676 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -125,7 +125,9 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, vcpu, hyp_vcpu);
-	if (ret)
+	if (!ret)
+		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
+	else
 		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
 
 	return ret;
@@ -144,9 +146,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 {
 	size_t pgd_sz, hyp_vm_sz;
-	struct kvm_vcpu *host_vcpu;
 	void *pgd, *hyp_vm;
-	unsigned long idx;
 	int ret;
 
 	if (host_kvm->created_vcpus < 1)
@@ -180,17 +180,7 @@ static int __pkvm_create_hyp_vm(struct kvm *host_kvm)
 
 	WRITE_ONCE(host_kvm->arch.pkvm.handle, ret);
 
-	kvm_for_each_vcpu(idx, host_vcpu, host_kvm) {
-		ret = __pkvm_create_hyp_vcpu(host_vcpu);
-		if (ret)
-			goto destroy_vm;
-	}
-
 	return 0;
-
-destroy_vm:
-	__pkvm_destroy_hyp_vm(host_kvm);
-	return ret;
 free_vm:
 	free_pages_exact(hyp_vm, hyp_vm_sz);
 free_pgd:
@@ -210,6 +200,18 @@ int pkvm_create_hyp_vm(struct kvm *host_kvm)
 	return ret;
 }
 
+int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
+{
+	int ret = 0;
+
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	if (!vcpu_get_flag(vcpu, VCPU_PKVM_FINALIZED))
+		ret = __pkvm_create_hyp_vcpu(vcpu);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+
+	return ret;
+}
+
 void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 {
 	mutex_lock(&host_kvm->arch.config_lock);
-- 
2.48.1.711.g2feabab25a-goog

