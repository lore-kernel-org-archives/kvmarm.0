Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725CC1DED75;
	Thu, 17 Oct 2024 13:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170923; cv=none; b=rqpXnYT+taYLzOqo0A9ubmrktJW/AgQF9uxhudMW7JpgP1e5ahoGdA0FLpPiS+scTyESenttu7JA5P+2xJaYFDruCDrUGs/GX0UuEgpxl97qVbuDQPPl9J3WwVWgx99OuhOdUybUQN9AyAXe30BPyxH4EIoKaanprosAGq1wh5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170923; c=relaxed/simple;
	bh=BAwPOAmOIzEQJ4SLugo9T4c57oNNMmBoAWU3VeT+tA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YxKHEU7+rG3cFa86CpyqN5YUlbYdJ2LB/skXJPaTeRjheVzkI4E96N/M4XAi92RkoejyyKl5GrT2+UaGBvR5loYBRUlOVPA8/AYyprS76HyPagHP+pOQIrj4aPu702OFQHM5o2v7Cqq+3u0Utb7xls+S5znVL6P6mI3f71yPmRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8814D1570;
	Thu, 17 Oct 2024 06:15:49 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44C813F71E;
	Thu, 17 Oct 2024 06:15:16 -0700 (PDT)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 08/11] arm64: mm: Avoid TLBI when marking pages as valid
Date: Thu, 17 Oct 2024 14:14:31 +0100
Message-Id: <20241017131434.40935-9-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241017131434.40935-1-steven.price@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When __change_memory_common() is purely setting the valid bit on a PTE
(e.g. via the set_memory_valid() call) there is no need for a TLBI as
either the entry isn't changing (the valid bit was already set) or the
entry was invalid and so should not have been cached in the TLB.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
v4: New patch
---
 arch/arm64/mm/pageattr.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 0e270a1c51e6..547a9e0b46c2 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -60,7 +60,13 @@ static int __change_memory_common(unsigned long start, unsigned long size,
 	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
 					&data);
 
-	flush_tlb_kernel_range(start, start + size);
+	/*
+	 * If the memory is being made valid without changing any other bits
+	 * then a TLBI isn't required as a non-valid entry cannot be cached in
+	 * the TLB.
+	 */
+	if (pgprot_val(set_mask) != PTE_VALID || pgprot_val(clear_mask))
+		flush_tlb_kernel_range(start, start + size);
 	return ret;
 }
 
-- 
2.34.1

