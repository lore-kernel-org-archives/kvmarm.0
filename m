Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397694C9558
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 19:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044308; cv=none; b=pUeo4kyY3E0MQLdmJLZ+bFOse+zMM26690Y095VZHZWoetFKHVoWeIcIT6RI3kY5+FWe8cGn5nO3ic/NacE5XpTEqZC2GSNUgmX6g9tWyR+7Kq5WFAMuDXpgOOrSEHi/QFg+xCAgkduwrwm9RbnD+fKAoaUH7KyzfCHRBhE4Yxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044308; c=relaxed/simple;
	bh=eOpTOOtsSiH93bf4Pk+e4HZeJ9yZohnQhzBcJPSS5Y0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a2zNromySKXCu43k4Y596Fyzs0yQEUBjdkuR5z+VwbdeI3HNwYVU70H6QaY8FypIYQw0E4RUR7n4LFbiQA88yVfWlsaCTbUNFEa1td4+DdaRFm/FJbU/Nh2oDONsLmHrAhHioVMPsHMmk+OIy0SJkSp3tzQi0K4hF4GXFWT1Bt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Haj5hPB0; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Haj5hPB0"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso1690333f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 12:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786044299; x=1786649099; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VJntHgxC09/3/XGghh26P3Kedsxi46TFVYMjNf12sL4=;
        b=Haj5hPB0QN1KBBr2UNi+XCxprt9i6fSTx6hbcOwPhgVbCEWyAYk8xrhmJZkWKRiERi
         pW+Z5eJoDBmSe4BWtD/WjUwJ0pkAbF18GW/svpizGMBKFjGy5fgwG6xP8WCg3rPVYVdv
         /NkNNFeDujQSb+jG5GGT0mIlb6hU9Vv+aGapFsc/Jq3zNN1revWAM1vWIWNlvd2o0Mhi
         G0Q9N4BJb/PhPfrth2pLpiCp1LwVoyREGcsl9LFaTXP//xhZAtXIGJlONSe7P+8pRAzu
         +B1kU99LrX0gz3jHHcg9y0O2e8nGzVgRrYvGd11oti/GFlk094RoYejttaMogIXj8sqT
         t+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044299; x=1786649099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VJntHgxC09/3/XGghh26P3Kedsxi46TFVYMjNf12sL4=;
        b=AnVX9hZZYRP7tzJmyFaOkInbdo8FWALSLVfxAg+26pWEKbWtV0X851XyXYlX1haz5p
         I8i1eAwatjQURKfFNPqYKt0SdFXQoWVVcZzulz39yfgOvgYRfIEVlRKsYow2G2V9BtVC
         CnnqJc0zowCJD13XdQAsikp+lh7B3dyVCm464sQrLBZiMLQJRwxRNNSLxMEZOeuUux7X
         hNQx58w2zp/5v2WIHySh+ek+fMNPed52U+gcnJZnUg7UO3fKrJYrxKewFzkFqZJUgEp4
         eA5IlswnMdzVEkicNhqlfy/GK7M5seWi0DP4mgNpP1Y29fd78y4jKjc3JyEGjHyW6aLe
         jZig==
X-Forwarded-Encrypted: i=1; AHgh+RpH2zUM77z0yrZ77mIZGn4HRiKkGi1hbTo5UeTO5JnheUYUmcF7Cof6HNaG0umDZYgykDdmCoc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8SCxVbYUw9caza5UnlQx7dc1L4ka6SMCLNHuP22sdxjHrmIlG
	YnCtwUsLDLthknsi0Wu/wlrc+iztfAALfKFtuz3k2eA4pJA3VAmd3gk9
