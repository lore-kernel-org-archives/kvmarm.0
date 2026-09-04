Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4722445AC6;
	Fri,  4 Sep 2026 10:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518138; cv=none; b=m2bGtFaJVclUoUXgBwah4pQMzxpRMc5YT0DqieCXMB8pY9fOQ5f4/MCw5sNZZrFk+4Lox5bNruH/+yLleBpVDByJHgGgbifR5lZZrOCLVicyvPCyg31efqsTgaRwcysyDehZ1j51NtTW6Kekpz86SS6mA/ecehn84mACgfNZfDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518138; c=relaxed/simple;
	bh=ifGW4IhadanzTNkJq0sUWSJNoZHVkSGpNG64Glyf8lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clQfFzUJx6sCHK5z5vt3pHpEEZ1TRSY5GTjQQIg2rSjtLHTdWbweZkSlk0h/LelaKZ2Vr8L3XjSQSQvxzFhR8EUNr74HrJwg0/fAcQIkcKSjYP7+DdfWOZqSzhtbG0NNL6cLs69/G6ADizJV7SfE+6WRp0ow58sUGw4H4h09l+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtwiJQNm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtwiJQNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5E11F00A3D;
	Fri,  4 Sep 2026 10:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518136;
	bh=zdjsjsW7gTao4JGqSdtTZcqDO/daSds2ybCp3eONEAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtwiJQNmBfj5pcFUU1SRjet42Lr3ykAyOTfvl5s/CFq27c/0PRf0StcdZDxH3Jb66
	 oMa/1VFXy+THz5WtX9Pv5+h/lZn1yVb1miLtQLueNchM3UqjnE8VK+Lrp9l8AdqKG8
	 bxVd8V1DQEGLD8bexSfbqdXI6iyLTuIH8wDGSAwK8kwaQ9uKl0OHcZEqWNnogotGfr
	 HkMLklu1eRbRSlU9OD4TNxiqb7nuVI7K4we3NHhhEAXsMr/X0F6r/bG8zokaU052sc
	 nUxUgwa4LAVh8ideLSiv7yVMlmqQKLqib2U2W8a7Yeju2fuk3BXmeyM4Mvo2cuQ5sE
	 3E2H3TV5eC4Sw==
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
Subject: [PATCH v6 6/9] swiotlb: Reject misaligned restricted DMA pools for CoCo guests
Date: Fri,  4 Sep 2026 16:04:49 +0530
Message-ID: <20260904103452.1197239-7-aneesh.kumar@kernel.org>
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
index f8936b03d942..d1bd06be628d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -2037,6 +2037,20 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
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

