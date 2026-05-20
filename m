Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750F53BF666
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268816; cv=none; b=jffduMtiJDPnmu5DSdWg129uz4su8PogQZ+EQKosub1s0He9AFQ5VgyQQe+vWnbBzwW5ZGM61/119cA0HS4SzIyIlUWAdpsuOSx2kPZTBpcJScwcTfUIKGS/hU2kfKYvHfDNLBLiogZz5Je3zRGLxaJ4kQen8j414is7n+ZO+m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268816; c=relaxed/simple;
	bh=Vcdpwhqa4oY8Q4qM0R7fO+FOw/PAi9tV3e+5XJgmua0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOcCP6FFSGkXEJVbYCvsZZKVip7aX3xZC1DSMIA4FfQSonlN8qARjYHUNCiV0QP/9xxMEAGsQ7a/AUq5YOe00xeHoWJOND5Jngz2faDXUoMMwglMUwufqlaiCGcfpSnK0zSdXFS4qqfeATf3prmqQYH7hwfi/wfo4B4L91P6K14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iP1UpO/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iP1UpO/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAED61F0089F;
	Wed, 20 May 2026 09:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268813;
	bh=uJOCXBypnoYZLX0nT495VkYgI+JgtlLL6d4W8+xo904=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iP1UpO/Qgcu1uWIyYi3hIfLKzizWRHkNd8IpKVqEVQQg08BXrU55l0SYRvHBnlk+j
	 tmKtXlT9/71OPdvHCSDf/TGzM9ZQv+J0PFSmOYMpNFZA4K38A3e+GRWJqdvFLjnvgR
	 qpXRINbishbpSlxJ7ZlVTnsiQxhsVRLPCIxTc9RjAMMnZHreQESWIwurWRR4jpZKLK
	 fbdQd1keBtoz8GzcTGMbA3PvyU99QDZTsrSaO+RbymHlUvuP/yIW6IDnZ8fG5tn6W8
	 7/s5Z7Aw5eicmnSjX0Vy9jm9CcsRjinF2xV79h8AcvbnVU05kitVE+8ND8q/NvEeHS
	 LMQXxMlzBeYYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd64-00000004IaV-09kS;
	Wed, 20 May 2026 09:20:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 09/18] KVM: arm64: vgic-v5: Limit support to 64 PPIs
Date: Wed, 20 May 2026 10:19:40 +0100
Message-ID: <20260520091949.542365-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we have some code supporting 128 PPIs, the only supported
configuration is 64 PPIs. There is no way to test the 128 PPI code,
so it is bound to bitrot very quickly.

Given that KVM/arm64's goal has always been to stick to non-IMPDEF
behaviours, drop the 128 PPI support. Someone motivated enough and
with very strong arguments can always bring it back -- it's all in
the git history.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v5-sr.c       | 82 ++++++---------------------
 arch/arm64/kvm/sys_regs.c             | 17 +++---
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  9 +--
 3 files changed, 26 insertions(+), 82 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-sr.c
index 47e6bcd437029..6d69dfe89a96c 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -30,10 +30,9 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
 {
 	/*
 	 * The following code assumes that the bitmap storage that we have for
-	 * PPIs is either 64 (architected PPIs, only) or 128 bits (architected &
-	 * impdef PPIs).
+	 * PPIs is either 64 (architected PPIs, only).
 	 */
-	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS % 64);
+	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS != 64);
 
 	bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
 		     read_sysreg_s(SYS_ICH_PPI_ACTIVER0_EL2), 0, 64);
@@ -49,22 +48,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
 	cpu_if->vgic_ppi_priorityr[6] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR6_EL2);
 	cpu_if->vgic_ppi_priorityr[7] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR7_EL2);
 
-	if (VGIC_V5_NR_PRIVATE_IRQS == 128) {
-		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->activer_exit,
-			     read_sysreg_s(SYS_ICH_PPI_ACTIVER1_EL2), 64, 64);
-		bitmap_write(host_data_ptr(vgic_v5_ppi_state)->pendr,
-			     read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2), 64, 64);
-
-		cpu_if->vgic_ppi_priorityr[8] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_EL2);
-		cpu_if->vgic_ppi_priorityr[9] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR9_EL2);
-		cpu_if->vgic_ppi_priorityr[10] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR10_EL2);
-		cpu_if->vgic_ppi_priorityr[11] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR11_EL2);
-		cpu_if->vgic_ppi_priorityr[12] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR12_EL2);
-		cpu_if->vgic_ppi_priorityr[13] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR13_EL2);
-		cpu_if->vgic_ppi_priorityr[14] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR14_EL2);
-		cpu_if->vgic_ppi_priorityr[15] = read_sysreg_s(SYS_ICH_PPI_PRIORITYR15_EL2);
-	}
-
 	/* Now that we are done, disable DVI */
 	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
 	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
