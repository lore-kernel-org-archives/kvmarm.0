Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D40B364028
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204253; cv=none; b=aEegerMiGLhkNsrahtRa+9UIABRk+AvaYCI9Bnoo+zBKvs+B7nuZR4e8YD6+S70m0jEqkL9uic7wVfSqSsAt+LYD/WtS6rLAenHwGhHsTyMKd3lRwUrCS8YILnopm+93vA6N9ogBGmaJTTCRQBB9KkqDqRp8vOYOoL1CtZNzw4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204253; c=relaxed/simple;
	bh=ksO25QtyOGlGyKTzZzMZ1uikYmKFYzW7rjKhL+LaAHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KjDBgXOI9FVDf1+peLKTVzCs4MPKMeOgfNzHc8CeX4nrqS75MpJemM7sbABf/LVWZg2FNYYwePSWAM3ZEOQ8Cz1Co8lsUoGnhMpiQR4I5De0XYz8D27AxK1dEPijWzHpErceewjVZ6vZCDTQDC6yo8UmKEWi3QoCvuTvFroGWJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=riO8AQDg; arc=none smtp.client-ip=95.215.58.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="riO8AQDg"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ksO25QtyOGlGyKTzZzMZ1uikYmKFYzW7rjKhL+LaAHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788204249; v=1; x=1788809049;
 b=riO8AQDgqyKmj4oL9OJKle2YguQpvq5XUKGg8TS7X13WfDxzEHfF4p0qlQWgM7XeXVH+tFcF
 TCZR9JShRXYbA9NqEy/YwHzZ52JUHukFHWaDldnGboSlxRpeYM2azmC6hWp/rKQ3zmPXaJFY2nL
 CqRpDvZjLaSuVFvZ6h1o+7lg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4bda6408a007b156;
	Mon, 31 Aug 2026 19:24:09 +0000
X-Mizu-Trace-ID: 4bda6408a007b156
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool 3/5] kvm: Name every exit reason the UAPI header defines
Date: Mon, 31 Aug 2026 20:24:04 +0100
Message-Id: <20260831192406.1341841-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831192406.1341841-1-fuad.tabba@linux.dev>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_exit_reasons[] stops at KVM_EXIT_INTERNAL_ERROR, so the panic path
prints "UNKNOWN" for every reason KVM has gained since. On arm64 that
covers KVM_EXIT_SYSTEM_EVENT and KVM_EXIT_ARM_NISV, and the newer
KVM_EXIT_MEMORY_FAULT, KVM_EXIT_ARM_SEA and KVM_EXIT_ARM_LDST64B.

Name the rest of the reasons the synced uapi header defines, up to
KVM_EXIT_SNP_REQ_CERTS. KVM_EXIT_PAPR_HCALL also loses its CONFIG_PPC64
guard, which the build never defines, so that entry was missing from
every configuration. The neighbouring PPC reasons are unconditional
already.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 kvm.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/kvm.c b/kvm.c
index b416f6f..828da64 100644
--- a/kvm.c
+++ b/kvm.c
@@ -52,9 +52,32 @@ static const char * const kvm_exit_reasons[] = {
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_DCR),
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_NMI),
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_INTERNAL_ERROR),
-#ifdef CONFIG_PPC64
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_OSI),
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_PAPR_HCALL),
-#endif
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_S390_UCONTROL),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_WATCHDOG),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_S390_TSCH),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_EPR),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_SYSTEM_EVENT),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_S390_STSI),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_IOAPIC_EOI),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_HYPERV),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_ARM_NISV),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_X86_RDMSR),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_X86_WRMSR),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_DIRTY_RING_FULL),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_AP_RESET_HOLD),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_X86_BUS_LOCK),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_XEN),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_RISCV_SBI),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_RISCV_CSR),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_NOTIFY),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_LOONGARCH_IOCSR),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_MEMORY_FAULT),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_TDX),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_ARM_SEA),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_ARM_LDST64B),
+	DEFINE_KVM_EXIT_REASON(KVM_EXIT_SNP_REQ_CERTS),
 };
 
 const char *kvm__exit_reason_str(__u32 exit_reason)
-- 
2.39.5

