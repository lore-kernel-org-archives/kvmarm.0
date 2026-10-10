Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CA53DD849
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639503; cv=none; b=JxmwshCfV3eLhWNzmYQVrebEuBj+BNzvh36tHzgc4XiNcA7ZfvPtXODimZ3fb6Y2yjmtiKXIH39XT/YXV12DTL6hj1DLD/dwCn3gOc7sSI+61KtQ8cDVbdsH5AlChFoUbY4dQbljbN90JbyF1xZUXXpApNULOwTAkRQ+WrWnDek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639503; c=relaxed/simple;
	bh=cCU7sgHDAnpbJHIPzznLBdjQvAAJHkTuo7ko3dBLwc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=TzoYFdBQY67OCLyue//mfONHrkrkMoC1iaLLihRmqkqr/Awtb460VQe/MxMutk/fi8ZiW5beXHU47Jxkl6vhKWGB2l/EQ6i+H6fEyXP82eY5ceyGQT8BwxheBLzmrDFalVqo3C6iOVCOxnvMY7yUa2cND6hEcbK6xNlVqqUiv8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uxbbghdp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uxbbghdp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCS2297zz90dKq9kmo+5S/qHDOXKjEj1vLBEZvlvhDk=;
	b=UxbbghdpVdfw1P8mK34RoXCYMTQWesM5Ap73NOSaugZER3ZQHFglI3PK8P01hSp1pQF3ZP
	X8S9Q9Gk1xJkz5cWNAHI3/gorLqmdsj+Pl7tq0JBvgyoBPMSgzCjWm5hU7IL3S7hiJQNx/
	9vzfl4Emd0BJmHf2+IxCRtbeGCxXv4I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-75-DqpaUcTjN6KZcDgK0Aw1YQ-1; Sat,
 10 Oct 2026 13:38:17 +0000
X-MC-Unique: DqpaUcTjN6KZcDgK0Aw1YQ-1
X-Mimecast-MFC-AGG-ID: DqpaUcTjN6KZcDgK0Aw1YQ_1791639495
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31A301801321;
	Sat, 10 Oct 2026 13:38:15 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C022A30000E5;
	Sat, 10 Oct 2026 13:38:10 +0000 (UTC)
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
Subject: [PATCH v10 08/26] target/arm/cpu-idregs.h.inc: Generate reserved fields
Date: Sat, 10 Oct 2026 15:36:12 +0200
Message-ID: <20261010133725.642498-9-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 7FiOf0R_LFbGD_MvxKsAfn-JdLslddI920kUcBzLKqg_1791639495
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Extract reserved fields: RES0, RES1, RAZ, ...

The extra complexity comes from the fact several reserved
fields may exist in the register, as opposed to named fields.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v7 -> v8:
- fix WithShifts issue
---
 target/arm/cpu-idregs.h.inc                   | 65 ++++++++++++++
 .../update-aarch64-cpu-sysreg-properties.py   | 85 +++++++++++++++----
 2 files changed, 134 insertions(+), 16 deletions(-)

diff --git a/target/arm/cpu-idregs.h.inc b/target/arm/cpu-idregs.h.inc
index be3540d41b..b9beda484b 100644
--- a/target/arm/cpu-idregs.h.inc
+++ b/target/arm/cpu-idregs.h.inc
@@ -13,16 +13,20 @@ IDREG_START(AIDR_EL1)
 IDREG_END(AIDR_EL1)
 
 IDREG_START(CCSIDR2_EL1)
+    IDREG_FIELD(CCSIDR2_EL1, RES0, 24, 40)
     IDREG_FIELD(CCSIDR2_EL1, NumSets, 0, 24)
 IDREG_END(CCSIDR2_EL1)
 
 IDREG_START(CCSIDR_EL1)
+    IDREG_FIELD(CCSIDR_EL1, RES0, 56, 8)
     IDREG_FIELD(CCSIDR_EL1, NumSets, 32, 24)
