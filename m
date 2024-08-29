Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CB81849
	for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 00:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724892400; cv=none; b=FIXgco9FK/MTCaOl0zhoQTSEZap9XSkVP//sBCzUop+KT25uyZ/Sv08022c9EiGpInbgzrpW3exkma1KDbDyTqQLNrlzpKuxlxi0IYCTpWWV9YNAjJzH6nh+JByH7xfVmPsqrXcvpO3NJImd6t2W/cRLxiuAed4Gtl6G+FvroHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724892400; c=relaxed/simple;
	bh=z4+RNR72EeIbb4HnbiB0RYLg5WLpjNYiY8Vvs1R22Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgfUsfgmHRlMOjCAncrNBxZc+PLHLoKaI9qZBRIuwp59bMM235T7e7dg1xZF5uSGoYPbnu2XsAku6nGRr2qqTeA01P9LDNCMwF6NGPFd6vFfnfYh5ADJPG6Ao7BJ1RBuc9U+6lZs/VdQLngFLisRORer2p93/y3xiq8Qikthyqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YtpU5ywn; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YtpU5ywn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724892396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N+MlVNE4Fogg6EjlLW7c731gocx3WBQa/S4313NXfqA=;
	b=YtpU5ywnZhy1n5QyWJrDnN/FLAI2bam/UhAp1VET0AYTg0HQrrpHp1J2l9kqJ2PrRVjXRa
	ttDC8b3QHQIqNnLMiCBgoQpn19Zp2ElICV5+Vq4bUKoDXYYlqr/lgJuVdsXmxRx/RamDSV
	/X66rro46nqZV0cGpounYmx6HytsWfU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH] KVM: arm64: selftests: Cope with lack of GICv3 in set_id_regs
Date: Thu, 29 Aug 2024 00:46:22 +0000
Message-ID: <20240829004622.3058639-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Broonie reports that the set_id_regs test is failing as of commit
5cb57a1aff75 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is
presented to the guest"). The test does not anticipate the 'late' ID
register fixup where KVM clobbers the GIC field in absence of GICv3.

While the field technically has FTR_LOWER_SAFE behavior, fix the issue
by setting it to an exact value of 0, matching the effect of the 'late'
fixup.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index d20981663831..2a3fe7914b72 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -126,6 +126,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, CSV2, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, DIT, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, SEL2, 0),
+	REG_FTR_BITS(FTR_EXACT, ID_AA64PFR0_EL1, GIC, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL3, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL2, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, EL1, 0),
-- 
2.46.0.295.g3b9ea8a38a-goog

