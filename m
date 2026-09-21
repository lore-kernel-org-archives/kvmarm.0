Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C329C36B04E
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789972644; cv=none; b=Gnu2eUuP/89KSOApt2vZhnTofCr9e+hCP3YcDIS7IfzC3YI+6CHQ0ptlyCFfMTt0rI95KSvAu0HlkGi+9TmNqQHiYnyMs8gkATuoddApkG8x2UqEEikLkvZ7qWtBqhVkyskaLy3l2KadQ6QpO4U16D5upWurMRaG4opOmpPH7Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789972644; c=relaxed/simple;
	bh=xInHr91a0qeWgwAjrmyy5kozbZsp5gJ/LU1kZ+ytvCI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RFi0F+VPOX5U4E/JhQAQsuXcPZpqPQc/bMOafZnHXSP19hW0U7FE1Knz0pN9GFGnrsDTrFpGGTwuKRqKoH3OIZpLu9Z2vHXQiA/rPBoObXNu7GXojt1/5ABtJ3qGjeAPjLg47niMmih1ZD2OMlKdxeu0uNCFMnS6Dy7S8pptEp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ePvE8ir+; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ePvE8ir+"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xInHr91a0qeWgwAjrmyy5kozbZsp5gJ/LU1kZ+ytvCI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789972640; v=1; x=1790577440;
 b=ePvE8ir+ayPRcq+UxisNyrJK6DWdqH1ZyqHsJ2P9tQWGEdfiDz0PaN9TUDHBNR+oKAOxirU8
 PJM5+A893WNt1/0fszHyQMdenQVb+D28uWyxvWAZz8PJE53nIP7Bx1okizooM9Sq01UyLILUjBb
 +b71jtr7yHDyqqxP0io6vgOw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9592896750a3be0b;
	Mon, 21 Sep 2026 06:37:20 +0000
X-Mizu-Trace-ID: 9592896750a3be0b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jack Thomson <jackabt@amazon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2] KVM: arm64: Restore the VM's feature bitmap when kvm_setup_vcpu() fails
Date: Mon, 21 Sep 2026 07:37:18 +0100
Message-Id: <20260921063718.1604533-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__kvm_vcpu_set_target() copies the requested features into the VM-wide
bitmap before kvm_setup_vcpu() runs and doesn't undo it when setup
fails, so a rejected KVM_ARM_VCPU_INIT leaves the VM recording features
that were never set up. With HAS_EL2 | HAS_EL2_E2H0 on a host without
FEAT_NV1, kvm_vcpu_init_nested() returns -EINVAL before it allocates any
nested stage-2 MMU, and vcpu_has_nv() is then true with
nested_mmus_size == 0; its -ENOMEM paths do the same on a VM's first
INIT.

Nothing in the tree loads a vCPU whose init failed, so this is latent.
The upcoming series that enables KVM_PRE_FAULT_MEMORY for arm64 exposes
it: the generic kvm_vcpu_pre_fault_memory() calls vcpu_load() whether
or not the vCPU has been initialised. After the rejected INIT, the first
call's vcpu_load() finds hw_mmu still set to the canonical MMU and
leaves it alone, but its vcpu_put() takes the vcpu_has_nv() branch into
kvm_vcpu_put_hw_mmu(), which clears hw_mmu. The second call's
vcpu_load() finds hw_mmu NULL and takes the nested branch into
get_s2_mmu_nested(), whose search over nested_mmus_size == 0 leaves
s2_mmu NULL for the BUG_ON(atomic_read(&s2_mmu->refcnt)), under
mmu_lock. On kvmarm/next with the series applied:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000074
  Call trace:
   kvm_vcpu_load_hw_mmu (arch/arm64/kvm/nested.c:891) (P)
   kvm_arch_vcpu_load (arch/arm64/kvm/arm.c:662)
   kvm_vcpu_pre_fault_memory (virt/kvm/kvm_main.c:170 virt/kvm/kvm_main.c:4349)
   kvm_vcpu_ioctl (virt/kvm/kvm_main.c:4639)

Setup reads the VM-wide bitmap, so the copy can't be deferred; restore
the previous value instead when kvm_setup_vcpu() fails.

Fixes: 427733579744e ("KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler")
Link: https://lore.kernel.org/r/20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org/
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
v2:
 - Commit message: say what the prefault series enables, bring the
   two-ioctl walk and the trace up from below the fold, the trace
   decoded, and drop the Fixes: on 1de10b7d13a97, which had nothing
   fallible after the copy (Lorenzo).
 - Fold Lorenzo's Reviewed-by.

Reproduced on kvmarm/next plus the series under QEMU (-cpu max with an
Apple M2 MIDR, which has_nv1() denies; kvm-arm.mode=nested):
KVM_ARM_VCPU_INIT with HAS_EL2 | HAS_EL2_E2H0 returns -EINVAL, then
KVM_PRE_FAULT_MEMORY twice. With the fix both calls return -ENOENT and
the host is unaffected. Applies unchanged to v7.3-rc3.

v1: https://lore.kernel.org/r/20260918120553.163139-1-fuad.tabba@linux.dev/

 arch/arm64/kvm/arm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index eaf583b771931..b25725f91c925 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1685,6 +1685,7 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
 static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 				 const struct kvm_vcpu_init *init)
 {
+	DECLARE_BITMAP(old_features, KVM_VCPU_MAX_FEATURES);
 	unsigned long features = init->features[0];
 	struct kvm *kvm = vcpu->kvm;
 	int ret = -EINVAL;
@@ -1695,11 +1696,15 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	    kvm_vcpu_init_changed(vcpu, init))
 		goto out_unlock;
 
+	/* Setup reads the VM-wide bitmap, so undo the copy if setup fails. */
+	bitmap_copy(old_features, kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
 	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
 
 	ret = kvm_setup_vcpu(vcpu);
-	if (ret)
+	if (ret) {
+		bitmap_copy(kvm->arch.vcpu_features, old_features, KVM_VCPU_MAX_FEATURES);
 		goto out_unlock;
+	}
 
 	/* Now we know what it is, we can reset it. */
 	kvm_reset_vcpu(vcpu);

base-commit: 089e4f3c4862ba3f29dff2361caa8084879194fd
-- 
2.39.5

