Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4553A3E9296;
	Wed, 18 Mar 2026 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849299; cv=none; b=siFB+9+wcEVGopT+knNEYgtmIeRv35L+0E7SXtn/lerZBu5nuq+JAlHOj97nw8RTDjxQsMEMwqUZHuMUabklXUUFsvGMuvgkrbQkI2SVNEaFVHrNT7L0ipjqQhzK8D4rtCkXjeTNNqFX98YPhcVmiSktdv7WSt2ac/J4wpouQgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849299; c=relaxed/simple;
	bh=+sM2kvR5f3HmncvxqprTrE/uxvQ+IBfjuxiHGqCVUNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvAzMNuaMvgQwIHdmYV+OrtD5Vz82kBadfTw8/NX3hx4Sl7nBc4VS293EFaW3mChvHrY2YAhQw4iQ3XDtZKqJ6TWALpAEnp+yvtMTk5lcWAPjff0sRpOFufkbc6Q6EMc4CXVNn/2VtSvXPCV7OWSm9DRslLRGFTBi4I7LgrI2cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FE311FCD;
	Wed, 18 Mar 2026 08:54:48 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 727FB3F73B;
	Wed, 18 Mar 2026 08:54:51 -0700 (PDT)
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
Subject: [PATCH v13 08/48] arm64: RMI: Configure the RMM with the host's page size
Date: Wed, 18 Mar 2026 15:53:32 +0000
Message-ID: <20260318155413.793430-9-steven.price@arm.com>
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

RMM v2.0 brings the ability to set the RMM's granule size. Read the
feature registers and configure the RMM so that it matches the host's
page size. This means that operations can be done with a granulatity
equal to PAGE_SIZE.

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v13
---
 arch/arm64/kvm/rmi.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index fac151580c01..482dc542451a 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -8,6 +8,9 @@
 #include <asm/rmi_cmds.h>
 #include <asm/virt.h>
 
+static unsigned long rmm_feat_reg0;
+static unsigned long rmm_feat_reg1;
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
@@ -47,11 +50,58 @@ static int rmi_check_version(void)
 	return 0;
 }
 
+static int rmi_configure(void)
+{
+	struct rmm_config *config __free(free_page) = NULL;
+	unsigned long ret;
+
+	config = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
+	if (!config)
+		return -ENOMEM;
+
+	switch (PAGE_SIZE) {
+	case SZ_4K:
+		config->rmi_granule_size = RMI_GRANULE_SIZE_4KB;
+		break;
+	case SZ_16K:
+		config->rmi_granule_size = RMI_GRANULE_SIZE_16KB;
+		break;
+	case SZ_64K:
+		config->rmi_granule_size = RMI_GRANULE_SIZE_64KB;
+		break;
+	default:
+		kvm_err("Unsupported PAGE_SIZE for RMM\n");
+		return -EINVAL;
+	}
+
+	ret = rmi_rmm_config_set(virt_to_phys(config));
+	if (ret) {
+		kvm_err("RMM config set failed\n");
+		return -EINVAL;
+	}
+
+	ret = rmi_rmm_activate();
+	if (ret) {
+		kvm_err("RMM activate failed\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 void kvm_init_rmi(void)
 {
 	/* Continue without realm support if we can't agree on a version */
 	if (rmi_check_version())
 		return;
 
+	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
+		return;
+	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
+		return;
+
+	if (rmi_configure())
+		return;
+
 	/* Future patch will enable static branch kvm_rmi_is_available */
 }
-- 
2.43.0

