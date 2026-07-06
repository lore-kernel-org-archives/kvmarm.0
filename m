Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D7C3BED71;
	Mon,  6 Jul 2026 06:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317931; cv=none; b=cTS5IQcep1is+QikDUHWf81I7aMjTosVBhxhk3Eu+ICy8LPF5YaOD817ryPt/Ai+t1F58j+HInl9fmLnKKbhO80lvhg8/jxcmWfTDyPjy43WwhVi2DNObeRjStpgVAAvZdCv52ObreDGFd4zjOnFlVg9siFasXbX3aCYy7vGEYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317931; c=relaxed/simple;
	bh=msuVWLCHNHW1vdQC7on4XrTXAPjCt498LXK1+AvqECA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PANA0OKAWWo4ZOM9LGPNZxH6O4qDgrsEzU2Hba+tjM74v6mUO86BQ5dqOSSgoT/yMY9kHya0vPmNfSOLGG60c6tGh8GjGFCiAsASQCq4ulS9qzgLNw/AigGGACiaumZeM7TzS6czXW+p0sYEE1FW+tEJbbF9wJaFY6VqsM8Oc2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLdnhD1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLdnhD1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D011F000E9;
	Mon,  6 Jul 2026 06:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317930;
	bh=2mDRZjsUoooCKSx6+cGErtBppIOM6woSiVm/h9NK9rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLdnhD1kG8xgRaq7xeKn+0Jdkzs3dhgyB9D6ZWISaKFEAjULs9ky4Wg1vFAJPeu5Q
	 NG67xdOLMrKAaRb6VOAcys684HHW3a01occrLAafreV+9XqK9iXtg9aoZhuKOLkWkd
	 StTEZtqTz3zGzUFEJnAUgOoG5Ff2scGN5lvUf5zpWNq9OIYYT1wxRKm8cyNrQZjlrn
	 Pi9XVtWAqSSSkhlwyJvd9lnHHRgNP/cAG3ORvmkbghTTPek3BPQ1qqmWCiOHiHiW/Z
	 vZ7gGgp8NkG3rOHWHjPVgKzL+l6slZez3B/WhGSJbztUaKWDwTe1pHNg8U9HOIu3R9
	 YrIQoaI6WI/6w==
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
Subject: [PATCH v5 06/10] swiotlb: Reject misaligned restricted DMA pools for CoCo guests
Date: Mon,  6 Jul 2026 11:34:28 +0530
Message-ID: <20260706060432.1375570-7-aneesh.kumar@kernel.org>
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

Restricted DMA pools are described by firmware reserved-memory nodes and
are not resized or realigned by the kernel. For confidential-computing
guests, such pools can only be shared safely when both the base address and
size are aligned to the shared-granule size.

Reject restricted DMA pools that are not aligned to
mem_cc_shared_granule_size() when guest memory encryption is active.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 1d77746b6f31..ad8a1ccf3977 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -2002,6 +2002,20 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 		 * if platform supports memory encryption,
 		 * restricted mem pool is shared by default
 		 */
+		if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+			size_t cc_shared_granule_size = mem_cc_shared_granule_size();
+
+			if (!IS_ALIGNED(rmem->base, cc_shared_granule_size) ||
+			    !IS_ALIGNED(rmem->size, cc_shared_granule_size)) {
+				dev_err(dev, "Restricted DMA pool must be aligned to %#zx bytes for memory encryption\n",
+					cc_shared_granule_size);
+				kfree(pool->areas);
+				kfree(pool->slots);
+				kfree(mem);
+				return -EINVAL;
+			}
+		}
+
 		if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
 			int ret;
 
-- 
2.43.0

