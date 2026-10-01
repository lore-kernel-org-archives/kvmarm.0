Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18D453F693;
	Thu,  1 Oct 2026 21:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790888913; cv=none; b=uCdYn3YhwP2Rf0Ir9FvMBRm5k/HkzeQ1XpvoUlCBWexuY/dt5AwFDS9fpEkixFeLbdWZGJmNgiBet0RYt9zoa7eLKY06GDcEjTzgV4CgVNfc9Ot0WaCNCDonSqcooma+Y74jN/OYZHDEF3RIzNnQBHaxyN49w7HBMLHijB1f6u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790888913; c=relaxed/simple;
	bh=2PXwIt14fX6jbq9VY5Nb5EXCg/nGSies41eMDwzPo5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2HfIjTcxTTlLwEB0TN16aZkRltH2s9/yB7qsPPnOB3tL0FLYn+LhBpJgWtnyJPRpXVc+nM2rV17s5A/6pZp1+QfQxph5JsR92/NtRWIBWwhzBY1pv1+AfsnC+OCM6HvJQY2aypT0y98N83UbjuJ+YCt3oekchaWa043wDTeS/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FjT6oZni; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FjT6oZni"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5CDB16F8;
	Thu,  1 Oct 2026 14:08:27 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D0C643F86F;
	Thu,  1 Oct 2026 14:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790888911; bh=2PXwIt14fX6jbq9VY5Nb5EXCg/nGSies41eMDwzPo5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjT6oZniZY0Kc9sjUigR9bNtNa/gdRlA0HH37Aq9ICHOtmbA+T1gJF/u97trC9Iuz
	 BOCcvZ1yFlb428LAzRviF1Eb3WFkqYeXrp8esc+e44/cAefEtVeovbzL1o8C9al3IN
	 2zFjq4q6l2rucLoKdAPJUd8subLotGln3QyDGqWQ=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v21 19/23] KVM: arm64: Prevent unsupported vcpu features for VM types
Date: Thu,  1 Oct 2026 22:06:59 +0100
Message-ID: <20261001210703.1597150-20-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001210703.1597150-1-suzuki.poulose@arm.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent unsupported VCPU features for the protected VCPUs.
Realms and pVM do not support 32bit EL1 or NV yet.
pKVM doesn't rely on the host vcpu features, but still
block the vcpu init if we detect incompatible features.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/arm.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 106b52e556e20..d43ae985ab1b4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1727,11 +1727,12 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
-static unsigned long system_supported_vcpu_features(void)
+static unsigned long system_supported_vcpu_features(struct kvm_vcpu *vcpu)
 {
 	unsigned long features = KVM_VCPU_VALID_FEATURES;
 
-	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
+	if (vcpu_is_protected(vcpu) ||
+	    !cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
 	if (!kvm_supports_guest_pmuv3()) {
@@ -1747,7 +1748,8 @@ static unsigned long system_supported_vcpu_features(void)
 		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
 	}
 
-	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
+	if (vcpu_is_protected(vcpu) ||
+	    !cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
 
 	return features;
@@ -1767,7 +1769,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 	}
 
-	if (features & ~system_supported_vcpu_features())
+	if (features & ~system_supported_vcpu_features(vcpu))
 		return -EINVAL;
 
 	/*
-- 
2.43.0

