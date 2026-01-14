Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437CE396B6E
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391935; cv=none; b=NSM37xC+pu4+YuN8mFJ/AoA3ZWp6jO7wz/H2Q1udIcTB/ZO606grzMbo31WWmrTWm2Htf31SIth4bpmVE3ifJz/yS1LdUWNK4yin3+Jm1GlfbIzDn+xcX12sycO670BXdEfvDKEm0BzuB/5pksx/rnD9Tzj8eInEmIvLbRdnQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391935; c=relaxed/simple;
	bh=Jq9hTm+PWw3J7nwlRwF/nIpZ3RQ50hoxepqhSZ3LRYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CXR9uubLHsDUkR8E0S8kl4Ho6XlEhlhe3E6S74TmJx6pdI/HFvwglIZa6MI3AmJqKGFFWRvgQ9y2ozsKo7JCRCQWPh19dUO4ObcC7YKgjCkKy2RVXAwUcZEA2dpZapzx+/MH6oCqxsUKID+F4cOAmOMODHAc4wuE8m+kB8wtyJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AE251650;
	Wed, 14 Jan 2026 03:58:42 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EC873F632;
	Wed, 14 Jan 2026 03:58:47 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 03/11] arm64: efi: initialise SCTLR_ELx fully
Date: Wed, 14 Jan 2026 11:56:55 +0000
Message-Id: <20260114115703.926685-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't rely on the value of SCTLR_ELx when booting via EFI.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 lib/arm/asm/setup.h   |  6 ++++++
 lib/arm/setup.c       |  2 ++
 lib/arm64/processor.c | 14 ++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 9f8ef82e..4e60d552 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -28,6 +28,12 @@ void setup(const void *fdt, phys_addr_t freemem_start);
 
 #include <efi.h>
 
+#ifdef __aarch64__
+void setup_efi_sctlr(void);
+#else
+static inline void setup_efi_sctlr(void) {}
+#endif
+
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 
 #endif
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 67b5db07..49f5e0f6 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+	setup_efi_sctlr();
+
 	exceptions_init();
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index eb93fd7c..f9fea519 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
+#include <asm/setup.h>
 #include <asm/thread_info.h>
 
 static const char *vector_names[] = {
@@ -271,3 +272,16 @@ bool __mmu_enabled(void)
 {
 	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
 }
+
+#ifdef CONFIG_EFI
+
+void setup_efi_sctlr(void)
+{
+	/*
+	 * EFI exits boot services with SCTLR_ELx.M=1, so keep
+	 * the MMU enabled.
+	 */
+	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);
+}
+
+#endif
-- 
2.25.1

