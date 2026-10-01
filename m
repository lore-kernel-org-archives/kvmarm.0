Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AB851CF48
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863129; cv=none; b=QaKq9IO06DjBrZcAAteCeAKJuOfWLZEWD1fTkKj1Jw6ftcd6z4cbhgSrUuzRGoglJ1/7osj2ihPeh/5YxVacW2r1v+IFQhRCC4idAnxwhTmmEwAVtJXthqib4eREHkypJKJYEXLY9RkU5s3kqf3tpSTrEl78/gJQCmabWCZLZek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863129; c=relaxed/simple;
	bh=dHdaphLPaxiJnDdChqsi9d9Aw/xsGioqmTQLQwvPdbE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CUBGwS18qlmwl5MiB4bxSmWico05qEBdw0YfLWttSG1KbgyKPwQ06wokv/GfqFW3fZ60o7n22uNy85YmTFIjbxipEB7iYYyBgMDnZ0KEokpzbsbX5jCRF2rZZtRwP0Uqxu3JX9rbknuYdcY7b1/vmy8faP5EZgVAYSK3W2pIFI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FwjDSugj; arc=none smtp.client-ip=91.218.175.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FwjDSugj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dHdaphLPaxiJnDdChqsi9d9Aw/xsGioqmTQLQwvPdbE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863125; v=1; x=1791467925;
 b=FwjDSugjfFaGjXVG1A1hUdQQ/DBrWeiu95W34gGH+5B4UI/PeuDzOwn2HMkVzBiG8HEfS6Bv
 FID9+P6b++4/oklheCXbX2SZCIlbq0ptZlPna3eX6eXoGC4IbNbHrm3nfFjb4qjvouEiz8FzgNN
 EVEPXMT+0oCmYZpW0VqmZWNk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 97672e52d256137f;
	Thu, 01 Oct 2026 13:58:45 +0000
X-Mizu-Trace-ID: 97672e52d256137f
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
Subject: [PATCH v4 12/18] KVM: arm64: Prevent host PC adjustments for protected vCPUs
Date: Thu,  1 Oct 2026 14:57:05 +0100
Message-Id: <20261001135711.1640520-13-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__kvm_adjust_pc() lets the host advance a vCPU's PC or inject an
exception, which for a protected vCPU would let the host redirect
guest execution. Leave the request on the host copy there: the entry
handlers apply the host's PC_UPDATE_REQ at the next entry, where EL2
allows it.

__kvm_adjust_pc() adjusts the vCPU a get/put pair returns, the one it
was given outside pKVM. Both host callers hold the vCPU mutex, so a
hyp vCPU loaded for the vCPU is loaded on the calling CPU, and EL2's
own calls pass the hyp vCPU itself. For a loaded protected vCPU,
kvm_adjust_pc_get() returns NULL and the request stays on the host
copy. For a loaded non-protected vCPU, PKVM_HOST_STATE_DIRTY selects
the copy, since adjusting the hyp vCPU while the host copy is
authoritative loses the update at the next flush. Adjusting the hyp
vCPU copies PC_UPDATE_REQ in and back out again: without the copy
back, INCREMENT_PC outlives the adjustment and the next
KVM_SET_VCPU_EVENTS trips WARN_ON(INCREMENT_PC) in
kvm_pend_exception(). With no hyp vCPU loaded, as under
KVM_SET_VCPU_EVENTS, the host copy is adjusted as before.

Until the marshalling patch clears PC_UPDATE_REQ on the host copy at
exit, a KVM_RUN that returns to userspace with INCREMENT_PC set leaves
it on the host copy of a loaded protected vCPU, and a
KVM_SET_VCPU_EVENTS before the next run then trips that WARN_ON.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/exception.c             | 21 +++++++++-----
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 20 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 32 ++++++++++++++++++++++
 3 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 6e60d890afa4a..93d68b1d38be8 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -353,12 +353,19 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  */
 void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_get_flag(vcpu, PENDING_EXCEPTION)) {
-		kvm_inject_exception(vcpu);
-		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
-		vcpu_clear_flag(vcpu, EXCEPT_MASK);
-	} else if (vcpu_get_flag(vcpu, INCREMENT_PC)) {
-		kvm_skip_instr(vcpu);
-		vcpu_clear_flag(vcpu, INCREMENT_PC);
+	struct kvm_vcpu *target = kvm_adjust_pc_get(vcpu);
+
+	if (!target)
+		return;
+
+	if (vcpu_get_flag(target, PENDING_EXCEPTION)) {
+		kvm_inject_exception(target);
+		vcpu_clear_flag(target, PENDING_EXCEPTION);
+		vcpu_clear_flag(target, EXCEPT_MASK);
+	} else if (vcpu_get_flag(target, INCREMENT_PC)) {
+		kvm_skip_instr(target);
+		vcpu_clear_flag(target, INCREMENT_PC);
 	}
+
+	kvm_adjust_pc_put(vcpu, target);
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index f55950ee2a7e4..a07936f87af83 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -78,4 +78,24 @@ static inline void kvm_skip_host_instr(void)
 	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
 }
 
+/*
+ * Under pKVM, the vCPU __kvm_adjust_pc() adjusts for @vcpu (NULL leaves the
+ * request on @vcpu for its next entry), and the copy of the consumed
+ * PC_UPDATE_REQ back to @vcpu.
+ */
+#ifdef __KVM_NVHE_HYPERVISOR__
+struct kvm_vcpu *kvm_adjust_pc_get(struct kvm_vcpu *vcpu);
+void kvm_adjust_pc_put(struct kvm_vcpu *vcpu, struct kvm_vcpu *target);
+#else
+static inline struct kvm_vcpu *kvm_adjust_pc_get(struct kvm_vcpu *vcpu)
+{
+	return vcpu;
+}
+
+static inline void kvm_adjust_pc_put(struct kvm_vcpu *vcpu,
+				     struct kvm_vcpu *target)
+{
+}
+#endif
+
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 00038a162d09b..2fcd3f8cc8fc4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -644,6 +644,38 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+/*
+ * PKVM_HOST_STATE_DIRTY names the authoritative copy, the host's when set.
+ * A loaded protected vCPU takes the request at its next entry instead.
+ */
+struct kvm_vcpu *kvm_adjust_pc_get(struct kvm_vcpu *vcpu)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+
+	if (!is_protected_kvm_enabled())
+		return vcpu;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || vcpu == &hyp_vcpu->vcpu)
+		return vcpu;
+
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return NULL;
+
+	if (vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))
+		return vcpu;
+
+	vcpu_copy_flag(&hyp_vcpu->vcpu, vcpu, PC_UPDATE_REQ);
+	return &hyp_vcpu->vcpu;
+}
+
+/* Reflect the consumed request back, otherwise it stays pending. */
+void kvm_adjust_pc_put(struct kvm_vcpu *vcpu, struct kvm_vcpu *target)
+{
+	if (target != vcpu)
+		vcpu_copy_flag(vcpu, target, PC_UPDATE_REQ);
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
-- 
2.39.5

