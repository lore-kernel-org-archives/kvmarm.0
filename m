Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127FD3C1D
	for <kvmarm@lists.linux.dev>; Fri, 28 Apr 2023 12:05:18 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 855461595;
	Fri, 28 Apr 2023 05:06:01 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 923523F5A1;
	Fri, 28 Apr 2023 05:05:16 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 25/29] arm64: Use code from the gnu-efi when booting with EFI
Date: Fri, 28 Apr 2023 13:04:01 +0100
Message-Id: <20230428120405.3770496-26-nikos.nikoleris@arm.com>
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

arm/efi/crt0-efi-aarch64.S defines the header and the handover
sequence from EFI to a efi_main. This change includes the whole file
in arm/cstart64.S when we compile with EFI support.

In addition, we change the handover code in arm/efi/crt0-efi-aarch64.S
to align the stack pointer. This alignment is necessary because we
make assumptions about cpu0's stack alignment and most importantly we
place its thread_info at the bottom of this stack.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/cstart64.S             |  6 ++++++
 arm/efi/crt0-efi-aarch64.S | 19 +++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 223c1092..cbd6b511 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -15,6 +15,10 @@
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
 
+#ifdef CONFIG_EFI
+#include "efi/crt0-efi-aarch64.S"
+#else
+
 .macro zero_range, tmp1, tmp2
 9998:	cmp	\tmp1, \tmp2
 	b.eq	9997f
@@ -107,6 +111,8 @@ start:
 	bl	exit
 	b	halt
 
+#endif
+
 .text
 
 /*
diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
index d50e78dd..5d0dc04a 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -111,10 +111,17 @@ section_table:
 
 	.align		12
 _start:
-	stp		x29, x30, [sp, #-32]!
+	stp		x29, x30, [sp, #-16]!
+
+	/* Align sp; this is necessary due to way we store cpu0's thread_info */
 	mov		x29, sp
+	mov		x30, sp
+	and		x30, x30, #THREAD_MASK
+	mov		sp, x30
+	str		x29, [sp, #-16]!
+
+	stp		x0, x1, [sp, #-16]!
 
-	stp		x0, x1, [sp, #16]
 	mov		x2, x0
 	mov		x3, x1
 	adr		x0, ImageBase
@@ -123,8 +130,12 @@ _start:
 	bl		_relocate
 	cbnz		x0, 0f
 
-	ldp		x0, x1, [sp, #16]
+	ldp		x0, x1, [sp], #16
 	bl		efi_main
 
-0:	ldp		x29, x30, [sp], #32
+	/* Restore sp */
+	ldr		x30, [sp], #16
+	mov             sp, x30
+
+0:	ldp		x29, x30, [sp], #16
 	ret
-- 
2.25.1

