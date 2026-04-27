Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01803A6400;
	Mon, 27 Apr 2026 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280049; cv=none; b=VbN0o9X1mvW2m2Hho8crYAScdfu6hFaK36lg91SDI3SSjmOz1JSFcq64F1tRCILJHmb9hyjQEfmr2ACtmScUN4QXdZ2jt6tTx7aoUsloqjEQKU8k5DytsYsd/8Tyj3tXwoHYqXrd36cgtLtmHGaBcqHUR2C293GvS+pwwbvsJpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280049; c=relaxed/simple;
	bh=Bo7WyqkDkmCNfV2kNVREL1QfabEb/FOXWjg40u50nEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=df+g65Ro/vbrdPy6HXgR/iS6aJLvCLw5jTngzMlnv0bb9f2xaqr+gI/oBYN0dxd8sG8LvSnnO6CCWH6S9w42hvGxK5g+AQZBnNiOe2kMOuZTUlf8fS+TAbUz9qcBMsXcqx5E5/0bMSq1dWNWYHZMp0DlLsplB/HPrASkXX/Hb8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAoPPgkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAoPPgkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233AAC19425;
	Mon, 27 Apr 2026 08:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280049;
	bh=Bo7WyqkDkmCNfV2kNVREL1QfabEb/FOXWjg40u50nEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAoPPgkhwpgN1Eg4Z1cqoyhOog3uD8niofmCtPhbELIDud647rXoZjo5QB+ihkZA/
	 zUYjwTfj/hBQ5aZnlWrgVIWRBiGYc2PHXFZdFxQ+vkRUaASfjXW2lyLBdb08LBCjBq
	 Q+nZccSEmUCeAu76CJR462hTAwxBO8i0ZGMIj1XlvmfA5Vf0FtWpQbBUrp9TFrHrFC
	 1MBpKKoiu+GCC39QmraCM4PT7f6nfGawbelRaquNJoOGVNz2ZHX2JC98LcHTRh350k
	 GKZ1F0G5SoagHIioNTF3c/OdoJpAsqm/joUxGUJKchN1TgcPRi2sHCQX99PursRBoe
	 Az4YHikYFWg6g==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 02/16] iommu/arm-smmu-v3: Save the programmed MSI message in msi_desc
Date: Mon, 27 Apr 2026 14:23:30 +0530
Message-ID: <20260427085344.941627-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cache the MSI message in desc->msg from arm_smmu_write_msi_msg(). The
realm support code later reads the MSI address and data through
irq_get_msi_desc(), so it needs the descriptor to reflect the last
programmed message.

This matches the caching done by __pci_write_msi_msg().

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d5b9ab95beea..17fd99887aab 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4012,6 +4012,9 @@ static void arm_smmu_write_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
 	if (smmu->features & ARM_SMMU_FEAT_PRI)
 		max_config_index = PRIQ_MSI_INDEX;
 
+	/* save the programmed msi message details */
+	desc->msg = *msg;
+
 	/* Don't try to config for Realm interrupts. */
 	if (desc->msi_index > max_config_index)
 		return;
-- 
2.43.0

