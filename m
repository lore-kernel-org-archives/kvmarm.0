Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2671C13
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 12:10:02 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6141C23A;
	Thu, 27 Oct 2022 05:10:08 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DA863F7B4;
	Thu, 27 Oct 2022 05:10:00 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Steven Price <steven.price@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1] KVM: arm64: Fix bad dereference on MTE-enabled systems.
Date: Thu, 27 Oct 2022 13:09:45 +0100
Message-ID: <20221027120945.29679-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Message-ID: <20221027120945.Z_X1dupRrR7RRWlkcCo_ew3kVatzd-fa0dIWUjV12mA@z>

enter_exception64() performs an MTE check, which involves dereferencing
vcpu->kvm. While vcpu has already been fixed up for hyp va, kvm is still
a kern va pointer.

Fix this by first converting kvm to a hyp va pointer. If the system does
not support MTE, the dereference is avoided in the first place.

Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/hyp/exception.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index b7557b25ed56..791d3de76771 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -13,6 +13,7 @@
 #include <hyp/adjust_pc.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>

 #if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
 #error Hypervisor code only!
@@ -115,7 +116,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);

-	if (kvm_has_mte(vcpu->kvm))
+	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
 		new |= PSR_TCO_BIT;

 	new |= (old & PSR_DIT_BIT);
--
2.17.1

