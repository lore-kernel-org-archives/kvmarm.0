Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55D338D69D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030410; cv=none; b=I30GhshQcSRRqasQ0YJ0qRf5j/HyExjdb2ZHORQ88Po9yGtHh5iEL1NsYsp/LjXRMXRT8hmOLEilVKF9XzDrdX8z7wjQW3QyZOgK/u8Xq57l8Rz78WBVqjEkiJCmuctVgNjRWzRU48++0sPiAsy2jyo/4wBhcHkSQdgRy8xLx2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030410; c=relaxed/simple;
	bh=0sHCsiFR68L+YiQqudbh7dXb+D2OosNbQD6DJoCp7Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeCsNgCY1iuG2oogqee8DRt48TNechcCXy+hrru6gog0ZklutkThDqW7vw/CRaEg3XOjwHoF1kr2wwiyW81ltbz/g3hjxOq1lYS+H+1Z7D1cDutJFCG50iV82ZO1D1hM0fNZcaxHa/IWyzFuzpj3IjpVJe59AIBFHcrfe5KuKXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YjU4N3bd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YjU4N3bd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCEDF1477;
	Tue, 14 Jul 2026 05:00:03 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99ACC3F93E;
	Tue, 14 Jul 2026 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784030408; bh=0sHCsiFR68L+YiQqudbh7dXb+D2OosNbQD6DJoCp7Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjU4N3bdOSPXXEn2diDSlkjIBmOqSHXjvjYKDQy7IeV2AUTdV2OGKfEkPD6GjhDR9
	 /fzMnKugMlyxjJaUaPQn2Qhgz28K/JqqRc9O4z6+niQRI05C8pkW5nSN+QyswWwrHI
	 IrXqcKGSeh38bjN9L5YgE5OiTQoVx3tK7uopgpVI=
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
Subject: [PATCH v4 3/6] KVM: arm64: nv: Add nested revmap broken tracepoint
Date: Tue, 14 Jul 2026 12:59:22 +0100
Message-ID: <20260714115926.2044757-4-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714115926.2044757-1-weilin.chang@arm.com>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a tracepoint to track when a nested reverse map becomes broken. This
makes it easier to detect NV performance degradation caused by full
shadow stage-2 unmaps.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/nested.c    |  7 ++++++-
 arch/arm64/kvm/trace_arm.h | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 065823e415ce..22f8a1daca93 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -17,6 +17,7 @@
 #include <asm/sysreg.h>
 
 #include "sys_regs.h"
+#include "trace.h"
 
 struct vncr_tlb {
 	/* The guest's VNCR_EL2 */
@@ -916,8 +917,12 @@ void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
 
 	mas_set_range(&mas_rmap, canonical_ipa, canonical_ipa_end);
 	if (mas_store_gfp(&mas_rmap, xa_mk_value(new_entry),
-			  GFP_NOWAIT | __GFP_ACCOUNT))
+			  GFP_NOWAIT | __GFP_ACCOUNT)) {
+		trace_kvm_nested_revmap_broken(mmu - mmu->arch->nested_mmus,
+					       canonical_ipa, canonical_ipa_end,
+					       nested_ipa, new_entry);
 		mmu->nested_revmap_broken = true;
+	}
 unlock:
 	mtree_unlock(revmap_mt);
 }
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 9c60f6465c78..0db90068ff63 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -415,6 +415,33 @@ TRACE_EVENT(kvm_forward_sysreg_trap,
 		      sys_reg_Op2(__entry->sysreg))
 );
 
+TRACE_EVENT(kvm_nested_revmap_broken,
+	    TP_PROTO(int mmu_idx, unsigned long canonical_ipa,
+		     unsigned long canonical_ipa_end, unsigned long nested_ipa,
+		     unsigned long revmap_entry),
+	    TP_ARGS(mmu_idx, canonical_ipa, canonical_ipa_end, nested_ipa, revmap_entry),
+
+	    TP_STRUCT__entry(
+		__field(int,			mmu_idx)
+		__field(unsigned long,		canonical_ipa)
+		__field(unsigned long,		nested_ipa)
+		__field(size_t,			size)
+		__field(unsigned long,		revmap_entry)
+	    ),
+
+	    TP_fast_assign(
+		__entry->mmu_idx = mmu_idx;
+		__entry->canonical_ipa = canonical_ipa;
+		__entry->nested_ipa = nested_ipa;
+		__entry->size = canonical_ipa_end - canonical_ipa + 1;
+		__entry->revmap_entry = revmap_entry;
+	    ),
+
+	    TP_printk("mmu idx: %d, cipa: 0x%016lx, nipa: 0x%016lx, size: 0x%016lx, entry: %016lx",
+		      __entry->mmu_idx, __entry->canonical_ipa, __entry->nested_ipa,
+		      __entry->size, __entry->revmap_entry)
+);
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.43.0