@@ -74,9 +57,6 @@ void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
 {
 	DECLARE_BITMAP(pendr, VGIC_V5_NR_PRIVATE_IRQS);
 
-	/* We assume 64 or 128 PPIs - see above comment */
-	BUILD_BUG_ON(VGIC_V5_NR_PRIVATE_IRQS % 64);
-
 	/* Enable DVI so that the guest's interrupt config takes over */
 	write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_dvir, 0, 64),
 		       SYS_ICH_PPI_DVIR0_EL2);
@@ -108,50 +88,20 @@ void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
 	write_sysreg_s(cpu_if->vgic_ppi_priorityr[7],
 		       SYS_ICH_PPI_PRIORITYR7_EL2);
 
-	if (VGIC_V5_NR_PRIVATE_IRQS == 128) {
-		/* Enable DVI so that the guest's interrupt config takes over */
-		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_dvir, 64, 64),
-			       SYS_ICH_PPI_DVIR1_EL2);
-
-		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_activer, 64, 64),
-			       SYS_ICH_PPI_ACTIVER1_EL2);
-		write_sysreg_s(bitmap_read(cpu_if->vgic_ppi_enabler, 64, 64),
-			       SYS_ICH_PPI_ENABLER1_EL2);
-		write_sysreg_s(bitmap_read(pendr, 64, 64),
-			       SYS_ICH_PPI_PENDR1_EL2);
-
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[8],
-			       SYS_ICH_PPI_PRIORITYR8_EL2);
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[9],
-			       SYS_ICH_PPI_PRIORITYR9_EL2);
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[10],
-			       SYS_ICH_PPI_PRIORITYR10_EL2);
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[11],
-			       SYS_ICH_PPI_PRIORITYR11_EL2);
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[12],
-			       SYS_ICH_PPI_PRIORITYR12_EL2);
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[13],
-			       SYS_ICH_PPI_PRIORITYR13_EL2);
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[14],
-			       SYS_ICH_PPI_PRIORITYR14_EL2);
-		write_sysreg_s(cpu_if->vgic_ppi_priorityr[15],
-			       SYS_ICH_PPI_PRIORITYR15_EL2);
-	} else {
-		write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
-
-		write_sysreg_s(0, SYS_ICH_PPI_ACTIVER1_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_ENABLER1_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PENDR1_EL2);
-
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR8_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR9_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR10_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR11_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR12_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR13_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR14_EL2);
-		write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR15_EL2);
-	}
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+
+	write_sysreg_s(0, SYS_ICH_PPI_ACTIVER1_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_ENABLER1_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PENDR1_EL2);
+
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR8_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR9_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR10_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR11_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR12_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR13_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR14_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_PRIORITYR15_EL2);
 }
 
 void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 513f5f1429b5f..6083a1b23dbf9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -724,6 +724,7 @@ static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
 {
 	unsigned long *mask = vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask;
 	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned long reg = p->regval;
 	int i;
 
 	/* We never expect to get here with a read! */
@@ -731,21 +732,17 @@ static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
 		return undef_access(vcpu, p, r);
 
 	/*
-	 * If we're only handling architected PPIs and the guest writes to the
-	 * enable for the non-architected PPIs, we just return as there's
-	 * nothing to do at all. We don't even allocate the storage for them in
-	 * this case.
+	 * As we're only handling architected PPIs, the guest writes to the
+	 * enable for the non-architected PPIs just return as there's
+	 * nothing to do at all. We don't even allocate the storage for them.
 	 */
-	if (VGIC_V5_NR_PRIVATE_IRQS == 64 && p->Op2 % 2)
+	if (p->Op2 % 2)
 		return true;
 
 	/*
-	 * Merge the raw guest write into out bitmap at an offset of either 0 or
-	 * 64, then and it with our PPI mask.
+	 * Merge the raw guest write into out bitmap, anded with our PPI mask.
 	 */
-	bitmap_write(cpu_if->vgic_ppi_enabler, p->regval, 64 * (p->Op2 % 2), 64);
-	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler, mask,
-		   VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(cpu_if->vgic_ppi_enabler, &reg, mask, VGIC_V5_NR_PRIVATE_IRQS);
 
 	/*
 	 * Sync the change in enable states to the vgic_irqs. We consider all
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index a96c77dccf353..90be99443df3b 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -730,18 +730,15 @@ static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
 	guard(mutex)(&dev->kvm->arch.config_lock);
 
 	/*
-	 * We either support 64 or 128 PPIs. In the former case, we need to
-	 * return 0s for the second 64 bits as we have no storage backing those.
+	 * We only support 64 PPIs, so, we need to return 0s for the
+	 * second 64 bits as we have no storage backing those.
 	 */
 	ret = put_user(bitmap_read(gicv5_vm->userspace_ppis, 0, 64), uaddr);
 	if (ret)
 		return ret;
 	uaddr++;
 
-	if (VGIC_V5_NR_PRIVATE_IRQS == 128)
-		ret = put_user(bitmap_read(gicv5_vm->userspace_ppis, 64, 128), uaddr);
-	else
-		ret = put_user(0, uaddr);
+	ret = put_user(0, uaddr);
 
 	return ret;
 }
-- 
2.47.3

