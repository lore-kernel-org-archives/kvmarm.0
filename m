Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77966391E4E
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764484; cv=none; b=cq/4iY+a6cw4E7UQMeSteqMnAtud0Hz+OqaCmDcfc63Ojqrk4S9lZw0TvNJznBBkIor9xMU2af52DTMQQfF/mxvFAltgB9RgbCw1KaWlXRN788e76i92a0iMJrDW9CJ7GlU8XPGCRE3mGjH0UXF3S1XBiNu26e+p7ohznb9m/9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764484; c=relaxed/simple;
	bh=kbRhFLruLLEiDeGEjd+pflb7ajVQAAsj00DfZkSrZfA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k/Z6v0zGXQ9WvHzwXsT3PUk+CoyeKTDgo/T0agCAHBSNOleV+8bwqfk5fHDHxNduMVyjWdDFcIikevQfpmoi8mtpTlOGstffhL2kve6Cw8ABLefmze2pF8zJ7tOFIv9QZy7bM7h7+alN/kae/lLc5F2rlNZVTjJxn6OUbA14edI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zgdxe3RR; arc=none smtp.client-ip=91.218.175.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zgdxe3RR"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kbRhFLruLLEiDeGEjd+pflb7ajVQAAsj00DfZkSrZfA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764480; v=1; x=1789369280;
 b=Zgdxe3RRpZms/kntwrjakMvwqeAN9jrsy6LU02RxYoBAu/4TEfrh5CkaUMW7LpC7jY317NUF
 34Y4psisntpvxNUiu2CxT7XdpHdTxGc3bFa014UI3SzOyhOT8LXSq94kA1TIWs4DEvICkPb9pbn
 X0XHrR7mVTI7pVk52vZdX+V8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 540ff1370b612f45;
	Mon, 07 Sep 2026 07:01:20 +0000
X-Mizu-Trace-ID: 540ff1370b612f45
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
Subject: [PATCH v2 10/17] KVM: arm64: Prevent host PC adjustments for protected vCPUs
Date: Mon,  7 Sep 2026 07:59:55 +0100
Message-Id: <20260907070002.3333525-11-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
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
index 051c2d95e3b7d..1a3f23e90e563 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -640,11 +640,56 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
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

