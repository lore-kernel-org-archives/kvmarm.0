Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6E2279903
	for <kvmarm@lists.linux.dev>; Mon, 14 Apr 2025 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744648813; cv=none; b=Oabdud0EgW0JbWLf4ZpoT/ooDOEeGLktJuQqdLGRmz7mp5GpaPZq+D/lsG05aTZ8ToXYOD/OudPT4xfeO83kdtp5bMMCe/K30/Wf/TJrXQkWcxve45F1vzl9JGKQEYAzaYDZSzP2Y2Uia2qlSejxVWp2fnuylwGhPBb80Cjgx4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744648813; c=relaxed/simple;
	bh=7QHGnFo2i4iRV403uybtrYNBtZNAoIIakzerVauj5zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=TVDy8iIHNQmoLTLWuGHZWvcJDxH0jLrD+g4bvSe4oj3a5IbwUKoOM2qQHOtTD2RClNTo1NbmPxdhFGKPAzx6QonXuUf1D6iEG5ZNJBJgOAlrHAsvNc463uSqH4xxKIqa0Ng4vd/0JkINJt9W9WDDnmt8GBEVkRMvfqf/Z6lBkeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Igl67cD2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Igl67cD2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744648809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OJqmdjWKBqX7ym21uneqbdLu4X8TMZeye3OqvTzYB3A=;
	b=Igl67cD2xA4DnxmSKk3DJz3z7clnQbEKc0z2YyyzwYAlocbN2pX35OzA5218k42Rs9vU+s
	QQNdo4dnULp5r4DP46o5ZkSjFzdbYVO6ZieRa1BMSvrBdFPEwwpVTEGHv7Zs1qXJSQbz6O
	UgRXhjSkuM3tz3Bpo4LFPaCQHlq1WCw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53--bZJANH9Mz6KqJAf048jMg-1; Mon,
 14 Apr 2025 12:40:05 -0400
X-MC-Unique: -bZJANH9Mz6KqJAf048jMg-1
X-Mimecast-MFC-AGG-ID: -bZJANH9Mz6KqJAf048jMg_1744648803
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FDFE1955DD0;
	Mon, 14 Apr 2025 16:40:03 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.14])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C0CC180B491;
	Mon, 14 Apr 2025 16:39:46 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: agraf@csgraf.de,
	shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 03/10] arm/cpu: Add generated sysreg properties
Date: Mon, 14 Apr 2025 18:38:42 +0200
Message-ID: <20250414163849.321857-4-cohuck@redhat.com>
In-Reply-To: <20250414163849.321857-1-cohuck@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Generated against Linux 6.14-rc1.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysreg-properties.c | 716 ++++++++++++++++++++++++++++-
 1 file changed, 694 insertions(+), 22 deletions(-)

diff --git a/target/arm/cpu-sysreg-properties.c b/target/arm/cpu-sysreg-properties.c
index 8b7ef5badfb9..05eb40487313 100644
--- a/target/arm/cpu-sysreg-properties.c
+++ b/target/arm/cpu-sysreg-properties.c
@@ -1,24 +1,3 @@
-/*
- * QEMU ARM CPU SYSREG PROPERTIES
- * to be generated from linux sysreg
- *
- * Copyright (c) Red Hat, Inc. 2024
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see
- * <http://www.gnu.org/licenses/gpl-2.0.html>
- */
-
 #include "cpu-custom.h"
 
 ARM64SysReg arm64_id_regs[NUM_ID_IDX];
