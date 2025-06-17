Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4031420F090
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174874; cv=none; b=hHaOgMwc6WSxj/yapc4pdf5E5LwjQbpSdW8QgR8mfKAFEF/f4NoGP3hm0qJwCQrIxSJuRXoK7A4Fg2tElL0hDST67xIiCGhp48M1LI3ZlVQRYXaNSLUGlOD2lb/tQQnNJL/jfDo3dCD+Cz47GHaCeRJu9lh5zYkCnyHhUNyPCvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174874; c=relaxed/simple;
	bh=5Lwasau4CsIyAEnjkQdV97qmpiKRB7dzX1mVkC/P1ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=G4xTtl3jUQ6GeS/4YVs6nEdix/Cd/b8dEKUvk63NjCRDXgjg1W40+QyTrVdHSDpiAcHlPMu+Gn/Ut6TXlr836yuvnRKpdmWZypUs92QfbkTqj8aBf/6i7f0wc7EeUXRJOrV6EOivdnd6vaOFTqdcwfCCMXDdM/g8eI2cQJMlLPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bEeC3+Xs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEeC3+Xs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750174872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbxMR4zpyo3J6LniePBWyJnj/wYIipfJzeHg05b32x8=;
	b=bEeC3+XsqVVJ+DWqQ5u5Nhr7HcHm6PFBv09qdigkmBLwbNpHDS4p+diBOmGkFKYYh6UcVr
	Z0kqTtsECdk1zKeIEHIIHibYRJ5fU7bJCjuS5i21QeBnMBdl5N9uljiSHZ400JHtrqjY/4
	uBD3yk5RJPGwBHLpPLcx1+4x1GYUh+Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-FaV9E22xOnSpzilSqE6qkw-1; Tue,
 17 Jun 2025 11:41:08 -0400
X-MC-Unique: FaV9E22xOnSpzilSqE6qkw-1
X-Mimecast-MFC-AGG-ID: FaV9E22xOnSpzilSqE6qkw_1750174866
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 234ED1828AC6;
	Tue, 17 Jun 2025 15:41:06 +0000 (UTC)
Received: from gondolin.str.redhat.com (pixel-6a.str.redhat.com [10.33.192.205])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4739E180035C;
	Tue, 17 Jun 2025 15:41:00 +0000 (UTC)
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
Subject: [PATCH v8 13/14] arm/cpu: switch to a generated cpu-sysregs.h.inc
Date: Tue, 17 Jun 2025 17:39:30 +0200
Message-ID: <20250617153931.1330449-14-cohuck@redhat.com>
In-Reply-To: <20250617153931.1330449-1-cohuck@redhat.com>
References: <20250617153931.1330449-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Generated against Linux 6.15.

Reviewed-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysregs.h.inc | 43 +++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index cb99286f7048..1dddd3d357eb 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,19 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
-DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
-DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
-DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
-DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
-DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
-DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
-DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
-DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
-DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
-DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
-DEF(ID_AA64MMFR3_EL1, 3, 0, 0, 7, 3)
+/* GENERATED FILE, DO NOT EDIT */
+/* use arm-gen-cpu-sysregs-header.awk to regenerate */
 DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
 DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
 DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
+DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
 DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
 DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
 DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
@@ -24,13 +15,39 @@ DEF(ID_ISAR2_EL1, 3, 0, 0, 2, 2)
 DEF(ID_ISAR3_EL1, 3, 0, 0, 2, 3)
 DEF(ID_ISAR4_EL1, 3, 0, 0, 2, 4)
 DEF(ID_ISAR5_EL1, 3, 0, 0, 2, 5)
-DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
 DEF(ID_ISAR6_EL1, 3, 0, 0, 2, 7)
+DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
 DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
 DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
 DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
 DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
 DEF(ID_DFR1_EL1, 3, 0, 0, 3, 5)
 DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
+DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
+DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
+DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
 DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
+DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
+DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
+DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
+DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
+DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
+DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
+DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
+DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
+DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
+DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
+DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
+DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
+DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
+DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
+DEF(ID_AA64MMFR3_EL1, 3, 0, 0, 7, 3)
+DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)
+DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
+DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
+DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
+DEF(GMID_EL1, 3, 1, 0, 0, 4)
+DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
 DEF(CTR_EL0, 3, 3, 0, 0, 1)
+DEF(DCZID_EL0, 3, 3, 0, 0, 7)
+
-- 
2.49.0

