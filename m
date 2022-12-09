Received: from out-139.mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7505C7E
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 02:01:45 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 5/7] KVM: arm64: selftests: Don't identity map the ucall MMIO hole
Date: Fri,  9 Dec 2022 01:53:04 +0000
Message-ID: <20221209015307.1781352-6-oliver.upton@linux.dev>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221209015304.HrXbzA0EoDTXEEB96Z3-4Frv2ERKgZEb73KuCGIVuXs@z>

Currently the ucall MMIO hole is placed immediately after slot0, which
is a relatively safe address in the PA space. However, it is possible
that the same address has already been used for something else (like the
guest program image) in the VA space. At least in my own testing,
building the vgic_irq test with clang leads to the MMIO hole appearing
underneath gicv3_ops.

Stop identity mapping the MMIO hole and instead find an unused VA to map
to it. Yet another subtle detail of the KVM selftests library is that
virt_pg_map() does not update vm->vpages_mapped. Switch over to
virt_map() instead to guarantee that the chosen VA isn't to something
else.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/lib/aarch64/ucall.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 562c16dfbb00..f212bd8ab93d 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -14,11 +14,13 @@ static vm_vaddr_t *ucall_exit_mmio_addr;
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
-	virt_pg_map(vm, mmio_gpa, mmio_gpa);
+	vm_vaddr_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
+
+	virt_map(vm, mmio_gva, mmio_gpa, 1);
 
 	vm->ucall_mmio_addr = mmio_gpa;
 
-	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gpa);
+	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
 }
 
 void ucall_arch_do_ucall(vm_vaddr_t uc)
-- 
2.39.0.rc1.256.g54fd8350bd-goog

