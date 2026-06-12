Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A90C3D79F0
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247578; cv=none; b=GN2qdIULHEQIzBnaTlag+J5qJSotKPmuCSSJARvMgmuRUo0V7OBBkhrSwruJ1lDUuDHwgNdMYhdGz0fR9cOOCvAzYcMM9mZ9J0nPlJgK1RTEs2zEN3/JydAfnMaVcVu+iXNScBFDlH1SC4XRILWq/uWHRtBw2BEAXe7+HIkvoQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247578; c=relaxed/simple;
	bh=jx/Yhq70Bsl7Q9oV5QijYVYxWzGtpUh9z9eIo/RbLoo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SYE3X1ZJAgsCUvBt/2vkYj4PyMB5yUgKORV1HR5+N6Szp0i46h7kdD5G+Cxr7e+EQQtyKRIcael9PO0rcbsU8skcqD2RIO1QSFVYddkuqbTVXo6xRIbBl0LYoL7Uqr3QD9KTZ5qHxJIMrrDR6ohgZFnei5GR/MOlxHbYFuSKBhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dkfYufsO; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dkfYufsO"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45ef55779d1so416108f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247570; x=1781852370; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xaz60O81ceKnaW6fsPnXrD/MZKDxDO1Yi/KW97lEVIQ=;
        b=dkfYufsOMwUQjKXDBLgSDWezSPVDvG0MJIGItDWX7AB55UOvWNm+LdQK9TudW+eESq
         s2UYFucERbXtkSKenedYnuMV8/L1V8tN1gMMevJXk4hedCXVMeeNVoieMHiHxllrz09n
         rvM+zDl0nJVO4G1geXpWfHSmj8TtYyuBd3HBPgI2n0PBE/Q2CINbuKepdt/1WrE1PEFK
         7n9LFYFfo9J8doEC1cpsihoTb+AULebMqhDgE2xI3k1LMJM0SHSwSK4blxNsmZoawDqz
         a3Um2uuusfuf9KBgYU5DpNp21ve9eFFQ7jrBw834VJEbK3Izuk0fbxNM/GFxOEe6Gib0
         2cBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247570; x=1781852370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xaz60O81ceKnaW6fsPnXrD/MZKDxDO1Yi/KW97lEVIQ=;
        b=VM/NitGWRINCapcaX43+7of92nCc1HXeaNomZRHlR8soQ1d6sHncNGcen+8kK89qnw
         FN04w2K767kRx7qf91i+HeHtYK5N4GGF+7U2axtkaU3gEC3wGTGaHHyXg3i1I2mnl4k4
         JgN4J47NwOZZXyubtNLtGI1z4hzU7Lszz9TEq0VYzjhyCCr7wAulOFQOMnQ1bcgU03Cq
         e2A/qB8uP+bxXCxGEBVLtQPj0EO//DqvwWVQQPCYKWoTk2HO5rkfvPtfv0K4g5inCscQ
         JWutEKVjNdGYIWGk6+ooBijEjpLx/wEyUdZandd8I82dTGP/PwjHrVRBjd1A7xVXfvlq
         MXEw==
X-Forwarded-Encrypted: i=1; AFNElJ9Aq1H/mPjF42t9yMO/2Lvd6Y+kxwX0xO6bqEOxfM1cPQZzoyO5AoGsWY/A+AmrC5BYplbH1B4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8Mfl01EwKe4oyRVQaYFO+jhdZ4sXgwk2IcJ80g6Yr1+PKgQfe
	QpPrOCjXjya3UQg2NSZdVzqPNUEkTW5gYh61Ryi/8CCcdXGuQdelcQcHlnNDVo3SSQXCeBRGFOD
	BUg==
X-Received: from wmxb3-n2.prod.google.com ([2002:a05:600d:8443:20b0:490:bfa7:ad27])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c3cd:20b0:490:d3ef:fa4a
 with SMTP id 5b1f17b1804b1-490ec4ea4f1mr10709515e9.14.1781247569549; Thu, 11
 Jun 2026 23:59:29 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:17 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-4-tabba@google.com>
Subject: [PATCH v1 03/11] KVM: arm64: Use guard()/scoped_guard() in arm64 KVM
 EL1 code
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Convert the manual mutex_lock()/spin_lock() pairs in
arch/arm64/kvm/{pkvm,arm,mmu,reset,psci}.c to guard(mutex),
guard(spinlock) and scoped_guard(), dropping unlock-only goto labels in
favour of direct returns. Centralised cleanup gotos that still serve
other resources are preserved.

