Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D88844E653
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 07:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455867; cv=none; b=RyMXQI4xhlFJkHkja+Y+TiXdbo/wTGs6BhmsZB3Xln6zAA0pw7M1NXS9NqXDaU5hJxtHZM7+BWUw8C3htdP78AsDRq83A64oHIXhekxRpItViIhqWhmdpk2NYx983ubCjaf6o6dARRnV2xN1vhNIW7jk7aoMV4Pj39EHT82H57M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455867; c=relaxed/simple;
	bh=ANhxith82ULbv0/JaaJ8goUq0CxV3cuc4rjj5cuj3dU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i5bEDBVXs0vIClv4xoZcDvXKvuU16ZYzv33cVYyVzlvxo4UFxvfFiKsaQ0d62sS7OgHykxNk5B7RVpjC+YjQXeA8NkIr1Rz+wAediTbRf4M+QuY481W+RvfDCiCWw4HVYerZinJOzD9U2oWU8niqWcgHyKUhOR13eUlDwFkSOI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p46XEyyi; arc=none smtp.client-ip=91.218.175.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p46XEyyi"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ANhxith82ULbv0/JaaJ8goUq0CxV3cuc4rjj5cuj3dU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455863; v=1; x=1790060663;
 b=p46XEyyi5VK6kYdJNj6dDh+yAg5PJ6zeWbO/NVYhYLMF4N41z2k4ANoHJzNnAdb1YNwH/1kz
 b/SpP/9onmTjkXf+PWhvslgIfxrgojUi4sbibhICmwlRT2UzDeTdXX4D/PYanWM7Mt3GKAMSJab
 H7e5yq0GgGvc7J/vMWuaurlo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 43fcf61e14ba3efe;
	Tue, 15 Sep 2026 07:04:23 +0000
X-Mizu-Trace-ID: 43fcf61e14ba3efe
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v2 1/2] KVM: arm64: Validate the host vCPU's VM before reading it under pKVM
Date: Tue, 15 Sep 2026 08:04:17 +0100
Message-Id: <20260915070418.3209779-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915070418.3209779-1-fuad.tabba@linux.dev>
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On an MTE-capable host under pKVM, enter_exception64() reads the VM's
MTE flag through vcpu->kvm, which for a host vCPU is a host-writable
pointer nothing validates. The host can point it at any address in the
hyp linear map and read back bit 1 of that word through PSR_TCO in the
vCPU's CPSR, or panic the hypervisor with an unmapped one.

Get the VM through a get/put pair around the read: a loaded vCPU's is
the hyp VM, an unloaded host vCPU's is read once and pinned, and a
pointer the host never shared leaves TCO clear.

Fixes: ea7fc1bb1cd1b ("KVM: arm64: Introduce MTE VM feature")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260914070536.877D91F000FF@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/exception.c             |  5 ++-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 39 ++++++++++++++++++++++
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 754e2dc1df54a..6e60d890afa4a 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -70,6 +70,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 			      enum exception_type type)
 {
 	unsigned long sctlr, vbar, old, new, mode;
+	struct kvm *kvm;
 	u64 exc_offset;
 
 	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
@@ -109,8 +110,10 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);
 
-	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
+	kvm = vcpu_get_kvm(vcpu);
+	if (kvm && kvm_has_mte(kvm))
 		new |= PSR_TCO_BIT;
+	vcpu_put_kvm(vcpu, kvm);
 
 	new |= (old & PSR_DIT_BIT);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 4fdfeabefeb43..a4fb04faa7d09 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -13,6 +13,24 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
+/*
+ * Under pKVM a host vCPU's ->kvm is host-writable: the nVHE pair
+ * validates it.
+ */
+#ifdef __KVM_NVHE_HYPERVISOR__
+struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu);
+void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm);
+#else
+static inline struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm;
+}
+
+static inline void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+}
+#endif
+
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..9bdc7a9b84b8c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -11,6 +11,8 @@
 
 #include <asm/kvm_emulate.h>
 
+#include <hyp/adjust_pc.h>
+
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
@@ -304,6 +306,43 @@ struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void)
 
 }
 
+static struct pkvm_hyp_vm *loaded_hyp_vm_of(struct kvm_vcpu *vcpu)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+
+	if (hyp_vcpu &&
+	    (vcpu == &hyp_vcpu->vcpu || vcpu == hyp_vcpu->host_vcpu))
+		return pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+
+	return NULL;
+}
+
+/* An unloaded host vCPU's VM is mapped at EL2 only while pinned. */
+struct kvm *vcpu_get_kvm(struct kvm_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm;
+	struct kvm *kvm;
+
+	if (!is_protected_kvm_enabled())
+		return kern_hyp_va(vcpu->kvm);
+
+	hyp_vm = loaded_hyp_vm_of(vcpu);
+	if (hyp_vm)
+		return &hyp_vm->kvm;
+
+	kvm = kern_hyp_va(READ_ONCE(vcpu->kvm));
+	if (hyp_pin_shared_mem(kvm, kvm + 1))
+		return NULL;
+
+	return kvm;
+}
+
+void vcpu_put_kvm(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+	if (kvm && is_protected_kvm_enabled() && !loaded_hyp_vm_of(vcpu))
+		hyp_unpin_shared_mem(kvm, kvm + 1);
+}
+
 struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
-- 
2.39.5

