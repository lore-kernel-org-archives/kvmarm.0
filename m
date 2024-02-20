Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2861E62160
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 10:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708423805; cv=none; b=W5W5mP0g1rXWIPO1v4sGr/NbByLmT7JjDNtaLci1EEByS5s0rT7Q4Siq++3Uy93xWiRhwZF8Yq48fKZ3T3Jj2NgtL5orYIZwMQaTTOgIh8HL3xYsc0UI1Zqdj5lNkXSSRTiUNEhmT6zeeCqH3tj7TULouyBxLtJ+2i5JdbM3kqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708423805; c=relaxed/simple;
	bh=/WMFdTur/ftMdu5Fg+u5AWRizeTGYRL+OGHqhgthSgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=if7CauHo7hP6okk6eyI1p6mKjwLPZd3AiCIhfr92SAyRKrdGrBSW6Jo1Trkzcuz10OiN7XWO8km4SYsUwYooRDBXlh52nx7Iwm2cMtkGakTOgQ0APrMhUl+PySvwnIxwsgbV/5WoMBBhDJaPHE1vUmFZc726Kj5LAbs85fcucMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADCBDFEC;
	Tue, 20 Feb 2024 02:10:40 -0800 (PST)
Received: from e127643.broadband (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8897A3F762;
	Tue, 20 Feb 2024 02:09:55 -0800 (PST)
From: James Clark <james.clark@arm.com>
To: coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	acme@kernel.org,
	oliver.upton@linux.dev,
	broonie@kernel.org
Cc: James Clark <james.clark@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/7] arm64: KVM: Fix renamed function in comment
Date: Tue, 20 Feb 2024 10:09:11 +0000
Message-Id: <20240220100924.2761706-2-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240220100924.2761706-1-james.clark@arm.com>
References: <20240220100924.2761706-1-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

finalize_host_mappings() became fix_host_ownership() in
commit 0d16d12eb26e ("KVM: arm64: Fix-up hyp stage-1 refcounts for all
pages mapped at EL2") so update the comment.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bc58d1b515af..11d77aa36173 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -131,7 +131,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	 * can't be donated or shared with another entity.
 	 *
 	 * The ownership transition requires matching changes in the host
-	 * stage-2. This will be done later (see finalize_host_mappings()) once
+	 * stage-2. This will be done later (see fix_host_ownership()) once
 	 * the hyp_vmemmap is addressable.
 	 */
 	prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
-- 
2.34.1

