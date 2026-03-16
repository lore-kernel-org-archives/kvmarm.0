Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C143195EA
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683703; cv=none; b=RIJ2ZqhemDCOQB/7JLTL+KRh52sVvlMECVsZKXDsSJdSvgOJnG/iU8pWVVwkbH2G8tHqmzE7ga2qx3Bh6AwmQ1kDy+3+9Erq3jp0tQXI3G3QEr7MXqeAvgFDTISavHzTcOtbN6oCoipr/VaGPszjv0gzNJGgXMEqDl67fd4UHGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683703; c=relaxed/simple;
	bh=S9BG/7xPpOu8U0aAfaIVPmi8MtVwmOxDoQeqtQS+iaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgcBJ/5ReMI+a4IvvyAdhoS8/zLlWFLm3ME2z1rzFcLEIDKUJxBTwlKYPG77nv8bsIVLANXS1feKK4gGyM0FBHn8Zc0ZgCTn1W9cp3+VirtEPkNZfbeU1rAYFCQa09QzN+036H9H4bgniFFMjYhilc02M7UVq1gB42DsQPDJis0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HBr8Aaoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HBr8Aaoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867AAC19421;
	Mon, 16 Mar 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683703;
	bh=S9BG/7xPpOu8U0aAfaIVPmi8MtVwmOxDoQeqtQS+iaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBr8Aaoz6+AqRiwPED51/+M9L1DbPyG3AnjZyAltrJnflYWzluLmYHQqMg9UtNgRO
	 WY7G5xF4rGiPwoqxCggNGQ9/DQXhHMUUtqfKQZ4YUVjIfaSAXOeWFA0EHW//JRzSaR
	 VICPrE3Ogb/6EegNXfDG91RIHe/nm4rHDp1NT8cRzFOMiGucaQU0HqkFivNWAicfYo
	 IfM1aPV7NwaYA8uGbAoIL7cXYFv+AmFPSYdVg+Pg7zH3an7l8FpdQ4Zu1GLyP7Gyae
	 TT8+wVRgIHZVmNAZ3xeeQfhL/K1Y8stkOkpwhHLegHXmtMwszxSc8UTl5sSISSOWSm
	 j6r4MAn51C8Ww==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9d-00000002XDx-2PAC;
	Mon, 16 Mar 2026 17:55:01 +0000
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
Subject: [PATCH 10/17] KVM: arm64: Kill logging_active from kvm_s2_fault
Date: Mon, 16 Mar 2026 17:54:43 +0000
Message-ID: <20260316175451.1866175-11-maz@kernel.org>
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

There are only two spots where we evaluate whether logging is
active. Replace the boolean with calls to the relevant helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a5b0dd41560f6..caa5bedc79e19 100644
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
@@ -1985,11 +1984,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
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
 	void *memcache;
@@ -2001,7 +1998,8 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
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

