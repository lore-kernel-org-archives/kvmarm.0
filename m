Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AECA39FD4
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 03:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721274651; cv=none; b=JVLtOdwGO56VZneZWyAu/QnLeACjIvasQywttZHmSgBwwMhhKUfYdwXXdqSS9SyIBei1bE0y5ZIWkTXGtrSk8oAMajJCAxG9X3aXABnXdQ5zTxy0fHIdzQQqGKbg9XQgqZDpX8k53Sr/X7DqgESOsfdTI6zOag6lN11FFfpCXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721274651; c=relaxed/simple;
	bh=e4wHAEZ3gagNaF1ZTKR2PF0U+lOxhIlDMDnEfAyzfco=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EUzJrjVZxiePlCGNNyg56mxLrFYeXfOuihLjmon8nAPoJekAYoWmUDz3GBJTs0h3DpRz6xMuzXxjwZJ0WoFgw4J2OZAg3Cdg7GEoEiC1vQGvd1MmAe6Ab2Bvpam5gE6jX5Z7BXjMCIhtL7v8S1/Ii+JhRxm7ePvT3nKwHlhG3p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZazkU3af; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZazkU3af"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721274649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wjT3SEZS1W43M1g2/yseY+4hWHaf3PnARkfq8XIFt8I=;
	b=ZazkU3af4raxQTpToet42vNybW0XZ53z3jRJu48zYK7P6ep4oFsu3f70/b1Evv0oKe2Ovm
	5n/4aClDi3Pw+G0yYIxd2dSLcq/eGnA+3W2NEdPDpalEc1TFZoEfL4LDKhJTmn3vkfoW5G
	tSNBOXk16+7P7msiQutoUTG+eis/r3M=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-BxcHjxmrNWiESzlrFWPI3A-1; Wed,
 17 Jul 2024 23:50:44 -0400
X-MC-Unique: BxcHjxmrNWiESzlrFWPI3A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3C1819560A2;
	Thu, 18 Jul 2024 03:50:41 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D7621955D42;
	Thu, 18 Jul 2024 03:50:38 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1
Date: Wed, 17 Jul 2024 23:50:16 -0400
Message-Id: <20240718035017.434996-4-shahuang@redhat.com>
In-Reply-To: <20240718035017.434996-1-shahuang@redhat.com>
References: <20240718035017.434996-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add writable test for the ID_AA64PFR1_EL1 register.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index a7de39fa2a0a..836dfb17d322 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -133,6 +133,22 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 	REG_FTR_END,
 };
 
+static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, PFAR, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, MTEX, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, THE, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, GCS, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, MTE_frac, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, NMI, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, RNDR_trap, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SME, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),
+	REG_FTR_END,
+};
+
 static const struct reg_ftr_bits ftr_id_aa64mmfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, ECV, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_EL1, EXS, 0),
@@ -199,6 +215,7 @@ static struct test_feature_reg test_regs[] = {
 	TEST_REG(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1_el1),
 	TEST_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2_el1),
 	TEST_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0_el1),
+	TEST_REG(SYS_ID_AA64PFR1_EL1, ftr_id_aa64pfr1_el1),
 	TEST_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0_el1),
 	TEST_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1_el1),
 	TEST_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2_el1),
@@ -551,9 +568,9 @@ int main(void)
 	test_cnt = ARRAY_SIZE(ftr_id_aa64dfr0_el1) + ARRAY_SIZE(ftr_id_dfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64isar0_el1) + ARRAY_SIZE(ftr_id_aa64isar1_el1) +
 		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
-		   ARRAY_SIZE(ftr_id_aa64mmfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) +
-		   ARRAY_SIZE(ftr_id_aa64mmfr2_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
-		   ARRAY_SIZE(test_regs) + 2;
+		   ARRAY_SIZE(ftr_id_aa64pfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr0_el1) +
+		   ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr2_el1) +
+		   ARRAY_SIZE(ftr_id_aa64zfr0_el1) - ARRAY_SIZE(test_regs) + 2;
 
 	ksft_set_plan(test_cnt);
 
-- 
2.40.1

