Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233023BB9ED;
	Thu, 30 Jul 2026 07:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395470; cv=none; b=l/zPgTo1G4jfQXuUYV2YMpX3lVGNQRJMUXUbRvOL8SnwaEFh7c5LDMJbn5NQsJmLiANIBkof3V0a4B8A0/C0UYe/EaItfIh39tJVDyjxHxn5USB2eWQhAfYt+TlKNFzbkknVOIJSTs+LPST1+PnBw7YpTItCtpzWmtTowBVcgmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395470; c=relaxed/simple;
	bh=af7UFh4yanCmm6j9ys+YBUa6Cc2KU9a8i/o2CeL7z4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulEVJhXjQzu8jZmwjmdPyR2xqFoH7q31BMjGH4oDTRb6DezgpqAiHEq0n4za4uIW3mvP8aMjZ15E9VH3kpISziT+drB8juuwBObKZzf+Lysmvb0DskR0TXJ7079CRMpT1Q6dqFwxsMto14OZCuUDSP/99fLHkr7clJ0tWA6FC+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNsntE6c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNsntE6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391211F0155B;
	Thu, 30 Jul 2026 07:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395455;
	bh=iphw/trZbQgKuaLseXe8o8FXlhLchtJlvFzyolbcN1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNsntE6cJcGyj56BJgdyOCjZzmZoi1R0PuaWlWqd/5Oa5TZvCHYDo/fGndmHfzbgF
	 162aGnCZrLLduG/QDL6GWZkfrFqK/CX6ZZ3IC9MHykt068Mbg6Nfq6WNMTVmPsl+wS
	 A9z/txwh3MV3nh4MMdHPEEH8zOzmDyOT471tcN2T4eLh2QLWU5U8HJ/3GhCGC/vDZ+
	 TcJBXFrySwD7YOC0JZvr0Uy3MUfA++tCiyb+4fmi7J4E+p3b6M5paFQg6Rkvh1K6F1
	 77KL2EmMntoT06VDJ4fjNwt28ZDKhejpxtMYm5LUO1Cd6zaQy5gND+jIV8dUNxwGex
	 BPrx3jOZRCquw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wpKur-0000000AOpW-2S4K;
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
Subject: [PATCH v4 24/29] KVM: arm64: Engage NV3 ERET trap elision
Date: Thu, 30 Jul 2026 08:10:17 +0100
Message-ID: <20260730071022.296811-25-maz@kernel.org>
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
index bdb7dfaa271cd..ee340d3294478 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -705,6 +705,16 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
+
+		/*
+		 * NV3 is a host-specific extension, and we always use
+		 * it when present and that the guest uses NV. It may
+		 * be hidden from the guest though.
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

