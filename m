Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E53C473C97;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706183; cv=none; b=eB2piYZxGj0TaeRXdG970EkYn99A+j6hqvraBip7XTGpyPMafFjuOKmmXbZZuA3m6Jh9Sf179rLMpNfe9zO4g62TstycaM19+/YicA1nWLtL6B1pzXj3MejHOcfVNIHelU3gyXx3NYt5YnCqtlyUGePEIjBq9TUBupJMviLoXm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706183; c=relaxed/simple;
	bh=x3l74HTA49hsSZV5wzY0Q794tMRyo6SdD7rivH0kOaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd+/g+6sz5234KSD22Zq2wZ71q35VXGxMoEyiAiHpO4QlTZIrqYPbdUjges/+xEh+U9sb9VIe0et5U4/IYwmq1NGKglh+0c2+M6DmyAuDBqpio7jt1yV3rNKX6jmyCTEyC7CTUn/0wXXxTs6Rv/cSQmihlM1M1kJ6erkrutCCYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jvi5j8JI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jvi5j8JI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420D71F00AC4;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706181;
	bh=J3D2mlM+r9vwvR96lfmaZndRlPy4OmCpqOgVbTDNnAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jvi5j8JIrOe1UHO+HDoUL8iCJbecoch5oUKSxFuVoUzN3R7qlELxDhjavVeNF9vOX
	 gkCqYkd7+mMAhFr/P7LjrXlbOo+91JcbCZSOQAorQKpntspenIxeXoFPYNrneC08yS
	 4soe45h+P+2KImqC7AdnoRZBjLS7ONnGeD0pCf8i9f0dE0z2L0YIMUdGqIQq70oPq2
	 X1S1EvlwZXpRIrBo2iB+Z1CSjm8QjKOafs84zI3jLhKLH4pXTawHsWWhafMp7YDXLr
	 68cYRG2scEVCcjcZ3rwtrp791P9tTBzXxXHtgYyYbvimrd3lUOKVe8k7flR41tjCRk
	 I6/MBZUWN6M7w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbX-00000007VfN-2hhR;
	Wed, 22 Jul 2026 07:42:59 +0000
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
Subject: [PATCH v3 24/28] KVM: arm64: Engage NV3 ERET trap elision
Date: Wed, 22 Jul 2026 08:42:30 +0100
Message-ID: <20260722074234.3330999-25-maz@kernel.org>
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

When running on NV3 HW, always engage ERET trap elision when running
the L1 context, as there is no benefit in not doing so.

An L1 can itself engage trap elision by setting its own view of
HCRX_EL2.NVTGE==1, which will subsequently be honored.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c      |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c562d8171d5e1..b32870a5e1236 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -706,6 +706,16 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
+
+		/*
+		 * NV3 is a host-specific extension, and we always use it
+		 * when present and that the guest uses NV. It may be be
+		 * hidden from the guest though.
+		 */
+		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
+		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_NVTGE;
+		}
 	}
 }
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index cbda9e087db39..4ed745bdde418 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -345,6 +345,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 	u64 spsr, elr, mode;
 
+	/* With NV3, the fast path is handled in HW */
+	if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
+		return false;
+
 	/*
 	 * Going through the whole put/load motions is a waste of time
 	 * if this is a VHE guest hypervisor returning to its own
-- 
2.47.3

