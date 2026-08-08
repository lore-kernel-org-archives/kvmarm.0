Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB737272816
	for <kvmarm@lists.linux.dev>; Sat,  8 Aug 2026 00:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786149594; cv=none; b=bYD+1ERYMgvujWQPH2s9FMdOmLTffCIvKospATvuF4ax6doAdC1AZvuozN8VKqzxqMPTOSxZ+GUSN5qbFIruuYBELjXh+su0qd7F43zY3S1s7SxObCb/AWrCLxEWlBeF7bK62rddRvJXZ1XDQIuKYz5bn2suBLYjB5INypcqWmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786149594; c=relaxed/simple;
	bh=o9s4z8td3QLSF5CnTXE0zRsB5Fv6Bk4sYfCu0xzzGKk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z/o8PBB9LMxyTduChVjFCfHRm5ih1RefByY5R+Ux9p1Xk0a2tOH6lbP5JPHvnvOWutnwwi9KlUQhdUz+wzfBJ4RH7IN5k7JPzT0uAtILwn9SngZNzQQEm1zHqr+OOuDOw3lq4laTEE1FOWCht22zR//rqJnkK8mZIlm8uj5I3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VGYR1nUD; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGYR1nUD"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f703a9d05so35910f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 17:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786149591; x=1786754391; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MSMRR2LWS0eYsjyx6GvhLb6OzJlZLcL9WlAoG1vJi74=;
        b=VGYR1nUD+/OWTp4DAHRUXkpHBKj9feqlMSMRXqyGIXW6D6O5bMdEF5L2k3hGzEyzgM
         GFU+/tKSl7XXtXlc4gF8hsHmqT6e/VFzBrh5KidNuo0lZ4wfRB1nECKiTv9OWvw6Aeec
         KRsIWY3Lsu0Z6WqhmVg3Q7C/ZqRvRC8SwZmv0iZatx5y2eKh28/B0OL7qdpE0YsTVsVm
         +yzMZmSDZ2e5J1DF4qgnAanjcQ0g/tyNGseVXuJRZduEfGz1DrH3UaU+zhcqcko/KYb7
         SAwOt3nKNF+13XzhYuOXcDSNM0N0byjKK3Cy3mjr18u8zMlJJr8Xt/QEhjHc7mw4Fy0m
         p+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786149591; x=1786754391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MSMRR2LWS0eYsjyx6GvhLb6OzJlZLcL9WlAoG1vJi74=;
        b=AZtVWxouPz6lUz/ODGZ+yylE/tas6NuiV92tjWsB/iVd9OJkcts43QarzZUi8omMWQ
         t6eG5J9yq2ApIukRv6uFfLwsDq1tQyOJb4BIEV0/bEbXI6ObIxS1idNB+v5rluQlXaaq
         UuAiMq+/oEqFcRkfFByuhtee/5jkerfIirSk1wm3BmzgKLNWefoYd+gsHTLQK/fZQ3xZ
         g2UFRTp12WeaCrugY6loxu8UJRQXSZJ0ryIbvHo2ek/rKpIGOSKrzpv//NuVtNjpZj5h
         SFYe0Q5PJ52CVfGCOXLuCppev9QbUdTI6UgRD2KYzf4rOkAqoHVNseOd2n2Sip+wVfCA
         nLiA==
X-Forwarded-Encrypted: i=1; AHgh+Rrr774VBReySc63ghPi2ycbsdA9+kSveX9crNX79ih3L2ric7nBFB29rGb3UJflwExOpveNMl0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDGPdwroI0mIPK7ef9b5FijWloXD0C0A6fu14VprpHNMD+C24H
	lEAJygoGnsMJIMtOMVjL2kvWzwhDqSziIXw6yabrJqmTBhoDDiHusYin
