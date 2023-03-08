Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB6433E0
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 11:10:25 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D88AE168F;
	Wed,  8 Mar 2023 03:11:02 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C84D3F71A;
	Wed,  8 Mar 2023 03:10:18 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 3/3] KVM: selftests: arm64: Fix ttbr0_el1 encoding for PA bits > 48
Date: Wed,  8 Mar 2023 11:09:48 +0000
Message-Id: <20230308110948.1820163-4-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308110948.1820163-1-ryan.roberts@arm.com>
References: <20230308110948.1820163-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bits [51:48] of the pgd address are stored at bits [5:2] of ttbr0_el1.
page_table_test stores its page tables at the far end of IPA space so
was tripping over this when run on a system that supports FEAT_LPA (or
FEAT_LPA2).

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index c413085d58b7..233357d2f1cc 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -242,7 +242,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
 	struct kvm_vm *vm = vcpu->vm;
-	uint64_t sctlr_el1, tcr_el1;
+	uint64_t sctlr_el1, tcr_el1, ttbr0_el1;
 
 	if (!init)
 		init = &default_init;
@@ -293,10 +293,13 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}
 
+	ttbr0_el1 = vm->pgd & GENMASK(47, vm->page_shift);
+
 	/* Configure output size */
 	switch (vm->mode) {
 	case VM_MODE_P52V48_64K:
 		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
+		ttbr0_el1 |= FIELD_GET(GENMASK(51, 48), vm->pgd) << 2;
 		break;
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P48V48_16K:
@@ -326,7 +329,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), vm->pgd);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), ttbr0_el1);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpu->id);
 }
 
-- 
2.25.1

