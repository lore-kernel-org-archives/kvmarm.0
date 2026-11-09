Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.78
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214199;
	b=S+c0ZAogssdNgzAeZW4Q0ApPYCEgXMdAv1EZ34o4ah1bk+lukUngolXFrNcPlhudXJzq
	 yr/9kEUm3jD/3aPya79KVSJEdO+X7gT8JACCNe3UJFZRs2jtmy1OrsmsT8pJ8E+DWxqTj
	 O7ZqcPNIZjwU8McRhM/yqC0o5hvNgO29Zky1cULM6Xy/4GlYTJx90dy5Kj3zvC4thK3yn
	 RtL0O/WfE/5u+YAnW8RmQuBflN+2kgEAuhTKY13TfHYoH54nszQg8/MiXFk99BY1r2g+U
	 m1ghZnaSF91KnaiHdrM6/WpBaX9k9au9Fjl0iOe27iARqbEoY0dRea0zdBm+m1aqXHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214199;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RKQQUYkySIuWXQVY7MpCGDxE52luhCcCeJyJckRYrE0=;
	b=2SUZQK373fQllYkQ73wdKL5Jpk9yn5fFuqn9yBzvCbrYka8GChFjtxdLbQ6q2SStlaVC
	 9KldMc2H1aiK+jdYJ39EYPbxfrhX2fVxQLa8k6oA9zQu20jhkvHdHZWPlAOPTqNsu7UZI
	 HgOpxB6pssN2Tmiox1uUClJot3N59SNnvHXYIquQobu+1P9uH5Flqn+lWzd52lXl0g1B2
	 SYmEABz02P0XjubAcFtu79jFQF+Kser4Wnjg1IEK4ax3qs4lYOggpc4kcCvtVq/oRWBBo
	 On2Nc06S6+Uatfzhr+1ZYzx60QSCG19eLR78yzy1sHeGrQT16WsYFHQ44iGgeLGIIWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="qGQ/gftV";
	arc=none smtp.remote-ip=95.215.58.78
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD17606EEB5
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CD17606EEB5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qGQ/gftV
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pvY9wx5XSdLlCtF08ytiK5bki8t7g1hmkb8W5MfUPHI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214196; v=1; x=1794818996;
 b=qGQ/gftVTTbGZfwL+l0GXJMRIfJWWbLu4dDKaOxOwWKqhPjKDITZMN/GCgSvkST5Arbyxm3H
 P1FBQQH4FWbh6uqFtyiGxcqT1P0+ffs/dsSQ83mYrEji940IrrVKgQdFFxhAnPoXevAjufXWgjU
 wN+KWBJqJ3PrwLZIigGQ7BCw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 72df1d8da48c0203;
	Mon, 09 Nov 2026 08:49:55 +0000
X-Mizu-Trace-ID: 72df1d8da48c0203
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/19] KVM: arm64: selftests: Check MOPS, PIE, POE and FPMR in a protected VM
Date: Mon,  9 Nov 2026 08:48:54 +0000
Message-ID: <20261109084854.840576-20-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109084854.840576-1-fuad.tabba@linux.dev>
References: <20261109084854.840576-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For each of MOPS, S1PIE, S1POE and FPMR that a protected VM's ID
registers advertise, EL2 has to set up the HCRX_EL2 enables, the
fine-grained traps and the context switch to match.

Check from the guest that each feature works when its ID field is set
and UNDEFs when it is clear. Working means the registers read back what
the guest writes, and a SETP/SETM/SETE fill completes. At v7.4-rc1 pKVM
advertises none of the four, so only the UNDEF cases run. Also check
that ID_AA64PFR2_EL1, ID_AA64ISAR3_EL1 and ID_AA64MMFR3_EL1 expose
nothing beyond the supported features, and that WFxT and the 128-bit
System register features stay hidden.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/arm64/pkvm_id_regs.c        | 70 +++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/pkvm_id_regs.c b/tools/testing/selftests/kvm/arm64/pkvm_id_regs.c
index 93ed557a30bc6..7a8367af3e009 100644
--- a/tools/testing/selftests/kvm/arm64/pkvm_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/pkvm_id_regs.c
@@ -33,6 +33,11 @@
 #define DBGBCR_VAL	((0xfUL << 5) | (1UL << 1))
 #define DBGWCR_VAL	((0xffUL << 5) | (3UL << 3) | (1UL << 1))
 
+/* Allocated encodings only: a reserved one reads back UNKNOWN. */
+#define PIR_PATTERN	0xeca87653210eca87UL
+#define POR_PATTERN	0x76543210UL
+#define FPMR_PATTERN	0x2a5a55c000UL
+
 extern unsigned char brk_insn;
 
 static volatile bool undef_seen;
