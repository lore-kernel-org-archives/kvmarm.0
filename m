Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C414035FF55
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826896; cv=none; b=i/jVRCaM6jIEEs6B87v/ZCV0MJXurnoPw4H1wxijm9YkxZSKiOA+aVceVE0iWkKTUp6pxiXhBa1uU/q3ux70cHIXjmK2sVA1zXy7Excuf2ATyTFnUOhUHiDBpPQKMJuDlcQbqGecxND6Q1jYOyO0DC9iEP5qq/IdxojBtzhOK+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826896; c=relaxed/simple;
	bh=tKUZCWGr3FuK7gXLAtk5AO5IsKzLGm0ZPhIWm+pvo4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRLSwBPuE3yEdwYLWMolyV3svvgZ0VwVjXXS7fmHSPEjhKlqdSgECZcwl4k70IERwE7JpNlYNZmBF1/DuY0OCChJsMkoQkPrLMgoyftqVw5UUA5ZynPjUWkcUwKyHoOLgUWii+WzQNoAiXxWI+bYycUswx6Wir5u7MHHJZ+MJSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+V6I0sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+V6I0sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF63DC19424;
	Mon, 19 Jan 2026 12:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826896;
	bh=tKUZCWGr3FuK7gXLAtk5AO5IsKzLGm0ZPhIWm+pvo4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+V6I0sr2GOpkNlyv9ugWoM3PsKQ6lrMNbFkJ1YdIzjce1O/VlJSOpEYF4hJwn3M5
	 DviIxehxZiKSklGZ1Eih9CuUdGO0Naz1WdKXz0w+wYmnSm6FVhAbvcuCBpNMUaG9L/
	 KyCPqzjBO/6d4i7tL0RSc7ebKAsuSGoI8axRG4kohuX2L6wuiqDFFb4Mg5MQ+5EdrQ
	 e2ckMMiY2gZLCNrqGrF732SAzlG9mA3lgSbIa1DGgkk7jnIKyxg157JMZgTP0vNnW0
	 9VpI2wQqYbTi2t/Aua2QyytoKs25/empzy+ZdCy8xIisxKz1fBNsLvKHg+z5nS0Yr+
	 Hc0InBiW/pGSw==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 27/35] KVM: arm64: Add hvc handler at EL2 for hypercalls from protected VMs
Date: Mon, 19 Jan 2026 12:46:20 +0000
Message-ID: <20260119124629.2563-28-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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
index 2836c68c1ea5..64171e04ea82 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -4,6 +4,8 @@
  * Author: Fuad Tabba <tabba@google.com>
  */
 
+#include <kvm/arm_hypercalls.h>
+
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 
@@ -935,3 +937,38 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
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
index d3b9ec8a7c28..b62e25e8bb7e 100644
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
2.52.0.457.g6b5491de43-goog

