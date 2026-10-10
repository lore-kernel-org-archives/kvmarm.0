Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DE03CFF72
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639496; cv=none; b=bC8vE2Gg4eJajw75HO50ooBYjavuMI0fWZSJuOdKYyF8INs3FbeQOTkGHqOB/41dYucyk+vmM3wX7BbTBntuxUkQl2WKyTxHdqHOD766UxXp2oqJxpE/tR5NkeHs97NoEW3/AFiWAV1d3ehW4/0EGG/8HZopFBzh/RirkvG/0gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639496; c=relaxed/simple;
	bh=R/EEPZM5lGcAcSQHbj+BeqQASVOf5dJIvH/ZSsapym0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lAmmnsu7FYl5TX/G0cjI++yBw0mHOeCULxZhcAV30+lgwml+9+3IZ0zeXAp7kCTEVfV+dtr1Ps+gA8Uph0QOoLIuwkHuDHjsthYg7Csru6vTmvyGSDPoIxB7ytfo6cLCSUq+PUkyutoUgM9ZTuUwIuc8Qoi8LB6fo8NyJ5mtef4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dvo96i7V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dvo96i7V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ndOYHicgpkf8J4BJA1GdVtzODpq198mdZFqFo2vB6hU=;
	b=Dvo96i7VReiIUWjbdNHSCOHRINGScwU0uh6r981ljyblgJ+a/Qn9xFy4/Fs3YPX5HlxvnR
	mLMAmoLO3IFDNoCCASx1y6QE5UkzOo/k5tz4P1fItIP/oHyi6FwrM/pnMGa8BLQfgPS324
	EY7t4SlvTPEhTW0DAE3J/XaXGXa/a9k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-wGnPjsC8MuCGi3ChAOznRw-1; Sat,
 10 Oct 2026 13:38:02 +0000
X-MC-Unique: wGnPjsC8MuCGi3ChAOznRw-1
X-Mimecast-MFC-AGG-ID: wGnPjsC8MuCGi3ChAOznRw_1791639480
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CAC01944B11;
	Sat, 10 Oct 2026 13:38:00 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8DD1130000E5;
	Sat, 10 Oct 2026 13:37:55 +0000 (UTC)
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
Subject: [PATCH v10 05/26] arm/cpu: Add infra to handle generated ID register definitions
Date: Sat, 10 Oct 2026 15:36:09 +0200
Message-ID: <20261010133725.642498-6-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 2ielivMAkAo9Eph-gs5oKTzqJfwgz7Ys_fiqBXXu0pM_1791639480
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce an infrastructure to store the definition of all ID regs:
This include their name, index array of named fields and enum values
if any.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>

---
v9 -> v10:
- commit description and comment slight rewording
- store RangeValues instead of Values

v7 -> v8:
- remove typedef struct ArmIdRegArchVal

v5 -> v6:
- add ArmIdRegArchVal
---
 target/arm/cpu-idregs.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 target/arm/cpu-idregs.h

diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
new file mode 100644
index 0000000000..e0399e251b
--- /dev/null
+++ b/target/arm/cpu-idregs.h
@@ -0,0 +1,41 @@
+/*
+ * ID registers and their field definition
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#ifndef TARGET_ARM_CPU_IDREGS_H
+#define TARGET_ARM_CPU_IDREGS_H
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "cpu.h"
+#include "cpu-sysregs.h"
+
+typedef struct ARM64SysRegArchValueRange {
+    uint64_t lo;
+    uint64_t hi;
+} ARM64SysRegArchValueRange;
+
+typedef struct ARM64SysRegField {
+    const char *name; /* name of the field, for instance CTR_EL0_IDC */
+    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
+    int shift; /* lsb of the field in the register */
+    int length; /* highest bit number */
+    const ARM64SysRegArchValueRange *arch_value_ranges;
+    uint32_t arch_value_ranges_count;
+} ARM64SysRegField;
+
+typedef struct ARM64SysReg {
+    const char *name;   /* name of the sysreg, for instance CTR_EL0 */
+    ARMIDRegisterIdx index; /* register index, e.g. CTR_EL0_IDX */
+    struct ARM64SysRegField *fields;
+    uint32_t fields_count;
+    uint64_t writable_mask;
+} ARM64SysReg;
+
+/*
+ * List of exposed ID regs (automatically populated from AARCHMRS Registers.json)
+ */
+extern ARM64SysReg arm64_id_regs[NUM_ID_IDX];
+
+#endif
-- 
2.53.0

