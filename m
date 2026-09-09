Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9967145D933
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 22:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992435; cv=none; b=dcnX2oW9ad+kT9fQR5B1o4ZMoBCuh6qKhDCSoxlJ4BUtfiPfhgz8A7K77ePiS32CKnVfRqe03cx8paXL0ZUbPKMkWkSkNOH0rHhHsOGwlQg7iS/hkupYRxMPuMXVzubJF028hB05Vob+Cp+/LtTpzHRVOFWgCiNvD1efMnezNWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992435; c=relaxed/simple;
	bh=UEnUnQoggEdcy/+YEATXGRzgw6BqC5bdlYacrxhBCr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSFIIBbg7+wUWJY69BMj6pl+wHmFicNEixWpTiz39Z7z6qx04dr9f4zsi+ZBbxgeiQ7pVdJn9EE6zL/kbQyuTJ90evnkNDwsu+oCs/JefkbxTXQ1Za8jV+cITV9MbwFbCuFYn09SoUE60K5bidtvPciJgcZnhvHJxEIkzOmSLq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oIn2j7Id; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oIn2j7Id"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 582AB1576;
	Wed,  9 Sep 2026 15:20:29 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 011F73F7D8;
	Wed,  9 Sep 2026 15:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788992433; bh=UEnUnQoggEdcy/+YEATXGRzgw6BqC5bdlYacrxhBCr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIn2j7IdOAYEu4YtjFv38zRnuv2FsD497t1DbToiochFJYvkWVUe61nY3PGWqAntw
	 cT/jJzZqlHFFusKlxHdg9gtHo80AacV5VSTYitgfNPZ5dkCwlj4N6k5b7pgQRBFBiH
	 rUtzGSSjL0vgigmSfNGVhsJYfHpugZpBqErK+mUY=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v1 1/3] KVM: arm64: nv: Don't advertise FEAT_LPA2 for guest stage-1
Date: Wed,  9 Sep 2026 23:20:13 +0100
Message-ID: <20260909222015.3046432-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909222015.3046432-1-weilin.chang@arm.com>
References: <20260909222015.3046432-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no FEAT_LPA2 support for NV guests as of now, but we missed
limiting it for the non-stage-2 granule size fields (TGRAN4, TGRAN16) in
ID_AA64MMFR0_EL1. Add the sanitisation.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/kvm/nested.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 3c4fc566eafc..1fd98117df23 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1731,6 +1731,19 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		/* Hide CNTPOFF if present */
 		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR0_EL1, ECV, IMP);
 
+		/* NV does not support FEAT_LPA2. */
+		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN4, val) ==
+		    ID_AA64MMFR0_EL1_TGRAN4_52_BIT) {
+			val &= ~ID_AA64MMFR0_EL1_TGRAN4;
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN4, IMP);
+		}
+
+		if (SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN16, val) ==
+		    ID_AA64MMFR0_EL1_TGRAN16_52_BIT) {
+			val &= ~ID_AA64MMFR0_EL1_TGRAN16;
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR0_EL1, TGRAN16, IMP);
+		}
+
 		/* Disallow unsupported S2 page sizes */
 		switch (PAGE_SIZE) {
 		case SZ_64K:
-- 
2.43.0

