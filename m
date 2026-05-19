Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8FE40963B
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197385; cv=none; b=hGbnUPHJ5H2M/cMPaVqyTJIwaryV7x/bn4ko+49cjKic/siiBgDSPE7f89PckzjMuI4m04P7aMnH/Czmxt5+R81910aSaHrEsdJ09wGufw7ioAC3OY7KfkzmFwRDZeUiel6txDjKxiIfQSWJB3dngdYHJPs1a0pEOiBU5wQFA+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197385; c=relaxed/simple;
	bh=PmRu9hIohu8PHWanU9jhqG74Qb0w8/tjwqUVavQvvYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=utmz0982NlOZHAlOugYyTh6ixJ+93AHNXJ9PsHu++5V80d12/dbrYQRwwzc+/kxh4nnuKiwNTGjs0ju9Bs8d3EcE2Rn1QqS2ut7NPVUo0Zl4vLPKa6CRTgTTfgWOrdEP03OtbeKbH4PSaeM5lu4hvP2iECH43/tM6HTpbLkQHfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UiljOXzl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UiljOXzl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZqvUsFvAPzgPcejYvj5MvHW6fgWe11AjRvksKeD8RSQ=;
	b=UiljOXzlRJ/jWtleI1A9rWpvHd2BUKcMnRhBgfxl0jWk0xlKzjxf77D7MFtH/++dekkm+a
	bF6n60tis3I4+2udJXQPhDnCEikWjmIjS0uVmAijqxTJ38oQxjasL2EO8kc6Ud7bDxdj2N
	R0gu+pxxp0O8xx3soyS6iSo0UlNEe58=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-JGdXmrxGN_afjkoIgppp1Q-1; Tue,
 19 May 2026 09:29:39 -0400
X-MC-Unique: JGdXmrxGN_afjkoIgppp1Q-1
X-Mimecast-MFC-AGG-ID: JGdXmrxGN_afjkoIgppp1Q_1779197377
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C7641800371;
	Tue, 19 May 2026 13:29:37 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D3868180034E;
	Tue, 19 May 2026 13:29:30 +0000 (UTC)
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
Subject: [PATCH v5 03/18] target/arm/cpu-sysregs.h.inc: Update with automatic generation
Date: Tue, 19 May 2026 15:27:17 +0200
Message-ID: <20260519132905.145643-4-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: eO_dICthO8Z1GuxQYvxsSzFfAfkO87YLDel1GYzqLao_1779197377
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Generated definitions with scripts/update-aarch64-cpu-sysregs-header.py
based on "AARCHMRS containing the JSON files for Arm A-profile
architecture (2026-03)" Registers.json file.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu-sysregs.h.inc | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
index a044596135..2188cd7be0 100644
--- a/target/arm/cpu-sysregs.h.inc
+++ b/target/arm/cpu-sysregs.h.inc
@@ -1,14 +1,25 @@
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
+DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
 DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
 DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
 DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
+DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
 DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
 DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
 DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
@@ -38,6 +49,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
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

