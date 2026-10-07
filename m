Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC8041169F;
	Wed,  7 Oct 2026 07:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791358606; cv=none; b=BLsijuoB40IftFDCuqxtLW1wsf6vZvZEJ0yqYqN42vT/1S8ii6QwgtciZ8YanhN5d3S1XkvsPDqP/RsDTiWncwat17g6xpylJLLeolQuZupCO/PLWlNS3BqBLM3UFM9schFesTgFT9n6ir114i3w6XnnMF/1NST6u9v8GhQWW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791358606; c=relaxed/simple;
	bh=vccP3PxOpy/dguFeUeUDJUfsgRBp6pEFcWHYQiK1mIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiLCDLgACZ4B+t8XEmP2/L2w7wC4PjYlh3rNYTa9dfJ3scYBTJZ4TG2K4ZZSOcwhasjfqm7GXtrEds9lMVQJsLbkrsWNXep9Yg3JMNWDcVIQvPR4u5LtP2yLPPgLETWUJUn+x0W+mtQLhZMMpUdIxOI1nVLfLAR5av8QazQvbVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LZBjYezZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LZBjYezZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C11E41BA8;
	Wed,  7 Oct 2026 00:36:40 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9543D3F763;
	Wed,  7 Oct 2026 00:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791358604; bh=vccP3PxOpy/dguFeUeUDJUfsgRBp6pEFcWHYQiK1mIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZBjYezZYR8DyL4iFNk4gX7d2HGciOOlrKZcWy9iZ764NePYh45UeC6WeyTtPvLFJ
	 eQvQApGn0ot+3Tjf0Hrsjdt2WJH7bdRpV8sphq1jioet1xZ+RYpEblgEpVI4XMexVw
	 Q7iemDdyU0a7cfYvQBYDarW/7pha3xHX0r7s74Zs=
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
Subject: [PATCH v23 14/14] KVM: arm64: Prevent unsupported vcpu features for VM types
Date: Wed,  7 Oct 2026 08:35:37 +0100
Message-ID: <20261007073537.2454351-15-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007073537.2454351-1-suzuki.poulose@arm.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent unsupported VCPU features for the protected VCPUs. Realms and pVMs
not support 32bit EL1 or NV yet. pKVM doesn't rely on the host vcpu
features for protected VMs and hand picks features while hyp_vcpu is
initialised. Block the features early in the vcpu init if we detect
incompatible features.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v22:
 - Start off with the base features supported per VM type
---
 arch/arm64/include/asm/kvm_host.h |  7 +++++++
 arch/arm64/kvm/arm.c              | 11 ++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4d0e6bd2009ac..97089c81d6428 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -42,6 +42,13 @@
 #define KVM_VCPU_MAX_FEATURES 10
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
+/* As dictated by kvm_pkvm_ext_allowed() */
+#define KVM_PROTECTED_VCPU_VALID_FEATURES		\
+	(BIT(KVM_ARM_VCPU_POWER_OFF)		|	\
+	 BIT(KVM_ARM_VCPU_PSCI_0_2)		|	\
+	 BIT(KVM_ARM_VCPU_PTRAUTH_ADDRESS)	|	\
+	 BIT(KVM_ARM_VCPU_PTRAUTH_GENERIC))
+
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f31d31fa27ad9..a53f2b2799cf8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1668,9 +1668,14 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
-static unsigned long system_supported_vcpu_features(void)
+static unsigned long system_supported_vcpu_features(struct kvm_vcpu *vcpu)
 {
-	unsigned long features = KVM_VCPU_VALID_FEATURES;
+	unsigned long features;
+
+	if (vcpu->kvm->arch.vm_flavor == VM_PROTECTED_PKVM)
+		features = KVM_PROTECTED_VCPU_VALID_FEATURES;
+	else
+		features = KVM_VCPU_VALID_FEATURES;
 
 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
@@ -1708,7 +1713,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 	}
 
-	if (features & ~system_supported_vcpu_features())
+	if (features & ~system_supported_vcpu_features(vcpu))
 		return -EINVAL;
 
 	/*
-- 
2.43.0

