Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2FE264A61
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739545390; cv=none; b=BJD/FO8L6Pzu8QJgVMkqkbz+4TXs/WZMZwgdhG9MxJ5SlS5e+aifGG3aRtOUI4xw3D6cSW0CzdpoQPI93p3l9zos5qDQWVPdlRTT3F/acrOaMrDiD5Gyg1QTOY53J3sK6ZfuihHJ4/9tWsOdLQKS0nTT4oIwqjfQxrT2jf5chhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739545390; c=relaxed/simple;
	bh=moSXFSAOv6Y0GDMzwxRky53RMNzoeGiyQo8oGlCznSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uDeQ/KI6C+/mBMce4CHHo6rFxR/vU9vEfK7Ve4ptdy3a6maFQJn5shykBdGNkfjQbzXZvyGS141Gp8cNDaJ+pZWGaw9VcJZ8tnUkrEttfzRj5GCL9VLG6b5OnGs+5VtQ3hNxLkMGBlkG6GR+p7XrPEwBJtmSc5narQWdtHhTag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jojxfmdn; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jojxfmdn"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4396260f74fso13458145e9.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 07:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739545386; x=1740150186; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vYCZEVwMXOsZCRPZrz0ygCxLWWB5K6kJuwIf0LtgrsU=;
        b=jojxfmdn4j+9pc+ekXKzLcathqT6VE1P4OefNIIWziGl6O3WkyUPJcn2x25EhqqRZe
         x020cjOXNC+cGgRiMEsHur/LjDcL0mXB24MgqWfWK51ciZnGxLZ5m+bs+21wFisx/Gk9
         1PqtvJ8NfKkhFVoaNfim1XpL3Pa5uE3OzYvYMc/j/F8DAC5XkOCTe3jktQ6K8wmsygZ1
         f3KIElQsKWjL/X65CAm76Q6bKWdEAO1FWvpBs/n/ntJecWgt/ot6+V2cKUvUM/TRI7Tf
         3/QzIWdmfty0+yoXC+WHl99p4CpNbOLAsl5tMMbvbPdRxDKfzbEehNyBpTu4DE66HHC6
         GGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739545386; x=1740150186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYCZEVwMXOsZCRPZrz0ygCxLWWB5K6kJuwIf0LtgrsU=;
        b=HtRPR84n36vyp/8aDefsp0etdcZIZ7lf++47DsJo2kD/QZvmbnML6BQi0SP1s2gkz9
         5xvob+xmAuC/iPX43QNqr2Gb7mJJfHkKvckxyxfQ10TAPlCI1KErXRcVwNK3HNMOmcrY
         Le+FywqY0cfRlLPs9Qq6FnOg+RJUHNsRKt20NKgAVj8/tqAMBuA0g8QKNmK30G1mUFvt
         9QPI0JM8XdoZYnE4BYv5PCKZQ9766ZrBRRYnIElnGzsEZEPjeHwPeKaPUNH8zQd4zQlD
         HKOML60rOE//GU1i4t+p+YS64FuzcXXLNP3Z7z7XyHGJbslmIQkDtyC6WLZZEs8Dvojn
         +i1A==
X-Gm-Message-State: AOJu0YxsX2z3E+SRLTPVisqu0Hjyb9hZ1R3CnL68RDLKVZY+SbGHqVL2
	aA1WUDXa7iRS79seZcV227NdOnebKQk4Bef+lg8gjJoYzPZ8Rlqzhrgt9zjOqUeqjvWH4cyWhWS
	gHihffORzq8sFiTvye7tH6HiKAwtZm+OgMpE8oG7hiE+sYzu+OFl6w+RK9Ub62w65BKHzXh4qe8
	biosDEIvjHcpYDKtIZ838ktUhUDno=
X-Google-Smtp-Source: AGHT+IEgvClSjiRCqZsobCfBVb8m5U5tEqqh7iL7ZM50v8X3mOoLF2QNmTRy6mSwXPzUsO0zThlWwt7fqg==
X-Received: from wmkg21.prod.google.com ([2002:a7b:c4d5:0:b0:439:4c5f:a295])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6019:b0:439:608f:a37f
 with SMTP id 5b1f17b1804b1-439608fa43bmr108055715e9.5.1739545386440; Fri, 14
 Feb 2025 07:03:06 -0800 (PST)
Date: Fri, 14 Feb 2025 15:02:58 +0000
In-Reply-To: <20250214150258.464798-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250214150258.464798-4-tabba@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Create each pKVM hyp vcpu after its
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
values) are not initialized until the first time the host vcpu is
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
index 7cfa024de4e3..d35ce3c860fc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -881,6 +881,8 @@ struct kvm_vcpu_arch {
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
index 071a7d75be68..e4661c2f0423 100644
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
index 668ebec27f1b..20abd46e03b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -285,10 +285,12 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 
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
@@ -407,8 +409,14 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
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
@@ -432,24 +440,18 @@ static void pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *
 
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
@@ -687,27 +689,28 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
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
@@ -753,12 +756,17 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
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
2.48.1.601.g30ceb7b040-goog

