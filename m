Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AFB25BACF
	for <kvmarm@lists.linux.dev>; Tue, 11 Mar 2025 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741710773; cv=none; b=Ij/YRjZ7UXl6IZ9PNsefoEGPPik7ZHOznMYEfX2fcRfDDoHNqVGZROxFBGauH90IDVAOKzIuymYtxaENiHXkk3WEqtoeeeW+a5bdlTcxe1C53LDHQiLWkDSuIDPjWa8xiihIpD2DvF9sx7aVvpwyeIeErGL0d+p4lTghIzUK6GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741710773; c=relaxed/simple;
	bh=sB8DKQZxyyuOLoWHYeUX8YPn9LiZoDzUqv96SZb0p24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Szj1UpJJFG0ot5N2FkJTacs3ryEtcRcqwAuyzUy/JPU9d0WVtEio4XIr1cYIWdgH100B0XjdGV+HQZYxsgiozAJMCwOxkkCfqN9VhZvtbN85ilpg9m+VO2vzm/sgLmDZ4WRAkaPVpli0sz4+frc2BeYEHXH711TM6WV/v2oGrUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iEntSTmD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iEntSTmD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741710770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MUiBjS3COnwmRwZzukNCDF0MQ4HGMsvyipVhCLvdRu8=;
	b=iEntSTmDLP7oK45XesqJFwdcXoFsEbi3VveTp27uXSTo1deN58r4+AffyTwBuMpROXPt6P
	o/y2hsV34zoqR0mwJpB2c7TS3c9WZgkjaioxJFFi5gNMkxgjTg9twxAZRfHY5k8t4ey63X
	KxRfH0bqXYj4bxYQM29W7Fet2x/Aobo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-jpkppMDMMtiL7FEpZ6ojpw-1; Tue,
 11 Mar 2025 12:32:43 -0400
X-MC-Unique: jpkppMDMMtiL7FEpZ6ojpw-1
X-Mimecast-MFC-AGG-ID: jpkppMDMMtiL7FEpZ6ojpw_1741710761
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E01D51809CA3;
	Tue, 11 Mar 2025 16:32:40 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.67.24.185])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C07C1800373;
	Tue, 11 Mar 2025 16:32:25 +0000 (UTC)
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
Subject: [PATCH v3 14/14] arm/cpu: switch to a generated cpu-sysregs.h.inc
Date: Tue, 11 Mar 2025 17:28:24 +0100
Message-ID: <20250311162824.199721-15-cohuck@redhat.com>
In-Reply-To: <20250311162824.199721-1-cohuck@redhat.com>
References: <20250311162824.199721-1-cohuck@redhat.com>
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
 target/arm/cpu-sysregs.h.inc | 161 ++++++++++++++++++++++++++++++++---
 1 file changed, 148 insertions(+), 13 deletions(-)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index 6c9f9981cc5d..a3829f40d3da 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,18 +1,14 @@
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
+
+DEF(OSDTRRX_EL1, 2, 0, 0, 0, 2)
+DEF(MDCCINT_EL1, 2, 0, 0, 2, 0)
+DEF(MDSCR_EL1, 2, 0, 0, 2, 2)
+DEF(OSDTRTX_EL1, 2, 0, 0, 3, 2)
+DEF(OSECCR_EL1, 2, 0, 0, 6, 2)
+DEF(OSLAR_EL1, 2, 0, 1, 0, 4)
 DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
 DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
 DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
+DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
 DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
 DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
 DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