X-Gm-Gg: AR+sD11rYVuIYH87LWjzwvOMHimHDFHaU9lk1Tm5PNMj/505KcocSgK7M6ijUfIgtf2
	APSPz6v0c5Mz7pEFBWbeH7eKAXa0OWJf7iw4Jbkd1hlFMBPnz04y91KEjY3+cgMMV729QnzwCfp
	rnN7feGixdd6VmpX0D3uEa2z0PTT+H6iUy7ftxDUKYzcBNVtON0lbf3+NEgtHRzKFKHdFMhfq21
	BJPQFtds+CyxyedczcU7VGp1aXrQGc836Ttrh8q4c3xsqWuPrgp4RQZ9KPDn17LUS0fidbpsR88
	Os2GEjmxKG1c+LH5f952k8xIID8FrHXFRI7OjfHppfWVwPB7yrwLzh2d5gVp0JIuBmIMf7dd1nx
	mbP2k876jsdeL5mbkxhiUMsYleskHJ3Ky4IDuLnNuo8nsjrSYXKHaGbanvskEinH8R51Jro+XvB
	mzYUhTbpvmbbGMU9NL9DKZjBPeK7977LesDm6q+nF6JZoXm3aEteyTt+Zm1BmvEiS6w72JO+JMP
	kmEv2uB+TzSBc0Uk7AxcacCoAn4moQ1g2G/0rAsNAXrB2RJvFPEY6Szx9wxwPm38lUEGZSAbuuP
	sgfR8rpfsWuQo0N4+ucXL6r9u0XDfJLdhWAM1aMfHx9QaES4JlIJXHJk3FuutghmqF/Z
