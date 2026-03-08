Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0114816FF37
	for <kvmarm@lists.linux.dev>; Sun,  8 Mar 2026 23:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773011975; cv=none; b=sBAsukJTL5Na3AkuDgcnp9bbdNkxzBgH9RBazyCZXWWhQWL+BBm74Fxo3ZIiW/wV7LWdK8Iu7Nfx3pkTrwN+omL8cdJPSlbGki8bwhbY4R7xCAT+Yo/Ae68Y1q7nnSm/Z6ErFnESeBdbLvD0tMTNCZbhzi3jAeN+4Sv/YntvTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773011975; c=relaxed/simple;
	bh=PKLzSjHdsr85DIWF9Z3dPB8MLO6XnjzBexVFM2uaYO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAhQHduDlFEdeZ17n3tifE4FUEyLyEJB9WVaC4boPYT8nTGmpDZXQyMB9413wz2MIr7bqBn1xaLVCycAKBlortFOgtFn4kIC8USqOxmq6FXQSXtVIpArnuk5bWvOmeuKHRAKVBqyQlmCpHTDK3tDVeEXG4nfFYvs6H2KSiWMBrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43EA71D15;
	Sun,  8 Mar 2026 16:19:27 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8F883F5CA;
	Sun,  8 Mar 2026 16:19:31 -0700 (PDT)
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH RESEND 1/2] KVM: arm64: ptdump: Make KVM ptdump code s2 mmu aware
Date: Sun,  8 Mar 2026 23:18:28 +0000
Message-ID: <20260308231829.864983-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260308231829.864983-1-weilin.chang@arm.com>
References: <20260308231829.864983-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To reuse the ptdump code for shadow page table dumping later, let's pass
s2 mmu as the private data, so we have the freedom to select which page
table to print.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 6cbe018fd6fd..98763b291956 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -18,7 +18,7 @@
 #define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
 
 struct kvm_ptdump_guest_state {
-	struct kvm		*kvm;
+	struct kvm_s2_mmu	*mmu;
 	struct ptdump_pg_state	parser_state;
 	struct addr_marker	ipa_marker[MARKERS_LEN];
 	struct ptdump_pg_level	level[KVM_PGTABLE_MAX_LEVELS];
@@ -112,10 +112,9 @@ static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
 	return 0;
 }
 
-static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
+static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu *mmu)
 {
 	struct kvm_ptdump_guest_state *st;
-	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 	struct kvm_pgtable *pgtable = mmu->pgt;
 	int ret;
 
@@ -133,7 +132,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
 	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
 	st->range[0].end		= BIT(pgtable->ia_bits);
 
-	st->kvm				= kvm;
+	st->mmu				= mmu;
 	st->parser_state = (struct ptdump_pg_state) {
 		.marker		= &st->ipa_marker[0],
 		.level		= -1,
@@ -149,8 +148,8 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 {
 	int ret;
 	struct kvm_ptdump_guest_state *st = m->private;
-	struct kvm *kvm = st->kvm;
-	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct kvm_s2_mmu *mmu = st->mmu;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct ptdump_pg_state *parser_state = &st->parser_state;
 	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
 		.cb	= kvm_ptdump_visitor,
@@ -169,14 +168,15 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 
 static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
 {
-	struct kvm *kvm = m->i_private;
+	struct kvm_s2_mmu *mmu = m->i_private;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_ptdump_guest_state *st;
 	int ret;
 
 	if (!kvm_get_kvm_safe(kvm))
 		return -ENOENT;
 
-	st = kvm_ptdump_parser_create(kvm);
+	st = kvm_ptdump_parser_create(mmu);
 	if (IS_ERR(st)) {
 		ret = PTR_ERR(st);
 		goto err_with_kvm_ref;
@@ -194,7 +194,7 @@ static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
 
 static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
 {
-	struct kvm *kvm = m->i_private;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(m->i_private);
 	void *st = ((struct seq_file *)file->private_data)->private;
 
 	kfree(st);
@@ -229,14 +229,15 @@ static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
 static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
 				    int (*show)(struct seq_file *, void *))
 {
-	struct kvm *kvm = m->i_private;
+	struct kvm_s2_mmu *mmu = m->i_private;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgtable;
 	int ret;
 
 	if (!kvm_get_kvm_safe(kvm))
 		return -ENOENT;
 
-	pgtable = kvm->arch.mmu.pgt;
+	pgtable = mmu->pgt;
 
 	ret = single_open(file, show, pgtable);
 	if (ret < 0)
@@ -256,7 +257,7 @@ static int kvm_pgtable_levels_open(struct inode *m, struct file *file)
 
 static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
 {
-	struct kvm *kvm = m->i_private;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(m->i_private);
 
 	kvm_put_kvm(kvm);
 	return single_release(m, file);
@@ -279,9 +280,9 @@ static const struct file_operations kvm_pgtable_levels_fops = {
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
 {
 	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
-			    kvm, &kvm_ptdump_guest_fops);
-	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry, kvm,
-			    &kvm_pgtable_range_fops);
+			    &kvm->arch.mmu, &kvm_ptdump_guest_fops);
+	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry,
+			    &kvm->arch.mmu, &kvm_pgtable_range_fops);
 	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
-			    kvm, &kvm_pgtable_levels_fops);
+			    &kvm->arch.mmu, &kvm_pgtable_levels_fops);
 }
-- 
2.43.0

