Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D78943FD35;
	Tue, 14 Jul 2026 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020615; cv=none; b=jsVofyOgpMFkOqaurrTku+7y2dI4hSRtVL7Hhg4OYZ+ZT+/eQ3+/cVjnJjD0j+MPJPkbzT94SIiHy0MNspvNdLQcuYE8VFStUi4Lw4l0mThQ2TOp2obHfSTgDvPLjKFmJyVmSSeNuTMqektHMHeHg/yGlWw97eUGuW/kHsyQKwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020615; c=relaxed/simple;
	bh=Bmarv9ETkOy+ocdGoVkqlZ5fWXWVdV9HYNdiftnMr4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHPg2cMA9symOM3XX3GPBLnQOqkJ5W9sw7fNGIOMtLwIIsVTpbEWv7qu9lTodR8XFdzGjyWiyYFjEM8NKhIJE4akeRcRR2cDz1PBlSYuM/3kya5Eaux7gjuUeOsqnNoKI3ehDDAaCvLA8BgDX2eb0ze5lhVK6vV/RmATc/rBlEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lB/flkKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lB/flkKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38C11F00ADF;
	Tue, 14 Jul 2026 09:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020614;
	bh=8jaHFCEviRnbCdixdpD0GtuLBAdju+GKxQE6UGfkIoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lB/flkKHtoBf/BAkGYkte5eGO4Nctr+CYyOZOCZ99SKRVb0JUjvdL+LcC67gINrPf
	 2NP1U6P/0Nvl3f8Zf06igfpgcB+rf5un+BFsoRXa/9D2Yeb8yukzXYVqE8AO6R7WNw
	 1q5LuSyscn6bDQHt1Dwv9ELOTyywG5u2+tKAg0lqruUm+xdXpOZVZLKwfepYmkGM2M
	 fb6gJYHBtsIGuQ0IesqKQCjf/BsjQCDlQ2Q+OWkrmD4HNPnKq1ykjOUR6bMKSUwi9/
	 d5WFl/Ynl5VI7zpTvDyjCriAl06Hgy6EBBh60YxWY0UtWIIT8PrZNHRZMImc1156Gy
	 lVRBGkINpvEJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZG0-00000004ny1-18W4;
	Tue, 14 Jul 2026 09:16:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 25/28] KVM: arm64: Engage NV3 TLBI trap elision
Date: Tue, 14 Jul 2026 10:16:38 +0100
Message-ID: <20260714091641.1970822-26-maz@kernel.org>
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

