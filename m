Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D322102
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AD4C433A7;
	Tue, 31 Jan 2023 09:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675157133;
	bh=mQifo5ColVaTyS46g1UPvijlpz/VgvuSAnasRmnAFuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSMVG0zoP42WIXCNPniPSqt5ky5LwAafUok5NOp4lu/Ce9YDWDUGp7kgsvVsD2zXt
	 AZYuyqkEZbdeqGx4gZt12rwm7cUrt2HrWsFOmnS7ww5xm94OZjSLKw5PpwOnMNTs8Q
	 CmhXfubmcNfFz79t/tZVFNBF55BTjMaZreR8+cZTF7i/KW2oO40RXlTT5de44qUa6B
	 77hVkk2QhpnE41m7evSVHvNiJe0LJkWiyz8PFUEg401vS9Gl0iHZLKwHjO6qIPJpyK
	 zrVO8eiRwUHezdv52S4pPqDFAHZpLC41wPsW66Fp8tyhZLlOE07D4jQ5IAOWmnnsBm
	 tVqu+317QEeFA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtQ-0067U2-1C;
	Tue, 31 Jan 2023 09:25:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 09/69] KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
Date: Tue, 31 Jan 2023 09:24:04 +0000
Message-Id: <20230131092504.2880505-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Christoffer Dall <christoffer.dall@arm.com>

The VMPIDR_EL2 and VPIDR_EL2 are architecturally UNKNOWN at reset, but
let's be nice to a guest hypervisor behaving foolishly and reset these
to something reasonable anyway.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d11c9c4c177a..2a1e8f77b56c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -667,7 +667,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
 }
 
-static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static u64 compute_reset_mpidr(struct kvm_vcpu *vcpu)
 {
 	u64 mpidr;
 
@@ -681,7 +681,24 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
 	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
 	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
+static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), MPIDR_EL1);
+}
+
+static void reset_vmpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, compute_reset_mpidr(vcpu), VMPIDR_EL2);
+}
+
+static void reset_vpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	vcpu_write_sys_reg(vcpu, read_cpuid_id(), VPIDR_EL2);
 }
 
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
@@ -2100,8 +2117,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
 	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
 
-	EL2_REG(VPIDR_EL2, access_rw, reset_val, 0),
-	EL2_REG(VMPIDR_EL2, access_rw, reset_val, 0),
+	EL2_REG(VPIDR_EL2, access_rw, reset_vpidr, 0),
+	EL2_REG(VMPIDR_EL2, access_rw, reset_vmpidr, 0),
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HCR_EL2, access_rw, reset_val, 0),
-- 
2.34.1

