Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F471D5AAD
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738081052; cv=none; b=Pask1KXFMzs/ooZWFtWmcObd2yIFhtYAhpgDhczbovO4PoRMFylMBL5T/Cg9I1E1G1F5OGvsD1iRjkkD64IVrx8MHwueeYsHPpaFmzWXKnKER4/tzmiIGwb+ZzB9JOpFggvGTJZ0/UW1UEx4wJbuw//dhYvYmbztxJO35iZxJ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738081052; c=relaxed/simple;
	bh=VQtqCF5VwxQZ3zUdT5Ya9xq6VhdkLVv1Fj7Qtdf+K5E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nVNMSUonyZMuHmZ4NTYY9tFJDFkkE7tgQKMW4kT2i2VH8XoLjNnwIjRghTjpjUe4P8e+UUxBuBlH8+I0CB1R62prAfSP0S74dUKd2CI+SkdL53VXSuc8lMeyA/w5sfS8r4D4Ol+kjo5DK5LwAvN9ZsiqXys2cqIwjYBo+HWM9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cw9h1ude; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cw9h1ude"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5003FC4CEE3;
	Tue, 28 Jan 2025 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738081052;
	bh=VQtqCF5VwxQZ3zUdT5Ya9xq6VhdkLVv1Fj7Qtdf+K5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cw9h1ude8ichfU8pcmw7OAiZfaNagCoGoYZREWS4HpvZEGGI0qDuFO+sQPwwtxy7Q
	 hkgTadm12wz5FNDARPJabzg5QTRWgBQnjELR4unV23s9IaTj+qXeWV709zrRwphqYg
	 Qw5MPLPI9HnZEB2tFYYcLzlg7NvidctOk7EjL1LKDcppNYyw8ghvtwUikpilXaEGUh
	 /q5VOnJCzi3JTJM1mTO1zJU38lqDaqsDwiIQMMcfy32KVjdf5sl6k9zsYc9/8e3ANr
	 h91f/RWl6oM0aYt0Ns3uY06gHtO8ApmbXDc5IuOpY3aWcf3rVu+KMVsLag4rE6K8da
	 /wstY9Vd9s+Ag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tcoHK-00G6bi-FP;
	Tue, 28 Jan 2025 16:17:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: timer: Consolidate NV configuration of virtual timers
Date: Tue, 28 Jan 2025 16:17:21 +0000
Message-Id: <20250128161721.3279927-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250128161721.3279927-1-maz@kernel.org>
References: <20250128161721.3279927-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, r09922117@csie.ntu.edu.tw, Volodymyr_Babchuk@epam.com, Dmytro_Terletskyi@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The way we configure the virtual timers with NV is rather odd:

- the EL1 virtual timer gets setup in kvm_timer_vcpu_reset(). Why not?

- the EL2 virtual timer gets setup at vcpu_load time, which is really
  bizarre, because this really should be a one-off.

The reason for the second point is that this setup is conditionned
on HCR_EL2.E2H, as it decides whether CNTVOFF_EL2 applies to the
EL2 virtual counter or not. And of course, this is not known at
the point where we reset the timer. Huh.

Solve this by introducing a NV-specific init for the timers,
matching what we do for the other subsystems, that gets called
once we know for sure that the configuration is final (on first
vcpu run, effectively).

This makes kvm_timer_vcpu_load_nested_switch() slightly simpler.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 48 ++++++++++++++++--------------------
 arch/arm64/kvm/arm.c         |  3 +++
 include/kvm/arm_arch_timer.h |  1 +
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index e59836e0260cf..43109277281a7 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -759,21 +759,6 @@ static void kvm_timer_vcpu_load_nested_switch(struct kvm_vcpu *vcpu,
 					    timer_irq(map->direct_ptimer),
 					    &arch_timer_irq_ops);
 		WARN_ON_ONCE(ret);
-
-		/*
-		 * The virtual offset behaviour is "interesting", as it
-		 * always applies when HCR_EL2.E2H==0, but only when
-		 * accessed from EL1 when HCR_EL2.E2H==1. So make sure we
-		 * track E2H when putting the HV timer in "direct" mode.
-		 */
-		if (map->direct_vtimer == vcpu_hvtimer(vcpu)) {
-			struct arch_timer_offset *offs = &map->direct_vtimer->offset;
-
-			if (vcpu_el2_e2h_is_set(vcpu))
-				offs->vcpu_offset = NULL;
-			else
-				offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
-		}
 	}
 }
 
@@ -1045,18 +1030,6 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	for (int i = 0; i < nr_timers(vcpu); i++)
 		timer_set_ctl(vcpu_get_timer(vcpu, i), 0);
 
-	/*
-	 * A vcpu running at EL2 is in charge of the offset applied to
-	 * the virtual timer, so use the physical VM offset, and point
-	 * the vcpu offset to CNTVOFF_EL2.
-	 */
-	if (vcpu_has_nv(vcpu)) {
-		struct arch_timer_offset *offs = &vcpu_vtimer(vcpu)->offset;
-
-		offs->vcpu_offset = &__vcpu_sys_reg(vcpu, CNTVOFF_EL2);
-		offs->vm_offset = &vcpu->kvm->arch.timer_data.poffset;
-	}
-
 	if (timer->enabled) {
 		for (int i = 0; i < nr_timers(vcpu); i++)
 			kvm_timer_update_irq(vcpu, false,
@@ -1102,6 +1075,27 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 	}
 }
 
+void kvm_timer_vcpu_nv_init(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * A vcpu running at EL2 is in charge of the offset applied to
+	 * the virtual timer, so use the physical VM offset, and point
+	 * the vcpu offset to CNTVOFF_EL2.
+	 *
+	 * The virtual offset behaviour is "interesting", as it always
+	 * applies when HCR_EL2.E2H==0, but only when accessed from EL1 when
+	 * HCR_EL2.E2H==1. Apply it to the HV timer when E2H==0.
+	 */
+	struct arch_timer_offset *offs = &vcpu_vtimer(vcpu)->offset;
+	u64 *voff = __ctxt_sys_reg(&vcpu->arch.ctxt, CNTVOFF_EL2);
+
+	offs->vcpu_offset = voff;
+	offs->vm_offset = &vcpu->kvm->arch.timer_data.poffset;
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		vcpu_hvtimer(vcpu)->offset.vcpu_offset = voff;
+}
+
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0725a0b50a3e9..deb74ab5775aa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -815,6 +815,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+	if (vcpu_has_nv(vcpu))
+		kvm_timer_vcpu_nv_init(vcpu);
+
 	/*
 	 * This needs to happen after any restriction has been applied
 	 * to the feature set.
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 681cf0c8b9df4..351813133aef6 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -98,6 +98,7 @@ int __init kvm_timer_hyp_init(bool has_gic);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
+void kvm_timer_vcpu_nv_init(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_user(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
-- 
2.39.2

