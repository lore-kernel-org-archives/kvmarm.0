Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44686332EB6
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 11:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765799068; cv=none; b=PjYs8jaFrZk5dLXLhPsckUKaGeHjC7IAcr3Jygxqc5zsz6IUtgSADUsw8yDHL1zwCGx/1DP6HlevmFe/AZDl0gw6WEtjlWTBeIz+jHY8lQOfWupphR7xZOjVL0iGQn6oqVGEeVXlZnuAoOiNfuqQ+SOGCmXgT/AJi45dbjsI/M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765799068; c=relaxed/simple;
	bh=4gksVKjaNzZp4IIhH6BbsBzlcoExYCiLW+Ik4QaWD/g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/UR3DyOOdjLbA2PutzhUrLhLz9fxgIOcR/5QcinsufiS4Mk2GGJEoDfKVno8Sb0AePzhMPeyyB9U8hRMgDIBm1nb+9uVpDh3tl9XO82OfmM0bXEhWnBNqFVQgJJMxuV/u8Sr6oYeDTXIcp2GR4QtUgxp9DYyC4uLkDeHhdsqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BE1DFEC;
	Mon, 15 Dec 2025 03:44:19 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC7653F73B;
	Mon, 15 Dec 2025 03:44:24 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 1/4] KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
Date: Mon, 15 Dec 2025 11:44:06 +0000
Message-ID: <20251215114409.212512-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215114409.212512-1-alexandru.elisei@arm.com>
References: <20251215114409.212512-1-alexandru.elisei@arm.com>
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
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 3 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a7c689152f68..8ffbbce5e2ed 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -180,6 +180,9 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 		/* Propagate WFx trapping flags */
 		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
 		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
+	} else {
+		memcpy(&hyp_vcpu->vcpu.arch.fgt, hyp_vcpu->host_vcpu->arch.fgt,
+		       sizeof(hyp_vcpu->vcpu.arch.fgt));
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8911338961c5..12b2acfbcfd1 100644
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

