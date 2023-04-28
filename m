Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38A72F53
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:04:57 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5F4D1480;
	Fri, 28 Apr 2023 05:05:39 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D41D93F5A1;
	Fri, 28 Apr 2023 05:04:54 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 06/29] x86: Avoid references to fields of ACPI tables
Date: Fri, 28 Apr 2023 13:03:42 +0100
Message-Id: <20230428120405.3770496-7-nikos.nikoleris@arm.com>
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

ACPI table definitions in <acpi.h> have to be packed.  However, once
we do that, direct references to members of the packed struct might
result in unaligned pointers and gcc complains about them. This change
modifies the code to avoid such references in preparation for making
the APCI table definitions packed.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 x86/s3.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/x86/s3.c b/x86/s3.c
index 96db728c..910c57fb 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -2,15 +2,6 @@
 #include "acpi.h"
 #include "asm/io.h"
 
-static u32* find_resume_vector_addr(void)
-{
-    struct acpi_table_facs_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
-    if (!facs)
-        return 0;
-    printf("FACS is at %p\n", facs);
-    return &facs->firmware_waking_vector;
-}
-
 #define RTC_SECONDS_ALARM       1
 #define RTC_MINUTES_ALARM       3
 #define RTC_HOURS_ALARM         5
@@ -40,12 +31,14 @@ extern char resume_start, resume_end;
 int main(int argc, char **argv)
 {
 	struct acpi_table_fadt_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
-	volatile u32 *resume_vector_ptr = find_resume_vector_addr();
+	struct acpi_table_facs_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
 	char *addr, *resume_vec = (void*)0x1000;
 
-	*resume_vector_ptr = (u32)(ulong)resume_vec;
+	assert(facs);
+	facs->firmware_waking_vector = (u32)(ulong)resume_vec;
 
-	printf("resume vector addr is %p\n", resume_vector_ptr);
+	printf("FACS is at %p\n", facs);
+	printf("resume vector addr is %p\n", &facs->firmware_waking_vector);
 	for (addr = &resume_start; addr < &resume_end; addr++)
 		*resume_vec++ = *addr;
 	printf("copy resume code from %p\n", &resume_start);
-- 
2.25.1

