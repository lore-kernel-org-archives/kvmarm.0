Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA393955D3
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 22:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786746333; cv=none; b=UM2AbBzWCaN8GYvlmA+J9cuLCanh9ws/La+c11oulpxHA6M5CfgC4s17VH23q9wAnAUcW+K9VUwGW5aqnAsbcQwzfhC3jb8QzHDgNjvx2Nvjc/a0grdUKOe+xcrwpUyql4SNxYPweG0ObI6lNHz7BM+YmOonVI+ypz1vG5fSeOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786746333; c=relaxed/simple;
	bh=W5P8QTaXkp+Wayx8mSPrX6v9guhFOjhs2fEdIvE2d+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2CVMVYa7wPumknSSHSI0aZhtb6GkKyln+oHWC2ho3oCja6eSWwCykaOnpFgsVFOskY1sIvtajxPIx//kKCf7m6Ocier4L68v+YEMYghTFT/pXIWzQoGZVmPdV4VL3L0C2rD7XX5SWvQzqgR/yRTV4uUFT63luO1B4d8t3Kc/Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=P875o408; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="P875o408"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAC6B1CDD;
	Fri, 14 Aug 2026 15:25:24 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93FB83F632;
	Fri, 14 Aug 2026 15:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786746328; bh=W5P8QTaXkp+Wayx8mSPrX6v9guhFOjhs2fEdIvE2d+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P875o408mULJ47Elq+B1BKlLtQSMKs0kL/5VA2/wPLn+jp5uHbbdiUQJA1T3Ko90A
	 t8UttLJy2+zW+9H8GIUZdEB2BXXm3ytXaXMZ7PfEUryUDv4BD7t6HlVToJ0P+GUjGZ
	 aWEjVrr9leBaf+80MjWemSkbyIGa8ZOJK8rSFGQM=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 1/2] arm64: ptdump: Make note_page_flush() range aware
Date: Fri, 14 Aug 2026 23:24:57 +0100
Message-ID: <20260814222458.584906-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814222458.584906-1-weilin.chang@arm.com>
References: <20260814222458.584906-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

note_page_flush() calls note_page() with addr == 0 and level == -1 to
dump the last row of a ptdump. addr == 0 (1 << 64 wrapped around)
renders a huge region with enormous size for address spaces with
IA bits < 64. For example the stage-2 page tables and the EFI runtime
page table.

More importantly, the last region of the address space and everything
after the address space up to 1 << 64 are merged into one row of
output. If the last region within the address space is valid, it will
appear to remain valid up to 1 << 64 with the same attributes.

Currently only the EFI runtime ptdump is affected by this, but KVM will
soon fix its stage-2 ptdump by using note_page_flush(). Here is an
example of an EFI runtime ptdump (last row):

0x0000008000000000-0x0000000000000000   17179868672G PGD

With this patch:

0x0000008000000000-0x0001000000000000      261632G PGD

To fix this, cache the end address of a ptdump in ptdump_pg_state so
note_page_flush() can call the final note_page() with the correct end
address.

Fixes: 9d80448ac92b ("efi/arm64: Add debugfs node to dump UEFI runtime page tables")
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/ptdump.h |  2 ++
 arch/arm64/mm/ptdump.c          | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 5b374a6ab34a..1b743de7d89e 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -52,6 +52,8 @@ struct ptdump_pg_state {
 	const struct addr_marker *marker;
 	const struct mm_struct *mm;
 	unsigned long start_address;
+	/* exclusive end, ULONG_MAX represents an end at 1 << 64 */
+	unsigned long end_address;
 	int level;
 	ptval_t current_prot;
 	bool check_wx;
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 1c20144700d7..eab400e744d9 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -278,9 +278,19 @@ void note_page_pgd(struct ptdump_state *pt_st, unsigned long addr, pgd_t pgd)
 
 void note_page_flush(struct ptdump_state *pt_st)
 {
+	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
+	unsigned long end = st->end_address;
 	pte_t pte_zero = {0};
 
-	note_page(pt_st, 0, -1, pte_val(pte_zero));
+	/*
+	 * Address spaces that end at 1 << 64 have end_address == ULONG_MAX,
+	 * but note_page() expects the exclusive end. In this case adjust end
+	 * to the wraparound value 0.
+	 */
+	if (end == ULONG_MAX)
+		end = 0;
+
+	note_page(pt_st, end, -1, pte_val(pte_zero));
 }
 
 static void arm64_ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm)
@@ -303,6 +313,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 		.marker = info->markers,
 		.mm = info->mm,
 		.pg_level = &kernel_pg_levels[0],
+		.end_address = end,
 		.level = -1,
 		.ptdump = {
 			.note_page_pte = note_page_pte,
@@ -344,6 +355,7 @@ bool ptdump_check_wx(void)
 			{ -1, NULL},
 		},
 		.pg_level = &kernel_pg_levels[0],
+		.end_address = ~0UL,
 		.level = -1,
 		.check_wx = true,
 		.ptdump = {
-- 
2.43.0

