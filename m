Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6AA33509A
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683702; cv=none; b=oQpgk9OyHpMffw4rqEQqxSM6vqVyKP8pnQQnhthof9lB+3jo0sBUZXzrVEjQtafnQE1KOqJ03LotbK5e8T/oDo4B7Z3Gm4LHIVQH+bTB0GzH9osJiTEXyo9NWh8uDCZi4zfFdcjoIBrftw/l/EJ+WDzWKusKk+vfu2DMZwyKcSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683702; c=relaxed/simple;
	bh=yN0Izyr1+3kVClshnIB+MMJVxrA5vG03ZI8xqRa29pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txoymMNMnaSegUINDHnQ0+g93eNsbDAhTZVWs/uVLST6p4K7KnHFxLIk0ogPOjvGNe4ZKNy1Aga27bNclyC4PM94CenhzH4bX5xlewKDfBuoA6ykSuYOgImZUdipqvNAEkBXfDhqeAmwUJyylWHXPyeNeP2wcZv1UXy/qUauhDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfPjRJl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfPjRJl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363F5C2BCB0;
	Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683702;
	bh=yN0Izyr1+3kVClshnIB+MMJVxrA5vG03ZI8xqRa29pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfPjRJl2ryGV/twk4yGl2phGLElTDQE69MOCRHAX55FEDrRw9phU/ZQuvxvj9B9Ey
	 Pb7HF2m4NAHJJVab3Cu2hNnRWvnk4DcjVaGpHYdT0cfA5mVwgzF4M661M7u0A8sVN4
	 329y7X6c5LMK34LMSk4dT7T2FpZD+umWA0nmtDwoICDNWWVIY/5ddt4KyqU8M1BtTt
	 FLc6sfL4erRtSSeqsGEi6hr+pOJ6Mv+2OsYIcVJgS8GwmtiyP9m5jf7WpyjQ4FtO42
	 CdpYhRWW/qciQnP6VfvnuGT/rFSIupSzuxF/gc2mwgdldJoCp6kgzvst53VopsDgVZ
	 6JmYMTYjujDdw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9b-00000002XDx-49tc;
	Mon, 16 Mar 2026 17:55:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 04/17] KVM: arm64: Replace fault_is_perm with a helper
Date: Mon, 16 Mar 2026 17:54:37 +0000
Message-ID: <20260316175451.1866175-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316175451.1866175-1-maz@kernel.org>
References: <20260316175451.1866175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Carrying a boolean to indicate that a given fault is slightly odd,
as this is a property of the fault itself, and we'd better avoid
duplicating state.

For this purpose, introduce a kvm_s2_fault_is_perm() predicate that
can take a fault descriptor as a parameter. fault_is_perm is therefore
dropped from kvm_s2_fault.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2a7128b8dd14f..1b32f2e6c3e61 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1711,8 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 }
 
 struct kvm_s2_fault {
-	bool fault_is_perm;
-
 	bool write_fault;
 	bool exec_fault;
 	bool writable;
@@ -1732,6 +1730,11 @@ struct kvm_s2_fault {
 	vm_flags_t vm_flags;
 };
 
+static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
+{
+	return kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
+}
+
 static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 				     struct kvm_s2_fault *fault)
 {
@@ -1888,7 +1891,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	if (s2fd->nested)
 		adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
 
-	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
+	if (!kvm_s2_fault_is_perm(s2fd) && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (!fault->mte_allowed)
 			return -EFAULT;
@@ -1905,6 +1908,7 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
 static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			    struct kvm_s2_fault *fault, void *memcache)
 {
+	bool fault_is_perm = kvm_s2_fault_is_perm(s2fd);
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	struct kvm_pgtable *pgt;
 	int ret;
@@ -1922,7 +1926,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 */
 	if (fault->vma_pagesize == PAGE_SIZE &&
 	    !(fault->force_pte || fault->s2_force_noncacheable)) {
-		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
+		if (fault_is_perm && fault->fault_granule > PAGE_SIZE) {
 			fault->vma_pagesize = fault->fault_granule;
 		} else {
 			fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
@@ -1936,7 +1940,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		}
 	}
 
-	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
+	if (!fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
 		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
 
 	/*
@@ -1944,7 +1948,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault->fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
+	if (fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
@@ -1977,7 +1981,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	bool write_fault = kvm_is_write_fault(s2fd->vcpu);
 	bool logging_active = memslot_is_logging(s2fd->memslot);
 	struct kvm_s2_fault fault = {
-		.fault_is_perm = perm_fault,
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-- 
2.47.3

