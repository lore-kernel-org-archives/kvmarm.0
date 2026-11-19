Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114339;
	b=R7a4A8X6v5LmlsE7h+frAvH6GccEUPOzdQUNxknCHHL3ag3bx6B05LZdsB4Xj8GXYrRB
	 YJ8n9DEVnRhHpflRw0AIfC4WDtcjxNFFMBt+8le5rEphovrPvouHS1sWN9M1yN24d0xr2
	 4uDy5Ty7Q4Lp8hNGvAurSENWoa8Qg58nx4XWYMI5wgklqrWfdhOIKo5w2vSakgxqeivGm
	 j2mAS/9BLCXDW5WZ81ip3Hqp3I4HY0reUf4vZEK3qHh0AKWCZN6b+zqqxIZc7PnjZ6HF+
	 4Zo6d6tSjTsU+cwQIkPz+SpK9eCkSbTiORCeJ56ULNH7ETLGzF9D+HmOwnLnjZtE82w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JnPyo9Uuk9yDsv0rmtMWzSN2FAMU1ZcFas4I3l5JKQU=;
	b=aZTgOYrTsDMf0taHhGopIjlEOYDCm34HvEhOgs3rMnnw8fcAjxjnUKL74N7IX6tsKhRA
	 Pb54OLcOOPe7z1IWwPSg4TWK7ATmW9fHXCQNAYkuG3bMbSuittt7CZAPaa+qUUlgmzIZ9
	 YwVGavx080p+fxOImHuiP/UWVq+b1eRXAx6tGgwhmWOlSj13xPPXmOjhgdaZKuMZK8PrL
	 8oc4k3BCSUWAWVa6LBsY0Ynxdiu/8qpMwLDxXyp4J5iZ8xIMFRKegAhBKAtE5bK9al6Px
	 MRGoYKPvrFCy93cUDz+f8Fu9TQkRHAJwlRRa/17/LU0CezRDUZWV670kiCYJTO+5CPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SdFov0hP;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC29606A339
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FC29606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SdFov0hP
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b597558c4cso178368b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114337; x=1795719137; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JnPyo9Uuk9yDsv0rmtMWzSN2FAMU1ZcFas4I3l5JKQU=;
        b=SdFov0hPE0vVijV1q4xfE9chpc4D9YUz0xx4bAuEU+oujV25VTaKyUCZBLzPiMyrAq
         LjWv5zMK+/Fg7SqbdaV67S3CRhrldjgy2FTtGcYzO+PIL0yXPqoPHib3Id92f9fEVRDr
         ZVEyF33l4pReYuh3GMQpd9NOuwUZ79oXd4Zy7LWMaW2u6Hw9IYQhkZYfGGXJwC3sMRDw
         3Ms/LFIaJE7p4dVhp1MBSg4mpGhIXQJvf7G+IFyWobf2X6ivIp15ttguBJGRjphd6/VA
         mht2kkK5OiptnmgtbMvbHK4MJRVl2PQqVQ/nImQRZ10kYEgpfpUNqQr/jYs2I0XLIIW0
         6aAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114337; x=1795719137;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JnPyo9Uuk9yDsv0rmtMWzSN2FAMU1ZcFas4I3l5JKQU=;
        b=NptbtsnrQ5Ii+n8039o0c5au87ll3as1w4Tr/WNXYv/G8rCtaSnYnxgMGXj3PVovWG
         5Lf2vHIRU8+dGun6HRcNa0drgEdgfkedC8wPLtIG4beXeMpnoV16pU+zZEeYrxFkGGWm
         5D6G7SoXjx2tQXoySsY5Qu7kMysv9LoPG/Olto9lPcs0io7ho+lbIav7p2T2v45+1Aa/
         dRFZxpb5V6Ftj7K5SV1u8hoOm+gFu9iY9aMBrxzSgNbLGwpwLjr9qN8p1m7ItEL3u0JQ
         zzlZYN3dAEZxAYYGt9wZlXP6kQmtIYxW2MDoFmCY/qmgU0C0g0V+4xpwgDYK4gf1ATmR
         ZVBg==
X-Forwarded-Encrypted: i=1; AL+hErE7blTVpIsdC6+MsC//HbGCs1R+IoW29K8zu6ZRH3x9vYkpXVxSZTUVJ9Rw8t3KcDgdvKwtCD8=@lists.linux.dev
X-Gm-Message-State: APuU4Z+qb48uuFwEsBR0OMUlIaKqW8DKv1AWc0rOAcNvaGrnFLf9mCgs
	Y2rpDRIZbYoJ5E3CbHx48rAQU3Zitozncg4upu7KhFaAAc33p4voc/O+sFuLfaMEr9u984Eu+LR
	QAFFKcy2rApHE9/v/a+sP/o7i7w==
X-Received: from iok14-n2.prod.google.com ([2002:a05:6602:c60e:20b0:9b4:c92a:b174])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:308b:b0:4f1:6c9c:78d3 with SMTP id 5614622812f47-57a0a92272dmr980283b6e.26.1795114337076;
 Thu, 19 Nov 2026 10:52:17 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:43 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-2-coltonlewis@google.com>
Subject: [PATCH v10 01/33] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
counters reserved for the guest.

This required changing HPMN0 to an UnsignedEnum in tools/sysreg
because otherwise not all the appropriate macros are generated to add
it to arm64_cpu_capabilities_arm64_features.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 11 ++++++++++-
 arch/arm64/kvm/sys_regs.c      |  5 ++++-
 arch/arm64/tools/cpucaps       |  1 +
 arch/arm64/tools/sysreg        |  6 +++---
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c9c9a6889455c..023b98e6be2d1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -77,7 +77,7 @@
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
 
-#include <asm/arm_pmuv3.h>
+#include <linux/perf/arm_pmuv3.h>
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -566,6 +566,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -730,6 +731,7 @@ static const struct arm64_ftr_bits ftr_id_dfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_dfr1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_DFR1_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_DFR1_EL1_MTPMU_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
@@ -2863,6 +2865,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
 	},
+	{
+		.desc = "HPMN0",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HPMN0,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c7d91138a6d49..04947bfbd0ee5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2218,6 +2218,8 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	if (kvm_vcpu_has_pmu(vcpu))
 		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMUVer,
 				      kvm_arm_pmu_get_pmuver_limit());
+	else
+		val &= ~ID_AA64DFR0_EL1_HPMN0_MASK;
 
 	/* Hide SPE from guests */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
@@ -3417,7 +3419,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ID_AA64DFR0_EL1_DoubleLock_MASK |
 		    ID_AA64DFR0_EL1_WRPs_MASK |
 		    ID_AA64DFR0_EL1_PMUVer_MASK |
-		    ID_AA64DFR0_EL1_DebugVer_MASK),
+		    ID_AA64DFR0_EL1_DebugVer_MASK |
+		    ID_AA64DFR0_EL1_HPMN0_MASK),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 3125695122a0a..1603a0dd19764 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -43,6 +43,7 @@ HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_ICH_HCR_EL2_TDIR
 HAS_HCR_NV1
+HAS_HPMN0
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 997c62ab72e68..7230a9cd46e53 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1726,9 +1726,9 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
-Enum	63:60	HPMN0
-	0b0000	UNPREDICTABLE
-	0b0001	DEF
+UnsignedEnum	63:60	HPMN0
+	0b0000	NI
+	0b0001	IMP
 EndEnum
 UnsignedEnum	59:56	ExtTrcBuff
 	0b0000	NI
-- 
2.56.1.708.g77570a6a1d-goog

