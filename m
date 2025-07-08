Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54E82E62B2
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995643; cv=none; b=FOwkX9DeDiUcWyVdglqkxBdY4o+u6vgreVl/26Jek10mbT/HvILlL5d42Ci115rssvUc9tYVwHB6xKnfoh/bi6C2U8g+xyzeYAQ27ygK8QCHaPXHwAe0k1/N9E2RzJLLu1ChCr7LyFtp0OCPvSM+XJFw1PyRHSLmfVLCGjVNjbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995643; c=relaxed/simple;
	bh=5SF9M4kLvy3QJ+CY+qb3VCXNlk3iBCQnbBcTloh5Gqg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a950kP0QUnqwacxka2lZ2jBgmaFJW59P08jLR2mCSt9aMsDcwPQbKMKUJRmLin2p2kAdL8jF5FESyGLcdoJOFjslyRjZKy1sJQ/jzNjjVt8cV7BKj2EmlmiO+Ancx0q9+2nwpMdCdZrAPBLGbtNSVMLZ7PzfgKFwL5dZLqOOrL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XIV4U9h5; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XIV4U9h5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PcpyxVekmfnLIrLpwqm+2uIvMmTUnXychm1HlnvfAds=;
	b=XIV4U9h5w21K1olD5tgbjSfea165pydD7ZGbLl5tG2SulOrvQ2IU21b88vGIBYHOpxGFoT
	LNhIQW0bQ/EttaxQj+qv41vO2N8g3FWLfiomqq83NWRi/SOdoMGt6K62ay6b3bLuSlOB0Q
	3ak77aMtKCGeaf0QapbB0tqz5WpJLPs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 16/27] KVM: arm64: nv: Ensure Address size faults affect correct ESR
Date: Tue,  8 Jul 2025 10:25:21 -0700
Message-Id: <20250708172532.1699409-17-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

For historical reasons, Address size faults are first injected into the
guest as an SEA and ESR_EL1 is subsequently modified to reflect the
correct FSC. Of course, when dealing with a vEL2 this should poke
ESR_EL2.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 39 +++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 4df42a41d0ab..88bc85ecdbb0 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -41,6 +41,22 @@ static unsigned int exception_target_el(struct kvm_vcpu *vcpu)
 	}
 }
 
+static enum vcpu_sysreg exception_esr_elx(struct kvm_vcpu *vcpu)
+{
+	if (exception_target_el(vcpu) == PSR_MODE_EL2h)
+		return ESR_EL2;
+
+	return ESR_EL1;
+}
+
+static enum vcpu_sysreg exception_far_elx(struct kvm_vcpu *vcpu)
+{
+	if (exception_target_el(vcpu) == PSR_MODE_EL2h)
+		return FAR_EL2;
+
+	return FAR_EL1;
+}
+
 static void pend_sync_exception(struct kvm_vcpu *vcpu)
 {
 	if (exception_target_el(vcpu) == PSR_MODE_EL1h)
@@ -49,11 +65,6 @@ static void pend_sync_exception(struct kvm_vcpu *vcpu)
 		kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
 }
 
-static bool match_target_el(struct kvm_vcpu *vcpu, unsigned long target)
-{
-	return (vcpu_get_flag(vcpu, EXCEPT_MASK) == target);
-}
-
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
@@ -83,13 +94,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 
 	esr |= ESR_ELx_FSC_EXTABT;
 
-	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC))) {
-		vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
-		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
-	} else {
-		vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
-		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
-	}
+	vcpu_write_sys_reg(vcpu, addr, exception_far_elx(vcpu));
+	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
 }
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
@@ -105,10 +111,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_trap_il_is32bit(vcpu))
 		esr |= ESR_ELx_IL;
 
-	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC)))
-		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
-	else
-		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
+	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
 }
 
 #define DFSR_FSC_EXTABT_LPAE	0x10
@@ -199,9 +202,9 @@ void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
 	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
 		return;
 
-	esr = vcpu_read_sys_reg(vcpu, ESR_EL1);
+	esr = vcpu_read_sys_reg(vcpu, exception_esr_elx(vcpu));
 	esr &= ~GENMASK_ULL(5, 0);
-	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
 }
 
 /**
-- 
2.39.5

