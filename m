Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E85121BB14;
	Fri,  4 Oct 2024 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728053023; cv=none; b=kiQeGHhXhJNa4nj66yzczcbA6JL2JYGuu+3llC0kYivHA5zKWE21rPajtdSjjfiBPRk6UzkVi0efOrYcklwY/JyRxCnoVlBWRIFom29bZKnpHe5yK+Pt3utgsbGcMKGSUMXHeBCkyUoi/aKPNPCzqxOctd334LyCW0STChYqjw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728053023; c=relaxed/simple;
	bh=m3/FSGzHIG3x/uAMlAm0inEDdKo/0vzrDx5FTjqT2G8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AHNwql+AhRYha+Q+T5b/RRNwbS/wbQLwZePeSvh5NyXkgt8k5UKTqD3E6PPqO8aX4PekThqrJ9jPOG3GEi7yJxMhFHQRH5EVQMIAniasnOIxzkmul+3ouq78X3WD3xJ29uE0II+UG3EhuSPbwHC5c4I6EQ6+c9K+Q8T+coQOm4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32875339;
	Fri,  4 Oct 2024 07:44:10 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10F7C3F58B;
	Fri,  4 Oct 2024 07:43:35 -0700 (PDT)
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
Subject: [PATCH v6 03/11] arm64: realm: Query IPA size from the RMM
Date: Fri,  4 Oct 2024 15:42:58 +0100
Message-Id: <20241004144307.66199-4-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241004144307.66199-1-steven.price@arm.com>
References: <20241004144307.66199-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The top bit of the configured IPA size is used as an attribute to
control whether the address is protected or shared. Query the
configuration from the RMM to assertain which bit this is.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v4:
 * Make PROT_NS_SHARED check is_realm_world() to reduce impact on
   non-CCA systems.
Changes since v2:
 * Drop unneeded extra brackets from PROT_NS_SHARED.
 * Drop the explicit alignment from 'config' as struct realm_config now
   specifies the alignment.
---
 arch/arm64/include/asm/pgtable-prot.h | 4 ++++
 arch/arm64/include/asm/rsi.h          | 2 +-
 arch/arm64/kernel/rsi.c               | 8 ++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 2a11d0c10760..820a3b06f08c 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -68,8 +68,12 @@
 
 #include <asm/cpufeature.h>
 #include <asm/pgtable-types.h>
+#include <asm/rsi.h>
 
 extern bool arm64_use_ng_mappings;
+extern unsigned long prot_ns_shared;
+
+#define PROT_NS_SHARED		(is_realm_world() ? prot_ns_shared : 0)
 
 #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
 #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
index e4c01796c618..acba065eb00e 100644
--- a/arch/arm64/include/asm/rsi.h
+++ b/arch/arm64/include/asm/rsi.h
@@ -27,7 +27,7 @@ static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
 
 	while (start != end) {
 		ret = rsi_set_addr_range_state(start, end, state, flags, &top);
-		if (WARN_ON(ret || top < start || top > end))
+		if (ret || top < start || top > end)
 			return -EINVAL;
 		start = top;
 	}
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 9bf757b4b00c..a6495a64d9bb 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -8,6 +8,11 @@
 #include <linux/psci.h>
 #include <asm/rsi.h>
 
+struct realm_config config;
+
+unsigned long prot_ns_shared;
+EXPORT_SYMBOL(prot_ns_shared);
+
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
@@ -67,6 +72,9 @@ void __init arm64_rsi_init(void)
 		return;
 	if (!rsi_version_matches())
 		return;
+	if (WARN_ON(rsi_get_realm_config(&config)))
+		return;
+	prot_ns_shared = BIT(config.ipa_bits - 1);
 
 	arm64_rsi_setup_memory();
 
-- 
2.34.1

