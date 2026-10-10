Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA34370AFC
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639498; cv=none; b=T9xv+44kz94Me4vaY1BQHuJYmwesq+4/Feq5qBIXOODwIhzOtFU6iIg4uNUf/Vx3EUpGzqX1gFvRvBsI4bNIvkcxiPrukIyFnYo0cDY2NXt1Oc6zoLd8XJCZU7uJC18yiOl6rEmuY+ALWm78fq95kMK7Jfp5s5ajU3Ce4DzcRh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639498; c=relaxed/simple;
	bh=YSTJgYu2nO2MqhSJPPmJjkB3Xe1bWJ5bIhMpD0Lsq+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mehTcPZTd6gAc2r90r5CVrf76eCwU8Bn3dApMunHwjL3KzIj94lKjWR7J9PPMFOksXbVyfbaTx9EaTUvszqleojU3JsFdvYwaCggLYLg+vVqyFYO0VvkjB0yR9pD0wLo7X/d1Zqk3gicenOzorHIQY9FphG6V1H16qXhzK+jDuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NcruhP7I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NcruhP7I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+7jpCnNWVONGrKduSQUm6TViuxQeMzjvlgr015jgBRY=;
	b=NcruhP7IQ6/XFPpkbA5vonMDBv0++ueaUAti5TJweL+XpggXx0dsvB1tIw5cbAHxwWD99K
	bG98qWBrehD4fsnY0B3cQC+X5k+I26UrHS/85wrS+NQJKeA29VfRYfal+rTGgHi9BOrEwm
	oCu/dkOoNgtPohvQJaqD0c4SpynA24k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-pPR30kTvOl6fypfLPmiVBg-1; Sat,
 10 Oct 2026 13:38:07 +0000
X-MC-Unique: pPR30kTvOl6fypfLPmiVBg-1
X-Mimecast-MFC-AGG-ID: pPR30kTvOl6fypfLPmiVBg_1791639485
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19F1B1802141;
	Sat, 10 Oct 2026 13:38:05 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 63F8830001BB;
	Sat, 10 Oct 2026 13:38:00 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v10 06/26] target/arm/cpu-idregs.h.inc: Generate with script
Date: Sat, 10 Oct 2026 15:36:10 +0200
Message-ID: <20261010133725.642498-7-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: -Y6LefaOV739BLLYLzZw5OBl8Z04IRycYXwkMYMShS0_1791639485
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce a script that takes as input the Registers.json file
delivered in the AARCHMRS Features Model downloadable from the
Arm Developer A-Profile Architecture Exploration Tools page:
https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
and automates the generation of system register properties definitions.

generates target/arm/cpu-idregs.h.inc containing definitions for
feature ID registers. Current generation is based on
AARCHMRS_OPENSOURCE_A_profile_FAT-2026-03.

We only care about IDregs with opcodes satisfying:
op0 = 3, op1 = {0,1,3}, crn = 0, crm within [0, 7], op2 within [0, 7]

Generate ID reg definitions with the scripts/update-aarch64-cpu-sysreg-properties.py
based on AARCHMRS_OPENSOURCE_A_profile_FAT-2026-03 Registers.json

Each register and fields are described with this pattern:

IDREG_START(REG)
IDREG_FIELD(REG, FIELD, SHIFT, LENGTH)
...
IDREG_END(REG)

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Suggested-by: Khushit Shah <khushit.shah@nutanix.com>
Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>

---

v9 -> v10:
- squashed the script and the generated header.
- improved comments
- some minor code rework like sorting inside the helper

v5 -> v6
- add ident
---
 target/arm/cpu-idregs.h.inc                   | 617 ++++++++++++++++++
 .../update-aarch64-cpu-sysreg-properties.py   | 165 +++++
 2 files changed, 782 insertions(+)
 create mode 100644 target/arm/cpu-idregs.h.inc
 create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py

