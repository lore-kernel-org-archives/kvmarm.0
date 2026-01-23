Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95399285CBA
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187073; cv=none; b=seVFcalMk4g3l62b9SXToGMcb+PNexeBV0E3D/j2T1DBLJgdHLOv58tVFIEYBB2LCEbNHAo1h5rpIuarZXufHLglrNoHT7f6+HnoLdm77J5R0UQq4azwkE7yt8OgC49an2ZGy5tyVefzGXtij2SzLNTy9AOCNzkOvQImbVVk9Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187073; c=relaxed/simple;
	bh=qMT4SOjpBVl5muZrm1yCxr4j1oujyqsjailAc+wXJlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gQy9qspHMWf51s9LePTokG9j2LZ6PZmQggaIbAYIKyh1wpANk9vrlcsuhtdr+rQVkrmnlt0kl6Bw1Lsqtjq3+XDsnWzPYy3p1HvXINkFomXb67ImDsIpRD+8iijHZ9EGpy3QOUUaQfJuE4JZcLOyQSgjuQtvBhJ8RnYV+EifuzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4021D1684;
	Fri, 23 Jan 2026 08:51:04 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 662FB3F694;
	Fri, 23 Jan 2026 08:51:09 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 05/14] arm64: efi: initialise the EL
Date: Fri, 23 Jan 2026 16:50:44 +0000
Message-Id: <20260123165053.2250754-6-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260123165053.2250754-1-joey.gouly@arm.com>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
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

