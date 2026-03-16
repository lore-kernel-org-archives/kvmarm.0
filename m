Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE033B6F8
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683702; cv=none; b=lZQ6K5EUVd+hUVPJrPqLhqFRX4+cXuDF32u2zv3PvLU2CGo/Wvh6YPG3afQHWWaxDFd29a0oOPJkRlW5QfsO7WB5a6Vu38aYpV/lksiEMuiFFGMmMlIcEBnksRSxRzSPt+P7O4250FBeeqnYSX/IF2iUGrpd2QB+ZNY6xurec0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683702; c=relaxed/simple;
	bh=pSz7KSEk3cZzgsv0JwIgztuHbAHwcbSKxhrdJqB5X70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUSvxM3E9AKjdQGPHxhVYDr/QtVkK8lNIeUBCifQ3LhZiBYZ/dpvf539j2+1vVWJq1jqIKhUVwY2rcPm/MBIzXWbuNxWQy2y3Bt0OzCAB1Ga+EIMXkIo5oxuITeWpCi8INhFxwcBW6GOTacbUr8Jn4pXS6DapaE1+yOJWt33cSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uF/fX79x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uF/fX79x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF61C19421;
	Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683702;
	bh=pSz7KSEk3cZzgsv0JwIgztuHbAHwcbSKxhrdJqB5X70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uF/fX79xcRAegiUt8xa9auKVQE5slpbESkSVo6Mwptn3YalTNhrjaqnWRHKDVTxB8
	 qn9V+emv76/lGBPr/yWrgS5r1wfOc+2gXwa1D/caAQhH7lL34pU3OvUpueUfuRbRq8
	 63dluAVdF1Zmx9lAsQiKAlu8vvoFFGzqaWdkDbhKauROUB5YrL74RXT+BKAS1jAZ6C
	 /jfYaIg58V4Z8PnOiVPru2ywctzOx+w9svEoqgdeYWpTs0Kfou28nqpZEi1WVood+E
	 q85A01VkOMcGBHDXAnf3OyykySUq7j4RaK0B3MLhsuP350W/HHxrcf20bSBw5XZq5I
	 uvZzPIsGI7oYw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9c-00000002XDx-2iOS;
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
Subject: [PATCH 06/17] KVM: arm64: Kill write_fault from kvm_s2_fault
Date: Mon, 16 Mar 2026 17:54:39 +0000
Message-ID: <20260316175451.1866175-7-maz@kernel.org>
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

We already have kvm_is_write_fault() as a predicate indicating
a S2 fault on a write, and we're better off just using that instead
of duplicating the state.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 12c2f0aeaae4c..86950acbd7e6b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1711,7 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 }
 
 struct kvm_s2_fault {
-	bool write_fault;
 	bool exec_fault;
 	bool writable;
 	bool topup_memcache;
@@ -1799,7 +1798,7 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 		return ret;
 
 	fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, fault),
-				       fault->write_fault ? FOLL_WRITE : 0,
+				       kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
 	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
 		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
@@ -1850,7 +1849,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 			 */
 			fault->s2_force_noncacheable = true;
 		}
-	} else if (fault->logging_active && !fault->write_fault) {
+	} else if (fault->logging_active && !kvm_is_write_fault(s2fd->vcpu)) {
 		/*
 		 * Only actually map the page as writable if this was a write
 		 * fault.
@@ -1980,21 +1979,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
-	bool write_fault = kvm_is_write_fault(s2fd->vcpu);
 	bool logging_active = memslot_is_logging(s2fd->memslot);
 	struct kvm_s2_fault fault = {
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-		.write_fault = write_fault,
 		.exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
-		.topup_memcache = !perm_fault || (logging_active && write_fault),
+		.topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
 	};
 	void *memcache;
 	int ret;
 
-	VM_WARN_ON_ONCE(fault.write_fault && fault.exec_fault);
-
 	/*
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
-- 
2.47.3

