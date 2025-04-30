Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF74218EB1
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 10:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746010771; cv=none; b=Hx50ATE47tRC5MMuN/NrcZR+HC3PANrmDreQBvE4gBvXjmyf8D/Xz1EQ2NOSRts4tXJLhGpnyXkufL3qtJHtQtz7bgPSb4BwNqWtQYBjoirwJ8ik5ZbseIZXuBo5eDm8b2c+lgk5SHonm4vtRHxmc7P/1rp9QIdh1/gX2ZD6ovQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746010771; c=relaxed/simple;
	bh=EvNCdJifATrWMosi0Tutk55nsBoDQ72JnliULEibsHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rid+y2UU6Gorp3Dqha57jR78zVt4QImVSxUZ9RLbuWbbZHmwx+YpZ5jQ/YA9MyiDYxmXulJTTaGbnWNSumtcbo/4/xme6OFNvx/LiLJB2V17GQSXCvtKdJm0QTPiSzJc3bLU5uYM6SkLiJaS/i8RKklDn769zVEn61h6nvGKIqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bai2WMSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bai2WMSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35149C4CEE9;
	Wed, 30 Apr 2025 10:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746010771;
	bh=EvNCdJifATrWMosi0Tutk55nsBoDQ72JnliULEibsHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bai2WMSraQ78mR2cpZOhd+yrTnBVW0N6PcSt0X4pOHuYMClADl/iBbyD4Y+k7RdKJ
	 xELjRg3fhIWGuQs8z/Fnnw0cds6zIVjeE75yuYoBjInHYFKUvgV6AlyLH+rUS0i3qU
	 R4YgW4mCw02ycVzBgThP6pOsV59awSyiQ1eyufMKu2Jb64nkDqkVCsPmhiF0a8ISKC
	 EJ+LR96UA79JOeto2R9ArZTr30sRIhscDzhEqwYaT+ul6iqIlUmq/6lmeZNDNcwAf6
	 uIadktTESzIH2zZQmLY0HSyDiU36TVDikOM1wHzSRiwMNeEjxEp3lbQtnVIeUINZgs
	 Jr6s+QXQe7HUA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uA5A1-00AFD9-8C;
	Wed, 30 Apr 2025 11:59:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/2] KVM: arm64: Properly save/restore HCRX_EL2
Date: Wed, 30 Apr 2025 11:59:15 +0100
Message-Id: <20250430105916.3815157-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250430105916.3815157-1-maz@kernel.org>
References: <20250430105916.3815157-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Rather than restoring HCRX_EL2 to a fixed value on vcpu exit,
perform a full save/restore of the register, ensuring that
we don't lose bits that would have been set at some point in
the host kernel lifetime, such as the GCSEn bit.

Fixes: ff5181d8a2a82 ("arm64/gcs: Provide basic EL2 setup to allow GCS usage at EL0 and EL1")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index b741ea6aefa58..96f625dc72566 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -235,6 +235,8 @@ static inline void __deactivate_traps_mpam(void)
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
+
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
 
@@ -245,11 +247,8 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 * EL1 instead of being trapped to EL2.
 	 */
 	if (system_supports_pmuv3()) {
-		struct kvm_cpu_context *hctxt;
-
 		write_sysreg(0, pmselr_el0);
 
-		hctxt = host_data_ptr(host_ctxt);
 		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
@@ -269,6 +268,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 			hcrx &= ~clr;
 		}
 
+		ctxt_sys_reg(hctxt, HCRX_EL2) = read_sysreg_s(SYS_HCRX_EL2);
 		write_sysreg_s(hcrx, SYS_HCRX_EL2);
 	}
 
@@ -278,19 +278,18 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
+
 	write_sysreg(*host_data_ptr(host_debug_state.mdcr_el2), mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
 	if (system_supports_pmuv3()) {
-		struct kvm_cpu_context *hctxt;
-
-		hctxt = host_data_ptr(host_ctxt);
 		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
 		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX))
-		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
+		write_sysreg_s(ctxt_sys_reg(hctxt, HCRX_EL2), SYS_HCRX_EL2);
 
 	__deactivate_traps_hfgxtr(vcpu);
 	__deactivate_traps_mpam();
-- 
2.39.2

