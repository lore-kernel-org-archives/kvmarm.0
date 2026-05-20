Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C027237703A;
	Wed, 20 May 2026 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779267055; cv=none; b=UbHc6f+jC7hk6qBLt4hvlThA7x0dAAPrVz27sYMlknmC0hGVwwUNR65F/hbiUlIcjtk4J0GrMMzG70W+UzHTRl7WdWFbClYkpQPvWDQUqvvhbyXVaoCGuaERSS2U3g2eip++KfgWUSQMqJ0moWYFNw4yg/q6Gxnkkk3db+1CW0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779267055; c=relaxed/simple;
	bh=L8ysmDjgLMJlwRCyF6CPt2pcHQpzkX/qmyB/HHBDAlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EugGJ5NlqemR1kgA5aGYp2yYm6DkfzjvytD2Tk7lBqkcEVxTtJdsku6yYVq+4jL8Rjj+ipR8NJZwEnnjsIXCrHCZyPGs9XTn9bAQkvl2Dao9uZWTBgGgWiEBlgXaUFQp1Vo/gctiKqvL9A72p6i/+6PR2t2z/zuMtoKAIjva1fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DP2QoG3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DP2QoG3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E721F0089A;
	Wed, 20 May 2026 08:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779267053;
	bh=9B6Ly6mVvTc9aFU/qVyydDvT1sySEiT+OWzALeLP+aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DP2QoG3hYSUW73110LbBQN0CFXn6/TJDoG6IJKLcR/dsiNzjl7ldzVqdAT69XE5Vv
	 wXjlNv/UrpN0OrdITh9g+vpuTZ+rjraolnrdRXYmHT7bSUSrwPpnGKEviLk3kDJyXf
	 gGhDVR1AwsQYhzz/iRRpoBhfZW0ncVnbrqc2AJKvotJEB7q52/l1jiDG9Bd/cEbKGg
	 AzHgo1l4WFB6c6HOcjyY7F+Is7EoN8fxBitVL6BD74MFaiRWhdZZqiB0kJL55rZll7
	 q7n/qIR37PhCBralb1fV5csc2WX32funtVwS2o6Btis0u6n8hW9nC2hmrBQklMo65j
	 Z4ZWz3Tux55uQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPcdf-00000004Hno-35LD;
	Wed, 20 May 2026 08:50:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: nv: Don't save/restore FP register during a nested ERET or exception
Date: Wed, 20 May 2026 09:50:36 +0100
Message-ID: <20260520085036.541666-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520085036.541666-1-maz@kernel.org>
References: <20260520085036.541666-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, mark.rutland@arm.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When switching between L1 and L2, we save the old state using
kvm_arch_vcpu_put(), mutate the state in memory, then load the new
state using kvm_arch_vcpu_load(). Any live FPSIMD/SVE state is saved
and unbound, such that it can be lazily restored on a subsequent trap.

The FPSIMD/SVE state is shared by exception levels, and only a handful
of related control registers need to be changed when transitioning
between L1 and L2. The save/restore of the common state is needless
overhead, especially as trapping becomes exponentially more expensive
with nesting.

Avoid this overhead by leaving the common FPSIMD/SVE state live on the
CPU, and only switching the state that is distinct for L1 and L2:

- the trap controls: the effective values are recomputed on each entry
  into the guest to take the EL into account and merge the L0 and L1
  configuration if in a nested context, or directly use the L0 configuration
  in non-nested context (see __activate_traps()).

- the VL settings: the effective values are are also recomputed on each
  entry into the guest (see fpsimd_lazy_switch_to_guest()).

Since we appear to cover all bases, use the vcpu flags indicating the
handling of a nested ERET or exception delivery to avoid the whole FP
save/restore shenanigans. SME will have to be similarly dealt with when
it eventually gets supported.

For an EL1 L3 guest where L1 and L2 have this optimisation, this
results in at least a 10% wall clock reduction when running an I/O
heavy workload, generating a high rate of nested exceptions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 15e17aca1dec0..aca98752a6e42 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -28,6 +28,20 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	if (!system_supports_fpsimd())
 		return;
 
+	/*
+	 * Avoid needless save/restore of the guest's common
+	 * FPSIMD/SVE/SME regs during transitions between L1/L2.
+	 *
+	 * These transitions only happens in a non-preemptible context
+	 * where the host regs have already been saved and unbound. The
+	 * live registers are either free or owned by the guest.
+	 */
+	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
+	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION)) {
+		WARN_ON_ONCE(host_owns_fp_regs());
+		return;
+	}
+
 	/*
 	 * Ensure that any host FPSIMD/SVE/SME state is saved and unbound such
 	 * that the host kernel is responsible for restoring this state upon
@@ -102,6 +116,15 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
+	/*
+	 * See comment in kvm_arch_vcpu_load_fp().
+	 */
+	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
+	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION)) {
+		WARN_ON_ONCE(host_owns_fp_regs());
+		return;
+	}
+
 	local_irq_save(flags);
 
 	if (guest_owns_fp_regs()) {
-- 
2.47.3

