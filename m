Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC26E57303;
	Fri, 12 Apr 2024 08:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911366; cv=none; b=Fw+ESeDcpNHxHoPzFx+JoyY9Y82GC0ZVWut4/B6tLbVI4lIrxsrf9lpY/8mmunXZzL0Bfb5N9WbPJOWYfK/cUVmCsBaHPJal17J68BikbSQBKEOxF37pHNNsnY33PXoWtDXsSF86kEkvS+rvA9OD8FZvawI5JByrdhCWWz/Mrno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911366; c=relaxed/simple;
	bh=a4i9eGCk8PPgeiMR9s+LcLlIOVcdVQnh6asJl8cpm0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vx3vJsm+M6oEbLXRfjpOFJ6sXKEb5ob/u1bhSVNsyA3RVxKEhFCbgbmks6RTkEVZQ3aMcDOSb19IIy8jCHtR09aB3Te7eSaQbnQN4FwfEHxtjmuqpmqxE8qjt70cHQmXiML6lRywNehATN/Zc44R9hh/Hw5G5Cn99GDNX5oG//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7729B113E;
	Fri, 12 Apr 2024 01:43:14 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FD513F6C4;
	Fri, 12 Apr 2024 01:42:43 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 10/14] arm64: Force device mappings to be non-secure shared
Date: Fri, 12 Apr 2024 09:42:09 +0100
Message-Id: <20240412084213.1733764-11-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084213.1733764-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Device mappings (currently) need to be emulated by the VMM so must be
mapped shared with the host.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f5376bd567a1..db71c564ec21 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -598,7 +598,7 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 #define pgprot_writecombine(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
 #define pgprot_device(prot) \
-	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN | PROT_NS_SHARED)
 #define pgprot_tagged(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_TAGGED))
 #define pgprot_mhp	pgprot_tagged
-- 
2.34.1

