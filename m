Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11242219E8;
	Mon,  6 Jul 2026 06:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317896; cv=none; b=MJ9wpsKG+KcN6FOo1tnl1n468+Z5SrZZk+Lf+qYeMAl7j6uzVgJlLkMlwEKkRw13m4hHtl/EaBc4tzyvxaWoqUZ/qtuAx8CKJwT1B5sqLoK+osrcbsuv6vLesZSBN7D2Ez+uvMv2ElHLoXG+xVJWgUTpeOC02+ADfrROB+yCKdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317896; c=relaxed/simple;
	bh=iZ+S/9LTyfsOPBBzau2MCrsTdSwO0f+hAAmt25eJ+hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPpkA7LgqjQ4/kM5AUoOlVMwK5KztJbFu+fKG0gFeQzQEW+lMI8UIvQP4PpoMCVxr/PpW9YPHCdDlse0DdaEn8EKCdWTQB3MSENXfZsdvYAxb8PHRCBtFQDXUjFX53drvR/hWfy5yY+8xiWvVOBltY8mmwOcid1TcygaFK+mRwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaHBKusR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaHBKusR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553DB1F00A3A;
	Mon,  6 Jul 2026 06:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317894;
	bh=9yCa15UdSNTilz8kPcvrpDVJ1NX5mcsjOV3wxcM11SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oaHBKusRrH3Y2ilylkIH9d0RsAMENchHR7eS8HqrdSQJ52O+CCOzBdV6jZddtpdU8
	 /eKWJF9Jsozfx5NaFN/1VAKLrBbhQCjZ4i9jFQhPVnN646zhGad9YWscawBzYx285L
	 klC1SGv1BXQwomDn9gmR2nU7UgHurqliT+s9EflGjDn9G/YhTCoH240yvV2iH5JSLH
	 bUbM2oCK9GDc2EqY91jDshGRPy42N4eWC2K5FK/iPiq+RV1+hIFDB7sYkEhmYDKKkF
	 wpoPscSuZ8IBXD36GnNnULpR0XH42dTAA1jfuadu27cyxx2KMLNuPV8+ZjQOEp9d4m
	 PmguWNr7Mi7jg==
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
Subject: [PATCH v5 01/10] mm/mem_encrypt: Add helpers for shared-buffer alignment
Date: Mon,  6 Jul 2026 11:34:23 +0530
Message-ID: <20260706060432.1375570-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
References: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
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

