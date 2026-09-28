Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46344839A
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790578009; cv=none; b=dNoA8LzNkz7bipuyKTwccNLsfjsUO2RLsmEMwXHVLiEo860QNm0eW88VnK0TGnRf3q81de39cQqz62FzxaqLkQd9x2fohWc04NHndjRLSpsUx0MyYudf261aouMKU6nEPs3DanetcvjV2hE5WTOr6Hki3amo39sjbEJS/H2PAiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790578009; c=relaxed/simple;
	bh=1jHpaWMldBRFaEmddqMc+nJNDn5a3aVbF5D1CXCVMl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pHZ/5sri37OZM9EIaNgUjUQKOpLPFLaYprRZoDkIntlcFZYZK8QxoMPqeHys5HUTc1JPL69m6gJueZaJehkh0I8GcXN4jyEtGkHOpffUm+vkavWKD6Tsym6796wLbcmIAF7BbKRQswJMMUB8m5sWtaHU2b8c+neTXHRZCcYTSE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pjYtaHUb; arc=none smtp.client-ip=91.218.175.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pjYtaHUb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1jHpaWMldBRFaEmddqMc+nJNDn5a3aVbF5D1CXCVMl8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790578005; v=1; x=1791182805;
 b=pjYtaHUbGZbtRJLTbDMx9FU73tPnoVbM1E3j37u158wVrYTA+z+AsiSYFRaFo3USQYdqnVEV
 6R6mn+jiBFB9BuJhiJuhFZYXBXjPLviZFvdZ4v9DO9aaM7oVunowqXje/m14BbBtirZjpkGRymW
 pyfBup38iVAHFmZtfjG3tCuk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ffd1c6cc9a1d9028;
	Mon, 28 Sep 2026 06:46:45 +0000
X-Mizu-Trace-ID: ffd1c6cc9a1d9028
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: arm64: Clear HCR_EL2.RW for 32-bit non-protected vCPUs
Date: Mon, 28 Sep 2026 07:46:41 +0100
Message-Id: <20260928064643.3265087-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260928064643.3265087-1-fuad.tabba@linux.dev>
References: <20260928064643.3265087-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM keeps its own copy of each vCPU's HCR_EL2 at EL2, initialised with
RW set unconditionally. Nothing stops userspace from creating a
non-protected AArch32 VM, and with RW set, entering one of its vCPUs is
an illegal exception return: KVM_RUN fails with KVM_EXIT_FAIL_ENTRY.

Clear RW for a vCPU that is AArch32 at EL1, when the CPU has AArch32
EL1. On a CPU without it, RW stays set and the entry still fails, rather
than EL2 switching *32_EL2 registers that are UNDEFINED there. The host
already rejects such a vCPU, but EL2 takes the vCPU's features from the
host and doesn't rely on that.

Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..62d432144d44c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -54,6 +54,15 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
 
+	/*
+	 * Without AArch32 EL1, leave RW set and let the entry fail with an
+	 * illegal exception return: the *32_EL2 registers EL2 would otherwise
+	 * switch are UNDEFINED there.
+	 */
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT) &&
+	    cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
+		vcpu->arch.hcr_el2 &= ~HCR_EL2_RW;
+
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
 
-- 
2.39.5

