Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73E02573
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:18:08 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04392176C;
	Mon, 13 Feb 2023 02:18:51 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8494E3F703;
	Mon, 13 Feb 2023 02:18:07 -0800 (PST)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	pbonzini@redhat.com,
	ricarkol@google.com
Subject: [PATCH v4 03/30] arm/Makefile.common: Compile lib/acpi.c if CONFIG_EFI=y
Date: Mon, 13 Feb 2023 10:17:32 +0000
Message-Id: <20230213101759.2577077-4-nikos.nikoleris@arm.com>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

For arm/arm64, ACPI is available only when UEFI is present. Compile
acpi.c if CONFIG_EFI is set to 'y'. For now, only x86 can configure the
tests with --enable-efi, but that will soon change.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/Makefile.common | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 1bbec64f..3a726c20 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -54,6 +54,10 @@ cflatobjs += lib/arm/smp.o
 cflatobjs += lib/arm/delay.o
 cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
 
+ifeq ($(CONFIG_EFI),y)
+cflatobjs += lib/acpi.o
+endif
+
 OBJDIRS += lib/arm
 
 libeabi = lib/arm/libeabi.a
-- 
2.25.1

