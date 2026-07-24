Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C997F38F629
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 18:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784919295; cv=none; b=tsL9tbJBk5zJGH+ToZ5Tfzu86Tylx5iVD4Vhin5rvtekTgH72/Wgm9wrdiWNp2pNeSpp+54EX/QRSqN6eZccrJV9T8vals98vvSKGFOqMFe9ZYzOEClTA9TrC5s/sngnrozz1EG5q1pQAsJduJFXxal16GQv9nrCrTl0Q+W/uvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784919295; c=relaxed/simple;
	bh=Q1VDWNE3+I+GnOSFyuDonVkxr0L9zZfgPrVh56WS1Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbIsfo54P7nG7JllWFA3q3f1eJlSo+dXCPvpWwZmyu5eUSU/ty77rGLV3qzP1aMrkLnZ7lrg8uZhk6OMQ+nDK1TK6bKenENjoDNVxfQyNJ2SRF9EhmBcTrsUAxUmBm3JrrySQEgK5otP4NRV5AApdtKoGi2eH3otiwRGLREsYbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g9Vf+KnT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g9Vf+KnT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAA761477;
	Fri, 24 Jul 2026 11:54:47 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FDBC3F66F;
	Fri, 24 Jul 2026 11:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784919291; bh=Q1VDWNE3+I+GnOSFyuDonVkxr0L9zZfgPrVh56WS1Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9Vf+KnTliDRWqJjoKnA+b5v6XKx7QBT+pJsfwfjJ+ysReEdEXy0X5qYYLI3BkmBu
	 fmS1+8R7aREni5OTtvOScazpwKh1LUJMB6u5QPQFp9bCQavu2TclJ0zXHxZizvcwiY
	 qzESB4GmQv2eAdc0IxLtZmmwUFFVFUu1aJL6ux4w=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matt Fleming <matt@codeblueprint.co.uk>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 1/2] arm64: ptdump: Make note_page_flush() range aware
Date: Fri, 24 Jul 2026 19:54:30 +0100
Message-ID: <20260724185431.2990395-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724185431.2990395-1-weilin.chang@arm.com>
References: <20260724185431.2990395-1-weilin.chang@arm.com>
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

To fix this, use ptdump_state.range[] to figure out where the address
space ends, and call note_page() with that.

Fixes: 9d80448ac92b ("efi/arm64: Add debugfs node to dump UEFI runtime page tables")
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/mm/ptdump.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 1c20144700d7..5b34060ceb96 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -278,9 +278,24 @@ void note_page_pgd(struct ptdump_state *pt_st, unsigned long addr, pgd_t pgd)
 
 void note_page_flush(struct ptdump_state *pt_st)
 {
+	const struct ptdump_range *range = pt_st->range;
+	unsigned long end = 0;
 	pte_t pte_zero = {0};
 
-	note_page(pt_st, 0, -1, pte_val(pte_zero));
+	while (range->start != range->end) {
+		end = range->end;
+		range++;
+	}
+
+	/*
+	 * Address spaces that end at 1 << 64 have range->end == ULONG_MAX,
+	 * but note_page() expects the exclusive end. In this case adjust end
+	 * to the wraparound value 0.
+	 */
+	if (end == ULONG_MAX)
+		end = 0;
+
+	note_page(pt_st, end, -1, pte_val(pte_zero));
 }
 
 static void arm64_ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm)
-- 
2.43.0

