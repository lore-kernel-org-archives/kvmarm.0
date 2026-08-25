Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5E53E1D12
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787648397; cv=none; b=kWRZMRGaGrp/2Md02nO/9m+XOO3ldoNndBiZHWUerqIt4DjKZuA2EHACqa3n2ZdIOlzvG95QBDLi260M4ri5BRKyYERfShTT/70JVx/WtYFpBsP22d3r01ctFPCTVXyjZsJwDy9YDC/hPkSVEec2ruEH0bmQ4edKNYiHoiGRqEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787648397; c=relaxed/simple;
	bh=qzr5u5nyOHcveIVIzXVin5uMFlcqJuyQtDVpldTuy/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p55HZLfBTqu+EJsDFHS1VXZl0gVxeg9vDwJXbuqZntpiO5W6H3WAbnxo/SrE9A+a5sfPLas9UQfiNVuVwA8D1VjrT/s+kBkh/cjixXxo9DVOaYvT1tDoRh4D+oacwYLqQu8TzFim+l5ytGxvPmsB5qTF4zn6YhPY2IoVGr9Raj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j3OjFZTB; arc=none smtp.client-ip=91.218.175.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j3OjFZTB"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qzr5u5nyOHcveIVIzXVin5uMFlcqJuyQtDVpldTuy/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787648394; v=1; x=1788253194;
 b=j3OjFZTBxOBbZXn156bp158NgZLaY0sZiSrRDlCB50ws+ThmNw8sq6whitCwpIutFFVcaqVN
 tXSaicL5Vd7AQoFn2gIhySGGX2liVFYua6pH/FXGACEKG5Xo07raate+KvhwEG0ddbjDXCG+ns1
 UFSOv08YbQiqnHW+0VDmRJsE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 4384835a12538f90;
	Tue, 25 Aug 2026 08:59:53 +0000
X-Mizu-Trace-ID: 4384835a12538f90
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Stefan Teodorescu <fane@google.com>,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
Date: Tue, 25 Aug 2026 09:59:45 +0100
Message-Id: <20260825085948.1674721-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825085948.1674721-1-fuad.tabba@linux.dev>
References: <20260825085948.1674721-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pkvm_vcpu_init_sve() clamps only the upper bound of the host-provided
sve_max_vl, so an invalid vector length reaches sve_state_size_from_vl()
and the WARN_ON() there, which is fatal at EL2. The existing
!sve_state_size test rejects such a length, but only after the macro has
run.

Check sve_vl_valid() before deriving the state size. A valid length
cannot yield a zero size, so the !sve_state_size test goes with it.

Fixes: 5db1bef93342 ("KVM: arm64: Track SVE state in the hypervisor vcpu structure")
Reported-by: Stefan Teodorescu <fane@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 24d6f164129ac..095ebfce91b08 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -460,14 +460,15 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 
 	/* Limit guest vector length to the maximum supported by the host. */
 	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
-	sve_state_size = sve_state_size_from_vl(sve_max_vl);
 	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
 
-	if (!sve_state || !sve_state_size) {
+	if (!sve_vl_valid(sve_max_vl) || !sve_state) {
 		ret = -EINVAL;
 		goto err;
 	}
 
+	sve_state_size = sve_state_size_from_vl(sve_max_vl);
+
 	ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
 	if (ret)
 		goto err;
-- 
2.39.5