diff --git a/target/arm/cpu-idregs.h.inc b/target/arm/cpu-idregs.h.inc
new file mode 100644
index 0000000000..a10d750123
--- /dev/null
+++ b/target/arm/cpu-idregs.h.inc
@@ -0,0 +1,617 @@
+/* AUTOMATICALLY GENERATED, DO NOT MODIFY */
+
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* IDREG_START(REG) */
+/*     IDREG_FIELD(REG, FIELD, SHIFT, LENGTH) */
+/* ... */
+/* IDREG_END(REG) */
+
+IDREG_START(AIDR_EL1)
+IDREG_END(AIDR_EL1)
+
+IDREG_START(CCSIDR2_EL1)
+    IDREG_FIELD(CCSIDR2_EL1, NumSets, 0, 24)
+IDREG_END(CCSIDR2_EL1)
+
+IDREG_START(CCSIDR_EL1)
+    IDREG_FIELD(CCSIDR_EL1, NumSets, 32, 24)
+    IDREG_FIELD(CCSIDR_EL1, Associativity, 3, 21)
+    IDREG_FIELD(CCSIDR_EL1, LineSize, 0, 3)
+IDREG_END(CCSIDR_EL1)
+
+IDREG_START(CLIDR_EL1)
+    IDREG_FIELD(CLIDR_EL1, Ttype7, 45, 2)
+    IDREG_FIELD(CLIDR_EL1, Ttype6, 43, 2)
+    IDREG_FIELD(CLIDR_EL1, Ttype5, 41, 2)
+    IDREG_FIELD(CLIDR_EL1, Ttype4, 39, 2)
+    IDREG_FIELD(CLIDR_EL1, Ttype3, 37, 2)
+    IDREG_FIELD(CLIDR_EL1, Ttype2, 35, 2)
+    IDREG_FIELD(CLIDR_EL1, Ttype1, 33, 2)
+    IDREG_FIELD(CLIDR_EL1, ICB, 30, 3)
+    IDREG_FIELD(CLIDR_EL1, LoUU, 27, 3)
+    IDREG_FIELD(CLIDR_EL1, LoC, 24, 3)
+    IDREG_FIELD(CLIDR_EL1, LoUIS, 21, 3)
+    IDREG_FIELD(CLIDR_EL1, Ctype7, 18, 3)
+    IDREG_FIELD(CLIDR_EL1, Ctype6, 15, 3)
+    IDREG_FIELD(CLIDR_EL1, Ctype5, 12, 3)
+    IDREG_FIELD(CLIDR_EL1, Ctype4, 9, 3)
+    IDREG_FIELD(CLIDR_EL1, Ctype3, 6, 3)
+    IDREG_FIELD(CLIDR_EL1, Ctype2, 3, 3)
+    IDREG_FIELD(CLIDR_EL1, Ctype1, 0, 3)
+IDREG_END(CLIDR_EL1)
+
+IDREG_START(CTR_EL0)
+    IDREG_FIELD(CTR_EL0, TminLine, 32, 6)
+    IDREG_FIELD(CTR_EL0, DIC, 29, 1)
+    IDREG_FIELD(CTR_EL0, IDC, 28, 1)
+    IDREG_FIELD(CTR_EL0, CWG, 24, 4)
+    IDREG_FIELD(CTR_EL0, ERG, 20, 4)
+    IDREG_FIELD(CTR_EL0, DminLine, 16, 4)
+    IDREG_FIELD(CTR_EL0, L1Ip, 14, 2)
+    IDREG_FIELD(CTR_EL0, IminLine, 0, 4)
+IDREG_END(CTR_EL0)
+
+IDREG_START(DCZID_EL0)
+    IDREG_FIELD(DCZID_EL0, TBS, 5, 4)
+    IDREG_FIELD(DCZID_EL0, DZP, 4, 1)
+    IDREG_FIELD(DCZID_EL0, BS, 0, 4)
+IDREG_END(DCZID_EL0)
+
+IDREG_START(GMID_EL1)
+    IDREG_FIELD(GMID_EL1, BS, 0, 4)
+IDREG_END(GMID_EL1)
+
+IDREG_START(ID_AA64AFR0_EL1)
+IDREG_END(ID_AA64AFR0_EL1)
+
+IDREG_START(ID_AA64AFR1_EL1)
+IDREG_END(ID_AA64AFR1_EL1)
+
+IDREG_START(ID_AA64DFR0_EL1)
+    IDREG_FIELD(ID_AA64DFR0_EL1, HPMN0, 60, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, ExtTrcBuff, 56, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, BRBE, 52, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, MTPMU, 48, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, TraceBuffer, 44, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, TraceFilt, 40, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, DoubleLock, 36, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, PMSVer, 32, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, CTX_CMPs, 28, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, WRPs, 20, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, PMSS, 16, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, BRPs, 12, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, PMUVer, 8, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, TraceVer, 4, 4)
+    IDREG_FIELD(ID_AA64DFR0_EL1, DebugVer, 0, 4)
+IDREG_END(ID_AA64DFR0_EL1)
+
+IDREG_START(ID_AA64DFR1_EL1)
+    IDREG_FIELD(ID_AA64DFR1_EL1, ABL_CMPs, 56, 8)
+    IDREG_FIELD(ID_AA64DFR1_EL1, DPFZS, 52, 4)
+    IDREG_FIELD(ID_AA64DFR1_EL1, EBEP, 48, 4)
+    IDREG_FIELD(ID_AA64DFR1_EL1, ITE, 44, 4)
+    IDREG_FIELD(ID_AA64DFR1_EL1, ABLE, 40, 4)
+    IDREG_FIELD(ID_AA64DFR1_EL1, PMICNTR, 36, 4)
+    IDREG_FIELD(ID_AA64DFR1_EL1, SPMU, 32, 4)
+    IDREG_FIELD(ID_AA64DFR1_EL1, CTX_CMPs, 24, 8)
+    IDREG_FIELD(ID_AA64DFR1_EL1, WRPs, 16, 8)
+    IDREG_FIELD(ID_AA64DFR1_EL1, BRPs, 8, 8)
+    IDREG_FIELD(ID_AA64DFR1_EL1, SYSPMUID, 0, 8)
+IDREG_END(ID_AA64DFR1_EL1)
+
+IDREG_START(ID_AA64DFR2_EL1)
+    IDREG_FIELD(ID_AA64DFR2_EL1, TRBE_EXC, 24, 4)
+    IDREG_FIELD(ID_AA64DFR2_EL1, SPE_nVM, 20, 4)
+    IDREG_FIELD(ID_AA64DFR2_EL1, SPE_EXC, 16, 4)
+    IDREG_FIELD(ID_AA64DFR2_EL1, BWE, 4, 4)
+    IDREG_FIELD(ID_AA64DFR2_EL1, STEP, 0, 4)
+IDREG_END(ID_AA64DFR2_EL1)
+
+IDREG_START(ID_AA64FPFR0_EL1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8CVT, 31, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8FMA, 30, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8DP4, 29, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8DP2, 28, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8MM8, 27, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8MM4, 26, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F16MM2, 15, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8E4M3, 1, 1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, F8E5M2, 0, 1)
+IDREG_END(ID_AA64FPFR0_EL1)
+
+IDREG_START(ID_AA64ISAR0_EL1)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, RNDR, 60, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, TLB, 56, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, TS, 52, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, FHM, 48, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, DP, 44, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, SM4, 40, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, SM3, 36, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, SHA3, 32, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, RDM, 28, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, Atomic, 20, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, CRC32, 16, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, SHA2, 12, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, SHA1, 8, 4)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, AES, 4, 4)
+IDREG_END(ID_AA64ISAR0_EL1)
+
+IDREG_START(ID_AA64ISAR1_EL1)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, LS64, 60, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, XS, 56, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, I8MM, 52, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, DGH, 48, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, BF16, 44, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, SPECRES, 40, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, SB, 36, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, FRINTTS, 32, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, GPI, 28, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, GPA, 24, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, LRCPC, 20, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, FCMA, 16, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, JSCVT, 12, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, API, 8, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, APA, 4, 4)
+    IDREG_FIELD(ID_AA64ISAR1_EL1, DPB, 0, 4)
+IDREG_END(ID_AA64ISAR1_EL1)
+
+IDREG_START(ID_AA64ISAR2_EL1)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, ATS1A, 60, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, LUT, 56, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, CSSC, 52, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, RPRFM, 48, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, PCDPHINT, 44, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, PRFMSLC, 40, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, SYSINSTR_128, 36, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, SYSREG_128, 32, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, CLRBHB, 28, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, PAC_frac, 24, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, BC, 20, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, MOPS, 16, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, APA3, 12, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, GPA3, 8, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, RPRES, 4, 4)
+    IDREG_FIELD(ID_AA64ISAR2_EL1, WFxT, 0, 4)
+IDREG_END(ID_AA64ISAR2_EL1)
+
+IDREG_START(ID_AA64ISAR3_EL1)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, LSCP, 44, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, LSCSHINT, 40, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, MTETC, 36, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, PAC_frac2, 32, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, FPRCVT, 28, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, LSUI, 24, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, OCCMO, 20, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, LSFE, 16, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, PACM, 12, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, TLBIW, 8, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, FAMINMAX, 4, 4)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, CPA, 0, 4)
+IDREG_END(ID_AA64ISAR3_EL1)
+
+IDREG_START(ID_AA64MMFR0_EL1)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, ECV, 60, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, FGT, 56, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, ExS, 44, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, TGran4_2, 40, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, TGran64_2, 36, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, TGran16_2, 32, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, TGran4, 28, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, TGran64, 24, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, TGran16, 20, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, BigEndEL0, 16, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, SNSMem, 12, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, BigEnd, 8, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, ASIDBits, 4, 4)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, PARange, 0, 4)
+IDREG_END(ID_AA64MMFR0_EL1)
+
+IDREG_START(ID_AA64MMFR1_EL1)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, ECBHB, 60, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, CMOW, 56, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, TIDCP1, 52, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, nTLBPA, 48, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, AFP, 44, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, HCX, 40, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, ETS, 36, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, TWED, 32, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, XNX, 28, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, SpecSEI, 24, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, PAN, 20, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, LO, 16, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, HPDS, 12, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, VH, 8, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, VMIDBits, 4, 4)
+    IDREG_FIELD(ID_AA64MMFR1_EL1, HAFDBS, 0, 4)
+IDREG_END(ID_AA64MMFR1_EL1)
+
+IDREG_START(ID_AA64MMFR2_EL1)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, E0PD, 60, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, EVT, 56, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, BBM, 52, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, TTL, 48, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, FWB, 40, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, IDS, 36, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, AT, 32, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, ST, 28, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, NV, 24, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, CCIDX, 20, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, VARange, 16, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, IESB, 12, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, LSM, 8, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, UAO, 4, 4)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, CnP, 0, 4)
+IDREG_END(ID_AA64MMFR2_EL1)
+
+IDREG_START(ID_AA64MMFR3_EL1)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, Spec_FPACC, 60, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, ADERR, 56, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, SDERR, 52, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, ANERR, 44, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, SNERR, 40, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, D128_2, 36, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, D128, 32, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, MEC, 28, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, AIE, 24, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, S2POE, 20, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, S1POE, 16, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, S2PIE, 12, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, S1PIE, 8, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, SCTLRX, 4, 4)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, TCRX, 0, 4)
+IDREG_END(ID_AA64MMFR3_EL1)
+
+IDREG_START(ID_AA64MMFR4_EL1)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, MTEFGT, 60, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, SCRX, 56, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, TEV, 52, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, TPS, 48, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, SRMASK, 44, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, TLBID, 40, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, E3DSE, 36, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, EAESR, 32, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, RMEGDI, 28, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, E2H0, 24, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, NV_frac, 20, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, FGWTE3, 16, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, HACDBS, 12, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, ASID2, 8, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, EIESB, 4, 4)
+    IDREG_FIELD(ID_AA64MMFR4_EL1, PoPS, 0, 4)
+IDREG_END(ID_AA64MMFR4_EL1)
+
+IDREG_START(ID_AA64PFR0_EL1)
+    IDREG_FIELD(ID_AA64PFR0_EL1, CSV3, 60, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, CSV2, 56, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, RME, 52, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, DIT, 48, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, AMU, 44, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, MPAM, 40, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, SEL2, 36, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, SVE, 32, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, RAS, 28, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, GIC, 24, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, AdvSIMD, 20, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, FP, 16, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, EL3, 12, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, EL2, 8, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, EL1, 4, 4)
+    IDREG_FIELD(ID_AA64PFR0_EL1, EL0, 0, 4)
+IDREG_END(ID_AA64PFR0_EL1)
+
+IDREG_START(ID_AA64PFR1_EL1)
+    IDREG_FIELD(ID_AA64PFR1_EL1, PFAR, 60, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, DF2, 56, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, MTEX, 52, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, THE, 48, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, GCS, 44, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, MTE_frac, 40, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, NMI, 36, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, CSV2_frac, 32, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, RNDR_trap, 28, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, SME, 24, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, MPAM_frac, 16, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, RAS_frac, 12, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, MTE, 8, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, SSBS, 4, 4)
+    IDREG_FIELD(ID_AA64PFR1_EL1, BT, 0, 4)
+IDREG_END(ID_AA64PFR1_EL1)
+
+IDREG_START(ID_AA64PFR2_EL1)
+    IDREG_FIELD(ID_AA64PFR2_EL1, VMTETCL, 44, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, VMTETC, 40, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, VMTE, 36, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, FPMR, 32, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, MPAM2, 28, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, FGDT, 24, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, MTEEIRG, 20, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, UINJ, 16, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, GCIE, 12, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, MTEFAR, 8, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, MTESTOREONLY, 4, 4)
+    IDREG_FIELD(ID_AA64PFR2_EL1, MTEPERM, 0, 4)
+IDREG_END(ID_AA64PFR2_EL1)
+
+IDREG_START(ID_AA64SMFR0_EL1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, FA64, 63, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, LUT6, 61, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, LUTv2, 60, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, SMEver, 56, 4)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, I16I64, 52, 4)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, F64F64, 48, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, I16I32, 44, 4)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, B16B16, 43, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, F16F16, 42, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, F8F16, 41, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, F8F32, 40, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, I8I32, 36, 4)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, F16F32, 35, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, B16F32, 34, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, BI32I32, 33, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, F32F32, 32, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, SF8FMA, 30, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, SF8DP4, 29, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, SF8DP2, 28, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, SBitPerm, 25, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, AES, 24, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, SFEXPA, 23, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, STMOP, 16, 1)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, SMOP4, 0, 1)
+IDREG_END(ID_AA64SMFR0_EL1)
+
+IDREG_START(ID_AA64ZFR0_EL1)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, F64MM, 56, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, F32MM, 52, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, F16MM, 48, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, I8MM, 44, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, SM4, 40, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, SHA3, 32, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, B16B16, 24, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, BF16, 20, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, BitPerm, 16, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, EltPerm, 12, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, AES, 4, 4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, SVEver, 0, 4)
+IDREG_END(ID_AA64ZFR0_EL1)
+
+IDREG_START(ID_AFR0_EL1)
+IDREG_END(ID_AFR0_EL1)
+
+IDREG_START(ID_DFR0_EL1)
+    IDREG_FIELD(ID_DFR0_EL1, TraceFilt, 28, 4)
+    IDREG_FIELD(ID_DFR0_EL1, PerfMon, 24, 4)
+    IDREG_FIELD(ID_DFR0_EL1, MProfDbg, 20, 4)
+    IDREG_FIELD(ID_DFR0_EL1, MMapTrc, 16, 4)
+    IDREG_FIELD(ID_DFR0_EL1, CopTrc, 12, 4)
+    IDREG_FIELD(ID_DFR0_EL1, MMapDbg, 8, 4)
+    IDREG_FIELD(ID_DFR0_EL1, CopSDbg, 4, 4)
+    IDREG_FIELD(ID_DFR0_EL1, CopDbg, 0, 4)
+IDREG_END(ID_DFR0_EL1)
+
+IDREG_START(ID_DFR1_EL1)
+    IDREG_FIELD(ID_DFR1_EL1, HPMN0, 4, 4)
+    IDREG_FIELD(ID_DFR1_EL1, MTPMU, 0, 4)
+IDREG_END(ID_DFR1_EL1)
+
+IDREG_START(ID_ISAR0_EL1)
+    IDREG_FIELD(ID_ISAR0_EL1, Divide, 24, 4)
+    IDREG_FIELD(ID_ISAR0_EL1, Debug, 20, 4)
+    IDREG_FIELD(ID_ISAR0_EL1, Coproc, 16, 4)
+    IDREG_FIELD(ID_ISAR0_EL1, CmpBranch, 12, 4)
+    IDREG_FIELD(ID_ISAR0_EL1, BitField, 8, 4)
+    IDREG_FIELD(ID_ISAR0_EL1, BitCount, 4, 4)
+    IDREG_FIELD(ID_ISAR0_EL1, Swap, 0, 4)
+IDREG_END(ID_ISAR0_EL1)
+
+IDREG_START(ID_ISAR1_EL1)
+    IDREG_FIELD(ID_ISAR1_EL1, Jazelle, 28, 4)
+    IDREG_FIELD(ID_ISAR1_EL1, Interwork, 24, 4)
+    IDREG_FIELD(ID_ISAR1_EL1, Immediate, 20, 4)
+    IDREG_FIELD(ID_ISAR1_EL1, IfThen, 16, 4)
+    IDREG_FIELD(ID_ISAR1_EL1, Extend, 12, 4)
+    IDREG_FIELD(ID_ISAR1_EL1, Except_AR, 8, 4)
+    IDREG_FIELD(ID_ISAR1_EL1, Except, 4, 4)
+    IDREG_FIELD(ID_ISAR1_EL1, Endian, 0, 4)
+IDREG_END(ID_ISAR1_EL1)
+
+IDREG_START(ID_ISAR2_EL1)
+    IDREG_FIELD(ID_ISAR2_EL1, Reversal, 28, 4)
+    IDREG_FIELD(ID_ISAR2_EL1, PSR_AR, 24, 4)
+    IDREG_FIELD(ID_ISAR2_EL1, MultU, 20, 4)
+    IDREG_FIELD(ID_ISAR2_EL1, MultS, 16, 4)
+    IDREG_FIELD(ID_ISAR2_EL1, Mult, 12, 4)
+    IDREG_FIELD(ID_ISAR2_EL1, MultiAccessInt, 8, 4)
+    IDREG_FIELD(ID_ISAR2_EL1, MemHint, 4, 4)
+    IDREG_FIELD(ID_ISAR2_EL1, LoadStore, 0, 4)
+IDREG_END(ID_ISAR2_EL1)
+
+IDREG_START(ID_ISAR3_EL1)
+    IDREG_FIELD(ID_ISAR3_EL1, T32EE, 28, 4)
+    IDREG_FIELD(ID_ISAR3_EL1, TrueNOP, 24, 4)
+    IDREG_FIELD(ID_ISAR3_EL1, T32Copy, 20, 4)
+    IDREG_FIELD(ID_ISAR3_EL1, TabBranch, 16, 4)
+    IDREG_FIELD(ID_ISAR3_EL1, SynchPrim, 12, 4)
+    IDREG_FIELD(ID_ISAR3_EL1, SVC, 8, 4)
+    IDREG_FIELD(ID_ISAR3_EL1, SIMD, 4, 4)
+    IDREG_FIELD(ID_ISAR3_EL1, Saturate, 0, 4)
+IDREG_END(ID_ISAR3_EL1)
+
+IDREG_START(ID_ISAR4_EL1)
+    IDREG_FIELD(ID_ISAR4_EL1, SWP_frac, 28, 4)
+    IDREG_FIELD(ID_ISAR4_EL1, PSR_M, 24, 4)
+    IDREG_FIELD(ID_ISAR4_EL1, SynchPrim_frac, 20, 4)
+    IDREG_FIELD(ID_ISAR4_EL1, Barrier, 16, 4)
+    IDREG_FIELD(ID_ISAR4_EL1, SMC, 12, 4)
+    IDREG_FIELD(ID_ISAR4_EL1, Writeback, 8, 4)
+    IDREG_FIELD(ID_ISAR4_EL1, WithShifts, 4, 4)
+    IDREG_FIELD(ID_ISAR4_EL1, Unpriv, 0, 4)
+IDREG_END(ID_ISAR4_EL1)
+
+IDREG_START(ID_ISAR5_EL1)
+    IDREG_FIELD(ID_ISAR5_EL1, VCMA, 28, 4)
+    IDREG_FIELD(ID_ISAR5_EL1, RDM, 24, 4)
+    IDREG_FIELD(ID_ISAR5_EL1, CRC32, 16, 4)
+    IDREG_FIELD(ID_ISAR5_EL1, SHA2, 12, 4)
+    IDREG_FIELD(ID_ISAR5_EL1, SHA1, 8, 4)
+    IDREG_FIELD(ID_ISAR5_EL1, AES, 4, 4)
+    IDREG_FIELD(ID_ISAR5_EL1, SEVL, 0, 4)
+IDREG_END(ID_ISAR5_EL1)
+
+IDREG_START(ID_ISAR6_EL1)
+    IDREG_FIELD(ID_ISAR6_EL1, CLRBHB, 28, 4)
+    IDREG_FIELD(ID_ISAR6_EL1, I8MM, 24, 4)
+    IDREG_FIELD(ID_ISAR6_EL1, BF16, 20, 4)
+    IDREG_FIELD(ID_ISAR6_EL1, SPECRES, 16, 4)
+    IDREG_FIELD(ID_ISAR6_EL1, SB, 12, 4)
+    IDREG_FIELD(ID_ISAR6_EL1, FHM, 8, 4)
+    IDREG_FIELD(ID_ISAR6_EL1, DP, 4, 4)
+    IDREG_FIELD(ID_ISAR6_EL1, JSCVT, 0, 4)
+IDREG_END(ID_ISAR6_EL1)
+
+IDREG_START(ID_MMFR0_EL1)
+    IDREG_FIELD(ID_MMFR0_EL1, InnerShr, 28, 4)
+    IDREG_FIELD(ID_MMFR0_EL1, FCSE, 24, 4)
+    IDREG_FIELD(ID_MMFR0_EL1, AuxReg, 20, 4)
+    IDREG_FIELD(ID_MMFR0_EL1, TCM, 16, 4)
+    IDREG_FIELD(ID_MMFR0_EL1, ShareLvl, 12, 4)
+    IDREG_FIELD(ID_MMFR0_EL1, OuterShr, 8, 4)
+    IDREG_FIELD(ID_MMFR0_EL1, PMSA, 4, 4)
+    IDREG_FIELD(ID_MMFR0_EL1, VMSA, 0, 4)
+IDREG_END(ID_MMFR0_EL1)
+
+IDREG_START(ID_MMFR1_EL1)
+    IDREG_FIELD(ID_MMFR1_EL1, BPred, 28, 4)
+    IDREG_FIELD(ID_MMFR1_EL1, L1TstCln, 24, 4)
+    IDREG_FIELD(ID_MMFR1_EL1, L1Uni, 20, 4)
+    IDREG_FIELD(ID_MMFR1_EL1, L1Hvd, 16, 4)
+    IDREG_FIELD(ID_MMFR1_EL1, L1UniSW, 12, 4)
+    IDREG_FIELD(ID_MMFR1_EL1, L1HvdSW, 8, 4)
+    IDREG_FIELD(ID_MMFR1_EL1, L1UniVA, 4, 4)
+    IDREG_FIELD(ID_MMFR1_EL1, L1HvdVA, 0, 4)
+IDREG_END(ID_MMFR1_EL1)
+
+IDREG_START(ID_MMFR2_EL1)
+    IDREG_FIELD(ID_MMFR2_EL1, HWAccFlg, 28, 4)
+    IDREG_FIELD(ID_MMFR2_EL1, WFIStall, 24, 4)
+    IDREG_FIELD(ID_MMFR2_EL1, MemBarr, 20, 4)
+    IDREG_FIELD(ID_MMFR2_EL1, UniTLB, 16, 4)
+    IDREG_FIELD(ID_MMFR2_EL1, HvdTLB, 12, 4)
+    IDREG_FIELD(ID_MMFR2_EL1, L1HvdRng, 8, 4)
+    IDREG_FIELD(ID_MMFR2_EL1, L1HvdBG, 4, 4)
+    IDREG_FIELD(ID_MMFR2_EL1, L1HvdFG, 0, 4)
+IDREG_END(ID_MMFR2_EL1)
+
+IDREG_START(ID_MMFR3_EL1)
+    IDREG_FIELD(ID_MMFR3_EL1, Supersec, 28, 4)
+    IDREG_FIELD(ID_MMFR3_EL1, CMemSz, 24, 4)
+    IDREG_FIELD(ID_MMFR3_EL1, CohWalk, 20, 4)
+    IDREG_FIELD(ID_MMFR3_EL1, PAN, 16, 4)
+    IDREG_FIELD(ID_MMFR3_EL1, MaintBcst, 12, 4)
+    IDREG_FIELD(ID_MMFR3_EL1, BPMaint, 8, 4)
+    IDREG_FIELD(ID_MMFR3_EL1, CMaintSW, 4, 4)
+    IDREG_FIELD(ID_MMFR3_EL1, CMaintVA, 0, 4)
+IDREG_END(ID_MMFR3_EL1)
+
+IDREG_START(ID_MMFR4_EL1)
+    IDREG_FIELD(ID_MMFR4_EL1, EVT, 28, 4)
+    IDREG_FIELD(ID_MMFR4_EL1, CCIDX, 24, 4)
+    IDREG_FIELD(ID_MMFR4_EL1, LSM, 20, 4)
+    IDREG_FIELD(ID_MMFR4_EL1, HPDS, 16, 4)
+    IDREG_FIELD(ID_MMFR4_EL1, CnP, 12, 4)
+    IDREG_FIELD(ID_MMFR4_EL1, XNX, 8, 4)
+    IDREG_FIELD(ID_MMFR4_EL1, AC2, 4, 4)
+    IDREG_FIELD(ID_MMFR4_EL1, SpecSEI, 0, 4)
+IDREG_END(ID_MMFR4_EL1)
+
+IDREG_START(ID_MMFR5_EL1)
+    IDREG_FIELD(ID_MMFR5_EL1, nTLBPA, 4, 4)
+    IDREG_FIELD(ID_MMFR5_EL1, ETS, 0, 4)
+IDREG_END(ID_MMFR5_EL1)
+
+IDREG_START(ID_PFR0_EL1)
+    IDREG_FIELD(ID_PFR0_EL1, RAS, 28, 4)
+    IDREG_FIELD(ID_PFR0_EL1, DIT, 24, 4)
+    IDREG_FIELD(ID_PFR0_EL1, AMU, 20, 4)
+    IDREG_FIELD(ID_PFR0_EL1, CSV2, 16, 4)
+    IDREG_FIELD(ID_PFR0_EL1, State3, 12, 4)
+    IDREG_FIELD(ID_PFR0_EL1, State2, 8, 4)
+    IDREG_FIELD(ID_PFR0_EL1, State1, 4, 4)
+    IDREG_FIELD(ID_PFR0_EL1, State0, 0, 4)
+IDREG_END(ID_PFR0_EL1)
+
+IDREG_START(ID_PFR1_EL1)
+    IDREG_FIELD(ID_PFR1_EL1, GIC, 28, 4)
+    IDREG_FIELD(ID_PFR1_EL1, Virt_frac, 24, 4)
+    IDREG_FIELD(ID_PFR1_EL1, Sec_frac, 20, 4)
+    IDREG_FIELD(ID_PFR1_EL1, GenTimer, 16, 4)
+    IDREG_FIELD(ID_PFR1_EL1, Virtualization, 12, 4)
+    IDREG_FIELD(ID_PFR1_EL1, MProgMod, 8, 4)
+    IDREG_FIELD(ID_PFR1_EL1, Security, 4, 4)
+    IDREG_FIELD(ID_PFR1_EL1, ProgMod, 0, 4)
+IDREG_END(ID_PFR1_EL1)
+
+IDREG_START(ID_PFR2_EL1)
+    IDREG_FIELD(ID_PFR2_EL1, RAS_frac, 8, 4)
+    IDREG_FIELD(ID_PFR2_EL1, SSBS, 4, 4)
+    IDREG_FIELD(ID_PFR2_EL1, CSV3, 0, 4)
+IDREG_END(ID_PFR2_EL1)
+
+IDREG_START(MIDR_EL1)
+    IDREG_FIELD(MIDR_EL1, Implementer, 24, 8)
+    IDREG_FIELD(MIDR_EL1, Variant, 20, 4)
+    IDREG_FIELD(MIDR_EL1, Architecture, 16, 4)
+    IDREG_FIELD(MIDR_EL1, PartNum, 4, 12)
+    IDREG_FIELD(MIDR_EL1, Revision, 0, 4)
+IDREG_END(MIDR_EL1)
+
+IDREG_START(MPIDR_EL1)
+    IDREG_FIELD(MPIDR_EL1, Aff3, 32, 8)
+    IDREG_FIELD(MPIDR_EL1, U, 30, 1)
+    IDREG_FIELD(MPIDR_EL1, MT, 24, 1)
+    IDREG_FIELD(MPIDR_EL1, Aff2, 16, 8)
+    IDREG_FIELD(MPIDR_EL1, Aff1, 8, 8)
+    IDREG_FIELD(MPIDR_EL1, Aff0, 0, 8)
+IDREG_END(MPIDR_EL1)
+
+IDREG_START(MVFR0_EL1)
+    IDREG_FIELD(MVFR0_EL1, FPRound, 28, 4)
+    IDREG_FIELD(MVFR0_EL1, FPShVec, 24, 4)
+    IDREG_FIELD(MVFR0_EL1, FPSqrt, 20, 4)
+    IDREG_FIELD(MVFR0_EL1, FPDivide, 16, 4)
+    IDREG_FIELD(MVFR0_EL1, FPTrap, 12, 4)
+    IDREG_FIELD(MVFR0_EL1, FPDP, 8, 4)
+    IDREG_FIELD(MVFR0_EL1, FPSP, 4, 4)
+    IDREG_FIELD(MVFR0_EL1, SIMDReg, 0, 4)
+IDREG_END(MVFR0_EL1)
+
+IDREG_START(MVFR1_EL1)
+    IDREG_FIELD(MVFR1_EL1, SIMDFMAC, 28, 4)
+    IDREG_FIELD(MVFR1_EL1, FPHP, 24, 4)
+    IDREG_FIELD(MVFR1_EL1, SIMDHP, 20, 4)
+    IDREG_FIELD(MVFR1_EL1, SIMDSP, 16, 4)
+    IDREG_FIELD(MVFR1_EL1, SIMDInt, 12, 4)
+    IDREG_FIELD(MVFR1_EL1, SIMDLS, 8, 4)
+    IDREG_FIELD(MVFR1_EL1, FPDNaN, 4, 4)
+    IDREG_FIELD(MVFR1_EL1, FPFtZ, 0, 4)
+IDREG_END(MVFR1_EL1)
+
+IDREG_START(MVFR2_EL1)
+    IDREG_FIELD(MVFR2_EL1, FPMisc, 4, 4)
+    IDREG_FIELD(MVFR2_EL1, SIMDMisc, 0, 4)
+IDREG_END(MVFR2_EL1)
+
+IDREG_START(REVIDR_EL1)
+IDREG_END(REVIDR_EL1)
+
+IDREG_START(SMIDR_EL1)
+    IDREG_FIELD(SMIDR_EL1, NSMC, 56, 4)
+    IDREG_FIELD(SMIDR_EL1, HIP, 52, 4)
+    IDREG_FIELD(SMIDR_EL1, Affinity2, 32, 20)
+    IDREG_FIELD(SMIDR_EL1, Implementer, 24, 8)
+    IDREG_FIELD(SMIDR_EL1, Revision, 16, 8)
+    IDREG_FIELD(SMIDR_EL1, SMPS, 15, 1)
+    IDREG_FIELD(SMIDR_EL1, SH, 13, 2)
+    IDREG_FIELD(SMIDR_EL1, Affinity, 0, 12)
+IDREG_END(SMIDR_EL1)
+
diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
new file mode 100644
index 0000000000..436e36ef58
--- /dev/null
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -0,0 +1,165 @@
+#!/usr/bin/env python3
+
+# This script takes as input the Registers.json file delivered in
+# the AARCHMRS Features Model downloadable from the Arm Developer
+# A-Profile Architecture Exploration Tools page:
+# https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
+# and outputs target/arm/cpu-idregs.h.inc content.
+# ID regs are defined using this pattern:
+#
+# IDREG_START(REG)
+#    IDREG_FIELD(REG, FIELD, SHIFT, LENGTH)
+# ...
+# IDREG_END(REG)
+#
+# Copyright (C) 2026 Red Hat, Inc.
+#
+# Authors: Eric Auger <eric.auger@redhat.com>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+
+import json
+import os
+import sys
+from aarch64_sysreg_helpers import extract_idregs_from_registers_json
+
+# look for all the fields belonging to a register fieldset
+# this is a recursive parser where bit_offset is used to convey
+# bit positions from the parent container if any
+def collect_fields(fieldset, bit_offset=0):
+    fields = []
+    if not isinstance(fieldset, dict):
+        return fields
+
+    _type = fieldset.get('_type', '')
+
+    # Leaf array type (for example CLIDR_EL1 Ctype<n>, Ttype<n>)
+    if _type == 'Fields.Array':
+        name_template = fieldset.get('name') or fieldset.get('label', '')
+        index_info = fieldset.get('indexes', [{}])[0]
+        start_idx = index_info.get('start', 0)
+        count = index_info.get('width', 0)
+
+        full_range = fieldset.get('rangeset', [{}])[0]
+        bit_start = full_range.get('start', 0) + bit_offset
+        elem_width = full_range.get('width', 0) // count if count else 0
+
+        for i in range(count):
+            idx = start_idx + i
+            # Append the actual index to the field by replacing <n>
+            field_name = name_template.replace('<n>', str(idx))
+            fields.append({
+                'name': field_name,
+                'rangeset': [{
+                    'start': bit_start + (i * elem_width),
+                    'width': elem_width
+                }],
+                '_type': 'Fields.Field'
+            })
+        return fields
+
+    # Conditional field which depend on specific FEAT_*
+    # like ID_AA64ZFR0_EL1_SVEver or ID_AA64MMFR4_EL1_E2H0
+    elif _type == 'Fields.ConditionalField':
+        container_bit_offset = bit_offset
+        if fieldset.get('rangeset'):
+            # Parent container defines the absolute start bit
+            container_bit_offset = fieldset['rangeset'][0].get('start', bit_offset)
+
+        for entry in fieldset.get('fields', []):
+            inner = entry.get('field')
+            if inner:
+                fields.extend(collect_fields(inner, container_bit_offset))
+        return fields
+
+    # Field Types
+    leaf_types = ['Fields.Field', 'Fields.ConstantField',
+                  'Fields.EnumeratedField', 'Fields.Bitfield']
+    if _type in leaf_types:
+        field_copy = fieldset.copy()
+        if field_copy.get('rangeset'):
+            new_ranges = []
+            for r in field_copy['rangeset']:
+                nr = r.copy()
+                nr['start'] = r.get('start', 0) + bit_offset
+                new_ranges.append(nr)
+            field_copy['rangeset'] = new_ranges
+        fields.append(field_copy)
+        return fields
+
+    # Traverse the hierarchy for other cases
+    for key in ['fields', 'values', 'fieldsets']:
+        for nested in fieldset.get(key, []):
+            fields.extend(collect_fields(nested, bit_offset))
+
+    return fields
+
+def generate_sysreg_properties_from_registers_json(idregs, raw_json_path):
+    with open(raw_json_path, 'r') as f:
+        register_data = json.load(f)
+
+    regs = {r.get('name'): r for r in register_data if r.get('_type') == 'Register'}
+
+    final_output = ""
+
+    for reg_name in idregs:
+        register = regs.get(reg_name)
+        if not register:
+            print(f"Error: Inconsistency when analyzing registers!", file=sys.stderr)
+            sys.exit(1)
+
+        final_output += f"IDREG_START({reg_name})\n"
+
+        unique_fields = {}
+        for fieldset in register.get('fieldsets', []):
+            candidates = collect_fields(fieldset)
+            for val in candidates:
+                name = (val.get('name') or val.get('label', '')).strip()
+                if not name or "RESERVED" in name.upper():
+                    continue
+                for r in val.get('rangeset', []):
+                    lsb = int(r.get('start'))
+                    width = r.get('width')
+                    msb = lsb + int(width) - 1
+
+                    # In json, some idregs may have multiple fielsets, depending
+                    # on some architecture configurations. If this happens, pick
+                    # up a single one with the largest msb (known one is CCSIDR
+                    # which is currently skipped)
+                    if name not in unique_fields or msb > unique_fields[name]['msb']:
+                       unique_fields[name] = {'lsb': lsb, 'msb': msb, 'width': width}
+
+        # Sort by decreasing lsbs
+        sorted_fields = sorted(unique_fields.items(),
+                               key=lambda x: x[1]['lsb'], reverse=True)
+
+        for name, bits in sorted_fields:
+            line = (f"    IDREG_FIELD({reg_name}, "
+                    f"{name}, {bits['lsb']}, {bits['width']})\n")
+            final_output += line
+        final_output += f"IDREG_END({reg_name})\n"
+        final_output += "\n"
+
+    os.makedirs("target/arm", exist_ok=True)
+    with open("target/arm/cpu-idregs.h.inc", 'w') as f:
+        f.write("/* AUTOMATICALLY GENERATED, DO NOT MODIFY */\n\n")
+        f.write("/* SPDX-License-Identifier: GPL-2.0-or-later */\n\n")
+        f.write("/* IDREG_START(REG) */\n")
+        f.write("/*     IDREG_FIELD(REG, FIELD, SHIFT, LENGTH) */\n")
+        f.write("/* ... */\n")
+        f.write("/* IDREG_END(REG) */\n\n")
+        f.write(final_output)
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print("Usage: python scripts/update-aarch64-cpu-sysreg-properties.py "
+              "<path_to_registers_json>")
+    else:
+        json_path = sys.argv[1]
+
+        idregs = extract_idregs_from_registers_json(json_path)
+
+        if idregs:
+            generate_sysreg_properties_from_registers_json(idregs, json_path)
+            print("Generated target/arm/cpu-idregs.h.inc")
-- 
2.53.0

