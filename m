Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB1933A9DD
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683704; cv=none; b=UMogV2EYfyMFmJa9fUFaCB9+fOYF+mfalMaFAKtj5BQWgnnYRfROyQcs++sr8+6f2iqlsX2Z6Wjqeh50vpXuDjPaGB5z7LlMf5Nod8bNXFJFMliTZ1h52HKpGcBNLH+DcZedeAQ1H5ah7PMbOTO8llDBbTYgRjjsKkOw4dD1TLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683704; c=relaxed/simple;
	bh=dFbpfv1p35YcB4zPuAbay7B6ANDvgyG8ziGP1KFMJIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4lmiIWkSRHnPpD6fQ1z/HCaBfp0a6zYTbPcVO3aC2PPX8LNQ/6SCn8Wd1Evo42GHfQ9EeCBAmDJ9cI8qZKu7RpK0L7fUU4SiR7bkA65oYMnWSKNer8oUyxKf4FE5ZRw0lO+NOdZ6UdyvvgqeZ/Hue5Aov2183HkR8aPiQXi5Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1JLSPb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1JLSPb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD7EC2BCB5;
	Mon, 16 Mar 2026 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683704;
	bh=dFbpfv1p35YcB4zPuAbay7B6ANDvgyG8ziGP1KFMJIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1JLSPb6AJQ7aOBPLY5+KShzFS52pCEBYMOsK/waYHBXmFbnmVHmVdisjKXCEOGzm
	 aw9BWiPB0tr9fKAewYLcnal+v7bzjNHrwMQdhjOyH+J3u2VXww7DmiuHaWy/xGIpYo
	 sbtlWQRTUXPSeBNwi29La6j/iT5rHn5/6X/FRP3GVBvyvPi8F9uhxQJ2ozXv0QnH6y
	 5Jr03/AdXViILVWidL5D2J9Ix0pi3ts6HI2BV/F6eIvDTAKhPO+ndQYl3JOHR51ipL
	 xgd7Vjfgaze2Lca2/oDq6+1tw/TC0I2dX4MdFZvJkGCs5Z8BjoJKTMGzRI89MXWPjP
	 kksESnfRYJKAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9e-00000002XDx-3tUl;
	Mon, 16 Mar 2026 17:55:03 +0000
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
Subject: [PATCH 16/17] KVM: arm64: Simplify integration of adjust_nested_*_perms()
Date: Mon, 16 Mar 2026 17:54:49 +0000
Message-ID: <20260316175451.1866175-17-maz@kernel.org>
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

Instead of passing pointers to adjust_nested_*_perms(), allow
them to return a new set of permissions.

With some careful moving around so that the canonical permissions
are computed before the nested ones are applied, we end-up with
a bit less code, and something a bit more readable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 62 +++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9b5df70807875..18cf7e6ba786d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1544,32 +1544,34 @@ static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
  * TLB invalidation from the guest and used to limit the invalidation scope if a
  * TTL hint or a range isn't provided.
  */
-static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
-				      enum kvm_pgtable_prot *prot,
-				      bool *writable)
+static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
+						       enum kvm_pgtable_prot prot)
 {
-	*writable &= kvm_s2_trans_writable(nested);
+	if (!kvm_s2_trans_writable(nested))
+		prot &= ~KVM_PGTABLE_PROT_W;
 	if (!kvm_s2_trans_readable(nested))
-		*prot &= ~KVM_PGTABLE_PROT_R;
+		prot &= ~KVM_PGTABLE_PROT_R;
 
-	*prot |= kvm_encode_nested_level(nested);
+	return prot | kvm_encode_nested_level(nested);
 }
 
-static void adjust_nested_exec_perms(struct kvm *kvm,
-				     struct kvm_s2_trans *nested,
-				     enum kvm_pgtable_prot *prot)
+static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
+						      struct kvm_s2_trans *nested,
+						      enum kvm_pgtable_prot prot)
 {
 	if (!kvm_s2_trans_exec_el0(kvm, nested))
-		*prot &= ~KVM_PGTABLE_PROT_UX;
+		prot &= ~KVM_PGTABLE_PROT_UX;
 	if (!kvm_s2_trans_exec_el1(kvm, nested))
-		*prot &= ~KVM_PGTABLE_PROT_PX;
+		prot &= ~KVM_PGTABLE_PROT_PX;
+
+	return prot;
 }
 
 static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		      struct kvm_s2_trans *nested,
 		      struct kvm_memory_slot *memslot, bool is_perm)
 {
-	bool write_fault, exec_fault, writable;
+	bool write_fault, exec_fault;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
@@ -1606,19 +1608,17 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return ret;
 	}
 
-	writable = !(memslot->flags & KVM_MEM_READONLY);
+	if (!(memslot->flags & KVM_MEM_READONLY))
+		prot |= KVM_PGTABLE_PROT_W;
 
 	if (nested)
-		adjust_nested_fault_perms(nested, &prot, &writable);
-
-	if (writable)
-		prot |= KVM_PGTABLE_PROT_W;
+		prot = adjust_nested_fault_perms(nested, prot);
 
 	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (nested)
-		adjust_nested_exec_perms(kvm, nested, &prot);
+		prot = adjust_nested_exec_perms(kvm, nested, prot);
 
 	kvm_fault_lock(kvm);
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
@@ -1631,10 +1631,10 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 memcache, flags);
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
 
-	if (writable && !ret)
+	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 	return ret != -EAGAIN ? ret : 0;
@@ -1856,16 +1856,6 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 				     enum kvm_pgtable_prot *prot)
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
-	bool writable = s2vi->map_writable;
-
-	if (!s2vi->device && memslot_is_logging(s2fd->memslot) &&
-	    !kvm_is_write_fault(s2fd->vcpu)) {
-		/*
-		 * Only actually map the page as writable if this was a write
-		 * fault.
-		 */
-		writable = false;
-	}
 
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && s2vi->map_non_cacheable)
 		return -ENOEXEC;
@@ -1883,12 +1873,14 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 
 	*prot = KVM_PGTABLE_PROT_R;
 
-	if (s2fd->nested)
-		adjust_nested_fault_perms(s2fd->nested, prot, &writable);
-
-	if (writable)
+	if (s2vi->map_writable && (s2vi->device ||
+				   !memslot_is_logging(s2fd->memslot) ||
+				   kvm_is_write_fault(s2fd->vcpu)))
 		*prot |= KVM_PGTABLE_PROT_W;
 
+	if (s2fd->nested)
+		*prot = adjust_nested_fault_perms(s2fd->nested, *prot);
+
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
 		*prot |= KVM_PGTABLE_PROT_X;
 
@@ -1899,7 +1891,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		*prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2fd->nested)
-		adjust_nested_exec_perms(kvm, s2fd->nested, prot);
+		*prot = adjust_nested_exec_perms(kvm, s2fd->nested, *prot);
 
 	if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-- 
2.47.3

