Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD047125B;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706185; cv=none; b=VYUcFf9FdCHixEazAC2kyxvrM/kmwsbtY2yRgXQlnXePD7O0ECT+gU2IJ0gNDy1FYmcNiDS8AeDMrlnGEvgRyNBAj3w9Hk0bFnEKEG+NeR6eDEcPEMNj3lBh/v/Nr49FVw/MInGGfnMRs3tklBx6496vZ3lUICCpR9zLyi7phXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706185; c=relaxed/simple;
	bh=Bmarv9ETkOy+ocdGoVkqlZ5fWXWVdV9HYNdiftnMr4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDCWsOc+W7yJkenwP9Ld8u2NMnu8H+A7hMgQk1tfBcpGi5LbYGDwYaQ9wIobumWwibsBcU9Kl45nJOaEOoojlZrVUcdOGpJuXjEnu89LxyFYxUu7wsqQfiXY7jWHrHRNMCArUhn4spi/9/po/fF9k5GZFWWtNks1VhvxHL8zOqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVO1H1z2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVO1H1z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977591F00A3E;
	Wed, 22 Jul 2026 07:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706181;
	bh=8jaHFCEviRnbCdixdpD0GtuLBAdju+GKxQE6UGfkIoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVO1H1z2lqLOb6HDjKUF7YUegGd21j85fCsJanfqN9nKAjbsmHTV+Y22NaBt6hZCf
	 Rd5vrGgcZ1CNEqyFazDA48gtutAc0PqGQp543lFmYwLZ6wtyYF621eLEkQMLezBcIa
	 Fb5qFn8ipRaDdysiVkJWAi7oBT6JS7wrC4H+b7w7HnOfutNabx86mVt87WtgvwXcJv
	 hlxFkQ3m3K1PLCYjbheJDyotBLG6yuxBNGBp+Qi84YVRER4BjCd5PIHFz+2MIQWNZk
	 PnDqql8gShYWuESay83ihBEr2sAooIbYm5VBmj79/P8VMAmuuCjmhLGThBf9u+ps6S
	 J3090VHX+RzzA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbX-00000007VfN-3jDV;
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
Subject: [PATCH v3 25/28] KVM: arm64: Engage NV3 TLBI trap elision
Date: Wed, 22 Jul 2026 08:42:31 +0100
Message-ID: <20260722074234.3330999-26-maz@kernel.org>
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

Similarly to the ERET elision mechanism, FEAT_NV3 can elide TLBIs
that only affects the guest's S1 translation. Enable this, with the
express condition that the guest isn't NV2 aware, as we otherwise
need to trap these TLBIs to deal with VNCR mappings.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b32870a5e1236..d17b161d4ba3a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -715,6 +715,19 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
 		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_NVTGE;
+
+			/*
+			 * If the guest is NV2-capable, then we need to see
+			 * all the TLBIs, as configured in HCR_EL2.
+			 * Otherwise, relax the TLBI traps to only TGE=0.
+			 */
+			if (!kvm_has_nv2(vcpu->kvm)) {
+				vcpu->arch.hcrx_el2 |= (HCRX_EL2_NVnTTLB   |
+							HCRX_EL2_NVnTTLBIS);
+
+				if (kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+					vcpu->arch.hcrx_el2 |= HCRX_EL2_NVnTTLBOS;;
+			}
 		}
 	}
 }
-- 
2.47.3

