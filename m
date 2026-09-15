Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CD84BE437;
	Tue, 15 Sep 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488151; cv=none; b=uCsAmaFknQvmJHaQP21rD1kDFMvd+GK0MQ7EceljjZFVA6UHrnHVacD4oHQYbSbkKP77VPRxpIPrNMtB0H0ntQ/1tOuu27wGqPk7GNaIm26y7Jgu/lSp1XDbWQ1H21JZF/G+5hQl4xgWkdGazo4bCHkY8SgBGPaOvDSnTkx3+e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488151; c=relaxed/simple;
	bh=qj0/UumNi5rDv9Vg9CrV5dfdz5rbhLtkWFeMlHj/0ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeSrd31Ynfbdq39pN+2LDCmgGSkzGTWOk6Z18ErniosFQKmCVZQQzwGL46aNy+HufLid//GbByIhC9IcPoVs9FHedxrCEP8FSMJF+8RLXbAQgwIOa0Pbq1TrjsKP0rCy/E45cnAy6U0XCWXpA8BIXzR/al+Ibt4SXGyt+ApLQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uc/omc6L; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uc/omc6L"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 962AF1BF3;
	Tue, 15 Sep 2026 09:02:25 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CAD93F882;
	Tue, 15 Sep 2026 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488149; bh=qj0/UumNi5rDv9Vg9CrV5dfdz5rbhLtkWFeMlHj/0ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc/omc6LolGCKoufSQrM1eLdyE1xcH7d+Puq7h5KkYr2fAslOBuR9wgoGo+lGo/xu
	 bKhiV67zsxwjjhEyvws5kVS5N6sdOX39WqbvP77n79jT9mqJ4Kn918LdoQo7OXkQAG
	 M2576vXCPvQdJs5xBMZHqUrcDrbAKbH7nFxM1HmI=
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
Subject: [PATCH v18 12/23] KVM: arm64: Widen the scope of "protected" VMs
Date: Tue, 15 Sep 2026 17:01:30 +0100
Message-ID: <20260915160141.3543048-13-suzuki.poulose@arm.com>
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

On arm64 we have "protected" VMs that run on PKVM as a confidential compute
guest. Given we already have the construct of "kvm_vm_is_protected" in the core
KVM code, use that for all confidential compute guests including Realms that
we are about to add.

Use the VM flavor to detect the "protected" VMs by introducing a marker.
Add explicit helper to detect if a given VM is a "protected" VM under PKVM.
Change the existing users that precisely want to check the VM type. These
include :
  - kvm_arch_prepare_memory_region - For preventing memslot changes after pVM
    creation.

All the others are retained as a wider check for confidential guest VMs.
These are:
 - kvm_vm_ioctl_set_counter_offset - For disallowing timer offset configuration
 - io_mem_abort for dabt handling without valid syndrome information

Both of which are true for Realms too.

Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
checks in the pkvm hyp specific code doesn't need to change, as the only
protected guests it deals with is "protected PKVM" guests.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 4 +++-
 arch/arm64/kvm/mmu.c              | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7ce46d853c47e..1bb43c57fb0f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -329,6 +329,7 @@ enum kvm_arm_vm_flavor {
 	VM_NVHE,
 	VM_VHE,
 	VM_PKVM,		/* Normal guests on pKVM */
+	MARKER(__VM_PROTECTED),
 	VM_PROTECTED_PKVM,	/* Protected VM */
 	VM_FLAVOR_MAX,
 };
@@ -1535,7 +1536,8 @@ struct kvm *kvm_arch_alloc_vm(void);
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
 
-#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
+#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
+#define kvm_vm_is_protected_pkvm(kvm)	((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM)
 #define kvm_vm_is_unprotected_pkvm(kvm)	((kvm)->arch.vm_flavor == VM_PKVM)
 
 #define kvm_vm_hyp_is_pkvm(kvm)		(is_protected_kvm_enabled())
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 607c908c15c42..38f3bf772278f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2678,7 +2678,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	hva_t hva, reg_end;
 	int ret = 0;
 
-	if (kvm_vm_is_protected(kvm)) {
+	if (kvm_vm_is_protected_pkvm(kvm)) {
 		/* Cannot modify memslots once a pVM has run. */
 		if (pkvm_hyp_vm_is_created(kvm) &&
 		    (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
-- 
2.43.0

