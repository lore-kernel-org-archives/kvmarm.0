Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750304A0135
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194103; cv=none; b=b8wgwIbefbUel20awkFV9ILiPz7hcKFuRML1wZ268VU9/ugl3reI8orwd8O5QpOUMcvZ2COm6Nr9DbCPJ0dVY1Sg8JPLrMS9nnUB1hSiU4uFgxdxgs5py2tQKP4JHATXjxu8f0BIE7rHYyf0RvMy3R81prElvklLAn88dDhYoIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194103; c=relaxed/simple;
	bh=6ANbHZO+GeKMjmPvw9fLYIpNaNW+Xrmp/Q12ajIWD68=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l1wC/y2ye8OHM+nzRTi8lRBxzrz53mO6oMHMRQcurl9g03TlMnxluoqwR2AfqHuOxOtADipLt2tssK7VGaDpPJvjb6boIhVSDTVCeXTwN5jjBN67biTIDx4FBoJk0tcI50fvy0pvmqkNqNBbYPrTfkK3vunD5yB4id7dG1WEpEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lWEX6ttC; arc=none smtp.client-ip=91.218.175.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lWEX6ttC"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6ANbHZO+GeKMjmPvw9fLYIpNaNW+Xrmp/Q12ajIWD68=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194098; v=1; x=1788798898;
 b=lWEX6ttCUJnfJIztK20XEix3uXXbfYtgiuFOgxVL3wJnYPh3WTtgiVgTNCBZTEY/2f/UMPBA
 1B+e1y48vtQT307NENU4Ndh1kKkOv4k5JXXjwIfXa2/iUuv9/PR7pe0rHXGxzIPEGJFlB9EIy6u
 NLrAqS9sPH8oy07FLqbiCdK4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d6c321c5f77338bd;
	Mon, 31 Aug 2026 16:34:58 +0000
X-Mizu-Trace-ID: d6c321c5f77338bd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 11/17] KVM: arm64: Prevent host PC adjustments for protected vCPUs
Date: Mon, 31 Aug 2026 17:34:15 +0100
Message-Id: <20260831163421.272420-12-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__kvm_adjust_pc() lets the host advance a vCPU's PC or inject an
exception, which for a protected vCPU would let the host redirect
guest execution. Drop the request there: the entry handlers apply the
host's PC_UPDATE_REQ on re-entry, where EL2 allows it.

For a non-protected vCPU, adjusting the hyp vCPU while
PKVM_HOST_STATE_DIRTY is set loses the update at the next flush and
the guest re-executes an emulated MMIO access, so the flag selects
which copy to adjust. Adjusting the hyp vCPU copies PC_UPDATE_REQ in
and back out again. Without the copy back, INCREMENT_PC outlives the
adjustment and the next KVM_SET_VCPU_EVENTS trips
WARN_ON(INCREMENT_PC) in kvm_pend_exception().

Unloaded, the host copy is host-writable, so pin it and its VM before
adjusting. Only commit_pending_events(), under KVM_SET_VCPU_EVENTS,
reaches EL2 with no hyp vCPU loaded. KVM_RUN's call always has one.
enter_exception64() reads the VM's MTE flag and a host copy's
vcpu->kvm is host-written, so __kvm_adjust_pc_vm() takes the VM as a
parameter: the pinned host struct kvm when unloaded, the hyp VM
otherwise.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kvm/hyp/exception.c     | 27 ++++++++++-------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 47 +++++++++++++++++++++++++++++-
 3 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69e..d149afee7b4bd 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -280,6 +280,7 @@ extern int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
+extern void __kvm_adjust_pc_vm(struct kvm_vcpu *vcpu, struct kvm *kvm);
 
 extern bool __vgic_v3_get_gic_config(void);
 extern void __vgic_v3_init_lrs(void);
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 754e2dc1df54a..bf9d8efce9984 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -66,8 +66,8 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
  * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
  * MSB to LSB.
  */
-static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
-			      enum exception_type type)
+static void enter_exception64(struct kvm_vcpu *vcpu, struct kvm *kvm,
+			      unsigned long target_mode, enum exception_type type)
 {
 	unsigned long sctlr, vbar, old, new, mode;
 	u64 exc_offset;
@@ -109,7 +109,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);
 
-	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
+	if (kvm_has_mte(kvm))
 		new |= PSR_TCO_BIT;
 
 	new |= (old & PSR_DIT_BIT);
