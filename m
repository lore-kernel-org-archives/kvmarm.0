Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E33DEB3A
	for <kvmarm@lists.linux.dev>; Mon,  5 Dec 2022 11:40:55 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40CE123A;
	Mon,  5 Dec 2022 03:40:56 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FAC73F73D;
	Mon,  5 Dec 2022 03:40:48 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1] KVM: arm64: Fix benign bug with incorrect use of VA_BITS.
Date: Mon,  5 Dec 2022 11:40:31 +0000
Message-ID: <20221205114031.3972780-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221205114031.ilYN2kiP4Io3dR4xJmiVvUmjXKdLAQxObXWMsAWYKHI@z>

get_user_mapping_size() uses kvm's pgtable library to walk a user space
page table created by the kernel, and in doing so, fakes up the metadata
that the library needs, including ia_bits, which defines the size of the
input address.

For the case where the kernel is compiled for 52 VA bits but runs on HW
that does not support LVA, it will fall back to 48 VA bits at runtime.
Therefore we must use vabits_actual rather than VA_BITS to get the true
address size.

This is benign in the current code base because the pgtable library only
uses it for error checking.

Fixes: 6011cf68c885 ("KVM: arm64: Walk userspace page tables to compute
the THP mapping size")

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4efb983cff43..1ef0704420d9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -641,7 +641,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 {
 	struct kvm_pgtable pgt = {
 		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
-		.ia_bits	= VA_BITS,
+		.ia_bits	= vabits_actual,
 		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
 				   CONFIG_PGTABLE_LEVELS),
 		.mm_ops		= &kvm_user_mm_ops,
--
2.25.1

