Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976225372CF;
	Thu,  1 Oct 2026 21:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790888902; cv=none; b=GhVlOmSilolFHY7Zqk8c4DnA7P2px/orWb9ZlZUS+Q0z0FT00nVuiIVtHuvHY8/+tedeYe3A/MEdOOpr5V9mosHXN3HbI4fqdi0LuUEab7DEssr29RHSa2GBGUVARaJbyijZ+JhXEzMl2KS3Sb0TQe2D9JdSTHxLs0jnoYgRkHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790888902; c=relaxed/simple;
	bh=J4qcShf5sghV5L5Y2wcHcCrDh9c4LPadyYpHFo9qgwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksoWYUywB1DJI5uzPfHIN1nTFb1RbYHwcmwkVpLxhL01CqEN+HqtMDz6Xb6W8cXGH/AZXLL6wLRdyu/QZD42BgImik8dtMzoY/BsZ1G8Ot6tal2FLcew4D6hlm7NCGrWm/HKRC3/C1FOzhG/AhANZooVU0VHfGdDINjnBX8Foac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ptiPTb2W; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ptiPTb2W"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B99BB16F8;
	Thu,  1 Oct 2026 14:08:16 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C4D223F86F;
	Thu,  1 Oct 2026 14:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790888900; bh=J4qcShf5sghV5L5Y2wcHcCrDh9c4LPadyYpHFo9qgwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptiPTb2W1mfNipNAtg55EMBx5ylXxd4+raDGT2ZOUJ4zed0z8MdwjsDp8BeaMf6SW
	 1N1yhShVkEMuQU1nv/VB4uc4DBhKUmvADndZ8aF4rzR5cXE3LXdA15x1c7v5y5rDxd
	 en0jfthKHrO5qxatMVfaFdlUZhOdsoiN9V1AEbqw=
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
Subject: [PATCH v21 16/23] KVM: arm64: CCA: Add bare minimal S2 operations for Realm
Date: Thu,  1 Oct 2026 22:06:56 +0100
Message-ID: <20261001210703.1597150-17-suzuki.poulose@arm.com>
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

Add bare minimal MMU operation hooks for Realms. The mem_abort handling
is chosen as the default KVM variant. However this cannot be reached for
Realms yet and we would need real RMI command support to make it fully
functional.

RMM takes care of the TLB flushing as required, when the Stage2 is
modified. So host doesn't need to do anything explicitly. RMM doesn't
support access flags for the stage2, even for the shared IPA.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/mmu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8f21652d3625c..1d2265801e7aa 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -180,6 +180,12 @@ static int kvm_vm_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+static int realm_vm_flush_remote_tlbs(struct kvm *kvm)
+{
+	/* Nothing to do here, RMM takes care of this */
+	return 0;
+}
+
 /**
  * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
@@ -210,6 +216,13 @@ static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
 	return 0;
 }
 
+static int realm_vm_flush_remote_tlbs_range(struct kvm *kvm,
+					   gfn_t gfn, u64 nr_pages)
+{
+	/* Nothing to do here, RMM takes care of this */
+	return 0;
+}
+
 int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
 				     gfn_t gfn, u64 nr_pages)
 {
@@ -2880,6 +2893,17 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
 	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
+static const struct kvm_vm_s2_ops realm_vm_s2_ops = {
+	.vm_flush_remote_tlbs		= realm_vm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= realm_vm_flush_remote_tlbs_range,
+	.vm_mem_abort			= kvm_vm_mem_abort,
+	/*
+	 * Not supported for Realms
+	 *	.vm_age_gfn			= realm_vm_age_gfn,
+	 *	.vm_test_age_gfn		= realm_vm_test_age_gfn,
+	 */
+};
+
 #define KVM_VM_S2_OPS(flavor, ops)		\
 		[flavor] = ops
 static const struct kvm_vm_s2_ops *arm64_vm_s2_ops[] = {
-- 
2.43.0

