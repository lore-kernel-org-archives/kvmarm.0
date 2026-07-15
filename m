Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95771383328;
	Wed, 15 Jul 2026 14:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125697; cv=none; b=e90rDgtmi5r3d2t2NNJpkndp9v3hv4caYMZQou3t2gLEasH50cEyINWuN3pXtkQ+KIZuh+J1m763CVI/cW7z2En6Br2ZYuad6/SnOQXBRTi4vOhDRlJ9/hSDAOGHR4QwHA9nHTh1WOhFWMTmF3OfnA676w0FyDF+uX4/+xHed08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125697; c=relaxed/simple;
	bh=9SSl2JWVW8vq8iRnNLAbFtsbXg6+OfUaJ0kt6uFH3uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S69j0Muj0Kem6qp/PfR9pPxJIpmtBvjttO/VRgiQMpPXtQCnXazaJHtqIq4qd03akOt75HucaWrIVmmmV7OnWs+jjP+oxW9a6kCsvZEMGDedkJ8LVlgRcaPiJGFAAJAt1N97OR7kr5I6O7lrljj+DIGdv/1/4xrDnVYipA61QsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eglhRL3v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eglhRL3v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5DF8153B;
	Wed, 15 Jul 2026 07:28:10 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3993E3F7B4;
	Wed, 15 Jul 2026 07:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125694; bh=9SSl2JWVW8vq8iRnNLAbFtsbXg6+OfUaJ0kt6uFH3uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eglhRL3vUU1BB0LEkBPkDMQI9/KkdvZ4mylOK4Hxmd6XOt0UFDWe2S8QgfhkfsquC
	 LFpESjm7PXpELghxjU4/jtOd+Yp6E7kkmYquwYzWY8vcLCh8hoxQRQfcEDgsYc/R6W
	 0nZJkASNrqaKalzbboOaNKPpC29bqTEMfEwS7RGw=
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
Subject: [PATCH 4/6] firmware: arm_rmm: Configure the RMM with the host's page size
Date: Wed, 15 Jul 2026 15:27:35 +0100
Message-ID: <20260715142739.80398-5-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142739.80398-1-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM v2.0 brings the ability to set the RMM's granule size. Check the
feature registers and configure the RMM so that it matches the host's
page size. This means that operations can be done with a granularity
equal to PAGE_SIZE.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v14:
 * Move the implementation into drivers/firmware/arm_rmm.
Changes since v13:
 * Moved out of KVM.
---
 drivers/firmware/arm_rmm/rmi.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index c4850976544f..e7ab4a7df3ca 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -76,6 +76,45 @@ static int rmi_read_features(void)
 	return 0;
 }
 
+static int rmi_configure(void)
+{
+	unsigned long ret;
+	struct rmm_config *config __free(free_page) = (struct rmm_config *)get_zeroed_page(GFP_KERNEL);
+
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
+		BUILD_BUG();
+	}
+
+	/*
+	 * For now we set the tracking_region_size to 0 which is the only option
+	 * for 4KB PAGE_SIZE (1GB for 4KB PAGE_SIZE, 32MB/512MB for 16KB/64KB).
+	 * TODO: Support other tracking sizes via Kconfig option for other
+	 * PAGE_SIZES
+	 */
+	config->tracking_region_size = 0;
+
+	ret = rmi_rmm_config_set(virt_to_phys(config));
+	if (ret) {
+		pr_err("RMM config set failed\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __init arm64_init_rmi(void)
 {
 	int ret;
@@ -89,6 +128,10 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
+	ret = rmi_configure();
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.43.0