X-Gm-Gg: AR+sD12ysScLDr820tAPcJq44pRF6A2wiNNZpdSKyqQvkqtsDvZ37VFyN9W1UiZuaZE
	ScnhoxHcTMDGwJFuupGdDK/yGHsxgqKPb6whQQyFy6n9flNQJLtjVWopzL6h215iovroBZ3lipq
	bVgnSjarTqeJMBb8zmLmYrcPGqzHNH7JTB1RPbWqz1cZRHR4PlQCDIPVboM2z/ayI4p78pIDTyu
	wF6JLuw/uqxaGR27xQZZ7UCp+I1A814VixCwTzfQUgxOLGPrRbRCTKLxKAlNzjKitb3V1I/cjD3
	pZ7H9yxdGgWLFo7RRpQhN0TLJZgOJHlFc9EwAkLhK5jM82qXppLjYc045Qm90KDjEgo5q+stncP
	qZ3Bm4Q5vduaSEl32At48boQ8Em7FmSlofc0iC+BXfHiDbt+5om3he4OlHLL8UeSKq2+NOiMIyD
	1ezHc/uDVB8f1O5nIABA+Dp9fJI6Zm9x0Wg6OphH/zSB7Zvx0PjxR58UKRfnr2XNhi2SpCC3mlH
	M0HkZGbvNVg9uWi2lacD7QRApIzmAI11Ki8hLWq0z/eNEdyKrFnXVvSFIISoF+smGX/QjY7u0AF
	7hhjnd3jk2znhKhofCmbjwdgy4uJhQBBGy/qFGHMtCDeozsxysFPW5dmcW8XmvTsHK3RlIovBg=
	=
X-Received: by 2002:adf:f4cf:0:b0:47f:776f:3838 with SMTP id ffacd0b85a97d-47fec5030e5mr23574023f8f.6.1786044298253;
        Thu, 06 Aug 2026 12:24:58 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-adf9-2301-8c14-6be6-a9e6-a2d4.310.pool.telefonica.de. [2a02:3100:adf9:2301:8c14:6be6:a9e6:a2d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff79a718bsm9164173f8f.5.2026.08.06.12.24.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Aug 2026 12:24:57 -0700 (PDT)
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
Subject: [PATCH v3] KVM: arm64: nv: Keep the shadow S2 MMUs at fixed addresses
Date: Thu,  6 Aug 2026 21:24:51 +0200
Message-Id: <20260806192451.10169-1-kmehltretter@gmail.com>
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
 arch/arm64/include/asm/kvm_host.h   |  6 +--
 arch/arm64/include/asm/kvm_nested.h |  2 +-
 arch/arm64/kvm/arm.c                |  7 ++-
 arch/arm64/kvm/nested.c             | 81 ++++++++++++++++-------------
 4 files changed, 54 insertions(+), 42 deletions(-)

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
index 50adfff75be8..e883e45382fb 100644
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
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index dfb96edbdc43..7dedb9f8ee86 100644
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
+	int num_mmus, ret = 0, i;
 
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features) &&
 	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
@@ -91,42 +104,38 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	 */
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
+			break;
 		}
 
-		swap(kvm->arch.nested_mmus, tmp);
-
-		write_unlock(&kvm->mmu_lock);
+		ret = init_nested_s2_mmu(kvm, mmu);
+		if (ret) {
+			kfree(mmu);
+			free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+			vcpu->arch.ctxt.vncr_array = NULL;
+			break;
+		}
 
-		kvfree(tmp);
+		kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i] = mmu;
 	}
 
-	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
-		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
-
 	if (ret) {
-		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
-			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
-
-		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
-		vcpu->arch.ctxt.vncr_array = NULL;
+		while (i--)
+			free_nested_s2_mmu(kvm->arch.nested_mmus[kvm->arch.nested_mmus_size + i]);
 
 		return ret;
 	}
 
-	kvm->arch.nested_mmus_size = num_mmus;
+	guard(write_lock)(&kvm->mmu_lock);
+	kvm->arch.nested_mmus_size += S2_MMU_PER_VCPU;
 
 	return 0;
 }
@@ -725,7 +734,7 @@ void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 	write_lock(&kvm->mmu_lock);
 
 	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!kvm_s2_mmu_valid(mmu))
 			continue;
@@ -767,7 +776,7 @@ struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
 	 *   if S2 translation is disabled.
 	 */
 	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!kvm_s2_mmu_valid(mmu))
 			continue;
@@ -806,7 +815,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	for (i = kvm->arch.nested_mmus_next;
 	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
 	     i++) {
-		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
+		s2_mmu = kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
 
 		if (atomic_read(&s2_mmu->refcnt) == 0)
 			break;
@@ -1223,7 +1232,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 		return;
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
@@ -1242,7 +1251,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		return;
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
@@ -1261,7 +1270,7 @@ void kvm_nested_s2_flush(struct kvm *kvm)
 		return;
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
@@ -1273,10 +1282,10 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
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

