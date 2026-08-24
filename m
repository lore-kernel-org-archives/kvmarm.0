Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A301B314D1A
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 07:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787555417; cv=none; b=K6t5adLuh6Di5V8wKh8w3tCIZb6TWDTULNj9Y111uu1z4nsiAy/WEszANHb89XK/hVgwkr5h6P/dVumn9eFXWj76pmw9+NKR3KPOLJ5SElFcxn2AjcnBDUGx4l3aH1drHnJ/W9NYwo7ut9EpqykgSqEwGDK/i8HjUv/UswclZ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787555417; c=relaxed/simple;
	bh=au6xQbhjJ6Ac1efAjVBkkpnspFlnMc1gX/jCiGcALR4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CRZvGuHNH1ZoCpcQfJyTX03Xu6rEOFs1M7AKERT8xfHqTmr8m0Aq7u20uHidSziegBkP37YQC3MFaNiedMW1VMUQvMzwsOKEU9f38rdMipPStI7YtwVlAsADxmlyNKBei3gXjg0Wq1nRJ9OckFFYUD3jFvK8j0TguXu3nc3jaDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hfpp4ZKb; arc=none smtp.client-ip=91.218.175.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hfpp4ZKb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=au6xQbhjJ6Ac1efAjVBkkpnspFlnMc1gX/jCiGcALR4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787555410; v=1; x=1788160210;
 b=Hfpp4ZKbj2MAqTcQhNHol4eUbT8tFa1og8fE6abhpNlZzQ+h6RRrJjCy4538luBG8opVFMNO
 QzzERDHMfkJu7b0THiHxiSWD3HTvJKQNr/46heKlvw9OtAHI2ezlZHcyeyYbDOym4O+y+JUsKMl
 dgQWMMCybpEQBjm8rwiPlQUM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 0d031bd8521c682b;
	Mon, 24 Aug 2026 07:10:08 +0000
X-Mizu-Trace-ID: 0d031bd8521c682b
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2] arm64: Defer the GMID_EL1 read to {init,update}_cpu_features()
Date: Mon, 24 Aug 2026 08:10:04 +0100
Message-Id: <20260824071004.504894-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
ID_AA64PFR1_EL1, so it reads the register on MTE hardware even when the
kernel has disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets
HCR_EL2.TID5 in that case, which traps the read to EL2 and injects an
UNDEF:

  Internal error: Oops - Undefined instruction: 0000000002000000 [#1]
  pc : __cpuinfo_store_cpu+0xf4/0x264
  Call trace:
   __cpuinfo_store_cpu+0xf4/0x264 (P)
   secondary_start_kernel+0xc8/0x1d0
   __secondary_switched+0xc0/0xc4
  Kernel panic - not syncing: Attempted to kill the idle task!

Only pKVM is affected, and only for a CPU that is offlined and brought
back online. Every CPU's first bring-up precedes KVM's initcall, and
pKVM refuses CPU_ON for a CPU that was not online when KVM initialised,
so hotplug is the only path to cpuinfo_store_cpu() with TID5 set. pKVM's
PSCI CPU_ON relay sets the host HCR before the CPU enters EL1, whereas
plain nVHE sets it at CPUHP_AP_KVM_ONLINE, after cpuinfo_store_cpu().

Defer the read to {init,update}_cpu_features() and gate it on the
sanitised ID register, as MPAM already does. system_supports_mte()
cannot serve as the gate, as update_cpu_features() also runs during
initial SMP bring-up, before smp_cpus_done() calls
setup_system_features(). The init path gains the CONFIG_ARM64_MTE test
the update path already had, leaving SYS_GMID_EL1 uninitialised when
MTE is compiled out, where its only other user (lib/mte.S) is not
built.

Fixes: f35abcbb8a084 ("KVM: arm64: Trap MTE access and discovery when MTE is disabled")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v1:
    - Clarified that the trap only fires on a CPU that is offlined and
      brought back online, not a late first boot (Marc).
    
    Tested on QEMU with -machine virt,mte=on, under pKVM.
    
    Offline/online CPU1 with arm64.nomte on the host cmdline: unpatched
    panics in __cpuinfo_store_cpu(), patched does not.

 arch/arm64/kernel/cpufeature.c | 19 ++++++++++++++++---
 arch/arm64/kernel/cpuinfo.c    |  8 +++++---
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120f..5120f6721b1e0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1176,6 +1176,17 @@ static bool detect_ftr_has_mpam(void)
 	return id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1);
 }
 
+/*
+ * Mirrors system_supports_mte(), which cannot be used before the capabilities
+ * are finalised. KVM sets HCR_EL2.TID5 when it is false, trapping GMID_EL1.
+ */
+static bool detect_has_mte(void)
+{
+	u64 pfr1 = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
+
+	return IS_ENABLED(CONFIG_ARM64_MTE) && id_aa64pfr1_mte(pfr1);
+}
+
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
 	/* Before we start using the tables, make sure it is sorted */
@@ -1228,8 +1239,10 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		init_cpu_ftr_reg(SYS_MPAMIDR_EL1, info->reg_mpamidr);
 	}
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
+	if (detect_has_mte()) {
+		info->reg_gmid = read_cpuid(GMID_EL1);
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
+	}
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1490,8 +1503,8 @@ void update_cpu_features(int cpu,
 	 * they read/write depends on the GMID_EL1.BS field. Check that the
 	 * value is the same on all CPUs.
 	 */
-	if (IS_ENABLED(CONFIG_ARM64_MTE) &&
-	    id_aa64pfr1_mte(info->reg_id_aa64pfr1)) {
+	if (detect_has_mte()) {
+		info->reg_gmid = read_cpuid(GMID_EL1);
 		taint |= check_update_ftr_reg(SYS_GMID_EL1, cpu,
 					      info->reg_gmid, boot->reg_gmid);
 	}
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index d50e2a9b066b3..c8967f185e3dd 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -502,12 +502,14 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
 	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
-		info->reg_gmid = read_cpuid(GMID_EL1);
-
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
 		__cpuinfo_store_cpu_32bit(&info->aarch32);
 
+	/*
+	 * info->reg_gmid deferred to {init,update}_cpu_features because
+	 * reading it traps to EL2 when MTE is disabled.
+	 */
+
 	/*
 	 * info->reg_mpamidr deferred to {init,update}_cpu_features because we
 	 * don't want to read it (and trigger a trap on buggy firmware) if
-- 
2.39.5

