Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2533D84
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 17:08:45 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12310C14;
	Tue, 28 Feb 2023 09:09:28 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD9193F881;
	Tue, 28 Feb 2023 09:08:43 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v1 2/2] KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
Date: Tue, 28 Feb 2023 17:07:56 +0000
Message-Id: <20230228170756.769461-3-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230228170756.769461-1-ryan.roberts@arm.com>
References: <20230228170756.769461-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The high bits [51:48] of a physical address should appear at [15:12] in
a 64K pte, not at [51:48] as was previously being programmed. Fix this
with new helper functions that do the conversion correctly. This also
sets us up nicely for adding LPA2 encodings in future.

Fixes: 7a6629ef746d ("kvm: selftests: add virt mem support for aarch64")

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 .../selftests/kvm/lib/aarch64/processor.c     | 32 ++++++++++++++-----
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 5972a23b2765..13f28d96521c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -58,10 +58,27 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> vm->page_shift) & mask;
 }
 
-static uint64_t pte_addr(struct kvm_vm *vm, uint64_t entry)
+static uint64_t addr_pte(struct kvm_vm *vm, uint64_t pa, uint64_t attrs)
 {
-	uint64_t mask = ((1UL << (vm->va_bits - vm->page_shift)) - 1) << vm->page_shift;
-	return entry & mask;
+	uint64_t pte;
+
+	pte = pa & GENMASK(47, vm->page_shift);
+	if (vm->page_shift == 16)
+		pte |= (pa & GENMASK(51, 48)) >> (48 - 12);
+	pte |= attrs;
+
+	return pte;
+}
+
+static uint64_t pte_addr(struct kvm_vm *vm, uint64_t pte)
+{
+	uint64_t pa;
+
+	pa = pte & GENMASK(47, vm->page_shift);
+	if (vm->page_shift == 16)
+		pa |= (pte & GENMASK(15, 12)) << (48 - 12);
+
+	return pa;
 }
 
 static uint64_t ptrs_per_pgd(struct kvm_vm *vm)
@@ -110,18 +127,18 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
 	if (!*ptep)
-		*ptep = vm_alloc_page_table(vm) | 3;
+		*ptep = addr_pte(vm, vm_alloc_page_table(vm), 3);
 
 	switch (vm->pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = vm_alloc_page_table(vm) | 3;
+			*ptep = addr_pte(vm, vm_alloc_page_table(vm), 3);
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = vm_alloc_page_table(vm) | 3;
+			*ptep = addr_pte(vm, vm_alloc_page_table(vm), 3);
 		/* fall through */
 	case 2:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, vaddr) * 8;
@@ -130,8 +147,7 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
 	}
 
-	*ptep = paddr | 3;
-	*ptep |= (attr_idx << 2) | (1 << 10) /* Access Flag */;
+	*ptep = addr_pte(vm, paddr, (attr_idx << 2) | (1 << 10) | 3);  /* AF */
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
-- 
2.25.1

