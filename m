Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF04355F46
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784027016; cv=none; b=N8r9WKlYWtQZVRDwAUITYDsxwYuYlepOvVyfU6FHiTiTdccdK4GxZjR9owXV7hBxti+Gnxkym8KqcL9duWvBs/2BFhkqBm9gdKIOawSmOUta/n4mwuZd42DS41Mr3bEgt8g9yz6wZhWQv2OpeUtXKEGChSdarPqCJ7r2tfl9wUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784027016; c=relaxed/simple;
	bh=1wVk/tQdaNhnArh4J0BQVcadplivbnaPbQao/4sAzu4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E3Kpn8Q6KKUmp6ecoeVa4UihfWngUxouRTzBmNB5YDxQFuesEPBEVpSyKgl/aw/7YSiEzdIn6F+kByA2v7XaR+MPdXJlP1TAtMxT3d/nRKW1tkRnDFUSlleeRHH/FNvWQhltQLx55eYFlh0nod2Ei/aWXQjNV2Ta56/lq5A56/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jRkIAqW9; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jRkIAqW9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784027012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UgPclGQHh7dNphdFO4WD5DMAk53aRk6exDDyQp10qx4=;
	b=jRkIAqW9xU+yEp9z4uZF+l5JWILsxZz9syYK8tKVl79qvKNeLhZnNVCyA6GqSadTYJoNBY
	9TfJZ1IbkiZKBAjqCeT4jdA9dqfQRKJUorY6APff0Nk6D9t1dkpm1LKu3TjecHeHraA0qo
	5l8XdhA+ThUr25wNqP0bpDaGfOWw7os=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH] arm64: Query per-VM capabilities when selecting vCPU features
Date: Tue, 14 Jul 2026 12:03:29 +0100
Message-Id: <20260714110329.12113-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm_cpu__select_features() and kvm_cpu__configure_features() probe vCPU
feature availability with kvm__supports_extension(), which issues
KVM_CHECK_EXTENSION on the global /dev/kvm fd. That reports the host's
raw capabilities, unaware of any per-VM restrictions.

Protected VMs support a subset of the host's features. The kernel
reflects this on the VM fd (commit a3163dca4817 ("KVM: arm64: Use KVM
extension checks for allowed protected VM capabilities")), while the
global fd still advertises capabilities such as SVE that the VM cannot
use. kvmtool then requests SVE in KVM_ARM_VCPU_INIT, which the kernel
rejects.

Query these capabilities on the VM fd via kvm__supports_vm_extension().
More generally, vCPU feature availability is a per-VM property and is
better checked against the VM fd than the global one.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arm64/kvm-cpu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
index ae5a6eb..3aa7684 100644
--- a/arm64/kvm-cpu.c
+++ b/arm64/kvm-cpu.c
@@ -53,34 +53,34 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
 static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init)
 {
 	if (kvm->cfg.arch.aarch32_guest) {
-		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
+		if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
 			die("32bit guests are not supported\n");
 		init->features[0] |= 1UL << KVM_ARM_VCPU_EL1_32BIT;
 	}
 
 	if (kvm->cfg.arch.has_pmuv3) {
-		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
+		if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_PMU_V3))
 			die("PMUv3 is not supported");
 		init->features[0] |= 1UL << KVM_ARM_VCPU_PMU_V3;
 	}
 
 	/* Enable pointer authentication if available */
-	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
-	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC)) {
+	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+	    kvm__supports_vm_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC)) {
 		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS;
 		init->features[0] |= 1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC;
 	}
 
 	/* Enable SVE if available */
-	if (kvm__supports_extension(kvm, KVM_CAP_ARM_SVE))
+	if (kvm__supports_vm_extension(kvm, KVM_CAP_ARM_SVE))
 		init->features[0] |= 1UL << KVM_ARM_VCPU_SVE;
 
 	if (kvm->cfg.arch.nested_virt) {
-		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
+		if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_EL2))
 			die("EL2 (nested virt) is not supported");
 		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
 		if (kvm->cfg.arch.e2h0) {
-			if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
+			if (!kvm__supports_vm_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
 				die("FEAT_E2H0 is not supported");
 			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
 		}
@@ -123,7 +123,7 @@ static int vcpu_configure_sve(struct kvm_cpu *vcpu)
 
 static int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 {
-	if (kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_SVE))
+	if (kvm__supports_vm_extension(vcpu->kvm, KVM_CAP_ARM_SVE))
 		return vcpu_configure_sve(vcpu);
 
 	return 0;
-- 
2.39.5

