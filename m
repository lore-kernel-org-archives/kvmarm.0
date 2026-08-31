Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FC841D648
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194084; cv=none; b=rAHCr/FWvvd7Tiz3xGGqCFZJJhZCnb5M/1FQTSTBtYOU9TVkpC2RsnCXKs1KwSL/hRIn3iEH7nRQPijMTnlMlYYWdMzLe2FX1egFSeOiX/b8QUkTnxSBphNPbgdomBXthKFAdsn7ZGGtFrB4sWD1zGXFKptjlJ0N6+BFgiCN/ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194084; c=relaxed/simple;
	bh=2sbto41tBk300tVzgzcERGaOKg9olZAVUAA+XHNTpvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QQYPtPCdDtRyMoPyzU0ITa4TPSrqgkxjEK2lmxFbVm1YbSai9PEKbAOudY7OidXOmgWGay73e334wwMBwbAfrMIaOKVIf5jC8Z0aOzwQV+WQSzQJRuVcde2Q5YzcrE8cxKDI+eLr1CEIkmWrp7y+0mnzA8nLpIz/Z9aOYx0xMO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JnfKgDgO; arc=none smtp.client-ip=91.218.175.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JnfKgDgO"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2sbto41tBk300tVzgzcERGaOKg9olZAVUAA+XHNTpvk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194080; v=1; x=1788798880;
 b=JnfKgDgOy7sepHNRkXUMQcVjDb6eTxmR/OcA10Gr3plpf7Jo5aCZMFmFEKxJx6UGAm9eHSie
 4318OCxDGxN/wiDqgoamY40xpZZud98D0D0FAu7VVKOJrnfquaQvelzwsuowm2NxvCEbu0ojxkm
 3TZZ8+TF21WbFQhxJaz8Mm4I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a1d3c5d0688f5f6d;
	Mon, 31 Aug 2026 16:34:40 +0000
X-Mizu-Trace-ID: a1d3c5d0688f5f6d
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
Subject: [PATCH 06/17] KVM: arm64: Add {flush,sync}_hyp_timer_state() primitives
Date: Mon, 31 Aug 2026 17:34:10 +0100
Message-Id: <20260831163421.272420-7-fuad.tabba@linux.dev>
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

From: Marc Zyngier <maz@kernel.org>

A protected guest's virtual timer is programmed from EL2's own copy of
the state and read back there, so the host cannot change the guest's
deadline. cntvoff_el2 is zeroed, so the guest's virtual time is the
physical time.

The flush also preserves the guest's CNTV and CNTP CVAL/CTL across the
host's full-context copy into the hyp vCPU.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 39 ++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 14e847b122abf..d4b0f69ff130c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -154,6 +154,33 @@ static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
 }
 
+static void flush_hyp_timer_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return;
+
+	/* A hyp vcpu has no offset, and sees vtime == ptime. */
+	write_sysreg(0, cntvoff_el2);
+	write_sysreg_el0(__vcpu_sys_reg(&hyp_vcpu->vcpu, CNTV_CVAL_EL0),
+			 SYS_CNTV_CVAL);
+	isb();
+	write_sysreg_el0(__vcpu_sys_reg(&hyp_vcpu->vcpu, CNTV_CTL_EL0),
+			 SYS_CNTV_CTL);
+}
+
+static void sync_hyp_timer_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return;
+
+	/*
+	 * Preserve the vtimer state so that it is always correct,
+	 * even if the host tries to make a mess.
+	 */
+	__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, CNTV_CVAL_EL0, read_sysreg_el0(SYS_CNTV_CVAL));
+	__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, CNTV_CTL_EL0, read_sysreg_el0(SYS_CNTV_CTL));
+}
+
 static void __copy_vcpu_state(const struct kvm_vcpu *from_vcpu,
 			      struct kvm_vcpu *to_vcpu)
 {
@@ -249,7 +276,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
 		flush_debug_state(hyp_vcpu);
 	} else {
+		u64 v_cval = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CVAL_EL0];
+		u64 v_ctl = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CTL_EL0];
+		u64 p_cval = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CVAL_EL0];
+		u64 p_ctl = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CTL_EL0];
+
 		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
+
+		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CVAL_EL0] = v_cval;
+		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CTL_EL0] = v_ctl;
+		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CVAL_EL0] = p_cval;
+		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CTL_EL0] = p_ctl;
 	}
 
 	/* __hyp_running_vcpu must be NULL in a guest context. */
@@ -264,6 +301,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.vsesr_el2 = host_vcpu->arch.vsesr_el2;
 
 	flush_hyp_vgic_state(hyp_vcpu);
+	flush_hyp_timer_state(hyp_vcpu);
 
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 
@@ -313,6 +351,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 	host_vcpu->arch.hcr_el2 |= hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VSE;
 
 	sync_hyp_vgic_state(hyp_vcpu);
+	sync_hyp_timer_state(hyp_vcpu);
 
 	hyp_vcpu->exit_code = exit_reason;
 }
-- 
2.39.5