@@ -26,6 +5,627 @@ ARM64SysReg arm64_id_regs[NUM_ID_IDX];
 void initialize_cpu_sysreg_properties(void)
 {
     memset(arm64_id_regs, 0, sizeof(ARM64SysReg) * NUM_ID_IDX);
+
+    /* ID_PFR0_EL1 */
+    ARM64SysReg *ID_PFR0_EL1 = arm64_sysreg_get(ID_PFR0_EL1_IDX);
+    ID_PFR0_EL1->name = "ID_PFR0_EL1";
+    arm64_sysreg_add_field(ID_PFR0_EL1, "RAS", 28, 31);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "DIT", 24, 27);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "AMU", 20, 23);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "CSV2", 16, 19);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State3", 12, 15);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State2", 8, 11);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State1", 4, 7);
+    arm64_sysreg_add_field(ID_PFR0_EL1, "State0", 0, 3);
+
+    /* ID_PFR1_EL1 */
+    ARM64SysReg *ID_PFR1_EL1 = arm64_sysreg_get(ID_PFR1_EL1_IDX);
+    ID_PFR1_EL1->name = "ID_PFR1_EL1";
+    arm64_sysreg_add_field(ID_PFR1_EL1, "GIC", 28, 31);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Virt_frac", 24, 27);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Sec_frac", 20, 23);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "GenTimer", 16, 19);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Virtualization", 12, 15);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "MProgMod", 8, 11);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "Security", 4, 7);
+    arm64_sysreg_add_field(ID_PFR1_EL1, "ProgMod", 0, 3);
+
+    /* ID_DFR0_EL1 */
+    ARM64SysReg *ID_DFR0_EL1 = arm64_sysreg_get(ID_DFR0_EL1_IDX);
+    ID_DFR0_EL1->name = "ID_DFR0_EL1";
+    arm64_sysreg_add_field(ID_DFR0_EL1, "TraceFilt", 28, 31);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "PerfMon", 24, 27);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "MProfDbg", 20, 23);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "MMapTrc", 16, 19);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "CopTrc", 12, 15);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "MMapDbg", 8, 11);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "CopSDbg", 4, 7);
+    arm64_sysreg_add_field(ID_DFR0_EL1, "CopDbg", 0, 3);
+
+    /* ID_AFR0_EL1 */
+    ARM64SysReg *ID_AFR0_EL1 = arm64_sysreg_get(ID_AFR0_EL1_IDX);
+    ID_AFR0_EL1->name = "ID_AFR0_EL1";
+    arm64_sysreg_add_field(ID_AFR0_EL1, "IMPDEF3", 12, 15);
+    arm64_sysreg_add_field(ID_AFR0_EL1, "IMPDEF2", 8, 11);
+    arm64_sysreg_add_field(ID_AFR0_EL1, "IMPDEF1", 4, 7);
+    arm64_sysreg_add_field(ID_AFR0_EL1, "IMPDEF0", 0, 3);
+
+    /* ID_MMFR0_EL1 */
+    ARM64SysReg *ID_MMFR0_EL1 = arm64_sysreg_get(ID_MMFR0_EL1_IDX);
+    ID_MMFR0_EL1->name = "ID_MMFR0_EL1";
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "InnerShr", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "FCSE", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "AuxReg", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "TCM", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "ShareLvl", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "OuterShr", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "PMSA", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR0_EL1, "VMSA", 0, 3);
+
+    /* ID_MMFR1_EL1 */
+    ARM64SysReg *ID_MMFR1_EL1 = arm64_sysreg_get(ID_MMFR1_EL1_IDX);
+    ID_MMFR1_EL1->name = "ID_MMFR1_EL1";
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "BPred", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1TstCln", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1Uni", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1Hvd", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1UniSW", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1HvdSW", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1UniVA", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR1_EL1, "L1HvdVA", 0, 3);
+
+    /* ID_MMFR2_EL1 */
+    ARM64SysReg *ID_MMFR2_EL1 = arm64_sysreg_get(ID_MMFR2_EL1_IDX);
+    ID_MMFR2_EL1->name = "ID_MMFR2_EL1";
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "HWAccFlg", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "WFIStall", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "MemBarr", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "UniTLB", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "HvdTLB", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "L1HvdRng", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "L1HvdBG", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR2_EL1, "L1HvdFG", 0, 3);
+
+    /* ID_MMFR3_EL1 */
+    ARM64SysReg *ID_MMFR3_EL1 = arm64_sysreg_get(ID_MMFR3_EL1_IDX);
+    ID_MMFR3_EL1->name = "ID_MMFR3_EL1";
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "Supersec", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CMemSz", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CohWalk", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "PAN", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "MaintBcst", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "BPMaint", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CMaintSW", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR3_EL1, "CMaintVA", 0, 3);
+
+    /* ID_ISAR0_EL1 */
+    ARM64SysReg *ID_ISAR0_EL1 = arm64_sysreg_get(ID_ISAR0_EL1_IDX);
+    ID_ISAR0_EL1->name = "ID_ISAR0_EL1";
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Divide", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Debug", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Coproc", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "CmpBranch", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "BitField", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "BitCount", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR0_EL1, "Swap", 0, 3);
+
+    /* ID_ISAR1_EL1 */
+    ARM64SysReg *ID_ISAR1_EL1 = arm64_sysreg_get(ID_ISAR1_EL1_IDX);
+    ID_ISAR1_EL1->name = "ID_ISAR1_EL1";
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Jazelle", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Interwork", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Immediate", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "IfThen", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Extend", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Except_AR", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Except", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR1_EL1, "Endian", 0, 3);
+
+    /* ID_ISAR2_EL1 */
+    ARM64SysReg *ID_ISAR2_EL1 = arm64_sysreg_get(ID_ISAR2_EL1_IDX);
+    ID_ISAR2_EL1->name = "ID_ISAR2_EL1";
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "Reversal", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "PSR_AR", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MultU", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MultS", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "Mult", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MultiAccessInt", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "MemHint", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR2_EL1, "LoadStore", 0, 3);
+
+    /* ID_ISAR3_EL1 */
+    ARM64SysReg *ID_ISAR3_EL1 = arm64_sysreg_get(ID_ISAR3_EL1_IDX);
+    ID_ISAR3_EL1->name = "ID_ISAR3_EL1";
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "T32EE", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "TrueNOP", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "T32Copy", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "TabBranch", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "SynchPrim", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "SVC", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "SIMD", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR3_EL1, "Saturate", 0, 3);
+
+    /* ID_ISAR4_EL1 */
+    ARM64SysReg *ID_ISAR4_EL1 = arm64_sysreg_get(ID_ISAR4_EL1_IDX);
+    ID_ISAR4_EL1->name = "ID_ISAR4_EL1";
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "SWP_frac", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "PSR_M", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "SynchPrim_frac", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "Barrier", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "SMC", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "Writeback", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "WithShifts", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR4_EL1, "Unpriv", 0, 3);
+
+    /* ID_ISAR5_EL1 */
+    ARM64SysReg *ID_ISAR5_EL1 = arm64_sysreg_get(ID_ISAR5_EL1_IDX);
+    ID_ISAR5_EL1->name = "ID_ISAR5_EL1";
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "VCMA", 28, 31);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "RDM", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "CRC32", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "SHA2", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "SHA1", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "AES", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR5_EL1, "SEVL", 0, 3);
+
+    /* ID_ISAR6_EL1 */
+    ARM64SysReg *ID_ISAR6_EL1 = arm64_sysreg_get(ID_ISAR6_EL1_IDX);
+    ID_ISAR6_EL1->name = "ID_ISAR6_EL1";
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "I8MM", 24, 27);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "BF16", 20, 23);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "SPECRES", 16, 19);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "SB", 12, 15);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "FHM", 8, 11);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "DP", 4, 7);
+    arm64_sysreg_add_field(ID_ISAR6_EL1, "JSCVT", 0, 3);
+
+    /* ID_MMFR4_EL1 */
+    ARM64SysReg *ID_MMFR4_EL1 = arm64_sysreg_get(ID_MMFR4_EL1_IDX);
+    ID_MMFR4_EL1->name = "ID_MMFR4_EL1";
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "EVT", 28, 31);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "CCIDX", 24, 27);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "LSM", 20, 23);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "HPDS", 16, 19);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "CnP", 12, 15);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "XNX", 8, 11);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "AC2", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR4_EL1, "SpecSEI", 0, 3);
+
+    /* MVFR0_EL1 */
+    ARM64SysReg *MVFR0_EL1 = arm64_sysreg_get(MVFR0_EL1_IDX);
+    MVFR0_EL1->name = "MVFR0_EL1";
+    arm64_sysreg_add_field(MVFR0_EL1, "FPRound", 28, 31);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPShVec", 24, 27);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPSqrt", 20, 23);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPDivide", 16, 19);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPTrap", 12, 15);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPDP", 8, 11);
+    arm64_sysreg_add_field(MVFR0_EL1, "FPSP", 4, 7);
+    arm64_sysreg_add_field(MVFR0_EL1, "SIMDReg", 0, 3);
+
+    /* MVFR1_EL1 */
+    ARM64SysReg *MVFR1_EL1 = arm64_sysreg_get(MVFR1_EL1_IDX);
+    MVFR1_EL1->name = "MVFR1_EL1";
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDFMAC", 28, 31);
+    arm64_sysreg_add_field(MVFR1_EL1, "FPHP", 24, 27);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDHP", 20, 23);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDSP", 16, 19);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDInt", 12, 15);
+    arm64_sysreg_add_field(MVFR1_EL1, "SIMDLS", 8, 11);
+    arm64_sysreg_add_field(MVFR1_EL1, "FPDNaN", 4, 7);
+    arm64_sysreg_add_field(MVFR1_EL1, "FPFtZ", 0, 3);
+
+    /* MVFR2_EL1 */
+    ARM64SysReg *MVFR2_EL1 = arm64_sysreg_get(MVFR2_EL1_IDX);
+    MVFR2_EL1->name = "MVFR2_EL1";
+    arm64_sysreg_add_field(MVFR2_EL1, "FPMisc", 4, 7);
+    arm64_sysreg_add_field(MVFR2_EL1, "SIMDMisc", 0, 3);
+
+    /* ID_PFR2_EL1 */
+    ARM64SysReg *ID_PFR2_EL1 = arm64_sysreg_get(ID_PFR2_EL1_IDX);
+    ID_PFR2_EL1->name = "ID_PFR2_EL1";
+    arm64_sysreg_add_field(ID_PFR2_EL1, "RAS_frac", 8, 11);
+    arm64_sysreg_add_field(ID_PFR2_EL1, "SSBS", 4, 7);
+    arm64_sysreg_add_field(ID_PFR2_EL1, "CSV3", 0, 3);
+
+    /* ID_DFR1_EL1 */
+    ARM64SysReg *ID_DFR1_EL1 = arm64_sysreg_get(ID_DFR1_EL1_IDX);
+    ID_DFR1_EL1->name = "ID_DFR1_EL1";
+    arm64_sysreg_add_field(ID_DFR1_EL1, "HPMN0", 4, 7);
+    arm64_sysreg_add_field(ID_DFR1_EL1, "MTPMU", 0, 3);
+
+    /* ID_MMFR5_EL1 */
+    ARM64SysReg *ID_MMFR5_EL1 = arm64_sysreg_get(ID_MMFR5_EL1_IDX);
+    ID_MMFR5_EL1->name = "ID_MMFR5_EL1";
+    arm64_sysreg_add_field(ID_MMFR5_EL1, "nTLBPA", 4, 7);
+    arm64_sysreg_add_field(ID_MMFR5_EL1, "ETS", 0, 3);
+
+    /* ID_AA64PFR0_EL1 */
+    ARM64SysReg *ID_AA64PFR0_EL1 = arm64_sysreg_get(ID_AA64PFR0_EL1_IDX);
+    ID_AA64PFR0_EL1->name = "ID_AA64PFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "CSV3", 60, 63);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "CSV2", 56, 59);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "RME", 52, 55);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "DIT", 48, 51);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "AMU", 44, 47);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "MPAM", 40, 43);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "SEL2", 36, 39);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "SVE", 32, 35);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "RAS", 28, 31);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "GIC", 24, 27);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "AdvSIMD", 20, 23);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "AdvSIMD", 20, 23);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "FP", 16, 19);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "FP", 16, 19);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL3", 12, 15);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL2", 8, 11);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL1", 4, 7);
+    arm64_sysreg_add_field(ID_AA64PFR0_EL1, "EL0", 0, 3);
+
+    /* ID_AA64PFR1_EL1 */
+    ARM64SysReg *ID_AA64PFR1_EL1 = arm64_sysreg_get(ID_AA64PFR1_EL1_IDX);
+    ID_AA64PFR1_EL1->name = "ID_AA64PFR1_EL1";
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "PFAR", 60, 63);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "DF2", 56, 59);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MTEX", 52, 55);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "THE", 48, 51);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "GCS", 44, 47);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MTE_frac", 40, 43);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "NMI", 36, 39);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "CSV2_frac", 32, 35);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "RNDR_trap", 28, 31);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "SME", 24, 27);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MPAM_frac", 16, 19);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "RAS_frac", 12, 15);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "MTE", 8, 11);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "SSBS", 4, 7);
+    arm64_sysreg_add_field(ID_AA64PFR1_EL1, "BT", 0, 3);
+
+    /* ID_AA64PFR2_EL1 */
+    ARM64SysReg *ID_AA64PFR2_EL1 = arm64_sysreg_get(ID_AA64PFR2_EL1_IDX);
+    ID_AA64PFR2_EL1->name = "ID_AA64PFR2_EL1";
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "FPMR", 32, 35);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "UINJ", 16, 19);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MTEFAR", 8, 11);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MTESTOREONLY", 4, 7);
+    arm64_sysreg_add_field(ID_AA64PFR2_EL1, "MTEPERM", 0, 3);
+
+    /* ID_AA64ZFR0_EL1 */
+    ARM64SysReg *ID_AA64ZFR0_EL1 = arm64_sysreg_get(ID_AA64ZFR0_EL1_IDX);
+    ID_AA64ZFR0_EL1->name = "ID_AA64ZFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "F64MM", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "F32MM", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "F16MM", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "I8MM", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "SM4", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "SHA3", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "B16B16", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "BF16", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "BitPerm", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "EltPerm", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "AES", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ZFR0_EL1, "SVEver", 0, 3);
+
+    /* ID_AA64SMFR0_EL1 */
+    ARM64SysReg *ID_AA64SMFR0_EL1 = arm64_sysreg_get(ID_AA64SMFR0_EL1_IDX);
+    ID_AA64SMFR0_EL1->name = "ID_AA64SMFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "FA64", 63, 63);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "LUTv2", 60, 60);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SMEver", 56, 59);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "I16I64", 52, 55);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F64F64", 48, 48);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "I16I32", 44, 47);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "B16B16", 43, 43);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F16F16", 42, 42);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F8F16", 41, 41);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F8F32", 40, 40);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "I8I32", 36, 39);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F16F32", 35, 35);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "B16F32", 34, 34);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "BI32I32", 33, 33);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "F32F32", 32, 32);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SF8FMA", 30, 30);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SF8DP4", 29, 29);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SF8DP2", 28, 28);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SBitPerm", 25, 25);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "AES", 24, 24);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SFEXPA", 23, 23);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "STMOP", 16, 16);
+    arm64_sysreg_add_field(ID_AA64SMFR0_EL1, "SMOP4", 0, 0);
+
+    /* ID_AA64FPFR0_EL1 */
+    ARM64SysReg *ID_AA64FPFR0_EL1 = arm64_sysreg_get(ID_AA64FPFR0_EL1_IDX);
+    ID_AA64FPFR0_EL1->name = "ID_AA64FPFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8CVT", 31, 31);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8FMA", 30, 30);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8DP4", 29, 29);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8DP2", 28, 28);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8MM8", 27, 27);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8MM4", 26, 26);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8E4M3", 1, 1);
+    arm64_sysreg_add_field(ID_AA64FPFR0_EL1, "F8E5M2", 0, 0);
+
+    /* ID_AA64DFR0_EL1 */
+    ARM64SysReg *ID_AA64DFR0_EL1 = arm64_sysreg_get(ID_AA64DFR0_EL1_IDX);
+    ID_AA64DFR0_EL1->name = "ID_AA64DFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "HPMN0", 60, 63);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "ExtTrcBuff", 56, 59);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "BRBE", 52, 55);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "MTPMU", 48, 51);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "MTPMU", 48, 51);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "TraceBuffer", 44, 47);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "TraceFilt", 40, 43);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "DoubleLock", 36, 39);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "PMSVer", 32, 35);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "CTX_CMPs", 28, 31);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "SEBEP", 24, 27);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "WRPs", 20, 23);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "PMSS", 16, 19);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "BRPs", 12, 15);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "PMUVer", 8, 11);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "TraceVer", 4, 7);
+    arm64_sysreg_add_field(ID_AA64DFR0_EL1, "DebugVer", 0, 3);
+
+    /* ID_AA64DFR1_EL1 */
+    ARM64SysReg *ID_AA64DFR1_EL1 = arm64_sysreg_get(ID_AA64DFR1_EL1_IDX);
+    ID_AA64DFR1_EL1->name = "ID_AA64DFR1_EL1";
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "ABL_CMPs", 56, 63);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "DPFZS", 52, 55);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "EBEP", 48, 51);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "ITE", 44, 47);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "ABLE", 40, 43);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "PMICNTR", 36, 39);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "SPMU", 32, 35);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "CTX_CMPs", 24, 31);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "WRPs", 16, 23);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "BRPs", 8, 15);
+    arm64_sysreg_add_field(ID_AA64DFR1_EL1, "SYSPMUID", 0, 7);
+
+    /* ID_AA64DFR2_EL1 */
+    ARM64SysReg *ID_AA64DFR2_EL1 = arm64_sysreg_get(ID_AA64DFR2_EL1_IDX);
+    ID_AA64DFR2_EL1->name = "ID_AA64DFR2_EL1";
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "TRBE_EXC", 24, 27);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "SPE_nVM", 20, 23);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "SPE_EXC", 16, 19);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "BWE", 4, 7);
+    arm64_sysreg_add_field(ID_AA64DFR2_EL1, "STEP", 0, 3);
+
+    /* ID_AA64AFR0_EL1 */
+    ARM64SysReg *ID_AA64AFR0_EL1 = arm64_sysreg_get(ID_AA64AFR0_EL1_IDX);
+    ID_AA64AFR0_EL1->name = "ID_AA64AFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF7", 28, 31);
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF6", 24, 27);
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF5", 20, 23);
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF4", 16, 19);
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF3", 12, 15);
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF2", 8, 11);
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF1", 4, 7);
+    arm64_sysreg_add_field(ID_AA64AFR0_EL1, "IMPDEF0", 0, 3);
+
+    /* ID_AA64AFR1_EL1 */
+    ARM64SysReg *ID_AA64AFR1_EL1 = arm64_sysreg_get(ID_AA64AFR1_EL1_IDX);
+    ID_AA64AFR1_EL1->name = "ID_AA64AFR1_EL1";
+
+    /* ID_AA64ISAR0_EL1 */
+    ARM64SysReg *ID_AA64ISAR0_EL1 = arm64_sysreg_get(ID_AA64ISAR0_EL1_IDX);
+    ID_AA64ISAR0_EL1->name = "ID_AA64ISAR0_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "RNDR", 60, 63);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "TLB", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "TS", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "FHM", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "DP", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SM4", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SM3", 36, 39);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SHA3", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "RDM", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "TME", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "ATOMIC", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "CRC32", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SHA2", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "SHA1", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR0_EL1, "AES", 4, 7);
+
+    /* ID_AA64ISAR1_EL1 */
+    ARM64SysReg *ID_AA64ISAR1_EL1 = arm64_sysreg_get(ID_AA64ISAR1_EL1_IDX);
+    ID_AA64ISAR1_EL1->name = "ID_AA64ISAR1_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "LS64", 60, 63);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "XS", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "I8MM", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "DGH", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "BF16", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "SPECRES", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "SB", 36, 39);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "FRINTTS", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "GPI", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "GPA", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "LRCPC", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "FCMA", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "JSCVT", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "API", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "APA", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ISAR1_EL1, "DPB", 0, 3);
+
+    /* ID_AA64ISAR2_EL1 */
+    ARM64SysReg *ID_AA64ISAR2_EL1 = arm64_sysreg_get(ID_AA64ISAR2_EL1_IDX);
+    ID_AA64ISAR2_EL1->name = "ID_AA64ISAR2_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "ATS1A", 60, 63);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "LUT", 56, 59);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "CSSC", 52, 55);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "RPRFM", 48, 51);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "PCDPHINT", 44, 47);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "PRFMSLC", 40, 43);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "SYSINSTR_128", 36, 39);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "SYSREG_128", 32, 35);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "CLRBHB", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "PAC_frac", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "BC", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "MOPS", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "APA3", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "GPA3", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "RPRES", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ISAR2_EL1, "WFxT", 0, 3);
+
+    /* ID_AA64ISAR3_EL1 */
+    ARM64SysReg *ID_AA64ISAR3_EL1 = arm64_sysreg_get(ID_AA64ISAR3_EL1_IDX);
+    ID_AA64ISAR3_EL1->name = "ID_AA64ISAR3_EL1";
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "FPRCVT", 28, 31);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "LSUI", 24, 27);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "OCCMO", 20, 23);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "LSFE", 16, 19);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "PACM", 12, 15);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "TLBIW", 8, 11);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "FAMINMAX", 4, 7);
+    arm64_sysreg_add_field(ID_AA64ISAR3_EL1, "CPA", 0, 3);
+
+    /* ID_AA64MMFR0_EL1 */
+    ARM64SysReg *ID_AA64MMFR0_EL1 = arm64_sysreg_get(ID_AA64MMFR0_EL1_IDX);
+    ID_AA64MMFR0_EL1->name = "ID_AA64MMFR0_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "ECV", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "FGT", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "EXS", 44, 47);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN4_2", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN64_2", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN16_2", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN4", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN4", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN64", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN64", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "TGRAN16", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "BIGENDEL0", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "SNSMEM", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "BIGEND", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "ASIDBITS", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR0_EL1, "PARANGE", 0, 3);
+
+    /* ID_AA64MMFR1_EL1 */
+    ARM64SysReg *ID_AA64MMFR1_EL1 = arm64_sysreg_get(ID_AA64MMFR1_EL1_IDX);
+    ID_AA64MMFR1_EL1->name = "ID_AA64MMFR1_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "ECBHB", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "CMOW", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "TIDCP1", 52, 55);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "nTLBPA", 48, 51);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "AFP", 44, 47);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "HCX", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "ETS", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "TWED", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "XNX", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "SpecSEI", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "PAN", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "LO", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "HPDS", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "VH", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "VMIDBits", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR1_EL1, "HAFDBS", 0, 3);
+
+    /* ID_AA64MMFR2_EL1 */
+    ARM64SysReg *ID_AA64MMFR2_EL1 = arm64_sysreg_get(ID_AA64MMFR2_EL1_IDX);
+    ID_AA64MMFR2_EL1->name = "ID_AA64MMFR2_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "E0PD", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "EVT", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "BBM", 52, 55);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "TTL", 48, 51);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "FWB", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "IDS", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "AT", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "ST", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "NV", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "CCIDX", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "VARange", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "IESB", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "LSM", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "UAO", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR2_EL1, "CnP", 0, 3);
+
+    /* ID_AA64MMFR3_EL1 */
+    ARM64SysReg *ID_AA64MMFR3_EL1 = arm64_sysreg_get(ID_AA64MMFR3_EL1_IDX);
+    ID_AA64MMFR3_EL1->name = "ID_AA64MMFR3_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "Spec_FPACC", 60, 63);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "ADERR", 56, 59);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "SDERR", 52, 55);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "ANERR", 44, 47);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "SNERR", 40, 43);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "D128_2", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "D128", 32, 35);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "MEC", 28, 31);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "AIE", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S2POE", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S1POE", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S2PIE", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "S1PIE", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "SCTLRX", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR3_EL1, "TCRX", 0, 3);
+
+    /* ID_AA64MMFR4_EL1 */
+    ARM64SysReg *ID_AA64MMFR4_EL1 = arm64_sysreg_get(ID_AA64MMFR4_EL1_IDX);
+    ID_AA64MMFR4_EL1->name = "ID_AA64MMFR4_EL1";
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "E3DSE", 36, 39);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "E2H0", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "E2H0", 24, 27);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "NV_frac", 20, 23);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "FGWTE3", 16, 19);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "HACDBS", 12, 15);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "ASID2", 8, 11);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "EIESB", 4, 7);
+    arm64_sysreg_add_field(ID_AA64MMFR4_EL1, "EIESB", 4, 7);
+
+/* For ZCR_EL1 fields see ZCR_ELx */
+
+/* For SMCR_EL1 fields see SMCR_ELx */
+
+/* For GCSCR_EL1 fields see GCSCR_ELx */
+
+/* For GCSPR_EL1 fields see GCSPR_ELx */
+
+/* For CONTEXTIDR_EL1 fields see CONTEXTIDR_ELx */
+
+    /* CCSIDR_EL1 */
+    ARM64SysReg *CCSIDR_EL1 = arm64_sysreg_get(CCSIDR_EL1_IDX);
+    CCSIDR_EL1->name = "CCSIDR_EL1";
+    arm64_sysreg_add_field(CCSIDR_EL1, "NumSets", 13, 27);
+    arm64_sysreg_add_field(CCSIDR_EL1, "Associativity", 3, 12);
+    arm64_sysreg_add_field(CCSIDR_EL1, "LineSize", 0, 2);
+
+    /* CLIDR_EL1 */
+    ARM64SysReg *CLIDR_EL1 = arm64_sysreg_get(CLIDR_EL1_IDX);
+    CLIDR_EL1->name = "CLIDR_EL1";
+    arm64_sysreg_add_field(CLIDR_EL1, "Ttypen", 33, 46);
+    arm64_sysreg_add_field(CLIDR_EL1, "ICB", 30, 32);
+    arm64_sysreg_add_field(CLIDR_EL1, "LoUU", 27, 29);
+    arm64_sysreg_add_field(CLIDR_EL1, "LoC", 24, 26);
+    arm64_sysreg_add_field(CLIDR_EL1, "LoUIS", 21, 23);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype7", 18, 20);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype6", 15, 17);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype5", 12, 14);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype4", 9, 11);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype3", 6, 8);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype2", 3, 5);
+    arm64_sysreg_add_field(CLIDR_EL1, "Ctype1", 0, 2);
+
+    /* CCSIDR2_EL1 */
+    ARM64SysReg *CCSIDR2_EL1 = arm64_sysreg_get(CCSIDR2_EL1_IDX);
+    CCSIDR2_EL1->name = "CCSIDR2_EL1";
+    arm64_sysreg_add_field(CCSIDR2_EL1, "NumSets", 0, 23);
+
+    /* GMID_EL1 */
+    ARM64SysReg *GMID_EL1 = arm64_sysreg_get(GMID_EL1_IDX);
+    GMID_EL1->name = "GMID_EL1";
+    arm64_sysreg_add_field(GMID_EL1, "BS", 0, 3);
+
+    /* SMIDR_EL1 */
+    ARM64SysReg *SMIDR_EL1 = arm64_sysreg_get(SMIDR_EL1_IDX);
+    SMIDR_EL1->name = "SMIDR_EL1";
+    arm64_sysreg_add_field(SMIDR_EL1, "IMPLEMENTER", 24, 31);
+    arm64_sysreg_add_field(SMIDR_EL1, "REVISION", 16, 23);
+    arm64_sysreg_add_field(SMIDR_EL1, "SMPS", 15, 15);
+    arm64_sysreg_add_field(SMIDR_EL1, "AFFINITY", 0, 11);
+
+    /* CSSELR_EL1 */
+    ARM64SysReg *CSSELR_EL1 = arm64_sysreg_get(CSSELR_EL1_IDX);
+    CSSELR_EL1->name = "CSSELR_EL1";
+    arm64_sysreg_add_field(CSSELR_EL1, "TnD", 4, 4);
+    arm64_sysreg_add_field(CSSELR_EL1, "Level", 1, 3);
+    arm64_sysreg_add_field(CSSELR_EL1, "InD", 0, 0);
+
     /* CTR_EL0 */
     ARM64SysReg *CTR_EL0 = arm64_sysreg_get(CTR_EL0_IDX);
     CTR_EL0->name = "CTR_EL0";
