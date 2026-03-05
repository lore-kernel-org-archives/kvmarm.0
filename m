Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46F37BE81
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721944; cv=none; b=klfcs7zQhI1o2gxs8AxhciV5SLgiogmi0VsPWh52SHWoiRTg00U+xttGWhtf6npdDDNzhSoxbHbD/s9Nc/e1aeK23R3CFRpXCrVmY+KpWVidMjnyn3aLmFeIMhb0sMcg3vIQ9fmsIJMdeSs7Mp4ytDBfAkgD0JCPU/lVpz6Fdj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721944; c=relaxed/simple;
	bh=A0gsw+S7d26oFSbb4t0/obkO9fbZRmAPdY9H7qyJ5Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZkam5D8BhOIKxLhPYKx61p5TA1ywS+ZnLxnsB6l3NR23xqhCc6xEFWRJNPlweqUkH15ow3YjBcZiPxsd/Vyz9VfQWRfPz84MeXjilNXX3DMszy9iF1Mp9tB8VLAYE1TP9quCqPNjCIlaY76dX836ocIm0IyQ6TXRBPFnzgB8tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hoX6ABhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hoX6ABhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E58C19423;
	Thu,  5 Mar 2026 14:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721944;
	bh=A0gsw+S7d26oFSbb4t0/obkO9fbZRmAPdY9H7qyJ5Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoX6ABhzuxWAqaWusGAhOeqENN/xpQ13hMEqqSVpmns03veeWshSJUrTgIK4p83rG
	 MzIx4bcd+CVDSTsg/KN91X95GOzoxKeo4M2Qhbjq1poelmC8g8NMKzwjTYVO2ynKSK
	 nO+XmU9tFm3rnVljrWZhxzjVRewKTYGNKYLdQg18F3Q7xSzfP57pp5mXvSsJmWw4ty
	 YvthnExa6UsI3ZI3CjwvtXp0ydFknpzmM4pcG64MSPeHvNprZfZQ0PmVxsWZdt8cX3
	 sQfC0y5NKxnTa++4Qcll3hju62GXtUi4/BgUTceTYreRKHvwaOUobs39Z3v3x1w7VU
	 lIaArBKe44iQg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 27/36] KVM: arm64: Add hvc handler at EL2 for hypercalls from protected VMs
Date: Thu,  5 Mar 2026 14:43:40 +0000
Message-ID: <20260305144351.17071-28-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a hypercall handler at EL2 for hypercalls originating from protected
VMs. For now, this implements only the FEATURES and MEMINFO calls, but
subsequent patches will implement the SHARE and UNSHARE functions
necessary for virtio.

Unhandled hypercalls (including PSCI) are passed back to the host.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 37 ++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c       |  1 +
 3 files changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index a5a7bb453f3e..c904647d2f76 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -88,6 +88,7 @@ struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle);
 struct pkvm_hyp_vm *get_np_pkvm_hyp_vm(pkvm_handle_t handle);
 void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm);
 
+bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 5269ac20d2fb..8b32bf37acc3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -4,6 +4,8 @@
  * Author: Fuad Tabba <tabba@google.com>
  */
 
+#include <kvm/arm_hypercalls.h>
+
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 
@@ -965,3 +967,38 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 	return err;
 }
+/*
+ * Handler for protected VM HVC calls.
+ *
+ * Returns true if the hypervisor has handled the exit (and control
+ * should return to the guest) or false if it hasn't (and the handling
+ * should be performed by the host).
+ */
+bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
+	bool handled = true;
+
+	switch (smccc_get_function(vcpu)) {
+	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
+		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
+		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
+		if (smccc_get_arg1(vcpu) ||
+		    smccc_get_arg2(vcpu) ||
+		    smccc_get_arg3(vcpu)) {
+			break;
+		}
+
+		val[0] = PAGE_SIZE;
+		break;
+	default:
+		/* Punt everything else back to the host, for now. */
+		handled = false;
+	}
+
+	if (handled)
+		smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
+	return handled;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 779089e42681..51bd88dc6012 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -190,6 +190,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 
 static const exit_handler_fn pvm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_HVC64]		= kvm_handle_pvm_hvc64,
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
 	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
-- 
2.53.0.473.g4a7958ca14-goog

