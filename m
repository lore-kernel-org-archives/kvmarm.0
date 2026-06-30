Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E7840BCD2
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782821497; cv=none; b=Z/feUcWSmZQgp5E65QUrj5Itd/EMN50t0tKAcp7XT5dy0a2eUYbgMsYmmUt0ylWOhHAZVckpzqHL4EVaMsYLp8MHKgS679XvddXnYsaqzU8LFJxzSQaOdJfHq+W6oH3CtOtgjBp1nIgqlksvDfzoTXEOCG4aNjlpUoxdj025vL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782821497; c=relaxed/simple;
	bh=lZjlT2hQqWxjuyaq3q3UVTuOgQS+V7y1M7gpu3du8Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCiR34bOv0E88EcDxfEIN9utXjvMf8d93fUWZ88OdS/fKuDp7uijD+Zk7SssTxnMktgsSL5id/Xrx8+Wve8OTTr+svO9fEQ/7QgUAx8KT6Pv+1CPF5PIQlZIAPbBTqp3DFrLQEmcaZW+0vWPDIW4Rg31e/QjKZyQaHYmLA3ngTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vy4gaUjx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vy4gaUjx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B88A32EC5;
	Tue, 30 Jun 2026 05:11:30 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B6D73F905;
	Tue, 30 Jun 2026 05:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782821495; bh=lZjlT2hQqWxjuyaq3q3UVTuOgQS+V7y1M7gpu3du8Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vy4gaUjxvI+U4U4KHKah3r2HlFsnoYmt2JXS69dmlHR+OCx5BlZdwBvnL/S8NxwRe
	 cStpQJ6hP3mOR2KjDKIpjDpNQPj/ZCbmRIiSSG71VtRMtLgP3BeySNEU92N+RHP+Jy
	 rLvox2SDUwGNiTiRIxN5gLgCse4BM8RrhBXJXpdE=
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
Subject: [PATCH v2 5/6] KVM: arm64: ptdump: Extract kvm_ptdump_guest_open() from canonical ptdump path
Date: Tue, 30 Jun 2026 13:10:04 +0100
Message-ID: <20260630121005.1130996-6-weilin.chang@arm.com>
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

Factor out kvm_ptdump_guest_open() so that the shadow ptdump can reuse
kvm_ptdump_guest_open().

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/ptdump.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 0c9647666e65..40f93b7c7ad9 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -156,7 +156,7 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
 	return st;
 }
 
-static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
+static int kvm_ptdump_guest_canonical_show(struct seq_file *m, void *unused)
 {
 	struct kvm_ptdump_guest_state *st = m->private;
 	struct kvm *kvm = st->kvm;
@@ -181,7 +181,8 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 	return 0;
 }
 
-static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
+static int kvm_ptdump_guest_open(struct inode *m, struct file *file,
+				 int (*show)(struct seq_file *, void *))
 {
 	struct kvm *kvm = m->i_private;
 	struct kvm_ptdump_guest_state *st;
@@ -196,7 +197,7 @@ static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
 		goto err_with_kvm_ref;
 	}
 
-	ret = single_open(file, kvm_ptdump_guest_show, st);
+	ret = single_open(file, show, st);
 	if (!ret)
 		return 0;
 
@@ -206,6 +207,11 @@ static int kvm_ptdump_guest_open(struct inode *m, struct file *file)
 	return ret;
 }
 
+static int kvm_ptdump_guest_canonical_open(struct inode *m, struct file *file)
+{
+	return kvm_ptdump_guest_open(m, file, kvm_ptdump_guest_canonical_show);
+}
+
 static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
 {
 	struct kvm *kvm = m->i_private;
@@ -217,8 +223,8 @@ static int kvm_ptdump_guest_close(struct inode *m, struct file *file)
 	return single_release(m, file);
 }
 
-static const struct file_operations kvm_ptdump_guest_fops = {
-	.open		= kvm_ptdump_guest_open,
+static const struct file_operations kvm_ptdump_guest_canonical_fops = {
+	.open		= kvm_ptdump_guest_canonical_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= kvm_ptdump_guest_close,
@@ -296,7 +302,7 @@ static const struct file_operations kvm_pgtable_levels_fops = {
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
 {
 	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
-			    kvm, &kvm_ptdump_guest_fops);
+			    kvm, &kvm_ptdump_guest_canonical_fops);
 	debugfs_create_file("ipa_range", 0400, kvm->debugfs_dentry,
 			    kvm, &kvm_pgtable_range_fops);
 	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
-- 
2.43.0

