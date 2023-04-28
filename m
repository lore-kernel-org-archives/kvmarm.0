Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F823C17
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:05:13 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AFB1150C;
	Fri, 28 Apr 2023 05:05:57 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E9893F5A1;
	Fri, 28 Apr 2023 05:05:12 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: Andrew Jones <drjones@redhat.com>,
	pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 21/29] arm64: Add a new type of memory type flag MR_F_RESERVED
Date: Fri, 28 Apr 2023 13:03:57 +0100
Message-Id: <20230428120405.3770496-22-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit

From: Andrew Jones <drjones@redhat.com>

This will be used by future change to add PTE entries for special EFI
memory regions.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/arm/asm/setup.h | 1 +
 lib/arm/mmu.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index f0e70b11..64cd379b 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -15,6 +15,7 @@ extern int nr_cpus;
 
 #define MR_F_IO			(1U << 0)
 #define MR_F_CODE		(1U << 1)
+#define MR_F_RESERVED		(1U << 2)
 #define MR_F_UNKNOWN		(1U << 31)
 
 struct mem_region {
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 18e32b2b..2f4ec815 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -222,6 +222,10 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 	for (r = mem_regions; r->end; ++r) {
 		if (r->flags & MR_F_IO) {
 			continue;
+		} else if (r->flags & MR_F_RESERVED) {
+			/* Reserved pages need to be writable for whatever reserved them */
+			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
+					   __pgprot(PTE_WBWA));
 		} else if (r->flags & MR_F_CODE) {
 			/* armv8 requires code shared between EL1 and EL0 to be read-only */
 			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
-- 
2.25.1

