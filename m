Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E34C175A99
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570161; cv=none; b=AggJvpj0BlsNtdgpTMhejGgdwJCunLN4o+RLJsptO0hCuqPCxm0mwXqt7VRcUSc2ai4x+AsWkMjsRafIiOlDt5wIItcuyQ5rsIHJyd0ctFlICe3We5bIn8nURl3JttRufZDExSjz8VSG+BKkyhUI1a8CQ4b9lw6cTKHnNT2YvUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570161; c=relaxed/simple;
	bh=UpKdNRoWIx2dkyyWjqXq157/ea3BOgMQHASM6cjnfa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DOvTLyrwoalzqurlw/gyXnEKnZlTaypeSzYNXiEfW0Z3Z20ETj7eciBsJdgGg8r1cXOIPSHwp8uYzB4hiPDhsq0eOY7ACkv6JkGUHv3p18SPncIWdNvYcYxTk5h7PeUizXzrLTMEChTWusyDO5eb6Kd2vJI3YtlNPPfKNi30sdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S0iIwRTh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S0iIwRTh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8lbJTdftQ32/6ElYZVmkeNO/8uGOKiFYhP6lbO4BtAo=;
	b=S0iIwRTh7kFfHNs6AVLAyvvl3ifiIjzXprd5H17dNw7jB4dYaT88Gcv6oZQCfGcX4G3uKB
	2lem8j5YJmZYIsspDkTMvX0yx6GEFoOkgjt01XhiL0cL5+NrMTPOXZhh/KA5ZaI2nX2RzA
	YJL2h4/Y5Lx0Lx8k/nsrUguqIg/YqUA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-opRl-U47OUe-pAId5k2yAQ-1; Wed,
 16 Sep 2026 10:49:14 -0400
X-MC-Unique: opRl-U47OUe-pAId5k2yAQ-1
X-Mimecast-MFC-AGG-ID: opRl-U47OUe-pAId5k2yAQ_1789570152
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 036981800655;
	Wed, 16 Sep 2026 14:49:12 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8003C19560AB;
	Wed, 16 Sep 2026 14:49:06 +0000 (UTC)
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
Subject: [PATCH v9 19/26] target/arm/cpu-idregs.h.inc: Generate reserved fields
Date: Wed, 16 Sep 2026 16:45:42 +0200
Message-ID: <20260916144721.751810-20-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: lltbrYCM93GDgyPGaE5og58FCLsZoYfWRi7Sq8wC_R4_1789570152
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Extract reserved fields: RES0, RES1, RAZ, ...

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v7 -> v8:
- fix WithShifts issue
---
 target/arm/cpu-idregs.h.inc                   | 62 ++++++++++++++
 .../update-aarch64-cpu-sysreg-properties.py   | 83 +++++++++++++++----
 2 files changed, 131 insertions(+), 14 deletions(-)

diff --git a/target/arm/cpu-idregs.h.inc b/target/arm/cpu-idregs.h.inc
index 10ddfdf43a..c7e93c48b7 100644
--- a/target/arm/cpu-idregs.h.inc
+++ b/target/arm/cpu-idregs.h.inc
@@ -15,6 +15,7 @@ IDREG_START(AIDR_EL1)
 IDREG_END(AIDR_EL1)
 
 IDREG_START(CLIDR_EL1)
+    IDREG_FIELD(CLIDR_EL1, RES0, 47, 17)
     IDREG_FIELD(CLIDR_EL1, Ttype7, 45, 2)
     IDREG_FIELD(CLIDR_EL1, Ttype6, 43, 2)
     IDREG_FIELD(CLIDR_EL1, Ttype5, 41, 2)
@@ -45,7 +46,10 @@ IDREG_START(CLIDR_EL1)
 IDREG_END(CLIDR_EL1)
 
 IDREG_START(CTR_EL0)
+    IDREG_FIELD(CTR_EL0, RES0, 38, 26)
     IDREG_FIELD(CTR_EL0, TminLine, 32, 6)
