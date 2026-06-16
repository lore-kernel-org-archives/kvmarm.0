Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A733067F
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 13:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616428; cv=none; b=YGM1qh4XO7MxgzIWVa6+nKjg2NpaqzE1L6qPmF5iBTFatOi2FBlFwz9XB9zdM1aCz8E18mybzqxqPbUciIo12Wcymab1AMp0KFI6UPOyDNVlbZZjCAJixcE3MTBM3TOrFE0X6VkPnC2t9ndl39KdNXID7oeSYeN6FS3b3qBH87Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616428; c=relaxed/simple;
	bh=ZD5lqbxbqSPi8tqka098rH/KRcDTrWnbfcAfkAtok/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=LrlBbDkAq322bhRx86J8oTAf9U0UH6twyUIOK/NqNZznvLThOwunW9SIOKBq+IIrakAXqdZPqiokkwG0aj8QTe7l6OWNHOT/vC7psgyqQ1xV63JoSX+XA2wjdF8qEvgQWd1GbyA8yQQgMFcIaENRG1VQlrmHX5/V+lFzrBaMKog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c6l0Nxf3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c6l0Nxf3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781616423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Q1MRRO+oFa8DFbRumsxnZz4i4gGeVWxNqhJGe6XFoQ=;
	b=c6l0Nxf3pIXW8PasR53NNsRZmdtTkp1KtQWJRVFnDi63vZUqefjr7/YANqdiXbU1NEoNNH
	U/VczCXC0nZq7tg5S7gmV+dgPRnnMt+90wIBpHK2yY2GbBoHFSV+Fkwc9mh0pNY3JPeJOA
	jhO8cpkM4MrVuP93LMUuEfikvZxKRMQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-116-qba89ywpOZ6xb42AmoUREg-1; Tue,
 16 Jun 2026 09:26:59 -0400
X-MC-Unique: qba89ywpOZ6xb42AmoUREg-1
X-Mimecast-MFC-AGG-ID: qba89ywpOZ6xb42AmoUREg_1781616417
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4795E1805A3C;
	Tue, 16 Jun 2026 13:26:57 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.30])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CB2B63000203;
	Tue, 16 Jun 2026 13:26:50 +0000 (UTC)
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
Subject: [RFC PATCH v6 03/17] target/arm/cpu-sysregs.h.inc: Update with automatic generation
Date: Tue, 16 Jun 2026 15:16:50 +0200
Message-ID: <20260616132625.1732031-4-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-1-eric.auger@redhat.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: d0xgt2AZ2IbBMruItmYLfMlMnwMdbtMtZ_mICMygXfw_1781616417
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
 target/arm/cpu-sysregs.h.inc | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index ec5a12b0f4..2188cd7be0 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,11 +1,20 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-header.py */
+/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
+
+DEF(AIDR_EL1, 3, 1, 0, 0, 7)
+DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
+DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
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
@@ -40,6 +49,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
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

