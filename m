Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A4639DBF4
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737106; cv=none; b=gKlclwCD8wjVJBRB8pGH5CTSlDYInslhTB86jeRjM8C6J8on94fkimI1gcNG4HljBogD08lVyv13nK0ELs30pjtC2ORI10+QyQ6Oy8DfITyfTzUuBuACM4njLpN3Rz/6AhvZL4tVVQYQgOyZOi94WTp+dr8JEndzyXIYT9V1tBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737106; c=relaxed/simple;
	bh=ewgOZCWQeGzPofoaX+GIZ33sYnT4SdqUI/O5Nm6UwLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=FpCBgNKDYgOPuvKNH/V1Hw5MxMV7EqXqQUkS1kGDqBkLXcUYNQ0rEBDfYgkH+BaRG5DE1vcUUDV8ZsHDy81VE1vla52JoZtfDDooHUbub5XXRJztyRTnu5xzSVEB6OpnXIEbnFsKhL8NjtLvut5byz+KEm6vfSPPel0AEA8ZSlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WfzwRYUD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfzwRYUD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voHwf+YFtdVEzgBWVvYQX13hhjEDTySDg3UzKLNi7tE=;
	b=WfzwRYUDl1kR0psX6PI50UTSLnLZ8aFteKeGrHzk4YyxlCs8cCyzimv2yjtLikvBkiDRVn
	4diLHJxVamslfRgVWqdnE10t6jYqsn+DUKwLm4+U5c2p8A+X3JHTzxTrsK7mWPAe+diHtK
	KTncad/Y7+KhlGiXZqPeojRe5o5s+mc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-8yYWgmCUNd2QPisvDYomOw-1; Wed,
 26 Aug 2026 05:38:19 -0400
X-MC-Unique: 8yYWgmCUNd2QPisvDYomOw-1
X-Mimecast-MFC-AGG-ID: 8yYWgmCUNd2QPisvDYomOw_1787737097
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D47091828AB0;
	Wed, 26 Aug 2026 09:38:16 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8FC341955F05;
	Wed, 26 Aug 2026 09:38:10 +0000 (UTC)
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
Subject: [RFC PATCH v8 03/20] target/arm/cpu-sysregs.h.inc: Update with automatic generation
Date: Wed, 26 Aug 2026 11:36:08 +0200
Message-ID: <20260826093747.1670077-4-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: L3UuWSnNQraXg7cqlntQk2Ns7ohpKnKNPhJGsptEw44_1787737097
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Generated definitions with scripts/update-aarch64-cpu-sysregs-header.py
based on "AARCHMRS containing the JSON files for Arm A-profile
architecture (2026-03)" Registers.json file.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
---
 target/arm/cpu-sysregs.h.inc | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index ec5a12b0f4..8b77c490d4 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,11 +1,18 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-header.py */
+/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
+
+DEF(AIDR_EL1, 3, 1, 0, 0, 7)
 DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
 DEF(CTR_EL0, 3, 3, 0, 0, 1)
 DEF(DCZID_EL0, 3, 3, 0, 0, 7)
+DEF(GMID_EL1, 3, 1, 0, 0, 4)
 DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
 DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
 DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
 DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
+DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
 DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
 DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
 DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
@@ -40,6 +47,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
 DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
 DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
 DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
+DEF(MIDR_EL1, 3, 0, 0, 0, 0)
+DEF(MPIDR_EL1, 3, 0, 0, 0, 5)
 DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
 DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
 DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
+DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
+DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
-- 
2.53.0

