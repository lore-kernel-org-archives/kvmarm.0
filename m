Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6159F44C678;
	Fri,  4 Sep 2026 10:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518109; cv=none; b=BVntT64bf8AZUaSwVU7h77SKOI1nMAyZFl9jvu0dvq6NS22Xxg235mqNDqPjJwfFqjIzBNR4ewLYb4OxEuDO45fKZ41MZj6G/WfYCvkm3xXnD3jZ5iR0++b2N7HlqorpMSWkUn+4u/d+Txyce6JvojpyMs6+PUEH9c6xuDu88hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518109; c=relaxed/simple;
	bh=iZ+S/9LTyfsOPBBzau2MCrsTdSwO0f+hAAmt25eJ+hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/xcz7bc/QZdi++erKC6ck3RMA+h6ip3W3RGInBDHIWwSkyIgn7wNdBCOkLq91TRfVZGyym3gmywme0HN3aU7i8kWwjS/uKrCeVHtoyKmWFvFTxCtoV9gw2vABrxpS7i13Ttd1JWDtxJ6g1C3gj55S5tj8q+qMAdZpX75akqJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n94gtNfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n94gtNfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D771F00A3E;
	Fri,  4 Sep 2026 10:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518107;
	bh=9yCa15UdSNTilz8kPcvrpDVJ1NX5mcsjOV3wxcM11SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n94gtNfOXVpib0FqSMswq4TJBhowKoamIh5esJxUMOLzRML4Wqd1va+BRLyrw3z2E
	 U7iZ7+4+mSvkdsg+XUxTcqYqdrv0DrxyDD1z/DaqmpozjfuLGwzmO25MIPzaKQ2GRv
	 K1S6acdrKeUdBr8WovRoqksDi1FhGnIexXoMkND7W6o2/sltKmjYduLX2V8kOl3WMU
	 XS3xEmJxv40hNvlY0ZXuyS3nu8mJtmiPFWvXgv5xcFI8LcNjHfW4sfPUCWKlFdg0un
	 1jyXlYdDI+RIIEOfvHVrW+Wt3/mP2rJ2W3bqQ7nu9NaWkuCigAD/tYQW7+B6PvjVpz
	 nE/SJ2oK8+Kcg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v6 1/9] mm/mem_encrypt: Add helpers for shared-buffer alignment
Date: Fri,  4 Sep 2026 16:04:44 +0530
Message-ID: <20260904103452.1197239-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

confidential-computing guests may require shared buffers with alignment
larger than the guest page size. As these buffers are shared with the host,
which may manage shared/private state at a different page-size granularity,
the required alignment must account for the host's page size as well.

Add helpers for querying the shared-buffer granule size and for rounding
sizes up to that granule. The generic implementation defaults to PAGE_SIZE
so that existing architectures keep their current behaviour unless they
override the granule size.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/mem_encrypt.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
index 07584c5e36fb..5d2a868f8d3d 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -11,6 +11,8 @@
 #define __MEM_ENCRYPT_H__
 
 #ifndef __ASSEMBLY__
+#include <linux/align.h>
+#include <vdso/page.h>
 
 #ifdef CONFIG_ARCH_HAS_MEM_ENCRYPT
 
@@ -54,6 +56,18 @@
 #define dma_addr_canonical(x)		(x)
 #endif
 
+#ifndef mem_cc_shared_granule_size
+static inline size_t mem_cc_shared_granule_size(void)
+{
+	return PAGE_SIZE;
+}
+#endif
+
+static inline size_t mem_cc_align_to_shared_granule(size_t size)
+{
+	return ALIGN(size, mem_cc_shared_granule_size());
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __MEM_ENCRYPT_H__ */
-- 
2.43.0