+    IDREG_FIELD(CCSIDR_EL1, RES0, 24, 8)
     IDREG_FIELD(CCSIDR_EL1, Associativity, 3, 21)
     IDREG_FIELD(CCSIDR_EL1, LineSize, 0, 3)
 IDREG_END(CCSIDR_EL1)
 
 IDREG_START(CLIDR_EL1)
+    IDREG_FIELD(CLIDR_EL1, RES0, 47, 17)
     IDREG_FIELD(CLIDR_EL1, Ttype7, 45, 2)
     IDREG_FIELD(CLIDR_EL1, Ttype6, 43, 2)
     IDREG_FIELD(CLIDR_EL1, Ttype5, 41, 2)
@@ -46,7 +50,10 @@ IDREG_START(CLIDR_EL1)
 IDREG_END(CLIDR_EL1)
 
 IDREG_START(CTR_EL0)
+    IDREG_FIELD(CTR_EL0, RES0, 38, 26)
     IDREG_FIELD(CTR_EL0, TminLine, 32, 6)
+    IDREG_FIELD(CTR_EL0, RES1, 31, 1)
+    IDREG_FIELD(CTR_EL0, RES0, 30, 1)
     IDREG_FIELD_ENUM(CTR_EL0, DIC, 29, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -59,10 +66,12 @@ IDREG_START(CTR_EL0)
     IDREG_FIELD_ENUM(CTR_EL0, L1Ip, 14, 2,
                  IDREG_ARCH_VALUE_RANGE(0, 3)
     )
+    IDREG_FIELD(CTR_EL0, RES0, 4, 10)
     IDREG_FIELD(CTR_EL0, IminLine, 0, 4)
 IDREG_END(CTR_EL0)
 
 IDREG_START(DCZID_EL0)
+    IDREG_FIELD(DCZID_EL0, RES0, 9, 55)
     IDREG_FIELD(DCZID_EL0, TBS, 5, 4)
     IDREG_FIELD_ENUM(DCZID_EL0, DZP, 4, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
@@ -71,13 +80,16 @@ IDREG_START(DCZID_EL0)
 IDREG_END(DCZID_EL0)
 
 IDREG_START(GMID_EL1)
+    IDREG_FIELD(GMID_EL1, RES0, 4, 60)
     IDREG_FIELD(GMID_EL1, BS, 0, 4)
 IDREG_END(GMID_EL1)
 
 IDREG_START(ID_AA64AFR0_EL1)
+    IDREG_FIELD(ID_AA64AFR0_EL1, RES0, 32, 32)
 IDREG_END(ID_AA64AFR0_EL1)
 
 IDREG_START(ID_AA64AFR1_EL1)
+    IDREG_FIELD(ID_AA64AFR1_EL1, RES0, 0, 64)
 IDREG_END(ID_AA64AFR1_EL1)
 
 IDREG_START(ID_AA64DFR0_EL1)
@@ -110,6 +122,7 @@ IDREG_START(ID_AA64DFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64DFR0_EL1, CTX_CMPs, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 15)
     )
+    IDREG_FIELD(ID_AA64DFR0_EL1, RES0, 24, 4)
     IDREG_FIELD_ENUM(ID_AA64DFR0_EL1, WRPs, 20, 4,
                  IDREG_ARCH_VALUE_RANGE(1, 15)
     )
@@ -169,6 +182,7 @@ IDREG_START(ID_AA64DFR1_EL1)
 IDREG_END(ID_AA64DFR1_EL1)
 
 IDREG_START(ID_AA64DFR2_EL1)
+    IDREG_FIELD(ID_AA64DFR2_EL1, RES0, 28, 36)
     IDREG_FIELD_ENUM(ID_AA64DFR2_EL1, TRBE_EXC, 24, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -178,6 +192,7 @@ IDREG_START(ID_AA64DFR2_EL1)
     IDREG_FIELD_ENUM(ID_AA64DFR2_EL1, SPE_EXC, 16, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64DFR2_EL1, RES0, 8, 8)
     IDREG_FIELD_ENUM(ID_AA64DFR2_EL1, BWE, 4, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 2)
     )
@@ -187,6 +202,7 @@ IDREG_START(ID_AA64DFR2_EL1)
 IDREG_END(ID_AA64DFR2_EL1)
 
 IDREG_START(ID_AA64FPFR0_EL1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_AA64FPFR0_EL1, F8CVT, 31, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -205,9 +221,12 @@ IDREG_START(ID_AA64FPFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64FPFR0_EL1, F8MM4, 26, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 16, 10)
     IDREG_FIELD_ENUM(ID_AA64FPFR0_EL1, F16MM2, 15, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 8, 7)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RAZ, 2, 6)
     IDREG_FIELD_ENUM(ID_AA64FPFR0_EL1, F8E4M3, 1, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -244,6 +263,7 @@ IDREG_START(ID_AA64ISAR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64ISAR0_EL1, RDM, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64ISAR0_EL1, RES0, 24, 4)
     IDREG_FIELD_ENUM(ID_AA64ISAR0_EL1, Atomic, 20, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 0),
                  IDREG_ARCH_VALUE_RANGE(2, 3)
@@ -260,6 +280,7 @@ IDREG_START(ID_AA64ISAR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64ISAR0_EL1, AES, 4, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 2)
     )
+    IDREG_FIELD(ID_AA64ISAR0_EL1, RES0, 0, 4)
 IDREG_END(ID_AA64ISAR0_EL1)
 
 IDREG_START(ID_AA64ISAR1_EL1)
@@ -366,6 +387,7 @@ IDREG_START(ID_AA64ISAR2_EL1)
 IDREG_END(ID_AA64ISAR2_EL1)
 
 IDREG_START(ID_AA64ISAR3_EL1)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, RES0, 48, 16)
     IDREG_FIELD_ENUM(ID_AA64ISAR3_EL1, LSCP, 44, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -411,6 +433,7 @@ IDREG_START(ID_AA64MMFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64MMFR0_EL1, FGT, 56, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 2)
     )
