Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0639256F
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:18:07 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E24A8176A;
	Mon, 13 Feb 2023 02:18:49 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E70E3F703;
	Mon, 13 Feb 2023 02:18:06 -0800 (PST)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	ricarkol@google.com
Subject: [PATCH v4 02/30] x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
Date: Mon, 13 Feb 2023 10:17:31 +0000
Message-Id: <20230213101759.2577077-3-nikos.nikoleris@arm.com>
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

Compiler flag -macculate-outgoing-args is only needed by the x86_64
ABI. Move it to the relevant Makefile.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 Makefile            | 4 ----
 x86/Makefile.x86_64 | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6ed5deac..307bc291 100644
--- a/Makefile
+++ b/Makefile
@@ -40,14 +40,10 @@ OBJDIRS += $(LIBFDT_objdir)
 
 # EFI App
 ifeq ($(CONFIG_EFI),y)
-EFI_ARCH = x86_64
 EFI_CFLAGS := -DCONFIG_EFI
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
-# Function calls must include the number of arguments passed to the functions
-# More details: https://wiki.osdev.org/GNU-EFI
-EFI_CFLAGS += -maccumulate-outgoing-args
 # GCC defines wchar to be 32 bits, but EFI expects 16 bits
 EFI_CFLAGS += -fshort-wchar
 # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f483dead..2771a6fa 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -2,6 +2,10 @@ cstart.o = $(TEST_DIR)/cstart64.o
 bits = 64
 ldarch = elf64-x86-64
 ifeq ($(CONFIG_EFI),y)
+# Function calls must include the number of arguments passed to the functions
+# More details: https://wiki.osdev.org/GNU-EFI
+CFLAGS += -maccumulate-outgoing-args
+
 exe = efi
 bin = so
 FORMAT = efi-app-x86_64
-- 
2.25.1