@@ -132,6 +137,20 @@ static void assert_id_regs(void)
 	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64ISAR2_EL1) &
 			(ID_AA64ISAR2_EL1_APA3_MASK | ID_AA64ISAR2_EL1_GPA3_MASK), 0);
 
+	/* WFxT and the 128-bit System register and instruction features are hidden. */
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64ISAR2_EL1) &
+			(ID_AA64ISAR2_EL1_WFxT_MASK | ID_AA64ISAR2_EL1_SYSREG_128_MASK |
+			 ID_AA64ISAR2_EL1_SYSINSTR_128_MASK), 0);
+
+	/* Of these registers, only the fields of the features pKVM supports can be set. */
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_EL1_FPMR_MASK, 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64ISAR3_EL1) &
+			~(ID_AA64ISAR3_EL1_FPRCVT_MASK | ID_AA64ISAR3_EL1_LSFE_MASK |
+			  ID_AA64ISAR3_EL1_FAMINMAX_MASK | ID_AA64ISAR3_EL1_LSUI_MASK), 0);
+	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64MMFR3_EL1) &
+			~(ID_AA64MMFR3_EL1_TCRX_MASK | ID_AA64MMFR3_EL1_SCTLRX_MASK |
+			  ID_AA64MMFR3_EL1_S1PIE_MASK | ID_AA64MMFR3_EL1_S1POE_MASK), 0);
+
 	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64DFR1_EL1), 0);
 	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64AFR0_EL1), 0);
 	GUEST_ASSERT_EQ(read_sysreg_s(SYS_ID_AA64AFR1_EL1), 0);
@@ -217,6 +236,56 @@ static void assert_undef_regs(void)
 	GUEST_ASSERT_UNDEF(asm volatile(".arch_extension sve\n rdvl x0, #1" : : : "x0"));
 }
 
+/* setp [x0]!, x1!, x2; setm; sete */
+static void mops_set(void *dst, u64 len, u64 val)
+{
+	register void *d asm("x0") = dst;
+	register u64 n asm("x1") = len;
+	register u64 v asm("x2") = val;
+
+	asm volatile(".inst 0x19c20420\n\t.inst 0x19c24420\n\t.inst 0x19c28420"
+		     : "+r"(d), "+r"(n) : "r"(v) : "cc", "memory");
+}
+
+/* A feature's registers and instructions work when it's advertised and UNDEF when hidden. */
+static void assert_feature_access(void)
+{
+	u64 mmfr3 = read_sysreg_s(SYS_ID_AA64MMFR3_EL1);
+	u64 buf[4] = {};
+	int i;
+
+	if (SYS_FIELD_GET(ID_AA64MMFR3_EL1, S1PIE, mmfr3)) {
+		GUEST_ASSERT_RW(SYS_PIR_EL1, PIR_PATTERN);
+		GUEST_ASSERT_RW(SYS_PIRE0_EL1, PIR_PATTERN);
+	} else {
+		GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_PIR_EL1));
+		GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_PIRE0_EL1));
+	}
+
+	if (SYS_FIELD_GET(ID_AA64MMFR3_EL1, S1POE, mmfr3)) {
+		GUEST_ASSERT_RW(SYS_POR_EL1, POR_PATTERN);
+		GUEST_ASSERT_RW(SYS_POR_EL0, POR_PATTERN);
+	} else {
+		GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_POR_EL1));
+		GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_POR_EL0));
+	}
+
+	if (SYS_FIELD_GET(ID_AA64PFR2_EL1, FPMR, read_sysreg_s(SYS_ID_AA64PFR2_EL1)))
+		GUEST_ASSERT_RW(SYS_FPMR, FPMR_PATTERN);
+	else
+		GUEST_ASSERT_UNDEF((void)read_sysreg_s(SYS_FPMR));
+
+	if (SYS_FIELD_GET(ID_AA64ISAR2_EL1, MOPS, read_sysreg_s(SYS_ID_AA64ISAR2_EL1))) {
+		undef_seen = false;
+		mops_set(buf, sizeof(buf), 0x5a);
+		GUEST_ASSERT(!undef_seen);
+		for (i = 0; i < ARRAY_SIZE(buf); i++)
+			GUEST_ASSERT_EQ(buf[i], 0x5a5a5a5a5a5a5a5aUL);
+	} else {
+		GUEST_ASSERT_UNDEF(mops_set(buf, sizeof(buf), 0x5a));
+	}
+}
+
 static void assert_host_handled(void)
 {
 	/* Host-handled registers reach the guest with no UNDEF. */
@@ -236,6 +305,7 @@ static void guest_baseline(void)
 	else
 		assert_debug_raz_wi();
 	assert_undef_regs();
+	assert_feature_access();
 	assert_host_handled();
 
 	asm volatile("brk_insn: brk #0");
-- 
2.47.3

