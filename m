Received: from out-122.mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37567E
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 01:53:35 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Ricardo Koller <ricarkol@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] KVM: selftests: Fix build due to ucall_uninit() removal
Date: Fri,  9 Dec 2022 01:53:00 +0000
Message-ID: <20221209015307.1781352-2-oliver.upton@linux.dev>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Message-ID: <20221209015300.8EfhZfczlKC_BlZigB9s3X0MAH5XJ9Zj91pls0pI3QU@z>

From: Mark Brown <broonie@kernel.org>

Today's -next fails to build on arm64 due to:

In file included from include/kvm_util.h:11,
                 from aarch64/page_fault_test.c:15:
include/ucall_common.h:36:47: note: expected ‘vm_paddr_t’ {aka ‘long unsigned int’} but argument is of type ‘void *’
   36 | void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
      |                                    ~~~~~~~~~~~^~~~~~~~
aarch64/page_fault_test.c:725:2: warning: implicit declaration of function ‘ucall_uninit’; did you mean ‘ucall_init’? [-Wimplicit-function-declaration]
  725 |  ucall_uninit(vm);
      |  ^~~~~~~~~~~~
      |  ucall_init

which is caused by commit

interacting poorly with commit

   28a65567acb5 ("KVM: selftests: Drop now-unnecessary ucall_uninit()")

As is done for other ucall_uninit() users remove the call in the newly added
page_fault_test.c.

Fixes: 28a65567acb5 ("KVM: selftests: Drop now-unnecessary ucall_uninit()")
Fixes: 35c581015712 ("KVM: selftests: aarch64: Add aarch64/page_fault_test")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Ricardo Koller <ricarkol@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/aarch64/page_fault_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
index 0cda70bef5d5..92d3a91153b6 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -722,7 +722,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	vcpu_run_loop(vm, vcpu, test);
 
-	ucall_uninit(vm);
 	kvm_vm_free(vm);
 	free_uffd(test, pt_uffd, data_uffd);
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

