Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263A04C1516;
	Tue, 15 Sep 2026 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488165; cv=none; b=XiV5MzZrzomSJtGm/Mtr5cvBIgbOWIAqU9PuN+tSkPPbVHRL3iMftvuKRtWxdyoUv8/NGYA6bNkBXPTfkx87sCW2k0Ddbb0dq7iN5r8bG9fQZuvwGRvyQi7CaGBuUipRfFgS9FwoCUzEcQSSDfQCu9HiaEQ2+J+JGLzWPCCE4z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488165; c=relaxed/simple;
	bh=22gesudg8073MgbQnGHHio9ZG47S1o4pC17iaDfRE1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWtDQ+cpa4jDqY/ysBDdUEEdtM8yeh02zNSvvKy62prQ/NfCW99n+W4stp9CFNg5wge04VWFW/l1PiahEa1tNUF9ayuA0Xz5Z5biN5Cimfn4Fi2j4bbfDYmBI7GFMOfQgW6ptTgxg2XBtffeU54DO//N1z6+LD16Zvin7g++CLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VA627VA8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VA627VA8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F9A61570;
	Tue, 15 Sep 2026 09:02:37 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 682F73F882;
	Tue, 15 Sep 2026 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488161; bh=22gesudg8073MgbQnGHHio9ZG47S1o4pC17iaDfRE1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VA627VA8W1VJco18HSGHTgCmYqW7eNkG8c11Tmu0VK0RZIDReyB2TK8A00YGoM7zn
	 biLItBO4p2vdxPwDwEHp2v33cmIzPivex8AuSSPakEYLwKMMLeEPK+P66+JlSY7JZW
	 yR6yD7mkN2c727GfX8/WUQTs2afSGfWhY908GzCo=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 16/23] KVM: arm64: CCA: Add bare minimal S2 operations for Realm
Date: Tue, 15 Sep 2026 17:01:34 +0100
Message-ID: <20260915160141.3543048-17-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915160141.3543048-1-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bare minimal MMU operation hooks for Realms. The mem_abort handling is
chosen as the default KVM variant. However this cannot be reached for Realms
yet and we would need real RMI command support to make it fully functional.

RMM takes care of the TLB flushing as required, when the Stage2 is modified.
So host doesn't need to do anything explicitly. RMM doesn't support
access flags for the stage2, even for the shared IPA.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/mmu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 559a8286807cd..ac86b5a41c315 100644
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
@@ -209,6 +215,13 @@ static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
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
@@ -2881,6 +2894,17 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
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

