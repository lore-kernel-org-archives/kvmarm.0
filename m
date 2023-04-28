Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5BE3C1D
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:05:16 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DB351480;
	Fri, 28 Apr 2023 05:06:00 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C0DE3F5A1;
	Fri, 28 Apr 2023 05:05:15 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 24/29] arm64: Change GNU-EFI imported code to use defined types
Date: Fri, 28 Apr 2023 13:04:00 +0100
Message-Id: <20230428120405.3770496-25-nikos.nikoleris@arm.com>
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

Convert some types to avoid dependency on gnu-efi's <efi.h> and
<efilib.h>.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/efi/reloc_aarch64.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
index 08672796..5ba0ba1f 100644
--- a/arm/efi/reloc_aarch64.c
+++ b/arm/efi/reloc_aarch64.c
@@ -35,13 +35,10 @@
 */
 
 #include <efi.h>
-#include <efilib.h>
-
 #include <elf.h>
 
-EFI_STATUS _relocate (long ldbase, Elf64_Dyn *dyn,
-		      EFI_HANDLE image EFI_UNUSED,
-		      EFI_SYSTEM_TABLE *systab EFI_UNUSED)
+efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t image,
+		       efi_system_table_t *sys_tab)
 {
 	long relsz = 0, relent = 0;
 	Elf64_Rela *rel = 0;
-- 
2.25.1