+    IDREG_FIELD(CTR_EL0, RES1, 31, 1)
+    IDREG_FIELD(CTR_EL0, RES0, 30, 1)
     IDREG_FIELD_START(CTR_EL0, DIC, 29, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -63,23 +67,28 @@ IDREG_START(CTR_EL0)
         IDREG_FIELD_ARCH_VAL(2)
         IDREG_FIELD_ARCH_VAL(3)
     IDREG_FIELD_END(CTR_EL0, L1Ip)
+    IDREG_FIELD(CTR_EL0, RES0, 4, 10)
     IDREG_FIELD(CTR_EL0, IminLine, 0, 4)
 IDREG_END(CTR_EL0)
 
 IDREG_START(DCZID_EL0)
+    IDREG_FIELD(DCZID_EL0, RES0, 9, 55)
     IDREG_FIELD(DCZID_EL0, TBS, 5, 4)
     IDREG_FIELD(DCZID_EL0, DZP, 4, 1)
     IDREG_FIELD(DCZID_EL0, BS, 0, 4)
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
@@ -141,6 +150,7 @@ IDREG_START(ID_AA64DFR0_EL1)
         IDREG_FIELD_ARCH_VAL(14)
         IDREG_FIELD_ARCH_VAL(15)
     IDREG_FIELD_END(ID_AA64DFR0_EL1, CTX_CMPs)
+    IDREG_FIELD(ID_AA64DFR0_EL1, RES0, 24, 4)
     IDREG_FIELD_START(ID_AA64DFR0_EL1, WRPs, 20, 4)
         IDREG_FIELD_ARCH_VAL(1)
         IDREG_FIELD_ARCH_VAL(2)
@@ -531,6 +541,7 @@ IDREG_START(ID_AA64DFR1_EL1)
 IDREG_END(ID_AA64DFR1_EL1)
 
 IDREG_START(ID_AA64DFR2_EL1)
+    IDREG_FIELD(ID_AA64DFR2_EL1, RES0, 28, 36)
     IDREG_FIELD_START(ID_AA64DFR2_EL1, TRBE_EXC, 24, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -543,6 +554,7 @@ IDREG_START(ID_AA64DFR2_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64DFR2_EL1, SPE_EXC)
+    IDREG_FIELD(ID_AA64DFR2_EL1, RES0, 8, 8)
     IDREG_FIELD_START(ID_AA64DFR2_EL1, BWE, 4, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -555,6 +567,7 @@ IDREG_START(ID_AA64DFR2_EL1)
 IDREG_END(ID_AA64DFR2_EL1)
 
 IDREG_START(ID_AA64FPFR0_EL1)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_AA64FPFR0_EL1, F8CVT, 31, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -579,10 +592,13 @@ IDREG_START(ID_AA64FPFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64FPFR0_EL1, F8MM4)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 16, 10)
     IDREG_FIELD_START(ID_AA64FPFR0_EL1, F16MM2, 15, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64FPFR0_EL1, F16MM2)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RES0, 8, 7)
+    IDREG_FIELD(ID_AA64FPFR0_EL1, RAZ, 2, 6)
     IDREG_FIELD_START(ID_AA64FPFR0_EL1, F8E4M3, 1, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -634,6 +650,7 @@ IDREG_START(ID_AA64ISAR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64ISAR0_EL1, RDM)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, RES0, 24, 4)
     IDREG_FIELD_START(ID_AA64ISAR0_EL1, Atomic, 20, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(2)
@@ -657,6 +674,7 @@ IDREG_START(ID_AA64ISAR0_EL1)
         IDREG_FIELD_ARCH_VAL(1)
         IDREG_FIELD_ARCH_VAL(2)
     IDREG_FIELD_END(ID_AA64ISAR0_EL1, AES)
+    IDREG_FIELD(ID_AA64ISAR0_EL1, RES0, 0, 4)
 IDREG_END(ID_AA64ISAR0_EL1)
 
 IDREG_START(ID_AA64ISAR1_EL1)
@@ -820,6 +838,7 @@ IDREG_START(ID_AA64ISAR2_EL1)
 IDREG_END(ID_AA64ISAR2_EL1)
 
 IDREG_START(ID_AA64ISAR3_EL1)
+    IDREG_FIELD(ID_AA64ISAR3_EL1, RES0, 48, 16)
     IDREG_FIELD_START(ID_AA64ISAR3_EL1, LSCP, 44, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -883,6 +902,7 @@ IDREG_START(ID_AA64MMFR0_EL1)
         IDREG_FIELD_ARCH_VAL(1)
         IDREG_FIELD_ARCH_VAL(2)
     IDREG_FIELD_END(ID_AA64MMFR0_EL1, FGT)
+    IDREG_FIELD(ID_AA64MMFR0_EL1, RES0, 48, 8)
     IDREG_FIELD_START(ID_AA64MMFR0_EL1, ExS, 44, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1035,6 +1055,7 @@ IDREG_START(ID_AA64MMFR2_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64MMFR2_EL1, TTL)
+    IDREG_FIELD(ID_AA64MMFR2_EL1, RES0, 44, 4)
     IDREG_FIELD_START(ID_AA64MMFR2_EL1, FWB, 40, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1100,6 +1121,7 @@ IDREG_START(ID_AA64MMFR3_EL1)
         IDREG_FIELD_ARCH_VAL(2)
         IDREG_FIELD_ARCH_VAL(3)
     IDREG_FIELD_END(ID_AA64MMFR3_EL1, SDERR)
+    IDREG_FIELD(ID_AA64MMFR3_EL1, RES0, 48, 4)
     IDREG_FIELD_START(ID_AA64MMFR3_EL1, ANERR, 44, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1353,6 +1375,7 @@ IDREG_START(ID_AA64PFR1_EL1)
         IDREG_FIELD_ARCH_VAL(1)
         IDREG_FIELD_ARCH_VAL(2)
     IDREG_FIELD_END(ID_AA64PFR1_EL1, SME)
+    IDREG_FIELD(ID_AA64PFR1_EL1, RES0, 20, 4)
     IDREG_FIELD_START(ID_AA64PFR1_EL1, MPAM_frac, 16, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1380,6 +1403,7 @@ IDREG_START(ID_AA64PFR1_EL1)
 IDREG_END(ID_AA64PFR1_EL1)
 
 IDREG_START(ID_AA64PFR2_EL1)
+    IDREG_FIELD(ID_AA64PFR2_EL1, RES0, 48, 16)
     IDREG_FIELD_START(ID_AA64PFR2_EL1, VMTETCL, 44, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1439,6 +1463,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64SMFR0_EL1, FA64)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 62, 1)
     IDREG_FIELD_START(ID_AA64SMFR0_EL1, LUT6, 61, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1458,6 +1483,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(15)
     IDREG_FIELD_END(ID_AA64SMFR0_EL1, I16I64)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 49, 3)
     IDREG_FIELD_START(ID_AA64SMFR0_EL1, F64F64, 48, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1502,6 +1528,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64SMFR0_EL1, F32F32)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 31, 1)
     IDREG_FIELD_START(ID_AA64SMFR0_EL1, SF8FMA, 30, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1514,6 +1541,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64SMFR0_EL1, SF8DP2)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 26, 2)
     IDREG_FIELD_START(ID_AA64SMFR0_EL1, SBitPerm, 25, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1526,10 +1554,12 @@ IDREG_START(ID_AA64SMFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64SMFR0_EL1, SFEXPA)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 17, 6)
     IDREG_FIELD_START(ID_AA64SMFR0_EL1, STMOP, 16, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64SMFR0_EL1, STMOP)
+    IDREG_FIELD(ID_AA64SMFR0_EL1, RES0, 1, 15)
     IDREG_FIELD_START(ID_AA64SMFR0_EL1, SMOP4, 0, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1537,6 +1567,7 @@ IDREG_START(ID_AA64SMFR0_EL1)
 IDREG_END(ID_AA64SMFR0_EL1)
 
 IDREG_START(ID_AA64ZFR0_EL1)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 60, 4)
     IDREG_FIELD_START(ID_AA64ZFR0_EL1, F64MM, 56, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1557,10 +1588,12 @@ IDREG_START(ID_AA64ZFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64ZFR0_EL1, SM4)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 36, 4)
     IDREG_FIELD_START(ID_AA64ZFR0_EL1, SHA3, 32, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64ZFR0_EL1, SHA3)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 28, 4)
     IDREG_FIELD_START(ID_AA64ZFR0_EL1, B16B16, 24, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1580,6 +1613,7 @@ IDREG_START(ID_AA64ZFR0_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_AA64ZFR0_EL1, EltPerm)
+    IDREG_FIELD(ID_AA64ZFR0_EL1, RES0, 8, 4)
     IDREG_FIELD_START(ID_AA64ZFR0_EL1, AES, 4, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1596,9 +1630,11 @@ IDREG_START(ID_AA64ZFR0_EL1)
 IDREG_END(ID_AA64ZFR0_EL1)
 
 IDREG_START(ID_AFR0_EL1)
+    IDREG_FIELD(ID_AFR0_EL1, RES0, 0, 64)
 IDREG_END(ID_AFR0_EL1)
 
 IDREG_START(ID_DFR0_EL1)
+    IDREG_FIELD(ID_DFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_DFR0_EL1, TraceFilt, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1650,6 +1686,7 @@ IDREG_START(ID_DFR0_EL1)
 IDREG_END(ID_DFR0_EL1)
 
 IDREG_START(ID_DFR1_EL1)
+    IDREG_FIELD(ID_DFR1_EL1, RES0, 8, 56)
     IDREG_FIELD_START(ID_DFR1_EL1, HPMN0, 4, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1662,6 +1699,7 @@ IDREG_START(ID_DFR1_EL1)
 IDREG_END(ID_DFR1_EL1)
 
 IDREG_START(ID_ISAR0_EL1)
+    IDREG_FIELD(ID_ISAR0_EL1, RES0, 28, 36)
     IDREG_FIELD_START(ID_ISAR0_EL1, Divide, 24, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1697,6 +1735,7 @@ IDREG_START(ID_ISAR0_EL1)
 IDREG_END(ID_ISAR0_EL1)
 
 IDREG_START(ID_ISAR1_EL1)
+    IDREG_FIELD(ID_ISAR1_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_ISAR1_EL1, Jazelle, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1735,6 +1774,7 @@ IDREG_START(ID_ISAR1_EL1)
 IDREG_END(ID_ISAR1_EL1)
 
 IDREG_START(ID_ISAR2_EL1)
+    IDREG_FIELD(ID_ISAR2_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_ISAR2_EL1, Reversal, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1780,6 +1820,7 @@ IDREG_START(ID_ISAR2_EL1)
 IDREG_END(ID_ISAR2_EL1)
 
 IDREG_START(ID_ISAR3_EL1)
+    IDREG_FIELD(ID_ISAR3_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_ISAR3_EL1, T32EE, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1817,6 +1858,7 @@ IDREG_START(ID_ISAR3_EL1)
 IDREG_END(ID_ISAR3_EL1)
 
 IDREG_START(ID_ISAR4_EL1)
+    IDREG_FIELD(ID_ISAR4_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_ISAR4_EL1, SWP_frac, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1855,6 +1897,7 @@ IDREG_START(ID_ISAR4_EL1)
 IDREG_END(ID_ISAR4_EL1)
 
 IDREG_START(ID_ISAR5_EL1)
+    IDREG_FIELD(ID_ISAR5_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_ISAR5_EL1, VCMA, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1863,6 +1906,7 @@ IDREG_START(ID_ISAR5_EL1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(ID_ISAR5_EL1, RDM)
+    IDREG_FIELD(ID_ISAR5_EL1, RES0, 20, 4)
     IDREG_FIELD_START(ID_ISAR5_EL1, CRC32, 16, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1887,6 +1931,7 @@ IDREG_START(ID_ISAR5_EL1)
 IDREG_END(ID_ISAR5_EL1)
 
 IDREG_START(ID_ISAR6_EL1)
+    IDREG_FIELD(ID_ISAR6_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_ISAR6_EL1, CLRBHB, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1923,6 +1968,7 @@ IDREG_START(ID_ISAR6_EL1)
 IDREG_END(ID_ISAR6_EL1)
 
 IDREG_START(ID_MMFR0_EL1)
+    IDREG_FIELD(ID_MMFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_MMFR0_EL1, InnerShr, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -1969,6 +2015,7 @@ IDREG_START(ID_MMFR0_EL1)
 IDREG_END(ID_MMFR0_EL1)
 
 IDREG_START(ID_MMFR1_EL1)
+    IDREG_FIELD(ID_MMFR1_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_MMFR1_EL1, BPred, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2017,6 +2064,7 @@ IDREG_START(ID_MMFR1_EL1)
 IDREG_END(ID_MMFR1_EL1)
 
 IDREG_START(ID_MMFR2_EL1)
+    IDREG_FIELD(ID_MMFR2_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_MMFR2_EL1, HWAccFlg, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2055,6 +2103,7 @@ IDREG_START(ID_MMFR2_EL1)
 IDREG_END(ID_MMFR2_EL1)
 
 IDREG_START(ID_MMFR3_EL1)
+    IDREG_FIELD(ID_MMFR3_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_MMFR3_EL1, Supersec, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(15)
@@ -2094,6 +2143,7 @@ IDREG_START(ID_MMFR3_EL1)
 IDREG_END(ID_MMFR3_EL1)
 
 IDREG_START(ID_MMFR4_EL1)
+    IDREG_FIELD(ID_MMFR4_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_MMFR4_EL1, EVT, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2131,6 +2181,7 @@ IDREG_START(ID_MMFR4_EL1)
 IDREG_END(ID_MMFR4_EL1)
 
 IDREG_START(ID_MMFR5_EL1)
+    IDREG_FIELD(ID_MMFR5_EL1, RES0, 8, 56)
     IDREG_FIELD_START(ID_MMFR5_EL1, nTLBPA, 4, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2144,6 +2195,7 @@ IDREG_START(ID_MMFR5_EL1)
 IDREG_END(ID_MMFR5_EL1)
 
 IDREG_START(ID_PFR0_EL1)
+    IDREG_FIELD(ID_PFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_PFR0_EL1, RAS, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2185,6 +2237,7 @@ IDREG_START(ID_PFR0_EL1)
 IDREG_END(ID_PFR0_EL1)
 
 IDREG_START(ID_PFR1_EL1)
+    IDREG_FIELD(ID_PFR1_EL1, RES0, 32, 32)
     IDREG_FIELD_START(ID_PFR1_EL1, GIC, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2224,6 +2277,7 @@ IDREG_START(ID_PFR1_EL1)
 IDREG_END(ID_PFR1_EL1)
 
 IDREG_START(ID_PFR2_EL1)
+    IDREG_FIELD(ID_PFR2_EL1, RES0, 12, 52)
     IDREG_FIELD_START(ID_PFR2_EL1, RAS_frac, 8, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2271,11 +2325,14 @@ IDREG_START(MIDR_EL1)
 IDREG_END(MIDR_EL1)
 
 IDREG_START(MPIDR_EL1)
+    IDREG_FIELD(MPIDR_EL1, RES0, 40, 24)
     IDREG_FIELD(MPIDR_EL1, Aff3, 32, 8)
+    IDREG_FIELD(MPIDR_EL1, RES1, 31, 1)
     IDREG_FIELD_START(MPIDR_EL1, U, 30, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
     IDREG_FIELD_END(MPIDR_EL1, U)
+    IDREG_FIELD(MPIDR_EL1, RES0, 25, 5)
     IDREG_FIELD_START(MPIDR_EL1, MT, 24, 1)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2286,6 +2343,7 @@ IDREG_START(MPIDR_EL1)
 IDREG_END(MPIDR_EL1)
 
 IDREG_START(MVFR0_EL1)
+    IDREG_FIELD(MVFR0_EL1, RES0, 32, 32)
     IDREG_FIELD_START(MVFR0_EL1, FPRound, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2324,6 +2382,7 @@ IDREG_START(MVFR0_EL1)
 IDREG_END(MVFR0_EL1)
 
 IDREG_START(MVFR1_EL1)
+    IDREG_FIELD(MVFR1_EL1, RES0, 32, 32)
     IDREG_FIELD_START(MVFR1_EL1, SIMDFMAC, 28, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2362,6 +2421,7 @@ IDREG_START(MVFR1_EL1)
 IDREG_END(MVFR1_EL1)
 
 IDREG_START(MVFR2_EL1)
+    IDREG_FIELD(MVFR2_EL1, RES0, 8, 56)
     IDREG_FIELD_START(MVFR2_EL1, FPMisc, 4, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2381,6 +2441,7 @@ IDREG_START(REVIDR_EL1)
 IDREG_END(REVIDR_EL1)
 
 IDREG_START(SMIDR_EL1)
+    IDREG_FIELD(SMIDR_EL1, RES0, 60, 4)
     IDREG_FIELD_START(SMIDR_EL1, NSMC, 56, 4)
         IDREG_FIELD_ARCH_VAL(0)
         IDREG_FIELD_ARCH_VAL(1)
@@ -2445,6 +2506,7 @@ IDREG_START(SMIDR_EL1)
         IDREG_FIELD_ARCH_VAL(2)
         IDREG_FIELD_ARCH_VAL(3)
     IDREG_FIELD_END(SMIDR_EL1, SH)
+    IDREG_FIELD(SMIDR_EL1, RES0, 12, 1)
     IDREG_FIELD(SMIDR_EL1, Affinity, 0, 12)
 IDREG_END(SMIDR_EL1)
 
diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
index 96f8aa2d64..0b4e4d3e0c 100644
--- a/scripts/update-aarch64-cpu-sysreg-properties.py
+++ b/scripts/update-aarch64-cpu-sysreg-properties.py
@@ -81,9 +81,13 @@ def collect_fields(item, bit_offset=0):
 
     # Normal Field Types
     leaf_types = ['Fields.Field', 'Fields.ConstantField',
-                  'Fields.EnumeratedField', 'Fields.Bitfield']
+                  'Fields.EnumeratedField', 'Fields.Bitfield', 'Fields.Reserved']
     if _type in leaf_types:
         field_copy = item.copy()
+
+        if _type == 'Fields.Reserved' and not field_copy.get('name'):
+            field_copy['name'] = item.get('value', 'RES0')
+
         if field_copy.get('rangeset'):
             new_ranges = []
             for r in field_copy['rangeset']:
@@ -96,7 +100,7 @@ def collect_fields(item, bit_offset=0):
         return fields
 
     # Traverse the hierarchy for other cases
-    for key in ['fields', 'values', 'fieldsets']:
+    for key in ['fields', 'values', 'fieldsets', 'constants']:
         for nested in item.get(key, []):
             fields.extend(collect_fields(nested, bit_offset))
 
@@ -171,45 +175,96 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
 
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
+                raw_name = val.get('name') or val.get('label') or val.get('value') or ''
+                name = raw_name.strip()
+                if not name:
                     continue
+
+                name_upper = name.upper()
+
+                # Check for architectural target states, including UNKNOWN remapping
+                base_reserved = None
+                for r_type in ["RES0", "RES1", "RAZ", "RAO", "WI", "UNKNOWN"]:
+                    if r_type == name_upper:
+                        base_reserved = "RES0" if r_type == "UNKNOWN" else r_type
+                        break
+
+                is_valid_reserved = base_reserved is not None
+                if "RESERVED" in name_upper and not is_valid_reserved:
+                    continue
+
+                # Force naming uniformity across padding blocks
+                if is_valid_reserved:
+                    name = base_reserved
+
                 for r in val.get('rangeset', []):
                     lsb = int(r.get('start'))
                     width = r.get('width')
                     msb = lsb + int(width) - 1
 
-                    # Only keep the fields with the highest MSB
-                    # needed fir CCSIDR_EL1
-                    if name not in unique_fields or msb > unique_fields[name]['msb']:
-                        # extract enum values if any
+                    if is_valid_reserved:
+                        unique_key = f"{name}_{lsb}"
+                    else:
+                        unique_key = name
+
+                    if unique_key not in current_fieldset_fields or \
+                       msb > current_fieldset_fields[unique_key]['msb']:
                         enums = extract_field_enums(val)
-                        unique_fields[name] = {'lsb': lsb, 'msb': msb, 'width': width, 'enums': enums}
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
+        for variant in fieldset_variants:
+            total_width = sum(f['width'] for f in variant.values())
+            # prioritize layout variants with the highest MSB coverage
+            max_msb = max(f['msb'] for f in variant.values()) if variant else 0
+
+            # Combine width and max_msb into a fitness score tuple
+            if (total_width, max_msb) > (max_total_width, max_total_width):
+                max_total_width = total_width
+                best_fieldset = variant
+
+        unique_fields = best_fieldset
 
         # Sort decreasing lsbs
         sorted_fields = sorted(unique_fields.items(),
                                key=lambda x: x[1]['lsb'], reverse=True)
 
-        for name, bits in sorted_fields:
+        for unique_key, bits in sorted_fields:
             enums_list = bits.get('enums', [])
 
+            clean_name = bits.get('raw_name', unique_key)
+
             if enums_list:
                line = (f"    IDREG_FIELD_START({reg_name}, "
-                       f"{name}, {bits['lsb']}, {bits['width']})\n")
+                       f"{clean_name}, {bits['lsb']}, {bits['width']})\n")
             else:
                line = (f"    IDREG_FIELD({reg_name}, "
-                       f"{name}, {bits['lsb']}, {bits['width']})\n")
+                       f"{clean_name}, {bits['lsb']}, {bits['width']})\n")
             final_output += line
             # generate enum value or range if any
             for enum_item in enums_list:
                     final_output += (f"        IDREG_FIELD_ARCH_VAL({enum_item['value']})\n")
 
             if enums_list:
-               line = (f"    IDREG_FIELD_END({reg_name}, {name})\n")
+               line = (f"    IDREG_FIELD_END({reg_name}, {clean_name})\n")
                final_output += line
      
         final_output += f"IDREG_END({reg_name})\n"
-- 
2.53.0

