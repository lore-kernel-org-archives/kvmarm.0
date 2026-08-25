Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E163EA97A
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787648398; cv=none; b=PrhIrZuDW+QrwF60rZ8TcoQ/SLvQd+gDPU579cD267uY6WnQR1ToOyI9FlXgmJdmIf5J+ZUauDSQp/Mdk8bx5pNxIpIWOsc9fSn2Ng0zzaSsn2H0R2kXdQ810mSDfa6ryCI+WWASQvIEDQX1rQGsCzu16aElAXrkWl0DZ9pJsiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787648398; c=relaxed/simple;
	bh=LjE9PUUTQJc3Mt/mX5qIW0W4SIgnuYSMj4Bego/GGoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mrhJj1YcbdDvwr7MwE+cq0suB0pRMZ5e40cIeXAcD4B4wY7QZNu0XIGQXss7zUuxGlDxpnJLPi3Py9/DAPf+pyjzZe9wA7yAvxa3MLfniOj/RJ5XJfoA7ZJ5wR67S5sY2z0UKjet4x40sE+gum83s3F7UC8P3FxW+pN1lbFP2cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PizeKtKN; arc=none smtp.client-ip=95.215.58.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PizeKtKN"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LjE9PUUTQJc3Mt/mX5qIW0W4SIgnuYSMj4Bego/GGoo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787648394; v=1; x=1788253194;
 b=PizeKtKNVePp47zcXi4tGyWtNRvk0XL+iIwQqHTBQbuvzuNoPc86Zb58UuZi+HT9hzdBHnFU
 Be5pvemwNA+93yVZnHANCGbOwkcELitLVL/PLp0MC/Tb74JNHd29ootKvuFFDIXZKdoGWppOUlA
 J4JVq7NaRo59if/zZ4xKNH2k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id e9bb1680c418ec1f;
	Tue, 25 Aug 2026 08:59:54 +0000
X-Mizu-Trace-ID: e9bb1680c418ec1f
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
Subject: [PATCH 2/4] KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
Date: Tue, 25 Aug 2026 09:59:46 +0100
Message-Id: <20260825085948.1674721-3-fuad.tabba@linux.dev>
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

pkvm_vcpu_init_sve() clears KVM_ARM_VCPU_SVE in kvm->arch.vcpu_features
when it fails, but vcpu_has_sve() tests KVM_ARCH_FLAG_GUEST_HAS_SVE,
which is left set. Later vCPUs on that VM then skip the SVE setup and
register with a NULL sve_state, which the guest's first FP access hands
to sve_load_state().

Return the error without touching vcpu_features.

Fixes: 5db1bef93342 ("KVM: arm64: Track SVE state in the hypervisor vcpu structure")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 095ebfce91b08..73e6ee059eebb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -451,7 +451,7 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	unsigned int sve_max_vl;
 	size_t sve_state_size;
 	void *sve_state;
-	int ret = 0;
+	int ret;
 
 	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
 		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
@@ -462,24 +462,19 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
 	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
 
-	if (!sve_vl_valid(sve_max_vl) || !sve_state) {
-		ret = -EINVAL;
-		goto err;
-	}
+	if (!sve_vl_valid(sve_max_vl) || !sve_state)
+		return -EINVAL;
 
 	sve_state_size = sve_state_size_from_vl(sve_max_vl);
 
 	ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
 	if (ret)
-		goto err;
+		return ret;
 
 	vcpu->arch.sve_state = sve_state;
 	vcpu->arch.sve_max_vl = sve_max_vl;
 
 	return 0;
-err:
-	clear_bit(KVM_ARM_VCPU_SVE, vcpu->kvm->arch.vcpu_features);
-	return ret;
 }
 
 static int vm_copy_id_regs(struct pkvm_hyp_vcpu *hyp_vcpu)
-- 
2.39.5

