Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA4E256A
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:18:33 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25C2E1F02;
	Mon, 13 Feb 2023 02:19:16 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A66883F703;
	Mon, 13 Feb 2023 02:18:32 -0800 (PST)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [PATCH v4 25/30] arm64: Change GNU-EFI imported code to use defined types
Date: Mon, 13 Feb 2023 10:17:54 +0000
Message-Id: <20230213101759.2577077-26-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
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
 arm/efi/reloc_aarch64.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
index 08672796..fa0cd6bc 100644
--- a/arm/efi/reloc_aarch64.c
+++ b/arm/efi/reloc_aarch64.c
@@ -34,14 +34,11 @@
     SUCH DAMAGE.
 */
 
-#include <efi.h>
-#include <efilib.h>
-
+#include "efi.h"
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

