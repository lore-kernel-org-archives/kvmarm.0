Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F834CFC5
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616433; cv=none; b=bmxk3S26gcZRc1n+CPj596njw478aLIijuLW66Cv0wAf8QTKyn8eyXsboYL5CmQAXOzTMLSi7Nc9F4LxNvQf+rTZVeuprSTiL2JGuaHsehlVeI4jP+E4RoBUcQYWaNMzNOBT2yFXKnY+4Dwo1wVVIT84nQsxS48K2fze/8Lzf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616433; c=relaxed/simple;
	bh=JaF/9gF9rNCCuCP30cU28vNTQmp5P8ITBidcQtJIROI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=AYTk4bI3V4mVPMkm2BMCqUn0dm6Q8zTUAQhuw0JjOU+bLd5HUpuDJSYCeO56ilH7fPKkmKN83q+eoJoGWA8Mg9FkcuuHbP8FNLBzcVJSekETLpsewJtmN0s3mgKGlzRzSFPItSbQQ/TWVU1cSN/g8IgGvqE/bbMrV77UyMXw4Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eoFVhW9+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eoFVhW9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781616429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DhixsKWT24zFPVpdhrpfzjTHfnfa7NPGnY2SIEHR/6Y=;
	b=eoFVhW9+tFUVfHYyNWysYKqNR3EkrZ47YTpDvbPsw+R3kZL2uvmYm80po14LFFA6H7ROha
	/yd/iykq2IJexqY7wJQ7hBFdZg4o5p1b0P6jZ6lBwuRHy/lFd8yQn6rcpzbS2W+4yRL2SR
	6R4ItIOFx/COg2BuU9TlM9rQJXnF5XM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-XlnVw-NVPoaBs9B9tpwVRA-1; Tue,
 16 Jun 2026 09:27:06 -0400
X-MC-Unique: XlnVw-NVPoaBs9B9tpwVRA-1
X-Mimecast-MFC-AGG-ID: XlnVw-NVPoaBs9B9tpwVRA_1781616424
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E32FE1956053;
	Tue, 16 Jun 2026 13:27:03 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C13363000203;
	Tue, 16 Jun 2026 13:26:57 +0000 (UTC)
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
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [RFC PATCH v6 04/17] arm/cpu: Add infra to handle generated ID register definitions
Date: Tue, 16 Jun 2026 15:16:51 +0200
Message-ID: <20260616132625.1732031-5-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-1-eric.auger@redhat.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: aRxI7cTxNsD9Sqh_ZEhbL1JqgMYsRaNUcINyUXTnSyo_1781616424
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce an infrastructure to store the definition of all ID regs:
This include their name, index and array of named fields.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Co-authored-by: Khushit Shah <khushit.shah@nutanix.com>

---

v5 -> v6:
- add ArmIdRegArchVal
---
 target/arm/cpu-idregs.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 target/arm/cpu-idregs.h

diff --git a/target/arm/cpu-idregs.h b/target/arm/cpu-idregs.h
new file mode 100644
index 0000000000..245f1c8103
--- /dev/null
+++ b/target/arm/cpu-idregs.h
@@ -0,0 +1,41 @@
+/*
+ * handle ID registers and their fields
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
+typedef struct ArmIdRegArchVal {
+    uint64_t value;
+    const char *name;
+} ArmIdRegArchVal;
+
+typedef struct ARM64SysRegField {
+    const char *name; /* name of the field, for instance CTR_EL0_IDC */
+    ARMIDRegisterIdx index; /* parent register, e.g. CTR_EL0_IDX */
+    int shift; /* lsb of the field in the register */
+    int length; /* highest bit number */
+    ArmIdRegArchVal *arch_vals;
+    uint32_t arch_vals_count;
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

