Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0D640B6DE;
	Tue, 14 Jul 2026 09:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020615; cv=none; b=si5idDcRBb0raUWU9XCL0x3AQglcqxtkZo+JR0AMNL+lZvqXEliFiP/Gz8Lm3SFDd66gJIvwkV2YndGbQh8G3AeDdEEtzOiXsLEZEDEoelT6s7rF946WRyByOO7fPBTCXEjtxCJ2Y8IRhY7fMJnpwWB4ng/PzzoInh39ega44OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020615; c=relaxed/simple;
	bh=3bsYBG1M9IuaTrqk3vHFO+kV2dV3d9oCSPOs8XXGKTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etuc/0+6heDdm2fY+kpV5K2f9j5JG6OnwZBXOrUaFZjkFDudDrDs8rB+Naj3U47OzgdDR/2LJ5KBpj3wqbdUau/lxtZg6fEagocnjcb+TxjLS1byCbveLXWTun1XILjf+clK91X8957Ynt5S/IHmH7u8vJHfkPii9h9sRlOm4O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGJxSJfr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGJxSJfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761451F000E9;
	Tue, 14 Jul 2026 09:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020612;
	bh=3ZzWfhxSs7Ijv/NWxS+JT1yf5R5x2XicAoTTuuWFkWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGJxSJfrnILbqN4JkpRpmAgs16egDIVO5z4tTPtEu39ntx44447kBwsyg6jS6wkPo
	 p5PjAhXAi75FWRb9Hl5LIklkmRNLu1VZVyv5fj1MQjWgEa6XDOapx+k8xkNsMsi/lC
	 9BXwcDb3ijd9uQ78paY74VWk+rmLF/5yJBnNrXCf7zQgT5P5CwQhy6SDDINmf4TqqP
	 CDDi9Lp52tH/LgCglCEg2A2ou0s5+yvvJHRGfWqdrAezjKDb/y5mC+kivlybaX6CU6
	 7B1dXWwgpBe9w1UZNHEV6KCFJ8NogKQqBnzRbE9WfyOGfD/Z8LRpUcHOzyD6xAJ18i
	 6vM6RuCnO6Avg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFy-00000004ny1-3GTz;
	Tue, 14 Jul 2026 09:16:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 18/28] KVM: arm64: Add kvm_has_nv{2,3}() predicates
Date: Tue, 14 Jul 2026 10:16:31 +0100
Message-ID: <20260714091641.1970822-19-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a new set of predicates indicating whether VM is capable of
NV2, NV3, and is in a nested NV3 context.

This is going to become useful as we start dealing with a mix of
behaviours (NV2, NV3, NV2 on NV3...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9831166695186..c562d8171d5e1 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -266,6 +266,26 @@ static inline bool vserror_state_is_nested(struct kvm_vcpu *vcpu)
 	       (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TMEA);
 }
 
+static inline bool kvm_has_nv2(struct kvm *kvm)
+{
+	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
+		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY));
+}
+
+static inline bool kvm_has_nv3(struct kvm *kvm)
+{
+	return (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
+		cpus_have_final_cap(ARM64_HAS_NV3) &&
+		kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV3));
+}
+
+static inline bool is_nested_nv3_ctxt(struct kvm_vcpu *vcpu)
+{
+	return (has_vhe() && kvm_has_nv3(vcpu->kvm) && is_nested_ctxt(vcpu) &&
+		(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_EL2_NV) &&
+		(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_NVTGE));
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
-- 
2.47.3

