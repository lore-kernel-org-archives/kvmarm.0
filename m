Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568D024B33
	for <kvmarm@lists.linux.dev>; Thu,  4 Jan 2024 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92291C15;
	Thu,  4 Jan 2024 08:28:30 -0800 (PST)
Received: from e127643.. (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DB3E83F5A1;
	Thu,  4 Jan 2024 08:27:37 -0800 (PST)
From: James Clark <james.clark@arm.com>
To: coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	broonie@kernel.org,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	acme@kernel.org
Cc: James Clark <james.clark@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>,
	Miguel Luis <miguel.luis@oracle.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Helge Deller <deller@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/7] arm64: KVM: Fix renamed function in comment
Date: Thu,  4 Jan 2024 16:27:01 +0000
Message-Id: <20240104162714.1062610-2-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240104162714.1062610-1-james.clark@arm.com>
References: <20240104162714.1062610-1-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

finalise_host_mappings() became fix_host_ownership() in
commit 0d16d12eb26e ("KVM: arm64: Fix-up hyp stage-1 refcounts for all
pages mapped at EL2") so update the comment.

Signed-off-by: James Clark <james.clark@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index cd2f39388251..b5452e58c49a 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -150,7 +150,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
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

