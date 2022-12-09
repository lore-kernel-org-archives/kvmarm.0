Received: from out-75.mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41B77E4
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 01:59:24 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] KVM: selftests: Setup ucall after loading program into guest memory
Date: Fri,  9 Dec 2022 01:53:01 +0000
Message-ID: <20221209015307.1781352-3-oliver.upton@linux.dev>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221209015301.iLPMJI0t98hDQlQ6eRQ7PvbbVwJya1USsmWvUQsaHU4@z>

The new ucall infrastructure needs to update a couple of guest globals
to pass through the ucall MMIO addr and pool of ucall structs. A
precondition of writing to the guest's program image is to have it
already loaded into guest memory.

Call ucall_init() after kvm_vm_elf_load(). Continue to park the ucall
MMIO addr after MEM_REGION_TEST_DATA.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 92d3a91153b6..95d22cfb7b41 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -609,8 +609,13 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 				    data_size / guest_page_size,
 				    p->test_desc->data_memslot_flags);
 	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
+}
+
+static void setup_ucall(struct kvm_vm *vm)
+{
+	struct userspace_mem_region *region = vm_get_mem_region(vm, MEM_REGION_TEST_DATA);
 
-	ucall_init(vm, data_gpa + data_size);
+	ucall_init(vm, region->region.guest_phys_addr + region->region.memory_size);
 }
 
 static void setup_default_handlers(struct test_desc *test)
@@ -702,6 +707,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = ____vm_create(mode);
 	setup_memslots(vm, p);
 	kvm_vm_elf_load(vm, program_invocation_name);
+	setup_ucall(vm);
 	vcpu = vm_vcpu_add(vm, 0, guest_code);
 
 	setup_gva_maps(vm);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