@@ -23,13 +19,152 @@ DEF(ID_ISAR2_EL1, 3, 0, 0, 2, 2)
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
+DEF(SCTLR_EL1, 3, 0, 1, 0, 0)
+DEF(CPACR_EL1, 3, 0, 1, 0, 2)
+DEF(TRFCR_EL1, 3, 0, 1, 2, 1)
+DEF(SMPRI_EL1, 3, 0, 1, 2, 4)
+DEF(ZCR_EL1, 3, 0, 1, 2, 0)
+DEF(SMCR_EL1, 3, 0, 1, 2, 6)
+DEF(GCSCR_EL1, 3, 0, 2, 5, 0)
+DEF(GCSPR_EL1, 3, 0, 2, 5, 1)
+DEF(GCSCRE0_EL1, 3, 0, 2, 5, 2)
+DEF(ALLINT, 3, 0, 4, 3, 0)
+DEF(FAR_EL1, 3, 0, 6, 0, 0)
+DEF(PMICNTR_EL0, 3, 3, 9, 4, 0)
+DEF(PMICFILTR_EL0, 3, 3, 9, 6, 0)
+DEF(PMSCR_EL1, 3, 0, 9, 9, 0)
+DEF(PMSNEVFR_EL1, 3, 0, 9, 9, 1)
+DEF(PMSICR_EL1, 3, 0, 9, 9, 2)
+DEF(PMSIRR_EL1, 3, 0, 9, 9, 3)
+DEF(PMSFCR_EL1, 3, 0, 9, 9, 4)
+DEF(PMSEVFR_EL1, 3, 0, 9, 9, 5)
+DEF(PMSLATFR_EL1, 3, 0, 9, 9, 6)
+DEF(PMSIDR_EL1, 3, 0, 9, 9, 7)
+DEF(PMBLIMITR_EL1, 3, 0, 9, 10, 0)
+DEF(PMBPTR_EL1, 3, 0, 9, 10, 1)
+DEF(PMBSR_EL1, 3, 0, 9, 10, 3)
+DEF(PMBIDR_EL1, 3, 0, 9, 10, 7)
+DEF(PMUACR_EL1, 3, 0, 9, 14, 4)
+DEF(PMSELR_EL0, 3, 3, 9, 12, 5)
+DEF(CONTEXTIDR_EL1, 3, 0, 13, 0, 1)
+DEF(RCWSMASK_EL1, 3, 0, 13, 0, 3)
+DEF(TPIDR_EL1, 3, 0, 13, 0, 4)
+DEF(RCWMASK_EL1, 3, 0, 13, 0, 6)
+DEF(SCXTNUM_EL1, 3, 0, 13, 0, 7)
+DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
+DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
+DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
+DEF(GMID_EL1, 3, 1, 0, 0, 4)
+DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
+DEF(CSSELR_EL1, 3, 2, 0, 0, 0)
 DEF(CTR_EL0, 3, 3, 0, 0, 1)
