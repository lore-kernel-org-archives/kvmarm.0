Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCADC31F9B1
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780673638; cv=none; b=J07oVpDQEjvi5yjwYiYfzSBDXV3W3NpyAEm1CKzj0rbc8Qb+icVkdbSP5Tizf3yx7NeK+lH1cRERaic/7036rK/Flrpr0qzVerqP//irjZR7wslkdDqDtwXzu2YM6ETrxOWC8BvJ24MlSChkLNUOIFt9e2UIE2nSsXO/koRGS1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780673638; c=relaxed/simple;
	bh=iJk4qjveu3UoNnJ691h+ELzlPLvx6w5PQjerE7+VMUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foN1VrAw2cBFzT8d8dWQel/gjffOUCBcxisgRJqEwubHb/+Ur4GiY2dReMrWZWmdrBFM/0bp4u90nV2RuR8xc3nhpGjEubxt+PDhxI/YVjhFe2EdVM20cfLP0x1oL13uHmqdF+CZrQirZ4r/yA4f3FdakOuO8fZfWzPqrjZkmqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rcmKxTgw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rcmKxTgw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E3D134FE;
	Fri,  5 Jun 2026 08:33:48 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7F0C3F86F;
	Fri,  5 Jun 2026 08:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780673632; bh=iJk4qjveu3UoNnJ691h+ELzlPLvx6w5PQjerE7+VMUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcmKxTgw5I4C0CsiJ4siCezSQ+0XGnrijovnLD0FgmitLGGEg4HMlrCtMh/ek4gqi
	 H3NJlux6boKl7w8I7T353PXyeVYPpqtluvaKl165XjqIzO/WrL3jjxkMKtmVtzyFRv
	 vQFMY00/wcnZoyEywrjdv0AuHDHxAWyLm3eLtd+U=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 1/2] KVM: arm64: Replace memslot_is_logging() with kvm_slot_dirty_track_enabled()
Date: Fri,  5 Jun 2026 16:32:47 +0100
Message-ID: <20260605153248.2412064-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260605153248.2412064-1-weilin.chang@arm.com>
References: <20260605153248.2412064-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When checking whether a memslot has dirty logging enabled, the
KVM_MEM_LOG_DIRTY_PAGES flag is the source of truth. Previously we were
using memslot_is_logging() which only tests dirty bitmap and did not
consider dirty ring. This was not detected because
KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP was introduced together with KVM
arm64 dirty ring, and users need to enable it to ensure dirty
information is not lost for the case of VGIC LPI/ITS table changes.

Fix this by using kvm_slot_dirty_track_enabled() instead which checks
KVM_MEM_LOG_DIRTY_PAGES.

Note that memslot_is_logging() also treats a memslot as not logging if
KVM_MEM_READONLY is set, hence a memslot with both dirty logging and
read only would be seen as not logging for memslot_is_logging(), but
logging for kvm_slot_dirty_track_enabled(). This allows a read only
mapping of size > PAGE_SIZE to be built when memslot_is_logging() is
used, leading to a better read performance compared to
kvm_slot_dirty_track_enabled(). However memslots that have both
KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY set do not really make
sense as dirty logging is essentially nop for a read only memslot, so
this shouldn't affect real workloads much.

Fixes: 9cb1096f8590 ("KVM: arm64: Enable ring-based dirty memory tracking")
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
It took me a long investigation to acquire the context needed to
understand this change, however the reason for this problem not being
detected is an educated guess. Please let me know if this is wrong or
if there are other issues, thanks!

 arch/arm64/kvm/mmu.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4da9281312eb..06c46124d3e7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -161,11 +161,6 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 	return ret;
 }
 
-static bool memslot_is_logging(struct kvm_memory_slot *memslot)
-{
-	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
-}
-
 /**
  * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
  * @kvm:	pointer to kvm structure.
@@ -1748,7 +1743,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 {
 	short vma_shift;
 
-	if (memslot_is_logging(s2fd->memslot)) {
+	if (kvm_slot_dirty_track_enabled(s2fd->memslot)) {
 		s2vi->max_map_size = PAGE_SIZE;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1953,7 +1948,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	*prot = KVM_PGTABLE_PROT_R;
 
 	if (s2vi->map_writable && (s2vi->device ||
-				   !memslot_is_logging(s2fd->memslot) ||
+				   !kvm_slot_dirty_track_enabled(s2fd->memslot) ||
 				   kvm_is_write_fault(s2fd->vcpu)))
 		*prot |= KVM_PGTABLE_PROT_W;
 
@@ -2084,7 +2079,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
 	memcache = get_mmu_memcache(s2fd->vcpu);
-	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
+	if (!perm_fault || (kvm_slot_dirty_track_enabled(s2fd->memslot) &&
 			    kvm_is_write_fault(s2fd->vcpu))) {
 		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
 		if (ret)
-- 
2.43.0

