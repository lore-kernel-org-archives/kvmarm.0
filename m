Received: from mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E193A718D
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 09:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278914; cv=none; b=SYwSKQLO4dhcuVcL4oDdnSMX8boPBii8f43Q1lmPQPMNSBlY/I0NCcQ82lWvz4If+fUG2UEXLBTt/wp6LSd6iqE6ss4g5mYRrpoa9+hW3ZIfk+Txo63qlr8IajvjISZn1JleuxhhH4SdVvmhiT8ux3lqx/jaNCpau/V9UpWNI44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278914; c=relaxed/simple;
	bh=v3T3fBb11/yU7ppCqF5TMod7CuvBDECZxjrjNXI8Y9o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q/ucGFHA2wbqg1qtYjJsebxQ1ahAJW9j7eZuBHMR3c6m0ejCwg5ANCzmkl39H8cSLwX5nQg6KmEQEXhUr/eQWE32o/KxE0Umdk5MwfHVpVgl+XUtjJZHLlv1f1sQwgGGpxfIjqKW5nvENwuIws5bijQw/gfX9DokCBVHqVbK1GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PsL7Jxdf; arc=none smtp.client-ip=91.218.175.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PsL7Jxdf"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=v3T3fBb11/yU7ppCqF5TMod7CuvBDECZxjrjNXI8Y9o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791278911; v=1; x=1791883711;
 b=PsL7JxdfWqBr55wQ/rfIOw4yeUv7YZfEcRTuZv6UWuOkukydRyHYSD4gkVKv7DQiedOLNLOz
 z2q2qFK5yPord/fz9SKjajpvJNe5mUsb5ZM5ysIYnWJyCRFF4wL+HfWBbyELn+muClp7s4R6Uza
 OvUfE6wlMvQzBZ5N4MTC+/rc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 913d3b9294e19705;
	Tue, 06 Oct 2026 09:28:30 +0000
X-Mizu-Trace-ID: 913d3b9294e19705
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
	vdonnefort@google.com,
	qperret@google.com,
	mark.rutland@arm.com,
	tabba@google.com
Subject: [PATCH v2] KVM: arm64: Mask SErrors in a protected vCPU's host copy at first run
Date: Tue,  6 Oct 2026 10:28:26 +0100
Message-Id: <20261006092826.2201763-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The host's copy of a protected vCPU has SErrors masked from reset, so a
host-injected SError is pended through HCR_EL2.VSE and the guest takes
it when it unmasks SErrors. However, the VMM can unmask SErrors in that
copy before the first run, through PSTATE.A or SCTLR2_EL1.NMEA. KVM
then emulates the SError's entry on the host copy, and the guest never
takes it as an SError. Exits that copy PSTATE out set PSTATE.A again,
but nothing clears NMEA. With NMEA set, an SError injected after a
KVM_RUN that completes an MMIO access but returns before entering the
guest also trips WARN_ON(INCREMENT_PC).

Mask SErrors in the host copy when the first run creates the hyp vCPU,
after which KVM_SET_ONE_REG is rejected. An SError injected before then
is still emulated, but only writes registers the VMM can set itself.

Fixes: 872383bd12e11 ("KVM: arm64: Add per-EC entry/exit state marshalling for protected guests")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20261001142109.794CA1F000FF@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
v2:
 - Set PSTATE.A and clear SCTLR2_EL1.NMEA in the host copy when the hyp
   vCPU is created, instead of testing vcpu_is_protected() in
   kvm_inject_serror_esr() (Marc).

Applies on kvmarm/next. A follow-up to "KVM: arm64: Confine protected VM
vCPU state to EL2" [1], from Sashiko's review of its v4 patch 12.

v1: https://lore.kernel.org/r/20261005050352.836980-1-fuad.tabba@linux.dev/
[1] https://lore.kernel.org/all/20261001135711.1640520-1-fuad.tabba@linux.dev/

 arch/arm64/kvm/pkvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d4822d8bb16b8..49973c689789f 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -191,12 +191,18 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 	/*
 	 * Mirror EL2's seeding of power_state from mp_state. The hyp vCPU is
 	 * published, so take mp_state_lock against kvm_psci_vcpu_on().
+	 *
+	 * EL2 never reads the VMM's PSTATE or SCTLR2_EL1: undo any unmasking
+	 * so that a host SError is pended through HCR_EL2.VSE.
 	 */
 	if (vcpu_is_protected(vcpu)) {
 		spin_lock(&vcpu->arch.mp_state_lock);
 		if (kvm_arm_vcpu_stopped(vcpu))
 			WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_UNINITIALIZED);
 		spin_unlock(&vcpu->arch.mp_state_lock);
+
+		*vcpu_cpsr(vcpu) |= PSR_A_BIT;
+		__vcpu_rmw_sys_reg(vcpu, SCTLR2_EL1, &=, ~SCTLR2_EL1_NMEA);
 	}
 
 	vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);

base-commit: fa22cd9947fc245d71bc40482f7f78eb0d5a4af0
-- 
2.39.5

