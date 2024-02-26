Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E571EB40
	for <kvmarm@lists.linux.dev>; Mon, 26 Feb 2024 11:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708947196; cv=none; b=LROFHATkXZS7X1Irs7KQERZnc8eH9bIDbqGHUfbftkt05xdL1ot5U7STV56Oyzm5fYHRGou5/Uiwa2he/YTjt3EX9v6Hetp2RzChFhH43rmuh0D60JY4D/Hd1LdbXbYEZZ7Bu1yQVLeboDq1HQFMg2w1UVlUHFJp9tSwjmNz7BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708947196; c=relaxed/simple;
	bh=KkQuS/ZWhtzOs8XSYgZZWKKZPnvsyEkbXVF4IhvZo8A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S/PeuClGPlLS8lANzTPgeGYQgqEztCykqp8zMw2tk4EqrzLr4qy8RmlYwr4f1kHpRg3EJvD6tRZQS2Duj2Rn00316Tk4+aDQD2V4owZG+jyPZ5wMBU+08lyNtAnrfj08CIYuN7FtaDqyDbJj8TXhhL2Y89aI+rbhxsnRTaFg6ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A54FDA7;
	Mon, 26 Feb 2024 03:33:52 -0800 (PST)
Received: from e127643.broadband (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5922C3F6C4;
	Mon, 26 Feb 2024 03:33:10 -0800 (PST)
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
	Quentin Perret <qperret@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/8] arm64: KVM: Fix renamed function in comment
Date: Mon, 26 Feb 2024 11:30:29 +0000
Message-Id: <20240226113044.228403-2-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240226113044.228403-1-james.clark@arm.com>
References: <20240226113044.228403-1-james.clark@arm.com>
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
index 9fdcf5484dfe..f0ee75bd6ac3 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -147,7 +147,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
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

