Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDFC27714
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 16:10:25 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 031261BB0;
	Tue, 30 May 2023 09:11:11 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB4DF3F663;
	Tue, 30 May 2023 09:10:24 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 27/32] lib: Avoid external dependency in libelf
Date: Tue, 30 May 2023 17:09:19 +0100
Message-Id: <20230530160924.82158-28-nikos.nikoleris@arm.com>
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

There is just a small number of definitions we need from
uapi/linux/elf.h and asm/elf.h and the relocation code is
self-contained.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/elf.h | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 lib/elf.h

diff --git a/lib/elf.h b/lib/elf.h
new file mode 100644
index 00000000..abd5cf4b
--- /dev/null
+++ b/lib/elf.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: LGPL-2.0-or-later */
+/*
+ * Relevant definitions from uapi/linux/elf.h and asm/elf.h
+ */
+
+#ifndef _ELF_H_
+#define _ELF_H_
+
+#include <libcflat.h>
+
+/* 64-bit ELF base types. */
+typedef u64	Elf64_Addr;
+typedef u64	Elf64_Xword;
+typedef s64	Elf64_Sxword;
+
+typedef struct {
+	Elf64_Sxword d_tag;             /* entry tag value */
+	union {
+		Elf64_Xword d_val;
+		Elf64_Addr d_ptr;
+	} d_un;
+} Elf64_Dyn;
+
+typedef struct elf64_rel {
+	Elf64_Addr r_offset;    /* Location at which to apply the action */
+	Elf64_Xword r_info;     /* index and type of relocation */
+} Elf64_Rel;
+
+typedef struct elf64_rela {
+	Elf64_Addr r_offset;    /* Location at which to apply the action */
+	Elf64_Xword r_info;     /* index and type of relocation */
+	Elf64_Sxword r_addend;  /* Constant addend used to compute value */
+} Elf64_Rela;
+
+/* This is the info that is needed to parse the dynamic section of the file */
+#define DT_NULL		0
+#define DT_RELA		7
+#define DT_RELASZ	8
+#define DT_RELAENT	9
+
+/* x86 relocation types. */
+#define R_X86_64_NONE		0       /* No reloc */
+#define R_X86_64_RELATIVE	8       /* Adjust by program base */
+
+
+/*
+ * AArch64 static relocation types.
+ */
+
+/* Miscellaneous. */
+#define R_AARCH64_NONE		256
+#define R_AARCH64_RELATIVE	1027
+
+/* The following are used with relocations */
+#define ELF64_R_TYPE(i)		((i) & 0xffffffff)
+
+#endif /* _ELF_H_ */
-- 
2.25.1

