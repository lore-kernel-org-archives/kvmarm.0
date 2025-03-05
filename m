Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEA724BC0B
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 16:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192943; cv=none; b=Wk9pjA1CmYeZ2+hGOJKVq2LtL5QDsBq6zSipVhCLlwVmmmuteDd5RUupr/crxILkSKAIseZUzuTKa+Pgn7JSH+qg6UqhVELLhZNRuAhWdHTbzP+Z8nuetHqNr4oGtr7Q4MC6rr8bHPI6st7h1KK43YWJqmJKtobo01SAyUty81I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192943; c=relaxed/simple;
	bh=6J90doyOefgqtm17seczzS8oOnwYQbaJNWiVUBXqZkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=a3myUlwYdxqkU7+Wu9iaxI+ZrpKjiY3l9NcXTHd4Nu5W2R9xR78rzYzL7V/hu729rWdYQbWUU5VxdjB4SjLRRo92nInrD3DV6trfMBVPZ8aLh708Dt1niXpfOFzNpHi1McKixOL8kd240xIvMTTmnIKN30ua425eFeW/jFhf/ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUcL5ch+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUcL5ch+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741192940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FC4UbF4F42Zk1lANeuJySWt0Klm/3oNM+IlRRNUTvBc=;
	b=RUcL5ch+dszlSsjMlH1ijfiuWi6KiwItVUzXXJ8aKIVV4h9W8e8gWLBWrF2TLmkaPWlobJ
	A1qbPavQ5OdgtQet2aGPQD5QPw/sOr3MRqLn2ohCK1Jga+I2weCT4Xwa5Df5mMrHlrWj3b
	8eZZKFbvUpoI/lY0BQwBdBUEeTcgYHM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-qvmy90P1N0O2c-gPkGuTHg-1; Wed,
 05 Mar 2025 11:42:17 -0500
X-MC-Unique: qvmy90P1N0O2c-gPkGuTHg-1
X-Mimecast-MFC-AGG-ID: qvmy90P1N0O2c-gPkGuTHg_1741192935
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B449A1956050;
	Wed,  5 Mar 2025 16:42:14 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.9])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1E9621955DDE;
	Wed,  5 Mar 2025 16:41:59 +0000 (UTC)
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
	jdenemar@redhat.com,
	agraf@csgraf.de
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 13/14] arm/cpu: Add sysreg generation scripts
Date: Wed,  5 Mar 2025 17:38:18 +0100
Message-ID: <20250305163819.2477553-14-cohuck@redhat.com>
In-Reply-To: <20250305163819.2477553-1-cohuck@redhat.com>
References: <20250305163819.2477553-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Eric Auger <eric.auger@redhat.com>

Introduce scripts that automate the generation of system register
definitions from a given linux source tree arch/arm64/tools/sysreg.

Invocation of
./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
in scripts directory generates target/arm/cpu-sysregs.h.inc
containing defines for all system registers.

[CH: update to handle current kernel sysregs structure, and to emit
     the re-worked register structures; cpu properties will be added
     later]
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 scripts/gen-cpu-sysregs-header.awk    | 70 +++++++++++++++++++++++++++
 scripts/update-aarch64-sysreg-code.sh | 35 ++++++++++++++
 2 files changed, 105 insertions(+)
 create mode 100755 scripts/gen-cpu-sysregs-header.awk
 create mode 100755 scripts/update-aarch64-sysreg-code.sh

diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysregs-header.awk
new file mode 100755
index 000000000000..27a222856a84
--- /dev/null
+++ b/scripts/gen-cpu-sysregs-header.awk
@@ -0,0 +1,70 @@
+#!/bin/awk -f
+# SPDX-License-Identifier: GPL-2.0
+# gen-cpu-sysregs-header.awk: arm64 sysreg header generator
+#
+# Usage: awk -f gen-cpu-sysregs-header.awk -- -v structure=xxx $LINUX_PATH/arch/arm64/tools/sysreg
+# where structure is one of "idx" "reg" "table"
+
+BEGIN {
+    print ""
+    if (structure == "idx") {
+	print "typedef enum ARMIDRegisterIdx {"
+    }
+    if (structure == "reg") {
+	print "typedef enum ARMSysRegs {"
+    }
+    if (structure == "table") {
+	print "static const uint32_t id_register_sysreg[NUM_ID_IDX] = {"
+    }
+} END {
+    if (structure == "idx") {
+	print "    NUM_ID_IDX,"
+	print "} ARMIDRegisterIdx;"
+    }
+    if (structure == "reg") {
+	print "} ARMSysRegs;"
+    }
+    if (structure == "table") {
+	print "};"
+    }
+    print ""
+}
+
+# skip blank lines and comment lines
+/^$/ { next }
+/^[\t ]*#/ { next }
+
+/^Sysreg\t/ || /^Sysreg /{
+
+	reg = $2
+	op0 = $3
+	op1 = $4
+	crn = $5
+	crm = $6
+	op2 = $7
+
+	if (op0 == 3 && (op1>=0 && op1<=3) && crn==0 && (crm>=0 && crm<=7) && (op2>=0 && op2<=7)) {
+	    idreg = 1
+        } else {
+	    idreg = 0
+	}
+
+	if (idreg) {
+	    if (structure == "idx") {
+		print "    "reg"_IDX,"
+	    }
+	    if (structure == "reg") {
+		print "    SYS_"reg" = ENCODE_ID_REG("op0", "op1", "crn", "crm", "op2"),"
+	    }
+	    if (structure == "table") {
+		print "    ["reg"_IDX] = SYS_"reg","
+	    }
+	}
+
+	next
+}
+
+{
+	/* skip all other lines */
+	next
+}
diff --git a/scripts/update-aarch64-sysreg-code.sh b/scripts/update-aarch64-sysreg-code.sh
new file mode 100755
index 000000000000..01762c620556
--- /dev/null
+++ b/scripts/update-aarch64-sysreg-code.sh
@@ -0,0 +1,35 @@
+#!/bin/sh -e
+#
+# Update target/arm/cpu-sysregs.h
+# from a linux source tree (arch/arm64/tools/sysreg)
+#
+# Copyright Red Hat, Inc. 2024
+#
+# Authors:
+#          Eric Auger <eric.auger@redhat.com>
+#
+
+linux="$1"
+output="$PWD"
+
+if [ -z "$linux" ] || ! [ -d "$linux" ]; then
+    cat << EOF
+usage: update-aarch64-sysreg-code.sh LINUX_PATH
+
+LINUX_PATH      Linux kernel directory to obtain the headers from
+EOF
+    exit 1
+fi
+
+            cat <<EOF >../target/arm/cpu-sysregs.h.inc
+/* GENERATED FILE -- DO NOT EDIT */
+#ifndef ARCH_ARM_CPU_SYSREGS_H_INC
+#define ARCH_ARM_CPU_SYSREGS_H_INC
+EOF
+
+for structure in "idx" "reg" "table"; do
+    awk -f gen-cpu-sysregs-header.awk -v structure="$structure"\
+       $linux/arch/arm64/tools/sysreg >> ../target/arm/cpu-sysregs.h.inc
+done
+
+echo "#endif /* ARCH_ARM_CPU_SYSREGS_H_INC */" >> ../target/arm/cpu-sysregs.h.inc
-- 
2.48.1

