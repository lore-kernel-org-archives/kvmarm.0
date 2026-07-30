Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A7D3BB69E;
	Thu, 30 Jul 2026 07:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395470; cv=none; b=J8y1fmuoDGYCHmkQNjx5Sem5/asSLy2neqZvLAK88ZpTRE6X31FgOnAmNpHc+TJ2S2vczsvWp3hpy+yJFJWVmKgUP0M92ZK9sVAo7qb5PLLe5tK/6gpiFG34dvIMDThAm4MBi5XQk33e2+XQ5jOMJ1HISoB4ONNN/jgbBHTPdpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395470; c=relaxed/simple;
	bh=7+itpKzbmIvOhr96VWbcJgtpQyHehVgKiT0Hre9ip8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA03dpykXlSzotzqgT5l7vRMfa3eMymuOLNUxdblNX2IwP++npnR5cTwNVPFoVmQAFGWwqBJfUNn+7Hjn0TwxhizWJp1M9ta/V0Go3vpFGURILjknweFYOoVvQYgA4b62z91gHlQrvuHbDK8CYdAfoCpzg6OjFezcG7VieTCeiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zno6SSpo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zno6SSpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696F01F01560;
	Thu, 30 Jul 2026 07:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395455;
	bh=EmXle6f58ZvhPKo2zNTeSDGA59Tm96Gw2BOndMtNuhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zno6SSpowHOpAHby86cYgerCZNwtKn6gtjS97iRgtUzRAr+akk7QTahaCA34xT0ur
	 GZIi8l1Fj3AWWKxOaQU6mXUqio7lBhQpDzYPCxBVJd6o0lbPp9+N2naRTqw397pmna
	 2fcS/I4NwXUpb1AmCdMsuWMa0Egci3VjPcZbKT+F2m4I+CReSUfoaj+XHqmdk/eaIg
	 ExT3CZL5VO7S06boAJoRdq3G+eg6a/C6FHFWxu8gyhELlAconX5x6hVCkNu8FcHKA/
	 u0WWpLrn/Q0MYW6PGNpN5GrouBg/7XsyMfw1N3caruPx2Gg2bAsL90E187F0LzWYaQ
	 hPtKW3BYSbInw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKur-0000000AOpW-3MpF;
	Thu, 30 Jul 2026 07:10:53 +0000
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
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 25/29] KVM: arm64: Engage NV3 TLBI trap elision
Date: Thu, 30 Jul 2026 08:10:18 +0100
Message-ID: <20260730071022.296811-26-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com, vladimir.murzin@arm.com
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
index ee340d3294478..67ad4523a1e67 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -714,6 +714,19 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
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
+					vcpu->arch.hcrx_el2 |= HCRX_EL2_NVnTTLBOS;
+			}
 		}
 	}
 }
-- 
2.47.3

