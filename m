Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B20A3F0749
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787648404; cv=none; b=Q3/fdisJTlu9wp95WxLBTaVUqirWDkh7i/GQzWkzhCg7PukjZ+K3IR+Ng6KrYM0jgQvWM4j5LffzG1G1ZwNqXUWkqhMJQElUSze3srm4WYMfOaoLuOgITS75Jie/DyD53cRrAdYqzQtlJl1kKE0V7pCrxm1l2nw3+nbNW/O9Ols=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787648404; c=relaxed/simple;
	bh=k4w2yytoDHZE0wCz7242BNWe7ZWxIERicnhL5Vmij0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FxwWWeUk/vaeqBvbCohLL8g1g4nbwna54dVwVsX2LbDvOxtbnrulEdM/gqD5ws7y1upb3BIg3mM23wi9XSV8tdsZ1tekzjTz2ef8HZii/+vwfCA85cm9Z0dsoF9dfWKPHoZ5+/6N/DLI+qc2U/5nvbeDonPLdV4WCKuR6Dd0umE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l0jglARL; arc=none smtp.client-ip=95.215.58.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l0jglARL"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=k4w2yytoDHZE0wCz7242BNWe7ZWxIERicnhL5Vmij0I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787648400; v=1; x=1788253200;
 b=l0jglARLlnQBxD+OijYoGIoFq9pxQ9aQlpAkcAHwS56fR1guDG4LBWY7cl9Cxf++2Oto5K4E
 EChzzSdPqNQ+6+Qyp9MrrvoGO1F9LEl8EKXH2TdIzWTAxgNVN2Moer3fBbKQrCe5JoQpc3pzyXx
 NyhCz91AjJkgTDeTacU75inw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id c08eced77c6b2cfb;
	Tue, 25 Aug 2026 09:00:00 +0000
X-Mizu-Trace-ID: c08eced77c6b2cfb
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
Subject: [PATCH 4/4] KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2
Date: Tue, 25 Aug 2026 09:59:48 +0100
Message-Id: <20260825085948.1674721-5-fuad.tabba@linux.dev>
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

pkvm_init_features_from_host() takes KVM_ARCH_FLAG_GUEST_HAS_SVE and
KVM_ARM_VCPU_SVE from the host separately, but pkvm_vcpu_init_sve()
tests the bit while vcpu_has_sve() reads the flag. A host that sets the
flag without the bit gets a vCPU with a NULL sve_state that the world
switch loads the guest's SVE state from.

Derive the flag from the bit, and drop the protected path's copy of the
host's flag, which is dead code since protected VMs are not allowed SVE.

Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 1d8cc984fb88c..6efca70e5f5a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -360,7 +360,7 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &host_arch_flags))
 			hyp_vm->kvm.arch.midr_el1 = host_kvm->arch.midr_el1;
 
-		return;
+		goto out;
 	}
 
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE))
@@ -379,13 +379,14 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
 
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE)) {
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE))
 		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
-		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
-	}
 
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
+out:
+	__assign_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &kvm->arch.flags,
+		     kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_SVE));
 }
 
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
-- 
2.39.5