reset.c uses scoped_guard() rather than guard() so the lock covers only
the small read/update window inside kvm_reset_vcpu(), leaving the rest
of the function outside the critical section.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c   | 14 +++-----
 arch/arm64/kvm/mmu.c   | 80 +++++++++++++++---------------------------
 arch/arm64/kvm/pkvm.c  | 26 ++++++--------
 arch/arm64/kvm/psci.c  | 17 ++++-----
 arch/arm64/kvm/reset.c |  8 ++---
 5 files changed, 53 insertions(+), 92 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9453321ef8c6..c9f36932c980 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -793,9 +793,7 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	int ret = 0;
-
-	spin_lock(&vcpu->arch.mp_state_lock);
+	guard(spinlock)(&vcpu->arch.mp_state_lock);
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
@@ -808,12 +806,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		kvm_arm_vcpu_suspend(vcpu);
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
-	spin_unlock(&vcpu->arch.mp_state_lock);
-
-	return ret;
+	return 0;
 }
 
 /**
@@ -1726,15 +1722,13 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
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
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4da9281312eb..d18f4ce7ceae 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -391,13 +391,13 @@ static void stage2_flush_vm(struct kvm *kvm)
  */
 void __init free_hyp_pgds(void)
 {
-	mutex_lock(&kvm_hyp_pgd_mutex);
-	if (hyp_pgtable) {
-		kvm_pgtable_hyp_destroy(hyp_pgtable);
-		kfree(hyp_pgtable);
-		hyp_pgtable = NULL;
-	}
-	mutex_unlock(&kvm_hyp_pgd_mutex);
+	guard(mutex)(&kvm_hyp_pgd_mutex);
+	if (!hyp_pgtable)
+		return;
+
+	kvm_pgtable_hyp_destroy(hyp_pgtable);
+	kfree(hyp_pgtable);
+	hyp_pgtable = NULL;
 }
 
 static bool kvm_host_owns_hyp_mappings(void)
@@ -424,16 +424,11 @@ static bool kvm_host_owns_hyp_mappings(void)
 int __create_hyp_mappings(unsigned long start, unsigned long size,
 			  unsigned long phys, enum kvm_pgtable_prot prot)
 {
-	int err;
-
 	if (WARN_ON(!kvm_host_owns_hyp_mappings()))
 		return -EINVAL;
 
-	mutex_lock(&kvm_hyp_pgd_mutex);
-	err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
-	mutex_unlock(&kvm_hyp_pgd_mutex);
-
-	return err;
+	guard(mutex)(&kvm_hyp_pgd_mutex);
+	return kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
 }
 
 static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
@@ -481,56 +476,42 @@ static int share_pfn_hyp(u64 pfn)
 {
 	struct rb_node **node, *parent;
 	struct hyp_shared_pfn *this;
-	int ret = 0;
 
-	mutex_lock(&hyp_shared_pfns_lock);
+	guard(mutex)(&hyp_shared_pfns_lock);
 	this = find_shared_pfn(pfn, &node, &parent);
 	if (this) {
 		this->count++;
-		goto unlock;
+		return 0;
 	}
 
 	this = kzalloc_obj(*this);
-	if (!this) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	if (!this)
+		return -ENOMEM;
 
 	this->pfn = pfn;
 	this->count = 1;
 	rb_link_node(&this->node, parent, node);
 	rb_insert_color(&this->node, &hyp_shared_pfns);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
-unlock:
-	mutex_unlock(&hyp_shared_pfns_lock);
-
-	return ret;
+	return kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
 }
 
 static int unshare_pfn_hyp(u64 pfn)
 {
 	struct rb_node **node, *parent;
 	struct hyp_shared_pfn *this;
-	int ret = 0;
 
-	mutex_lock(&hyp_shared_pfns_lock);
+	guard(mutex)(&hyp_shared_pfns_lock);
 	this = find_shared_pfn(pfn, &node, &parent);
-	if (WARN_ON(!this)) {
-		ret = -ENOENT;
-		goto unlock;
-	}
+	if (WARN_ON(!this))
+		return -ENOENT;
 
 	this->count--;
 	if (this->count)
-		goto unlock;
+		return 0;
 
 	rb_erase(&this->node, &hyp_shared_pfns);
 	kfree(this);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
-unlock:
-	mutex_unlock(&hyp_shared_pfns_lock);
-
-	return ret;
+	return kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
 }
 
 int kvm_share_hyp(void *from, void *to)
@@ -655,7 +636,7 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
 	unsigned long base;
 	int ret = 0;
 
