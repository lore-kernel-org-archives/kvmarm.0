Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3125D27717
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 16:10:17 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D59C1AC1;
	Tue, 30 May 2023 09:11:02 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED8D23F663;
	Tue, 30 May 2023 09:10:15 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: Andrew Jones <drjones@redhat.com>,
	pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 20/32] arm/arm64: Rename etext to _etext
Date: Tue, 30 May 2023 17:09:12 +0100
Message-Id: <20230530160924.82158-21-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
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