X-Received: by 2002:a5d:64ce:0:b0:47f:93e4:5389 with SMTP id ffacd0b85a97d-480026d5f84mr10771351f8f.20.1786149590548;
        Fri, 07 Aug 2026 17:39:50 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b105-e101-a437-493a-4de9-ee3e.310.pool.telefonica.de. [2a02:3100:b105:e101:a437:493a:4de9:ee3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f9182sm10345921f8f.28.2026.08.07.17.39.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Aug 2026 17:39:49 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	grayhat@foxmail.com
Subject: [PATCH v5] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed addresses
Date: Sat,  8 Aug 2026 02:39:43 +0200
Message-Id: <20260808003943.60963-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_vcpu_init_nested() can grow kvm->arch.nested_mmus while initialising
another vCPU: it copies the MMUs, publishes the new allocation, and frees
the old one. It updates pgt->mmu back-pointers, but not hw_mmu, leaving
already-running vCPUs with pointers to freed memory. hw_mmu cannot be
fixed up the same way: a running vCPU reads it without holding mmu_lock.
The nested S2 ptdump file's debugfs private data is also affected, as it
points into the freed array.

KASAN reports an access through the stale hw_mmu pointer as a
slab-use-after-free in kvm_handle_guest_abort().

Turn nested_mmus into a pointer table allocated once for the maximum
number of vCPUs during VM creation. Allocate the MMUs separately as
vCPUs are initialised and append their pointers to that table. The MMU
objects never move, so cached hw_mmu pointers, pgt->mmu back-pointers,
and ptdump private data remain valid.

Two issues in the old implementation are also fixed:

- The old failure path passed uninitialised MMUs to
  kvm_free_stage2_pgd(), which derives kvm from mmu->arch and can
  therefore dereference an invalid pointer. Only call
  kvm_free_stage2_pgd() for initialised MMUs.
- Previously, initialisation of the new MMUs was not ordered before
  publication of nested_mmus_size. Fix this by taking mmu_lock when
  increasing nested_mmus_size.

Fixes: 4f128f8e1aaa ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Cc: stable@vger.kernel.org
Suggested-by: Marc Zyngier <maz@kernel.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Changes in v5:
- Free the fixed nested_mmus pointer table from kvm_arch_destroy_vm()
  when generic VM creation fails after kvm_arch_init_vm() succeeds
  (reported by Sashiko AI).

Changes in v4:
- The code diff changes only arch/arm64/kvm/nested.c compared to v3:
  - Restore v2's centralized error paths (Wei-Lin Chang).
  - Restore explicit write_lock()/write_unlock() to avoid mixing goto-based
    error handling with cleanup guards.
  - Drop the allocation-failure comment (Marc Zyngier).

v3: https://lore.kernel.org/r/20260806192451.10169-1-kmehltretter@gmail.com/

Changes in v3:
- Tighten the commit message (Wei-Lin Chang).
- The code diff changes only arch/arm64/kvm/nested.c compared to v2:
  - Drop the redundant pointer-table allocation comment and use
    guard(write_lock) when publishing nested_mmus_size (Wei-Lin Chang).
  - Rewrite the error handling without gotos.

v2: https://lore.kernel.org/r/20260806062352.93489-1-kmehltretter@gmail.com/

Changes in v2:
- Allocate the fixed pointer table during VM creation, as suggested by Marc.
- Allocate the MMUs individually and simplify the error and teardown paths.
- Drop the selftest patch that triggered KASAN.
  It is not a good fit for the existing suite.

v1: https://lore.kernel.org/r/20260803224405.41468-1-kmehltretter@gmail.com/

 arch/arm64/include/asm/kvm_host.h   |  6 +-
 arch/arm64/include/asm/kvm_nested.h |  2 +-
 arch/arm64/kvm/arm.c                |  8 ++-
 arch/arm64/kvm/nested.c             | 95 ++++++++++++++++-------------
 4 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5..59d1d77ee116 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -319,10 +319,10 @@ struct kvm_arch {
 	u64 fgu[__NR_FGT_GROUP_IDS__];
 
 	/*
-	 * Stage 2 paging state for VMs with nested S2 using a virtual
-	 * VMID.
+	 * Stage 2 paging state for VMs with nested S2 using a virtual VMID.
+	 * MMUs are allocated separately to keep their addresses stable.
 	 */
-	struct kvm_s2_mmu *nested_mmus;
+	struct kvm_s2_mmu **nested_mmus;
 	size_t nested_mmus_size;
 	int nested_mmus_next;
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 012d711034d1..d21be647ac57 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -66,7 +66,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 extern bool forward_debug_exception(struct kvm_vcpu *vcpu);
-extern void kvm_init_nested(struct kvm *kvm);
+extern int kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
 extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..12bb94a95b36 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -223,8 +223,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_unlock(&kvm->lock);
 #endif
 
-	kvm_init_nested(kvm);
-
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -239,6 +237,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto err_free_cpumask;
 
+	ret = kvm_init_nested(kvm);
+	if (ret)
+		goto err_uninit_mmu;
+
 	if (is_protected_kvm_enabled()) {
 		/*
 		 * If any failures occur after this is successful, make sure to
@@ -267,6 +269,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 err_uninit_mmu:
 	kvm_uninit_stage2_mmu(kvm);
+	kvfree(kvm->arch.nested_mmus);
 err_free_cpumask:
 	free_cpumask_var(kvm->arch.supported_cpus);
 err_unshare_kvm:
@@ -317,6 +320,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		pkvm_destroy_hyp_vm(kvm);
 
 	kvm_uninit_stage2_mmu(kvm);
+	kvfree(kvm->arch.nested_mmus);
 	kvm_destroy_mpidr_data(kvm);
 
 	kfree(kvm->arch.sysreg_masks);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43..8376adbb8736 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -44,11 +44,18 @@ struct vncr_tlb {
  */
 #define S2_MMU_PER_VCPU		2
 
-void kvm_init_nested(struct kvm *kvm)
+int kvm_init_nested(struct kvm *kvm)
 {
-	kvm->arch.nested_mmus = NULL;
+	kvm->arch.nested_mmus = kvcalloc(KVM_MAX_VCPUS * S2_MMU_PER_VCPU,
+					 sizeof(*kvm->arch.nested_mmus),
+					 GFP_KERNEL_ACCOUNT);
+	if (!kvm->arch.nested_mmus)
+		return -ENOMEM;
+
 	kvm->arch.nested_mmus_size = 0;
 	atomic_set(&kvm->arch.vncr_map_count, 0);
+
+	return 0;
 }
 
 static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
@@ -66,11 +73,17 @@ static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	return kvm_init_stage2_mmu(kvm, mmu, kvm_get_pa_bits(kvm));
 }
 
+static void free_nested_s2_mmu(struct kvm_s2_mmu *mmu)
+{
+	kvm_free_stage2_pgd(mmu);
+	kfree(mmu);
+}
+
 int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_s2_mmu *tmp;
-	int num_mmus, ret = 0;
+	struct kvm_s2_mmu *mmu;
+	int num_mmus, ret, i;
 
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features) &&
 	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
@@ -83,52 +96,46 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.ctxt.vncr_array)
 		return -ENOMEM;
 
