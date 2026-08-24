Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDB237AA7E
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787596925; cv=none; b=sLkiY2k64Gt7J1ux/FsqdR47bfTZWzY1hSYDbzpOzunV6KIak+EHHohIN1U0cPCmMMmhtQCOktWZhJfebD2mMsqxk0JZBkRD13TebgIkHpYmlztFIvSkR5WdJZJqVInQ9na4RC0HzFYJ40WrGg+MRUcBVbdc0AMQo+r69ugsQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787596925; c=relaxed/simple;
	bh=mKxOK6il8hO1+Kr1wMob41kUctuaK3oMCEbCR+rq6j8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nOJKgaSADZHwIVi2ae8OIUDi6y7mCHDoLGqJqwVwX4thQAq+VdTQQ4DqJXNx2Be7YBlyJJ8Sw6XScN5oZF+WcGRUGQXXlH9zE3mrx9CxbAOspGgh7UOgV0/ev6bF1e22lZ/3vNEwI5sMUR4w72Ghz9+gQUy4JD2msLzRWak2+eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sL2MbGqP; arc=none smtp.client-ip=95.215.58.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sL2MbGqP"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mKxOK6il8hO1+Kr1wMob41kUctuaK3oMCEbCR+rq6j8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787596919; v=1; x=1788201719;
 b=sL2MbGqPKEJtwD0Uew0sm8yj/F/1904h2M/fmxOZgst/PE5lXRZATioZ3v+j9/uDCpnueBvi
 arFCb/cHAdMtmKY4NEiJ+s0cvkw7Mfjwm0Wl0xtGdPWVtkxNs7ecS0nr+QrmHkGxOtHqC6kS5aI
 S7ppblMWi9+vO6QbvZd9tXnw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 9451ed2f0a70d1e3;
	Mon, 24 Aug 2026 18:41:59 +0000
X-Mizu-Trace-ID: 9451ed2f0a70d1e3
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
Subject: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
Date: Mon, 24 Aug 2026 19:41:55 +0100
Message-Id: <20260824184155.2644646-1-fuad.tabba@linux.dev>
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
HCR_EL2.TID5 in that case, trapping the read to EL2, where pKVM injects
an UNDEF the host cannot handle:

  Internal error: Oops - Undefined instruction: 0000000002000000 [#1]
  pc : __cpuinfo_store_cpu+0xf4/0x264
  Kernel panic - not syncing: Attempted to kill the idle task!

Only pKVM is affected, and only on a CPU that is offlined and brought
back online: a first bring-up either precedes KVM's initcall or is
refused by pKVM's CPU_ON relay. That relay sets the host HCR before the
CPU enters EL1, whereas plain nVHE sets it at CPUHP_AP_KVM_ONLINE,
after cpuinfo_store_cpu().

Gate the read on ID_AA64PFR1_EL1 with the cmdline override applied, and
on CONFIG_ARM64_MTE, which no register value reflects. That leaves the
SYS_GMID_EL1 feature register uninitialised when MTE is off, and it has
no readers.

Fixes: f35abcbb8a084 ("KVM: arm64: Trap MTE access and discovery when MTE is disabled")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v2:
    - Keep the GMID_EL1 read in __cpuinfo_store_cpu() and gate it on the
      local ID_AA64PFR1_EL1 with the cmdline override applied, rather than
      deferring the read to {init,update}_cpu_features() (Will). This also
      keeps reg_gmid set in cpu_data[0], which v2 dropped (Catalin).
    
    Changes since v1:
    - Clarified that the trap only fires on a CPU that is offlined and
      brought back online, not a late first boot (Marc).
    
    Tested on QEMU with -machine virt,mte=on, under pKVM.
    
    Offline/online CPU1 with arm64.nomte on the host cmdline: unpatched
    panics in __cpuinfo_store_cpu(), patched does not.

 arch/arm64/include/asm/cpufeature.h | 15 +++++++++++++++
 arch/arm64/kernel/cpufeature.c      |  6 ++----
 arch/arm64/kernel/cpuinfo.c         |  2 +-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db5..5bb242721e4b9 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -1085,6 +1085,21 @@ static inline bool cpu_has_lpa2(void)
 #endif
 }
 
+/*
+ * Reading GMID_EL1 when the kernel has disabled MTE traps to EL2, and the raw
+ * ID_AA64PFR1_EL1 reflects neither CONFIG_ARM64_MTE nor the cmdline override.
+ */
+static inline bool gmid_el1_accessible(u64 pfr1)
+{
+	if (!IS_ENABLED(CONFIG_ARM64_MTE))
+		return false;
+
+	pfr1 &= ~id_aa64pfr1_override.mask;
+	pfr1 |= id_aa64pfr1_override.val;
+
+	return id_aa64pfr1_mte(pfr1);
+}
+
 #endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120f..4b339346f6c78 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1228,7 +1228,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 		init_cpu_ftr_reg(SYS_MPAMIDR_EL1, info->reg_mpamidr);
 	}
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
+	if (gmid_el1_accessible(info->reg_id_aa64pfr1))
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
 }
 
@@ -1490,11 +1490,9 @@ void update_cpu_features(int cpu,
 	 * they read/write depends on the GMID_EL1.BS field. Check that the
 	 * value is the same on all CPUs.
 	 */
-	if (IS_ENABLED(CONFIG_ARM64_MTE) &&
-	    id_aa64pfr1_mte(info->reg_id_aa64pfr1)) {
+	if (gmid_el1_accessible(info->reg_id_aa64pfr1))
 		taint |= check_update_ftr_reg(SYS_GMID_EL1, cpu,
 					      info->reg_gmid, boot->reg_gmid);
-	}
 
 	/*
 	 * If we don't have AArch32 at all then skip the checks entirely
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index d50e2a9b066b3..52a161fc38250 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -502,7 +502,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
 	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
 
-	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
+	if (gmid_el1_accessible(info->reg_id_aa64pfr1))
 		info->reg_gmid = read_cpuid(GMID_EL1);
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
-- 
2.39.5