+DEF(DCZID_EL0, 3, 3, 0, 0, 7)
+DEF(GCSPR_EL0, 3, 3, 2, 5, 1)
+DEF(SVCR, 3, 3, 4, 2, 2)
+DEF(FPMR, 3, 3, 4, 4, 2)
+DEF(MDCR_EL2, 3, 4, 1, 1, 1)
+DEF(HFGRTR_EL2, 3, 4, 1, 1, 4)
+DEF(HFGWTR_EL2, 3, 4, 1, 1, 5)
+DEF(HFGITR_EL2, 3, 4, 1, 1, 6)
+DEF(TRFCR_EL2, 3, 4, 1, 2, 1)
+DEF(HDFGRTR_EL2, 3, 4, 3, 1, 4)
+DEF(HDFGWTR_EL2, 3, 4, 3, 1, 5)
+DEF(HAFGRTR_EL2, 3, 4, 3, 1, 6)
+DEF(ZCR_EL2, 3, 4, 1, 2, 0)
+DEF(HCRX_EL2, 3, 4, 1, 2, 2)
+DEF(SMPRIMAP_EL2, 3, 4, 1, 2, 5)
+DEF(SMCR_EL2, 3, 4, 1, 2, 6)
+DEF(GCSCR_EL2, 3, 4, 2, 5, 0)
+DEF(GCSPR_EL2, 3, 4, 2, 5, 1)
+DEF(DACR32_EL2, 3, 4, 3, 0, 0)
+DEF(FAR_EL2, 3, 4, 6, 0, 0)
+DEF(PMSCR_EL2, 3, 4, 9, 9, 0)
+DEF(MPAMHCR_EL2, 3, 4, 10, 4, 0)
+DEF(MPAMVPMV_EL2, 3, 4, 10, 4, 1)
+DEF(MPAM2_EL2, 3, 4, 10, 5, 0)
+DEF(MPAMVPM0_EL2, 3, 4, 10, 6, 0)
+DEF(MPAMVPM1_EL2, 3, 4, 10, 6, 1)
+DEF(MPAMVPM2_EL2, 3, 4, 10, 6, 2)
+DEF(MPAMVPM3_EL2, 3, 4, 10, 6, 3)
+DEF(MPAMVPM4_EL2, 3, 4, 10, 6, 4)
+DEF(MPAMVPM5_EL2, 3, 4, 10, 6, 5)
+DEF(MPAMVPM6_EL2, 3, 4, 10, 6, 6)
+DEF(MPAMVPM7_EL2, 3, 4, 10, 6, 7)
+DEF(CONTEXTIDR_EL2, 3, 4, 13, 0, 1)
+DEF(CNTPOFF_EL2, 3, 4, 14, 0, 6)
+DEF(CPACR_EL12, 3, 5, 1, 0, 2)
+DEF(ZCR_EL12, 3, 5, 1, 2, 0)
+DEF(TRFCR_EL12, 3, 5, 1, 2, 1)
+DEF(SMCR_EL12, 3, 5, 1, 2, 6)
+DEF(GCSCR_EL12, 3, 5, 2, 5, 0)
+DEF(GCSPR_EL12, 3, 5, 2, 5, 1)
+DEF(FAR_EL12, 3, 5, 6, 0, 0)
+DEF(MPAM1_EL12, 3, 5, 10, 5, 0)
+DEF(CONTEXTIDR_EL12, 3, 5, 13, 0, 1)
+DEF(TTBR0_EL1, 3, 0, 2, 0, 0)
+DEF(TTBR1_EL1, 3, 0, 2, 0, 1)
+DEF(TCR2_EL1, 3, 0, 2, 0, 3)
+DEF(TCR2_EL12, 3, 5, 2, 0, 3)
+DEF(TCR2_EL2, 3, 4, 2, 0, 3)
+DEF(MAIR2_EL1, 3, 0, 10, 2, 1)
+DEF(MAIR2_EL2, 3, 4, 10, 1, 1)
+DEF(AMAIR2_EL1, 3, 0, 10, 3, 1)
+DEF(AMAIR2_EL2, 3, 4, 10, 3, 1)
+DEF(PIRE0_EL1, 3, 0, 10, 2, 2)
+DEF(PIRE0_EL12, 3, 5, 10, 2, 2)
+DEF(PIRE0_EL2, 3, 4, 10, 2, 2)
+DEF(PIR_EL1, 3, 0, 10, 2, 3)
+DEF(PIR_EL12, 3, 5, 10, 2, 3)
+DEF(PIR_EL2, 3, 4, 10, 2, 3)
+DEF(POR_EL0, 3, 3, 10, 2, 4)
+DEF(POR_EL1, 3, 0, 10, 2, 4)
+DEF(POR_EL2, 3, 4, 10, 2, 4)
+DEF(POR_EL12, 3, 5, 10, 2, 4)
+DEF(S2POR_EL1, 3, 0, 10, 2, 5)
+DEF(S2PIR_EL2, 3, 4, 10, 2, 5)
+DEF(LORSA_EL1, 3, 0, 10, 4, 0)
+DEF(LOREA_EL1, 3, 0, 10, 4, 1)
+DEF(LORN_EL1, 3, 0, 10, 4, 2)
+DEF(LORC_EL1, 3, 0, 10, 4, 3)
+DEF(MPAMIDR_EL1, 3, 0, 10, 4, 4)
+DEF(LORID_EL1, 3, 0, 10, 4, 7)
+DEF(MPAM1_EL1, 3, 0, 10, 5, 0)
+DEF(MPAM0_EL1, 3, 0, 10, 5, 1)
+DEF(ISR_EL1, 3, 0, 12, 1, 0)
+DEF(ICC_NMIAR1_EL1, 3, 0, 12, 9, 5)
+DEF(TRBLIMITR_EL1, 3, 0, 9, 11, 0)
+DEF(TRBPTR_EL1, 3, 0, 9, 11, 1)
+DEF(TRBBASER_EL1, 3, 0, 9, 11, 2)
+DEF(TRBSR_EL1, 3, 0, 9, 11, 3)
+DEF(TRBMAR_EL1, 3, 0, 9, 11, 4)
+DEF(TRBTRG_EL1, 3, 0, 9, 11, 6)
+DEF(TRBIDR_EL1, 3, 0, 9, 11, 7)
+
-- 
2.48.1

