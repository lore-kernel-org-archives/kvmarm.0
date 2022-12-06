Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7648485
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 14:00:25 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8E95D6E;
	Tue,  6 Dec 2022 06:00:31 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 706813F73D;
	Tue,  6 Dec 2022 06:00:23 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 12/12] KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
Date: Tue,  6 Dec 2022 13:59:30 +0000
Message-ID: <20221206135930.3277585-13-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206135930.3277585-1-ryan.roberts@arm.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221206135930.SMMvbU7qJII0o3C5BdIADyHv0TSXHa2zFcjATt24zng@z>

With all the page-table infrastructure in place, we can finally increase
the maximum permisable IPA size to 52-bits on 4KB and 16KB page systems
that have FEAT_LPA2.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/reset.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ae18472205a..548756c3f43c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -118,7 +118,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		kfree(buf);
 		return ret;
 	}
-	
+
 	vcpu->arch.sve_state = buf;
 	vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
 	return 0;
@@ -361,12 +361,11 @@ int kvm_set_ipa_limit(void)
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
+	if (!kvm_supports_stage2_lpa2(mmfr0) && PAGE_SIZE != SZ_64K)
 		parange = min(parange, (unsigned int)ID_AA64MMFR0_EL1_PARANGE_48);
 
 	/*
-- 
2.25.1

