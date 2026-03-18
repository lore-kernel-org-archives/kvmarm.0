Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBD726158B;
	Wed, 18 Mar 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849301; cv=none; b=YftmF87cgS4XZFX83aKqzYqneuxA2x29qMk4h1g5LQfskdk76dTXl8g7QokSMzBcfTo06J6KQAwN/HsCwZmT202C943iyMHC4cD76EGvsslgrf7NonNYjT9r+QPqimpkSWP9Izav3TD420LcC/e7Q1gdmswc5VKDvAubFM/qs60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849301; c=relaxed/simple;
	bh=/ioKEmdEMjgsjCaeDYeWkBQVD3DtELc+u+if79p20oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4OiTVNC5WucWTUySuNrYHJSvbnXWDg08SbvTTvoKzmm6f1Sjw9carFBnmCrnU1YRJZDCPtTv+60EDWpoyCuaB6vbrvN7C72vBZJMKHaQsyOopfngMNKTHe5wrASNPgntvhwqhUlAbMi9nF0Wu3lQ2q0MzfxvjX8upTNC6hJfKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4514F201B;
	Wed, 18 Mar 2026 08:54:52 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB9CF3F73B;
	Wed, 18 Mar 2026 08:54:54 -0700 (PDT)
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
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 09/48] arm64: RMI: Check for LPA2 support
Date: Wed, 18 Mar 2026 15:53:33 +0000
Message-ID: <20260318155413.793430-10-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
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
New patch for v13
---
 arch/arm64/kvm/rmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 482dc542451a..9590dff9a2c1 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -5,12 +5,18 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_pgtable.h>
 #include <asm/rmi_cmds.h>
 #include <asm/virt.h>
 
 static unsigned long rmm_feat_reg0;
 static unsigned long rmm_feat_reg1;
 
+static bool rmi_has_feature(unsigned long feature)
+{
+	return !!u64_get_bits(rmm_feat_reg0, feature);
+}
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
@@ -89,6 +95,16 @@ static int rmi_configure(void)
 	return 0;
 }
 
+static int rmm_check_features(void)
+{
+	if (kvm_lpa2_is_enabled() && !rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
+		kvm_err("RMM doesn't support LPA2");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 void kvm_init_rmi(void)
 {
 	/* Continue without realm support if we can't agree on a version */
@@ -100,6 +116,8 @@ void kvm_init_rmi(void)
 	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
 		return;
 
+	if (rmm_check_features())
+		return;
 	if (rmi_configure())
 		return;
 
-- 
2.43.0