-	mutex_lock(&kvm_hyp_pgd_mutex);
+	guard(mutex)(&kvm_hyp_pgd_mutex);
 
 	/*
 	 * This assumes that we have enough space below the idmap
@@ -670,8 +651,6 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
 	base = io_map_base - size;
 	ret = __hyp_alloc_private_va_range(base);
 
-	mutex_unlock(&kvm_hyp_pgd_mutex);
-
 	if (!ret)
 		*haddr = base;
 
@@ -714,17 +693,16 @@ int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr)
 	size_t size;
 	int ret;
 
-	mutex_lock(&kvm_hyp_pgd_mutex);
-	/*
-	 * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
-	 * an alignment of our allocation on the order of the size.
-	 */
-	size = NVHE_STACK_SIZE * 2;
-	base = ALIGN_DOWN(io_map_base - size, size);
+	scoped_guard(mutex, &kvm_hyp_pgd_mutex) {
+		/*
+		 * Efficient stack verification using the NVHE_STACK_SHIFT bit implies
+		 * an alignment of our allocation on the order of the size.
+		 */
+		size = NVHE_STACK_SIZE * 2;
+		base = ALIGN_DOWN(io_map_base - size, size);
 
-	ret = __hyp_alloc_private_va_range(base);
-
-	mutex_unlock(&kvm_hyp_pgd_mutex);
+		ret = __hyp_alloc_private_va_range(base);
+	}
 
 	if (ret) {
 		kvm_err("Cannot allocate hyp stack guard page\n");
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..a39111b70f9f 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -190,39 +190,33 @@ bool pkvm_hyp_vm_is_created(struct kvm *kvm)
 
 int pkvm_create_hyp_vm(struct kvm *kvm)
 {
-	int ret = 0;
-
 	/*
 	 * Synchronise with kvm_arch_prepare_memory_region(), as we
 	 * prevent memslot modifications on a pVM that has been run.
 	 */
-	mutex_lock(&kvm->slots_lock);
-	mutex_lock(&kvm->arch.config_lock);
-	if (!pkvm_hyp_vm_is_created(kvm))
-		ret = __pkvm_create_hyp_vm(kvm);
-	mutex_unlock(&kvm->arch.config_lock);
-	mutex_unlock(&kvm->slots_lock);
+	guard(mutex)(&kvm->slots_lock);
+	guard(mutex)(&kvm->arch.config_lock);
 
-	return ret;
+	if (!pkvm_hyp_vm_is_created(kvm))
+		return __pkvm_create_hyp_vm(kvm);
+
+	return 0;
 }
 
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 {
-	int ret = 0;
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
 
-	mutex_lock(&vcpu->kvm->arch.config_lock);
 	if (!vcpu_get_flag(vcpu, VCPU_PKVM_FINALIZED))
-		ret = __pkvm_create_hyp_vcpu(vcpu);
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
+		return __pkvm_create_hyp_vcpu(vcpu);
 
-	return ret;
+	return 0;
 }
 
 void pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
-	mutex_lock(&kvm->arch.config_lock);
+	guard(mutex)(&kvm->arch.config_lock);
 	__pkvm_destroy_hyp_vm(kvm);
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type)
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3b5dbe9a0a0e..e1389c525e9d 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -62,7 +62,6 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	struct vcpu_reset_state *reset_state;
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
-	int ret = PSCI_RET_SUCCESS;
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
@@ -78,14 +77,13 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 
-	spin_lock(&vcpu->arch.mp_state_lock);
+	guard(spinlock)(&vcpu->arch.mp_state_lock);
+
 	if (!kvm_arm_vcpu_stopped(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
-			ret = PSCI_RET_ALREADY_ON;
+			return PSCI_RET_ALREADY_ON;
 		else
-			ret = PSCI_RET_INVALID_PARAMS;
-
-		goto out_unlock;
+			return PSCI_RET_INVALID_PARAMS;
 	}
 
 	reset_state = &vcpu->arch.reset_state;
@@ -113,9 +111,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 	kvm_vcpu_wake_up(vcpu);
 
-out_unlock:
-	spin_unlock(&vcpu->arch.mp_state_lock);
-	return ret;
+	return PSCI_RET_SUCCESS;
 }
 
 static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
@@ -176,9 +172,8 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	 * re-initialized.
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		spin_lock(&tmp->arch.mp_state_lock);
+		guard(spinlock)(&tmp->arch.mp_state_lock);
 		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
-		spin_unlock(&tmp->arch.mp_state_lock);
 	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b963fd975aac..60969d90bdd3 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -193,10 +193,10 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	bool loaded;
 	u32 pstate;
 
-	spin_lock(&vcpu->arch.mp_state_lock);
-	reset_state = vcpu->arch.reset_state;
-	vcpu->arch.reset_state.reset = false;
-	spin_unlock(&vcpu->arch.mp_state_lock);
+	scoped_guard(spinlock, &vcpu->arch.mp_state_lock) {
+		reset_state = vcpu->arch.reset_state;
+		vcpu->arch.reset_state.reset = false;
+	}
 
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);
-- 
2.54.0.1136.gdb2ca164c4-goog