@@ -37,5 +637,77 @@ void initialize_cpu_sysreg_properties(void)
     arm64_sysreg_add_field(CTR_EL0, "DminLine", 16, 19);
     arm64_sysreg_add_field(CTR_EL0, "L1Ip", 14, 15);
     arm64_sysreg_add_field(CTR_EL0, "IminLine", 0, 3);
-}
 
+    /* DCZID_EL0 */
+    ARM64SysReg *DCZID_EL0 = arm64_sysreg_get(DCZID_EL0_IDX);
+    DCZID_EL0->name = "DCZID_EL0";
+    arm64_sysreg_add_field(DCZID_EL0, "DZP", 4, 4);
+    arm64_sysreg_add_field(DCZID_EL0, "BS", 0, 3);
+
+/* For GCSPR_EL0 fields see GCSPR_ELx */
+
+/* For HFGRTR_EL2 fields see HFGxTR_EL2 */
+
+/* For HFGWTR_EL2 fields see HFGxTR_EL2 */
+
+/* For ZCR_EL2 fields see ZCR_ELx */
+
+/* For SMCR_EL2 fields see SMCR_ELx */
+
+/* For GCSCR_EL2 fields see GCSCR_ELx */
+
+/* For GCSPR_EL2 fields see GCSPR_ELx */
+
+/* For CONTEXTIDR_EL2 fields see CONTEXTIDR_ELx */
+
+/* For CPACR_EL12 fields see CPACR_EL1 */
+
+/* For ZCR_EL12 fields see ZCR_EL1 */
+
+/* For TRFCR_EL12 fields see TRFCR_EL1 */
+
+/* For SMCR_EL12 fields see SMCR_EL1 */
+
+/* For GCSCR_EL12 fields see GCSCR_EL1 */
+
+/* For GCSPR_EL12 fields see GCSPR_EL1 */
+
+/* For MPAM1_EL12 fields see MPAM1_ELx */
+
+/* For CONTEXTIDR_EL12 fields see CONTEXTIDR_EL1 */
+
+/* For TTBR0_EL1 fields see TTBRx_EL1 */
+
+/* For TTBR1_EL1 fields see TTBRx_EL1 */
+
+/* For TCR2_EL12 fields see TCR2_EL1 */
+
+/* For MAIR2_EL1 fields see MAIR2_ELx */
+
+/* For MAIR2_EL2 fields see MAIR2_ELx */
+
+/* For PIRE0_EL1 fields see PIRx_ELx */
+
+/* For PIRE0_EL12 fields see PIRE0_EL1 */
+
+/* For PIRE0_EL2 fields see PIRx_ELx */
+
+/* For PIR_EL1 fields see PIRx_ELx */
+
+/* For PIR_EL12 fields see PIR_EL1 */
+
+/* For PIR_EL2 fields see PIRx_ELx */
+
+/* For POR_EL0 fields see PIRx_ELx */
+
+/* For POR_EL1 fields see PIRx_ELx */
+
+/* For POR_EL2 fields see PIRx_ELx */
+
+/* For POR_EL12 fields see POR_EL1 */
+
+/* For S2POR_EL1 fields see PIRx_ELx */
+
+/* For S2PIR_EL2 fields see PIRx_ELx */
+
+}
-- 
2.49.0

