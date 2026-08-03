Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5E535C6B7;
	Mon,  3 Aug 2026 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764716; cv=none; b=JeJkWZb4Z2esRit2Qe041fbQ5gDtluWKDOexa1B1Ld9P5at6plmGMr4vpRf0akijywrFqIEsimIcNtsnJRElwDarRXbsTmIy7cNV9DDo+83jz74z/1wFOvMF9/2ivu5p7j8BwRSxrCBWzA/m/GslrX7aWtFE9PKlBWAM9mmWzl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764716; c=relaxed/simple;
	bh=A5swwuKF1sO6Ks2eU21cOmS2+QgmSfc5adtL4WsCNVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6Lz+luUOPeG9PSM+7bJfB/S7ypohGQQrOCK2mfTqtxg47ocWLsLNm7EXjEKLnsibZcr92/3TdhpJI/stevdgU5WlzmUnY3A+NLJtAymP4DdcTdB6CBsJOnolv8a+/iANkuGgU+FGPLsZI5X/5hvoXDEQ9MIoImFpswRv6X/jAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Cz+udvNR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Cz+udvNR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03344143D;
	Mon,  3 Aug 2026 06:45:10 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7D033F66F;
	Mon,  3 Aug 2026 06:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764714; bh=A5swwuKF1sO6Ks2eU21cOmS2+QgmSfc5adtL4WsCNVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cz+udvNRcM1Tk4J/RUkbxEBfr01o+wyepwZMwkWNP6dPU53LYHVSaSaRSIAwEbG8P
	 PD8KzhfmpLeMgjyAuA1bJBBn8kBae7e+GGTDKJMXmkyek873FlOBbB7jF/isgOtgW/
	 wiG9rwtlgwMcOX07xk3G1Ao0AERzyMQR9/Tpsx9U=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 12/45] KVM: arm64: CCA: Check for LPA2 support
Date: Mon,  3 Aug 2026 14:43:28 +0100
Message-ID: <20260803134403.80630-13-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If KVM has enabled LPA2 support then check that the RMM also supports
it. If there is a mismatch then disable support for realm guests as the
VMM may attempt to create a guest which is incompatible with the RMM.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
v15:
 * Extend rmi_has_feature() to take the register number and check the
   presence of SHA-256 support which is default.
v13:
 * New patch
---
 arch/arm64/kvm/rmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 384991d69f78..247c4f033945 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -5,9 +5,31 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_pgtable.h>
 #include <asm/rmi_cmds.h>
 #include <asm/virt.h>
 
+static bool rmi_has_feature(int reg, unsigned long feature)
+{
+	return !!u64_get_bits(rmi_feat_reg(reg), feature);
+}
+
+static int rmm_check_features(void)
+{
+	if (kvm_lpa2_is_enabled() &&
+	    !rmi_has_feature(0, RMI_FEATURE_REGISTER_0_LPA2)) {
+		kvm_err("RMM doesn't support LPA2\n");
+		return -ENXIO;
+	}
+
+	if (!rmi_has_feature(1, RMI_FEATURE_REGISTER_1_HASH_SHA_256)) {
+		kvm_err("RMM doesn't support SHA-256 measurements\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 void kvm_init_rmi(void)
 {
 	/*
@@ -20,5 +42,8 @@ void kvm_init_rmi(void)
 	if (!is_rmi_available())
 		return;
 
+	if (rmm_check_features())
+		return;
+
 	/* Future patch will enable static branch kvm_rmi_is_available */
 }
-- 
2.43.0

