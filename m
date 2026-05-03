Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CCB1A9B24
	for <kvmarm@lists.linux.dev>; Sun,  3 May 2026 07:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777793777; cv=none; b=cPNMwFxjzL2rJAuDbHkvNDgr4kAsb+PPn5nNIC7mmDtAjf8BsRtLZ0HOXI6ijMKGksdJi9kuV/U7E3UkrtmkRS0zDiMe+3z9rcvcnUQoVJwoTo3+M8g+fDTpds/DPR6zh4t/hB3UepRwkHbX746NmN2k9G8TtkWLwCd2EyV1ctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777793777; c=relaxed/simple;
	bh=7Gv2/n81N+ravNi/FoLtXmOK4c1vk+cK7TjMvlPX5UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=H6hCM9TRyJOsBgbue4J2od5hXHfe1YXJSJ3VoHHo43qoctNUHwiGr/RNq0OaUE1xONHCo75Xz7EOGGsrq3UROs3aLtFrBkLXx4ercK1zpTHdDdZU9JscFoN9bMddudcDBnZxHIoIsXb2AmEWx25U0TphF9hXr+VB+5xHRwxxVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQKemzWV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQKemzWV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777793775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JNxvgPjTK7K7Hh6VWcUTM1XEmH4nJagmC+vCCbG+wug=;
	b=HQKemzWVc9h1FuzRDFbiktBapW+ZntbB2owfAKKiJlhQtcmLdiHEic5ajM093gJvRDKCzs
	fd/uMbzAceIzKs7ZOHm+zirAv5qGq6ERJgrkUh3Fw1/RtC82LVS2QOBlVC82UtCAVgjMC3
	n1NKY3TZFnqq82PB4LvXc05F6uzuqs4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-YOcK5gbcO2CNyHxuFv6eSQ-1; Sun,
 03 May 2026 03:36:12 -0400
X-MC-Unique: YOcK5gbcO2CNyHxuFv6eSQ-1
X-Mimecast-MFC-AGG-ID: YOcK5gbcO2CNyHxuFv6eSQ_1777793770
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A60361800350;
	Sun,  3 May 2026 07:36:10 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 201021800480;
	Sun,  3 May 2026 07:36:04 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	cohuck@redhat.com,
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
Subject: [PATCH v4 03/17] target/arm/cpu-sysregs.h.inc: Update with automatic generation
Date: Sun,  3 May 2026 09:33:23 +0200
Message-ID: <20260503073541.790215-4-eric.auger@redhat.com>
In-Reply-To: <20260503073541.790215-1-eric.auger@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: UgSKd8TW-EAl1tWGtcBJauWRTMuWSqsePopx5FGpqic_1777793770
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Generated definitions with scripts/update-aarch64-cpu-sysregs-header.py
based on "AARCHMRS containing the JSON files for Arm A-profile
architecture (2026-03)" Registers.json file.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Message-ID: <20251208163751.611186-4-eric.auger@redhat.com>
---
 target/arm/cpu-sysregs.h.inc | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index d61f0d0a19..2188cd7be0 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,15 +1,25 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-header.py */
+/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
+
+DEF(AIDR_EL1, 3, 1, 0, 0, 7)
+DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
 DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
 DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
 DEF(CTR_EL0, 3, 3, 0, 0, 1)
 DEF(DCZID_EL0, 3, 3, 0, 0, 7)
+DEF(GMID_EL1, 3, 1, 0, 0, 4)
 DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
 DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
 DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
 DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
+DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
+DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
 DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
 DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
 DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
+DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
 DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
 DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
 DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
@@ -39,6 +49,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
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

