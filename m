Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3409F373BE7;
	Fri, 27 Mar 2026 11:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611385; cv=none; b=W2u17z3NJr3iYscT9HVrUwj7dHYzAFxiyyptg1+iu+zwah7U7pqjpTCnplSrpwtjSnBY1ql3QfjNFNF9ECjWVjuXZXRCVZvGcwm9Lac58cC13laswrMRohe3VfAM2ZOamkZg7XgtUM9NALwDgB5zeWKqk9NFHEc3szE5zZnB2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611385; c=relaxed/simple;
	bh=+aeHJ2YQDszoCJhPqw9IaJhiayWdRWxmEzD5vTRGnzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHuYJuBNvuP/Y122DPhysZb1d86VmmTlpClsByBGfcqfpxU8j0nS4qh9HZz29rIA+Q2DG6f0D49zKngZcsUIyfCi/LF+lKk6bwi+PlW2awdSgGXdfEfOEDWPmbetjdG9CWV4DA7CX7CY6xhHw8ky9WFMZ/OIwpC8fuLV3NJ4xX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpaH/UEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpaH/UEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC6CC2BC9E;
	Fri, 27 Mar 2026 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611385;
	bh=+aeHJ2YQDszoCJhPqw9IaJhiayWdRWxmEzD5vTRGnzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpaH/UExhWTVaIzuXHpFmdbZNEubYp9O53Z0bdOpN3MaTd/IkdUPN3ACAxbmNW/B0
	 16Oz9OC9+qB6p3kZtNM+AgIO+NxPansej8iyDbfUCgAU4JkrDb2ingJrGtMV31H1II
	 /GZTPHtjRcNMmW/6z5puvfJGjcR7HqAx+mECpcLo4ntlKs6+He7yPRbDZq+p9turOA
	 YVcArahFhb0w8RIPigLp2q2GDxIp3Ks7RdAs9IuSxrshOw0/9Oo5zx6WmIg/2LsAnu
	 x5PVHQf4c9kHubThgQW0WV29G4aLLgPfRsc/+m7YcVanup/jw3zyKeISjaDw89x5cP
	 wrB47P1u278GA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UF-00000006K4a-0DrT;
	Fri, 27 Mar 2026 11:36:23 +0000
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
Subject: [PATCH v2 04/30] KVM: arm64: Isolate mmap_read_lock inside new kvm_s2_fault_get_vma_info() helper
Date: Fri, 27 Mar 2026 11:35:52 +0000
Message-ID: <20260327113618.4051534-5-maz@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Extract the VMA lookup and metadata snapshotting logic from
kvm_s2_fault_pin_pfn() into a tightly-scoped sub-helper.

This refactoring structurally fixes a TOCTOU (Time-Of-Check to
Time-Of-Use) vulnerability and Use-After-Free risk involving the vma
pointer. In the previous layout, the mmap_read_lock is taken, the vma is
looked up, and then the lock is dropped before the function continues to
map the PFN. While an explicit vma = NULL safeguard was present, the vma
variable was still lexically in scope for the remainder of the function.

By isolating the locked region into kvm_s2_fault_get_vma_info(), the vma
pointer becomes a local variable strictly confined to that sub-helper.
Because the pointer's scope literally ends when the sub-helper returns,
it is not possible for the subsequent page fault logic in
kvm_s2_fault_pin_pfn() to accidentally access the vanished VMA,
eliminating this bug class by design.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5079a58b65b14..1f2c2200ccd8d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1740,7 +1740,7 @@ struct kvm_s2_fault {
 	vm_flags_t vm_flags;
 };
 
-static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
+static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 {
 	struct vm_area_struct *vma;
 	struct kvm *kvm = fault->vcpu->kvm;
@@ -1774,9 +1774,6 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 
 	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
 
-	/* Don't use the VMA after the unlock -- it may have vanished */
-	vma = NULL;
-
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
 	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
@@ -1788,6 +1785,17 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	fault->mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	return 0;
+}
+
+static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
+{
+	int ret;
+
+	ret = kvm_s2_fault_get_vma_info(fault);
+	if (ret)
+		return ret;
+
 	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
-- 
2.47.3

