Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F4F1991C3;
	Mon, 28 Oct 2024 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730108447; cv=none; b=npuQzbBEDIhpizGl6pmDs/ymx+0xl5D3R7a8xrBFVWFj4+sPJmTw4NOPN++X+whMBDmnHqmvboIETnWZyezRmFGSK0AxH9HG+qvSerm8LlIDWWWT8cKUEymBqonZEqsfsZGCJDOLIfV+x4RgGK9Vh0AhdM0Bb4k+EO3MgBT29yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730108447; c=relaxed/simple;
	bh=z1mUlgIUaANV/bPlzaFct/onP+Qou91QVjn4WHN+xBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9F8/wqY4RqDZ3srHBhDWQOmSsfZjbRrqZ0bSX18RzBLK/qH3MwJiIqiicA0Uw+WROp32Db3LeXMEDqkrlngxXW5B3bXzIaH7Ht9fNxzKfFJb7pLkT5KwjmkBCuCd6xRH/7OEBroyiROFEedlb6apfuMJpGkxmN3N3IuN5C/2H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=makORikM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="makORikM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EA3C4CEE3;
	Mon, 28 Oct 2024 09:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730108446;
	bh=z1mUlgIUaANV/bPlzaFct/onP+Qou91QVjn4WHN+xBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=makORikMMp9/UbWQJ3sLJYYmDweBYANAH51dd82Y2lkQOuR/iidUeUDNFZazncjP9
	 SXlxlDLkTEuXSuJxdvyV3ic8Z8x8fkCuv5P2eGaDWz96MXcgNl1bu+4ps234VH4hFz
	 hojhDqOkIT0MHmmm27Yqe04+In8D8Unw308HCHt3aw71+SxoM2XbzPIpwKzBZYbNDO
	 CkomdyrKrGxLm7fCWIb77ITglUOIe6z6qrVF/clVOowdB2jt3wT1XARtYa/+jYQ3uo
	 UiBKwAvgSnrqo9SM5rouDqir2whDwApOP26Gxoxe6qY9Zh0LMW8iGZjivdTvPpcIfQ
	 7UQJd5K8abhYg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH 3/4] arm64: mte: update code comments
Date: Mon, 28 Oct 2024 15:10:13 +0530
Message-ID: <20241028094014.2596619-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
initialisation") updated the locking such the kernel now allows
VM_SHARED mapping with MTE. Update the code comment to reflect this.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/kvm/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a509b63bd4dd..b5824e93cee0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1390,11 +1390,8 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
  * able to see the page's tags and therefore they must be initialised first. If
  * PG_mte_tagged is set, tags have already been initialised.
  *
- * The race in the test/set of the PG_mte_tagged flag is handled by:
- * - preventing VM_SHARED mappings in a memslot with MTE preventing two VMs
- *   racing to santise the same page
- * - mmap_lock protects between a VM faulting a page in and the VMM performing
- *   an mprotect() to add VM_MTE
+ * The race in the test/set of the PG_mte_tagged flag is handled by
+ * using PG_mte_lock and PG_mte_tagged together.
  */
 static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 			      unsigned long size)
@@ -1646,7 +1643,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new disallowed VMA */
+		/*
+		 *  not a permission fault implies a translation fault which
+		 *  means mapping the page for the first time
+		 */
 		if (mte_allowed) {
 			sanitise_mte_tags(kvm, pfn, vma_pagesize);
 		} else {
-- 
2.43.0

