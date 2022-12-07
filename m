Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E54D8C1A
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 21:48:36 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670449714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+DyLxs3HyIoF5wx9VX+BHFSEjjnbDaZ4BqGRsxySYTU=;
	b=ezeBgIrapc0Yr+sy6EGzPWIC5Jvm36lxzF1ASa6A4Z3hmSRNYzMMaQSam4w8KPu85HkMXB
	fnAOl2c3FSG9VrCYbXt/O0Y1yj0US4HOM9g+eBr1nabRFom+i0iPi0WNhgUHF32YNirkYn
	B1AafIwUyT0gRbFNqHcwh/v+ZOnK/1A=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Peter Gonda <pgonda@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: selftests: Allocate ucall pool from MEM_REGION_DATA
Date: Wed,  7 Dec 2022 21:48:08 +0000
Message-ID: <20221207214809.489070-5-oliver.upton@linux.dev>
In-Reply-To: <20221207214809.489070-1-oliver.upton@linux.dev>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221207214808.tZZt3zE2x4rtgic9Jx6Jsltmt3ZUWgVZUnAvSWUhIxE@z>

MEM_REGION_TEST_DATA is meant to hold data explicitly used by a
selftest, not implicit allocations due to the selftests infrastructure.
Allocate the ucall pool from MEM_REGION_DATA much like the rest of the
selftests library allocations.

Fixes: 426729b2cf2e ("KVM: selftests: Add ucall pool based implementation")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 820ce6c82829..0cc0971ce60e 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -22,7 +22,7 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR);
+	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

