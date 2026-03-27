Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D2D390C90;
	Fri, 27 Mar 2026 11:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611389; cv=none; b=k9Ewi6XUSUSOktir2rV7wKsWol9CMEKRLW+B/A/YokNNXG8mV5VedkpoIxA9soKyJanjzn6JXBzeLw/X6A5uL8+YHFtCrDxfMf+C9GRZ4x4/dcZBw3fgAEXwQhNs/HrQ2PhLKRK0BsDtZnWyh8n5fnMI8b5Q2JrYm3TZJCbThRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611389; c=relaxed/simple;
	bh=PstDFGkZeF8dkGmxvk4oRyMbmEixCqCmAuiHv71POEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzXUpw0kskXojb9Jx/TrNKSOCgZq4b4Fvm/0K+OxAqcOhrLlmZaSqYGtt280OFWm6FFbhAnImerWvt05Pldo41UEcfEyWFagDf6MpPUEoqCtlTUPGGIltTVQg0LNBLs719RUAegh5uUMgjQkJK1i6yjoMsTTX/WJKD+ZHNKEfj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nz8gvLHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nz8gvLHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8415AC2BCB4;
	Fri, 27 Mar 2026 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611389;
	bh=PstDFGkZeF8dkGmxvk4oRyMbmEixCqCmAuiHv71POEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nz8gvLHJjkcN8sZMYYNLfzvJ3Dh0Q0FlIdtGE4FiVIgV+AXY60drNJ7+WmQXGz41o
	 PRE0G27HZX75sYQ1/QhqBrVXipwLnX6fe7vuVUSOIr4An7IJgsqwwGUA8VrJR4ZG8G
	 jN+iIPAsPAfV7FSs502YaixMdhKYE63t38ytQf58TjJx1HnoPvlDtnJjCdlfjUw6gn
	 bQd8z6U8YV3kwXLH0GciOmIzIsTlnOkk2ECZx1KgXE5z5qV1TH7N6SaYw7BUK1HSaJ
	 rwA2znbcrS52PnkFknPxQNlrwIuwrYRJ7NlI4+3hz5Bk1omiMpSTo89+z5g6Uy0FLL
	 ttmxHdFcv6Lxg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UJ-00000006K4a-2vb9;
	Fri, 27 Mar 2026 11:36:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 23/30] KVM: arm64: Kill logging_active from kvm_s2_fault
Date: Fri, 27 Mar 2026 11:36:11 +0000
Message-ID: <20260327113618.4051534-24-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

There are only two spots where we evaluate whether logging is
active. Replace the boolean with calls to the relevant helper.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5b2862e2bfcf3..26313e0b40c25 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1723,7 +1723,6 @@ struct kvm_s2_fault {
 	bool writable;
 	bool s2_force_noncacheable;
 	kvm_pfn_t pfn;
-	bool logging_active;
 	bool force_pte;
 	enum kvm_pgtable_prot prot;
 	struct page *page;
@@ -1853,7 +1852,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 			 */
 			fault->s2_force_noncacheable = true;
 		}
-	} else if (fault->logging_active && !kvm_is_write_fault(s2fd->vcpu)) {
+	} else if (memslot_is_logging(s2fd->memslot) && !kvm_is_write_fault(s2fd->vcpu)) {
 		/*
 		 * Only actually map the page as writable if this was a write
 		 * fault.
@@ -1989,11 +1988,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
-	bool logging_active = memslot_is_logging(s2fd->memslot);
 	struct kvm_s2_fault_vma_info s2vi = {};
 	struct kvm_s2_fault fault = {
-		.logging_active = logging_active,
-		.force_pte = logging_active,
+		.force_pte = memslot_is_logging(s2fd->memslot),
 		.prot = KVM_PGTABLE_PROT_R,
 	};
 	void *memcache = NULL;
@@ -2005,7 +2002,8 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	if (!perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu))) {
+	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
+			    kvm_is_write_fault(s2fd->vcpu))) {
 		ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
 		if (ret)
 			return ret;
-- 
2.47.3

