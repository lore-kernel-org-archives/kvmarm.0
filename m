Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994AF21ABA2
	for <kvmarm@lists.linux.dev>; Thu, 15 May 2025 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747323655; cv=none; b=fuPz5Xfd23TAuBDl0qaS3UJ1OHn4HX1lPz9l6NcW9QgEedYf6J3/9KvKTV4v/M8+x8vHxM3BufBEaUbHd0qBEmI6DwDoumqoWDjzAznZz4MKdz/GTf0nOmvDki3g2jN0ERpJiXGjz/2t1YPWVhAfKosR81ACh3VC3NPxtuakox4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747323655; c=relaxed/simple;
	bh=DQCR7nmAX1ed08wjc7lZbrEMINuAf1abQgPQ6e3IeWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Bh7djqYc6y8DaQziahNO1ymzyUQwDGQcMv9yV7W8xhq1X/AFywsz25Ou/ewFrkVIRuTRSHxqMVwDZCQCD6CcUkMC/H5Eiuh6raIFblLRgPW2q4fFRUzM7FaG/3gFQSnf5RD1Mwe0L/TTUglhSZOipTV/9+bP6YWe9KGAJVvCkzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGNu5AWh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGNu5AWh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747323652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dw/Db2xoHw22oOmtylJ530vbFmxQEouXJB1KfSoMdJ8=;
	b=ZGNu5AWhrreLS9lp31Rn+DZ0C5/iyzOQXq+SYqNBYm//tR4NdjyY5PtEtjofVIWc6ljShs
	QmTuU28msBBaKeFqVOT0V4LpxOwTHUF9I+sC23rozWmftbmwJkDyeRx0xBHJ1XzWek2X2Y
	fxTXFXpxiUgOKsaYNBBaQxJor+KGKZg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-2EaTWaaPP1-FDZuKHYhcnA-1; Thu,
 15 May 2025 11:40:49 -0400
X-MC-Unique: 2EaTWaaPP1-FDZuKHYhcnA-1
X-Mimecast-MFC-AGG-ID: 2EaTWaaPP1-FDZuKHYhcnA_1747323647
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8B86195608E;
	Thu, 15 May 2025 15:40:46 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.45.225.145])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B04CF1956066;
	Thu, 15 May 2025 15:40:40 +0000 (UTC)
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
Subject: [PATCH v7 12/14] arm/cpu: Add sysreg generation scripts
Date: Thu, 15 May 2025 17:39:05 +0200
Message-ID: <20250515153907.151174-13-cohuck@redhat.com>
In-Reply-To: <20250515153907.151174-1-cohuck@redhat.com>
References: <20250515153907.151174-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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
Reviewed-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS                           |  1 +
 scripts/gen-cpu-sysregs-header.awk    | 35 +++++++++++++++++++++++++++
 scripts/update-aarch64-sysreg-code.sh | 26 ++++++++++++++++++++
 3 files changed, 62 insertions(+)
 create mode 100755 scripts/gen-cpu-sysregs-header.awk
 create mode 100755 scripts/update-aarch64-sysreg-code.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dacd6d004dc..843a1f7bd9f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -441,6 +441,7 @@ M: Peter Maydell <peter.maydell@linaro.org>
 L: qemu-arm@nongnu.org
 S: Maintained
 F: target/arm/kvm.c
+F: scripts/*-sysreg*
 
 MIPS KVM CPUs
 M: Huacai Chen <chenhuacai@kernel.org>
diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysregs-header.awk
new file mode 100755
index 000000000000..452e51035d52
--- /dev/null
+++ b/scripts/gen-cpu-sysregs-header.awk
@@ -0,0 +1,35 @@
+#!/bin/awk -f
+# SPDX-License-Identifier: GPL-2.0-or-later
+# gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
+#
+# Usage: awk -f gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
+
+BEGIN {
+    print ""
+} END {
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
+	    print "DEF("reg", "op0", "op1", "crn", "crm", "op2")"
+	}
+	next
+}
+
+{
+	/* skip all other lines */
+	next
+}
diff --git a/scripts/update-aarch64-sysreg-code.sh b/scripts/update-aarch64-sysreg-code.sh
new file mode 100755
index 000000000000..e34538887dd8
--- /dev/null
+++ b/scripts/update-aarch64-sysreg-code.sh
@@ -0,0 +1,26 @@
+#!/bin/sh -e
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
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
+awk -f gen-cpu-sysregs-header.awk \
+    $linux/arch/arm64/tools/sysreg > ../target/arm/cpu-sysregs.h.inc
-- 
2.49.0

