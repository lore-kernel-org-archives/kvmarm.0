Received: from out-191.mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714E7E
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 01:53:31 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool + page_fault_test
Date: Fri,  9 Dec 2022 01:52:59 +0000
Message-ID: <20221209015307.1781352-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Message-ID: <20221209015259.DtK1PPReHhxHugmBrh5LorOQSL14FguKHk-Izxu3g6Y@z>

The combination of the pool-based ucall implementation + page_fault_test
resulted in some 'fun' bugs. As has always been the case, KVM selftests
is a house of cards.

Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
be squashed into Paolo's merge resolution, if desired.

Tested on Ampere Altra and a Skylake box, since there was a decent
amount of munging in architecture-generic code.

v1 -> v2:
 - Collect R-b from Sean (thanks!)
 - Use a common routine for split and contiguous VA spaces, with
   commentary on why arm64 is different since we all get to look at it
   now. (Sean)
 - Don't identity map the ucall MMIO hole
 - Fix an off-by-one issue in the accounting of virtual memory,
   discovered in fighting with #2
 - Fix an infinite loop in ucall_alloc(), discovered fighting with the
   ucall_init() v. kvm_vm_elf_load() ordering issue

Mark Brown (1):
  KVM: selftests: Fix build due to ucall_uninit() removal

Oliver Upton (6):
  KVM: selftests: Setup ucall after loading program into guest memory
  KVM: selftests: Mark correct page as mapped in virt_map()
  KVM: selftests: Correctly initialize the VA space for TTBR0_EL1
  KVM: arm64: selftests: Don't identity map the ucall MMIO hole
  KVM: selftests: Allocate ucall pool from MEM_REGION_DATA
  KVM: selftests: Avoid infinite loop if ucall_alloc() fails

 .../selftests/kvm/aarch64/page_fault_test.c   |  9 +++-
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  6 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 ++++++++++++++++---
 .../testing/selftests/kvm/lib/ucall_common.c  | 14 +++--
 5 files changed, 68 insertions(+), 15 deletions(-)


base-commit: 89b2395859651113375101bb07cd6340b1ba3637
-- 
2.39.0.rc1.256.g54fd8350bd-goog

