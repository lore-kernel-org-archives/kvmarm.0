Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB74843F4D0;
	Tue, 14 Jul 2026 09:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020615; cv=none; b=kYChDfkLimhtipVu6xhpofTkJ/1GeI04FrrHuIZ+1K17eDdMfQ+lQzIj7RAmrd9m7I/P3yL7glDCYX0ta3IBbAs8WvazTGqatXeSUyrXDvhLRotbjOdbxR0th+QHsu980PEGFU9HEk1ZtgwGoIqNJK0PHXzBu88hKMcxD7zMlEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020615; c=relaxed/simple;
	bh=fXt5FTW+4Di4PFlbgt1bA4MfMkwlaMU2hGin9+0GM8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs5Fclp0KqxL/3G2ozTpa5szn4sWiFIW6Ely7Osa5yMptBSA1n6bltJhFXnAHdO3SrvQqehkqID0OjQxop/yAkELfrp4L8BsaBa0ubOn62wDBJImDxVslMEUmQou0jwhs+ZFaHpukhz+sczVHvbssweJ9YUYvBhO1k97KBw8Pc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QsLdjkmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsLdjkmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0BE1F00ADE;
	Tue, 14 Jul 2026 09:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020613;
	bh=fEe+1zzaqbCdXdh6ww+SYAkJw1CH2t7i7FHcOdmaALg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsLdjkmGsoNlDYf4FZHQB9btlmfcr28KTP4TvBiUsloYP/QWrot08R0OKdDBcc3co
	 dGGTR50I0y5OOJ8x40HCKRJ05PB8YLa68C6uYgkQUKq+7zLjiz0Yb+15Kpga8CHULP
	 7seIOysi3iyqJw7udw/iSt6Vm3q8vTn1YXppDysSgrciO3bCe3JEV7hAsNIdTYWvs+
	 1xCUnMzgGcitINiQy08m96VzjbpzGimPPInzdOUsR+eKC0nRU/4u6eRak+X/9gnlmr
	 gFTj76Oo4uMst3f3ziQXzc3v9gu3SWTvLg1ra46sWCtLwtiQYhhImNLNWvtbmfM6rH
	 adiLUq7/v+ROg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZG0-00000004ny1-0GGU;
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
Subject: [PATCH v2 24/28] KVM: arm64: Engage NV3 ERET trap elision
Date: Tue, 14 Jul 2026 10:16:37 +0100
Message-ID: <20260714091641.1970822-25-maz@kernel.org>
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
index e823046d28796..8a39e72d8386b 100644
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

