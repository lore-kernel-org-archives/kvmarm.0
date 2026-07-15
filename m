Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9175738AC9A;
	Wed, 15 Jul 2026 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125760; cv=none; b=ZsoIan5ksFfhYJu871syXUt4eLvbQ6EAFUFUzZDfWZVIJ/la7bKv3/XTHjwDD/7oCwHw6eJ0NRWYzoo6DR9KieJj/xKYx6VM1eSxFdYqkSpGR/N1kLr+IxJyJ4elbaVKEptmY6xcm45Me7hqESRTzLAzgkir9Aqe5bp2K8dHdHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125760; c=relaxed/simple;
	bh=nW7/u/8ytSl027az4/gQTrog0UWHJWQHxjfzk2ofIrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkg0uLryUOYkn1idw+ANnjdhoiH2pVZWwty4ILgy0lKIwTOr60+yUvVW4llkNbIWl0sUcR2xLDPfIcR+ewq1jRx/qcJK24eYJN0VNw2MLCOSjYUAYcFs2NUqi4xoGkfTg+RdZfr504GvhlXd9ahGlnDKkB8nJGjyQKUI7i4kwJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=o79Cj0Uh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="o79Cj0Uh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9446B153B;
	Wed, 15 Jul 2026 07:29:13 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF4413F7B4;
	Wed, 15 Jul 2026 07:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125757; bh=nW7/u/8ytSl027az4/gQTrog0UWHJWQHxjfzk2ofIrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o79Cj0UhKUE0ZUJMcVo9NDGCbiXgRWZ+bShrkDmKFuklkECL2mOQMjgsW4Y4akVqT
	 OA++hUC1Enfa80QB53kaSBps6rSWkGJ1KiWEf3HUdRCRaHawGpY25mf5JM950VaSOm
	 XN2g7hgfkJUw5HN2Fkkr4AiXQdr+Pj2btk3V0sds=
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
Subject: [PATCH v15 05/37] KVM: arm64: CCA: Check for LPA2 support
Date: Wed, 15 Jul 2026 15:28:07 +0100
Message-ID: <20260715142841.80544-6-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
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

