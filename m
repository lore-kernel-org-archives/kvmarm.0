Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C9E31A89
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 00:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740444860; cv=none; b=SN15RNXbu5XqVjv9fZ19rv8491yWXtygcH8VwcOHnMag3qmOOFEyk+MpHOQctN2Tf/78t6E3ktycL6ayzpS0AawxsmuQyfwn9nuA4WZ0mXGbBcVzNAA2YgK3xzqBR0imtlJcygrMz+gR+18FTAPrmVWBVjpTACtEty3Rim5bDVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740444860; c=relaxed/simple;
	bh=kbzVxBHERXhmFA4rPaD5Ciic7+4ApQfi1QHxFauMj54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=okaNOGtEs5R3Z5XHXLY/JlKtUc3J0RvADiuwMSRqT1f/SoYKN2dcZ6gI24GYCIXnmz4/DM9w8ILu7rgPqU4GraXw99ld/yQkvWGr6q+4CplkSM8lIVdcm741MPcP5XjUAhkn1nMK5rwniYHeR9folluIezWgczSRU3Vjjx4aIJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aZywtJQc; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aZywtJQc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740444857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4u5aO5ixUbcJsSky7y8P7F36pro8YcVt4SzFHlfx2p8=;
	b=aZywtJQcyDqj2CyV27W5tDaCqSZdZd8dsmkgpkeifHAepeh31B02PVNNPbXBcyH5D0IlNc
	K2vxXSUFSVKsJ6LU27cAv/xqX5N6M1ZVyYp+u1HmToFVjgUY/mlnMjSkv1U/p0V3TGOhqK
	cH/XWDABxzSafUvJjLoLsceLXW2umdI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 3/5] KVM: arm64: Load VPIDR_EL2 with the VM's MIDR_EL1 value
Date: Mon, 24 Feb 2025 16:53:59 -0800
Message-Id: <20250225005401.679536-4-oliver.upton@linux.dev>
In-Reply-To: <20250225005401.679536-1-oliver.upton@linux.dev>
References: <20250225005401.679536-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Userspace will soon be able to change the value of MIDR_EL1. Prepare by
loading VPIDR_EL2 with the guest value for non-nested VMs.

Since VPIDR_EL2 is set for any VM, get rid of the NV-specific cleanup of
reloading the hardware value on vcpu_put(). And for nVHE, load the
hardware value before switching to the host.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  8 ++++++-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |  4 +++-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 28 ++++++++--------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 76ff095c6b6e..6e6d13580377 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -43,6 +43,11 @@ static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
 	return &ctxt_sys_reg(ctxt, MDSCR_EL1);
 }
 
+static inline u64 ctxt_midr_el1(struct kvm_cpu_context *ctxt)
+{
+	return read_cpuid_id();
+}
+
 static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
 	*ctxt_mdscr_el1(ctxt)	= read_sysreg(mdscr_el1);
@@ -168,8 +173,9 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 }
 
 static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
-					      u64 mpidr)
+					      u64 midr, u64 mpidr)
 {
+	write_sysreg(midr,				vpidr_el2);
 	write_sysreg(mpidr,				vmpidr_el2);
 
 	if (has_vhe() ||
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
index dba101565de3..3cc613cce5f5 100644
--- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -28,7 +28,9 @@ void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_el1_state(ctxt, ctxt_sys_reg(ctxt, MPIDR_EL1));
+	u64 midr = ctxt_midr_el1(ctxt);
+
+	__sysreg_restore_el1_state(ctxt, midr, ctxt_sys_reg(ctxt, MPIDR_EL1));
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 90b018e06f2c..3814b0b2c937 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -87,11 +87,12 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 	write_sysreg(__vcpu_sys_reg(vcpu, PAR_EL1),	par_el1);
 	write_sysreg(__vcpu_sys_reg(vcpu, TPIDR_EL1),	tpidr_el1);
 
-	write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),		vmpidr_el2);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),	SYS_MAIR);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),	SYS_VBAR);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),	SYS_CONTEXTIDR);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),	SYS_AMAIR);
+	write_sysreg(ctxt_midr_el1(&vcpu->arch.ctxt),			vpidr_el2);
+	write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),			vmpidr_el2);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),		SYS_MAIR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),		SYS_VBAR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),		SYS_CONTEXTIDR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),		SYS_AMAIR);
 
 	if (vcpu_el2_e2h_is_set(vcpu)) {
 		/*
@@ -191,7 +192,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
-	u64 mpidr;
+	u64 midr, mpidr;
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	__sysreg_save_user_state(host_ctxt);
@@ -220,23 +221,18 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 		__sysreg_restore_vel2_state(vcpu);
 	} else {
 		if (vcpu_has_nv(vcpu)) {
-			/*
-			 * Use the guest hypervisor's VPIDR_EL2 when in a
-			 * nested state. The hardware value of MIDR_EL1 gets
-			 * restored on put.
-			 */
-			write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2), vpidr_el2);
-
 			/*
 			 * As we're restoring a nested guest, set the value
 			 * provided by the guest hypervisor.
 			 */
+			midr = ctxt_sys_reg(guest_ctxt, VPIDR_EL2);
 			mpidr = ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
 		} else {
+			midr = ctxt_midr_el1(guest_ctxt);
 			mpidr = ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
 		}
 
-		__sysreg_restore_el1_state(guest_ctxt, mpidr);
+		__sysreg_restore_el1_state(guest_ctxt, midr, mpidr);
 	}
 
 	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
@@ -271,9 +267,5 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
-	/* If leaving a nesting guest, restore MIDR_EL1 default view */
-	if (vcpu_has_nv(vcpu))
-		write_sysreg(read_cpuid_id(),	vpidr_el2);
-
 	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
 }
-- 
2.39.5

