Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611E74334A6;
	Mon,  5 Oct 2026 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191345; cv=none; b=hr51faF5KgqOGmVfFXhhYN6NxTElsHQ0StgUaa/8IOsTmV+2C3502X3oitNS2Rf4O+OVF3Um8QrCHPPz4ietUSztvc0nnKfpwUYisNU+8YPagGu2h7EMp5x0lGBVM9AIUj6+ca+RVU3HPVg6iVojLMexPt03uxLuh4FtKwzjPtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191345; c=relaxed/simple;
	bh=H+4kqsPac3dmJA9PfDo6eks6Egeh4gjjwuOEOQNZra0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQwx0CigweD/ejjCcDwJynzIRXUT1pO28Mvn8tIRcPCcFHK2AgRwWfQ7sF3jkJWUIk7fs0ghtJMuMPKlfLJXDDke7DtrofDk3qf+pmIOq+zvhU4dYFtO/+GGznVn5GqWdggcu+75pV+fhkQTRFkqGkt0CdVBN/TV4OCxs5hJ4kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kB5cmTdC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kB5cmTdC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C7351684;
	Mon,  5 Oct 2026 02:08:59 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EE1EE3F66F;
	Mon,  5 Oct 2026 02:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191342; bh=H+4kqsPac3dmJA9PfDo6eks6Egeh4gjjwuOEOQNZra0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kB5cmTdC3/QvQPvMHhhzr4ilHk/vLTJ1DRe2iz5TSOF2On9v/1dzIXbH56Gwkbwl+
	 b0krWpkb3oZRm5uF33KjmSbe6YwXjH0/CvoItNnd/E31DdN23kaLqCuBiFjA3SS8p8
	 Rg3oLAyj+i0TZVIrar8E2auShoGvx5Iyyg3ELDTo=
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
Subject: [PATCH v22 17/23] KVM: arm64: CCA: Add bare minimal S2 operations for Realm
Date: Mon,  5 Oct 2026 10:07:48 +0100
Message-ID: <20261005090754.2140522-18-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
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
functional. Similarly, unmapping stage2 requires RMI command support.
Until then reuse follow protected pKVM hook and ignore unmapping.
This will be addressed in the later series.

RMM takes care of the TLB flushing as required, when the Stage2 is
modified. So host doesn't need to do anything explicitly. RMM doesn't
support access flags for the stage2, even for the shared IPA.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v21:
 - Reuse no_age_gfn for Realms. Also use no_stage2_unmap_range for
   now, until we get proper RMI backed driver.
---
 arch/arm64/kvm/mmu.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 909ea3f545e83..58bc6a85f48b4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -180,6 +180,12 @@ static int kvm_vm_flush_remote_tlbs(struct kvm *kvm)
 	return 0;
 }
 
+static int realm_flush_remote_tlbs(struct kvm *kvm)
+{
+	/* Nothing to do here, RMM does the job */
+	return 0;
+}
+
 /**
  * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
@@ -207,6 +213,13 @@ static int kvm_vm_flush_remote_tlbs_range(struct kvm *kvm,
 	return 0;
 }
 
+static int realm_flush_remote_tlbs_range(struct kvm *kvm,
+					 gfn_t gfn, u64 nr_pages)
+{
+	/* Nothing to do here, RMM does the job */
+	return 0;
+}
+
 int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
 				     gfn_t gfn, u64 nr_pages)
 {
@@ -2896,6 +2909,16 @@ static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
 	.vm_mem_abort			= kvm_vm_mem_abort,
 };
 
+static const struct kvm_vm_s2_ops realm_vm_s2_ops = {
+	.vm_flush_remote_tlbs		= realm_flush_remote_tlbs,
+	.vm_flush_remote_tlbs_range	= realm_flush_remote_tlbs_range,
+	.vm_age_gfn			= no_age_gfn,
+	.vm_test_age_gfn		= no_age_gfn,
+	/* Until we get proper support for unmap */
+	.vm_stage2_unmap_range		= no_stage2_unmap_range,
+	.vm_mem_abort			= kvm_vm_mem_abort,
+};
+
 #define KVM_VM_S2_OPS(flavor, ops)		\
 		[flavor] = &(ops)
 
-- 
2.43.0

