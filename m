Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A27FBE3
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3F59FEC;
	Mon,  9 Oct 2023 11:51:15 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 806703F5A1;
	Mon,  9 Oct 2023 11:50:33 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v4 10/12] KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
Date: Mon,  9 Oct 2023 19:50:06 +0100
Message-Id: <20231009185008.3803879-11-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009185008.3803879-1-ryan.roberts@arm.com>
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With all the page-table infrastructure in place, we can finally increase
the maximum permisable IPA size to 52-bits on 4KB and 16KB page systems
that have FEAT_LPA2.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/reset.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 7a65a35ee4ac..7816c64d4701 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -316,12 +316,11 @@ int __init kvm_set_ipa_limit(void)
 	parange = cpuid_feature_extract_unsigned_field(mmfr0,
 				ID_AA64MMFR0_EL1_PARANGE_SHIFT);
 	/*
-	 * IPA size beyond 48 bits could not be supported
-	 * on either 4K or 16K page size. Hence let's cap
-	 * it to 48 bits, in case it's reported as larger
-	 * on the system.
+	 * IPA size beyond 48 bits for 4K and 16K page size is only supported
+	 * when LPA2 is available. So if we have LPA2, enable it, else cap to 48
+	 * bits, in case it's reported as larger on the system.
 	 */
-	if (PAGE_SIZE != SZ_64K)
+	if (!system_supports_lpa2() && PAGE_SIZE != SZ_64K)
 		parange = min(parange, (unsigned int)ID_AA64MMFR0_EL1_PARANGE_48);
 
 	/*
-- 
2.25.1

