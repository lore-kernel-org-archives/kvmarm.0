Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7672FB3
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:04:59 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC2EA14BF;
	Fri, 28 Apr 2023 05:05:40 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAA1E3F5A1;
	Fri, 28 Apr 2023 05:04:55 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 07/29] lib/acpi: Ensure all struct definition for ACPI tables are packed
Date: Fri, 28 Apr 2023 13:03:43 +0100
Message-Id: <20230428120405.3770496-8-nikos.nikoleris@arm.com>
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

All ACPI table definitions are provided with precise definitions of
field sizes and offsets, make sure that no compiler optimization can
interfere with the memory layout of the corresponding structs.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/acpi.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/acpi.h b/lib/acpi.h
index f9a344e9..53e41c4b 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -3,6 +3,12 @@
 
 #include "libcflat.h"
 
+/*
+ * All tables and structures must be byte-packed to match the ACPI
+ * specification, since the tables are provided by the system firmware.
+ */
+#pragma pack(1)
+
 #define ACPI_SIGNATURE(c1, c2, c3, c4) \
 	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
 
@@ -103,6 +109,8 @@ struct acpi_table_facs_rev1 {
 	u8 reserved3[40];	/* Reserved - must be zero */
 };
 
+#pragma pack(0)
+
 void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
 void *find_acpi_table_addr(u32 sig);
 
-- 
2.25.1