@@ -294,7 +294,7 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	*vcpu_pc(vcpu) = vect_offset;
 }
 
-static void kvm_inject_exception(struct kvm_vcpu *vcpu)
+static void kvm_inject_exception(struct kvm_vcpu *vcpu, struct kvm *kvm)
 {
 	if (vcpu_el1_is_32bit(vcpu)) {
 		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
@@ -314,23 +314,23 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 	} else {
 		switch (vcpu_get_flag(vcpu, EXCEPT_MASK)) {
 		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC):
-			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
+			enter_exception64(vcpu, kvm, PSR_MODE_EL1h, except_type_sync);
 			break;
 
 		case unpack_vcpu_flag(EXCEPT_AA64_EL1_SERR):
-			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
+			enter_exception64(vcpu, kvm, PSR_MODE_EL1h, except_type_serror);
 			break;
 
 		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SYNC):
-			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_sync);
+			enter_exception64(vcpu, kvm, PSR_MODE_EL2h, except_type_sync);
 			break;
 
 		case unpack_vcpu_flag(EXCEPT_AA64_EL2_IRQ):
-			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_irq);
+			enter_exception64(vcpu, kvm, PSR_MODE_EL2h, except_type_irq);
 			break;
 
 		case unpack_vcpu_flag(EXCEPT_AA64_EL2_SERR):
-			enter_exception64(vcpu, PSR_MODE_EL2h, except_type_serror);
+			enter_exception64(vcpu, kvm, PSR_MODE_EL2h, except_type_serror);
 			break;
 
 		default:
@@ -348,10 +348,10 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  * Adjust the guest PC (and potentially exception state) depending on
  * flags provided by the emulation code.
  */
-void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
+void __kvm_adjust_pc_vm(struct kvm_vcpu *vcpu, struct kvm *kvm)
 {
 	if (vcpu_get_flag(vcpu, PENDING_EXCEPTION)) {
-		kvm_inject_exception(vcpu);
+		kvm_inject_exception(vcpu, kvm);
 		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
 		vcpu_clear_flag(vcpu, EXCEPT_MASK);
 	} else if (vcpu_get_flag(vcpu, INCREMENT_PC)) {
@@ -359,3 +359,8 @@ void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 		vcpu_clear_flag(vcpu, INCREMENT_PC);
 	}
 }
+
+void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
+{
+	__kvm_adjust_pc_vm(vcpu, kern_hyp_va(vcpu->kvm));
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2fdb861abb22d..5925d35abba8c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -741,11 +741,56 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static void adjust_pc_loaded(struct pkvm_hyp_vcpu *hyp_vcpu,
+			     struct kvm_vcpu *host_vcpu)
+{
+	/*
+	 * PKVM_HOST_STATE_DIRTY names the authoritative copy: the host's
+	 * when set, the hyp vCPU's otherwise. Adjust that one.
+	 */
+	if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY)) {
+		__kvm_adjust_pc_vm(host_vcpu, hyp_vcpu->vcpu.kvm);
+		return;
+	}
+
+	/* Reflect the consumed request back, otherwise it stays pending. */
+	vcpu_copy_flag(&hyp_vcpu->vcpu, host_vcpu, PC_UPDATE_REQ);
+	__kvm_adjust_pc(&hyp_vcpu->vcpu);
+	vcpu_copy_flag(host_vcpu, &hyp_vcpu->vcpu, PC_UPDATE_REQ);
+}
+
+static void adjust_pc_unloaded(struct kvm_vcpu *host_vcpu)
+{
+	struct kvm *host_kvm;
+
+	if (!is_protected_kvm_enabled()) {
+		__kvm_adjust_pc(host_vcpu);
+		return;
+	}
+
+	/* The host copy is authoritative, used only while pinned. */
+	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
+		return;
+
+	host_kvm = kern_hyp_va(READ_ONCE(host_vcpu->kvm));
+	if (!hyp_pin_shared_mem(host_kvm, host_kvm + 1)) {
+		__kvm_adjust_pc_vm(host_vcpu, host_kvm);
+		hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
+	}
+	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
 
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
+	if (!hyp_vcpu)
+		adjust_pc_unloaded(kern_hyp_va(vcpu));
+	else if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		adjust_pc_loaded(hyp_vcpu, host_vcpu);
 }
 
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
-- 
2.39.5

