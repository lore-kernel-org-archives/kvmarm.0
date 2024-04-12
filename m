Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF58D53E01;
	Fri, 12 Apr 2024 08:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911355; cv=none; b=G0OiqFI+wHNFmOEQ74B+3DDRqefqP68qcUHIOAMKvsaOMqq1fE9Vr0FDncmI0aB48W/OKZt/X+naebQjStbhzduwjECkZN1ejZDFycgNZKi/HOcyWfs4GfiziHMHti6ce7ZePPv6NU9S7MZ9Ni4tIXeVRD4s3EWXWr+ocVwyhNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911355; c=relaxed/simple;
	bh=C30FIBDNOKB2NdwcI7wHovadNEvWIc5qcaCjjIynEgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nolOKboa76jVmuOVJtTJLFDe9LpbLjpIegafiAiMh013y7kQGjixlNiN6FXqZ6/tClHJT32HGEsIw1HiVDpAlioy7Hb0DmpEqaZS5paSZXVW7Edvj0GVgRIcJdAzS++F5ZsXBWIpkHinY5W12u63HQG3AIuDmRUZea0b5nse6sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C211D339;
	Fri, 12 Apr 2024 01:43:02 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A70E3F6C4;
	Fri, 12 Apr 2024 01:42:31 -0700 (PDT)
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
Subject: [PATCH v2 05/14] fixmap: Allow architecture overriding set_fixmap_io
Date: Fri, 12 Apr 2024 09:42:04 +0100
Message-Id: <20240412084213.1733764-6-steven.price@arm.com>
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

For a realm guest it will be necessary to ensure IO mappings are shared
so that the VMM can emulate the device. The following patch will provide
an implementation of set_fixmap_io for arm64 setting the shared bit (if
in a realm).

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 include/asm-generic/fixmap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
index 8cc7b09c1bc7..c5ce0368c1ee 100644
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
 
 #define set_fixmap_offset_io(idx, phys) \
 	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_IO)
-- 
2.34.1

