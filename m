Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C252C15A6
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810313; cv=none; b=KURByGzCYXwE7vjyoSj+LE7cR+Vzp8yPjq+e6MdZxISsCH3mU4ZWLAZm6SQYqBkQsYk+ZwjE1LZEm48V1SrOPMh/CnctW+dA2tCTxFRsBuur4wifSW/TV/xpuMUoUxY1h/uEVSLquBgVAhoQrqf255MaQvxyq20JplAolWG0E6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810313; c=relaxed/simple;
	bh=jE5qFd8aCzPzhFiibLwZtoM2vlDCXw6n+ke0/1pLRLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TLfklYWd0xqwteErWYl4rF2wfahdQcRB/z9QneyJzkuSaaCwR66zLtdvovxemexJNjn/Pqr7Q7Fknfmx3j4dAmk0msICGUVa3kUEX7avzbWf3drMCzPH+VLXQMyDP5arpLFxWoLYYx1IqUhVkzz+mS2XFe+xdzupq4/jw2ppgOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E766F1692;
	Thu, 25 Sep 2025 07:25:03 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA6513F694;
	Thu, 25 Sep 2025 07:25:10 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 03/10] arm64: efi: initialise the EL
Date: Thu, 25 Sep 2025 15:19:51 +0100
Message-Id: <20250925141958.468311-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialise the exception level, which may include dropping to EL1 from EL2, if
VHE is not supported.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/efi/crt0-efi-aarch64.S | 5 +++++
 lib/arm/asm/setup.h        | 2 ++
 lib/arm/setup.c            | 1 +
 3 files changed, 8 insertions(+)

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
index 0aaa1d3a..5ff40b54 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -349,6 +349,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
+	do_init_el();
 
 	setup_efi_sctlr();
 
-- 
2.25.1

