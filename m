Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F0F38E8A4
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 16:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787676158; cv=none; b=dPBUVd87qA6QBkYCNqllMBVNHF+uipBx4FRMvfSCNRR8t4jp/3jKZOrXKmLVF/FQCMJ1GIDDvu7ABLMoNQ4okbbic6OG8rnP8MHzauEDZKjRSyTsFG+sur2rc58a8cZe7hbCwrMr6mL8t3XN1l3g00J8monySTxE+rOqYA7EZLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787676158; c=relaxed/simple;
	bh=CYocrFWmtpehijgOQcGCt0ml+hOpQBMXbSBN0pxWBYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jfSJf7/Or+WEFWWo7dHAqCdt+g979oRd4xO4Ld2z7b4NBe/+QFItt/P5A0/Rvuvwqg1KkfIMwBHXhKO/jIrJSEVJygFwQgGsU6SozC+Mp14JRtwv/VTmxYF+47NATqv7FyV+AGo8luSbz55ghoZZ+1PLNBF4yzfVXBJgyRveL44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h/3l8OqF; arc=none smtp.client-ip=91.218.175.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h/3l8OqF"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CYocrFWmtpehijgOQcGCt0ml+hOpQBMXbSBN0pxWBYg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787676154; v=1; x=1788280954;
 b=h/3l8OqFwZfY77u+/ur1hFq103jfMJ9kpESQwXqjQ/0w8oPXX1QGLKDk5FTdyLD9TqCe5bAI
 tLIiTIoov8PXdykCWf1yz36O4hJC0rCr+nWfx5nL4JqM0iwr4KKpnvYgHp48JDcHguREISdYIvb
 Yme+R6F35RrEtxLi2xfmi52o=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 5c13a4e79d66ea44;
	Tue, 25 Aug 2026 16:42:34 +0000
X-Mizu-Trace-ID: 5c13a4e79d66ea44
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
Subject: [PATCH v4 2/2] arm64: Don't read GMID_EL1 when MTE is disabled
Date: Tue, 25 Aug 2026 17:42:19 +0100
Message-Id: <20260825164219.3347229-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825164219.3347229-1-fuad.tabba@linux.dev>
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__cpuinfo_store_cpu() gates the GMID_EL1 read on the raw
ID_AA64PFR1_EL1, so it reads the register even when the kernel has
disabled MTE (CONFIG_ARM64_MTE=n or arm64.nomte). KVM sets HCR_EL2.TID5
in that case, and pKVM injects an UNDEF the host cannot handle:

  Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
  pc : __cpuinfo_store_cpu+0xf4/0x264
  Kernel panic - not syncing: Attempted to kill the idle task!

Only pKVM reaches it, and only after a CPU is offlined and brought back
online: its CPU_ON relay sets the host HCR before the CPU enters EL1,
while plain nVHE sets it at CPUHP_AP_KVM_ONLINE.

Gate the read on __read_sysreg_by_encoding(), which applies the cmdline
override, and on CONFIG_ARM64_MTE, which no register reflects.

Fixes: f35abcbb8a084 ("KVM: arm64: Trap MTE access and discovery when MTE is disabled")
Cc: stable@vger.kernel.org # needs "arm64: Apply overrides to CPU local capabilities"
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/cpufeature.h | 9 +++++++++
 arch/arm64/kernel/cpufeature.c      | 6 ++----
 arch/arm64/kernel/cpuinfo.c         | 2 +-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db5..0b374e938f708 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -1085,6 +1085,15 @@ static inline bool cpu_has_lpa2(void)
 #endif
 }
 
+/* No ID register reflects CONFIG_ARM64_MTE. */
+static inline bool gmid_el1_accessible(void)
+{
+	if (!IS_ENABLED(CONFIG_ARM64_MTE))
+		return false;
+
+	return id_aa64pfr1_mte(__read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1));
+}
+
 #endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 88b15b5ef2f7f..23f174b3c4e26 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1228,7 +1228,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		init_cpu_ftr_reg(SYS_MPAMIDR_EL1, info->reg_mpamidr);
 	}
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
+	if (gmid_el1_accessible())
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
 }
 
@@ -1523,11 +1523,9 @@ void update_cpu_features(int cpu,
 	 * they read/write depends on the GMID_EL1.BS field. Check that the
 	 * value is the same on all CPUs.
 	 */
-	if (IS_ENABLED(CONFIG_ARM64_MTE) &&
-	    id_aa64pfr1_mte(info->reg_id_aa64pfr1)) {
+	if (gmid_el1_accessible())
 		taint |= check_update_ftr_reg(SYS_GMID_EL1, cpu,
 					      info->reg_gmid, boot->reg_gmid);
-	}
 
 	/*
 	 * If we don't have AArch32 at all then skip the checks entirely
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index d50e2a9b066b3..389fca84f106b 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -502,7 +502,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
 	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
+	if (gmid_el1_accessible())
 		info->reg_gmid = read_cpuid(GMID_EL1);
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
-- 
2.39.5

