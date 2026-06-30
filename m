Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5771540B389
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 12:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782821489; cv=none; b=YqmphcnXRUT5suW7jOMwPQO2LhcRS9SBZctTGgGmawsYGj0zelOY1B/HVKLQUe+QzEiP9HVBnhNLzDMMwIXgiVBttZsaLNUvSbZbHOiWcWaNKuSd5QIZvGjBivLjXU66vucb59vyTG9IPt+0afE+89GWSTdWBu1i5pGpMFhDBhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782821489; c=relaxed/simple;
	bh=1n3qO4tevriGd8jkJz2HrHo3ryYalBTuCbFEYqo0xRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfCObSH2FG01mPKKlD7OAUUd2C3KUYbnO3pszmih0OGKskJcEoE6r5voy/57HCUXumz0BGcBT0Q47N4aCH22/HKpUiEARCSK4QS1WHy1xpw75rkfVaEc/WCmTNbZaPRXp8jnJ4j2gUorcVEcmVcV7xZOh+mZ+9jkJZX9yR2DlOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KmqaPz0I; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KmqaPz0I"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D3C62EC5;
	Tue, 30 Jun 2026 05:11:23 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A49383F905;
	Tue, 30 Jun 2026 05:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782821487; bh=1n3qO4tevriGd8jkJz2HrHo3ryYalBTuCbFEYqo0xRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmqaPz0IcdrkYoO7v6PppquU5yL1vJhZEtjmmAPv5k1di8nLjevBDBZiK/Y1RP/SF
	 UfHqDMRFATbBIXdImZmXVKnwquc552Uh1d2QGmMuJE2sIjMNs/WG3KctmWQor9WYPF
	 FKqthm+5zjl3GBM/bL3Ye/RIcuNh6W5auKdptX18=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 2/6] KVM: arm64: ptdump: Undo making the ptdump code mmu aware
Date: Tue, 30 Jun 2026 13:10:01 +0100
Message-ID: <20260630121005.1130996-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630121005.1130996-1-weilin.chang@arm.com>
References: <20260630121005.1130996-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 204f7c018d76 ("KVM: arm64: ptdump: Make KVM ptdump code s2 mmu
aware") changed the ptdump code from storing the kvm pointer to storing
the mmu pointer, in order to reuse code for shadow ptdumps.

This turned out to be buggy as the nested mmus can be freed before the
last access to the ptdump files. To prepare for a new implementation of
the shadow ptdumps which solves this problem, revert the effects of the
commit to avoid this UAF.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 7c32f1f7772c..d5aa9eff08d1 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -19,7 +19,7 @@
 #define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
 
 struct kvm_ptdump_guest_state {
-	struct kvm_s2_mmu	*mmu;
+	struct kvm		*kvm;
 	struct ptdump_pg_state	parser_state;
 	struct addr_marker	ipa_marker[MARKERS_LEN];
 	struct ptdump_pg_level	level[KVM_PGTABLE_MAX_LEVELS];
@@ -112,10 +112,10 @@ static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
 	return 0;
 }
 
-static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu *mmu)
+static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
 {
 	struct kvm_ptdump_guest_state *st;
-	struct kvm_pgtable *pgtable = mmu->pgt;
+	struct kvm_pgtable *pgtable = kvm->arch.mmu.pgt;
 	int ret;
 
 	st = kzalloc_obj(struct kvm_ptdump_guest_state, GFP_KERNEL_ACCOUNT);
@@ -131,7 +131,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu
 	st->ipa_marker[0].name		= "Guest IPA";
 	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
 
-	st->mmu				= mmu;
+	st->kvm				= kvm;
 	return st;
 }
 
@@ -139,8 +139,8 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 {
 	int ret;
 	struct kvm_ptdump_guest_state *st = m->private;
-	struct kvm_s2_mmu *mmu = st->mmu;
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	struct kvm *kvm = st->kvm;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
 		.cb	= kvm_ptdump_visitor,
 		.arg	= &st->parser_state,
@@ -163,15 +163,14 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 
 static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
 {
-	struct kvm_s2_mmu *mmu = m->i_private;
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	struct kvm *kvm = m->i_private;
 	struct kvm_ptdump_guest_state *st;
 	int ret;
 
 	if (!kvm_get_kvm_safe(kvm))
 		return -ENOENT;
 
-	st = kvm_ptdump_parser_create(mmu);
+	st = kvm_ptdump_parser_create(kvm);
 	if (IS_ERR(st)) {
 		ret = PTR_ERR(st);
 		goto err_with_kvm_ref;
@@ -189,7 +188,7 @@ static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
 
 static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
 {
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(m->i_private);
+	struct kvm *kvm = m->i_private;
 	void *st = ((struct seq_file *)file->private_data)->private;
 
 	kfree(st);
@@ -224,15 +223,14 @@ static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
 static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
 				    int (*show)(struct seq_file *, void *))
 {
-	struct kvm_s2_mmu *mmu = m->i_private;
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	struct kvm *kvm = m->i_private;
 	struct kvm_pgtable *pgtable;
 	int ret;
 
 	if (!kvm_get_kvm_safe(kvm))
 		return -ENOENT;
 
-	pgtable = mmu->pgt;
+	pgtable = kvm->arch.mmu.pgt;
 
 	ret = single_open(file, show, pgtable);
 	if (ret < 0)
@@ -252,7 +250,7 @@ static int kvm_pgtable_levels_open(struct inode *m, struct file *file)
 
 static int kvm_pgtable_debugfs_close(struct inode *m, struct file *file)
 {
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(m->i_private);
+	struct kvm *kvm = m->i_private;
 
 	kvm_put_kvm(kvm);
 	return single_release(m, file);
@@ -275,11 +273,11 @@ static const struct file_operations kvm_pgtable_levels_fops = {
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
 {
 	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
-			    &kvm->arch.mmu, &kvm_ptdump_guest_fops);
+			    kvm, &kvm_ptdump_guest_fops);
 	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry,
-			    &kvm->arch.mmu, &kvm_pgtable_range_fops);
+			    kvm, &kvm_pgtable_range_fops);
 	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
-			    &kvm->arch.mmu, &kvm_pgtable_levels_fops);
+			    kvm, &kvm_pgtable_levels_fops);
 	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		kvm->arch.debugfs_nv_dentry = debugfs_create_dir("nested", kvm->debugfs_dentry);
 }
-- 
2.43.0

