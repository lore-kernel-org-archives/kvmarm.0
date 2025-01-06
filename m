Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAEA18A6B2
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 11:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736162678; cv=none; b=HBOnkwJkObdEIaRAFYxn3+mvcGwz2PTLpKlgim4uwhtyBjzwIurc/YF79L7M7qrm7yIUZMYiNSwxBiIT12cuzWqvnO6vGucqQxcfLbp//NyUq7oDfMiHOOLIksllpPaTFfDc21dEiU9x1EDEcaY9M+lbqSqoX1K+USBcEZVE+o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736162678; c=relaxed/simple;
	bh=wkNzgX+6632zYQ3nVhzJr6BzQQt0rGHi51Dqr094L98=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GG0+plxpNMC6JVJ/ZL0YuVjDrtm1Db9Jowgnu7ES4etM3caqZobMCqWaZypDKnDvazuCBCMp5W3gg0XKDxIibGwzBPSIW//oNTWZY4gZ7DYE5UICW2y9b6CjznSVliM1Er996bAjJU9gSqQP+G1YvAokDveB74peGFSHTKJnKLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6C3A1476;
	Mon,  6 Jan 2025 03:25:03 -0800 (PST)
Received: from login2.euhpc.arm.com (login2.euhpc.arm.com [10.6.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BE5123F59E;
	Mon,  6 Jan 2025 03:24:34 -0800 (PST)
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev,
	maz@kernel.org,
	tabba@google.com
Subject: [PATCH] KVM: arm64: Fix FEAT_MTE in pKVM
Date: Mon,  6 Jan 2025 11:24:21 +0000
Message-Id: <20250106112421.65355-1-vladimir.murzin@arm.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure we do not trap access to Allocation Tags.

Fixes: b56680de9c64 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 071993c16d..dd55bff6a6 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -229,6 +229,9 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
 	if (vcpu_has_ptrauth(vcpu))
 		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+
+	if (kvm_has_mte(vcpu->kvm))
+		vcpu->arch.hcr_el2 |= HCR_ATA;
 }
 
 /*
@@ -332,6 +335,9 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	struct kvm *kvm = &hyp_vm->kvm;
 	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
 
+	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
+		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
+
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		bitmap_copy(kvm->arch.vcpu_features,
-- 
2.24.0