+    IDREG_FIELD(ID_AA64MMFR0_EL1, RES0, 48, 8)
     IDREG_FIELD_ENUM(ID_AA64MMFR0_EL1, ExS, 44, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -517,6 +540,7 @@ IDREG_START(ID_AA64MMFR2_EL1)
     IDREG_FIELD_ENUM(ID_AA64MMFR2_EL1, TTL, 48, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64MMFR2_EL1, RES0, 44, 4)
     IDREG_FIELD_ENUM(ID_AA64MMFR2_EL1, FWB, 40, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -562,6 +586,7 @@ IDREG_START(ID_AA64MMFR3_EL1)
     IDREG_FIELD_ENUM(ID_AA64MMFR3_EL1, SDERR, 52, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 3)
     )
+    IDREG_FIELD(ID_AA64MMFR3_EL1, RES0, 48, 4)
     IDREG_FIELD_ENUM(ID_AA64MMFR3_EL1, ANERR, 44, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 3)
     )
@@ -739,6 +764,7 @@ IDREG_START(ID_AA64PFR1_EL1)
     IDREG_FIELD_ENUM(ID_AA64PFR1_EL1, SME, 24, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 2)
     )
+    IDREG_FIELD(ID_AA64PFR1_EL1, RES0, 20, 4)
     IDREG_FIELD_ENUM(ID_AA64PFR1_EL1, MPAM_frac, 16, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -757,6 +783,7 @@ IDREG_START(ID_AA64PFR1_EL1)
 IDREG_END(ID_AA64PFR1_EL1)
 
 IDREG_START(ID_AA64PFR2_EL1)
+    IDREG_FIELD(ID_AA64PFR2_EL1, RES0, 48, 16)
     IDREG_FIELD_ENUM(ID_AA64PFR2_EL1, VMTETCL, 44, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -799,6 +826,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, FA64, 63, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 62, 1)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, LUT6, 61, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -812,6 +840,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
                  IDREG_ARCH_VALUE_RANGE(0, 0),
                  IDREG_ARCH_VALUE_RANGE(15, 15)
     )
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 49, 3)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, F64F64, 48, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -847,6 +876,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, F32F32, 32, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 31, 1)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, SF8FMA, 30, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -856,6 +886,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, SF8DP2, 28, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 26, 2)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, SBitPerm, 25, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -865,15 +896,18 @@ IDREG_START(ID_AA64SMFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, SFEXPA, 23, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 17, 6)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, STMOP, 16, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 1, 15)
     IDREG_FIELD_ENUM(ID_AA64SMFR0_EL1, SMOP4, 0, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
 IDREG_END(ID_AA64SMFR0_EL1)
 
 IDREG_START(ID_AA64ZFR0_EL1)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 60, 4)
     IDREG_FIELD_ENUM(ID_AA64ZFR0_EL1, F64MM, 56, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -889,9 +923,11 @@ IDREG_START(ID_AA64ZFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64ZFR0_EL1, SM4, 40, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 36, 4)
     IDREG_FIELD_ENUM(ID_AA64ZFR0_EL1, SHA3, 32, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 28, 4)
     IDREG_FIELD_ENUM(ID_AA64ZFR0_EL1, B16B16, 24, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 3)
     )
