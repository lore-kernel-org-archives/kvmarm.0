Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA53BBE64
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 13:15:44 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1B7C1682;
	Wed, 23 Aug 2023 06:16:24 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F9513F740;
	Wed, 23 Aug 2023 06:15:38 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	bristot@redhat.com,
	vschneid@redhat.com,
	mhiramat@kernel.org,
	rppt@kernel.org,
	hughd@google.com
Cc: pcc@google.com,
	steven.price@arm.com,
	anshuman.khandual@arm.com,
	vincenzo.frascino@arm.com,
	david@redhat.com,
	eugenis@google.com,
	kcc@google.com,
	hyesoo.yu@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH RFC 15/37] arm64: mte: Make tag storage depend on ARCH_KEEP_MEMBLOCK
Date: Wed, 23 Aug 2023 14:13:28 +0100
Message-Id: <20230823131350.114942-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230823131350.114942-1-alexandru.elisei@arm.com>
References: <20230823131350.114942-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tag storage memory requires that the tag storage pages used for data can be
migrated when they need to be repurposed to store tags.

If ARCH_KEEP_MEMBLOCK is enabled, kexec will scan all non-reserved
memblocks to find a suitable location for copying the kernel image. The
kernel image, once loaded, cannot be moved to another location in physical
memory. The initialization code for the tag storage reserves the memblocks
for the tag storage pages, which means kexec will not use them, and the tag
storage pages can be migrated at any time, which is the desired behaviour.

However, if ARCH_KEEP_MEMBLOCK is not selected, kexec will not skip a
region unless the memory resource has the IORESOURCE_SYSRAM_DRIVER_MANAGED
flag, which isn't currently set by the initialization code.

Make ARM64_MTE_TAG_STORAGE depend on ARCH_KEEP_MEMBLOCK to make it explicit
that that is required for it to work correctly.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ed27bb87babd..1e3d23ee22ab 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2081,6 +2081,7 @@ if ARM64_MTE
 config ARM64_MTE_TAG_STORAGE
 	bool "Dynamic MTE tag storage management"
 	select MEMORY_METADATA
+	depends on ARCH_KEEP_MEMBLOCK
 	help
 	  Adds support for dynamic management of the memory used by the hardware
 	  for storing MTE tags. This memory can be used as regular data memory
-- 
2.41.0

