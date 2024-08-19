Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7271116C86B;
	Mon, 19 Aug 2024 13:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073617; cv=none; b=UlpA3QmIUrXIM0KkRdU8JYQV7OYIHdpfdgc2oPn/OlCuDem6qJo+N/uwnSJIVFVGkiju5gIKjSNpksCFWKyDlIK3aAl1uuuk73899ihPZCRzb4zPl/PNclrOkQPawCbymSI0YSYsKhUMZoBi8GpizA2iSj/TIYcvd8HTxNbent0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073617; c=relaxed/simple;
	bh=TSPywSLsjMo97jZ+kUql1y4frPVKBelvm4qNdHTkfBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yn6lyXUsvZTBeB4qOVsFobrQbUkUfTZcwxKSuZuYdKPOKphlHol/7dC+5X7eDBWnBPPMo4vAQhjq5JtCspi1VGnNwtB/CfetM6fopJwre2b29r5pTDcFYStsO02CT4zfgByZ9iOhvXNKWQhl8mJCoFDQ+tc/Uk+15Mekxott8MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6F71339;
	Mon, 19 Aug 2024 06:20:41 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43F873F73B;
	Mon, 19 Aug 2024 06:20:12 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>
Subject: [PATCH v5 08/19] fixmap: Allow architecture overriding set_fixmap_io
Date: Mon, 19 Aug 2024 14:19:13 +0100
Message-Id: <20240819131924.372366-9-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240819131924.372366-1-steven.price@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

For a realm guest it will be necessary to ensure IO mappings are shared
so that the VMM can emulate the device. The following patch will provide
an implementation of set_fixmap_io for arm64 setting the shared bit (if
in a realm).

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v5
---
 include/asm-generic/fixmap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
index 29cab7947980..9b75fe2bd8fd 100644
--- a/include/asm-generic/fixmap.h
+++ b/include/asm-generic/fixmap.h
@@ -94,8 +94,10 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 /*
  * Some fixmaps are for IO
  */
+#ifndef set_fixmap_io
 #define set_fixmap_io(idx, phys) \
 	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
+#endif
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_GENERIC_FIXMAP_H */
-- 
2.34.1

