Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00E83C17
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:05:10 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD5381516;
	Fri, 28 Apr 2023 05:05:54 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B150B3F5A1;
	Fri, 28 Apr 2023 05:05:09 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: Andrew Jones <drjones@redhat.com>,
	pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 19/29] arm/arm64: Rename etext to _etext
Date: Fri, 28 Apr 2023 13:03:55 +0100
Message-Id: <20230428120405.3770496-20-nikos.nikoleris@arm.com>
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

Rename etext to the more popular _etext allowing different linker
scripts to more easily be used.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/arm/setup.c | 4 ++--
 arm/flat.lds    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 59b0aedd..03a4098e 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -33,7 +33,7 @@
 #define NR_EXTRA_MEM_REGIONS	16
 #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
 
-extern unsigned long etext;
+extern unsigned long _etext;
 
 char *initrd;
 u32 initrd_size;
@@ -157,7 +157,7 @@ unsigned int mem_region_get_flags(phys_addr_t paddr)
 
 static void mem_regions_add_assumed(void)
 {
-	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
+	phys_addr_t code_end = (phys_addr_t)(unsigned long)&_etext;
 	struct mem_region *r;
 
 	r = mem_region_find(code_end - 1);
diff --git a/arm/flat.lds b/arm/flat.lds
index 47fcb649..9016ac9f 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -27,7 +27,7 @@ SECTIONS
     PROVIDE(_text = .);
     .text : { *(.init) *(.text) *(.text.*) }
     . = ALIGN(64K);
-    PROVIDE(etext = .);
+    PROVIDE(_etext = .);
 
     PROVIDE(reloc_start = .);
     .rela.dyn : { *(.rela.dyn) }
-- 
2.25.1