-	/*
-	 * Let's treat memory allocation failures as benign: If we fail to
-	 * allocate anything, return an error and keep the allocated array
-	 * alive. Userspace may try to recover by initializing the vcpu
-	 * again, and there is no reason to affect the whole VM for this.
-	 */
 	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
 
-	if (num_mmus > kvm->arch.nested_mmus_size) {
-		tmp = kvcalloc(num_mmus, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
-		if (!tmp)
-			return -ENOMEM;
-
-		write_lock(&kvm->mmu_lock);
+	if (num_mmus <= kvm->arch.nested_mmus_size)
+		return 0;
 
-		if (kvm->arch.nested_mmus_size) {
-			memcpy(tmp, kvm->arch.nested_mmus,
-			       size_mul(sizeof(*tmp), kvm->arch.nested_mmus_size));
+	lockdep_assert_held(&kvm->arch.config_lock);
 
-			for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
-				tmp[i].pgt->mmu = &tmp[i];
+	for (i = 0; i < S2_MMU_PER_VCPU; i++) {
+		mmu = kzalloc_obj(*mmu, GFP_KERNEL_ACCOUNT);
+		if (!mmu) {
+			ret = -ENOMEM;
+			goto err_free_mmus;
 		}
 
-		swap(kvm->arch.nested_mmus, tmp);
-
-		write_unlock(&kvm->mmu_lock);
+		ret = init_nested_s2_mmu(kvm, mmu);
+		if (ret) {
+			kfree(mmu);
+			goto err_free_vncr;
+		}
 
-		kvfree(tmp);
+		kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i] = mmu;
 	}
 
-	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
-		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
+	write_lock(&kvm->mmu_lock);
+
+	kvm->arch.nested_mmus_size += S2_MMU_PER_VCPU;
 
-	if (ret) {
-		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
-			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
+	write_unlock(&kvm->mmu_lock);
 
-		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
-		vcpu->arch.ctxt.vncr_array = NULL;
+	return 0;
 
-		return ret;
-	}
+err_free_vncr:
+	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+	vcpu->arch.ctxt.vncr_array = NULL;
 
-	kvm->arch.nested_mmus_size = num_mmus;
+err_free_mmus:
+	while (i--)
+		free_nested_s2_mmu(kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i]);
 
-	return 0;
+	return ret;
 }
 
 struct s2_walk_info {
@@ -725,7 +732,7 @@ void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 	write_lock(&kvm->mmu_lock);
 
 	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!kvm_s2_mmu_valid(mmu))
 			continue;
@@ -767,7 +774,7 @@ struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
 	 *   if S2 translation is disabled.
 	 */
 	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!kvm_s2_mmu_valid(mmu))
 			continue;
@@ -806,7 +813,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	for (i = kvm->arch.nested_mmus_next;
 	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
 	     i++) {
-		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
+		s2_mmu = kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
 
 		if (atomic_read(&s2_mmu->refcnt) == 0)
 			break;
@@ -1223,7 +1230,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 		return;
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
@@ -1242,7 +1249,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		return;
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
@@ -1261,7 +1268,7 @@ void kvm_nested_s2_flush(struct kvm *kvm)
 		return;
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
@@ -1273,10 +1280,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	int i;
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
-			kvm_free_stage2_pgd(mmu);
+			free_nested_s2_mmu(mmu);
 	}
 	kvfree(kvm->arch.nested_mmus);
 	kvm->arch.nested_mmus = NULL;
-- 
2.39.5 (Apple Git-154)