@@ -904,6 +940,7 @@ IDREG_START(ID_AA64ZFR0_EL1)
     IDREG_FIELD_ENUM(ID_AA64ZFR0_EL1, EltPerm, 12, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 8, 4)
     IDREG_FIELD_ENUM(ID_AA64ZFR0_EL1, AES, 4, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 3)
     )
@@ -913,9 +950,11 @@ IDREG_START(ID_AA64ZFR0_EL1)
 IDREG_END(ID_AA64ZFR0_EL1)
 
 IDREG_START(ID_AFR0_EL1)
+    IDREG_FIELD(ID_AFR0_EL1, RES0, 0, 64)
 IDREG_END(ID_AFR0_EL1)
 
 IDREG_START(ID_DFR0_EL1)
+    IDREG_FIELD(ID_DFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_DFR0_EL1, TraceFilt, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -944,6 +983,7 @@ IDREG_START(ID_DFR0_EL1)
 IDREG_END(ID_DFR0_EL1)
 
 IDREG_START(ID_DFR1_EL1)
+    IDREG_FIELD(ID_DFR1_EL1, RES0, 8, 56)
     IDREG_FIELD_ENUM(ID_DFR1_EL1, HPMN0, 4, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -954,6 +994,7 @@ IDREG_START(ID_DFR1_EL1)
 IDREG_END(ID_DFR1_EL1)
 
 IDREG_START(ID_ISAR0_EL1)
+    IDREG_FIELD(ID_ISAR0_EL1, RES0, 28, 36)
     IDREG_FIELD_ENUM(ID_ISAR0_EL1, Divide, 24, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 2)
     )
@@ -978,6 +1019,7 @@ IDREG_START(ID_ISAR0_EL1)
 IDREG_END(ID_ISAR0_EL1)
 
 IDREG_START(ID_ISAR1_EL1)
+    IDREG_FIELD(ID_ISAR1_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_ISAR1_EL1, Jazelle, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1005,6 +1047,7 @@ IDREG_START(ID_ISAR1_EL1)
 IDREG_END(ID_ISAR1_EL1)
 
 IDREG_START(ID_ISAR2_EL1)
+    IDREG_FIELD(ID_ISAR2_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_ISAR2_EL1, Reversal, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 2)
     )
@@ -1032,6 +1075,7 @@ IDREG_START(ID_ISAR2_EL1)
 IDREG_END(ID_ISAR2_EL1)
 
 IDREG_START(ID_ISAR3_EL1)
+    IDREG_FIELD(ID_ISAR3_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_ISAR3_EL1, T32EE, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1060,6 +1104,7 @@ IDREG_START(ID_ISAR3_EL1)
 IDREG_END(ID_ISAR3_EL1)
 
 IDREG_START(ID_ISAR4_EL1)
+    IDREG_FIELD(ID_ISAR4_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_ISAR4_EL1, SWP_frac, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1089,12 +1134,14 @@ IDREG_START(ID_ISAR4_EL1)
 IDREG_END(ID_ISAR4_EL1)
 
 IDREG_START(ID_ISAR5_EL1)
+    IDREG_FIELD(ID_ISAR5_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_ISAR5_EL1, VCMA, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
     IDREG_FIELD_ENUM(ID_ISAR5_EL1, RDM, 24, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(ID_ISAR5_EL1, RES0, 20, 4)
     IDREG_FIELD_ENUM(ID_ISAR5_EL1, CRC32, 16, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1113,6 +1160,7 @@ IDREG_START(ID_ISAR5_EL1)
 IDREG_END(ID_ISAR5_EL1)
 
 IDREG_START(ID_ISAR6_EL1)
+    IDREG_FIELD(ID_ISAR6_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_ISAR6_EL1, CLRBHB, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1140,6 +1188,7 @@ IDREG_START(ID_ISAR6_EL1)
 IDREG_END(ID_ISAR6_EL1)
 
 IDREG_START(ID_MMFR0_EL1)
+    IDREG_FIELD(ID_MMFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_MMFR0_EL1, InnerShr, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1),
                  IDREG_ARCH_VALUE_RANGE(15, 15)
@@ -1169,6 +1218,7 @@ IDREG_START(ID_MMFR0_EL1)
 IDREG_END(ID_MMFR0_EL1)
 
 IDREG_START(ID_MMFR1_EL1)
+    IDREG_FIELD(ID_MMFR1_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_MMFR1_EL1, BPred, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 4)
     )
@@ -1196,6 +1246,7 @@ IDREG_START(ID_MMFR1_EL1)
 IDREG_END(ID_MMFR1_EL1)
 
 IDREG_START(ID_MMFR2_EL1)
+    IDREG_FIELD(ID_MMFR2_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_MMFR2_EL1, HWAccFlg, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1221,6 +1272,7 @@ IDREG_START(ID_MMFR2_EL1)
 IDREG_END(ID_MMFR2_EL1)
 
 IDREG_START(ID_MMFR3_EL1)
+    IDREG_FIELD(ID_MMFR3_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_MMFR3_EL1, Supersec, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 0),
                  IDREG_ARCH_VALUE_RANGE(15, 15)
@@ -1249,6 +1301,7 @@ IDREG_START(ID_MMFR3_EL1)
 IDREG_END(ID_MMFR3_EL1)
 
 IDREG_START(ID_MMFR4_EL1)
+    IDREG_FIELD(ID_MMFR4_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_MMFR4_EL1, EVT, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 2)
     )
@@ -1276,6 +1329,7 @@ IDREG_START(ID_MMFR4_EL1)
 IDREG_END(ID_MMFR4_EL1)
 
 IDREG_START(ID_MMFR5_EL1)
+    IDREG_FIELD(ID_MMFR5_EL1, RES0, 8, 56)
     IDREG_FIELD_ENUM(ID_MMFR5_EL1, nTLBPA, 4, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1285,6 +1339,7 @@ IDREG_START(ID_MMFR5_EL1)
 IDREG_END(ID_MMFR5_EL1)
 
 IDREG_START(ID_PFR0_EL1)
+    IDREG_FIELD(ID_PFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_PFR0_EL1, RAS, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 3)
     )
@@ -1313,6 +1368,7 @@ IDREG_START(ID_PFR0_EL1)
 IDREG_END(ID_PFR0_EL1)
 
 IDREG_START(ID_PFR1_EL1)
+    IDREG_FIELD(ID_PFR1_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(ID_PFR1_EL1, GIC, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1),
                  IDREG_ARCH_VALUE_RANGE(3, 3)
@@ -1342,6 +1398,7 @@ IDREG_START(ID_PFR1_EL1)
 IDREG_END(ID_PFR1_EL1)
 
 IDREG_START(ID_PFR2_EL1)
+    IDREG_FIELD(ID_PFR2_EL1, RES0, 12, 52)
     IDREG_FIELD_ENUM(ID_PFR2_EL1, RAS_frac, 8, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1375,10 +1432,13 @@ IDREG_START(MIDR_EL1)
 IDREG_END(MIDR_EL1)
 
 IDREG_START(MPIDR_EL1)
+    IDREG_FIELD(MPIDR_EL1, RES0, 40, 24)
     IDREG_FIELD(MPIDR_EL1, Aff3, 32, 8)
+    IDREG_FIELD(MPIDR_EL1, RES1, 31, 1)
     IDREG_FIELD_ENUM(MPIDR_EL1, U, 30, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
+    IDREG_FIELD(MPIDR_EL1, RES0, 25, 5)
     IDREG_FIELD_ENUM(MPIDR_EL1, MT, 24, 1,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1388,6 +1448,7 @@ IDREG_START(MPIDR_EL1)
 IDREG_END(MPIDR_EL1)
 
 IDREG_START(MVFR0_EL1)
+    IDREG_FIELD(MVFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(MVFR0_EL1, FPRound, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1415,6 +1476,7 @@ IDREG_START(MVFR0_EL1)
 IDREG_END(MVFR0_EL1)
 
 IDREG_START(MVFR1_EL1)
+    IDREG_FIELD(MVFR1_EL1, RES0, 32, 32)
     IDREG_FIELD_ENUM(MVFR1_EL1, SIMDFMAC, 28, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 1)
     )
@@ -1442,6 +1504,7 @@ IDREG_START(MVFR1_EL1)
 IDREG_END(MVFR1_EL1)
 
 IDREG_START(MVFR2_EL1)
+    IDREG_FIELD(MVFR2_EL1, RES0, 8, 56)
     IDREG_FIELD_ENUM(MVFR2_EL1, FPMisc, 4, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 4)
     )
@@ -1454,6 +1517,7 @@ IDREG_START(REVIDR_EL1)
 IDREG_END(REVIDR_EL1)
 
 IDREG_START(SMIDR_EL1)
+    IDREG_FIELD(SMIDR_EL1, RES0, 60, 4)
     IDREG_FIELD_ENUM(SMIDR_EL1, NSMC, 56, 4,
                  IDREG_ARCH_VALUE_RANGE(0, 15)
     )
@@ -1479,6 +1543,7 @@ IDREG_START(SMIDR_EL1)
     IDREG_FIELD_ENUM(SMIDR_EL1, SH, 13, 2,
                  IDREG_ARCH_VALUE_RANGE(0, 3)
     )
+    IDREG_FIELD(SMIDR_EL1, RES0, 12, 1)
     IDREG_FIELD(SMIDR_EL1, Affinity, 0, 12)
 IDREG_END(SMIDR_EL1)
 
diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
index b4b548a6e2..86a2d2db84 100644
--- a/scripts/update-aarch64-cpu-sysreg-properties.py
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -78,9 +78,13 @@ def collect_fields(fieldset, bit_offset=0):
 
     # Field Types
     leaf_types = ['Fields.Field', 'Fields.ConstantField',
-                  'Fields.EnumeratedField', 'Fields.Bitfield']
+                  'Fields.EnumeratedField', 'Fields.Bitfield', 'Fields.Reserved']
     if _type in leaf_types:
         field_copy = fieldset.copy()
+
+        if _type == 'Fields.Reserved' and not field_copy.get('name'):
+            field_copy['name'] = fieldset.get('value', 'RES0')
+
         if field_copy.get('rangeset'):
             new_ranges = []
             for r in field_copy['rangeset']:
@@ -92,7 +96,7 @@ def collect_fields(fieldset, bit_offset=0):
         return fields
 
     # Traverse the hierarchy for other cases
-    for key in ['fields', 'values', 'fieldsets']:
+    for key in ['fields', 'values', 'fieldsets', 'constants']:
         for nested in fieldset.get(key, []):
             fields.extend(collect_fields(nested, bit_offset))
 
@@ -210,43 +214,92 @@ def generate_sysreg_properties_from_registers_json(idregs, raw_json_path):
 
         final_output += f"IDREG_START({reg_name})\n"
 
-        unique_fields = {}
+        fieldset_variants = []
+
         for fieldset in register.get('fieldsets', []):
+            current_fieldset_fields = {}
             candidates = collect_fields(fieldset)
+
             for val in candidates:
-                name = (val.get('name') or val.get('label', '')).strip()
-                if not name or "RESERVED" in name.upper():
+                # reserved fields may leave the 'name' empty or set to None and use
+                # value or label instead. Last '' garantees we fall back to an empty
+                # string and prevent the next line from cashing
+                raw_name = val.get('name') or val.get('label') or val.get('value') or ''
+                name = raw_name.strip()
+                if not name:
                     continue
+
+                name_upper = name.upper()
+
+                base_reserved = None
+                for r_type in ["RES0", "RES1", "RAZ", "RAO", "WI", "UNKNOWN"]:
+                    if r_type == name_upper:
+                        # Turn UNKNOWN to RES0
+                        base_reserved = "RES0" if r_type == "UNKNOWN" else r_type
+                        break
+
+                if base_reserved:
+                    name = base_reserved
+                elif "RESERVED" in name_upper:
+                    continue
+
                 for r in val.get('rangeset', []):
                     lsb = int(r.get('start'))
                     width = r.get('width')
                     msb = lsb + int(width) - 1
 
-                    # In json, some idregs may have multiple fielsets, depending
-                    # on some architecture configurations. If this happens, pick
-                    # up a single one with the largest msb (known one is CCSIDR
-                    # which is currently skipped)
-                    if name not in unique_fields or msb > unique_fields[name]['msb']:
-                        # extract enum values if any
+                    if base_reserved:
+                        # reserved fields have same name so append their lsb
+                        # to prevent fields from overriding each other
+                        unique_key = f"{name}_{lsb}"
+                    else:
+                        unique_key = name
+
+                    # within the same fieldset we can have fields with the
+                    # same name and different msbs. Keep the largest.
+                    if unique_key not in current_fieldset_fields or \
+                       msb > current_fieldset_fields[unique_key]['msb']:
                         enums = extract_field_enums(val)
-                        unique_fields[name] = \
-                            {'lsb': lsb, 'msb': msb, 'width': width, 'enums': enums}
+                        current_fieldset_fields[unique_key] = {
+                            'raw_name': name,
+                            'lsb': lsb,
+                            'msb': msb,
+                            'width': width,
+                            'enums': enums
+                        }
+
+            if current_fieldset_fields:
+                fieldset_variants.append(current_fieldset_fields)
+
+        best_fieldset = {}
+        max_total_width = -1
+
+        # among several variants of a fieldset keep the largest one
+        for variant in fieldset_variants:
+            total_width = sum(f['width'] for f in variant.values())
+
+            if total_width > max_total_width:
+                max_total_width = total_width
+                best_fieldset = variant
+
+        unique_fields = best_fieldset
 
         # Sort by decreasing lsbs
         sorted_fields = sorted(unique_fields.items(),
                                key=lambda x: x[1]['lsb'], reverse=True)
 
-        for name, bits in sorted_fields:
+        for unique_key, bits in sorted_fields:
             enums_list = bits.get('enums', [])
+            clean_name = bits.get('raw_name', unique_key)
 
             if enums_list:
                 final_output += format_field_enum(
-                    reg_name, name, bits['lsb'], bits['width'],
+                    reg_name, clean_name, bits['lsb'], bits['width'],
                     merge_enum_ranges(enums_list))
             else:
                 final_output += (
                     f"    IDREG_FIELD({reg_name}, "
-                    f"{name}, {bits['lsb']}, {bits['width']})\n"
+                    f"{clean_name}, {bits['lsb']}, {bits['width']})\n"
                 )
 
         final_output += f"IDREG_END({reg_name})\n"
-- 
2.53.0

