Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C7F30D40E
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570070; cv=none; b=llnnGuWWwazylkgFYnKz4iogTHg14WeP8TOc/pDnNNfNWZlGqqDJ1htp0sx8U9vnS198bal2IynvkngQDW1eX8sXevZ+v0FwYRYLxzOoMStaoGJy9CImMJ4++ba69aecfUVUtjOL+jW9t+N854uMDI88ncyzG/D+YiEzRaC0YgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570070; c=relaxed/simple;
	bh=tWkfEVnHeMe3m7YO6dFAB88P/dOx+gluuMLx+2/QJAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PaJFmfD9fPxPa1e6u7jb850efGyXydLbWZnM+O7M8YS12z0cGQkoJswXNbGQn8Q2vaofJIHvr071+MfQR4DT6jGFbex/9TxwLaFTpOFGHSfGrPChl2udU7+RAz6wgMMT4BdvwT+4VRd2g7ApuJ80WOVzyagpQ3fuiUi0CXr87gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8WPXZej; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8WPXZej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PGwhGSRwbZ5oBDYs0gjQNDzMSLjGv9rxTmsKdTjHBlA=;
	b=i8WPXZejQ5uOw2dHU5jCGeLgsL+Tydf1GTW1jg5dsFM9naXyRAmnSBVPf6kp5Ks4/VWDVm
	oVz61+kKb8lHK5I6+leE81TrmLknorGezMwVf76Kf3CsVzVwxtRzsh3SxfYci1CUki611c
	uGxNnD1CJDCTxnI5G6GXvSVSTU9PzYI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-LJ-J0ZNQO-SjI1h2Oj59tQ-1; Wed,
 16 Sep 2026 10:47:44 -0400
X-MC-Unique: LJ-J0ZNQO-SjI1h2Oj59tQ-1
X-Mimecast-MFC-AGG-ID: LJ-J0ZNQO-SjI1h2Oj59tQ_1789570062
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D10C1944B3A;
	Wed, 16 Sep 2026 14:47:42 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 22A1619560AB;
	Wed, 16 Sep 2026 14:47:36 +0000 (UTC)
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
Subject: [PATCH v9 02/26] target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
Date: Wed, 16 Sep 2026 16:45:25 +0200
Message-ID: <20260916144721.751810-3-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: VvkvhYrAqJq9r5Reicu9fqfDEWjedZt-6VFvkbvD_ow_1789570062
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Sort by register name alphabetical order. This will allow to
easily diff with the future content, automatically generated.

No functional change intended.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Reviewed-by: Khushit Shah <khushit.shah@nutanix.com>

---
v5 -> v6:
- v5 version conflicted because ID_AA64FPFR0_EL1 has been
  added

v4 -> v5:
- remove spurious CCSIDR definition
---
 target/arm/cpu-sysregs.h.inc | 44 ++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index 6e8b335b8f..ec5a12b0f4 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,13 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
-DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
-DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
-DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
-DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
-DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
-DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
-DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
+DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
+DEF(CTR_EL0, 3, 3, 0, 0, 1)
+DEF(DCZID_EL0, 3, 3, 0, 0, 7)
 DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
 DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
+DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
+DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
+DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
 DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
 DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
 DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
@@ -17,29 +16,30 @@ DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
 DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
 DEF(ID_AA64MMFR3_EL1, 3, 0, 0, 7, 3)
 DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)
-DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
-DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
-DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
+DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
+DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
+DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
+DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
+DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
 DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
-DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
-DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
-DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
-DEF(ID_MMFR3_EL1, 3, 0, 0, 1, 7)
+DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
+DEF(ID_DFR1_EL1, 3, 0, 0, 3, 5)
 DEF(ID_ISAR0_EL1, 3, 0, 0, 2, 0)
 DEF(ID_ISAR1_EL1, 3, 0, 0, 2, 1)
 DEF(ID_ISAR2_EL1, 3, 0, 0, 2, 2)
 DEF(ID_ISAR3_EL1, 3, 0, 0, 2, 3)
 DEF(ID_ISAR4_EL1, 3, 0, 0, 2, 4)
 DEF(ID_ISAR5_EL1, 3, 0, 0, 2, 5)
-DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
 DEF(ID_ISAR6_EL1, 3, 0, 0, 2, 7)
+DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
+DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
+DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
+DEF(ID_MMFR3_EL1, 3, 0, 0, 1, 7)
+DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
+DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
+DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
+DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
+DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
 DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
 DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
 DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
-DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
-DEF(ID_DFR1_EL1, 3, 0, 0, 3, 5)
-DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
-DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
-DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
-DEF(CTR_EL0, 3, 3, 0, 0, 1)
-DEF(DCZID_EL0, 3, 3, 0, 0, 7)
-- 
2.53.0

