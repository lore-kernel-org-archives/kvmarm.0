Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1F9395DAF
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 11:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391937; cv=none; b=SWVkRaLmStF5S/xjfeOVfLBPnEmz7D0qu8zPu24Z0TkpnOwJVlcnrRwajY+1A3de6BBdW5WdUtNEYjaex8GLGr4mGQs3RU/Uicd8EnxWzjWVBKw6S+7WlefNLmI10r9HtckqPqMGqDzT8EVEXO/UWe2MCs1/X5zaF9k1snU81po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391937; c=relaxed/simple;
	bh=qMT4SOjpBVl5muZrm1yCxr4j1oujyqsjailAc+wXJlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O2sQS0L9J3tcTp5DQJyuGe/44LQYUqjOVncqDQcxnPkPUy/YVM5c0TJXtQkWkfCoJqiW6usR/rDkEhoi8umC7YX2XGu+aYxwIALsN0WLF8j/xPG9zLnC28YJswCiZXSl469PcIADokiV2LcyPM1BnHeytPCa63fyFtHmHxGaENM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A8291655;
	Wed, 14 Jan 2026 03:58:44 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 900E03F632;
	Wed, 14 Jan 2026 03:58:49 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 04/11] arm64: efi: initialise the EL
Date: Wed, 14 Jan 2026 11:56:56 +0000
Message-Id: <20260114115703.926685-5-joey.gouly@arm.com>
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

Initialise the exception level, which may include dropping to EL1 from EL2,
if VHE is not supported.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/efi/crt0-efi-aarch64.S | 5 +++++
 lib/arm/asm/setup.h        | 2 ++
 lib/arm/setup.c            | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
index 71ce2794..5632fee0 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -147,6 +147,11 @@ _start:
 0:	ldp		x29, x30, [sp], #32
 	ret
 
+.globl do_init_el
+do_init_el:
+	init_el x16
+	ret
+
 	.section	.data
 
 .balign 65536
diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 4e60d552..bf05ffbb 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -29,8 +29,10 @@ void setup(const void *fdt, phys_addr_t freemem_start);
 #include <efi.h>
 
 #ifdef __aarch64__
+void do_init_el(void);
 void setup_efi_sctlr(void);
 #else
+static inline void do_init_el(void) {}
 static inline void setup_efi_sctlr(void) {}
 #endif
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 49f5e0f6..5ff40b54 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+	do_init_el();
+
 	setup_efi_sctlr();
 
 	exceptions_init();
-- 
2.25.1

