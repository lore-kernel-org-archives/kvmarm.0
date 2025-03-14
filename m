Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6E778C9C
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 11:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741951127; cv=none; b=qTDdMX7AY+E7EiV2uLc6m9dfTYxCw4WtEEO8c7RVFdoNhdjE7MZLtJSRuGYML9RbVAbGsih6XwPyAicDE7JsfDfpuGjgHud1Oi9uRz6jBnz29Z51F29xsxgYgs3rvHufypUJ80X/HL4GvXd80WP0CBi1StRUagdsbW++8hA5Jsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741951127; c=relaxed/simple;
	bh=6ssYBDToyqvawCjJntyfnIUtZC8yoDBML56bhiWOljM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EV8pQisdQXuovEZY7JhCs5tJgLci2d4kUyWWJVWMzrm+eXkftIXmRlm/A5/nhgUGjZl7SnEvAqHkZO9pAMkWCcn7iM8jdE2IAYaN/X6FFVpdqgErZ+ZvnIJ8bNKoC/Has74LRUMc8+U8AuF7n0AG3mojqt9D37HwlkQekHEaqQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H2GymVTD; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H2GymVTD"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-39135d31ca4so1096990f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 04:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741951124; x=1742555924; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nQHS6edakeTMkoUtKqh0HQvA5buiRQWe1WYXeTlyIUk=;
        b=H2GymVTD0xWtwikseoiAhTZn21AsJoFZNXbyU3UL5k9yx2/3mKgMzc4CYlJLj3kG5D
         jfEY5gf4nbomQCHRDMJMBscATSG1bX40Wnuuyfm9Jow6sWe6eZwqDqLGQQagq5gQkz+y
         8Xuz0MQjXYKQjhmXguDBkNixBes4Odvn/T6GWOYYJbAIyzebOUMsT4fmPv1KSoi1EowF
         cOc5/wCc416yrgZB/72nN7RypVnozBCT5ePkltNrOtT0dMl7iCWBlcLKisNcIXEdPwk6
         FXzPi4NtfsskqZO528nRJcVJ6QFkYk0nQQhCphxU1wqfVY5RY7ixQMvnjFjX9HqQ0eb+
         uNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741951124; x=1742555924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nQHS6edakeTMkoUtKqh0HQvA5buiRQWe1WYXeTlyIUk=;
        b=KdcTt4yxF3QT3dC0njabTyHV7hvQRAZ9Jgr+03Iiv0sEMITaFb2tpaKL82YU92rIET
         XRLhIcb5iNNSyNouAhcybv5355oIYacGeWeX/dBewPslAOtHIROZhHgEgMWWNwwANBG+
         +u7Vez6p2J1lGB3fyX3BeTG/uwbqJ5AMaBq1Wdz4D3ObIlm4HONhhGzSUKbQSnD5vYpO
         GvlYIdjJa+w65EWjmYWgNjD+soOejULtk1pF+41N81wUnet8U+2CkBYQw22h7Ej+LI+s
         VyaW2Ahww72nvNFBR3yVpbw1+XWqKnljUVxXWfyF6WzV1Tlkr6Ic/CS4iagflJ3xc5Og
         /3Pw==
X-Gm-Message-State: AOJu0YwMKosrBUl3Hg47oUlK82XotUg+B1Pxx4NPaFGAWpyt3W2/vvIT
	Nsv/gJOw1iBQurfDQDZi5sayQvo9Te769ymvMswyHXEujHoicDB0hM3/AA5YqsXPHgI8sqAtzpY
	gc8jd+UZ/cxEuJD5Ol9bG9iHyWpoPtzfj+NDFlTDQyxNWQ1bVi1N+RnAZUiclgSIwa+6ufKyzX/
	ll4OtTGDpmpCJE2XM0416HJUrkGkw=
X-Google-Smtp-Source: AGHT+IFYtQOOphKfLoOaQyXRnKRzCcMMNh/zGKLdmVfOk340KK97aCzghkWNQExmuTK4+Cq9Ck3MWM7VWg==
X-Received: from wmrn15.prod.google.com ([2002:a05:600c:500f:b0:43c:f03d:18aa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4026:b0:391:a74:d7e2
 with SMTP id ffacd0b85a97d-395b9b10d93mr6955810f8f.26.1741951124121; Fri, 14
 Mar 2025 04:18:44 -0700 (PDT)
Date: Fri, 14 Mar 2025 11:18:32 +0000
In-Reply-To: <20250314111832.4137161-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250314111832.4137161-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250314111832.4137161-5-tabba@google.com>
Subject: [PATCH v3 4/4] KVM: arm64: Create each pKVM hyp vcpu after its
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

Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
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
index d919557af5e5..31b21cf8118a 100644
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
index 0160b4924351..6acd8b924210 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -843,6 +843,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
index 74cf5d87e77b..fc6b5df309dd 100644
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
 
 	host_kvm->arch.pkvm.handle = ret;
 
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
2.49.0.rc1.451.g8f38331e32-goog

