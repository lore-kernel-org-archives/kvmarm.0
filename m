Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2232F690F;
	Wed, 13 May 2026 13:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678339; cv=none; b=K12+gHDeMs6AhMw1EwDwFfRtMKHYZbV6pe1ZOGKSwC8huurLfaYXjZ3zAaqHRqXVh7eNHwRQNxyQVc1F9usBJAjR3hNoYxan60CSiAGciTHx8TMAHUIiL1sF4R/pNGMDsDVDoaYu7A0EZowBpSucONW/NRYQBMZYda4D0b5/uHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678339; c=relaxed/simple;
	bh=cG+9RtOTQ3thXfd8j6zA3ANwSbmme4UsvVw8z7/71yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQtpLZJva3FRlyv5nVL2UctR/sJNT3kbBqJWQbJx8J9Uxyg8D5HlVNknnr7uGzRTax9BYxQrzv0VPmeV+4WNTiJr/gWPU0s64ZcwXfYaikWBeRzBtf82OTNGwe5EohMRr2o2aIm7g+QL3frYrWndWHZnkg3GAeXiKEEr1z+oDGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HNCsvQpw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HNCsvQpw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A59CD1C14;
	Wed, 13 May 2026 06:18:52 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 109993F836;
	Wed, 13 May 2026 06:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678337; bh=cG+9RtOTQ3thXfd8j6zA3ANwSbmme4UsvVw8z7/71yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNCsvQpwmOkBeoSKcui3hUmxurM7KnUUNQhk6r+G1ltanJroq5edH5Yg/0zSiqp5c
	 lhYqa4B5RJAuxUGLpBQO8NJQTWTA6bGX5PjH1PVjtc/I9Z/QYnztDLYDSHwlRy4K7W
	 yBASKbLEdu+cEmNH4Xeb+HPslXA4tdSNYpgzZqxk=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 07/44] arm64: RMI: Configure the RMM with the host's page size
Date: Wed, 13 May 2026 14:17:15 +0100
Message-ID: <20260513131757.116630-8-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM v2.0 brings the ability to set the RMM's granule size. Check the
feature registers and configure the RMM so that it matches the host's
page size. This means that operations can be done with a granulatity
equal to PAGE_SIZE.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v13:
 * Moved out of KVM.
---
 arch/arm64/kernel/rmi.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
index 99c1ccc35c11..a14ead5dedda 100644
--- a/arch/arm64/kernel/rmi.c
+++ b/arch/arm64/kernel/rmi.c
@@ -49,6 +49,45 @@ static int rmi_check_version(void)
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
+		pr_err("Unsupported PAGE_SIZE for RMM\n");
+		return -EINVAL;
+	}
+
+	ret = rmi_rmm_config_set(virt_to_phys(config));
+	if (ret) {
+		pr_err("RMM config set failed\n");
+		return -EINVAL;
+	}
+
+	ret = rmi_rmm_activate();
+	if (ret) {
+		pr_err("RMM activate failed\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 static int __init arm64_init_rmi(void)
 {
 	/* Continue without realm support if we can't agree on a version */
@@ -60,6 +99,9 @@ static int __init arm64_init_rmi(void)
 	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
 		return 0;
 
+	if (rmi_configure())
+		return 0;
+
 	return 0;
 }
 subsys_initcall(arm64_init_rmi);
-- 
2.43.0

