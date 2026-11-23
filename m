Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461923;
	b=VwC/J+0uJGu+RGrHMlgFDswl98fa86ANeLhLWct+KG8QyX8dCplCJ5mSd57xKulCA2oN
	 q/RymKMvncnwDYRqKyUrp0+ZlhaHAlnhrWe2CVauR53XHpdhLA6bRCghR3jeBsmX7Ny2s
	 6YK7DbIgcTO4fwREGawk3wQiBTnNi5KzyTQJOiP0lgvelBZ3B8BePy8SvNlfXCuD/w7dl
	 8ZJTL0zbQaEQwis5nYPgl2/9HT9FFiwL6436n9RLWSM8I/1wM1QcMtdrPjxe84OW/LnDU
	 ryQwVsVa79autLDlNQxMcy5rDTMBCg53fXRZv5CD8hXHHZ8h3sQ6oywbfn0eW4Iul/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461923;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=BFhYmS3lF+XBG7GlA3KpWFp5tO2SjJoboEtR4nWrvcs=;
	b=LOm5nlrzI3HkfrssZRTan4bjBIhn4G71ch5jpq485u/nr70OyImTaxXGKhCkfJRA3XE0
	 qP29+y2jmvjAp5PWs++zWHGKYu8X4AYGGSZsFHXE9QuBR0nLiHSH+HZFxXr+T3Uj85h6T
	 z4nWhS4MLxVC3cl31JJp+ZTK/OUkekGQLS5DKeSGzeOpfNyM5dy4Nn4eW7XJJTN+/B15l
	 f+z2y1C7ARfMUcLhBGm5kNUNDMzWuHRq0esCVrVq1QZjqZfHxcHCI0zNVm3uEBZcS6thG
	 NhlDq2c36UkZNbIZpu3gUwzBY6tK0NvUIzua3Hwb1CRb3XfN3PWBP41oBkCkFCgKKXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L5YgBkR+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1AB606A31A;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L5YgBkR+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7294C1F000E0;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795461923;
	bh=BFhYmS3lF+XBG7GlA3KpWFp5tO2SjJoboEtR4nWrvcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5YgBkR+VrmeyzgAZ3he/DIjkd0SE8JFs6tCuHUcfQ4nGLfMqmzRs+JwPfl2Qa6dU
	 cA2+9MoIbNqRjOJOxOwHCG/0E2kZhUNZ7ehLJ4yu7b7thA1evlipDM7J6XlyTPxKyU
	 kkTQxwv6VwQc1G7QEK2AEejh0qJUEmaCX36RTM/y9sJOlXLyW89CXrVJQEDhUB9gpF
	 klKyO2YmOyXlrGWMt/tZiPuYU9O7ofEFQlCqwU8Bd7qBvBIpT2OCdpzRrVXZwxlxFF
	 42l8F641voaBYdq3gG8yhtRWIIbaYTs20mGJc6vRcuQ4F6QOQetaR1OjZbhJOL0yHl
	 7K+mY46wnrbOQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xVZfF-00000002A6V-2yEk;
	Mon, 23 Nov 2026 19:25:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Drop open-coded GIC idreg sanitisation
Date: Mon, 23 Nov 2026 19:24:57 +0000
Message-ID: <20261123192457.8700-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123192457.8700-1-maz@kernel.org>
References: <20261123192457.8700-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have a generic mechanism to sanitise the GIC idregs,
drop the open-coded version and replace it with a call to the
new code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c       | 45 ---------------------------------
 arch/arm64/kvm/vgic/vgic-init.c | 31 +----------------------
 include/kvm/arm_vgic.h          |  1 -
 3 files changed, 1 insertion(+), 76 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0687b78cd7c2b..d145541420b3a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5874,51 +5874,6 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 
 	kvm_idregs_enforce_dependencies(kvm);
 
-	/*
-	 * This hacks into the ID registers, so only perform it when the
-	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.
-	 */
-	if (!irqchip_in_kernel(kvm)) {
-		u64 val;
-
-		val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
-		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
-		val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_EL1_GCIE;
-		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, val);
-		val = kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
-		kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, val);
-	} else {
-		/*
-		 * Certain userspace software - QEMU - samples the system
-		 * register state without creating an irqchip, then blindly
-		 * restores the state prior to running the final guest. This
-		 * means that it restores the virtualization & emulation
-		 * capabilities of the host system, rather than something that
-		 * reflects the final guest state. Moreover, it checks that the
-		 * state was "correctly" restored (i.e., verbatim), bailing if
-		 * it isn't, so masking off invalid state isn't an option.
-		 *
-		 * On GICv5 hardware that supports FEAT_GCIE_LEGACY we can run
-		 * both GICv3- and GICv5-based guests. Therefore, we initially
-		 * present both ID_AA64PFR0.GIC and ID_AA64PFR2.GCIE as IMP to
-		 * reflect that userspace can create EITHER a vGICv3 or a
-		 * vGICv5. This is an architecturally invalid combination, of
-		 * course. Once an in-kernel GIC is created, the sysreg state is
-		 * updated to reflect the actual, valid configuration.
-		 *
-		 * Setting both the GIC and GCIE features to IMP unsurprisingly
-		 * results in guests falling over, and hence we need to fix up
-		 * this mess in KVM. Before running for the first time we yet
-		 * again ensure that the GIC and GCIE fields accurately reflect
-		 * the actual hardware the guest should see.
-		 *
-		 * This hack allows legacy QEMU-based GICv3 guests to run
-		 * unmodified on compatible GICv5 hosts, and avoids the inverse
-		 * problem for GICv5-based guests in the future.
-		 */
-		kvm_vgic_finalize_idregs(kvm);
-	}
-
 	set_bit(KVM_ARCH_FLAG_ID_REGS_FINAL, &kvm->arch.flags);
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index c9991e24cb6b7..b6236146602d8 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -180,7 +180,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	 * We've now created the GIC. Update the system register state
 	 * to accurately reflect what we've created.
 	 */
-	kvm_vgic_finalize_idregs(kvm);
+	kvm_idregs_enforce_dependencies(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret = vgic_allocate_private_irqs_locked(vcpu, type);
@@ -770,35 +770,6 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	return ret;
 }
 
-void kvm_vgic_finalize_idregs(struct kvm *kvm)
-{
-	u32 type = kvm->arch.vgic.vgic_model;
-	u64 aa64pfr0, aa64pfr2, pfr1;
-
-	aa64pfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
-	aa64pfr2 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_EL1_GCIE;
-	pfr1 = kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
-
-	switch (type) {
-	case KVM_DEV_TYPE_ARM_VGIC_V2:
-		break;
-	case KVM_DEV_TYPE_ARM_VGIC_V3:
-		aa64pfr0 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
-		if (kvm_supports_32bit_el0())
-			pfr1 |= SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
-		break;
-	case KVM_DEV_TYPE_ARM_VGIC_V5:
-		aa64pfr2 |= SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
-		break;
-	default:
-		WARN_ONCE(1, "Unknown VGIC type!!!\n");
-	}
-
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
-	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
-}
-
 /* GENERIC PROBE */
 
 void kvm_vgic_cpu_up(void)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4b2c41917b77c..956c68f75e7c0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -689,7 +689,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vgic_map_resources(struct kvm *kvm);
-void kvm_vgic_finalize_idregs(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
 
-- 
2.47.3

