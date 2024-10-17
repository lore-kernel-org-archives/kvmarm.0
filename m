Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE0E1DE8B2;
	Thu, 17 Oct 2024 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170915; cv=none; b=mNUhHwzgm7UsQrMAvxojkEaGq7XdWIfpTZIaJysxFmUnn9m41PFCsO9Ij3A4tlY58tRbMfgSKgV8K5evJ5iiOjpyJlINSGZf4GQTHjajWhDmvav/rTvjNd0t2ljXehKugr/EQ5mTbVkiWHUyNpZ4IG8ye4n2x1pbLUg9KBjnr0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170915; c=relaxed/simple;
	bh=t5I3iUHobSE1SI4nN11vGqGPdsKJnhAaIhIVN96Ss/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t4jaeFFlBHsoPE4DbXRPdynYllyfZg5U3L9/nojc3MIj+zrtwcsE8Ji2kpjDxCQWcvr/NSRKHKAPgNuQ7x+VB/Pa1t5el+i6FOo8NKuCCwyyDpGWm5JQLtxYE/m4FX/p+ilgEaxwBL+2GGvf1ELN8aXwLCv5PI4ckmOqF45hJGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9145FFEC;
	Thu, 17 Oct 2024 06:15:41 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 163C93F71E;
	Thu, 17 Oct 2024 06:15:07 -0700 (PDT)
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
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v7 06/11] efi: arm64: Map Device with Prot Shared
Date: Thu, 17 Oct 2024 14:14:29 +0100
Message-Id: <20241017131434.40935-7-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Device mappings need to be emulated by the VMM so must be mapped shared
with the host.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v4:
 * Reworked to use arm64_is_iomem_private() to decide whether the memory
   needs to be decrypted or not.
---
 arch/arm64/kernel/efi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 712718aed5dd..1d25d8899dbf 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -34,8 +34,16 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 	u64 attr = md->attribute;
 	u32 type = md->type;
 
-	if (type == EFI_MEMORY_MAPPED_IO)
-		return PROT_DEVICE_nGnRE;
+	if (type == EFI_MEMORY_MAPPED_IO) {
+		pgprot_t prot = __pgprot(PROT_DEVICE_nGnRE);
+
+		if (arm64_is_protected_mmio(md->phys_addr,
+					    md->num_pages << EFI_PAGE_SHIFT))
+			prot = pgprot_encrypted(prot);
+		else
+			prot = pgprot_decrypted(prot);
+		return pgprot_val(prot);
+	}
 
 	if (region_is_misaligned(md)) {
 		static bool __initdata code_is_misaligned;
-- 
2.34.1

