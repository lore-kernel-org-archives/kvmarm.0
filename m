Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D5821C175
	for <kvmarm@lists.linux.dev>; Wed, 10 Dec 2025 13:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765372878; cv=none; b=lFlO3rqBK6LkteIjSmjaPrg593RTLionvGRS11S85bRpCrCUYp+Vnrz2oWc7C9UBaNzg1GcUXKVpgOrPp7TIG7h8eETkO/mpNdfpDH29FGbRc/xPFAWkv04hf9ZaeWuiqthSNzh6R0mv9y0dtRq9JhCLHgWayqhlHnc9Kunp14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765372878; c=relaxed/simple;
	bh=k4ON9sqbg5Avf5r/X+SB+uEp+ozDA05k1XM4xNaeS5k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xe4o3WCRN4BsBSiW+1ROvGARVtG+1Exdw7KxYYuU23oQfIXo2SL1TcilwlKzsPnGwVbBLaPqIVSfEKlwLmAKLM1JQtkVOUBESejk9ByxoSPTfA0zXwNE1coHrcXGqg5AFOuyvynJsMq89iImuaQ2ai8w/5/+z5ZbJwVcj/cEGsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FAEC175D;
	Wed, 10 Dec 2025 05:21:08 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B94273F762;
	Wed, 10 Dec 2025 05:21:13 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 1/2] KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
Date: Wed, 10 Dec 2025 13:21:01 +0000
Message-ID: <20251210132102.137631-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210132102.137631-1-alexandru.elisei@arm.com>
References: <20251210132102.137631-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
introduced per-VCPU FGT traps. For an unprotected pKVM VCPU, the untrusted
host FGT configuration is copied in pkvm_vcpu_init_traps(), which is called
from __pkvm_init_vcpu(). __pkvm_init_vcpu() is called once per VCPU (when
the VCPU is first run) which means that the uninitialized, zero, values for
the FGT registers end up being used for the entire lifetime of the VCPU.
This causes both unwanted traps (for the inverse polarity trap bits) and
the guest being allowed to access registers it shouldn't.

Fix it by copying the FGT traps for unprotected pKVM VCPUs when the
untrusted host loads the VCPU.

Fixes: fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  1 -
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 29430c031095..ee0f1343100c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -167,6 +167,7 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(unsigned int, vcpu_idx, host_ctxt, 2);
 	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *hyp_kvm_vcpu;
 
 	if (!is_protected_kvm_enabled())
 		return;
@@ -175,10 +176,17 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 	if (!hyp_vcpu)
 		return;
 
+	hyp_kvm_vcpu = &hyp_vcpu->vcpu;
+
 	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		/* Propagate WFx trapping flags */
-		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
-		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
+		hyp_kvm_vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
+		hyp_kvm_vcpu->arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
+	} else {
+		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+		memcpy(&hyp_kvm_vcpu->arch.fgt, host_vcpu->arch.fgt,
+		       sizeof(hyp_kvm_vcpu->arch.fgt));
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65d..05774aed09cb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -172,7 +172,6 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 		/* Trust the host for non-protected vcpu features. */
 		vcpu->arch.hcrx_el2 = host_vcpu->arch.hcrx_el2;
-		memcpy(vcpu->arch.fgt, host_vcpu->arch.fgt, sizeof(vcpu->arch.fgt));
 		return 0;
 	}
 
-- 
2.52.0

