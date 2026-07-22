Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9737F472F8E;
	Wed, 22 Jul 2026 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706182; cv=none; b=RkYkPOuTIwPUNCU/7AXhp0aq0nqElXwOI36OZDYCGAdGpXjb/CeLWviCVe5T2OgyPSgcv//A1TqTm2JXmSfAKUlmIJ4qsSDJrHkz33/jhAz0fW+di0wAwNrHAfwgHVRfhoyzf1kr2SHTZWGytCDN8VN2QY/AU7+yHgFoMu6lLvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706182; c=relaxed/simple;
	bh=iPWJduhWesQakHfCm+lSWNQezSoHB8idqVgPBO1wLu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oW0B2ewCLq2qIzSUoHC2eeufDzJLMehb+BVFHhMi/7s/OUzoSbZUa3+7sJQIgfblKMvQAr/duBav0pFqf27FD+l2OdWGBkSwr3V2fmAlLfYqOv3XMxdintSKDOcnLArpzUPyk69qqC7c+6JQSXxKb+wZNtMMgFrMLVesFm0l6oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEqspXeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEqspXeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F121F00ADF;
	Wed, 22 Jul 2026 07:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706180;
	bh=58csLrbtmr01W2uSPT+plvbSN2aEa7PPRg7YP3Oh/88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEqspXeROswTVc3o0+xFyUVPbKapt9HvAhq1XF95f8F830HtCG17uvkfrDC8bHg0u
	 yqvz5SJRuJwJEw8469eCdW/DcrdrXRAv4B11S5zxf4YNOSzJxXsrG1DL1tcZl4OmeM
	 KC57bIAldf2aBDKLfuRi8RKBa+VwlrasTpLQ123R14lDdQpv39C5vuIjWhsGyzAbb6
	 bEe4Mg57mgibrXPc+X65UyaNq6cNhKHs+lHe8ggn4eVJ/hVlmT0AtjgMZwgQ3/vidp
	 7wSt4F/uYo0Nn8iTPxXPB7k07Lwq2XbhJZy9FBzVolqIhG4KPQHt4MC1HUAistAF8B
	 fi/Jxovw6UbAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbW-00000007VfN-25NA;
	Wed, 22 Jul 2026 07:42:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 19/28] KVM: arm64: Make HCR_EL2 a non-VNCR register
Date: Wed, 22 Jul 2026 08:42:25 +0100
Message-ID: <20260722074234.3330999-20-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_NV3 makes a fundamental change to the architecture, by moving
guest-initiated HCR_EL2 accesses to the NVHCR_EL2 register. As the
names suggests, this is HCR_EL2 for a NV guest.

But where do NVHCR_EL2 accesses from a guest go? The are redirected
to the VNCR page, right where HCR_EL2 is stored in the NV2 case.
Does it hurt? Good. There's more coming.

The challenge here is to make KVM work seamlessly, without rewriting
everything. Which implies that things such as __vcpu_sys_reg(HCR_EL2)
must work, no matter the underlying NV implementation.

A simple way to deal with it is to move HCR_EL2's canonical storage
outside of VNCR for the vast majority of the KVM code, and only have
a copy at entry/exit times. Given that we don't really support NV3
yet, this is pretty simple.

In the process, advertise NVHCR_EL2 as the register that now holds
offset 0x78 in the VNCR page.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     | 3 ++-
 arch/arm64/include/asm/vncr_mapping.h | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c       | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5c..2648c8a717ba0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -543,6 +543,7 @@ enum vcpu_sysreg {
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	ZCR_EL2,	/* SVE Control Register (EL2) */
+	HCR_EL2,	/* Hypervisor Control Register */
 
 	/* Any VNCR-capable reg goes after this point */
 	MARKER(__VNCR_START__),
@@ -571,7 +572,7 @@ enum vcpu_sysreg {
 	VNCR(TFSR_EL1),	/* Tag Fault Status Register (EL1) */
 	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
 	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
-	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
+	VNCR(NVHCR_EL2),/* NV Hypervisor Configuration Register */
 	VNCR(HSTR_EL2),	/* Hypervisor System Trap Register */
 	VNCR(VTTBR_EL2),/* Virtualization Translation Table Base Register */
 	VNCR(VTCR_EL2),	/* Virtualization Translation Control Register */
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 14366d35ce82f..9e8a49fa8b638 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -11,7 +11,7 @@
 #define VNCR_VTCR_EL2           0x040
 #define VNCR_VMPIDR_EL2         0x050
 #define VNCR_CNTVOFF_EL2        0x060
-#define VNCR_HCR_EL2            0x078
+#define VNCR_NVHCR_EL2          0x078
 #define VNCR_HSTR_EL2           0x080
 #define VNCR_VPIDR_EL2          0x088
 #define VNCR_TPIDR_EL2          0x090
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 53af19212895d..e5a51dc3cbe5e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -70,6 +70,9 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			hcr |= HCR_NV1;
 
+		/* Publish the guest's view of HCR_EL2 to the HW */
+		__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
+
 		/*
 		 * Nothing in HCR_EL2 should impact running in hypervisor
 		 * context, apart from bits we have defined as RESx (E2H,
@@ -549,6 +552,7 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
 		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
+		u64 hcr;
 
 		switch (mode) {
 		case PSR_MODE_EL1t:
@@ -561,6 +565,11 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
 
 		*vcpu_cpsr(vcpu) &= ~(PSR_MODE_MASK | PSR_MODE32_BIT);
 		*vcpu_cpsr(vcpu) |= mode;
+
+		/* Publish the latest HCR_EL2 to the emulation */
+		hcr = __vcpu_sys_reg(vcpu, NVHCR_EL2);
+
+		__vcpu_assign_sys_reg(vcpu, HCR_EL2, hcr);
 	}
 
 	/* Apply extreme paranoia! */
-- 
2.47.3

