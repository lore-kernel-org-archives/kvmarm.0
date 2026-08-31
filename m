Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A189C49EC67
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194085; cv=none; b=oUMWQhnLig482csnkNH+yUGmc5PEegUR3XYPg408udHGZ8TafSXifDruCpMJIewxQsxBzfnpeR/FaB9YevyquT0TIWUc+xnsH9ZnPkzYsu4/hMs7BOv1O/LGKljkQ8G7onv/1XBnQyfHseW3dZqXDyby8tmxUx3oQDNtUXIjJ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194085; c=relaxed/simple;
	bh=llHVSBDbIpHVrNbVZKpBn9aInJeZ47+2NBcLRjFcajA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mu16ItTAcKNIgHoMdb6ask82UBC8b6nDvuD4cECQkdMdSK49bRmbD9fCqDg6QRsCyFbJLqxBwqKQWGFHyHsVs39KPwQY665BWS5cGtWxuVEJ766N+Dd2kFPKlZSPPVu1SKBxaEluiljK8MCxHpkTPtoutU96TNr78iFxTmU8mmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kq179Bi5; arc=none smtp.client-ip=95.215.58.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kq179Bi5"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=llHVSBDbIpHVrNbVZKpBn9aInJeZ47+2NBcLRjFcajA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194081; v=1; x=1788798881;
 b=Kq179Bi5hJyn88Sg2Yfsx2XrXNfIJQS1kZNKKOuoQjqiXr77clvA0GoliK/heBXFvNNvb9Ie
 m/Rmt2tefSTltkhWH3z8pM2qwCXhfg3/hUABvCWuP9yuVz6G2W2xi3zEzrkSI9TYOsxR/1JBs/G
 YdQagc00xmFEiwE6fZUPAtsc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f7553cf9231fffe6;
	Mon, 31 Aug 2026 16:34:41 +0000
X-Mizu-Trace-ID: f7553cf9231fffe6
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
Subject: [PATCH 08/17] KVM: arm64: Implement HVC handling for protected guests at EL2
Date: Mon, 31 Aug 2026 17:34:12 +0100
Message-Id: <20260831163421.272420-9-fuad.tabba@linux.dev>
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

Extend kvm_handle_pvm_hvc64() to handle SMCCC_VERSION,
SMCCC_ARCH_FEATURES and the vendor hypervisor call UID at EL2, so
these queries do not reach the host. ARCH_FEATURES is mandatory from
SMCCC 1.1, the version EL2 reports: it returns SUCCESS for itself and
for SMCCC_VERSION, and NOT_SUPPORTED for anything else.

Add handle_pvm_entry_hvc64() and handle_pvm_exit_hvc64(), which
forward a protected guest's HVCs to the host and return the reply; a
later patch wires them into the per-EC dispatch tables.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 28 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 29 +++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d4b0f69ff130c..62864db1e099a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,6 +4,8 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
+#include <kvm/arm_hypercalls.h>
+
 #include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
@@ -33,6 +35,32 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
 
+static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		u64 ret =
+			READ_ONCE(hyp_vcpu->host_vcpu->arch.ctxt.regs.regs[i]);
+		vcpu_set_reg(&hyp_vcpu->vcpu, i, ret);
+	}
+}
+
+static void __maybe_unused handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	int i;
+
+	WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
+		   hyp_vcpu->vcpu.arch.fault.esr_el2);
+
+	/* Pass the HVC function id (r0) and its arguments. */
+	for (i = 0; i < 8; i++) {
+		WRITE_ONCE(host_vcpu->arch.ctxt.regs.regs[i],
+			   vcpu_get_reg(&hyp_vcpu->vcpu, i));
+	}
+}
+
 static void handle_vm_entry_generic(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	vcpu_copy_flag(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu, PC_UPDATE_REQ);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index af334318d0a03..0fe11f95e2e26 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1144,8 +1144,37 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
 	bool handled = true;
+	u32 feature;
+	uuid_t uuid;
 
 	switch (smccc_get_function(vcpu)) {
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		/* Nothing to be handled by the host. Go back to the guest. */
+		val[0] = ARM_SMCCC_VERSION_1_1;
+		val[1] = 0;
+		val[2] = 0;
+		val[3] = 0;
+		break;
+	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+		/* SUCCESS only for the architecture calls EL2 implements. */
+		feature = smccc_get_arg1(vcpu);
+		switch (feature) {
+		case ARM_SMCCC_VERSION_FUNC_ID:
+		case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+			val[0] = SMCCC_RET_SUCCESS;
+			break;
+		default:
+			val[0] = SMCCC_RET_NOT_SUPPORTED;
+			break;
+		}
+		break;
+	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
+		uuid = ARM_SMCCC_VENDOR_HYP_UID_KVM;
+		val[0] = smccc_uuid_to_reg(&uuid, 0);
+		val[1] = smccc_uuid_to_reg(&uuid, 1);
+		val[2] = smccc_uuid_to_reg(&uuid, 2);
+		val[3] = smccc_uuid_to_reg(&uuid, 3);
+		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
-- 
2.39.5

