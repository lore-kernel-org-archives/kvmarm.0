Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D9E4BA1FB;
	Thu, 24 Sep 2026 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265993; cv=none; b=GM+44lLRqbSNHZZRNR83o4M3+a25Xj1jUKnJc8GWS6E6mvyKWXWL5fZ/8fV3rYAnrjHZPlXtxPenuWwPf3VXDTzNtu1m4laNgqhTj8Din5HIhiTHO6SVpyj7lYlXBrKiIWUMfxSGKqppXf3SaSyHNyzJRqdr2m6mvFVSvJMXhZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265993; c=relaxed/simple;
	bh=J4qcShf5sghV5L5Y2wcHcCrDh9c4LPadyYpHFo9qgwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtQXvyoZ3u2K44i6u9OOm8zeSY8CDffXqTyxnRMBzjzitJxTXFoPuP0U+bk+qRTXonMyZ3f6Z9nEdYF/GixYNiqSL/2TdQpQgibeK/dmpnvCK18+gHqQvHnb1SnMt5VKtoh8jQNZYh/jcw6HD/y6BNdIjXSgzozOnGPPJhaWSX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aVuot4se; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aVuot4se"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BFEA1E7D;
	Thu, 24 Sep 2026 09:06:28 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 64CBF3FAB1;
	Thu, 24 Sep 2026 09:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265991; bh=J4qcShf5sghV5L5Y2wcHcCrDh9c4LPadyYpHFo9qgwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVuot4serLCoRiU+s6wSR2runjB+8k9giQ14cbikSaWMXrY/Ru9b+Y4oTOX6lUyp9
	 1fllwkIVQxlBTs1OZVU3E6g96MI0pa54Bpf3hHH/CiDRdwC9StDwTk+MfRxBGnKs6i
	 1Vl4dZDxf7l0oBa2Uyoj1TKRpIrk5NylkBzZXOs8=
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
Subject: [PATCH v20 16/22] KVM: arm64: CCA: Add bare minimal S2 operations for Realm
Date: Thu, 24 Sep 2026 17:04:58 +0100
Message-ID: <20260924160504.853911-17-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
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

